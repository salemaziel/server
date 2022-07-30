#!/bin/bash
# Simple bridge setup/teardown script for a routed X11 firejail
# (by default, br10 on 10.10.20.1/24)
# pass argument "start" to setup bridge, or "stop" to
# tear it down
#
# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL-3.0+
# https://wiki.gentoo.org/wiki/User:Sakaki/Sakaki%27s_EFI_Install_Guide/Sandboxing_the_Firefox_Browser_with_Firejail


# we avoid br0, br1 etc. as these may already be in use
BRIDGE="br10"

# modify if 10.10.20.0/24 subnet already in use on your machine
SUBNET_PREFIX="10.10.20"

if [[ "start" == "$1" ]]; then
        # create a null bridge with address 10.10.20.1, and bring it up
        brctl addbr "$BRIDGE"
        ip addr add "$SUBNET_PREFIX".1/24 dev "$BRIDGE"
        ip link set "$BRIDGE" up
	# enable ipv4 forwarding
	echo "1" > /proc/sys/net/ipv4/ip_forward
#	bash ./firejail-firewall.sh
elif [[ "stop" == "$1" ]]; then
        # delete the bridge, if it exists
        if brctl show "$BRIDGE" &>/dev/null; then
                ip link set "$BRIDGE" down
                brctl delbr "$BRIDGE"
		iptables-nft-restore /etc/iptables/rules.v4
        fi
else
        >&2 echo "$0: error: please use 'start' or 'stop'"
        exit 1
fi
