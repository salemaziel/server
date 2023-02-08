#!/bin/bash

DOCKER="$(command -v docker)"

FIREFOX="firefox"
LIBREWOLF="librewolf"


BROWSER="${1:-$FIREFOX}"

if [ -z "$1" ]; then
	BROWSER="$FIREFOX"
fi

if [ -z "$DOCKER" ];then
	echo -e "docker doesnt seem to be installed. Quitting\n"
	sleep 0.5
else
	systemctl status docker | head -n 3 | grep -q running

	if [ "$?" = "0" ]; then
		echo -e "docker is running\n"
	elif [ "$?" = "1" ]; then
		echo -e "docker isn't running. lets fix that\n"
		sleep 0.5
		sudo systemctl start docker.service docker.socker containerd.service
		sleep 0.5
		docker --version
	else
		echo -e "Encounted unknown error. Quitting\n"
		sleep 0.5
		exit 1
	fi
fi


echo -e "Starting Gluetun WG container\n"
sleep 0.5

cd $HOME/docker/gluetun || return
sudo docker-compose up -d

sleep 1

echo -e "Starting $BROWSER connected to gluetun proxy\n"
sleep 0.5

firefox -P default --no-remote --new-instance --browser --new-window https://ipleak.net 

#if [ $(systemctl status docker | head -n 3 | grep -q running) === "0" ]; then
#	echo -e "docker is running\n"
#elif [ $(systemctl status docker | head -n 3 | grep -q running) === "1" ]; then
#	echo -e "docker is probably not running\n"
#fi
