#!/bin/bash


# Needs dialog package to run
read -p "Install dialog package for install menu? (y/n) " DIALOG_INSTALL_CHOICE
if [ "$DIALOG_INSTALL_CHOICE" == "y" ] || [ "$DIALOG_INSTALL_CHOICE" == "Y" ]; then
    sudo apt-get -y install dialog
elif [ "$DIALOG_INSTALL_CHOICE" == "n" ] || [ "$DIALOG_INSTALL_CHOICE" == "N" ]; then
    echo -e "Skipping dialog install"
    exit 1
else
    echo "Invalid choice"
    exit 1
fi





## Dialog multiple choice menu for selecting apps to install
cmd=(dialog --separate-output --checklist "Default is to Install None. Navigate with Up/Down Arrows. \n 
Select/Unselect with Spacebar. Hit Enter key When Finished To Continue. \n
ESC key/Cancel will continue without installing any options \n
Use Ctrl+c to quit" 22 126 16)
options=(1 "" on
         2 "" off
         3 "" off
         4 "" off
         5 "" off
         6 "" off
         7 "" off
         8 "" off
         9 "" off
         10 "" off
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

if [ $STUN -eq 1 ]; then
    allow_stun_turn
fi

if [ $ICMP -eq 1 ]; then
    allow_icmp
fi
if [ $DNSDOCKER -eq 1 ]; then
    allow_dns_docker_localhost
fi

log_dropped_in

prepend_chain

rate_limit

log_dropped_incoming

if [ $WEBSERVER -eq 1 ]; then
    allow_webserver
fi

if [ $SSH -eq 1 ]; then
    allow_ssh
fi

if [ $CUSTOMTCP -eq 1 ]; then
    allowed_tcp_ports
fi

if [ $CUSTOMUDP -eq 1 ]; then
    allowed_udp_ports
fi
if [ $DOCKERWORKAROUND -eq 1 ]; then
    docker_workaround
fi