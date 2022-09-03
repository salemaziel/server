#!/bin/bash

set -eu -o pipefail

BASE_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $BASE_DIR || return
cd ../ || return
source ./common/sys-checks

sys-check



REPO_OWNER=binwiederhier
REPO_NAME=ntfy


LATEST_RELEASE_VERSION=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "tag_name" | cut -d : -f 2,3 | tr -d \"v, | awk '{sub(/^[ \t]+/, "")};1')

# Download latest release tar.gz package
#    DOWNLOAD_URL_TAR=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "browser_download_url.*tar.gz" | grep "${ARCH}" | cut -d : -f 2,3 | tr -d \" | awk '{sub(/^[ \t]+/, "")};1')
DOWNLOAD_URL_TAR=https://github.com/"${REPO_OWNER}"/"${REPO_NAME}"/releases/download/v"${LATEST_RELEASE_VERSION}"/"${REPO_NAME}"_"${LATEST_RELEASE_VERSION}"_linux_"$(uname -m)".tar.gz



# Install release binary tar.gz
function install-ntfy-targz(){

        cd /tmp || return
        wget "$DOWNLOAD_URL_TAR"

        tar zxvf ntfy*.tar.gz
        sudo cp -a ntfy_*/ntfy /usr/bin/ntfy

        sudo mkdir /etc/ntfy && sudo cp ntfy_*/{client,server}/*.yml /etc/ntfy

        sudo ntfy serve
}


# Install repo
function install-ntfy-repo(){
    if [[ "${DISTRO}" == "ubuntu" ]] || [[ "${DISTRO}" == "Debian" ]]; then

        curl -sSL https://archive.heckel.io/apt/pubkey.txt | sudo apt-key add -

        sudo apt install apt-transport-https

        sudo sh -c "echo 'deb [arch=amd64] https://archive.heckel.io/apt debian main' > /etc/apt/sources.list.d/archive.heckel.io.list" 

        sudo apt update
        sudo apt install -y ntfy
        
        sudo systemctl enable ntfy
        sudo systemctl start ntfy


    elif [[ "${DISTRO}" == "fedora" ]] || [[ "${DISTRO}" == "centos" ]] || [[ "${DISTRO}" == "rocky" ]] || [[ "${DISTRO}" == "alma" ]] || [[ "${DISTRO}" == "rhel" ]]; then

        sudo rpm -ivh https://github.com/"${REPO_OWNER}"/"${REPO_NAME}"/releases/download/v"${LATEST_RELEASE_VERSION}"/"${REPO_NAME}"_"${LATEST_RELEASE_VERSION}"_linux_"${ARCH}".rpm

        sudo systemctl enable ntfy 
        sudo systemctl start ntfy
    

    else

        echo "Unsupported OS"
        exit 1

    fi
}

# Install from github release
function install-ntfy-standalone-package(){
    LATEST_RELEASE_VERSION=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "tag_name" | cut -d : -f 2,3 | tr -d \"v, | awk '{sub(/^[ \t]+/, "")};1')

    # Download latest release deb package
    DOWNLOAD_URL_DEB=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "browser_download_url.*deb" | grep "${ARCH}" | cut -d : -f 2,3 | tr -d \" | awk '{sub(/^[ \t]+/, "")};1')

    # Download latest release rpm package
    DOWNLOAD_URL_RPM=$(curl -s https://api.github.com/repos/"$REPO_OWNER"/"$REPO_NAME"/releases/latest | grep "browser_download_url.*rpm" | grep "${ARCH}" | cut -d : -f 2,3 | tr -d \" | awk '{sub(/^[ \t]+/, "")};1')



    if [[ "${DISTRO}" == "ubuntu" ]] || [[ "${DISTRO}" == "Debian" ]]; then
        cd /tmp || return
        wget "$DOWNLOAD_URL_DEB"
        if [[ -z $(command -v gdebi) ]]; then
            cmd_install="sudo apt -f install"
        else
            cmd_install="sudo gdebi -n"
        fi

        $cmd_install ntfy*.deb

    elif [[ "${DISTRO}" == "fedora" ]] || [[ "${DISTRO}" == "centos" ]] || [[ "${DISTRO}" == "rocky" ]] || [[ "${DISTRO}" == "alma" ]] || [[ "${DISTRO}" == "rhel" ]]; then

        cd /tmp || return
        wget "$DOWNLOAD_URL_RPM"
    

    else
    
        install-ntfy-targz
    fi
    
}



read -p "Install from release binary (tar.gz), standalone distro package (rpm/deb), or add repo? [rb/dp/r] " install_style

case $install_style in
    rb) 
        echo "Installing from release binary tar.gz"
        install-ntfy-targz
        ;;
    dp) 
        echo "Installing from standalone distro package"
        install-ntfy-standalone-package
        ;;
    r) 
        echo "Installing from repo"
        install-ntfy-repo
        ;;
    *)
        echo "Invalid input"
        exit 1
        ;;
esac


