#!/bin/bash

echo "Enter website"

read -p http:// "website"

code=200

check=$(curl -sSI http://$website | grep 200 | awk '{print $2}') 

echo "website code: $check"

if [ $check -eq $code ]; then

echo PING OUTPUT:

ping -c4 $website

echo "website is ok: $check"
else
echo "unable to load webpage"
fi


