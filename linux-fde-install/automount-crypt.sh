#! /bin/sh

# create auto mount of luks encrypted volume on system start

# scripts requirements: cryptsetup (luks), awk, grep, dd 
# files changed by script: /etc/crypttab, /etc/fstab
# files created by script: DRIVE_PATH (mount path)
# tested on: debian stretch
# set configuration & chmod +x this script ;) & run this script
# see: https://blog.tinned-software.net/automount-a-luks-encrypted-volume-on-system-start/ | https://linuxwiki.de/cryptsetup

# list hard drives to get your DRIVE_ID
# lsblk

##
## <configuration>
##

DRIVE_ID=""                 # drive id. see "lsblk" output
DRIVE_PATH=""   # path to mount drive (use / as last char)
KEY_PATH=""      # path to store drive key (use / as last char)

##
## </configuration>
##

# mkdir /root/myramfs
# mount ramfs /root/myramfs/ -t ramfs
# cd /root/myramfs

if [ $(whoami) != "root" ]; then
    echo "luks auto mount: root privilegs are required. do 'su'"
    exit 1
fi

echo "luks auto mount: create mount point at path ${DRIVE_PATH} for encrypted drive ${DRIVE_ID} with key ${KEY_PATH}${DRIVE_ID}"

# create key directory if not exist
if [ ! -e "${KEY_PATH}" ]; then
    mkdir -p "${KEY_PATH}"
fi

# create random key - required to unlock volumne
dd if=/dev/urandom of="${KEY_PATH}${DRIVE_ID}" bs=512 count=8

# only allow root / group to read key file
chmod 640 "${KEY_PATH}${DRIVE_ID}"

# add created key to cryptsetup for our luks device
cryptsetup -v luksAddKey "/dev/${DRIVE_ID}" "${KEY_PATH}${DRIVE_ID}"
# remove key from crypt drive and delete it with (set vars in shell before): cryptsetup -v luksRemoveKey /dev/${DRIVE_ID} "${KEY_PATH}${DRIVE_ID}" && rm ${KEY_PATH}${DRIVE_ID}

# get cryptsetup luks drive id
UUID=$(cryptsetup luksDump "/dev/${DRIVE_ID}" | grep "UUID" | awk -v N=2 '{print $N}')

# add volume to crypttab - required to automatically encrypt volume
echo "${DRIVE_ID}_crypt UUID={UUID} ${KEY_PATH}${DRIVE_ID} luks" >> /etc/crypttab

# create drive mount path if not exist
if [ ! -e "${KEY_PATH}" ]; then
    mkdir -p "${DRIVE_PATH}"
fi

# add volume to fstab - required to automatically mount the encrypted volume on system start
echo "/dev/mapper/${DRIVE_ID}_crypt ${DRIVE_PATH} ext4    defaults   0       2" >> /etc/fstab

echo "luks auto mount: reboot your system please"

exit 0
