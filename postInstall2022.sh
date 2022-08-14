#!/bin/bash

set -eu -o pipefail

# Set base directory
MY_DIR=$(dirname $(readlink -f $0))

# Add text styling
source "$MY_DIR"/common/text-styling.sh

# Add functions
source "$MY_DIR"/common/functions.sh



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


# Choice to add new user with sudo privs
echo -e "${COL_MAGENTA}Add new user with sudo privs? ${COL_RESET}"
read new_user_choice
if [ "$new_user_choice" == "y" ] || [ "$new_user_choice" == "Y" ]; then
    add_usersudo
elif [ "$new_user_choice" == "n" ] || [ "$new_user_choice" == "N" ]; then
    echo -e "${COL_WHITE}Skipping new user add${COL_RESET}"
else
    echo "Invalid choice"
    exit 1
fi