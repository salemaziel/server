#!/bin/bash


## Add some color

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

# shellcheck disable=SC2145
echo_cmd() { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_prompt() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_note() { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_info() { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_warn() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_debug() { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_fail() { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }


# Variables

## Folder this script is in
SCRIPT_DIR=$(dirname $(readlink -f $0))

## Location of env file containing environment variables for USER and PASS
ENV_FILE="${SCRIPT_DIR}/.ntfy.env"

## Date and time for log entries
LOG_TIME=$(date +%I.%M-%p)

## Log location
LOG_FILE="${SCRIPT_DIR}/ntfy.log"


##### Start Script


## Sourcing env file for variable values
source "${ENV_FILE}"


#echo -e "$SCRIPT_DIR"

#echo -e "$ENV_FILE"

#echo -e "User is $USER"
#echo -e "Pass is $PASS"




## Set Notification title

### Prompt user for custom title
echo_prompt "\nAdd a Notification Title: [Press Enter for Default: Time For Bed]"
read "NTITLE"

### Set default if none
NOT_TITLE="${NTITLE:-Time for bed}"




## Set priority

### Prompt to enter priority level
echo_prompt "\nSet Priority: [ Default: is 4) urgent ]"
echo_info "* Sets volume/intensity of notification alert"
echo_info "* You can enter the number or the word"

echo_note "
4) high
5) urgent
"

read "PRIORITY"

### Set default priority at 4
USE_PRIORITY="${PRIORITY:-4}"



## Set Notification message

### Prompt for custom notification message
echo_prompt "\nAdd a Notification Message: [Press Enter for Default ] \n"
read "NMSG"

### Set default of blank message
NOT_MSG=${NMSG:-Go to sleep foo}

#if [[ -n "$NMSG" ]]; then
#	MSG="-d $NOT_MSG"
#elif [[ -z "$NMSG" ]]; then
#	MSG="-d ' '"
#else
#	MSG="-d ' '"
#fi

### Display settings for sending notification this time
echo -e  "${ANSI_GRN}\nUsing Notification Title:${ANSI_RST}${ANSI_WHT} $NOT_TITLE${ANSI_RST}
${ANSI_GRN}Priority level:${ANSI_RST}${ANSI_WHT} $USE_PRIORITY${ANSI_RST}
${ANSI_GRN}Notification message:${ANSI_RST}${ANSI_WHT} $NOT_MSG${ANSI_RST}
"

### Confirm sending notification with above settings
echo_prompt "Send? [yes/y OR no/n]"
echo_info "* Entering no or n cancels script; will need to restart it \n"

read "CONFIRM_SEND"

### Send notification if yes, quit if no, exit with warning 2 if invalid response
### Sent notifications are logged
case $CONFIRM_SEND in
	yes|y)
		echo_note "Sending notification"
		curl -u "${USER}:${PASS}" -H "Title: $NOT_TITLE" -H "Tags: warning,alarm_clock" -H "Priority: $USE_PRIORITY" -d "$NOT_MSG" https://ntfy.vdweb.cloud/alarms

		cat > "${LOG_FILE}" <<-EOF
			---------------------------------

			    Last ran at:  "{LOG_TIME}"

			---------------------------------
		EOF
	;;
	no|n)
		echo_warn "Quitting. Re-run script please"
		sleep 0.5
		exit 1
	;;
	*)
		echo_fail "Invalid entry. Quitting. Please re-run script"
		sleep 0.5
		exit 2
	;;
esac
