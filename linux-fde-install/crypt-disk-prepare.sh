#!/usr/bin/env bash

set -eu -o pipefail

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


for-reference(){
print_color "\n*******************************\n" "$WHT"
echo
print_color "For your reference..."  "$YEL"
echo
print_color "\n*******************************\n" "$WHT"
echo
lsblk

sleep 2
print_color "\n*******************************\n" "$WHT"

blkid

print_color "\n*******************************\n" "$WHT"

sleep 2

}

select-disk-one(){
print_color "Enter disk  (e.g. sda, hda, mmcblk0, nvme0n1) " "$PRPL"
print_color "Do not include full path i.e /dev/ ; it'll be added automatically" "$WHT"
read "disk_path"
echo -e "\n"
export disk_path="/dev/${disk_path}"
}

select-disk-two(){
print_color "Second disk? [y/n] " "$PRPL"
read "second_disk"
echo
case "${second_disk}" in
y)
	print_color "Enter 2nd disk (e.g. sda, hda, mmcblk0, nvme0n1) " "$PRPL"
	read "disk_path2"
	echo -e "\n"
	sleep 1
	export disk_path2="/dev/${disk_path2}"
	;;
n)
	print_color "\nOk, continuing\n" "$BLU"
	echo -e "\n"
	sleep 1
	;;
*)
	print_color "Wrong key pressed. Start over" "$RED"
	sleep 2
	exit 1
	;;
esac

}



warning-banner(){

echo -e "************* Preparing to write to disks *******************"
sleep 1
echo -e "\n"
print_color "       THIS IS IRREVERSABLE. DATA LOSS IS GUARANTEED         " "$RED"
echo -e "\n"
print_color "     Hit ctrl+c to cancel and double check if you're unsure  " "$YEL"
echo -e "\n"
echo -e "\n"
sleep 3
print_color "  Beginning disk writes...                                   " "$BLU"
echo -e "\n"
}

crypt-open-temp(){
print_color "Creating a temporary cryptsetup container on $disk_path" "$BLU"
echo -e "\n"
sleep 1
print_color "This will be used to create a LUKS container on the disk that will be open at /dev/mapper/to_be_wiped" "$WHT"
echo -e "\n"
sleep 1
cryptsetup open --type plain -d /dev/urandom "${disk_path}" to_be_wiped
}


wipe-zeros-quick(){
print_color "Wiping $disk_path with zeros using OpenSSL + dd" "$BLU"
echo -e "\n"
DEVICE=/dev/mapper/to_be_wiped
PASS=$(tr -cd '[:alnum:]' </dev/urandom | head -c128)
openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of="${DEVICE}" oflag=direct status=progress
}

wipe-zeros-slow(){
print_color "Wiping $disk_path with zeros just using dd"  "$BLU"
echo -e "\n"
DEVICE=/dev/mapper/to_be_wiped
dd if=/dev/zero obs=64K ibs=4K of="${DEVICE}" oflag=direct status=progress
}


# take user input
wipe-method() {
	print_color "Slower wipe (dd if=/dev/zero) or quicker wipe (using openssl + dd)?" "$PRPL"
	print_color "   1) Slower"  "$WHT"
	print_color "   2) Quicker"  "$WHT"

	read -rp "${PRPL}Enter your choice [1-2]:${RST} " choice

	case "$choice" in
		1|Slower|slower)
			print_color "\nSlower wipe selected\n" "$BLU"

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
				print_color "\nFirst disk wiped\n" "$BLU"
				sleep 1
				print_color "\nStarting Wiping second disk\n" "$BLU"
				PATH="${disk_path2}"
				crypt-open-temp
				wipe-zeros-slow
				cryptsetup close to_be_wiped
				print_color "\nSecond disk wiped\n" "$BLU"
			else
				print_color "Wrong key pressed. Start over"
				sleep 2
				exit 1
			fi
			;;

		2|Quicker|quicker)
			print_color "\nQuicker wipe selected\n" "$BLU"

			if [[ "${second_disk}" == n ]]; then
				PATH="${disk_path}"
				crypt-open-temp
				wipe-zeros-quick
				cryptsetup close to_be_wiped
				print_color "\nFirst disk wiped\n" "$BLU"
				sleep 1
			elif [[ "${second_disk}" == y ]]; then
				PATH="${disk_path}"
				crypt-open-temp
				wipe-zeros-slow
				cryptsetup close to_be_wiped
				print_color "\nFirst disk wiped\n" "$BLU"
				sleep 1
				print_color "\nStarting Wiping second disk\n" "$BLU"
				PATH="${disk_path2}"
				crypt-open-temp
				wipe-zeros-slow
				cryptsetup close to_be_wiped
				print_color "\nSecond disk wiped\n" "$BLU"
			else
				print_color "Wrong key pressed. Start over" "$RED"
				sleep 1
				exit 1
			fi
			;;
		
		*)
			print_color "Invalid choice. Start over" "$RED"
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
#				print_color "Finished with $DEVICE - Continuing..."
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
#				print_color "Finished with $DEVICE - Continuing..."
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
#		print_color "Finished with $DEVICE - Continuing..."
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

	print_color "Finished !"

}


main

exit 0
