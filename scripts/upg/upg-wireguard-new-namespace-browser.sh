#!/bin/bash

# Prompt user for Wireguard config file
echo "Please enter the name of your Wireguard config file:"
read config_file_name

# Set the path to the Wireguard config file
config_file="/etc/wireguard/$config_file_name"

# Create a new network namespace
ip netns add vpn_ns

# Connect the namespace to the Wireguard config file
wg-quick up $config_file -n vpn_ns

# Allow a browser to connect to the namespace using the VPN
ip netns exec vpn_ns firefox --private-window &