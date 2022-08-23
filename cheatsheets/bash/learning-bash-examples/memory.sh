#!/bin/bash

set -x

echo reading server memory

MEMORY=$(free -m -h | grep Mem | awk '{print $7}'| cut -d'M' -f1)

echo $MEMORY


THRESHOLD=300

if [ $MEMORY -lt $THRESHOLD ]; then
echo "Memory is normal"
#mail -s "Memory is critical for the server "IP email" <<< "message"
else
echo "Memory is critical" 
fi
