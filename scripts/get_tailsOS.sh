#!/bin/bash

set -eu -x


TAILS_VERSION=$(torsocks curl -s https://mirrors.edge.kernel.org/tails/stable/ | grep "tails-amd" | cut -d \> -f 2 | cut -d \/ -f 1)
USE_TORSOCKS=""

torsocks_check() {
#if [ -z $(command -v torsocks) ] || [ $USE_TORSOCKS == "0" ]; then
if [ -z $(command -v torsocks) ]; then
	echo -e "Torsocks isn't installed. Ok to check for Tails version over clearweb?"
	echo -e "You can ignore this if using a vpn"
	read curl_clearweb
	case $curl_clearweb in
		Y|y)
			echo -e "Ok, will check over clearweb"
			echo -e "continuing"
			USE_TORSOCKS=0
			export USE_TORSOCKS
			sleep 0.5
			;;
		N|n)
			echo -e "Not checking over clearweb. Install torsocks then re-run script"
			sleep 1
			exit 1
			;;
		*)
			echo -e "Invalid response. Answer Y or N"
			echo -e "Exiting"
			sleep 0.5
			exit 2
			;;
	esac
fi
}

get_key() {
## Import the Tails signing key in your GnuPG keyring:
torsocks wget https://tails.boum.org/tails-signing.key
gpg --import < tails-signing.key

# to test:  wget https://tails.boum.org/tails-signing.key | gpg --import -  (?? would this work?? test it)

## Install the Debian keyring. It contains the OpenPGP keys of all Debian developers
sudo apt update && sudo apt install debian-keyring -y
}

import_key() {
## Import the OpenPGP key of Chris Lamb, a former Debian Project Leader, from the Debian keyring into your keyring
gpg --keyring=/usr/share/keyrings/debian-keyring.gpg --export chris@chris-lamb.co.uk | gpg --import

## Verify the certifications made on the Tails signing key and look for Chris Lamb's verification sig
gpg --keyid-format 0xlong --check-sigs A490D0F4D311A4153E2BB7CADBB802B258ACD84F | grep -e "sig!" -e "0x1E953E27D4311E58" -e "2020-03-19" -e  "Chris Lamb <chris@chris-lamb.co.uk>"

## sig!         0x1E953E27D4311E58 2020-03-19  Chris Lamb <chris@chris-lamb.co.uk>

sleep 3
echo "\nThe line 175 signatures not checked due to missing keys or similar refers to the certifications (also called signatures) made by other public keys that are not in your keyring. This is not a problem."

## Certify the Tails signing key with your own key:
# gpg --lsign-key A490D0F4D311A4153E2BB7CADBB802B258ACD84F
}


get_tails() {
## download tails usb image (dec 30, 2021)

wget --continue "https://download.tails.net/tails/stable/${TAILS_VERSION}/${TAILS_VERSION}.img"

export TA

}

verify_sig() {
## download tails sig
wget https://tails.boum.org/torrents/files/${TAILS_VERSION}.img.sig

## Verify that the USB image is signed by the Tails signing key:
TZ=UTC gpg --no-options --keyid-format long --verify ${TAILS_VERSION}.img.sig ${TAILS_VERSION}.img

sleep 3
echo -e " The output of previous command should be the following:"

echo -e '
gpg: Signature made 2021-12-06T16:19:38 UTC
gpg:                using RSA key 05469FB85EAD6589B43D41D3D21DAD38AF281C0B
gpg: Good signature from "Tails developers (offline long-term identity key) <tails@boum.org>" [full]
gpg:                 aka "Tails developers <tails@boum.org>" [full]
'

sleep 2
echo -e " Verify in this output that:"

echo -e "The date of the signature is the same."
echo -e "The signature is marked as Good signature since you certified the Tails signing key with your own key."
}


certify_sigkey() {
	gpg --lsign-key A490D0F4D311A4153E2BB7CADBB802B258ACD84F
}


flash_usb() {
read -p "Use dd command to install on usb drive now? [y/N] "  "install_tails"

case "$install_tails" in
     Y|y)
          echo -e "ok, getting ready to install"
          sleep 2
          echo -e "checking available disks..."
          sleep 2
          lsblk -a
          sleep 2
          read -p "Enter your usb disks name (e.g. sda, sdb, etc):  "  "usb_disk"
          echo -e "You selected: /dev/$usb_disk"
          sleep 3
          read -p "Are you absolutely sure? Theres no turning back once it starts!! [y/N] "  "yes_no"
          case "$yes_no" in
                 y)
                  echo -e "ok, starting install in 5 seconds"
                  sleep 5
                  echo -e "starting now"
                  sudo dd if=$(ls | grep tails) of=/dev/"$usb_disk" bs=16M oflag=direct status=progress
                  echo -e "done!"
                  sleep 2
                  exit 0
                  ;;
                 n)
                  echo -e "Quitting, run this script again"
                  sleep 3
                  exit 
                  ;;
                 *)
                  echo -e "error, invalid option chosen"
                  sleep 2
                  echo -e "quitting, run script again"
                  sleep 2
                  exit
                  ;;
           esac
         ;;
      N|n)
           echo -e "Ok, quitting"
           sleep 2
           exit 0
         ;;
      *)
          echo -e "error, invalid option chosen"
          sleep 0.5
          echo -e "quitting"
          sleep 0.5
          exit 1
        ;;
esac
}

dl_gpgkey_prompt() {
	echo -e "Download and import Tails signing key?"
	echo -e "Can skip this if already imported"
	echo -e "If in doubt, answer yes"
	read dl_key
	case dl_key in
		Y|y)
			get_key
			import_key
			;;
		N|n)
			echo -e "Skipping downloading and importing signing key"
			sleep 0.5
			;;
		*)
			get_key
			import_key
			;;
	esac
}

## _________

#echo "Incomplete!! Source this file to use the functions though"
#sleep 3
#exit 0


#read -p "Get debian keyring to verify signature?" "get_debsig"
#case "$get_debsig" in
#    y)
#
#    ;;
#   n)
#    echo "ok, next"
#    ;;
#esac

# Check if torsock is installed
torsocks_check


# Download signing key
dl_gpgkey_prompt

# Download Tails image
get_tails

# Verify image file matches signature
verify_sig

# Certify the signing key with my own key
certify_sigkey


flash_usb
