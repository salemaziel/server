#!/bin/bash

Threshold=1

load=$(cat /proc/loadavg | awk '{print $1}'| cut -d'.' -f1)

if [ $load -gt $Threshold ] ; then
echo "$load is higher"

else  

echo "$load is normal"

fi
