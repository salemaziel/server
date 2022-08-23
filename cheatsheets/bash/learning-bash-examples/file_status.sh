#!/bin/bash

echo "enter the file or directory name"

read data

echo "searching..."

DATA=$data

if [ -d $DATA ]; then
echo "Its an directory not a file"
else 
echo "Directory not exist"
fi

if [ -f $DATA ]; then 
echo "file exist"
else
echo "file didn't exist"
fi

if [ -r $DATA ]; then
echo "$DATA is readable"
else "$DATA don't have read permission"
fi
if [ -w $DATA ]; then
echo "$DATA is writable"
else
echo  "$DATA don't have write permission"
fi
if [ -x $DATA ]; then
echo "$DATA is executable"
else 
echo "$DATA don't have executable permission"
fi


