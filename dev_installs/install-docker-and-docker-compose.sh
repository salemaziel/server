#!/bin/bash


# Require script to be run as root
function super-user-check() {
  if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script with sudo or as super user."
    exit
  fi
}

# Check for root
super-user-check


function download_docker() {
# Download Docker
curl -fsSL get.docker.com -o get-docker.sh
# Install Docker using the stable channel (instead of the default "edge")
CHANNEL=stable sh get-docker.sh
# Remove Docker install script
}

function download_docker-compose {
# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Make it executable
chmod +x /usr/local/bin/docker-compose
# Install command completion
sudo curl \
    -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
# Source .bashrc so completion becomes active
source $HOME/.bashrc
# Test command and show version
docker-compose --version
}


function install_options() {
    echo "Choose what you want to install?"
    echo "   1) Only Docker"
    echo "   2) Only Docker-Compose"
    echo "   3) Docker AND Docker-Compose"
#    echo "   4) Podman"
#    echo "   5) Option #5"
    until [[ "${USER_OPTIONS}" =~ ^[0-9]+$ ]] && [ "${USER_OPTIONS}" -ge 1 ] && [ "${USER_OPTIONS}" -le 3 ]; do
      read -rp "Select an Option [1-3]: " -e -i 1 USER_OPTIONS
    done
    case ${USER_OPTIONS} in
    1)
      echo "Installing Docker"
      sleep 2
      download_docker
      ;;
    2)
      echo "Installing Docker-Compose"
      sleep 2
      download_docker-compose
      ;;
    3)
      echo "Installing Docker first"
      sleep 2
      download_docker
      
      echo "Now installing Docker-Compose"
      sleep 2
      download_docker-compose      
      ;;
#    4)
#      echo "Wassup foo"
#      ;;
#    5)
#      echo "Wassup foo"
#      ;;
    esac
  }
  
  
install_options
