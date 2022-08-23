#!/bin/bash

set -eu -o pipefail

CURRENT_OPENSNITCH_VERSION="$(/usr/bin/opensnitchd -version)"
REPO_OWNER=evilsocket
REPO_NAME=opensnitch

DOWNLOAD_FOLDER=/home/pc/Downloads

source ../common/download-github-release.sh

if [[ -z $(command -v gdebi) ]]; then
    cmd_install="sudo apt -f install"
else
    cmd_install="sudo gdebi -n"
fi

LATEST_RELEASE=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "tag_name" | cut -d : -f 2,3 | tr -d \"v,| tail -1 | awk '{sub(/^[ \t]+/, "")};1')

if [ "$CURRENT_OPENSNITCH_VERSION" == "$LATEST_RELEASE" ]; then
  echo "You already have the latest version of OpenSnitch ($CURRENT_OPENSNITCH_VERSION)"
  exit 0
else

    DOWNLOAD_URL_DAEMON=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | head -1 | awk '{sub(/^[ \t]+/, "")};1' )

    DOWNLOAD_URL_UI=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | tail -1 | sed 's/.PIP//' | awk '{sub(/^[ \t]+/, "")};1' )


    cd "$DOWNLOAD_FOLDER" || return

    if [[ -n "opensnitch*.deb" ]]; then
      rm -rf opensnitch*.deb
    fi
    echo "Downloading OpenSnitch daemon $LATEST_RELEASE"
    wget "$DOWNLOAD_URL_DAEMON"

    echo "Installing OpenSnitch daemon $LATEST_RELEASE"
    $cmd_install opensnitch*.deb

    if [[ -n "python3-opensnitch*.deb" ]]; then
      rm -rf python3-opensnitch*.deb
    fi
    echo "Downloading OpenSnitch UI $LATEST_RELEASE from $DOWNLOAD_URL_UI"
    wget "$DOWNLOAD_URL_UI"

    echo "Installing OpenSnitch UI $LATEST_RELEASE"
    $cmd_install python3-opensnitch*.deb
fi

#DOWNLOAD_URL=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "browser_download_url.*python3-opensnitch-ui*.deb" | cut -d : -f 2,3 | tr -d \" | tail -1 | awk '{sub(/^[ \t]+/, "")};1')


