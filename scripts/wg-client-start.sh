#!/usr/bin/env bash

# This script is used to start WireGuard VPN

set -euo pipefail

#SERVER_NAME=GENERIC
#SERVER_WG_IP=10.0.0.2
#WG_LOCAL_LISTEN_PORT=6969
#SERVER_DNS=45.90.28.184
#SERVER_END_IP=6.6.6.6
#SERVER_END_PORT=51820

SERVER_NAME=
SERVER_WG_IP=
WG_LOCAL_LISTEN_PORT=
SERVER_DNS=
SERVER_END_IP=
SERVER_END_PORT=
SERVER_END_IP_PORT="$SERVER_END_IP:$SERVER_END_PORT"
STOPWG=/usr/local/bin/wgstop.sh


# Check if WireGuard is installed
function check_wg_installed() {
    if ! command -v wg &> /dev/null
    then
        echo "WireGuard is not installed"
        exit
    fi
}
#if [ ! -d /etc/wireguard ]; then
#    echo "WireGuard is not installed"
#    exit 1
#fi

function check_for_interface(){
    ifconfig -a | grep wg0 | awk '{ print $1 }' | sed 's/.$//'
}

# Check if Wireguard is already running
function check_wg_running() {
    if [ -n "$(check_for_interface)" ]; then
        CHECK="$(check_for_interface)"
        echo -e "WireGuard connection $CHECK is already running"
        read -p "Disconnect from $CHECK ? [y/n] " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "\nDisconnecting from $CHECK\n"
            ${STOPWG}
            sleep 2
        elif [[ $REPLY =~ ^[Nn]$ ]]; then
            echo -e "\nExiting"
            exit 1
        else
            echo -e "\nInvalid input"
            exit 1
        fi
    fi
}

function check_available_servers() {
    sudo ls /etc/wireguard/ | cut -d . -f 1
}


function check_server_details() {
    for i in $(check_available_servers) ; do
        if [ "$i" == "$SERVER_NAME" ]; then
            SERVER_WG_IP=$(sudo cat /etc/wireguard/$i.conf | grep "Address" | cut -d " " -f 3 | tail -n 1)
            WG_LOCAL_LISTEN_PORT=$(sudo cat /etc/wireguard/$i.conf | grep "ListenPort" | cut -d " " -f 3)
            SERVER_DNS=$(sudo cat /etc/wireguard/$i.conf | grep "DNS" | cut -d " " -f 3 | tail -n 1)
            SERVER_END_IP=$(sudo cat /etc/wireguard/$i.conf | grep "Endpoint" | cut -d " " -f 3 | cut -d : -f 1)
            SERVER_END_PORT=$(sudo cat /etc/wireguard/$i.conf | grep "Endpoint" | cut -d : -f 2)
            SERVER_END_IP_PORT="$SERVER_END_IP:$SERVER_END_PORT"
            break
        fi
    done
}

function start_wireguard_vpn() {
    sudo systemctl start wg-quick@"$SERVER_NAME"
}

function choose_server_responses() {
        case "$SERVER_NAME" in
        d|D)
            read -p "Enter server name to see details on: " SERVER_NAME
            check_server_details
                echo "Server $SERVER_NAME details:"
                echo "------------------------------"
                echo -e "WG Internal IP: $SERVER_WG_IP"
                echo -e "WG Local Listening Port: $WG_LOCAL_LISTEN_PORT \n"
                echo -e "DNS Used: $SERVER_DNS"
                echo -e "WG Public IP: $SERVER_END_IP_PORT"
                echo -e "WG Public Port: $SERVER_END_IP_PORT"
                echo -e "WG Public IP & Port: $SERVER_END_IP_PORT"
                echo "------------------------------"
                sleep 2
                read -p "Choose this server? [y/n] " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo -e "\nStarting WireGuard connection to $SERVER_NAME\n"
                    start_wireguard_vpn
                elif [[ $REPLY =~ ^[Nn]$ ]]; then
                    choose_server
                else
                    echo -e "\nInvalid input"
                    sleep 0.5
                    choose_server
                fi
                
                ;;
        q|Q)
                exit 0
                ;;
        *-wg0)
                start_wireguard_vpn
                echo -e "Connected to $SERVER_NAME at $SERVER_END_IP_PORT"
                ;;
        *) echo "Invalid server name"
                choose_server
                ;;
    esac
}


function choose_server() {
    echo -e "\nAvailable servers:"
    echo "------------------------------"
    check_available_servers
    echo "------------------------------"
    echo -e "Enter a server name to choose a server, or enter d to see a server details"
    echo -e "Enter q to quit"
    read -p "Choose server: " SERVER_NAME
    if [ "$SERVER_NAME" == "d" ]; then
            read -p "Enter server name to see details on: " SERVER_NAME
            check_server_details
                echo "Server $SERVER_NAME details:"
                echo "------------------------------"
                echo -e "WG Internal IP: $SERVER_WG_IP"
                echo -e "WG Local Listening Port: $WG_LOCAL_LISTEN_PORT \n"
                echo -e "DNS Used: $SERVER_DNS"
                echo -e "WG Public IP: $SERVER_END_IP_PORT"
                echo -e "WG Public Port: $SERVER_END_IP_PORT"
                echo -e "WG Public IP & Port: $SERVER_END_IP_PORT"
                echo "------------------------------"
                sleep 2
                read -p "Choose this server? [y/n] " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo -e "\nStarting WireGuard connection to $SERVER_NAME\n"
                    start_wireguard_vpn
                elif [[ $REPLY =~ ^[Nn]$ ]]; then
                    choose_server
                else
                    echo -e "\nInvalid input"
                    sleep 0.5
                    choose_server
                fi
    elif [ "$SERVER_NAME" == "q" ]; then
        exit 0
    else
        start_wireguard_vpn
        echo -e "Connected to $SERVER_NAME"
    fi

}

check_wg_installed

check_wg_running

choose_server
