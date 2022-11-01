#!/usr/bin/env bash

set -eu -o pipefail

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

# shellcheck disable=SC2145
echo_cmd() { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_prompt() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_note() { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_info() { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_warn() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_debug() { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_fail() { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }


for-reference(){
echo
echo
echo_info "*******************************"
echo
echo_prompt "For your reference..."
echo
echo_info "*******************************"
echo
lsblk

sleep 2
echo
echo_info "\n*******************************\n"

blkid

echo_info "\n*******************************\n"

sleep 2

}

select-disk-one(){
echo_prompt "Enter disk  (e.g. sda, hda, mmcblk0, nvme0n1) "
echo_info "Do not include full path i.e /dev/ ; it'll be added automatically"
read "disk_path"
echo -e "\n"
export disk_path="/dev/${disk_path}"
}

select-disk-two(){
echo_prompt "Second disk? [y/n] "
read "second_disk"
echo
case "${second_disk}" in
y)
	echo_prompt "Enter 2nd disk (e.g. sda, hda, mmcblk0, nvme0n1) "
	read "disk_path2"
	echo -e "\n"
	sleep 1
	export disk_path2="/dev/${disk_path2}"
	;;
n)
	echo_cmd "\nOk, continuing\n"
	echo -e "\n"
	sleep 1
	;;
*)
	echo_fail "Wrong key pressed. Start over"
	sleep 2
	exit 1
	;;
esac

}



warning-banner(){

echo_warn "************* Preparing to write to disks *******************"
sleep 1
echo -e "\n"
echo_fail "       THIS IS IRREVERSABLE. DATA LOSS IS GUARANTEED         "
echo -e "\n"
echo_warn "     Hit ctrl+c to cancel and double check if you're unsure  "
echo -e "\n"
echo -e "\n"
sleep 3
echo_cmd "  Beginning disk writes...                                   "
echo -e "\n"
}

crypt-open-temp(){
echo_note "Creating a temporary cryptsetup container on $disk_path"
echo -e "\n"
sleep 1
echo_info "This will be used to create a LUKS container on the disk that will be open at /dev/mapper/to_be_wiped"
echo -e "\n"
sleep 1
cryptsetup open --type plain -d /dev/urandom "${PATH}" to_be_wiped
}


wipe-zeros-quick(){
echo_note "Wiping $disk_path with zeros using OpenSSL + dd"
echo -e "\n"
DEVICE=/dev/mapper/to_be_wiped
PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of="${DEVICE}" oflag=direct status=progress
}

wipe-zeros-slow(){
echo_note "Wiping $disk_path with zeros just using dd"
echo -e "\n"
DEVICE=/dev/mapper/to_be_wiped
dd if=/dev/zero obs=64K ibs=4K of="${DEVICE}" oflag=direct status=progress
}


# take user input
wipe-method() {
	echo_prompt "Slower wipe (dd if=/dev/zero) or quicker wipe (using openssl + dd)? "
	echo_info "   1) Slower"
	echo_info "   2) Quicker"

	read -rp "${ANSI_YEL}Enter your choice [1-2]:${ANSI_RST} " choice

	case "$choice" in
		1|Slower|slower)
			echo_cmd "\nSlower wipe selected\n"

			if [[ "${second_disk}" == n ]]; then
				PATH="${disk_path}"
				crypt-open-temp
				wipe-zeros-slow
				cryptsetup close to_be_wiped
			elif [[ "${second_disk}" == y ]]; then
				PATH="${disk_path}"
				crypt-open-temp
				wipe-zeros-slow
				cryptsetup close to_be_wiped
				echo_cmd "\nFirst disk wiped\n"
				sleep 1
				echo_cmd "\nStarting Wiping second disk\n"
				PATH="${disk_path2}"
				crypt-open-temp
				wipe-zeros-slow
				cryptsetup close to_be_wiped
				echo_cmd "\nSecond disk wiped\n"
			else
				echo_fail "Wrong key pressed. Start over"
				sleep 2
				exit 1
			fi
			;;

		2|Quicker|quicker)
			echo_cmd "\nQuicker wipe selected\n"

			if [[ "${second_disk}" == n ]]; then
				PATH="${disk_path}"
				crypt-open-temp
				wipe-zeros-quick
				cryptsetup close to_be_wiped
				echo_cmd "\nFirst disk wiped\n"
				sleep 1
			elif [[ "${second_disk}" == y ]]; then
				PATH="${disk_path}"
				crypt-open-temp
				wipe-zeros-slow
				cryptsetup close to_be_wiped
				echo_cmd "\nFirst disk wiped\n"
				sleep 1
				echo_cmd "\nStarting Wiping second disk\n"			
				PATH="${disk_path2}"
				crypt-open-temp
				wipe-zeros-slow
				cryptsetup close to_be_wiped
				echo_cmd "\nSecond disk wiped\n"
			else
				echo_fail "Wrong key pressed. Start over"
				sleep 1
				exit 1
			fi
			;;
		
		*)
			echo_fail "Invalid choice. Start over"
			sleep 2
			exit 1
			;;
	esac
}


#random-idk(){
#
#		for PATH in "${disk_path}" "${disk_path2}"; do
#			crypt-open-temp
#			wipe-zeros-slow
#			cryptsetup close to_be_wiped
#		done
#
#		if [[ "${second_disk}" == n ]]; then
#			DEVICE="${disk_path}"
#			echo "${DEVICE}"
#			PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
#			openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress
#
#		else
#			for DEVICE in "${disk_path}" "${disk_path2}"; do
#				echo "${DEVICE}"
#				PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
#				openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress
#				sleep 1
#				echo
#				echo_cmd "Finished with $DEVICE - Continuing..."
#				echo
#				sleep 1
#			done
#		fi
#		if [[ "${second_disk}" == n ]]; then
#			echo -e "now wiping with zeros"
#			dd if=/dev/zero of=/dev/mapper/to_be_wiped bs=1M status=progress
#
#		else
#			for DEVICE in "${disk_path}" "${disk_path2}"; do
#				echo "${DEVICE}"
#				PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
#				openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress
#				sleep 1
#				echo
#				echo_cmd "Finished with $DEVICE - Continuing..."
#				echo
#				sleep 1
#			done
#		fi
#if [[ "${second_disk}" == n ]]; then
#	DEVICE="${disk_path}"
#	echo "${DEVICE}"
#	PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
#	openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of="$DEVICE oflag=direct status=progress
#
#else
#	for DEVICE in "${disk_path}" "${disk_path2}"; do
#		echo "${DEVICE}"
#		PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
#		openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress
#		sleep 1
#		echo
#		echo_cmd "Finished with $DEVICE - Continuing..."
#		echo
#		sleep 1
#	done
#fi
#}


main(){
	# Display disks and block devices
	for-reference

	# Choose first disk
	select-disk-one

	# Choose second disk if applicable
	select-disk-two

	# Warn that all data will be lost
	warning-banner

	# Choose wipe method and wipe
	wipe-method

	echo_cmd "Finished !"

}


main

exit 0