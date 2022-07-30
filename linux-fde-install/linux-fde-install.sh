#!/bin/bash

# 1. delete all existing partitions
# 2. create 1st partition: 100MB FAT32 filesystem for EFI
# 3. create 2nd partition: 360MB ext2 filesystem for boot
# 4. create 3rd partition: remainder of disk ext4 filesystem for system
# 5. use cryptsetup luksFormat /dev/$(3rd partition) to encrypt the rest of the disk; enter encryption password
# 6. cryptsetup open /dev/$(3rd partition) mapper_name - use crxMMC_crypt
# 7. create new LVM pv group from the encrypted partition, eg: pvcreate /dev/mapper/crxMMC_crypt
# 8. create new LVM vg group using the pv, eg: vgcreate vg0 /dev/mapper/crxMMC_crypt
# 9. create new LVM lv for root partition in the vg group vg0, eg:
# -  lvcreate -L $ROOT_SIZE $VG_NAME -n $LV_ROOT
# 10. repeat number 9 for swap partition, home partition, and tmp partition, eg:
# - lvcreate -L $SWAP_SIZE $VG_NAME -n $LV_SWAP
# - lvcreate -L $HOME_SIZE $VG_NAME -n $LV_HOME
# - lvcreate -L $TMP_SIZE $VG_NAME -n $LV_TMP
# 11. Check with lvdisplay, if all looks good, then run GUI installer
#
DISK='mmcblk0'
DISK_PARTITION='mmcblk0p3'

ROOT_SIZE='12G'
#ROOT_SIZE='+42%'
HOME_SIZE='13G'
#HOME_SIZE='45%'
SWAP_SIZE='768M'
#SWAP_SIZE='3%'
TMP_SIZE='100%FREE'
#TMP_SIZE='10%'

PV_MAPPER='crxMMC_crypt'
VG_NAME='vg0'
LV_ROOT='lv-root'
LV_HOME='lv-home'
LV_SWAP='lv-swap'
LV_TMP='lv-tmp'





echo -e "Deleting all partitions of disk /dev/$DISK in 5 seconds"
sleep 6
sudo sfdisk --delete /dev/"$DISK"

echo -e "Using fdisk to create new gpt partition table, then a 1st primary partition 100MB for EFI, then a 2nd 384MB linux partition for /boot, then another linux partition for now "
sleep 3
echo -e "g\nn\n1\n\n+300M\nt\n1\nn\n2\n\n+512M\nn\n3\n\n\nw" | fdisk /dev/"$DISK"

sleep 3

mkfs.fat -F 32 /dev/"$DISK"p1

mkfs.ext2 -F /dev/"$DISK"p2

mkfs.ext2 -F /dev/"$DISK_PARTITION"

sleep 3


echo -e "writing random data before encrypting"
#cryptsetup open --type plain /dev/"$DISK_PARTITION" container --key-file /dev/urandom
#dd if=/dev/zero of=/dev/mapper/container status=progress
cryptsetup open --type plain -d /dev/urandom /dev/"$DISK_PARTITION" to_be_wiped

echo -e "now wiping inside encrypted container with zeros"
dd if=/dev/zero of=/dev/mapper/to_be_wiped status=progress

echo -e "closing temp encrypted container"
cryptsetup close to_be_wiped



echo "starting actual encryption"
echo
read -s -p "Enter encryption password: " "password"
echo -n "$password" > /tmp/.crypt > /dev/null 2>&1
sleep 2
cryptsetup -q -v --type luks2 luksFormat /dev/"$DISK_PARTITION" -d /tmp/.cryptPass.txt
cryptsetup open /dev/"$DISK_PARTITION" "$PV_MAPPER" -d /tmp/.cryptPass.txt

#mkfs.ext4 -F /dev/mapper/crxMMC_crypt


pvcreate /dev/mapper/"$PV_MAPPER"

vgcreate "$VG_NAME" /dev/mapper/"$PV_MAPPER"



lvcreate -L "$SWAP_SIZE" "$VG_NAME" -n "$LV_SWAP"

lvcreate -L "$ROOT_SIZE" "$VG_NAME" -n "$LV_ROOT"

lvcreate -L "$HOME_SIZE" "$VG_NAME" -n "$LV_HOME"

lvcreate -l "$TMP_SIZE" "$VG_NAME" -n "$LV_TMP"



mkswap /dev/"$VG_NAME"/"$LV_SWAP"

mkfs.ext4 -F /dev/"$VG_NAME"/"$LV_ROOT"

mkfs.ext4 -F /dev/"$VG_NAME"/"$LV_HOME"

mkfs.ext4 -F /dev/"$VG_NAME"/"$LV_TMP"

echo -e "Now complete GUI installer, but DO NOT REBOOT AFTERWARDS"
sleep 2


# see this url about chrooting in to configure newly installed system
# https://www.oxygenimpaired.com/multiple-linux-distro-installs-on-a-luks-encrypted-harddrive


# other resources
# https://tonisagrista.com/blog/2020/arch-encryption/
# https://www.linux.com/training-tutorials/how-full-encrypt-your-linux-system-lvm-luks/
# https://schumacher.sh/2016/11/17/encrypt-an-existing-linux-installation-with-luks-and-lvm.html
# https://github.com/rickellis/Arch-Linux-Install-Guide
# https://www.linux.com/training-tutorials/how-full-encrypt-your-system-lvm-luks-cli/
# https://askubuntu.com/questions/1250266/how-to-install-ubuntu-with-lvm-luks-on-a-ssd-and-use-an-luks-encrypted-hdd-luksFormat
#


