#!/bin/bash



REPO_OWNER=evilsocket
REPO_NAME=opensnitch


#curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep -e "browser_download_url.*python3.*deb" | cut -d : -f 2,3 | tr -d \" | tail -1 | awk '{sub(/^[ \t]+/, "")};1' | sed 's/.PIP//'

#DOWNLOAD_URL=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | tail -1 | awk '{sub(/^[ \t]+/, "")};1')

DOWNLOAD_URL=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | head -1)

wget $DOWNLOAD_URL