#!/bin/bash

set -eu -o pipefail

## Goal: Script which automatically sets up a new Ubuntu Machine after installation
## This is a basic install, easily configurable to your needs

SCRIPT_DIR="/home/pc/Server"


## Add some color

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

echo_cmd()    { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
echo_prompt() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_note()   { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
echo_info()   { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
echo_warn()   { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_debug()  { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
echo_fail()   { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }



## Require script to be run as root
function super-user-check() {
  if [ "${EUID}" -ne 0 ]; then
    echo_warn "You need to run this script as super user."
    exit
  fi
}


## Detect Operating System
function dist-check() {
  if [ -f /etc/os-release ]; then
    ## shellcheck disable=SC1091
    source /etc/os-release
    DISTRO=${ID}
    DISTRO_VERSION=${VERSION_ID}
  fi
}


### Pre-Checks system requirements
 function installing-system-requirements() {
  if { [ "${DISTRO}" == "ubuntu" ] || [ "${DISTRO}" == "debian" ] || [ "${DISTRO}" == "raspbian" ] || [ "${DISTRO}" == "pop" ] || [ "${DISTRO}" == "kali" ] || [ "${DISTRO}" == "linuxmint" ]; }; then                  #|| [ "${DISTRO}" == "fedora" ] || [ "${DISTRO}" == "centos" ] || [ "${DISTRO}" == "rhel" ] || [ "${DISTRO}" == "arch" ] || [ "${DISTRO}" == "archarm" ] || [ "${DISTRO}" == "manjaro" ] || [ "${DISTRO}" == "alpine" ] || [ "${DISTRO}" == "freebsd" ]; }; then
    if { [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v iptables)" ] || [ ! -x "$(command -v bc)" ] || [ ! -x "$(command -v jq)" ] || [ ! -x "$(command -v cron)" ] || [ ! -x "$(command -v sed)" ] || [ ! -x "$(command -v zip)" ] || [ ! -x "$(command -v unzip)" ] || [ ! -x "$(command -v grep)" ] || [ ! -x "$(command -v awk)" ] || [ ! -x "$(command -v shuf)" ] || [ ! -x "$(command -v openssl)" ] || [ ! -x "$(command -v ntpd)" ] || [ ! -x "$(command -v dialog)" ]; }; then
      if { [ "${DISTRO}" == "ubuntu" ] || [ "${DISTRO}" == "debian" ] || [ "${DISTRO}" == "raspbian" ] || [ "${DISTRO}" == "pop" ] || [ "${DISTRO}" == "kali" ] || [ "${DISTRO}" == "linuxmint" ]; }; then
        apt-get update && apt-get install apt-utils iptables curl coreutils bc jq sed e2fsprogs zip unzip grep gawk iproute2 systemd openssl cron ntp dialog nano git -y
#      elif { [ "${DISTRO}" == "fedora" ] || [ "${DISTRO}" == "centos" ] || [ "${DISTRO}" == "rhel" ]; }; then
#        yum update -y && yum install iptables curl coreutils bc jq sed e2fsprogs zip unzip grep gawk systemd openssl cron ntp dialog -y
#      elif { [ "${DISTRO}" == "arch" ] || [ "${DISTRO}" == "archarm" ] || [ "${DISTRO}" == "manjaro" ]; }; then
#        pacman -Syu --noconfirm --needed bc jq zip unzip cronie ntp dialog
#      elif [ "${DISTRO}" == "alpine" ]; then
#        apk update && apk add iptables curl bc jq sed zip unzip grep gawk iproute2 systemd coreutils openssl cron ntp dialog
#      elif [ "${DISTRO}" == "freebsd" ]; then
#        pkg update && pkg install curl jq zip unzip gawk openssl cron ntp dialog
      fi
    fi
  else
    echo "Error: ${DISTRO} is not supported."
    sleep 2
    read -p "Try To Continue Anyway? [ y / n ] " continue_anyway    
        case $continue_anyway in
            Y)
                echo_warn "Ok. Hope you know what you're doing"
                sleep 2
                echo_note "Hit Ctrl+c if you need to exit. May need to enter it a few times"
                sleep 2
                    ;;
            y)
                echo_warn "Ok. Hope you know what you're doing"
                sleep 2
                echo_note "Hit Ctrl+c if you need to exit. May need to enter it a few times"
                sleep 2
                    ;;
            N)
                echo_note "Fsho, Quitting. Maybe just try running parts of this script to get what you need"
                sleep 4
                exit 0
                    ;;
            n)
                echo_note "Fsho, Quitting. Maybe just try running parts of this script to get what you need"
                sleep 4
                exit 0
                    ;;
        esac    
  fi
}




## install sysctl.d config file
function install-sysctl-d() {
    cp -r -f "${SCRIPT_DIR}/confs/sysctl.d" /etc/sysctl.d
    echo_info "Installing sysctl.d config file"
    sysctl -p
}



## install sshd config file
function install-sshd-conf() {
    echo_warn "Are you sure you want to install the sshd config file? This will overwrite any existing config file. Make sure your SSH keys are installed or password auth is allowed"
    read "sshd_config_install"

    if [ "${sshd_config_install}" == "y" ] || [ "${sshd_config_install}" == "Y" ]; then
        mv /etc/ssh/sshd_config /etc/ssh/sshd_config.original
        cp -f "${SCRIPT_DIR}/confs/ssh/sshd_config.hardened" /etc/ssh/sshd_config
        echo_info "Installing sshd config file"
        sudo kill -SIGHUP "$(pgrep -f 'sshd -D')"
        sudo systemctl daemon-reload && sleep 2 && sudo systemctl restart sshd
    elif [ "${sshd_config_install}" == "n" ] || [ "${sshd_config_install}" == "N" ]; then
        echo_warn "Skipping sshd config file install"
    else
        echo_warn "Invalid option. Skipping sshd config file install"
    fi

}


## install resolved.conf.d config file; get rid of default DNS stub
function install-resolved-conf() {
    cp -r -f "${SCRIPT_DIR}/confs/systemd/resolved.conf.d" /etc/systemd/resolved.conf.d

    echo_info "Installing resolved.conf.d config file"
    systemctl daemon-reload && sleep 2 && systemctl restart systemd-resolved
    rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

    systemctl daemon-reload && sleep 2 && systemctl restart systemd-resolved && sleep 2 && systemctl restart networking && sleep 2

    curl https://ifconfig.me/all
}


## install grub.d kernel options file
function install-grub-d() {
    cp -r -f "${SCRIPT_DIR}/confs/grub.d" /etc/default/grub.d
    echo_info "updating grub"
    update-grub
}

## install dotfiles
function install-dotfiles() {
    echo_info "Installing dotfiles"
    echo_prompt "Do you want to install dotfiles? [ y / n ]"
    read "dotfiles_install"
    if [ "$dotfiles_install" == "n" ] || [ "$dotfiles_install" == "N" ]; then
      echo_warn "Skipping dotfiles install"
    elif [ "$dotfiles_install" == "y" ] || [ "$dotfiles_install" == "Y" ]; then
        echo_prompt "Do you want to install dotfiles for root? [ y / n ]"
        read "dotfiles_root_install"
        
        if [ "${dotfiles_root_install}" == "y" ] || [ "${dotfiles_root_install}" == "Y" ]; then
          echo_info "Installing dotfiles"
          mv "$HOME/.bashrc" "$HOME/.bashrc.original"
          mv "$HOME/.profile" "$HOME/.profile.original"
          cp -f "${SCRIPT_DIR}/confs/dotfiles/.bash_aliases" "$HOME/.bash_aliases"
          cp -f "${SCRIPT_DIR}/confs/dotfiles/.bashrc" "$HOME/.bashrc"
          cp -f "${SCRIPT_DIR}/confs/dotfiles/.profile" "$HOME/.profile"
        
        elif [ "${dotfiles_root_install}" == "n" ] || [ "${dotfiles_root_install}" == "N" ]; then
          echo_info "Skipping dotfiles install for root"
        else
          echo_warn "Invalid option. Skipping dotfiles install for root"
        fi

        echo_prompt "Do you want to install dotfiles for non-root? [ y / n ]"
        read "dotfiles_nonroot_install"
        if [ "${dotfiles_nonroot_install}" == "y" ] || [ "${dotfiles_nonroot_install}" == "Y" ]; then
            echo_prompt "Enter the username of the user you want to install dotfiles for: "
            read "dotfiles_user"

            echo_info "Installing dotfiles for ${dotfiles_user}"
            mv /home/"${dotfiles_user}"/.bashrc /home/"${dotfiles_user}"/.bashrc.original
            mv /home/"${dotfiles_user}"/.profile /home/"${dotfiles_user}"/.profile.original
            cp -f "${SCRIPT_DIR}/confs/dotfiles/.bash_aliases" /home/"${dotfiles_user}"/.bash_aliases
            cp -f "${SCRIPT_DIR}/confs/dotfiles/.bashrc" /home/"${dotfiles_user}"/.bashrc
            cp -f "${SCRIPT_DIR}/confs/dotfiles/.profile" /home/"${dotfiles_user}"/.profile

        elif [ "${dotfiles_nonroot_install}" == "n" ] || [ "${dotfiles_nonroot_install}" == "N" ]; then
            echo_info "Skipping dotfiles install for non-root"
        else
            echo_warn "Invalid option. Skipping dotfiles install for non-root"
        fi
    else
        echo_warn "Invalid option. Skipping dotfiles install"
    fi

}



##########################




## Check for root
super-user-check


## Check Operating System
dist-check



### Run the function and check for requirements
installing-system-requirements


## install sysctl.d config file
install-sysctl-d

## install sshd config file
install-sshd-conf

## install resolved.conf.d config file; get rid of default DNS stub
install-resolved-conf

## install grub.d kernel options file
install-grub-d

## install dotfiles
install-dotfiles