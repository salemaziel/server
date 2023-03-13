#!/bin/bash



# Utility function for exiting
exitScript()
{
    echo -e "\nPress enter to dismiss this message"
    read
    exit $1
}

# Wrapper function to only use sudo if not already root
sudoIf()
{
    if [ "$(id -u)" -ne 0 ]; then
        sudo $1 $2
    else
        $1 $2
    fi
}

# Utility function that waits for any existing installation operations to complete
# on Debian/Ubuntu based distributions and then calls apt-get
aptSudoIf() 
{
    while sudoIf fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
        echo -ne "(*) Waiting for other package operations to complete.\r"
        sleep 0.2
        echo -ne "(*) Waiting for other package operations to complete..\r"
        sleep 0.2
        echo -ne "(*) Waiting for other package operations to complete...\r"
        sleep 0.2
        echo -ne "\r\033[K"
    done
    sudoIf apt-get "$1"
}


# Check distro id and details
if [ -z /etc/os-release ]; then
	DISTRO="$(lsb_release -si)"
	DISTRO_ID="$(lsb_release -sc)"
	export DISTRO
	export DISTRO_ID
else
	source /etc/os-release
	DISTRO="$ID"
	DISTRO_ID="$VERSION_CODENAME"
	export DISTRO
	export DISTRO_ID
fi


## REPO for over tor ; everything else the sme


if [[ $DISTRO == "debian" || $DISTRO == "ubuntu" || $DISTRO == "pop" || $DISTRO == "raspbian" ]]; then

	ARCH="$(dpkg --print-architecture)"
	export ARCH

	if [[ $ARCH == "amd64" || $ARCH == "arm64" || $ARCH == "i386" ]]; then
		echo -e "Installing Tor repo on $DISTRO $DISTRO_ID $ARCH \n"
		sleep 0.5
	else
		echo -e "Sorry, this script doesn't support this CPU architecture: $ARCH "
		echo -e "Quitting."
		sleep 1
		exit 1
	fi
else
	echo -e "Sorry, this script doesn't support this Distro: $DISTRO "
	echo -e "Quitting."
	exit 1
fi

# Get dependencies to get tor repo signing key for integrity
echo -e "Installing dependencies"
aptSudoIf install apt-transport-https wget -y


# Get tor signing key and import to apt keyring
echo -e "Downloading and importing Tor project repo key with wget and gpg"
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudoIf tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null

echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list
echo "deb-src [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list


# Update apt cache
echo -e "Running apt update"
aptSudoIf update

echo -e "\nDownloading tor and deb.torproject.org-keyring over https configured for apt-transport\n"
sleep 0.5
echo -e "After installing those packages, want to switch Tors apt source list to get updates over Tor network configured for apt-transport?"
echo -e "You can always add or switch these back later"
read -p "Y or y will make change; N or n will continue using apt-transport-https:  "  "apt_method"


aptSudoIf install tor deb.torproject.org-keyring apt-transport-tor -y


case $apt_method in
	Y|y)
	echo -e "Changing apt to use transport over tor"
	sleep 0.5
	echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] tor://apow7mjfryruh65chtdydfmqfpj5btws7nbocgtaovhvezgccyjazpqd.onion/torproject.org $DISTRO_ID main" > /etc/apt/sources.list.d/tor.list
	echo "deb-src [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] tor://apow7mjfryruh65chtdydfmqfpj5btws7nbocgtaovhvezgccyjazpqd.onion/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list
	echo -e "\n" >> /etc/apt/sources.list.d/tor.list 
	echo -e "## Comment the above and uncomment the below to switch apt back to using https" >> /etc/apt/sources.list.d/tor.list
	echo "#deb [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list
	echo "#deb-src [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list
	echo -e "Done."
	;;
	N|n)
	echo -e ""
        echo "#deb [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] tor://apow7mjfryruh65chtdydfmqfpj5btws7nbocgtaovhvezgccyjazpqd.onion/torproject.org $DISTRO_ID main" > /etc/apt/sources.list.d/tor.list
        echo "#deb-src [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] tor://apow7mjfryruh65chtdydfmqfpj5btws7nbocgtaovhvezgccyjazpqd.onion/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list
        echo -e "\n" >> /etc/apt/sources.list.d/tor.list
        echo -e "## Comment the below and uncomment the above to switch apt back to using tor" >> /etc/apt/sources.list.d/tor.list
        echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list
        echo "deb-src [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list
	;;
	*)
	echo -e "Invalid response. Keeping whatever apt config you currently have (probably transport-https) "
	sleep 0.5
	exitScript
	;;
esac


#echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" > /etc/apt/sources.list.d/tor.list echo "deb-src [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" > /etc/apt/sources.list.d/tor.list


