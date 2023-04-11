#!/bin/bash

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

###################

#NS=
#WGVPN=


echo_fail "Need to add veth devices and bridge namespaces before will work!"
sleep 2
exit


# Check if WireGuard is installed
function check_wg_installed() {
    if ! command -v wg &> /dev/null
    then
        echo_fail "WireGuard is not installed"
        exit
    fi
}

function check_available_servers() {

    echo_note "\nNames of Servers Available:"
    echo_note "------------------------------\n"
    sudo ls /etc/wireguard/ | cut -d . -f 1
    ## Below: Display vpn options with numbers e.g. 1) vpn1-wgo
#    sudo ls /etc/wireguard/ | cut -d . -f 1 | sed 's/^/) /' | sed '/./=' | sed '/./N; s/\n//'
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



# Create network namespaces
echo_cmd "Starting network namespace NS1"
ip netns add NS1

echo_cmd "Starting network namespace NS2"
ip netns add NS2

# Set up Wireguard VPN in NS1 namespace
echo_cmd "Starting wireguard vpn in NS1"
ip netns exec NS1 wg-quick up s2-wg0

# Set up Wireguard VPN in NS2 namespace
ip netns exec NS2 wg-quick up vnet-wg0

# Configure firewall rules for NS1 namespace
ip netns exec NS1 iptables -A OUTPUT ! -o s2-wg0 -m mark ! --mark 0xcafe -j REJECT
ip netns exec NS1 iptables -t nat -A POSTROUTING -o s2-wg0 -j MASQUERADE

# Configure firewall rules for NS2 namespace
ip netns exec NS2 iptables -A OUTPUT ! -o vnet1-wg0 -m mark ! --mark 0xcafe -j REJECT
ip netns exec NS2 iptables -t nat -A POSTROUTING -o vnet1-wg0 -j MASQUERADE

# Launch Vivaldi browser in NS1 namespace
ip netns exec NS1 vivaldi &

# Sleep for 10 seconds
sleep 10

# Launch Firefox browser in NS2 namespace
ip netns exec NS2 firefox &

# Remove Wireguard VPN from namespaces
#ip netns exec NS1 wg-quick down c1-wg0
#ip netns exec NS2 wg-quick down net-wg0

# Remove network namespaces
#ip netns del NS1
#ip netns del NS2
