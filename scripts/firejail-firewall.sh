#!/bin/bash
# Simple configuration script for an IPv4 routing firewall
# suitable for use with a firejail sandbox on a client machine
# New input is blocked by default, and bridge traffic is
# redirected to the gateway interface, with masquerading
#
# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL-3.0+

# modify to match your particular machine's main interface
#NETIF="wlp0s20f3"
NIC=$(ifconfig -a | grep -e "wlp" -e "wg" -e "tun" -e "proto" | awk '{ print $1 }' | cut -d : -f 1 | head -n 1)

# modify if 10.10.20.0/24 subnet already in use on your machine
# (for something other than br10)
SUBNET="10.10.20.0/24"

# clear firewall state, including policies, rules and counters
iptables --flush
iptables -t nat -F
iptables -X
iptables -Z

# setup default policies, which apply in the absence of
# any contradicting explicit rule
# (here: drop any input, but allow output and forwarding)
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# explicit rules
# allow any input from localhost
iptables -A INPUT -i lo -j ACCEPT
# also permit any input state matched to an existing connection
# (i.e., a reply)
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# add any specific blocks you want here
# for example, prevent any port 25 forwarding (SMTP) from the sandbox
# to help guard against mail spam
iptables -A FORWARD -s "$SUBNET" -p tcp --dport 25 -j DROP

# dynamically translate the source address of any outbound
# traffic from the bridge subnet (and reverse for matched input)
iptables -t nat -A POSTROUTING -s "$SUBNET" -o "$NIC" -j MASQUERADE
