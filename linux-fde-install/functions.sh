#!/usr/bin/env bash

temp_cryptdisk() {
    export DISK=''
    echo -e "creating temporary plain encrypted volume so whole disk has random data written to it"
    #cryptsetup open --type plain /dev/"$DISK_PARTITION" container --key-file /dev/urandom
    #dd if=/dev/zero of=/dev/mapper/container status=progress
    cryptsetup open --type plain -c aes-xts-plain64 -d /dev/urandom /dev/"$DISK" to_be_wiped
}

temp_cryptpart() {
    export DISK_PARTITION=''
    echo -e "creating temporary plain encrypted volume so whole disk has random data written to it"
    #cryptsetup open --type plain /dev/"$DISK_PARTITION" container --key-file /dev/urandom
    #dd if=/dev/zero of=/dev/mapper/container status=progress
    cryptsetup open --type plain -c aes-xts-plain64 -d /dev/urandom /dev/"$DISK_PARTITION" to_be_wiped
}

zerodisk_long() {
    echo -e "now wiping with zeros"
    dd if=/dev/zero of=/dev/mapper/to_be_wiped status=progress

    echo -e "closing temp encrypted container"
    cryptsetup close to_be_wiped
}

zerodisk_quicker() {
	DEVICE="${disk_path}" ;
	echo "${DEVICE}"
#	PASS=$(tr -cd '[:alnum:]' < /dev/urandom | head -c128) ;
#	openssl enc -aes-256-ctr -pbkdf2 -pass pass:"$PASS" -nosalt </dev/zero | dd obs=64K ibs=4K of=$DEVICE oflag=direct status=progress
}





wipe_partitions() {
    echo -e "Deleting all partitions of disk /dev/$DISK in 5 seconds"
    sleep 6
    sudo sfdisk --delete /dev/"$DISK"
}

show_disks() {
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
}
