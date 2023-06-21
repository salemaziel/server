#!/bin/bash

set -eu -o pipefail

# Variables - Set base directory
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
declare -r -x SCRIPT_DIR

# Add text styling, color, and print_color function
# shellcheck source=common/text-styling2023
source "$SCRIPT_DIR"/common/styling

# Syschecks
source "$SCRIPT_DIR/common/sys-checks"

## Display Welcome to Post Installer
echo_note '
    ____                  __       
   / __ \  ___    ____   / /_      
  / /_/ / / __ \ / ___/ / __/ ______
 / ____/ / /_/ /(__   )/ /_  /_____/
/_/      \____/ /____/ \__/        
                                 '
                                                                                           
echo_note '
    ____              __           __ __           
   /  _/____   _____ / /_  ____ _ / // /___   _____
   / / / __ \ / ___// __/ / __ `// // // _ \ / ___/
 _/ / / / / / \__  )/ /_ / /_/ // // //  __// /    
/___//_/ /_/ /____/ \__/ \__,_//_//_/ \___//_/  

'

sleep 1


# check if root or using sudo
super-user-check


# shellcheck source=common/create-new-user.func
source "$SCRIPT_DIR/common/create-new-user.func"

# Choice to add new user with sudo privs
create-sudo-user

# Make executable, install configs
chmod +x "$SCRIPT_DIR"/confs/install-confs.sh
"$SCRIPT_DIR"/confs/install-confs.sh

# Add functions
source "$SCRIPT_DIR"/common/functions.func


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
