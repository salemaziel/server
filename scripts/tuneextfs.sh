#!/bin/bash

# Check if the user is root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Check if tune2fs is installed
if ! [ -x "$(command -v tune2fs)" ]; then
  echo 'Error: tune2fs is not installed.' >&2
  exit 1
fi

# Check if dumpe2fs is installed
if ! [ -x "$(command -v dumpe2fs)" ]; then
  echo 'Error: dumpe2fs is not installed.' >&2
  exit 1
fi

# Check if device path is passed as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 device_path" >&2
    exit 1
fi

device_path=$1

# Check the filesystem type
fs_type=$(blkid -o value -s TYPE "${device_path}")
if [ "$fs_type" != "ext4" ]; then
    echo "Error: Filesystem type of $device_path is not ext4." >&2
    exit 1
fi

# Check the current filesystem space used by ext4 journaling
echo "Checking current filesystem space used by ext4 journaling..."
dumpe2fs "$device_path" 2>/dev/null | grep -i "Journal size"

# Ask for user confirmation before reducing the journal size
read -rp "Are you sure you want to reduce the journal size to 32M on $device_path? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    # Reduce the journal size to 32M
    if ! tune2fs -J size=32 "$device_path"; then
        echo "Error: Failed to reduce the journal size." >&2
        exit 1
    fi
else
    echo "Operation cancelled by user."
    exit 1
fi
