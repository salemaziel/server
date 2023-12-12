#!/bin/bash

## This script performs a secure delete of a specified drive using the ATA Secure Erase command.
## Remember to replace [sda] and mypassword with your actual drive name and password.
## (CHANGE DRIVE AND PASSWORD AS NEEDED)
# bash hdparm-ata-secure-delete2.sh /dev/[sda] mypassword

# Check that user is root or using sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root or using sudo"
    exit 1
fi

# Messages used in the script
PASSWORD_PROMPT="Enter the password for the drive: "
DRIVE_FROZEN_MESSAGE="Quitting. Unfreeze the drive first then run script again.\nPossible ways to do this: \n - Manually put computer to sleep, then wake it back up. \n - Run command echo -n mem > /sys/power/state \n"
INVALID_ANSWER_MESSAGE="Invalid answer, quitting."

# Command line arguments
DRIVE=$1
# Set password to second command line argument if provided, otherwise prompt for it, allowing for default of "melasleiza"
PASSWORD=${2:-melasleiza}

# Check if both a drive and password were provided
if [ -z "$DRIVE" ] && [ -z "$PASSWORD" ]; then
    echo "Usage to run non-interactively: $0 <drive> <password>"
    exit 1
fi

# Function to check if the drive is frozen
function check_drive_frozen_auto() {
    hdparm -I "$DRIVE" | grep -q "not     frozen"
    if [ $? -ne 0 ]; then
        echo "$DRIVE_FROZEN_MESSAGE"
        exit 1
    fi
}

# Function to run the secure erase command
function run_secure_erase_auto() {
    echo "Running ATA erase command on $DRIVE"
    time hdparm --user-master u --security-erase "$PASSWORD" "$DRIVE"
}

# Call the functions to run non-interactively
check_drive_frozen_auto
echo "$PASSWORD" | hdparm --user-master u --security-set-pass "$DRIVE"
run_secure_erase_auto



# Function to get the device name
function get_device_name() {
    # Dynamically generate device options
    options="($(lsblk -d -o name --noheadings))" # Dynamically generate device options
#     mapfile -t options < <(lsblk -d -o name | tail -n +2) # Dynamically generate device options; better than above?
    PS3="Enter device name (e.g. sda, sdb, hda, etc): "
    select DEVICE_NAME in "${options[@]}"; do
        if [[ -n $DEVICE_NAME ]]; then
            printf "%s" "You chose /dev/${DEVICE_NAME}, is that correct?\n"
            read -rp "Enter your choice [Y/n]: " CORRECT_DEVICE
            case $CORRECT_DEVICE in
                Y|y) printf "OK\n" ;;
                N|n) printf "Quitting, start over to enter correct device"; return 0 ;;
                *) printf "%s" "$INVALID_ANSWER_MESSAGE"; return 0 ;;
            esac
            break
        else
            printf "Invalid option. Please select a valid device name.\n"
        fi
    done

    printf "%s" "/dev/${DEVICE_NAME}"
}
# Function to check if the drive is frozen
function check_drive_frozen() {
    read -rp "Is drive frozen? [y/n]" DRIVE_FROZEN
    case $DRIVE_FROZEN in
        y|Y) printf "%s" "$DRIVE_FROZEN_MESSAGE"; return 0 ;;
        n|N) printf "%s" "Drive is not frozen? Last chance to cancel"; verify_drive_not_frozen ;;
        *) printf "%s" "$INVALID_ANSWER_MESSAGE"; return 0 ;;
    esac
}

# Function to verify if the drive is not frozen
function verify_drive_not_frozen() {
    read -rp "Drive is not frozen? [y/n] " VERIFY_NOTFROZEN
    case $VERIFY_NOTFROZEN in
        y) printf "Ok continuing" ;;
        n) printf "%s" "$DRIVE_FROZEN_MESSAGE"; return 0 ;;
        *) printf "%s" "$INVALID_ANSWER_MESSAGE"; return 0 ;;
    esac
}

# Display available devices
printf "Showing available devices\n"
read -p "Press enter to continue..."
lsblk -a
echo -e "\n" --------------------------------------- "\n"
echo -e "Devices: \n"
lsblk -d -o name --noheadings
read -p "Remember this MUST NOT be done over USB. SATA interface ONLY. Press enter to continue..."

# Get the device name
DRIVE=$(get_device_name)

printf "Check if device is frozen or not.\n"
printf "Should look similar to this: \n
--------------------------------------\n
Security:
       Master password revision code = 65534
               supported
       not     enabled
       not     locked
-->    not     frozen
       not     expired: security count
               supported: enhanced erase
       2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT. \n
---------------------------------------\n\n"
read -p "Press enter to continue..."

hdparm -I "$DRIVE"
printf "\n Is drive frozen? If yes cancel with Ctrl+c now, DO NOT CONTINUE!\n"
read -p "Press enter to continue..."

check_drive_frozen
#############################################

# Function to get the password
function get_password() {
    read -s -p "$PASSWORD_PROMPT" PASSWORD
    echo "$PASSWORD"| hdparm --user-master u --security-erase "$DRIVE"
}

# Function to run the secure erase command
function run_secure_erase() {
    read -rp "All good? [y/n] " ALL_GOOD
    case $ALL_GOOD in
        y) printf "%s" "Running ATA erase command on $DRIVE"; time hdparm --user-master u --security-erase "$PASSWORD" "$DRIVE" ;;
        n) printf "Damn that was close. Quitting"; return 1 ;;
        *) printf "%s" "$INVALID_ANSWER_MESSAGE"; return 0 ;;
    esac
}

printf "%s" "Setting user password for user-master u on $DRIVE \n"
read -p "Press enter to continue..."
PASSWORD=$(get_password)

printf "Check it was successful, should Enabled. Output of next command should look like: \n
-----------------------------------\n
Security:
       Master password revision code = 65534
               supported
 -->           enabled
       not     locked
       not     frozen
       not     expired: security count
               supported: enhanced erase
       Security level high
       2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT. \n\n
------------------------------------\n\n"
sleep 2

hdparm -I "$DRIVE"
printf "\n If all good, we'll run the secure erase command.\n"

run_secure_erase

printf "\n Lets verify it worked, output should look like below, saying Not Enabled: \n
----------------------------\n
Security:
       Master password revision code = 65534
               supported
-->    not     enabled
       not     locked
       not     frozen
       not     expired: security count
               supported: enhanced erase
       2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.\n\n
----------------------------\n\n"
sleep 1

hdparm -I "$DRIVE"

printf "If output doesn't match the Not Enabled part, try running this again, possibly manually.\n"
printf "Needed commands are at bottom of this script\n"
sleep 1

exit