#!/bin/bash


# Remove old yt-dlp from package manager
remove-old-yt-dlp() {
echo -e "Removing old yt-dlp from package manager"
sleep 1
sudo apt -y purge yt-dlp
}

# Install dependencies
install-dependencies() {
echo -e "Installing dependencies"
sleep 1
sudo apt install -y python3-certifi brotli python3-brotli python3 python-is-python3 python3-websockets python3-mutagen atomicparsley python3-pycryptodome python3-secretstorage
}


# Install phantomjs
install-phantomjs(){

echo -e "Checking if phantomjs is installed"
sleep 1
if ! [ -x "$(command -v phantomjs)" ]; then
  echo -e "Installing phantomjs"
  sleep 1
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
else
  echo -e "phantomjs is already installed"
  sleep 1
fi
}





# Install FFmpeg builds special for yt-dlp
install-ytdlp-ffmpeg(){
    do_install(){
                cd /tmp || return
                mkdir ytdlp-ffmpeg
                cd ytdlp-ffmpeg || return
                wget https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl.tar.xz
                tar xf ffmpeg-master-latest-linux64-gpl.tar.xz
                cd ffmpeg-master-latest-linux64-gpl/bin || return
                sudo cp ffmpeg ffprobe ffplay -t /usr/local/bin/

                DIR_OWNER="$(stat -c %U /usr/local/bin)"
                DIR_GROUP="$(stat -c %G /usr/local/bin)"
                sudo chown -R "${DIR_OWNER}":"${DIR_GROUP}" /usr/local/bin/
    }

    if [ "/usr/bin/ffmpeg"  = "$(command -v ffmpeg)" ]; then
        echo -e "FFmpeg is already installed, but is from package manager"
        sleep 0.5
        read -rp "Install yt-dlp's FFmpeg build? [y/n]: " install_ffmpeg 
        case $install_ffmpeg in
            y)
                do_install
                ;;
            n)
                echo -e "Skipping yt-dlp's FFmpeg build"
                sleep 1
                ;;
            *)
                echo -e "Invalid option"
                echo -e "Skipping yt-dlp's FFmpeg build"
                sleep 1
                ;;
        esac
    elif [ "/usr/local/bin/ffmpeg"  = "$(command -v ffmpeg)" ]; then
        echo -e "yt-dlp FFmpeg build is already installed, skipping"
        sleep 1
    else
        do_install
    fi
}


install-ytdlp(){
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

}


# Update yt-dlp
update-ytdlp(){
sudo /usr/local/bin/yt-dlp -U
}




if [[ -x $(command -v yt-dlp ) ]]; then
    echo -e "yt-dlp is already installed."
    sleep 1
    read -rp "Do you want to update yt-dlp? [y/n] " -n 1 -r
        case $REPLY in
            y)
                update-ytdlp
                ;;
            n)
                echo -e "Exiting."
                exit 1
                ;;
            *) 
                echo -e "Invalid option. Exiting."
                exit 1
                ;;
        esac
else
    remove-old-yt-dlp
    install-dependencies
    install-phantomjs
    install-ytdlp-ffmpeg
    install-ytdlp
fi
