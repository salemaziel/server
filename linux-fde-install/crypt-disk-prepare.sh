#!/usr/bin/env bash

set -eu -o pipefail

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

echo_cmd() { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
echo_note() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_prompt() { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
echo_info() { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
echo_warn() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_debug() { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
echo_fail() { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }

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
echo_info "*******************************"
echo

blkid
echo
sleep 2

echo_prompt "Enter disk  (e.g. sda, hda, mmcblk0, nvme0n1) "
read "disk_path"

echo

echo_prompt "Second disk? [y/n] "
read "second_disk"
echo
case "${second_disk}" in
y)
	echo_prompt "Enter 2nd disk (e.g. sda, hda, mmcblk0, nvme0n1) "
	read "disk_path2"
	echo
	sleep 1
	;;
n)
	echo_cmd "Ok, continuing"
	echo
	sleep 1
	;;
*)
	echo_fail "Wrong key pressed. Start over"
	sleep 2
	exit 1
	;;
esac

echo
echo_warn "************* Preparing to write to disks *******************"
sleep 1
echo
echo_fail "       THIS IS IRREVERSABLE. DATA LOSS IS GUARANTEED         "
echo
echo_warn "     Hit ctrl+c to cancel and double check if you're unsure  "
echo
echo
sleep 2
echo_cmd "  Beginning disk writes...                                   "
echo

echo -e "writing random data before encrypting"
#cryptsetup open --type plain /dev/"$DISK_PARTITION" container --key-file /dev/urandom
#dd if=/dev/zero of=/dev/mapper/container status=progress
cryptsetup open --type plain -d /dev/urandom /dev/"$disk_path" to_be_wiped

# take user input
wipe_zeros() {
	echo "Slower wipe (dd if=/dev/zero) or quicker wipe (using openssl + dd)? "
	echo "   1) Slower"
	echo "   2) Quicker"
	#    echo "   3) Option #3"
	#    echo "   4) Option #4"
	#    echo "   5) Option #5"
	until [[ "${USER_OPTIONS}" =~ ^[0-9]+$ ]] && [ "${USER_OPTIONS}" -ge 1 ] && [ "${USER_OPTIONS}" -le 2 ]; do
		read -rp "Select an Option [1-2]: " -e -i 1 USER_OPTIONS
	done
	case ${USER_OPTIONS} in
	1)
		echo -e "closing temp encrypted container"
		cryptsetup close to_be_wiped

		if [[ "${second_disk}" == n ]]; then
			echo -e "now wiping with zeros"
			dd if=/dev/zero of=/dev/mapper/to_be_wiped bs=1M status=progress

		else
			for DEVICE in "${disk_path}" "${disk_path2}"; do
				echo "${DEVICE}"
				PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
				openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress
				sleep 1
				echo
				echo_cmd "Finished with $DEVICE - Continuing..."
				echo
				sleep 1
			done
		fi
		;;
	2)
		if [[ "${second_disk}" == n ]]; then
			DEVICE="${disk_path}"
			echo "${DEVICE}"
			PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
			openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress

		else
			for DEVICE in "${disk_path}" "${disk_path2}"; do
				echo "${DEVICE}"
				PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
				openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress
				sleep 1
				echo
				echo_cmd "Finished with $DEVICE - Continuing..."
				echo
				sleep 1
			done
		fi
		;;
		#	3)
		#		echo "Wassup foo"
		#		;;
		#	4)
		#		echo "Wassup foo"
		#		;;
		#	5)
		#		echo "Wassup foo"
		#		;;
	esac
}

#echo -e "slower wipe (dd if=/dev/zero) or quicker wipe (using openssl + dd)?  "
#echo -e "now wiping with zeros"
#dd if=/dev/zero of=/dev/mapper/to_be_wiped status=progress

#echo -e "closing temp encrypted container"
#cryptsetup close to_be_wiped

if [[ "${second_disk}" == n ]]; then
	DEVICE="${disk_path}"
	echo "${DEVICE}"
	PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
	openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress

else
	for DEVICE in "${disk_path}" "${disk_path2}"; do
		echo "${DEVICE}"
		PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
		openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress
		sleep 1
		echo
		echo_cmd "Finished with $DEVICE - Continuing..."
		echo
		sleep 1
	done
fi

echo_debug "Finished !"
echo
