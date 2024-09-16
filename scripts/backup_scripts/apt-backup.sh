#!/bin/bash

# Define color variables
ANSI_RED='\033[1;31m'
ANSI_YEL='\033[1;33m'
ANSI_GRN='\033[1;32m'
ANSI_VIO='\033[1;35m'
ANSI_BLU='\033[1;36m'
ANSI_WHT='\033[1;37m'
ANSI_RST='\033[0m'

# Function to print colored messages
echo_cmd()    { echo -e "${ANSI_BLU}$*${ANSI_RST}"; }
echo_prompt() { echo -e "${ANSI_YEL}$*${ANSI_RST}"; }
echo_note()   { echo -e "${ANSI_GRN}$*${ANSI_RST}"; }
echo_info()   { echo -e "${ANSI_WHT}$*${ANSI_RST}"; }
echo_warn()   { echo -e "${ANSI_YEL}$*${ANSI_RST}"; }
echo_debug()  { echo -e "${ANSI_VIO}$*${ANSI_RST}"; }
echo_fail()   { echo -e "${ANSI_RED}$*${ANSI_RST}"; }

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    echo_fail "sudo could not be found. Please install sudo or run this script as root."
    exit 1
fi

# Check if necessary commands are available
for cmd in dpkg rsync apt-key; do
    if ! command -v $cmd &> /dev/null; then
        echo_fail "$cmd could not be found. Please install $cmd before running this script."
        exit 1
    fi
done

# Create backup directory
backup_dir="$HOME/aptReinstalling.$(date -I)"
echo_info "Creating directory $backup_dir to save files into"
mkdir -p "$backup_dir" || { echo_fail "Failed to create directory $backup_dir"; exit 1; }

# Save list of installed packages
sudo dpkg --get-selections > "$backup_dir/Package.list" || { echo_fail "Failed to save list of installed packages"; exit 1; }
echo_note "Saved list of installed packages in Package.list"

# Copy APT sources
echo_info "Copying your /etc/apt/sources.list and sources.list.d/* to $backup_dir"
sudo rsync -avzh /etc/apt/sources.list* "$backup_dir/" || { echo_fail "Failed to copy APT sources"; exit 1; }

# Export Repo GPG keys
echo_info "Exporting Repo GPG keys to Repo.keys"
sudo apt-key exportall > "$backup_dir/Repo.keys" || { echo_fail "Failed to export Repo GPG keys"; exit 1; }
echo_note "You can safely ignore the warning about apt-key output"

# Copy /etc/apt folder
echo_info "Copying your /etc/apt folder to $backup_dir/etc/apt"
mkdir -p "$backup_dir/etc"
sudo rsync -avzh /etc/apt "$backup_dir/etc/" || { echo_fail "Failed to copy /etc/apt folder"; exit 1; }

# Copy sysctl configurations
echo_info "Copying your /etc/sysctl.conf and /etc/sysctl.d/* to $backup_dir/etc/"
sudo rsync -avzh /etc/sysctl.conf "$backup_dir/etc/" || { echo_fail "Failed to copy sysctl configurations"; exit 1; }
sudo rsync -avzh /etc/sysctl.d "$backup_dir/etc/" || { echo_fail "Failed to copy sysctl configurations"; exit 1; }

# Copy GRUB configurations
echo_info "Copying your /etc/default/grub.d to $backup_dir/etc/default/"
mkdir -p "$backup_dir/etc/default/"
sudo rsync -avzh /etc/default/grub.d "$backup_dir/etc/default/" || { echo_fail "Failed to copy GRUB configurations"; exit 1; }

# Prompt for backing up local programs
read -p "Are there locally/manually installed programs you want to back up as well? [y/n] " -r backup_local

if [[ $backup_local == 'y' ]]; then
    echo_note "Ok."
    read -p "Are they located in your /opt and or /usr/local/bin folders? [y/n] " -r opt_usrlocbin
    if [[ $opt_usrlocbin == 'y' ]]; then
        echo_info "Backing up /opt and /usr/local/bin directories"
        sudo rsync -avzh /opt "$backup_dir/" || { echo_fail "Failed to back up /opt folder"; exit 1; }
        echo_note "Finished backing up /opt folder"
        sudo rsync -avzh /usr/local/bin "$backup_dir/" || { echo_fail "Failed to back up /usr/local/bin folder"; exit 1; }
        echo_note "Finished backing up /usr/local/bin folder"
    else
        echo_info "You can use the rsync command to back up other directories manually."
        echo_info "Example: rsync -avzh /path/to/directory/you/want $backup_dir/"
    fi
else
    echo_note "OK, skipping local programs backup."
fi

# Copy the reinstallation script
echo_info "Copying the reinstallation script into your $backup_dir folder"
cp Reinstall_savedApt.sh "$backup_dir/" || { echo_fail "Failed to copy the reinstallation script"; exit 1; }

echo_note "Done! Make sure to save the folder $backup_dir somewhere safe."
