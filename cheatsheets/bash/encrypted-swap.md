
Encrypted Swap
How to set up encrypted swap.

    Show

randomly encrypted swap¶

turn off swap:

# swapoff -a

Look in /etc/fstab for what partitions are swap. In my case, it will be /dev/sda2 and /dev/sdb2. Comment these out and replace them with encrypted swap devices (which we will create later):

/etc/fstab
# /dev/sda2          none    swap    sw    0    0
# /dev/sdb2          none    swap    sw    0    0
/dev/mapper/swap1    none    swap    sw    0    0
/dev/mapper/swap2    none    swap    sw    0    0

/etc/crypttab
swap1      /dev/sda2    /dev/random      swap
swap2      /dev/sdb2    /dev/random      swap

Run the cryptdisks startup script to create /dev/mapper/swapX from /etc/crypttab entries:

# /etc/init.d/cryptdisks start

Turn swap back on:

# swapon -a

hibernation with encrypted swap¶

If you want to be able to hibernate (suspend to disk) then swap must be encrypted with a non-random key.
about hibernation¶

There are three methods of hibernation: swsusp, uswsusp (aka suspend), and tuxonice (aka suspend2). See comparison of methods and the ubuntu suspend pages.
setup encrypted swap for uswsusp¶
Install the cryptsetup package¶

apt-get install cryptsetup

Setup the encrypted partition:¶

sudo -s
swapoff -a
cryptsetup luksFormat /dev/hda2
cryptsetup luksOpen /dev/hda2 cryptswap
mkswap /dev/mapper/cryptswap

Add this line to /etc/crypttab:¶

cryptswap /dev/hda2 none swap,luks,timeout=30

Set the swap partition to be this in /etc/fstab:¶

/dev/mapper/cryptswap none swap sw 0 0

activate new swap¶

swapon -a

You can check to see what swap is active:

cat /proc/swaps

Configure uswsusp to use /dev/mapper/cswap and write unencrypted data¶

install or reconfigure uswsusp:

apt-get install uswsusp

or

dpkg-reconfigure -plow uswsusp

or, you could just edit the config /etc/uswsusp.conf and run:

update-initramfs -u 

codetitle. /etc/uswsusp.conf

resume device = /dev/mapper/cryptswap
compress = y
early writeout = y
image size = 472324997
RSA key file =
shutdown method = platform
encrypt = n

making gnome hibernate button work with uswsusp¶
THIS DOES NOT WORK ANYMORE, BECAUSE NOW HAL SCRIPTS WONT TRY OTHER METHODS

the hal scripts that govern what happens when you hit hibernate in the gnome logout dialog will use pmi scripts first. We can’t remove the pmi package, because that will remove gnome-desktop. However, we can divert the scripts to a disabled path name. This way, the hal scripts will use uswsusp first.

sudo dpkg-divert --rename --divert /usr/sbin/pmi-disabled /usr/sbin/pmi

undo the divert:

sudo dpkg-divert --rename --remove /usr/sbin/pmi

testing¶

sudo s2disk

see if that works.

strings /dev/hda2

 
kugg
2008-10-28
	

Whats the benefit from encrypting the swap?
 
 
elijah
2008-10-28
	

if your disk is encrypted but your swap is not, then your key for the disk encryption can be read from the swap file.
