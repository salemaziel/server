#!/bin/bash


DISTRO="$(lsb_release -si)"
DISTRO_ID="$(lsb_release -sc)"


#APT_OVER_TOR="http://apow7mjfryruh65chtdydfmqfpj5btws7nbocgtaovhvezgccyjazpqd.onion"
## REPO for over tor ; everything else the sme
#deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] tor://apow7mjfryruh65chtdydfmqfpj5btws7nbocgtaovhvezgccyjazpqd.onion/torproject.org <DISTRIBUTION> main


if [[ $DISTRO == "debian" || $DISTRO == "ubuntu" || $DISTRO == "pop" || $DISTRO == "raspbian" ]]; then

	ARCH="$(dpkg --print-architecture)"

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



sudo apt install apt-transport-https wget -y

echo "deb [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list
echo "deb-src [arch=$ARCH signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org $DISTRO_ID main" >> /etc/apt/sources.list.d/tor.list

wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null

sudo apt update

sudo apt install -y tor deb.torproject.org-keyring



