#!/bin/bash

set -eo pipefail

INSTALL_VERSION=""

usage() {
    echo -e "\nUsage: bash install-go.sh [ --version <go_version> | --help ]\n"
}

# Parse
#   bash install-go.sh --help
# or
#   bash install-go.sh --version <go_version>
function parse_args(){
if [ -n "${1-}" ]; then
    if [ "${1-}" == "--help" ]; then
        usage
        exit 0
    elif [ "${1-}" == "--version" ]; then
        if [ -z "$2" ]; then
            echo -e "Error: --version requires a version argument\n"
            usage
            exit 1
        fi
    fi 
elif [ -z "${1-}" ]; then
        usage
        exit 1
fi
INSTALL_VERSION="${2-}"
}

# Set Go Version Filename
function go_version_filename(){
filename=""

arch="$(uname -m)"
kernel="$(uname -s)"
sourced_env_vars_file=".bashrc"

if [ "${kernel}" == "Linux" ]; then
    case "${arch}" in
        "x86")
            filename="go${INSTALL_VERSION}.linux-386.tar.gz"
            ;;
        "x86_64")
            filename="go${INSTALL_VERSION}.linux-amd64.tar.gz"
            ;;
        "armv6l" | "armv7l")  # No armv7l version exists; use armv6l
            filename="go${INSTALL_VERSION}.linux-armv6l.tar.gz"
            ;;
        "armv8l")
            filename="go${INSTALL_VERSION}.linux-arm64.tar.gz"
            ;;
        "*")
            echo "Architecture ${arch} not recognized; exiting"
            exit 1
    esac
else  # Assume macOS
    sourced_env_vars_file=".profile"
    case "${arch}" in
        "x86")
            filename="go${INSTALL_VERSION}.darwin-386.tar.gz"
            ;;
        "x86_64")
            filename="go${INSTALL_VERSION}.darwin-amd64.tar.gz"
            ;;
        "*")
            echo "Architecture ${arch} not recognized; exiting"
            exit 1
    esac
fi
}

# Download Go
function download_go(){
dest="/tmp/$filename"

echo "Downloading $filename ..."
wget https://go.dev/dl/$filename -O $dest

if [ $? -ne 0 ]; then
    echo "Download failed! Exiting."
    exit 1
fi
}

# Extract Go to Home Directory
function extract_home_dir(){
echo "Extracting $filename ..."
tar -C "$HOME" -xzf $dest

echo '
export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin' >> "$HOME/${sourced_env_vars_file}"
}

# Extract Go to /usr/local Directory
function extract_usr_local(){
INSTALL_PATH="/usr/local"
INSTALL_DIR="/usr/local/go"

if [ -d "$INSTALL_DIR" ]; then
    echo "Removing existing $INSTALL_DIR ..."
    sudo rm -rf "$INSTALL_DIR"
fi

echo "Extracting $filename ..."
sudo tar -C "$INSTALL_PATH" -xzf $dest


# Set permissions on /usr/local/go - root:usrlocbin if exists, else root:root
if [ ! "$(grep usrlocbin /etc/passwd)" ]; then
    sudo chown -R root:root "$INSTALL_DIR"
else
    sudo chown -R root:usrlocbin "$INSTALL_DIR"
    sudo chmod -R 0750 "$INSTALL_DIR"
fi

# Add to path
echo '
# Go
export PATH=$PATH:$INSTALL_DIR/bin
' >> "$HOME/${sourced_env_vars_file}"
}

# Install success
function install_success(){
# Only print this if this script is being run interactively
if [ -n "$PS1" ]; then
    echo 'Success! Now open a new terminal or type

    source ~/'${sourced_env_vars_file}'

then run this to make sure it worked:

    go version
'
fi

# Clean up
rm "$dest"

}

# Install Go in Home Directory
function install_home_dir(){

# Make sure we haven't already installed Go
if [ -d "$HOME/go" ] || [ -d "$HOME/gocode" ]; then
    echo "$HOME/go or $HOME/gocode already exists; exiting"
    exit 1
fi

# Get Go version filename
go_version_filename

# Download file
download_go

# Unpack
extract_home_dir

#  Install success
install_success
}



# Install Go in Home Directory
function install_usr_local(){

# Get Go version filename
go_version_filename

# Download file
download_go

# Unpack
extract_usr_local

# Install success
install_success
}


# Main

# Parse args
parse_args "$@"

read -p "Install Go in Home directory or /usr/local? [h/usr] " "where_install"

if [ -z "$where_install" ] || [ "$where_install" == "usr" ] || [ "$where_install" == "u" ]; then
    install_usr_local
elif [ "$where_install" == "h" ]; then
    install_usr_local
else
    echo "Invalid option; exiting"
    exit 1
fi