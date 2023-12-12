#!/bin/bash

set -euo pipefail

# Save the output of the printenv command to a variable
env_output=$(printenv)
TMP_VAR_DATE=$(date +%Y-%m-%d_%A_%I:%M%p) # Use a more suitable date format
RANDOM_UID=$(shuf -i 1-420 -n 1)
ENV_TMPVARS_FILE="$HOME/env-wg-tmpvars-${TMP_VAR_DATE}-${RANDOM_UID}.txt"

find_oldvars(){
    cd "$HOME" || return
    find "$HOME" -maxdepth 1 -name "env-wg-tmpvars-*.txt"
}

OLDVARS=$(find_oldvars)

if [[ -n "$OLDVARS" ]]; then
    echo -e "Old var files found: $OLDVARS\n"
    echo -e "Delete past env wg tmp file(s)? (default yes) [Y/n] "
    read -r DELETE_OLD
    case $DELETE_OLD in
        Y|Yes|YES|y|yes|"")
            rm -i "$OLDVARS"
            ;;
        N|No|NO|no|n)
            echo -e "Leaving $OLDVARS alone"
            ;;
        *)
            echo -e "Invalid response. Using default \n"
            rm -i "$OLDVARS"
            ;;
    esac
fi

vars=(KDE_FULL_SESSION PATH KDE_APPLICATIONS_AS_SCOPE XDG_DATA_DIRS GOROOT VOLTA_HOME PLASMA_USE_QT_SCALING PAM_KWALLET5_LOGIN QT_WAYLAND_FORCE_DPI XDG_SESSION_TYPE XDG_SESSION_DESKTOP GTK2_RC_FILES XKB_DEFAULT_MODEL XDG_CONFIG_DIRS GOPATH WAYLAND_DISPLAY QT_ACCESSIBILITY DESKTOP_SESSION  DBUS_STARTER_BUS_TYPE XDG_SESSION_PATH GTK_IM_MODULE XDG_SEAT_PATH KDE_SESSION_UID XKB_DEFAULT_LAYOUT XDG_RUNTIME_DIR QT_AUTO_SCREEN_SCALE_FACTOR DBUS_SESSION_BUS_ADDRESS DBUS_STARTER_ADDRESS XDG_SEAT)

for var in "${vars[@]}"; do
    value=$(echo "$env_output" | grep "^$var=" | cut -d'=' -f2-)
    if [ -n "$value" ]; then
        echo -e "export $var=$value" >> "$ENV_TMPVARS_FILE"
    fi
done

if [ -s "$ENV_TMPVARS_FILE" ]; then
    echo -e "\nEnv vars saved successfully."
else
    echo -e "\nNo missing env vars found. Deleting created var file"
    rm -- "$ENV_TMPVARS_FILE" # Remove the empty file
fi
