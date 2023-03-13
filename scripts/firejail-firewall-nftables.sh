#!/bin/bash
# Simple configuration script for an IPv4 routing firewall suitable for use with a firejail sandbox on a client machine
# New input is blocked by default, and bridge traffic is redirected to the gateway interface, with masquerading
#
# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL-3.0+

# modify to match your particular machine's main interface (e.g., wlp0s20f3)
NIC="wlp0s20f3"

# modify if 10.10.20.0/24 subnet already in use on your machine
# (for something other than br10)
SUBNET="10.10.20.0/24"

# clear firewall state, including policies, rules and counters, and set default policies
nft flush ruleset
nft add table ip filter
nft add chain ip filter input { type filter hook input priority 0 \; }
nft add chain ip filter forward { type filter hook forward priority 0 \; }
nft add chain ip filter output { type filter hook output priority 0 \; }
nft add rule ip filter input iif lo accept
nft add rule ip filter input ct state established,related accept
nft add rule ip filter input drop
nft add rule ip filter forward drop
nft add rule ip filter output accept
# dynamically translate the source address of any outbound traffic from the bridge subnet (and reverse for matched input)
nft add table ip nat
nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }
nft add rule ip nat postrouting ip saddr "$SUBNET" oif "$NIC" masquerade