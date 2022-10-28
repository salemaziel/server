#!/bin/bash

set -eu -o pipefail

## Add some color

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

# shellcheck disable=SC2145
echo_cmd()    { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_prompt() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_note()   { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_info()   { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_warn()   { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_debug()  { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_fail()   { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }



# Set base directory
#MY_DIR=$(dirname $(readlink -f $0))
MY_DIR="$(realpath .)"


# Syschecks
source $MY_DIR/common/sys-checks

# Add text styling
# shellcheck source=common/text-styling.sh
source "$MY_DIR"/common/text-styling.sh

# Add functions
#source "$MY_DIR"/common/functions.sh
# shellcheck source=common/create-new-user.sh
source "$MY_DIR"/common/create-new-user.sh


# check if root or using sudo
super-user-check

# Choice to add new user with sudo privs
create-sudo-user

#echo -e "${COL_MAGENTA}Add new user with sudo privs? ${COL_RESET}"
#read new_user_choice
#if [ "$new_user_choice" == "y" ] || [ "$new_user_choice" == "Y" ]; then
#    add_usersudo
#elif [ "$new_user_choice" == "n" ] || [ "$new_user_choice" == "N" ]; then
#    echo -e "${COL_WHITE}Skipping new user add${COL_RESET}"
#else
#    echo "Invalid choice"
#    exit 1
#fi


# Make executable, install configs
chmod +x "$MY_DIR"/confs/install-confs.sh
"$MY_DIR"/confs/install-confs.sh





# Choice to Install Docker and Docker-Compose
echo -e "${COL_MAGENTA}Install Docker? ${COL_RESET}"
read docker_choice

if [ "$docker_choice" == "y" ] || [ "$docker_choice" == "Y" ]; then
    chmod +x "$MY_DIR"/dev_installs/install-docker-and-docker-compose.sh
    "$MY_DIR"/dev_installs/install-docker-and-docker-compose.sh
elif [ "$docker_choice" == "n" ] || [ "$docker_choice" == "N" ]; then
    echo -e "${COL_WHITE}Skipping Docker install${COL_RESET}"
else
    echo "Invalid choice"
    exit 1
fi
