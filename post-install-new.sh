#!/bin/bash

## Goal: Script which automatically sets up a new Ubuntu Machine after installation
## This is a basic install, easily configurable to your needs

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



## Check for docker stuff
function docker-check() {
  if [ -f /.dockerenv ]; then
    DOCKER_KERNEL_VERSION_LIMIT=5.6
    DOCKER_KERNEL_CURRENT_VERSION=$(uname -r | cut -c1-3)
    if (($(echo "${DOCKER_KERNEL_CURRENT_VERSION} >= ${DOCKER_KERNEL_VERSION_LIMIT}" | bc -l))); then
      echo "Correct: Kernel ${DOCKER_KERNEL_CURRENT_VERSION} supported." >>/dev/null
    else
      echo "Error: Kernel ${DOCKER_KERNEL_CURRENT_VERSION} not supported, please update to ${DOCKER_KERNEL_VERSION_LIMIT}"
      exit
    fi
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


## create regular use with sudo privileges
function create-sudo-user() {
echo_prompt "Create a new regular user with sudo privileges? [y/n] "
read create_user
case $create_user in
    Y)
        echo_prompt "Enter username: "
        read new_user
        if [[ -n $(getent passwd | grep $new_user) ]]; then
            echo_fail "User $new_user already exists!"
            sleep 2
            echo_prompt "Change password for $new_user? [y/n] "
            read change_passwd
            case $change_passwd in
                y)
                    echo_note "Ok, lets update that password"
                    echo_info "Must be 8+ characters with mix of letters, digits, & symbols"
                    echo_prompt "Enter password for new user: "
                    read new_passwd2
                    sudo echo -e "$new_passwd2\n$new_passwd2" | passwd $new_user > /dev/null 2>&1
                    echo_note "Password for $new_user successfully changed to $new_passwd2"
                        ;;
                n)
                    echo_note "Ok, continuing"
                    sleep 2
                        ;;
            esac
        else
            echo_info "Must be 8+ characters with mix of letters, digits, & symbols"
            echo_prompt "Enter password for new user: "
            read new_passwd
            add_usersudo
            sleep 2
        fi
            ;;
    y)
        echo_prompt "Enter username: "
        read new_user
        if [[ -n $(getent passwd | grep $new_user) ]]; then
            echo_fail "User $new_user already exists!"
            sleep 2
            echo_prompt "Change password for $new_user? [y/n] "
            read change_passwd
            case $change_passwd in
                y)
                    echo_note "Ok, lets update that password"
                    echo_info "Must be 8+ characters with mix of letters, digits, & symbols"
                    echo_prompt "Enter password for new user: "
                    read new_passwd2
                    sudo echo -e "$new_passwd2\n$new_passwd2" | passwd $new_user > /dev/null 2>&1
                    echo_note "Password for $new_user successfully changed to $new_passwd2"
                        ;;
                n)
                    echo_note "Ok, continuing"
                    sleep 2
                        ;;
            esac
        else
            echo_info "Must be 8+ characters with mix of letters, digits, & symbols"
            echo_prompt "Enter password for new user: "
            read new_passwd
            add_usersudo
            sleep 2
        fi
            ;;
    N)
        echo_note "Fsho."
        sleep 2
            ;;
    n)
        echo_note "Fsho."
        sleep 2
            ;;
    *)
        echo_fail "Bruh."
        sleep 1
        echo_warn "You only had TWO options."
        sleep 2
        echo_warn "Terrible. Take a lap."
        sleep 2
        exit 1
            ;;
esac
}







## import app installing functions
source ./functions2.sh


###################      Beginning of script      ##############################



## Check for root
super-user-check


## Display Welcome to Post Installer
echo_note '
    ____                  __       
   / __ \  ___    ____   / /_      
  / /_/ / / __ \ / ___/ / __/ ______
 / ____/ / /_/ /(__   )/ /_  /_____/
/_/      \____/ /____/ \__/        
                                 '
                                                                                           
echo_note '
    ____              __           __ __           
   /  _/____   _____ / /_  ____ _ / // /___   _____
   / / / __ \ / ___// __/ / __ `// // // _ \ / ___/
 _/ / / / / / \__  )/ /_ / /_/ // // //  __// /    
/___//_/ /_/ /____/ \__/ \__,_//_//_/ \___//_/  

'

sleep 2



## Check Operating System
dist-check



### Run the function and check for requirements
installing-system-requirements



# Virtualization Check
virt-check



## Docker Check
docker-check



# Kernel Version
kernel-check




## clear screeen
clear


## option to create regular user with sudo privileges
create-sudo-user



## Dialog multiple choice menu for selecting apps to install
cmd=(dialog --separate-output --checklist "Default is to Install None. Navigate with Up/Down Arrows. \n 
Select/Unselect with Spacebar. Hit Enter key When Finished To Continue. \n
ESC key/Cancel will continue without installing any options \n
Use Ctrl+c to quit" 22 126 16)
options=(1 "OpenSSH server. Recommended even if already have ssh server running" on
         2 "Fail2ban" off
         3 "Speedtest-cli" off
         4 "Inxi: System/Hardware Identifier" off
         5 "SFTP Server / FTP server that runs over ssh" off
         6 "Docker: Run Apps in Isolated Containers" off
         7 "Docker-Compose: Simplified Docker Container configuration" off
         8 "Wireguard VPN server" off
         9 "TeamViewer: Remote Desktop Sharing" off
         10 "Tor & torsocks: Onion Routing" off
         11 "Google Cloud Platform SDK" off
         12 "NodeJS 14" off
         13 "Yarn: NodeJS package manager" off
         14 "FireJail: Application Sandbox" off
         15 "Your usual Linux packages (User configured at top of this script)" off
         16 "Harden Linux by loading Apparmor at boot" off
         17 "Add System Stats message of the day" off
         18 "Set up Unattended Updates (security updates only)" off
         19 "Install php Composer" off
         20 "Disable WPAD/auto-proxy finding & use bbr for tcp in sysctl.conf" off
         21 "Wireguard VPN server & Manager (recommend)" off          )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

clear 
sleep 3

echo_note " ********************************************* "
echo -e "                                                 "
echo_info "       Ensuring system is up to date            "
echo -e "                                                 "
echo_note " ********************************************* "

sleep 2

# Upgrade the system
sudo DEBIAN_FRONTEND=noninteractive apt-get update 
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y



for apps in $choices
do
    case $apps in
        1)
            install_openssh
            ;;
        2)
            install_fail2ban
            ;;
        3)
            install_speedtestcli
            ;;
        4)
            install_inxi
            ;;
        5)
            install_sftp
            ;;
        6)
            install_dockerce
            ;;
        7)
            install_dockercompose
            ;;
        8)
            wireguard_server
            ;;
        9)
            install_teamviewer
            ;;
        10)
            install_tor
            ;;
        11)
            install_googlecloudSDK
            ;;
        12)
            install_node
            ;;
        13)
            install_yarn
            ;;
        14)
            install_firejail
            ;;
        15)
            general_linuxpkgs
            ;;
        16)
            apparmor_grub
            ;;
        17)
            add_daymsg
            ;;
        18)
            unattended_sec
            ;;
        19) 
            install_phpcomposer
            ;;
        20)
            sysctl_conf
            ;;
        21)
            mkdir -p /usr/local/bin
            cp ./wireguard_server_and_manager.sh /usr/local/bin/wireguard_server_manager
            chmod +x /usr/local/bin/wireguard_server_manager
            /usr/local/bin/./wireguard_server_manager
            #source ./wireguard_server_manager.sh
            #wireguard_server_manager
            ;;
        22)
            source ./hidden_service_manager.sh
            hidden_service_manager
            ;;
    esac
done

clear

sleep 2



echo_note " ###################################################################################################### "
echo_info "
                                        A few tid bits

- In order to use SpeedTest - Just use 'speedtest' in the cli

- Reboot your server to fully configure the vpn service

- When using the VPN service on a device simply use the config file in you home directory. 
To create a new config enter  bash wireguard-install.sh in the cli and choose a new name

- If you installed Docker a portainer management image is running on ip:9000 

- Look in /etc/ssh/sshd_config.suggested for a hardened ssh configuration

"
echo_note " ###################################################################################################### "

sleep 7



echo_note "Cleaning Up."
sudo apt autoremove
sudo apt autoclean
sudo apt clean 

exit 0