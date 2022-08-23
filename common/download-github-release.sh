#!/bin/bash


check_latest_release_version() {
  curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "tag_name" | cut -d : -f 2,3 | tr -d \",| tail -1 | awk '{sub(/^[ \t]+/, "")};1'
}


download_gh_release() {
REPO_OWNER="$1"
REPO_NAME="$2"

if [ -z "$REPO_OWNER" ] || [ -z "$REPO_NAME" ]; then
#  echo "Usage: $0 <repo_owner> <repo_name>"

  read -p "Repo owner: " REPO_OWNER
  read -p "Repo name: " REPO_NAME
fi




DOWNLOAD_URL=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | tail -1 | awk '{sub(/^[ \t]+/, "")};1')

echo "Downloading $REPO_OWNER $REPO_NAME latest release from $DOWNLOAD_URL"

wget $DOWNLOAD_URL

}