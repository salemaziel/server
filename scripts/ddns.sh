#!/bin/bash

set -e

OLD_IP=/root/myoldip.txt
MY_IP=/root/mycurrentip.txt
LOG=/root/mycurrentip.log

get_ip() {
	curl -sSL https://ifconfig.me
}

CURRENT_IP=$(cat "$MY_IP")
DETECTED_IP="$(get_ip)"

check_ip() {
if [ "$DETECTED_IP" == "$CURRENT_IP" ]; then
	exit 0
elif [ "$DETECTED_IP" != "$CURRENT_IP" ]; then
	CHANGED_MSG="IP Address detected as changed to $DETECTED_IP"
	echo -e "$CHANGED_MSG on: $(date)\n" >> "$LOG"
	cat "$MY_IP" > "$OLD_IP"
	echo "$DETECTED_IP" > /root/mycurrentip.txt

	local NTFY_USER=sam
	local NTFY_PASS='chinga.tu.madre!'

	curl -u "${NTFY_USER}:${NTFY_PASS}" -H "Title: Prox IP Address changed" -H "Tags: warning" -H "Priority: 4" -d "$CHANGED_MSG" https://ntfy.vdweb.cloud/alarms
else
	echo -e "An error occurred at $(date) \n" >> "$LOG"
	exit 1
fi
}


apexdomains=(
	"vdweb.cloud"
	"mackintosh.network"
)
## Get existing dns records and check if domains were already updated (avoid redundancy), and if they are pointing elsewhere and should not be updated
get_dns_records() {
	DO_RECORDS=/tmp/dorecords.txt
	doctl compute domain records list "$apexdomain" | grep -F " A " > "$DO_RECORDS" 2>&1 "$LOG"


	## Assign variable CURRENT_RECORD_DATA for each line of $(cat $DO_RECORDS | awk '{ print $4 }')


	## Compare string value of CURRENT_RECORD_DATA with $DETECTED_IP to check for match.
	## If they match, break/skip this line and continue checking the next line in $DO_RECORDS ; but if they do not match, check if $CURRENT_RECORD_DATA matches with OLD_IP


		## if $CURRENT_RECORD_DATA does not match $OLD_IP, break/skip this line and continue checking the next line in $DO_RECORD ; but if $CURRENT_RECORD_DATA matches $OLD_IP, continue



	## Assign variable RECORD_IDS for each line of $(cat $DO_RECORDS | awk '{ print $1 }')



	## export RECORD_IDS if $CURRENT_RECORD_DATA and $DETECTED_IP did not match



}


update_records()
	for apexdomain in "${apexdomains[@]}"; do
		get_dns_records
		for RECORD_ID in "${RECORD_IDS[@]}"; do
			doctl compute domain records update "$apexdomain" --record-id "$RECORD_ID" --record-data "$DETECTED_IP"
		done
	done
}



check_ip

if [ "$?" == "1" ]; then
	exit 1
fi


update_records
