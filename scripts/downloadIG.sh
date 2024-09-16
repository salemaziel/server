#!/bin/bash


# Add color
ANSI_RED='\033[1;31m'
ANSI_YEL='\033[1;33m'
ANSI_GRN='\033[1;32m'
ANSI_WHT='\033[1;37m'
ANSI_RST='\033[0m'

# Define function to print colored text
print_color() {
  printf "%b%s%b\n" "$2" "$1" "$ANSI_RST"
}

# Variables
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"


#SCRIPT_DIR=$(dirname $(readlink -f $0))

CLIENT_ACCOUNT='premierpaintingprosla'
CLIENT_PHOTO_DIR="${SCRIPT_DIR}/${CLIENT_ACCOUNT}"
MY_ACCOUNT='viadelweb'

#USER_AGENT='Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.7113.93 Safari/537.36'
#USER_AGENT='Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.0.0 Safari/537.36'
#USER_AGENT='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.26 Safari/537.36'
#USER_AGENT='Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
USER_AGENT='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'

# Make sure instaloader command installed
if [[ -z $(command -v instaloader) ]]; then
    echo "Instaloader command not found; make sure it's downloaded and in your PATH, then try again"
    sleep 2
    exit
fi

# Check if connected to VPN; don't want to get downloading account banned
if [[ -n $(ip addr | grep -e "tun" -e "wg") ]]; then
    echo "You're connected to a vpn, you might get your account banned or get blocked from downloading. continue? [ y/n ]"
    sleep 1
    read "continue_dl"
    case $continue_dl in
        Y|y|yes)
            echo "continuing" 
            sleep 2
            ;;
        N|n|no)
            echo "quitting. disconnect from vpn and try again"
            sleep 3
            exit
            ;;
    esac
fi

read -p "Run logged in or no? [y/n] " "logged_in"

case $logged_in in
	y|yes)
	if [[ ! -d "$CLIENT_PHOTO_DIR" ]]; then
		instaloader --stories --tagged --no-compress-json --login="$MY_ACCOUNT" --user-agent "$USER_AGENT" "$CLIENT_ACCOUNT"

	elif [[ -d "$CLIENT_PHOTO_DIR" ]]; then
		instaloader --fast-update --stories --tagged --no-compress-json --login="$MY_ACCOUNT" --user-agent "$USER_AGENT" "$CLIENT_ACCOUNT"
	fi
	;;
	n)
        if [[ ! -d "$CLIENT_PHOTO_DIR" ]]; then
                instaloader --tagged --no-compress-json --user-agent "$USER_AGENT" "$CLIENT_ACCOUNT"

        elif [[ -d "$CLIENT_PHOTO_DIR" ]]; then
                instaloader --no-compress-json --user-agent "$USER_AGENT" "$CLIENT_ACCOUNT"
        fi
	;;
	*)
	print_color "Invalid. Quitting" "$ANSI_RED"
	exit 1
	;;
esac


