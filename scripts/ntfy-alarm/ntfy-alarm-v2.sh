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
ENV_FILE="$SCRIPT_DIR/.ntfy.env"

# Check for env file and source it
if [[ ! -f "${ENV_FILE}" ]]; then
	print_color "Missing .ntfy.env file in script directory" "$ANSI_RED"
	sleep 1
	print_color "Creating .ntfy.env file from example template \n" "$ANSI_WHT"
	print_color "Please edit .ntfy.env file with your USER and PASS values from defaults 'user' and 'pass' ; these will not work and cause this script to fail. After editing, re-run this script." "$ANSI_YEL"
	if [[ ! -f "${SCRIPT_DIR}/.ntfy.env.example" ]]; then
        print_color "Missing .ntfy.env.example file in script directory" "$ANSI_RED"
        print_color "Creating it" "$ANSI_WHT"
        touch "${SCRIPT_DIR}/.ntfy.env.example"
        echo "USER=user" >> "${SCRIPT_DIR}/.ntfy.env.example"
        echo "PASS='pass'" >> "${SCRIPT_DIR}/.ntfy.env.example"
        cp "${SCRIPT_DIR}/.ntfy.env.example" "${ENV_FILE}"
        exit 1
	else
        cp "${SCRIPT_DIR}/.ntfy.env.example" "${ENV_FILE}"
        exit 1
    fi
else
	# shellcheck source=ntfy-alarm/.ntfy.env
	source "${ENV_FILE}"
fi

# Set notification title
print_color "Add a Notification Title: [Press Enter for Default: Time For Bed]" "$ANSI_YEL"
read -r NTITLE
NOT_TITLE="${NTITLE:-Time for bed}"

# Set priority
print_color "Set Priority: [Default: 4 (high)]" "$ANSI_YEL"
print_color "* Sets volume/intensity of notification alert" "$ANSI_WHT"
print_color "* You can enter the number or the word" "$ANSI_WHT"
printf "\n%b\n" "4) high\n5) urgent" "$ANSI_RST"
read -r PRIORITY
USE_PRIORITY="${PRIORITY:-4}"

# Set notification message
print_color "Add a Notification Message: [Press Enter for Default]" "$ANSI_YEL"
read -r NMSG
NOT_MSG="${NMSG:-Go to sleep foo}"

# Display settings for sending notification
printf "%b\n" "${ANSI_GRN}Using Notification Title:${ANSI_RST}${ANSI_WHT} $NOT_TITLE${ANSI_RST}"
printf "%b\n" "${ANSI_GRN}Priority level:${ANSI_RST}${ANSI_WHT} $USE_PRIORITY${ANSI_RST}"
printf "%b\n" "${ANSI_GRN}Notification message:${ANSI_RST}${ANSI_WHT} $NOT_MSG${ANSI_RST}"
echo ""
# Confirm sending notification with above settings
print_color "Send? [yes/y OR no/n]" "$ANSI_YEL"
print_color "* Entering no or n cancels script; will need to restart it \n" "$ANSI_WHT"
read -r CONFIRM_SEND

# Send notification if yes, quit if no, exit with warning 2 if invalid response
case $CONFIRM_SEND in
    yes|y|$'\0A')
        print_color "Sending notification" "$ANSI_GRN"
        curl -u "${USER}:${PASS}" -H "Title: $NOT_TITLE" -H "Tags: warning,alarm_clock" -H "Priority: $USE_PRIORITY" -d "$NOT_MSG" https://ntfy.vdweb.cloud/alarms
        cat > "${SCRIPT_DIR}/ntfy.log" <<-EOF
            ---------------------------------

                Last ran at:  "$(date)"

            ---------------------------------
EOF
    ;;
    no|n)
        print_color "Quitting. Re-run script please" "$ANSI_YEL"
        sleep 0.5
        exit 1
    ;;
    *)
        print_color "Invalid entry. Quitting. Please re-run script" "$ANSI_RED"
        sleep 0.5
        exit 2
    ;;
esac
