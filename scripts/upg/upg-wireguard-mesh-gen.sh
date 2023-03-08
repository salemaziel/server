#!/bin/bash

# Generate a mesh network using Wireguard VPN protocol

# Install Wireguard
sudo apt-get install wireguard

# Generate a private key for each node
for node in $(seq 1 10); do
  wg genkey | tee node$node-private.key | wg pubkey > node$node-public.key
done

# Create a configuration file for each node
for node in $(seq 1 10); do
  echo "[Interface]" > node$node.conf
  echo "Address = 10.0.0.$node/24" >> node$node.conf
  echo "PrivateKey = $(cat node$node-private.key)" >> node$node.conf
  echo "" >> node$node.conf
  echo "[Peer]" >> node$node.conf
  for peer in $(seq 1 10); do
    if [ $peer -ne $node ]; then
      echo "PublicKey = $(cat node$peer-public.key)" >> node$node.conf
      echo "AllowedIPs = 10.0.0.$peer/32" >> node$node.conf
    fi
  done
done

# Start the Wireguard service on each node
for node in $(seq 1 10); do
  wg-quick up node$node.conf
done