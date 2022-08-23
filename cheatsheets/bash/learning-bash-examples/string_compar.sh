#!/bin/bash

STR1="string1"
STR2="string2"

echo "enter STR1"
read string1
echo $STR1

echo STR2
read string2
echo $STR2

if [ "$STR1" = "$STR2" ]; then
echo same
else
echo "not same"
fi
