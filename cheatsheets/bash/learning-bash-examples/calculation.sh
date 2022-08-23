#!/bin/bash

NUM=$1
NUM2=$2

if [ $# -ne 2 ]; then
echo "======================================"
echo "Enter two arguments ( number)"
exit 1
fi

let RESULT=NUM*NUM2

Exit_status=$?

echo "Exit status is: $Exit_status"

if ! [ $Exit_status -eq 0 ]; then
echo "==========================================="
echo "Error in script **SCRIPT SUCKS**"
exit 2
else

echo "==========================================="

echo "$NUM * $NUM2 is below"
echo "script executed successfully the result is: $RESULT"
fi




