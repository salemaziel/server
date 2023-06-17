#!/bin/bash

set -e

# Save the output of the printenv command to a variable
env_output=$(printenv)
#TMP_VAR_DATE=$(date +%Y%m%d-%H%M%S) # Use a more suitable date format
TMP_VAR_DATE=$(date +%Y-%m-%d_%A_%I:%M%p) # Use a more suitable date format
RANDOM_UID=$(shuf -i 1-420 -n 1)
ENV_TMPVARS_FILE="$HOME/env-wg-tmpvars-${TMP_VAR_DATE}-${RANDOM_UID}.txt"

echo -e "Saving missing env vars to $ENV_TMPVARS_FILE \n"

# Use an array to store the variable names
vars=(KDE_FULL_SESSION PATH KDE_APPLICATIONS_AS_SCOPE XDG_DATA_DIRS GOROOT VOLTA_HOME PLASMA_USE_QT_SCALING PAM_KWALLET5_LOGIN QT_WAYLAND_FORCE_DPI XDG_SESSION_TYPE XDG_SESSION_DESKTOP GTK2_RC_FILES XKB_DEFAULT_MODEL XDG_CONFIG_DIRS GOPATH WAYLAND_DISPLAY QT_ACCESSIBILITY DESKTOP_SESSION  DBUS_STARTER_BUS_TYPE XDG_SESSION_PATH GTK_IM_MODULE XDG_SEAT_PATH KDE_SESSION_UID XKB_DEFAULT_LAYOUT XDG_RUNTIME_DIR QT_AUTO_SCREEN_SCALE_FACTOR DBUS_SESSION_BUS_ADDRESS DBUS_STARTER_ADDRESS XDG_SEAT)

# Use a for loop to iterate through each variable (old)
#for var in KDE_FULL_SESSION PATH KDE_APPLICATIONS_AS_SCOPE XDG_DATA_DIRS GOROOT VOLTA_HOME PLASMA_USE_QT_SCALING PAM_KWALLET5_LOGIN QT_WAYLAND_FORCE_DPI XDG_SESSION_TYPE XDG_SESSION_DESKTOP GTK2_RC_FILES XKB_DEFAULT_MODEL  XDG_CONFIG_DIRS GOPATH WAYLAND_DISPLAY QT_ACCESSIBILITY DESKTOP_SESSION DBUS_STARTER_BUS_TYPE XDG_SESSION_PATH GTK_IM_MODULE XDG_SEAT_PATH    KDE_SESSION_UID XKB_DEFAULT_LAYOUT XDG_RUNTIME_DIR QT_AUTO_SCREEN_SCALE_FACTOR    DBUS_SESSION_BUS_ADDRESS DBUS_STARTER_ADDRESS XDG_SEAT; do

# Use a for loop to iterate through each variable
for var in "${vars[@]}"; do

    # Use grep to find the variable in the output and save its value
    value=$(echo "$env_output" | grep "^$var=" | cut -d'=' -f2-)

    # Check if the value is not empty
    if [ -n "$value" ]; then

        # Add the string exporting the variable with its value to a file to source later
        # export $var="$value"
        echo -e "export $var=$value" >> "$ENV_TMPVARS_FILE"
    fi

done


# Check if the file is not empty
if [ -s "$ENV_TMPVARS_FILE" ]; then
    echo -e "\nEnv vars saved successfully."
else
    echo -e "\nNo missing env vars found. Deleting created var file"
    rm "$ENV_TMPVARS_FILE" # Remove the empty file
fi
