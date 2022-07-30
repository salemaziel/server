#!/bin/bash


#
# Routed network configuration script
#

#WG_IF=$(ifconfig -a | grep wg | awk '{ print $1 }' | cut -d : -f 1)
#TUN_IF=$(ifconfig -a | grep tun | awk '{ print $1 }' | cut -d : -f 1)
#PROTON_IF=$(ifconfig -a | grep proto | awk '{ print $1 }' | cut -d : -f 1)
#NET_IF=$(ifconfig -a | grep wlp | awk '{ print $1 }' | cut -d : -f 1)
NIC=$(ifconfig -a | grep -e "wlp" -e "wg" -e "tun" -e "proto" | awk '{ print $1 }' | cut -d : -f 1 | head -n 1)


echo $NIC

#exit
# check for vpn interfaces
#check_nic() {
#if  [ -n ${WG_IF} ] ; then#
#	NIC="${WG_IF}"
#elif

# bridge setup
brctl addbr br0
ifconfig br0 10.10.20.1/24 up

# enable ipv4 forwarding
echo "1" > /proc/sys/net/ipv4/ip_forward

# netfilter cleanup
iptables --flush
iptables -t nat -F
iptables -X
iptables -Z
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

# netfilter network address translation
iptables -t nat -A POSTROUTING -o ${NIC} -s 10.10.20.0/24 -j MASQUERADE

echo "Now start applications like: firejail --net=br0 firefox"

sleep 2



#For running servers I replace network address translation with port forwarding in the script above:
# host port 80 forwarded to sandbox port 80
#iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 10.10.20.10:80


