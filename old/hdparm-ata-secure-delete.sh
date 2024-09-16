#!/bin/bash

echo -e "Showing available devices"
sleep 0.5
lsblk -a

sleep 1

echo -e "Remember this MUST NOT be done over USB."
echo -e "SATA interface ONLY. Cancel now otherwise.\n\n"

sleep 1

read -rp "Enter device name (e.g. sda, sdb, hda, etc): " "DEVICE_NAME"

read -rp "You chose /dev/${DEVICE_NAME}, is that correct?" "CORRECT_DEVICE"

case $CORRECT_DEVICE in
	Y|y)
		echo -e "OK"
		;;
	N|n)
		echo -e "Quitting, start over to enter correct device"
		exit 0
		;;
	*)
		echo -e "Invalid answer, quitting."
		exit 0
		;;
esac

DRIVE="/dev/${DEVICE_NAME}"

echo -e "Check if device is frozen or not."
echo -e "Should look similar to this: \n
--------------------------------------\n
Security:
       Master password revision code = 65534
               supported
       not     enabled
       not     locked
-->    not     frozen
       not     expired: security count
               supported: enhanced erase
       2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT. \n
---------------------------------------\n\n"

sleep 1

hdparm -I "$DRIVE"

echo -e "\n Is drive frozen? If yes cancel with Ctrl+c now, DO NOT CONTINUE!\n"
sleep 1

read -rp "Is drive frozen? [y/n]" "DRIVE_FROZEN"
case $DRIVE_FROZEN in
	y|Y)
		echo -e "Quitting. Unfreeze the drive first then run script again.\n"
		echo -e "Possible ways to do this: \n - Manually put computer to sleep, then wake it back up. \n - Run command `echo -n mem > /sys/power/state` \n"
		sleep 0.5
		exit 0
		;;
	n|N)
		echo -e "Drive is not frozen? Last chance to cancel"
		read -rp "Drive is not frozen? [y/n] " "VERIFY_NOTFROZEN"
		case $VERIFY_NOTFROZEN in
			y)
				echo -e "Ok continuing"
				;;
			n)
		                echo -e "Quitting. Unfreeze the drive first then run script again.\n"
        		        echo -e "Possible ways to do this: \n - Manually put computer to sleep, then wake it back up. \n - Run command `echo -n mem > /sys/power/state` \n"
				exit 0
				;;
        		*)
                		echo -e "Invalid answer, quitting."
                		exit 0
                		;;
		esac
		;;
	*)
                echo -e "Invalid answer, quitting."
                exit 0
                ;;
esac

echo -e "Setting user password: melasleiza for user-master u on $DRIVE"
sleep 1
hdparm --user-master u --security-set-pass melasleiza "$DRIVE"

echo -e "Check it was successful, should Enabled. Output of next command should look like: \n
-----------------------------------\n
Security:
       Master password revision code = 65534
               supported
 -->           enabled
       not     locked
       not     frozen
       not     expired: security count
               supported: enhanced erase
       Security level high
       2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT. \n\n
------------------------------------\n\n"

sleep 2

hdparm -I "$DRIVE"

echo -e "\n If all good, we'll run the secure erase command.\n"

read -rp "All good? [y/n] " "ALL_GOOD"
case $ALL_GOOD in
	y)
		echo -e "Running ATA erase command on $DRIVE"
		sleep 1
		time hdparm --user-master u --security-erase melasleiza "$DRIVE"
		;;
	n)
		echo -e "Damn that was close. Quitting"
		exit 1
		;;
	*)
		echo -e "Invalid, quitting. Run this again."
		exit 0
		;;
esac

echo -e "\n Lets verify it worked, output should look like below, saying Not Enabled: \n
----------------------------\n
Security:
       Master password revision code = 65534
               supported
-->    not     enabled
       not     locked
       not     frozen
       not     expired: security count
               supported: enhanced erase
       2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.\n\n
----------------------------\n\n"

sleep 1.5

hdparm -I "$DRIVE"

echo -e "If output doesn't match the Not Enabled part, try running this again, possibly manually."
echo -e "Needed commands are at bottom of this script"
sleep 1

exit
