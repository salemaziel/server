#!/usr/bin/env bash

# -Super User Check
# -Distro check
# -System requirements pre-check
# -Virtualization check
# -Kernel check

## Require script to be run as root
function super-user-check() {
  if [ "${EUID}" -ne 0 ]; then
    echo_warn "You need to run this script as super user or with sudo"
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




## Check if system is compatible with this script
function checkOS() {
	if [[ -e /etc/debian_version ]]; then
		OS="debian"
		source /etc/os-release

		if [[ $ID == "debian" || $ID == "raspbian" ]]; then
			if [[ $VERSION_ID -lt 9 ]]; then
				echo "⚠️ Your version of Debian is not supported."
				echo ""
				echo "However, if you're using Debian >= 9 or unstable/testing then you can continue, at your own risk."
				echo ""
				until [[ $CONTINUE =~ (y|n) ]]; do
					read -rp "Continue? [y/n]: " -e CONTINUE
				done
				if [[ $CONTINUE == "n" ]]; then
					exit 1
				fi
			fi
		elif [[ $ID == "ubuntu" ]]; then
			OS="ubuntu"
			MAJOR_UBUNTU_VERSION=$(echo "$VERSION_ID" | cut -d '.' -f1)
			if [[ $MAJOR_UBUNTU_VERSION -lt 16 ]]; then
				echo "⚠️ Your version of Ubuntu is not supported."
				echo ""
				echo "However, if you're using Ubuntu >= 16.04 or beta, then you can continue, at your own risk."
				echo ""
				until [[ $CONTINUE =~ (y|n) ]]; do
					read -rp "Continue? [y/n]: " -e CONTINUE
				done
				if [[ $CONTINUE == "n" ]]; then
					exit 1
				fi
			fi
		fi
	elif [[ -e /etc/system-release ]]; then
		source /etc/os-release
		if [[ $ID == "fedora" || $ID_LIKE == "fedora" ]]; then
			OS="fedora"
		fi
		if [[ $ID == "centos" || $ID == "rocky" ]]; then
			OS="centos"
			if [[ ! $VERSION_ID =~ (7|8) ]]; then
				echo "⚠️ Your version of CentOS is not supported."
				echo ""
				echo "The script only support CentOS 7 and CentOS 8."
				echo ""
				exit 1
			fi
		fi
		if [[ $ID == "ol" ]]; then
			OS="oracle"
			if [[ ! $VERSION_ID =~ (8) ]]; then
				echo "Your version of Oracle Linux is not supported."
				echo ""
				echo "The script only support Oracle Linux 8."
				exit 1
			fi
		fi
		if [[ $ID == "amzn" ]]; then
			OS="amzn"
			if [[ $VERSION_ID != "2" ]]; then
				echo "⚠️ Your version of Amazon Linux is not supported."
				echo ""
				echo "The script only support Amazon Linux 2."
				echo ""
				exit 1
			fi
		fi
	elif [[ -e /etc/arch-release ]]; then
		OS=arch
	else
		echo "Looks like you aren't running this installer on a Debian, Ubuntu, Fedora, CentOS, Amazon Linux 2, Oracle Linux 8 or Arch Linux system"
		exit 1
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



