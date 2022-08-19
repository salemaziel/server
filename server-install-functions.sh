#!/bin/bash

install_menu() {

# Needs dialog package to run
read -p "Install dialog package for install menu? (y/n) " DIALOG_INSTALL_CHOICE
if [ "$DIALOG_INSTALL_CHOICE" == "y" ] || [ "$DIALOG_INSTALL_CHOICE" == "Y" ]; then
    sudo apt-get -y install dialog
elif [ "$DIALOG_INSTALL_CHOICE" == "n" ] || [ "$DIALOG_INSTALL_CHOICE" == "N" ]; then
    echo -e "Skipping dialog install"
    echo -e "Continuing without dialog install"
    echo -e "Just kidding, quitting cuz i havent finished it yet. Install shit manually"
    sleep 2
    exit 1
else
    echo "Invalid choice"
    exit 1
fi

echo "not done yet, sorry"

exit 1

## Dialog multiple choice menu for selecting apps to install
cmd=(dialog --separate-output --checklist "Default is to Install None. Navigate with Up/Down Arrows. \n 
Select/Unselect with Spacebar. Hit Enter key When Finished To Continue. \n
ESC key/Cancel will continue without installing any options \n
Use Ctrl+c to quit" 22 126 16)
options=(1 "Install common requirements" on
         2 "Hardened Confs (Sysctl, SSH, Resolved, grub, dotfiles" on
         3 "Docker & Docker Compose" off
         4 "Wireguard VPN (non-docker)" off
         5 "OpenVPN server (non-docker)" off
         6 "Shadowsocks server (non-docker)" off
         7 "Croc (Utility for easy file transfer)" off
         8 "Inxi (System viewer)" off
         9 "Setup IPtables firewall" on
         10 "NextDNS CLI DOH DNS proxy" off
         11 "" off
         12 "" off
         13 "" off
         14 "" off
         15 "" off
         16 "" off
         17 "" off
         18 "" off
         19 "" off
         20 "" off
         21 "" off          )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for FWRULES in $choices
do
    case $FWRULES in
        1)
#            ICMP=1
            allow_icmp
            ;;
        2)
#            allow_dns_docker_localhost
            DNSDOCKER=1
            ;;
        3)
#            allow_ssh
            SSH=1
            ;;
        4)
#            allow_webserver
            WEBSERVER=1
            ;;
        5)
#            allowed_tcp_ports
            CUSTOMTCP=1
            ;;
        6)
#            allowed_udp_ports
            CUSTOMUDP=1
            ;;
        7) 
#            allow_stun_turn
            STUN=1
            ;;
        8) 
#            docker_workaround
            DOCKERWORKAROUND=1
            ;;
    esac
done

}