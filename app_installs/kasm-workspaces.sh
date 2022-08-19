#!/usr/bin/env bash

# Sloppy af but it works
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../ && pwd )
"
# something else to try:
#SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"


source $BASE_DIR/common/text-styling.sh
source $BASE_DIR/common/sys-checks.sh

# Check if user is root
super-user-check

# check distro version
dist-check



# Check if system is compatible with this script.. sloppy; assumes up to date versions; TODO: add checks for distro versions
function check-compatible(){
        if { [ "${DISTRO}" == "ubuntu" ] || [ "${DISTRO}" == "debian" ] || [ "${DISTRO}" == "raspbian" ] || [ "${DISTRO}" == "centos" ]; }; then
            echo_note "System is compatible with this script"
        elif [ "${DISTRO}" == "rhel" ] ; then
            echo_warn "Extra scripts are needed to install on RHEL"
            echo_prompt "Do you want to continue? [y/n]"
            until [[ $CONTINUE =~ (y|n) ]]; do
                read -rp "Continue? [y/n]: " -e CONTINUE
            done
            if [[ $CONTINUE == "n" ]]; then
                exit 1
            elif [[ $CONTINUE == "y" ]]; then
                echo_note "Ok, running scripts"
                sleep 1
                install-kasm-rhel
            fi
        else
            echo "Error: ${DISTRO} is not supported."
            exit 1 
        fi
}

check-compatible



# Install the necessary dependencies for the script to run on Red Hat Linux
function install-kasm-rhel(){
if [[ "${DISTRO}" == "rhel" ]]; then
sudo yum install -y yum-utils device-mapper-persistent-data lvm2 openssl wget
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo bash -c "cat > /etc/yum.repos.d/centos-extras.repo" << EOL
[centos-extras]
name=Centos extras - $basearch
baseurl=http://mirror.centos.org/centos/7/extras/x86_64
enabled=1
gpgcheck=1
gpgkey=http://centos.org/keys/RPM-GPG-KEY-CentOS-7
EOL
sudo sed -i 's#\$releasever#7#g' /etc/yum.repos.d/docker-ce.repo
sudo yum install -y docker-ce
sudo systemctl enable --now docker.service
sudo systemctl start docker.service
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -L https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

fi
}


# Installing Kasm Workspace
cd /tmp || exit

curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.11.0.18142e.tar.gz

tar -xf kasm_release*.tar.gz

sudo bash kasm_release/install.sh