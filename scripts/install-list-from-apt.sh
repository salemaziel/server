#!/bin/bash

# Check if being run by root
if [ "$EUID" -ne 0 ]
  then
    # Prompt the user for password to use sudo
    echo "Please enter your password to use sudo:"
    read -s SUDO_PASSWORD
    # Define all currently installed nvidia packages
    NVIDIA_PACKAGES=$(apt list --installed | grep nvidia | cut -d / -f 1) # awk '{print $1}')

      # Read each line of NVIDIA_PACKAGES separately and run apt install --reinstall on each line
      while read -r line; do
        # Use sudo to run apt to reinstall all currently installed nvidia packages, redirecting stderr to /dev/null
        echo "$SUDO_PASSWORD" | sudo -S apt install --reinstall $line
      done <<< "$NVIDIA_PACKAGES"
fi


#nvidia_packages=$(apt list --installed | grep nvidia | awk '{print $1}')