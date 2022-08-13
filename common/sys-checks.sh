#!/usr/bin/env bash

# -Super User Check
# -Distro check
# -System requirements pre-check
# -Virtualization check
# -Kernel check

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
    DISTRO_CODENAME=${VERSION_CODENAME}
  fi
}


### Pre-Checks system requirements
 function installing-system-requirements() {
  if { [ "${DISTRO}" == "ubuntu" ] || [ "${DISTRO}" == "debian" ] || [ "${DISTRO}" == "raspbian" ] || [ "${DISTRO}" == "pop" ] || [ "${DISTRO}" == "kali" ] || [ "${DISTRO}" == "linuxmint" ] || [ "${DISTRO}" == "fedora" ] || [ "${DISTRO}" == "centos" ] || [ "${DISTRO}" == "rhel" ] || [ "${DISTRO}" == "arch" ] || [ "${DISTRO}" == "archarm" ] || [ "${DISTRO}" == "manjaro" ] || [ "${DISTRO}" == "alpine" ] || [ "${DISTRO}" == "freebsd" ]; }; then
    if { [ ! -x "$(command -v curl)" ] || [ ! -x "$(command -v iptables)" ] || [ ! -x "$(command -v bc)" ] || [ ! -x "$(command -v jq)" ] || [ ! -x "$(command -v cron)" ] || [ ! -x "$(command -v sed)" ] || [ ! -x "$(command -v zip)" ] || [ ! -x "$(command -v unzip)" ] || [ ! -x "$(command -v grep)" ] || [ ! -x "$(command -v awk)" ] || [ ! -x "$(command -v shuf)" ] || [ ! -x "$(command -v openssl)" ] || [ ! -x "$(command -v ntpd)" ] || [ ! -x "$(command -v dialog)" ]; }; then
      if { [ "${DISTRO}" == "ubuntu" ] || [ "${DISTRO}" == "debian" ] || [ "${DISTRO}" == "raspbian" ] || [ "${DISTRO}" == "pop" ] || [ "${DISTRO}" == "kali" ] || [ "${DISTRO}" == "linuxmint" ]; }; then
        apt-get update && apt-get install iptables curl coreutils bc jq sed e2fsprogs zip unzip grep gawk iproute2 systemd openssl cron ntp dialog -y
      elif { [ "${DISTRO}" == "fedora" ] || [ "${DISTRO}" == "centos" ] || [ "${DISTRO}" == "rhel" ]; }; then
        yum update -y && yum install iptables curl coreutils bc jq sed e2fsprogs zip unzip grep gawk systemd openssl cron ntp dialog -y
      elif { [ "${DISTRO}" == "arch" ] || [ "${DISTRO}" == "archarm" ] || [ "${DISTRO}" == "manjaro" ]; }; then
        pacman -Syu --noconfirm --needed bc jq zip unzip cronie ntp dialog
      elif [ "${DISTRO}" == "alpine" ]; then
        apk update && apk add iptables curl bc jq sed zip unzip grep gawk iproute2 systemd coreutils openssl cron ntp dialog
      elif [ "${DISTRO}" == "freebsd" ]; then
        pkg update && pkg install curl jq zip unzip gawk openssl cron ntp dialog
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




## Checking For Virtualization
function virt-check() {
  ## Deny OpenVZ Virtualization
  if [ "$(systemd-detect-virt)" == "openvz" ]; then
    echo "OpenVZ virtualization is not supported (yet)."
    exit
  ## Deny LXC Virtualization
  elif [ "$(systemd-detect-virt)" == "lxc" ]; then
    echo "LXC virtualization is not supported (yet)."
    exit
  fi
}



## Lets check the kernel version
function kernel-check() {
  KERNEL_VERSION_LIMIT=3.1
  KERNEL_CURRENT_VERSION=$(uname -r | cut -c1-3)
  if (($(echo "${KERNEL_CURRENT_VERSION} >= ${KERNEL_VERSION_LIMIT}" | bc -l))); then
    echo "Correct: Kernel ${KERNEL_CURRENT_VERSION} supported." >>/dev/null
  else
    echo "Error: Kernel ${KERNEL_CURRENT_VERSION} not supported, please update to ${KERNEL_VERSION_LIMIT}"
    exit
  fi
}



