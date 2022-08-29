#!/bin/bash


# Uninstall old versions
uninstall_old_versions() {
  sudo apt-get remove -y docker docker-engine docker.io containerd runc
}


# Install Debian Repos
# https://docs.docker.com/engine/install/debian/
install_debian_repo(){
    uninstall_old_versions
    
    sudo apt-get update
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y ca-certificates curl gnupg lsb-release

    sudo mkdir -p /etc/apt/keyrings && chmod -R 0755 /etc/apt/keyrings

    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    DEBIAN_FRONTEND=noninteractive sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    sudo apt-get install -y dbus-user-session fuse-overlayfs slirp4netns

}


# Install Ubuntu Repos
# https://docs.docker.com/engine/install/ubuntu/
function install_ubuntu_repos(){
    sudo apt-get update
    DEBIAN_FRONTEND=noninteractive sudo apt-get install ca-certificates curl gnupg lsb-release

    sudo mkdir -p /etc/apt/keyrings && chmod -R 0755 /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update
    DEBIAN_FRONTEND=noninteractive sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

    sudo apt-get install -y dbus-user-session overlay2 fuse-overlayfs slirp4netns
}



