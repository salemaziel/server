#!/usr/bin/env bash

# This script is used to prepare a disk for full disk encryption on Linux.
# It prompts the user to enter the disk name, checks if the disk exists, and then offers the option to wipe the disk using either a slow or quick method.
# The script uses the cryptsetup utility to open the disk, perform the wipe operation, and then close the disk.
# The wipe operation can be performed on a single disk or on a second disk if the user chooses to do so.
# The wipe method can be selected as either slow (using dd if=/dev/zero) or quick (using openssl + dd).
# After the wipe operation is completed, the script exits with a status code of 0.

DISK="$1"

set -eu -o pipefail

# Add color
readonly RED='\033[1;31m'
readonly YEL='\033[1;33m'
readonly GRN='\033[1;32m'
readonly PRPL='\033[1;35m'
readonly RST='\033[0m'

# Define function to print colored text
print_color() {
  printf "%b%s%b\n" "$2" "$1" "$RST"
}

# Check if DISK variable is set; if not, ask for it to set it. When DISK is set, check if it is a valid disk and print it to standard output for user to see, then export the DISK variable for use in other bash functions or elsewhere in the script.
get_disk() {
  while true; do
    if [[ -z "${DISK}" ]]; then
      print_color "Enter disk (e.g., sda, hda, mmcblk0, nvme0n1):" "$PRPL"
      print_color "Do not include full path i.e., /dev/; it will be added automatically." "$YEL"
      read -r DISK
      echo "/dev/${DISK}"
    fi

    if [[ -b "/dev/${DISK}" ]]; then
      break
    else
      print_color "Disk /dev/${DISK} does not exist. Please enter a valid disk." "$RED"
      unset DISK
    fi
  done

  echo "/dev/${DISK}"
}

# Function to wipe the disk using the specified wipe method
wipe_disk() {
  local disk_path=$1
  local wipe_method=$2

  print_color "Wiping ${disk_path} with method: ${wipe_method}" "$YEL"

  if ! cryptsetup open --type plain -d /dev/urandom "${disk_path}" to_be_wiped; then
    print_color "Failed to open ${disk_path} with cryptsetup. Exiting." "$RED"
    exit 1
  fi

  local DEVICE=/dev/mapper/to_be_wiped

  if [[ "${wipe_method}" == "slow" ]]; then
    dd if=/dev/zero obs=64K ibs=4K of="${DEVICE}" oflag=direct status=progress
  elif [[ "${wipe_method}" == "quick" ]]; then
    local PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128);
    openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of="${DEVICE}" oflag=direct status=progress
  fi


  cryptsetup close to_be_wiped

  print_color "${disk_path} wiped!" "$GRN"
}

# Main function
main() {
  local first_disk
  local second_disk=""
  first_disk=$(get_disk)

  print_color "Do you want to wipe a second disk? [y/n]" "$PRPL"
  read -r second_disk_choice
  if [[ "${second_disk_choice}" == "y" ]]; then
    second_disk=$(get_disk)
  fi

  PS3="${PRPL}Enter your choice [1-2]:${RST} "
  select wipe_method in "Slow (dd if=/dev/zero)" "Quick (using openssl + dd)"; do
    case $wipe_method in
    "Slow (dd if=/dev/zero)")
      wipe_method="slow"
      break
      ;;
    "Quick (using openssl + dd)")
      wipe_method="quick"
      break
      ;;
    *) echo "Invalid choice. Please enter a valid number." ;;
    esac
  done

  wipe_disk "${first_disk}" "${wipe_method}"
  if [[ -n "${second_disk}" ]]; then
    wipe_disk "${second_disk}" "${wipe_method}"
  fi
}

# Call the main function
main

# Exit with status code 0
exit 0