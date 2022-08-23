#!/bin/bash

THRESHOLD=40
SPACE=$(df -h | grep /dev/sda3 | awk '{print $5}'| cut -d'%' -f1)
if [ $SPACE -gt $THRESHOLD ]; then
echo "Disk is almost full and current disk usage is $SPACE % and the alert threshold is $THRESHOLD %"
echo "E-mail notification was sent to ***"
mail -s "Disk usage alers form ***" your mail ID <<< "Hi, disk space is almost full. kindly fix the issue ASAP ***"
else
echo "Disk is normal and the current usage is $SPACE %"
fi
