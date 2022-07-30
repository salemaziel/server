#!/bin/bash




# Require script to be run as root
function super-user-check() {
  if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as super user."
    exit
  fi
}

# Check for root
super-user-check


cd /home/pc/Downloads || exit

rm -rf ./firefox/firefox-*.tar.bz2

mv ./firefox-10*.tar.bz2 ./firefox/

cd ./firefox/ || exit

tar xjf firefox-*.tar.bz2

mv /opt/firefox/ /opt/firefox-old-$(date -I)

mv ./firefox /opt/firefox

chown -R root:optuser /opt/firefox/

command -v firefox


