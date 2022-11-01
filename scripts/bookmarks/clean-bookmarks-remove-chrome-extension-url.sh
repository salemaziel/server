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

BOOKMARK_FILE=$1

if [[ ! $1 ]]; then
  echo_prompt "Bookmark file name:"
  read -r "BOOKMARK_FILE"
#        read -p "Bookmark file name: " "BOOKMARK_FILE"
fi

if [[ -z $(echo "$BOOKMARK_FILE" | grep "CLEARED") ]]; then
	echo_warn "$BOOKMARK_FILE is not a valid bookmark file"
	exit 0
else
	echo_info "Valid html file found: $BOOKMARK_FILE"
	sleep 1
fi



BOOKMARK_FILE_NAME="${BOOKMARK_FILE/%.html/}"
#BOOKMARK_FILE_TEXT=$(cat "$BOOKMARK_FILE")
#BOOKMARK_FILE_TEXT_LINE=$(printf '%s\n' "$line")

STRING_START='chrome-extension'
STRING_END='&uri='
NEW_STRING_END=''



############### TESTING SCRIPT BELOW - WORKED ###############

#while read -r line; do
#      BOOKMARK_FILE_TEXT_LINE=$(printf '%s\n' "$line")
#      CLEAN_BOOKMARKS="${BOOKMARK_FILE_TEXT_LINE/$STRING_START*$STRING_END/$NEW_STRING_END}"
#      echo -e "$CLEAN_BOOKMARKS" >> "${BOOKMARK_FILE_NAME}-chrome-extension-CLEARED.html"
#done < "$BOOKMARK_FILE"
#
#  printf "\ndone\n"

#echo -e "                                      "
#echo_warn "New bookmark file created named"
#echo_note " ${BOOKMARK_FILE_NAME}-chrome-extension-CLEARED.html"
#echo -e "                                      "
#sleep 1

#exit 0

############    TESTING SCRIPT ABOVE - Worked ########

### For Counting Time Estimated Left
## vars:
# LINE_COUNT=$(wc -l "$BOOKMARK_FILE" | awk '{ print $1 }')
# count=0
# total="$LINE_COUNT"
# start=$(date +%s)
#
# while [ $count -lt $total ]; do
#     *WORK/SCRIPT GOES HERE*
#
#      cur=$(date +%s)
#      count=$(($count + 1))
#      pd=$(($count * 73 / $total))
#      runtime=$(($cur - $start))
#      estremain=$((($runtime * $total / $count) - $runtime))
#      printf "\r%d.%d%% complete ($count of $total) - est %d:%0.2d remaining\e[K" $(($count * 100 / $total)) $((($count * 1000 / $total) % 10)) $(($estremain / 60)) $(($estremain % 60))
#  done
#  printf "\ndone\n"


### TEMPLATE ABOVE

### OLD SCRIPT BELOW




LINE_COUNT=$(wc -l "$BOOKMARK_FILE" | awk '{ print $1 }')
count=0
total="$LINE_COUNT"
start=$(date +%s)

while [ $count -lt $total ]; do
    while read -r line; do
      BOOKMARK_FILE_TEXT_LINE=$(printf '%s\n' "$line")
      CLEAN_BOOKMARKS="${BOOKMARK_FILE_TEXT_LINE/$STRING_START*$STRING_END/$NEW_STRING_END}"
      echo -e "$CLEAN_BOOKMARKS" >> "${BOOKMARK_FILE_NAME}-chrome-extension-CLEARED.html"
      cur=$(date +%s)
      count=$(($count + 1))
##      pd=$(($count * 73 / $total))
      runtime=$(($cur - $start))
      estremain=$((($runtime * $total / $count) - $runtime))
      printf "\r%d.%d%% complete ($count of $total) - est %d:%0.2d remaining\e[K" $(($count * 100 / $total)) $((($count * 1000 / $total) % 10)) $(($estremain / 60)) $(($estremain % 60))
      done < "$BOOKMARK_FILE"
  done
  printf "\ndone\n"

echo -e "                                      "
echo_warn "New bookmark file created named"
echo_note " ${BOOKMARK_FILE_NAME}-chrome-extension-CLEARED.html"
echo -e "                                      "
sleep 1
exit 0
