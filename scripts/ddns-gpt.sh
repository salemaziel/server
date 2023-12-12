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
	echo "$DETECTED_IP" > "$MY_IP"

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

get_dns_records() {
	DO_RECORDS=/tmp/dorecords.txt
	doctl compute domain records list "$apexdomain" | grep -F " A " > "$DO_RECORDS" 2>&1 "$LOG"

	RECORD_IDS=()
	while read -r line; do
		CURRENT_RECORD_DATA=$(echo "$line" | awk '{ print $4 }')
		if [ "$CURRENT_RECORD_DATA" != "$DETECTED_IP" ]; then
			if [ "$CURRENT_RECORD_DATA" == "$OLD_IP" ]; then
				RECORD_ID=$(echo "$line" | awk '{ print $1 }')
				RECORD_IDS+=("$RECORD_ID")
			fi
		fi
	done < "$DO_RECORDS"
	export RECORD_IDS
}

update_records() {
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

