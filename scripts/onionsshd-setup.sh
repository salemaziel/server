#!/bin/bash

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root"
    exit
fi

# Update the package lists for upgrades and new package installations
apt update

# Check if tor is installed and running; if not, install and start it
if ! command -v tor &> /dev/null; then
    apt install -qy tor
    systemctl start tor
elif ! systemctl is-active --quiet tor; then
    systemctl start tor
fi

# Check if openssh-server is installed and running; if not, install and start it
if ! command -v sshd &> /dev/null; then
    apt install -qy openssh-server
    systemctl start sshd
elif ! systemctl is-active --quiet sshd; then
    systemctl start sshd
fi

# Backup the original torrc file if not already backed up
if [ ! -f /etc/tor/torrc.original ]; then
    cp /etc/tor/torrc /etc/tor/torrc.original
fi

# Configure the Hidden Service
sudo tee /etc/tor/torrc > /dev/null << EOT
## Original config
Include /etc/tor/torrc.original

## Hidden Service for SSH
HiddenServiceDir /var/lib/tor/hidden-service-ssh/
HiddenServicePort 42069 127.0.0.1:22
EOT

# Create the Hidden Service directory if it doesn't exist
mkdir -p /var/lib/tor/hidden-service-ssh/

# Change the owner of the Hidden Service directory to the debian-tor user
chown debian-tor:debian-tor /var/lib/tor/hidden-service-ssh/

# Restart the tor service
systemctl restart tor

# Get the Hidden Service address
hidden_service_address="$(cat /var/lib/tor/hidden-service-ssh/hostname)"

# Output the Hidden Service address
echo "Hidden Service address for SSH:"
echo "${hidden_service_address}"

# Output the SSH command to connect to the Hidden Service
echo "SSH command to connect to the Hidden Service:"
echo "ssh -p 42069 debian@${hidden_service_address}"

# Check and confirm the firewall (using iptables or nftables) is enabled and allowing traffic on port 42069
#iptables -L INPUT -v -n | grep "dpt:42069"
#nft list ruleset | grep "dport 42069"
#iptables -L INPUT -v -n | grep "dpt:42069" && nft list ruleset | grep "dport 42069" || echo "Firewall is not allowing traffic on port 42069" && echo "Please enable the firewall and allow traffic on port 42069"
#iptables -L INPUT -v -n | grep "dpt:42069" && nft list ruleset | grep "dport 42069" || echo "Firewall is not allowing traffic on port 42069" && echo "Please enable the firewall and allow traffic on port 42069" && exit