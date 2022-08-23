#!/bin/bash

START=$(date +%s)
CURRENT_DIR=$(pwd)
sleep 5
END=$(date +%s)

DIFF=$(( END - START ))

echo
echo Time diff: $DIFF seconds  
