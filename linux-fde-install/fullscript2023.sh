#!/usr/bin/env bash

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

get_disk() {
  print_color "Enter disk (e.g., sda, hda, mmcblk0, nvme0n1):" "$PRPL"
  print_color "Do not include full path i.e., /dev/; it will be added automatically." "$YEL"
  read -r disk
  echo "/dev/${disk}"
}

wipe_disk() {
  local disk_path=$1
  local wipe_method=$2

  print_color "Wiping ${disk_path} with method: ${wipe_method}" "$YEL"

  cryptsetup open --type plain -d /dev/urandom "${disk_path}" to_be_wiped

  local DEVICE=/dev/mapper/to_be_wiped

  if [[ "${wipe_method}" == "slow" ]]; then
    dd if=/dev/zero obs=64K ibs=4K of="${DEVICE}" oflag=direct status=progress
  else
    local PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
    openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of="${DEVICE}" oflag=direct status=progress
  fi

  cryptsetup close to_be_wiped
  print_color "${disk_path} wiped!" "$GRN"
}

main() {
  local first_disk=$(get_disk)
  local second_disk=""
  
  print_color "Do you want to wipe a second disk? [y/n]" "$PRPL"
  read -r second_disk_choice
  if [[ "${second_disk_choice}" == "y" ]]; then
    second_disk=$(get_disk)
  fi

  print_color "Choose a wipe method:" "$PRPL"
  print_color "1) Slow (dd if=/dev/zero)" "$YEL"
  print_color "2) Quick (using openssl + dd)" "$YEL"
  read -rp "${PRPL}Enter your choice [1-2]:${RST} " method_choice

  local wipe_method="slow"
  if [[ "${method_choice}" == "2" ]]; then
    wipe_method="quick"
  fi

  wipe_disk "${first_disk}" "${wipe_method}"
  if [[ -n "${second_disk}" ]]; then
    wipe_disk "${second_disk}" "${wipe_method}"
  fi

  # Create a partition on the wiped disk
  parted -s "${first_disk}" mklabel gpt
  parted -s "${first_disk}" mkpart primary 1MiB 100%

  # Set up LUKS on the partition
  cryptsetup luksFormat "${first_disk}1"

  # Open the encrypted partition
  cryptsetup open "${first_disk}1" luks

  # Create a file system on the mapped LUKS partition
  mkfs.ext4 /dev/mapper/luks

  # Mount the new file system
  mount /dev/mapper/luks /mnt

  # Perform any additional setup or configuration on the
  # mounted file system, such as installing an OS, copying
  # files, etc.

  # When you are done with the setup, unmount the file system
  umount /mnt

  # Close the LUKS partition
  cryptsetup close luks

  print_color "LUKS setup complete!" "$GRN"
}

main
exit 0
