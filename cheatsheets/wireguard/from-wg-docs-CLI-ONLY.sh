#!/bin/bash

WG_DEV=""
WG_PATH=/etc/wireguard/
WG_CONF=""
WG_CONF_PATH="${WG_PATH}/${WG_CONF}"

echo -e "EXITING. This is an example only with commands from Wireguard.com/quickstart"
echo -e "Copy this file and customize for your uses if needed, don't change this"
sleep 1
exit

function super-user-check() {
  if [ "${EUID}" -ne 0 ]; then
    echo_warn "You need to run this script as super user or with sudo"
    exit
  fi
}

super-user-check


# A new interface can be added via ip-link(8), which should automatically handle module loading:
ip link add dev wg0 type wireguard

# An IP address and peer can be assigned with ifconfig(8) or ip-address(8)
ip address add dev wg0 192.168.2.1/24

# Or, if there are only two peers total, something like this might be more desirable:
ip link delete devip address add dev wg0 192.168.2.1 peer 192.168.2.2

# The interface can be configured with keys and peer endpoints with the included wg(8) utility:
wg setconf wg0 myconfig.conf
# or
wg set wg0 listen-port 51820 private-key /path/to/private-key peer ABCDEF... allowed-ips 192.168.88.0/24 endpoint 209.202.254.14:8172

# Finally, the interface can then be activated with ifconfig(8) or ip-link(8):
ip link set up dev wg0

# To bring down
ip link set down dev wg0 # (?)
ip link delete dev wg0

# There are also tip link delete devhe wg show and wg showconf commands, for viewing the current configuration.
# Calling wg with no arguments defaults to calling wg show on all WireGuard interfaces.


# If you're using the Linux kernel module and your kernel supports dynamic debugging, you can get useful runtime output by enabling dynamic debug for the module:
modprobe wireguard && echo module wireguard +p > /sys/kernel/debug/dynamic_debug/control





