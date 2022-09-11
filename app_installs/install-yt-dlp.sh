#!/bin/bash


# Remove old yt-dlp from package manager
sudo apt -y purge yt-dlp


# Install dependencies
sudo apt install -y python3-certifi brotli python3-brotli python3 python-is-python3 python3-websockets python3-mutagen atomicparsley python3-pycryptodome python3-secretstorage



cd /tmp || return


mkdir phantomjs
cd phantomjs || return
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2

tar xvf phantomjs-2.1.1-linux-x86_64.tar.bz2

cd phantomjs-2.1.1-linux-x86_64/bin || return
sudo cp phantomjs /usr/local/bin/phantomjs

DIR_OWNER="$(stat -c %U /usr/local/bin)"
DIR_GROUP="$(stat -c %G /usr/local/bin)"
sudo chown -R "${DIR_OWNER}":"${DIR_GROUP}" /usr/local/bin/
sudo chmod a+rx /usr/local/bin/phantomjs




if [[ -z $(command -v wget ) ]]; then
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
elif [[ -z $(command -v curl ) ]]; then
    sudo wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O /usr/local/bin/yt-dlp
else
    echo -e "Neither wget nor curl are installed."
    read -rp "Install wget or curl or both? [w/c/b] " -n 1 -r
        case $REPLY in
            w)
                sudo apt install -y wget
                ;;
            c)
                sudo apt install -y curl
                ;;
            b)
                sudo apt install -y wget curl
                ;;
            *) 
                echo -e "Invalid option. Exiting."
                exit 1
                ;;
        esac
fi


sudo chmod a+rx /usr/local/bin/yt-dlp  # Make executable

DIR_OWNER="$(stat -c %U /usr/local/bin)"
DIR_GROUP="$(stat -c %G /usr/local/bin)"
sudo chown -R "${DIR_OWNER}":"${DIR_GROUP}" /usr/local/bin/



sudo yt-dlp -U
