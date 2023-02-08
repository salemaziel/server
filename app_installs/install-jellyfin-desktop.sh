#!/bin/bash

version=$(curl --head https://github.com/jellyfin/jellyfin-media-player/releases/latest | tr -d '\r' | grep '^location' | sed 's/.*\/v//g')

echo -e "Downloading version $version of Jellyfin player for desktop\n"
sleep 0.5

cd ~/Downloads || return

wget "https://github.com/jellyfin/jellyfin-media-player/releases/download/v$version/jellyfin-media-player_$version-1_amd64-$(grep VERSION_CODENAME /etc/os-release | cut -d= -f2).deb" -O jellyfinmediaplayer-"${version}".deb

if [ -z $(command -v gdebi) ];then
	sudo apt install ~/Downloads/jellyfinmediaplayer*.deb
elif [ -n $(command -v gdebi) ]; then
	sudo gdebi -n ~/Downloads/jellyfinmediaplayer*.deb
else
	echo -e "something went wrong. quitting"
	sleep 1
	exit 1
fi
