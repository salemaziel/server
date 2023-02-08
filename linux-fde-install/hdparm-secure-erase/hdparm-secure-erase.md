# Step 1 - Make sure the drive Security is not frozen:

Issue the following command, where "X" matches your device (eg. sda).

hdparm -I /dev/X

Step 1a - Ensure the drive is not frozen:

Security: 
       Master password revision code = 65534
               supported
       not     enabled
       not     locked
       not     frozen
       not     expired: security count
               supported: enhanced erase
       2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.

If the command output shows "frozen" (instead of "not frozen") then you cannot continue to the next step.

Many BIOSes will protect your drives if you have a password set (security enabled) by issuing a SECURITY FREEZE command before booting an operating system. If your drive is frozen, and it has a password enabled, try removing the password using the BIOS and powering down the system to see if that disables the freeze. Otherwise you may need to use a different motherboard (with a different BIOS).

A possible solution for SATA drives is hot-(re)plug the data cable (this might crash your kernel). If hot-(re)pluging the SATA data cable crashes the kernel try letting the operating system fully boot up, then quickly hot-(re)plug both the SATA power and data cables.

    It has been reported that hooking up the drive to an eSATA SIIG ExpressCard/54 with an eSATA enclosure will leave the drive security state to "not frozen". 

    Placing my system into "sleep" (suspend to RAM) worked too---and this may reset other drives to "not frozen" as well. This has worked on PCs from various manufacturers including Dell, Lenovo, and Clevo. Many Live distributions can be suspended to RAM for this purpose: 

 echo -n mem > /sys/power/state

    Users have also reported that IDE Drives may be unfreezed by plugging in an IDE cable to a CD-ROM first, booting your system and then moving the IDE cable to the drive in question. This will allow you to bypass "SECURITY FREEZE" commands sent by BIOS and your OS. BE AWARE, that IDE cables are not hot-pluggable and this technique possesses even higher risks; under no circumstances should you connect/disconnect/swap power cables of an HDD or CD-ROM, when your PC is on. 

Step 2 - Enable security by setting a user password:

WARNING: When the user password is set the drive will be locked after next power cycle (the drive will deny normal access until unlocked with the correct password).
Step 2a - Set a User Password:

Any password will do, as this should only be temporary. After the secure erase the password will be set back to NULL. For this procedure we'll use the password "Eins".

hdparm --user-master u --security-set-pass Eins /dev/X

Step 2a - Command Output:

security_password="Eins"

/dev/sdd:
Issuing SECURITY_SET_PASS command, password="Eins", user=user, mode=high

Step 2b - Make sure it succeeded, execute:

hdparm -I /dev/X

Step 2b - Command Output (should display "enabled"):

Security: 
       Master password revision code = 65534
               supported
               enabled
       not     locked
       not     frozen
       not     expired: security count
               supported: enhanced erase
       Security level high
       2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.

Step 3 - Issue the ATA Secure Erase command:

time hdparm --user-master u --security-erase Eins /dev/X

Step 3 Command Output:

Wait until the command completes. This example output shows it took about 40 seconds for an Intel X25-M 80GB SSD, for a 1TB hard disk it might take 3 hours or more!

security_password="Eins"

 /dev/sdd:
Issuing SECURITY_ERASE command, password="Eins", user=user
0.000u 0.000s 0:39.71 0.0%      0+0k 0+0io 0pf+0w

Step 4 - The drive is now erased! Verify security is disabled:

After a successful erasure the drive security should automatically be set to disabled (thus no longer requiring a password for access). Verify this by running the following command:

hdparm -I /dev/X

Step 4 - Command Output (should display "not enabled"):

Security: 
       Master password revision code = 65534
               supported
       not     enabled
       not     locked
       not     frozen
       not     expired: security count
               supported: enhanced erase
       2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.

Known issues:
Executing security erase without setting a password

Some variations of this are spread on various Internet sources. It does not work because security is "not enabled" (see hdparm output below).

WARNING: DO NOT DO THIS! The Lenovo BIOS at least doesn't allow you to change the password if it's empty, and also freezes the drive so it can't be unlocked later, so your drive could be password-locked forever! If you just want to remove the security lock on your drive without secure-erasing it, use --security-disable instead.

hdparm --user-master u --security-erase NULL /dev/X
security_password=""
/dev/sdd:
 Issuing SECURITY_ERASE command, password="", user=user
 ERASE_PREPARE: Input/output error

Even if you freeze or lock your drive by running the above command from a Lenovo laptop with a blank password, it is still possible to unfreeze and unlock it. First, plug the drive into a different computer. Second, perform a power cycle of the drive while you are booted into a drive utility (like Gparted). Third, issue the following command which should disable the security on the drive.

sudo hdparm --security-disable PWD  


Error: 25

With some distributions setting a password does not work:

hdparm --user-master u --security-set-pass Eins /dev/X


/dev/sdd:
Issuing SECURITY_SET_PASS command, password="Eins", user=user, mode=high
Problem issuing security command: Inappropriate ioctl for device
Error: 25

Compiling the latest hdparm from http://sourceforge.net/projects/hdparm/ resolved this problem on CentOS 5 x86_64.
Command time-out during erase with larger drives

hdparm versions prior to version 9.31 hard-coded the time-out for the erase command to be 2 hours. If your drive requires longer than 2 hours to perform a security-erase, then it will be reset part-way through the erase command.

If your drive reports that it needs longer than 120 minutes to perform the security erase operation, then you should ensure that you are using version 9.31 or newer.

If such a time-out has occurred, the output of the "time" command above will be just slightly longer than 120 minutes, and the drive will not have erased correctly. The drive will be reset when the time-out occurs, and whilst this appeared to do no harm to a 1GB Seagate ES.2, it's probably not a very well tested part of the drive firmware and should be avoided. In the case of the Seagate, the password was still enabled after the partial-erase and subsequent time-out/reset.
Alternative ATA Secure Erase Tools
HDDErase

The freeware DOS tool can also perform a ATA Secure Erase, although controller support is spotty at best.

    Page Discussion View source History 

    Log in / create account 

Navigation

    Main page
    Recent changes
    Random page

Search
 
Tools

    What links here
    Related changes
    Special pages
    Printable version
    Permanent link

Powered by MediaWiki

