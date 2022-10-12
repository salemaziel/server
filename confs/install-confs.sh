#!/bin/bash

set -eu -o pipefail

## Goal: Script which automatically sets up a new Ubuntu Machine after installation
## This is a basic install, easily configurable to your needs

SCRIPT_DIR=$(dirname $(readlink -f $0))
#SCRIPT_DIR="$PWD"

CONF_NAME="none"

## Add some color

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

echo_cmd() { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
echo_prompt() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_note() { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
echo_info() { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
echo_warn() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_debug() { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
echo_fail() { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }

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
  if { [ "${DISTRO}" == "ubuntu" ] || [ "${DISTRO}" == "debian" ] || [ "${DISTRO}" == "raspbian" ] || [ "${DISTRO}" == "pop" ] || [ "${DISTRO}" == "kali" ] || [ "${DISTRO}" == "linuxmint" ]; }; then #|| [ "${DISTRO}" == "fedora" ] || [ "${DISTRO}" == "centos" ] || [ "${DISTRO}" == "rhel" ] || [ "${DISTRO}" == "arch" ] || [ "${DISTRO}" == "archarm" ] || [ "${DISTRO}" == "manjaro" ] || [ "${DISTRO}" == "alpine" ] || [ "${DISTRO}" == "freebsd" ]; }; then
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
  if [ -f /etc/sysctl.d/custom.txt ]; then
    echo_note "Trying to install sysctl.d configs, but it looks like they're already installed."
    sleep 1
    echo_info "Reinstall them? [ y / n ]"
    read -r reinstall_sysctl_d
    case $reinstall_sysctl_d in
    Y | y)
      echo_warn "Ok. Reinstalling sysctl.d configs."
      sleep 2
      ;;
    N | n)
      echo_note "Ok. Skipping sysctl.d configs."
      sleep 2
      return
      ;;
    *)
      echo_fail "Invalid option. Skipping sysctl.d configs."
      sleep 2
      return
      ;;
    esac

    CONF_NAME="Sysctl.d Config"

    ask-install-choices

    if [ "$INSTALL" == "true" ]; then

      echo_info "Copying sysctl.d config files"
      cp -r -f ./confs/sysctl.d/* /etc/sysctl.d
      sleep 1
      echo_info "Installing sysctl.d config files"
      sleep 1
      sysctl -p
    elif [ "$install_choices" == "n" ] || [ "$install_choices" == "N" ]; then
      echo_info "Skipping confs for ${CONF_NAME}"
    else
      echo_warn "Invalid option. Skipping confs for ${CONF_NAME}"
    fi
  fi
}

## install sshd config file
function install-sshd-conf() {

  if [ -f /etc/ssh/sshd_config.original ]; then
    echo_note "Sshd config already installed. Skipping"
    sleep 1
  else

    CONF_NAME="Hardened SSHD Config"
    ask-install-choices

    if [ "$INSTALL" == "true" ]; then
      echo_note "Installing sshd config file"
      sleep 2
      echo_warn "Are you sure you want to install the sshd config file? This will overwrite any existing config file. Make sure your SSH keys are installed or password auth is allowed"
      read "sshd_config_install"

      if [ "${sshd_config_install}" == "y" ] || [ "${sshd_config_install}" == "Y" ]; then
        mv /etc/ssh/sshd_config /etc/ssh/sshd_config.original
        cp -f "./confs/ssh/sshd_config.hardened" /etc/ssh/sshd_config
        echo_info "Installing sshd config file"
        sudo kill -SIGHUP "$(pgrep -f 'sshd -D')"
        sudo systemctl daemon-reload && sleep 2 && sudo systemctl restart sshd
      elif [ "${sshd_config_install}" == "n" ] || [ "${sshd_config_install}" == "N" ]; then
        echo_warn "Skipping sshd config file install"
      else
        echo_warn "Invalid option. Skipping sshd config file install"
      fi
    else
      echo_note "Skipping confs for ${CONF_NAME}"
    fi
  fi
  #            elif [ "$install_choices" == "n" ] || [ "$install_choices" == "N" ]; then
  #                echo_info "Skipping confs for "${CONF_NAME}""
  #            else
  #                echo_warn "Invalid option. Skipping confs for "${CONF_NAME}""
  #            fi

}

## install resolved.conf.d config file; get rid of default DNS stub
function install-resolved-conf() {

  if [ -d /etc/systemd/resolved.conf.d ]; then
    echo_note "Resolved config already installed. Skipping"
    sleep 1
    exit
  fi

  if [ "${DISTRO}" == "ubuntu" ]; then

    echo_note "Installing resolved.conf.d config file \n"
    sleep 1
    echo_info "This will disable the default DNS stub resolver and use systemd-resolved instead."
    echo_info "Do you want to continue? [y/n]"
    read "resolved_conf_install"
    if [ "${resolved_conf_install}" == "y" ] || [ "${resolved_conf_install}" == "Y" ]; then
      echo_info "Ok, installing resolved.conf.d config file"
      sleep 1
      #cp -r -f "./confs/systemd/resolved.conf.d" /etc/systemd/resolved.conf.d
      #chown -R root:root /etc/systemd/resolved.conf.d
      #sudo systemctl daemon-reload && sleep 2 && sudo systemctl restart systemd-resolved
      #rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf

      echo_info "Checking if we have DNS resolution and our public IP"
      curl https://ifconfig.me/all

    elif [ "${resolved_conf_install}" == "n" ] || [ "${resolved_conf_install}" == "N" ]; then
      echo_warn "Skipping resolved.conf.d config file install"
    else
      echo_warn "Invalid option. Skipping resolved.conf.d config file install"
    fi

  elif { [ "${DISTRO}" == "debian" ] || [ "${DISTRO}" == "raspbian" ] || [ "${DISTRO}" == "pop" ] || [ "${DISTRO}" == "kali" ] || [ "${DISTRO}" == "linuxmint" ]; }; then
    echo_info "Not installing resolved.conf.d config file, as i think its only an ubuntu thing"
    sleep 2
    echo_note "Continuing. You can install it manually if you want"
    sleep 1
  else
    echo_warn "Not installing resolved.conf.d config file, this doesnt seem to be a supported distro"
    sleep 2
    echo_prompt "Want to exit and check it out? [ y / n ] "
    read check_exit
    case $check_exit in
    Y | y)
      echo_warn "Ok. Quitting"
      sleep 2
      exit 1
      ;;
    N | n)
      echo_note "Ok. Continuing... Good luck"
      sleep 2
      ;;
    esac
  fi
}

## install grub.d kernel options file
function install-grub-d() {
  #cp -r -f "./confs/grub.d" /etc/default/grub.d
  #test
  mkdir -p /tmp/default/grub.d

  #cp -r -f "./confs/grub.d" /etc/default/grub.d
  #test
  cp -r -f ./confs/grub.d/* /tmp/default/grub.d
  echo_info "updating grub"
  #update-grub
}

run-dotfiles-root() {
  echo_note "Installing dotfiles"
  mv "$HOME/.bashrc" "$HOME/.bashrc.original"
  mv "$HOME/.profile" "$HOME/.profile.original"
  cp -f "./confs/dotfiles/.bash_aliases" "$HOME/.bash_aliases"
  cp -f "./confs/dotfiles/.bashrc" "$HOME/.bashrc"
  cp -f "./confs/dotfiles/.profile" "$HOME/.profile"
}

run-dotfiles-nonroot() {
  echo_prompt "Enter the username of the user you want to install dotfiles for: "
  read "dotfiles_user"

  echo_info "Installing dotfiles for ${dotfiles_user}"
  #            if [ -f "/home/${dotfiles_user}/.bash_aliases" ]; then
  #              mv "/home/${dotfiles_user}/.bash_aliases" "/home/${dotfiles_user}/.bash_aliases.original"
  #              mv /home/"${dotfiles_user}"/.bashrc /home/"${dotfiles_user}"/.bashrc.original
  #              mv /home/"${dotfiles_user}"/.profile /home/"${dotfiles_user}"/.profile.original
  #            else
  #              cp -f "./confs/dotfiles/.bash_aliases" /home/"${dotfiles_user}"/.bash_aliases
  #              cp -f "./confs/dotfiles/.bashrc" /home/"${dotfiles_user}"/.bashrc
  #              cp -f "./confs/dotfiles/.profile" /home/"${dotfiles_user}"/.profile
  #            fi
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
      echo_info "Installing dotfiles for root"
      sleep 1

      # run dotfiles for root
      #           run-dotfiles-root

      #          mv "$HOME/.bashrc" "$HOME/.bashrc.original"
      #          mv "$HOME/.profile" "$HOME/.profile.original"
      #          cp -f "./confs/dotfiles/.bash_aliases" "$HOME/.bash_aliases"
      #          cp -f "./confs/dotfiles/.bashrc" "$HOME/.bashrc"
      #          cp -f "./confs/dotfiles/.profile" "$HOME/.profile"

    elif [ "${dotfiles_root_install}" == "n" ] || [ "${dotfiles_root_install}" == "N" ]; then
      echo_info "Skipping dotfiles install for root"
      sleep 1
      echo_prompt "Do you want to install dotfiles for non-root? [ y / n ]"
      read "dotfiles_nonroot_install"

      if [ "${dotfiles_nonroot_install}" == "y" ] || [ "${dotfiles_nonroot_install}" == "Y" ]; then
        run-dotfiles-nonroot
      elif [ "${dotfiles_nonroot_install}" == "n" ] || [ "${dotfiles_nonroot_install}" == "N" ]; then
        echo_info "Skipping dotfiles install for non-root"
      else
        echo_warn "Invalid option. Skipping dotfiles install for non-root"
      fi

    fi
    echo_prompt "Do you want to install dotfiles for non-root? [ y / n ]"
    read "dotfiles_nonroot_install"
    if [ "${dotfiles_nonroot_install}" == "y" ] || [ "${dotfiles_nonroot_install}" == "Y" ]; then

      run-dotfiles-nonroot

      #            echo_prompt "Enter the username of the user you want to install dotfiles for: "
      #            read "dotfiles_user"

      #            echo_info "Installing dotfiles for ${dotfiles_user}"
      #            if [ -f "/home/${dotfiles_user}/.bash_aliases" ]; then
      #              mv "/home/${dotfiles_user}/.bash_aliases" "/home/${dotfiles_user}/.bash_aliases.original"
      #              mv /home/"${dotfiles_user}"/.bashrc /home/"${dotfiles_user}"/.bashrc.original
      #              mv /home/"${dotfiles_user}"/.profile /home/"${dotfiles_user}"/.profile.original
      #            else
      #              cp -f "./confs/dotfiles/.bash_aliases" /home/"${dotfiles_user}"/.bash_aliases
      #              cp -f "./confs/dotfiles/.bashrc" /home/"${dotfiles_user}"/.bashrc
      #              cp -f "./confs/dotfiles/.profile" /home/"${dotfiles_user}"/.profile
      #            fi
    elif [ "${dotfiles_nonroot_install}" == "n" ] || [ "${dotfiles_nonroot_install}" == "N" ]; then
      echo_info "Skipping dotfiles install for non-root"
    else
      echo_warn "Invalid option. Skipping dotfiles install for non-root"
    fi
  fi

}

## Ask to Install
ask-to-install() {
  echo_prompt "Do you want to install the following? [ y / n ]"
  echo_info "1. Install grub.d kernel options file"
  echo_info "2. Install resolved.conf.d config file"
  echo_info "3. Install dotfiles"
  echo_info "4. Install all of the above"
  echo_info "5. Install nothing"
  read "install_options"
  if [ "$install_options" == "1" ]; then
    install-grub-d
  elif [ "$install_options" == "2" ]; then
    install-resolved-conf
  elif [ "$install_options" == "3" ]; then
    install-dotfiles
  elif [ "$install_options" == "4" ]; then
    install-grub-d
    install-resolved-conf
    install-dotfiles
  elif [ "$install_options" == "5" ]; then
    echo_warn "Skipping install"
  else
    echo_warn "Invalid option. Skipping install"
  fi
}

## Ask user to choose what to install
ask-install-choices() {
  echo_prompt "Do you want to install confs for ${CONF_NAME} ? [ y / n ]"
  read "install_choices"
  if [ "$install_choices" == "y" ] || [ "$install_choices" == "Y" ]; then
    INSTALL="true"
  elif [ "$install_choices" == "n" ] || [ "$install_choices" == "N" ]; then
    INSTALL="false"
    echo_info "Skipping confs for ""${CONF_NAME}"""
  else
    INSTALL="false"
    echo_warn "Invalid option. Skipping confs for ""${CONF_NAME}"""
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

read -p "${ANSI_YEL}Install sysctl.d config file? [ y / n ]${ANSI_RST} " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install-sysctl-d
elif [[ $REPLY =~ ^[Nn]$ ]]; then
  echo -e ""
  sleep 0.5
else
  echo_fail "\nInvalid input\n"
  sleep 0.5
fi

## install sshd config file

read -p "${ANSI_YEL}Install sshd config file? [ y / n ]${ANSI_RST} " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then

  if [ -f /etc/ssh/sshd_config.original ]; then
    echo_note "Sshd config already installed. Skipping"
    sleep 1
  else
    #testing
    echo -e "installing sshd config file"
    sleep 1
  fi
  #                        install-sshd-conf
elif [[ $REPLY =~ ^[Nn]$ ]]; then
  echo -e ""
  sleep 0.5
else
  echo_fail "\nInvalid input\n"
  sleep 0.5
fi

## install resolved.conf.d config file; get rid of default DNS stub

read -p "${ANSI_YEL}Install resolved-conf [ y / n ]${ANSI_RST} " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install-resolved-conf

elif [[ $REPLY =~ ^[Nn]$ ]]; then
  echo -e ""
  sleep 0.5
else
  echo_fail "\nInvalid input\n"
  sleep 0.5
fi
## install grub.d kernel options file

read -p "${ANSI_YEL}Install grub.d boot confs [ y / n ]${ANSI_RST} " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  install-grub-d

elif [[ $REPLY =~ ^[Nn]$ ]]; then
  echo -e ""
  sleep 0.5
else
  echo_fail "\nInvalid input\n"
  sleep 0.5
fi

## install dotfiles
install-dotfiles
