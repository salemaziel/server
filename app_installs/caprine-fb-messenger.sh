#!/bin/bash

install_caprine() {
echo_info " *** Installing Caprine:FB messenger for Linux *** "
sudo apt install -y curl
cd "$HOME"/Downloads || return
curl -s https://api.github.com/repos/sindresorhus/caprine/releases/latest | grep "browser_download_url.*deb" | cut -d : -f 2,3 | tr -d \" | tail -1 | wget -O caprine.deb -qi -
#sudo gdebi -n caprine.deb
sudo apt -f ./caprine.deb
}