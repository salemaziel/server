#!/bin/bash

Receiving=$(ifconfig | grep 'RX packets' | awk '{print $8}')

Transmission=$(ifconfig | grep 'TX packets')

echo TRANSMISSION : $Transmission

echo RECEIVING :$Receiving
