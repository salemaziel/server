#!/usr/bin/env bash

# This script is used to start WireGuard VPN

set -euo pipefail


# Add Color
ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

# shellcheck disable=SC2145
echo_cmd()    { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }

# shellcheck disable=SC2145
echo_prompt() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }

# shellcheck disable=SC2145
echo_note()   { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }

# shellcheck disable=SC2145
echo_info()   { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }

# shellcheck disable=SC2145
echo_warn()   { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }

# shellcheck disable=SC2145
echo_debug()  { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }

# shellcheck disable=SC2145
echo_fail()   { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }


#SERVER_NAME=GENERIC
#SERVER_WG_IP=10.0.0.2
#WG_LOCAL_LISTEN_PORT=6969
#SERVER_DNS=45.90.28.184
#SERVER_END_IP=6.6.6.6
#SERVER_END_PORT=51820

SERVER_NAME=
SERVER_WG_IP=
#WG_LOCAL_LISTEN_PORT=
SERVER_DNS=
SERVER_END_IP=
#SERVER_END_DOMAINNAME=
SERVER_END_PORT=
SERVER_END_IP_PORT="$SERVER_END_IP:$SERVER_END_PORT"
#SERVER_END_DOMAINNAME_PORT="$SERVER_END_DOMAINNAME:$SERVER_END_PORT"
#SERVER_END_HOST="$SERVER_END_DOMAINNAME:-SERVER_END_IP"
STOPWG=/usr/local/bin/wgstop.sh


# Check if WireGuard is installed
function check_wg_installed() {
    if ! command -v wg &> /dev/null
    then
        echo_fail "WireGuard is not installed"
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
        echo_warn "\nWireGuard connection $CHECK is already running\n"
        read -p "${ANSI_WHT}Disconnect from $CHECK ? [y/n]${ANSI_RST} " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo_cmd "\nDisconnecting from $CHECK\n"
            ${STOPWG}
            sleep 0.5
        elif [[ $REPLY =~ ^[Nn]$ ]]; then
            echo_cmd "\nExiting"
            exit 0
        else
            echo_warn "\nInvalid input"
            exit 1
        fi
    fi
}

function check_available_servers() {

    echo_note "\nNames of Servers Available:"
    echo_note "------------------------------\n"
    sudo ls /etc/wireguard/ | cut -d . -f 1
    ## Below: Display vpn options with numbers e.g. 1) vpn1-wgo
#    sudo ls /etc/wireguard/ | cut -d . -f 1 | sed 's/^/) /' | sed '/./=' | sed '/./N; s/\n//'

## Below: display numbered vpn options and then printing without the numbers ; e.g. 1) vpn1-wgo  will print as just vpn1-wgo
# Supposed to be for giving numbered options when choosing vpn instead of entering full vpn name... probably an easier way to do this though
#   sudo ls /etc/wireguard/ | cut -d . -f 1 | sed 's/^/) /' | sed '/./=' | sed '/./N; s/\n//' | awk '{ print $2 }'

    echo_note "\n------------------------------\n"
}


function check_server_details() {
    for i in $(check_available_servers) ; do
        if [ "$i" == "$SERVER_NAME" ]; then
            SERVER_WG_IP=$(sudo cat /etc/wireguard/"${i}".conf | grep "Address" | cut -d " " -f 3 | tail -n 1)
#            WG_LOCAL_LISTEN_PORT=$(sudo cat /etc/wireguard/"${i}".conf | grep "ListenPort" | cut -d " " -f 3)
            SERVER_DNS=$(sudo cat /etc/wireguard/"${i}".conf | grep "DNS" | cut -d " " -f 3 | tail -n 1)
            SERVER_END_IP=$(sudo cat /etc/wireguard/"${i}".conf | grep "Endpoint" | cut -d " " -f 3 | cut -d : -f 1)
#            SERVER_END_DOMAINNAME=$(sudo cat /etc/wireguard/"${i}".conf | grep "Endpoint" | cut -d " " -f 3 | cut -d : -f 1)
            SERVER_END_PORT=$(sudo cat /etc/wireguard/"${i}".conf | grep "Endpoint" | cut -d : -f 2)
            SERVER_END_IP_PORT="$SERVER_END_IP:$SERVER_END_PORT"
#            SERVER_END_DOMAINNAME_PORT="$SERVER_DOMAINNAME:$SERVER_END_PORT"
            break
        fi
    done
}

function start_wireguard_vpn() {
    sudo systemctl start wg-quick@"$SERVER_NAME"
    echo -e "\nConnected to ${ANSI_GRN}$SERVER_NAME${ANSI_RST} at ${ANSI_GRN}$SERVER_END_IP_PORT${ANSI_RST}"
}

function choose_server_responses() {
        case "$SERVER_NAME" in
        d|D)
            read -p "${ANSI_YEL}'Enter server name to see details on:${ANSI_RST} " SERVER_NAME
            check_server_details
                echo_note "\nServer $SERVER_NAME details:"
                echo "\n------------------------------\n"
                echo -e "WG Internal IP: $SERVER_WG_IP"
#                echo -e "WG Local Listening Port: $WG_LOCAL_LISTEN_PORT \n"
                echo -e "DNS Used: $SERVER_DNS"
                echo -e "WG Public IP: $SERVER_END_IP_PORT"
                echo -e "WG Public Port: $SERVER_END_IP_PORT"
                echo -e "WG Public IP & Port: $SERVER_END_IP_PORT"
                echo "\n------------------------------\n"
                sleep 2
                read -p "${ANSI_YEL}Choose this server? [y/n]${ANSI_RST} " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo_cmd "\nStarting WireGuard connection to $SERVER_NAME\n"
                    start_wireguard_vpn
                elif [[ $REPLY =~ ^[Nn]$ ]]; then
                    choose_server
                else
                    echo_fail "\nInvalid input\n"
                    sleep 0.5
                    choose_server
                fi

                ;;
        q|Q)
                exit 0
                ;;
        *wg0)
		check_server_details
                start_wireguard_vpn
                echo_note "Connected to $SERVER_NAME at $SERVER_END_IP_PORT"
                ;;
        *) echo_fail "Invalid server name"
                choose_server
                ;;
    esac
}


function choose_server() {
    echo -e "\n${ANSI_YEL}Checking available servers needs sudo access${ANSI_RST}\n"
    sudo -v
    echo_cmd "Checking available servers...\n"
    sleep 0.5

#    echo -e "\nAvailable servers:"
#    echo "------------------------------"

	   check_available_servers

#    echo "------------------------------"
    echo_prompt "Enter a server name to choose and connect to"
    sleep 0.5
    echo_info "Enter d to see a server's details"
    echo_info "Enter q to quit\n"
    sleep 0.5
    read -p "${ANSI_YEL}Choose server: ${ANSI_RST}" SERVER_NAME
    if [ "$SERVER_NAME" == "d" ]; then
            read -p "${ANSI_YEL}Enter server name to see details on:${ANSI_RST} " SERVER_NAME
            check_server_details
                echo_note "\nServer $SERVER_NAME details:"
                echo_note "------------------------------\n"
                echo -e "${ANSI_BLU}WG Internal IP:${ANSI_RST} $SERVER_WG_IP"
#                echo -e "${ANSI_BLU}WG Local Listening Port:${ANSI_RST} $WG_LOCAL_LISTEN_PORT \n"
                echo -e "${ANSI_BLU}DNS Used:${ANSI_RST} $SERVER_DNS"
                echo -e "${ANSI_BLU}WG Public IP:${ANSI_RST} $SERVER_END_IP_PORT"
                echo -e "${ANSI_BLU}WG Public Port:${ANSI_RST} $SERVER_END_IP_PORT\n"
                echo -e "${ANSI_BLU}WG Public IP & Port:${ANSI_RST} $SERVER_END_IP_PORT"
                echo_note "\n------------------------------\n"
                sleep 2
                read -p "${ANSI_YEL}Choose this server? [y/n]${ANSI_RST} " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo_cmd "\nStarting WireGuard connection to $SERVER_NAME\n"
                    start_wireguard_vpn
                elif [[ $REPLY =~ ^[Nn]$ ]]; then
                    choose_server
                else
                    echo_fail "\nInvalid input"
                    sleep 0.5
                    choose_server
                fi
    elif [ "$SERVER_NAME" == "q" ]; then
        exit 0
    else
	check_server_details
        start_wireguard_vpn
    fi

}

check_wg_installed

check_wg_running

choose_server
