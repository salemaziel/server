#!/bin/bash

DISK='mmcblk0'
DISK_PARTITION='mmcblk0p3'


PV_MAPPER='crxMMC_crypt'
VG_NAME='vg0'
LV_ROOT='lv-root'
LV_HOME='lv-home'
LV_SWAP='lv-swap'
LV_TMP='lv-tmp'

# Add root check function
echo "run as root"


# create folder to mount system
mkdir /mnt/newroot

# mount newly installed system's root onto new folder just created
mount /dev/mapper/"$VG_NAME"-"$LV_ROOT" /mnt/newroot

# chroot into the new system
mount -o bind /proc /mnt/newroot/proc
mount -o bind /dev /mnt/newroot/dev
mount -o bind /dev/pts /mnt/newroot/dev/pts
mount -o bind /sys /mnt/newroot/sys
cd /mnt/newroot
chroot /mnt/newroot

# mount /boot partition for newly installed system
mount /dev/"$DISK"p2 /boot

# Get the UUID of the crypto partition you created previously with fdisk:
FOR_CRYPTTAB=$(blkid /dev/"$DISK_PARTITION")

# Take the UUID given above (without the quotes) and create the file “/etc/crypttab” with the following single line. (This file will be the same for all linux distros within the LUKS container).
echo "$PV_MAPPER UUID=$FOR_CRYPTTAB none luks" >> /etc/crypttab
#sda5_crypt UUID=your-blkid-goes-here none luks

# Check /etc/fstab to ensure everything looks okay. It should list mounts for swap, /boot, / , and /home

# You may want to add the following line to /etc/default/grub to keep your grub menu clean. This will restrict Grub to only creating menu entries for items in this distro’s /boot partition instead of searching the entire disk and creating menu entries for everything it finds.
GRUB_DISABLE_OS_PROBER=true

# Ensure that the “cryptsetup” and “cryptsetup-bin” packages are installed on the system (should be included on most modern distros) as well as initramfs-tools. For Debian based systems:
dpkg -l | grep cryptsetup
dpkg -l | grep initramfs

#Update the kernel boot images and grub menu:
update-initramfs -u
update-grub

# Take a look in /boot to ensure the initrd and vmlinuz images exist. Also take a peek at /boot/grub/grub.cfg to review your menu entries.

# Optional: If you want to save time and keep a tidy Grub menu then you can setup menu entries for your other distros now. They obviously won’t work until you install those distros, but it’ll save the step of having to boot back into the primary to update grub again after each install. To do this, add the “GRUB_DISABLE_OS_PROBER” entry mentioned above. Next, manually create the “chainload” entries for the other boot partitions by adding the following to the end of the 40_custom file.

# nano /etc/grub.d/40_custom
#menuentry "Linux /dev/sda2 chainload" {
#set root=(hd0,2)
#chainload +1
#}

#menuentry "Linux /dev/sda3 chainload" {
#set root=(hd0,3)
#chainload +1
#}

#Once completed, run “update-grub” again and recheck your “/boot/grub/grub.cfg”. You should see these entries near the bottom.

#* Time to take the plunge!
# reboot
