#!/bin/bash

## Checks for name of wireguard interface
WG_IF=$(ifconfig -a | grep wg0 | awk '{ print $1 }' | sed 's/.$//')

## for testing
#echo $WG_IF

## Stops wireguard connection
sudo systemctl stop wg-quick@$WG_IF
