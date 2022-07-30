oxygen impaired
entropy.embraced
about
Multiple Linux Distro Installs on a LUKS Encrypted Harddrive
Posted: December 18th, 2014 | Author: Ken | Filed under: computing | Tags: bored musings of a dirtbiker stuck in snowy winter, encrypted multiboot, grub, linux, luks | 13 Comments »
Goal:
Install multiple linux distros on one machine that use the same encrypted container.

Why:
I’m setting up a new laptop with a 1 TB drive and want to be able to natively boot multiple distributions of linux, but also want everything in the drive except the necessary /boot partition to be encrypted. Each distro will have it’s own LVM volume within the encrypted container but I want all the LVMs to live within the same encrypted container so that data can be shared between volumes and I can grow/shrink/rearrange the logical volumes as needed.

Also.. just because.

The Challenges:
1) Boot partitions -- In a typical multiboot setup I would install Grub for the “primary” OS to the harddrive boot sector and then install the Grub for the secondary distros into their respective partition boot sectors. The primary Grub menu seen at boot would then be configured to chainload the secondary distros. Unfortunately this doesn’t work as simply with the LUKS setup above as Grub can’t access the secondary bootloaders if they are sitting in an encrypted LUKS container.

2) Dumb Installers -- In trying to keep things simple, the installer programs for many distros have been streamlined to the point they cannot support non-standard LUKS/LVM setups such as this.

The Process:
WARNING: FOLLOWING THESE STEPS IS GUARANTEED TO DESTROY EVERY BYTE OF EXISTING DATA ON YOUR HARD DRIVE. I’m serious -- the very first few steps will likely make any existing data unrecoverable by the best NSA jock using the latest secret-alien-area51 gear with unlimited funding. DO NOT PROCEED if you have not backed up every piece of needed data on the installation disk and have physically disconnected any other drives. This is NOT an exact step-by-step guide for beginners and assumes you are already familiar with linux installation and command-line administration.

Preparing the harddrive.
* This writeup assumes the installation harddrive is /dev/sda, adjust accordingly.

* Download and burn a linux installation disk with a Live option (e.g. latest Debian, Ubuntu or Mint). Alternative installers could be adapted as well if you know your stuff.

* Boot into the live environment, open a Terminal and “sudo su -” to obtain a root prompt.

* Create a temporary full disk partition to properly prepare the disk for encryption by first filling it with random data (this is where all existing data goes bye-bye). Use “fdisk /dev/sda” to delete any exiting partitions then create a full disk /dev/sda1 partition using the whole disk with default values. After saving the new table, if you get the following error:

WARNING: Re-reading the partition table failed with error 22: Invalid argument.
The kernel still uses the old table.
The new table will be used at the next reboot.
Syncing disks.
Then reboot before continuing or you will only overwrite whatever the old sda1 partition size was.

* The step of filling the new disk with random data is usually done with the agonizingly slow “dd if=/dev/urandom”. Thanks to these awesome guys we have a much quicker method available using a clever combo of /dev/zero and LUKS itself. (I now use this even for standard encrypted installs and can then skip the “wipe data” step provided by the installers.)

* Create a LUKS container using /dev/sda1:
# cryptsetup luksFormat /dev/sda1

This will overwrite data on /dev/sda1 irrevocably.
Are you sure? (Type uppercase yes): [YES]
Enter LUKS passphrase: [enter a random one-time-use password]
Verify passphrase: [re-enter password]
* Open the LUKS container:
# cryptsetup luksOpen /dev/sda1 sda1_crypt
[re-enter password]

* Fill the container data using /dev/zero. LUKS will encrypt the /dev/zero input as it writes. For me this is roughly 8x faster than the /dev/urandom method and the result is just as good (or better):
# dd if=/dev/zero of=/dev/mapper/sda1_crypt bs=1M

* Once complete, close the crypto device.
# cryptsetup luksClose sda1_crypt

* Overwrite the small LUKS header space for extra security.
# dd if=/dev/urandom of=/dev/sda1 bs=512 count=2056

Create the new permanent partitions and LUKS container.
* Use fdisk to create a new partition layout. The following layout provides boot partitions for 3 linux distros and the rest of the disk as the encrypted container. If you want more distos, format more boot partitions accordingly. It is possible to use the same /boot for more than one distro, but it will make all kinds of ugliness when you run update-grub. Unfortunately Grub2 is not nearly as refined as the old Grub in customizing these things yet. Using separate boot partitions keeps things easy and clean.

# fdisk /dev/sda
new primary partition 1 = /dev/sda1, 512Mb, type 83 Linux (/boot for primary distro)
new primary partition 2 = /dev/sda2, 256Mb, type 83 Linux (/boot for alternate distro)
new primary partition 3 = /dev/sda3, 256Mb, type 83 Linux (/boot for alternate distro)
new extended partition = /dev/sda4, (disk remainder) type 5 extended
new partition 5 = /dev/sda5, (disk remainder) type 83 Linux (this is the encrypted partition)

Also, if you want to install non-encrypted OS’s (e.g. Windows) then limit the size of the encrypted partition and create additional extended partitions for those OS’s. Note that most non-encrypted OS’s do not need separate boot partitions because they can be chainloaded from the Grub that will be installed in the primary harddrive boot sector. Also note that some versions of Windows may have trouble with booting from extended partitions so you would need to modify your layout accordingly. (Personally, I prefer never run to Windows outside of a Virtualbox).

* Now create the new crypto device. Note that the password you use here will be required each time you boot.

# cryptsetup luksFormat /dev/sda5

This will overwrite data on /dev/sda5 irrevocably.
Are you sure? (Type uppercase yes): YES
Enter LUKS passphrase: [new password]
Verify passphrase: [re-enter password]
* Open the new crypto partition:
# cryptsetup luksOpen /dev/sda5 sda5_crypt

* Create a new LVM Physical Volume (PV) from the crypto partition:
# pvcreate /dev/mapper/sda5_crypt

* Create a new LVM Volume Group (VG) using the PV:
# vgcreate [vg-name] /dev/mapper/sda5_crypt

* Create new LVM Logical Volumes (LVs) for swap and root (/). The swap LV will be common for all the distros, but each distro will have it’s own root LV. It may be helpful to name the root LV based on distro (e.g. “kubuntu-root”). You can delete and create new LVs if you swap out distros later. You can also start small as it’s easy to grow the LV later using lvextend (and most filesystems with resize2fs) if you need more space.
# lvcreate -L[8G] -n [swap-lv-name] [vg-name]
# lvcreate -L[50G] -n [root1-lv-name] [vg-name]

* Check everything with “lvdisplay”. If it all looks good then leave the terminal window open and move to the GUI installer.

Installing the initial (primary) Linux distro
* Click on the Live CD’s gui installer icon (probably right on the desktop) and follow the instructions. When you get to the disk setup selections, select the Manual option. Use the screens to configure:
/dev/sda1 as format ext2, mount /boot
/dev/mapper/[vg-name]-[swap-lv-name] as swap area
/dev/mapper/[vg-name]-[root1-lv-name] as format ext4, mount /

All the other available partitions should be listed as “Do not use”.

* If/when you are presented with a Grub install choice, then install this grub instance to the harddrive boot sector “/dev/sda”.

* Complete the gui install, but once completed DO NOT REBOOT YET, instead click the “Continue Testing” option. LUKS must be configured before you reboot.

Enabling LUKS on the Linux distro
* Once the installer completes, you need to chroot from the Live CD environment into your newly installed distro so you can configure LUKS before rebooting.

* From the terminal window you were using previously (as root):
# mkdir /mnt/newroot
# mount /dev/mapper/[vg-name]-[root1-lv-name] /mnt/newroot
# mount -o bind /proc /mnt/newroot/proc
# mount -o bind /dev /mnt/newroot/dev
# mount -o bind /dev/pts /mnt/newroot/dev/pts
# mount -o bind /sys /mnt/newroot/sys
# cd /mnt/newroot
# chroot /mnt/newroot

You are now in the newly installed distro’s environment (the previous /mnt/newroot is now “/”).

* Mount the /boot partition for this distro (e.g. /dev/sda1 for the primary distro)
# mount /dev/sdaX /boot

* Get the UUID of the crypto partition you created previously with fdisk:
# blkid /dev/sda5

* Take the UUID given above (without the quotes) and create the file “/etc/crypttab” with the following single line. (This file will be the same for all linux distros within the LUKS container).
# nano /etc/crypttab

sda5_crypt UUID=your-blkid-goes-here none luks
* Check /etc/fstab to ensure everything looks okay. It should list mounts for swap, /boot and /.

* You may want to add the following line to /etc/default/grub to keep your grub menu clean. This will restrict Grub to only creating menu entries for items in this distro’s /boot partition instead of searching the entire disk and creating menu entries for everything it finds.
GRUB_DISABLE_OS_PROBER=true

* Ensure that the “cryptsetup” and “cryptsetup-bin” packages are installed on the system (should be included on most modern distros) as well as initramfs-tools. For Debian based systems:
# dpkg -l | grep cryptsetup
# dpkg -l | grep initramfs

* Update the kernel boot images and grub menu:
# update-initramfs -u
# update-grub

# Take a look in /boot to ensure the initrd and vmlinuz images exist. Also take a peek at /boot/grub/grub.cfg to review your menu entries.

* Optional: If you want to save time and keep a tidy Grub menu then you can setup menu entries for your other distros now. They obviously won’t work until you install those distros, but it’ll save the step of having to boot back into the primary to update grub again after each install. To do this, add the “GRUB_DISABLE_OS_PROBER” entry mentioned above. Next, manually create the “chainload” entries for the other boot partitions by adding the following to the end of the 40_custom file.

# nano /etc/grub.d/40_custom

menuentry "Linux /dev/sda2 chainload" {
set root=(hd0,2)
chainload +1
}
menuentry "Linux /dev/sda3 chainload" {
set root=(hd0,3)
chainload +1
}

Once completed, run “update-grub” again and recheck your “/boot/grub/grub.cfg”. You should see these entries near the bottom.

* Time to take the plunge!
# reboot

* Make sure you eject the Live CD. Once the system reboots you should be presented with your Grub menu and shortly afterwards the boot process will pause and prompt for your LUKS password. Once entered you should boot into the normal user login prompt. Congrats!

Installing the additional Linux distros
* For installing the additional distros it’s easy to create the root LV for those while still logged into your primary distro. In a new terminal window:
$ sudo lvcreate -L[50G] -n [root2-lv-name] [vg-name]
$ sudo lvcreate -L[50G] -n [root3-lv-name] [vg-name]

There is no need to create a secondary swap LV. They’ll all use the same one.

* Reboot into the Live CD for the new distro. Once booted, open a terminal window and get to a root prompt like before.

* Now open the LUKS container:
# cryptsetup luksOpen /dev/sda5 sda5_crypt
[enter pass]

* Once open, activate the existing LVM LVs:
# lvscan

* If they didn’t automatically active then run:
# lvchange -a y

* If you didn’t already create the root LV for the new distro then do so now:
# lvcreate -L[50G] -n [root2-lv-name] [vg-name]

* Once again, leave the terminal window open and click on the Live CD’s gui installer and follow the instructions. When you get to the disk setup selections, select the Manual option. Use the screens to configure (use /dev/sda2 for the second distro /dev/sda3 for the third):
/dev/sda2 as format ext2, mount /boot
/dev/mapper/[vgname]-[swap-lv-name] as swap area
/dev/mapper/[vgname]-[root2-lv-name] as format ext4, mount /

DOUBLE CHECK that you are using one of the empty /boot partitions and root LV before proceeding or you will overwrite your existing install. Aside from swap, all the partitions for your other existing installs should be marked “Do not use”.

* Continue the install, when prompted for the grub installation choice, this time do not choose /dev/sda, but instead use the partition you defined as /boot (e.g. /dev/sda2). Grub may whine about being installed in a partition, but it works fine (at least for me so far.. knock on wood.)

* Complete the gui install, but again, once completed DO NOT REBOOT YET. Click the “Continue Testing” option.

* Follow the exact same steps as last time to chroot. Make sure you use the new root LV when mounting /mnt/newroot and the proper partition when mounting /boot.

* Use the same blkid process to create the /etc/crypttab file (it should be identical to the one you created last time).

* For these additional distros definitely disable the OS prober in /etc/default/grub. You do not need to add anything to 40_custom this time.
GRUB_DISABLE_OS_PROBER=true

* Again, ensure that the “cryptsetup” and “cryptsetup-bin” packages are installed on this system (should be included on most modern distros) as well as initramfs-tools.

* And again, update the kernel boot images and grub menu for this distro:
# update-initramfs -u
# update-grub

* Reboot!
# reboot

At startup you should see the same Grub menu as before (from the grub installed in /dev/sda), but this time select the “Linux /dev/sda2 chainload” menu option. This will then chainload you to a second Grub menu for that distro. The beauty in this is each distro controls it’s own grub entries and only messes with it’s own initramfs images. You can shorten up the timeouts in the respective /etc/default/grub configs to keep the boot sequence quick. You may also edit the chainload entries in the primary distro’s /etc/grub.d/40_custom file to something more descriptive (maybe “My ub3r l33t h4x0r Kali Install” ;).

Cheers!

PS -- Comments and corrections are invited. I wrote this from memory, while consuming IPAs, a few weeks after the fact so I’m positive it’s full of holes.. hopefully not ones that leave you hanging, but Dragons There May Be.

13 Comments on “Multiple Linux Distro Installs on a LUKS Encrypted Harddrive”
1» Linux: Can Grub2 multi-boot LUKS/LVM distros with only one boot partition? said at 9:08 pm on June 14th, 2015:
[…] Likewise, there are tutorials for multi-booting distros inside LUKS/LVM if multiple (unencrypted) boot partitions are used, by having the main bootloader chainload the bootloaders in the other unencrypted boot partitions. For example, multi-boot on LUKS. […]

2Fabricio said at 11:37 am on September 3rd, 2015:
Hi Ken, i’m trying to follow your tutorial but i’m having a few errors, maybe you can help me:
1) I’m not succeed to have an extended partition, so i’m doing with four primaries partitions, i tried with all tools you can imagine, even gparted live CD wont let me do it.
2) The first OS(Debian) wont let me install grub on the first sda(sda1 type 83 linux)
This is amazing tutorial i’m ever search for and the best i read about, i hope you can help me and congrats for the tutorial really! Thanks in advance! :-)

3Ken said at 6:07 pm on September 9th, 2015:
@Fabricio – it sounds like you may be on a newer UEFI firmware based machine instead of a traditional BIOS. In which case your disk will use a GPT partition table instead of an MBR (or you machine is still using BIOS, but the BIOS is set to boot the harddrive in GPT mode). GPT does not have primary vs extended partitions, but instead supports up to 128 primary partitions. Your options are either to see if your machine firmware setup provides options for “legacy” or “MBR” boot modes, or you’ll have to use a slightly different process for the initial bootloader install. Fortunately GRUB2 does support EFI & GPT so you can likely still get the overall setup above to work once you get past the primary Grub2 install. I’d suggest more reading on different Grub installs here: https://help.ubuntu.com/community/Grub2/Installing

4Fabricio said at 7:11 pm on September 9th, 2015:
@Ken i solved the problem about do 3 partitions and one extended with Debian formatting, now i’m on the second distro install(Arch) and studying Luks and Lvm CLI management and how to point the init and vmlinuz to the first grub partition! thanks for the answer!
I’m working in a virtual machine first to then make it in a physical machine! :-)

5Ken said at 3:17 pm on September 10th, 2015:
@Fabricio – Glad to hear it’s working out.

6Unix:Can Grub2 multi-boot LUKS/LVM distros with only one boot partition? – Unix Questions said at 7:24 am on October 21st, 2015:
[…] Likewise, there are tutorials for multi-booting distros inside LUKS/LVM if multiple (unencrypted) boot partitions are used, by having the main bootloader chainload the bootloaders in the other unencrypted boot partitions. For example, multi-boot on LUKS. […]

7Anonymous said at 2:25 am on May 9th, 2016:
Thaks for the info, i will try to adapt it to my needs!

I know how to have a main Grub2 onto its own 4GiB partition Ext4 formatted (with SystemRescueCD.iso on it and chainload it).
Note: I can do it on MBR and GPT modes and also on USB Stricks / memory cards, etc.

Next steps i am trying is to have such Grub2 partition encrypted… must learn howto.

After that step i am trying to learn howto add some more partitions (each one encrypted with its own passphrase), and bootable from a chainload from main Grub2.

I mean: Install a main Grub2 onto a main encrypted partition (with a pass1), then it will chainload another Grub2 on a different encrypted partition (with pass2) or will chainload another Grub2 on a different encrypted partition (with pass3) or .. etc … depending on what i select on the main Grub2 menu.

Final Idea is to have: One main Grub2 (encrypted with pass1) that can chainload other encrypted partitions (each one with its own pass) and boot whatever bootloader is there.

Objective: isolate each Linux form each other, having each Linux in just one encrypted parttion (one partition for each Linux) plus a main encrypted partition for main Grub2 bootlader.

I am tottally noob on LVM, LUKS, etc, but not on how to manually install Grub2 from a LiveCD called SystemRescueCD.

i know i what too much, why not just install the distros directly insetead of first testing the encrypted part by having only Grub2 chainload each other Grub2? Easy answer: i want to get the knonledge of how it works and i love to do thing complety by hand (is how i learn more, at a high cost).

All i test them on VirtualBox… among its failure to USB boot (can not do it) and UEFI / GPT support got me mad because VirtualBox does it in its own maner (not standard, etc).

But, at least, now i know how to (using only VirtualBox and SystemRecueCD) create a USB stick in GPT mode that can boot Grub2 while plugged onto a physical machine in both old MBR mode and new UEFI mode.

Nest, i want to know how to have such Grub2 inside encrypted partition (LVM / LUKs).

After that, or before that, i want to know how to create LVM / LUKS partitions (after learning a little i can do them), but how i put Grub2 onto them (maybe as i normal install Gru2 onto a non encrypted partition) but how i configure main Grub2 to chainload them? That is the big question i am on now.

After solved, i wish to know how i can install any Linux onto such encrypted partition (i am afraid that Linux muxt know something about LVM / LUKS, since i will try with modern distro SolydXK i hope it will know), but if i do not know how to chainload to it, that will be of no use, i will not be able to boot it.

Have in mind: When installing each Linux i want it to not touch any bit outside the encrypted partition where i install it, this is a must for Linux isolation.

On the other hand i also want only one swap (also encrypted with its own pass) shared by all distros, this will get me mad on searching on the net.

For swap, the big question is: how to make the bootloader asks for both passwords, swap one and root one?

I do not wnat any pass stored on any place except inside my mind, no usb stick for key files, not inside any file, neither stored as a hash, etc.

I want each needed password to be asked for it on boot.

My desired partition scheme on physical drive:

*LVM (rest of the disk)
*ext4 (main /boo for main Grub2)
Note: Better if encrypted

Inside that LVM:
*swap (encrypted with pass: MySwapPass)
*Linux_1 root with /boot as folder (encrypted with pass: MyLinux_1_Pass)
*Linux_2 root with /boot as folder (encrypted with pass: MyLinux_2_Pass)

Boot secuence:
-Power ON
-Load first MBR 440 bytes of 1st sector or GPT EFI
*asks for Pass for main Grub2
-Boot into main Grub2 menu
+I select Linux_1 or Linux_2 or …
-It chainload to each Linux bootloader
*asks for root pass and for swap pass (order is not relevant)
-Boot into the Linux bootloader that has such Linux
+I let time pass or select to boot such linux
-Linux boot normally and do not asks for any pass

Maybe too complicated? most dificoult part will be sharing the swap and ask at boot for its password each time… can be solved with linux having its own swap, but i preffer to have only one.

Thanks, i will learn a lot on some steps, while others are not even commented (i will investigate them on the net).

P.D.: I see no place where an dtep by step tutorial can be seen on how to create 3 partitions (one for main Grub2, two for each own Grub2), all three encrypted with a different pass, and boot one Grub2 then chainload the other two, asking for pass on boot.

8Anonymous said at 3:53 am on May 9th, 2016:
Wow, it works like a charm! at least the first step, having an encrypted main bootloader.

Steps i had follow (for a BIOS-MBR), with a blank new virtual disk under VirtualBOX:

01.-Boot with SystemRescueCD.iso on VirtualCD slot (as SATA port 0)
Note1: VirtualBOX has a Big BUG when booting on UEFI mode if VirtualCD is not on Port 0 of SATA controller, will not boot EFI CD/DVD !
Note2: SystemRescueCD X will not start if VirtualBOX boots on UEFI mode, all must be done in console mode.
That is the way i want to do things totally manually, so i get the most knonledge, but it is the hardest way.

02.-Add (at end) to /etc/default/grub file, the line:
GRUB_ENABLE_CRYPTODISK=y
Note: can be done with, vi, nano, or just with cat.

03.-Create the test partition scheme (a very complex one that i want, i do nlot like easy things), i use fdisk fo it.
*Pri XGiB (hole for a Windows like OS)
*Pri XGiB (hole for a Windows like OS)
*Pri XGiB (hole for a Windows like OS)
*Ext Rest of the disk
+XGiB SWAP (still need to encrypt this with its own pass)
+XGiB Second_Grub2_or_a_Linux_ROOT (still need to encrypt this with its own pass)
+XGiB Grub2 (encrypted – this is the one i explain howto on this post)

Note: On next steps, # is the number of the partition, for the sample case is 7.

04.- Format the partition for Grub2 as a LUKS partition
cryptsetup luksFormat /dev/sda#
Note: The password will be asked twice, and will be the one used (i need to know how to be able to change it without reinstalling Grub2, i must investigate ‘cryptsetup luksChangeKey’)

05.- Open the LVM:
cryptsetup luksOpen /dev/sda# Grub2_crypt

06.- Create the physical volume (why they call it physical?):
pvcreate /dev/mapper/Grub2_crypt

07.- Create the volume group:
vgcreate Grub2_vg_crypt /dev/mapper/Grub2_crypt

08.- Create the logical volume:
lvcreate -l 100%FREE -n Grub2_lv_crypt Grub2_vg_crypt

09.- Show / check all go well by listing volumes:
lvdisplay

10.- Show / check all go well by listing how all is connected:
lsblk

11.- Format the Grub2 (on the fly decrypted) partition:
mkfs.ext4 -L Grub2 /dev/mapper/Grub2_vg_crypt-Grub2_lg_crypt

12.- Mount the Grub2 (on the fly decrypted) partition:
mount /dev/mapper/Grub2_vg_crypt-Grub2_lg_crypt /boot

13.- Install Grub2 onto Grub2 (on the fly decrypted) partition:
grub2-install target=i386-pc /dev/sda

Note: I do not yet create a personal /boot/grub/grub.cfg file just to test all goes well

And finally reboot.

When reboot, VirtualBOX shows Logo, then boot from VirtualHDD and wow a password is asked, if right one typed, Grub2 loads, wow!

1st Step done: Know how to install from scratch a Grub2 onto an encrypted partition.

Next step: Get someone to tell me what i must put inside /boot/grub/grub2.cfg to chainload to another encrypted partition (the one on the sample called Second_Grub2_or_a_Linux_ROOT)

But prior to that i will need to create an Ext4 under an encrypted LVM / LUKS container, maybe like the one i do for main Grub2, and install a second Grub2 on it, or maybe another different bootloader, etc.

Ken, Thanks a lot for your commands, i learn a lot… but i still need to lear a lot more, first steps done with crypto on Linux!

9Anonymous said at 4:04 am on May 9th, 2016:
By the way, i think it would also worked without all such LVM, just by doing a EXT4 partition over /dev/mapper/Grub2_crypt

Why to complicate all with LVM if i want the full /dev/sdz# encrypted and holding only one filesystem?
Easy: i was following Ken tutorial, and it is better to know how i would be able to create at least two partitions inside same encrypted container (just in case i need a separate SWAP partition).

In terms of HDD (rotational ones) speed it will be faster if each Linux has its own SWAP partition just before its own root partition, less HDD head movement when SWAP used; among this, i had never get SWAP being used more than 0% with a 2GiB PC… i know i do not run too much Linux RAM demaning apps at same time, but i like SWAP be there just in case!

P.D.: My final, final wisj is to do all this in a Linus RAID 0 (stripping) with 3 stripes (3 HDDs)… I clone System once a month (and after important software changes / config) to a External USB 3.1 enclosure, so an HDD failure is irrelevant for me… and all DATA i managed i have five copies, two online at same time at most (while doing a master / slave sync)… i am a little paranoid on security and on speed.

Said that: how can i benchmark (and how can i change encryption algorithms)?

Thanks Ken, again for a great base tutorial, you’re the one that make me get my 1st encrypted partition boot to work… i had read a lot of other tutorials and none worked for me in the manner i want, most of them requiere to install a full distro, etc, not the way i want to.

10claudio said at 7:37 am on October 27th, 2016:
Just to clarify:

I have a working PC with this config of the HDDs (they are in LVM Raid 0, so i will simplify as if they where only one), also i have tried on MBR and GPT modes, both working also with 64bit native boot, etc.

It cost me a lot to figure out how to configure all, most difficoult part was touching some initram scripts.

*###GiB*: LVM container in Raid 0 (using other HDDs)
*32GiB*: Windows 64 Bits (XP or 7 or 8 or 8.1 or 10) on a native NTFS.
*32GiB*: Windows 32 Bits (XP or 7 or 8 or 8.1 or 10) on a native NTFS.

Inside that LVM i have the top most difficoult part to install, Grub2 and some Linux:

*32Gib*: LUKS container for Linux OS 1 with its owh Grub/Grub2
*32Gib*: LUKS container for Linux OS 2with its owh Grub/Grub2
*32Gib*: LUKS container for Linux OS 3with its owh Grub/Grub2
*32Gib*: LUKS container for Linux OS 4with its owh Grub/Grub2
…and so on…
*2Gib*: LUKS container for Grub2, yes /boot is on an ecrypted partition

When PC boot, it asks for that 2Gib LUKs passphrase, the Grub2 loads.
Menu appear on screen (as i configured it on grub.cfg)
Then i select the entry i want… Windows, Linux 1, Linux 2, Linux 3, … etc.
If i select any Windows it just chainload to that partition, since no LUKs and no LVM is present on that part.

But i select any of the Linux, Grub2 instructions first do some insmod, so Grub2 mount the LVM and then the LUKs (asking for passphrase of that LUKs), i use for each one a different passphrase.

Then Grub2 can load the other Linux Grub, so its own menu, own manteined, is shown.

Of course, when i install that other Linux, i must touch a little the initram configuration, so it knows it must mount LVM and LUKs, so the initram scripts of that Linux are updated for such.

Oh!, yes such Linux passphrase is asked twice, i do not like the LUKs be mounted with a KeyFile only, i want a passphrase be needed to be typed, so since Linux partition must be mounted twice (main Grub2 and its own bootloader mantained by the Linux installed), the passphrase must be typed twice.

I had also loop, the loop, and made things more complicated… but i first put the “easy” to do… now i put the “too much dificoulf” to do (sorry, no native Windows allowed, only Linux):

The whole HDD is a LUKs without header, so i need a USB boot device to hold Grub2, again such USB microSD card is with a LUKs full disk, just to make things very, very difficoult to an attacker.

So resuming, boot would go as this:
-USB boot
-Passphare for Grub2 partition (/boot) is asked (that need Grub2 be installed with LVM and LUKs modules)
-Grub2 menu appears with only one entry (boot from HDD), so i can remove the USB as soon as possible.
-I configured grub.cfg for doing some special things
-Mount the HDD LUKs (asking the passphrase od the HDD), it will see an empty Ext4; yes, empty, yes the whole internal HDD looks like been empty, it is called denegability, i must give the passphare of the HDD it will show an empty drive (that is why i use a usb card reader to boot Grub2 from an encrypted microSD LUKs, to hide the script to mount internal HDD structure)
-Mount inside that “empty” Ext4 a region (a number of Y sectors from sector X) into a loop device.
-That one is again a LUKs without headers, it is where all important data resides hidden to anyone pointing to you with a gun on your head.
-So Grub2 will ask for a 3rd passphare (all 3 are different of course)
-Now Grub2 can see and mount a LVM structure, where another Grub2 is inside a LUKs partition.
-Chainload to that one will fail (knows nothing about all that complicated / hidden internal HDD structure), so i load that other Grub2
-Now i can unplug USB

To reach this point, where internal Grub2 menu is shown it took me to enter 3 different passphares (one for the USB boot, one to access the whole HDD LUKs that will show an “empty” Ext4, and one more to mount part of that partition defined by a sector start and a number of sectors), total time to reach that point from power off: near 10 seconds if i type fast and not fail.

Now internal hidden Grub2 boot loader is loaded and its menu is present i can select what linux i want to boot.

But hey, things are not so easy as chainload to such Grubs, again that will fail (they can not access in such way my so complicated hidden structure), i must load such boot loaders, since they are also Grub2, no problem at all.

But things get worse, here… when i installed each of such Linux i must edit initram scripts, so they again know how to mount my internal HDD very complicated structure… and that implies asking for main HDD LUKs passphrase (again), and also for the hidden area (Y sectors from sector X) that has another LUKs, so again that other passphrase is asked… then, since each Linux is on a LUKs over LVM, it will ask for a 4th different password (each Linux with its own one).

I know it is so weird and complicated… i will try to represente in a secuence of containers:

Linux root (/) is inside a Ext4 over a LUKs (Passpharse#4), inside a LVM, that LVM is inside a LUKs (Passphrase#3) that is loopmounted from a loop stored on Y sectors from sector X of a Ext4 that resides on a LUKs that resides on all the internal HDD. On the other hand my main Grub2 boot and grub.cfg script resides on a Ext4 (/boot) over a LUKs (Passphare#1) on a microSD inside a USB card reader.

That way, the whole HDD looks like a LUKs encrypted, if some one asks me its Passphrase i can give it since the only thing will be seen is an empry Ext4.

Without knowing what sector and how much i use of such partition for that Loop device, it will be seen as an empty Ext4 with garbage.

Also more, knowing that two values, there is stored anothe LUKs with different passphrase, so without that one, no luck!

And i can say i do not know there is such LUKs, i can say i only have an empty partition i use for temporal data, saying i allways boot from LiveDVDs because i am scared of Virus, etc… “deniable plausibility”.

My OS in my internal HDD is fully hidden and no one can tell it is there, neither with forensic tools.

Please consider this… i only use 10% of the HDD for such OS, on the rest space i create more non used LUKs with real garbage, etc… just to make things worst for an attacker, intruder or law border agents, police, etc.

I want my data safe for unwanted see.

Oh, yes, that is a very, very simplistic and basic configuration… i really use more than one disk (with Raid 0 like), so i span things arrounf multiple disks, making access to be much more hard to be discovered without knowing the layers structure i use… and i use more than five layers of LUKs inside LVM inside LUKs, etc… now on top most secure i am arround 75 layers, with more than 42 passphrases… for a total paranoid secure LinuxOS boot.

Yes, it took me more than 5 minutues typing pasphrases, but secure is againts fast access.

Oh! i use that madness secure Linux on a PC not connected to Internet where i use LibreOffice and hold an Inmutable VirtualBox where i have a WindowsXP where i have some apps that do not go on Linux.

For the other PC that is on my room with Internet access (i am much more paranoid on it) i use a not encrypted at all Linux… Grub2 isoloop load a SystemRescueCD.iso file, so each boot is allways the same, fast as less than 30 seconds, with X windows and Internet access… to power it off it is as simple as unplug wall power cord, no need to shutdown the linux, it is a LiveDVD iso loaded in loop mode and with all iso to ram on kernel parameters, so while working wih it the HDD can be spin down and stopped, no use of the HDD at all will happen…. to say the truth… it has no HDD at all… the Grub2 and SystemrescueCD.iso are on a USB3 stick, that i unplug as soon as user prompt brings on screen.

Paranoid to the max! That way no need to worry for Viruses, etc… no modification can be done to that Linux that is on my pocket and is not connected to the PC, while it is running.

Live distros are the very best on secure against modifications… it is like booting from a CD/DVD but much more fast, and totally secure against unwanted modifications.

By the way, i can use that Stick to boot that LiveISO Linux on near any modern PC that has USB boot support!

Also that .ISO file can be personalized… tooo much work, but can be done… so you can carry your own wanted apps, like VeraCrypt, etc.

11blades said at 4:41 am on December 19th, 2016:
What a fantastic tutorial. After 3 days dancing around google I finally managed to do this what the title says.
Thanx a lot

ps. one correction, there at the /etc/crypttab entry, the UUID must be without the “”, just plain number

12Anonymous said at 5:13 am on January 1st, 2017:
Linux /boot partitions can be logical partitions.

I allways use no primary partition at all, all inside the extended partition.

Grub2 is great on booting itself from logical Ext4 Encrypted partition, yes /boot partition where is Grub2 can also be encrypted (check howto by adding modules parameter when using grub2-install command).

100% disk encrypted

Scheme:
1. Extended
2. Empty
3. Empty
4. Empty
5. Encrypted Ext4 X MiB for main Grub2
6. Encrypted Ext4 X MiB for Linux A bootloader
7. Encrypted Ext4 X GiB for Linux A rootfs
8. Encrypted Ext4 X MiB for Linux B bootloader
9. Encrypted Ext4 X GiB for Linux B rootfs
and so on…

Also for most distros i use /boot as a folder inside encrypted rootfs

Then from main Grub2 i chainloader the PBR of each Linux distro, that will load the distro own maintained bootloader and so the main bootloader must not be edited after kernel updates, neither after a distro update changes its own bootloader from LiLo to Grub, etc.. really isolated!.

That allows Distros be isolated, have their own password and be accesible all from all by mounting them when needed.

When booting only two passphrase asked… the one for main /boot (Main Grub2), then after selecting the distro to be booted the one used for it.

All that if using old MBR style… now i preffer BIOS+GPT (i hate EFI ways, just because there is needed a non encrypted FAT32 partition)

And if i need to boot a 32Bits Windows Home from inside a GPT disk i use the trick to have a .VHD file (created from windows install media with DiskPart) that emulates a MBR disk, i put inside only one NFTS partition, where i put nt60 boot code and all BCD stuff for only thatone windows.. then i use Grub2 and memdisk to chainload to it… so that .vhd file can also be inside the encrypted /boot partition for main Grub2… i am still working on how to encrypt the GPT windows 32 bit system partition (VeraCrypt does not like Boot and System be on different disks, and when it sees system on GPT it asumes it is EFI not BIOS only), but thatis another story.

My main want is have all encrypted, including bootloaders, all of them… Grub2 is so great for that… after i discovered how to add modules to it on the command line ‘grub2-install …’ i never ever will use a non encrypted main bootloader.

13user said at 5:52 pm on May 14th, 2019:
There is a step by step (with pictures) version of this tutorial with Ubuntu 18.04.2 and Linux Mint Cinnamon
19.1 on: https://askubuntu.com/a/1128696/589584 (How can I install Ubuntu encrypted with LUKS with dual-boot?)
