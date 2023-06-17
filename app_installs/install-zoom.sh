#!/bin/bash

asroot() {
    if [ "$(grep '^Uid:' /proc/$$/status 2>/dev/null|cut -f2)" = "0" ] || [ "$USER" = "root" ] || [ "$(id -u 2>/dev/null)" = "0" ]; then
        "$@"
    elif [ "$(command -v sudo 2>/dev/null)" ]; then
        sudo "$@"
    else
        echo "Root required"
        su -m root -c "$*"
    fi
}

if command -v curl &> /dev/null; then
	cmd_dl=curl
else
	if command -v wget &> /dev/null; then
		cmd_dl=wget
	else
		echo "Neither curl or wget are installed. Install one of them first"
		exit 1
	fi
fi

if command -v jq &> /dev/null; then
	:
else
	echo "jq isnt installed on this system. install it first"
	exit 1
fi

LATEST_RELEASE=$(curl -s https://zoom.us/rest/download?os=linux | jq '.result.downloadVO.zoom.version' | tr -d \")
echo "Latest version is ${LATEST_RELEASE}"

ZOOM_URL="https://zoom.us/client/${LATEST_RELEASE}/zoom_amd64.deb"

if [ ! -d "$HOME/Downloads" ]; then
	echo "No Downloads folder; creating one..."
	mkdir -p "$HOME/Downloads"
fi

echo "Downloading to $HOME/Downloads folder"
case $cmd_dl in
	curl)
		curl -sSL "${ZOOM_URL}" -o "$HOME/Downloads/zoom_amd64.deb" || { echo "$cmd_dl failed to download"; exit 2; }
		;;
	wget)
		wget -q "${ZOOM_URL}" -O "$HOME/Downloads/zoom_amd64.deb" || { echo "$cmd_dl failed to download"; exit 2; }
		;;
	*)
		echo "Somehow wrong command got set. If you see this theres definitely some kind of error. Exiting"
		exit 3
		;;
esac

echo "Finished downloading, installing zoom now..."
if command -v gdebi &> /dev/null ; then
	asroot gdebi -n "$HOME/Downloads/zoom_amd64.deb"
else
	asroot dpkg -i "$HOME/Downloads/zoom_amd64.deb"
fi

echo "Done!"
