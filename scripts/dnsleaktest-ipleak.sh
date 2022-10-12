#!/bin/bash

SESSION=$(tr -cd '[:alnum:]' </dev/urandom | head -c40)

readonly SESSION="$SESSION"

SESSION_TMP=/tmp/.dns.tmp



random-char(){
	RANDOM_CHAR=$(tr -cd '[:alnum:]' </dev/urandom | head -c10)
}

check-ip-general(){

echo -e "Checking IP - General"
if [ -f "${SESSION_TMP}" ]; then
	echo -e "Reusing past session string for dns detection"
	RE_SESSION=$(cat ${SESSION_TMP})
	random-char
	curl https://"${RE_SESSION}"-"$RANDOM_CHAR".ipleak.net/json/﻿
	echo -e "\n"
else
	random-char
	echo $SESSION > "${SESSION_TMP}"
	curl https://"${SESSION}"-"$RANDOM_CHAR".ipleak.net/json/﻿
	echo -e "\n"
fi
}

check-ip-ipv4(){
echo -e "Checking IP - IPV4 only"
curl https://ipv4.ipleak.net/json/﻿
echo -e "\n"
}

check-ip-ipv6(){
if [ -f "${SESSION_TMP}" ]; then
	echo -e "Reusing past session string for dns detection"
	RE_SESSION=$(cat ${SESSION_TMP})
	random-char
	curl https://"${RE_SESSION}"-"$RANDOM_CHAR".ipv6.ipleak.net/json/﻿
	echo -e "\n"
else
	echo -e "Checking IP - IPV6 only"
	random-char
	echo $SESSION > "${SESSION_TMP}"
	curl https://"${SESSION}"-"$RANDOM_CHAR".ipv6.ipleak.net/json/﻿
	echo -e "\n"
fi
}

check-this-ip(){
if [ -f "${SESSION_TMP}" ]; then
	echo -e "Reusing past session string for dns detection"
	RE_SESSION=$(cat ${SESSION_TMP})
	random-char
	curl https://"${RE_SESSION}"-"$RANDOM_CHAR"
	echo -e "\n"
else
	echo -e "Enter an ip address to check in XML format: "
	read IP_ADDRESS
	random-char
	echo $SESSION > "${SESSION_TMP}"
	curl https://ipleak.net/xml/"$IP_ADDRESS"
	echo -e "\n"
fi
}

check-dns-detection(){
if [ -f "${SESSION_TMP}" ]; then
	echo -e "Reusing past session string for dns detection"
	RE_SESSION=$(cat ${SESSION_TMP})
	random-char
	curl https://"${RE_SESSION}"-"$RANDOM_CHAR".ipleak.net/dnsdetection/
	echo -e "\n"
else
	echo -e "Checking DNS Detection"
	random-char
	echo $SESSION > "${SESSION_TMP}"
	curl https://"${SESSION}"-"$RANDOM_CHAR".ipleak.net/dnsdetection/
	echo -e "\n"
fi
}


usage(){
    echo "Usage:"
    cat <<\EOF
	4			: Check IPV4 address only
	6			: Check IPV6 address only
	me myip			: Check IP - general
	ip			: Enter an IP address to check - XML format
	dns			: Check DNS detection
EOF
}


case "$1" in
	4)
		check-ip-ipv4
		;;
	6)
		check-ip-ipv6
		;;
	me|myip)
		check-ip-general
		;;
	dns)
		check-dns-detection
		;;
	*)
		usage
		;;
esac
