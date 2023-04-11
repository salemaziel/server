#!/bin/bash

set -eu -o pipefail

# Variables
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
declare -r -x SCRIPT_DIR

# Add text styling, color, and print_color function
# shellcheck source=common/text-styling2023.sh
source "$SCRIPT_DIR"/common/text-styling2023.sh

# Set base directory



# Syschecks
source "$SCRIPT_DIR/common/sys-checks"



# Add functions
#source "$SCRIPT_DIR"/common/functions.sh
# shellcheck source=common/create-new-user.sh
source "$SCRIPT_DIR/common/create-new-user.sh"


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
chmod +x "$SCRIPT_DIR"/confs/install-confs.sh
"$SCRIPT_DIR"/confs/install-confs.sh





# Choice to Install Docker and Docker-Compose
if [ -z "$(print_color)" ]; then
    echo -e "${PRPL}Install Docker? ${RST}"
else 
    print_color  "Install Docker? [y/n] " "$PRPL"
fi
read -r docker_choice

if [ "$docker_choice" == "y" ] || [ "$docker_choice" == "Y" ]; then
    chmod +x "$SCRIPT_DIR"/dev_installs/install-docker-and-docker-compose.sh
    "$SCRIPT_DIR"/dev_installs/install-docker-and-docker-compose.sh
elif [ "$docker_choice" == "n" ] || [ "$docker_choice" == "N" ]; then
    echo -e "${COL_WHITE}Skipping Docker install${COL_RESET}"
else
    echo "Invalid choice"
    exit 1
fi
