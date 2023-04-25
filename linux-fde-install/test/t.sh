#!/bin/bash

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

# ...

main() {
  local first_disk=$(get_disk)
  echo "${first_disk}"
}

main
