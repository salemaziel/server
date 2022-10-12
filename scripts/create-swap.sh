#!/bin/bash


SWAP_DIR_PATH="${SWAP_DIR_PATH:-/mnt}"

SWAP_SIZE_COUNT="${SWAP_SIZE_COUNT:-2048}"
SWAP_SIZE_GiB="${SWAP_SIZE_GiB:-2GiB}"

#SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
SWAP_PATH="${SWAP_PATH:-$SWAP_DIR_PATH/$SWAP_SIZE_GiB.swap}"

mk-swap(){

echo "dd if bs 1m count=${SWAP_SIZE_COUNT}" of "${SWAP_DIR_PATH}"/"${SWAP_SIZE_GiB}".swap
sudo dd if=/dev/zero bs=1M count="${SWAP_SIZE_COUNT}" of="${SWAP_DIR_PATH}"/"${SWAP_SIZE_GiB}".swap status=progress
sleep 0.5

echo -e "\n"
echo chmoding "${SWAP_PATH}"
sudo chmod 600 "${SWAP_PATH}"
sleep 0.5

echo -e "\n"
echo makeswap "${SWAP_PATH}"
mkswap "${SWAP_PATH}"
sleep 0.5

echo -e "\n"
echo swapping on "${SWAP_PATH}"
swapon "${SWAP_PATH}"
sleep 0.5

echo -e "\n"
echo "${SWAP_PATH}" swap swap defaults 0 0 | sudo tee -a /etc/fstab
#echo "${SWAP_PATH}" swap swap defaults 0 0 | tee -a /tmp/fstabtest
}


choose-path(){
	echo -e "\nEnter path to directory to create swap in:"
	echo -e "     e.g. : /mnt              	           "
	read SWAP_DIR_PATH
}

choose-size-count(){
        echo -e "\nEnter swap size:  "
        echo -e " e.g. : 2048      "
        read SWAP_SIZE_COUNT
}

choose-size-gib(){
        echo -e "\nEnter swap size in GiB:  "
	echo -e "Integer only; GiB appended to it automatically"
        echo -e " e.g. : 2"
        read SWAP_SIZE_GiB
	case $SWAP_SIZE_GiB in
		1)
			SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
			SWAP_SIZE_COUNT="1024"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
			;;
                2)
	                SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
        	        SWAP_SIZE_COUNT="2048"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
        	        ;;
                3)
        	        SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
                	SWAP_SIZE_COUNT="3072"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
               		;;
                4)
                	SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
                	SWAP_SIZE_COUNT="4096"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
                	;;
                5)
                	SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
                	SWAP_SIZE_COUNT="5120"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
                	;;
                6)
                	SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
                	SWAP_SIZE_COUNT="6144"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
                	;;
                8)
                	SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
                	SWAP_SIZE_COUNT="8192"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
                	;;
                10)
                	SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
                	SWAP_SIZE_COUNT="10240"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
                	;;
                12)
                	SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
                	SWAP_SIZE_COUNT="12288"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
                	;;
                16)
                	SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
                	SWAP_SIZE_COUNT="16384"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
                	;;
		*)
			SWAP_SIZE_COUNT=$((1024*"${SWAP_SIZE_GiB}"))
                	SWAP_SIZE_GiB="${SWAP_SIZE_GiB}GiB"
			SWAP_PATH="${SWAP_DIR_PATH}/${SWAP_SIZE_GiB}.swap"
                	;;
	esac
}


display-var-details(){
	echo -e "----------------------"
        echo -e "\nUsing the following:\n"
        echo -e "Directory to put swap in: ${SWAP_DIR_PATH}"
        echo -e "Swap size: ${SWAP_SIZE_COUNT}"
        echo -e "Swap size in GiB: ${SWAP_SIZE_GiB}"
        echo -e "Will be added to fstab as: ${SWAP_PATH} swap swap defaults 0 0 \n"
        echo -e "----------------------\n"

}




choose-custom(){
	while [ "$iscorrect" = "" ] || [ "$iscorrect" = "n" ];
	do
		choose-path

		sleep 0.5

		choose-size-gib

		display-var-details

		read -p "Is this correct? [y/n] " iscorrect
		case $iscorrect in
			y|Y)
				mk-swap
				;;
			n|N)
				echo -e "trying again"
				;;
			*)
				echo -e "invalid"
				;;
		esac
	done
}




defaults(){
	echo -e "\nCurrent defaults:\n"
	echo -e "Directory to put swap in: ${SWAP_DIR_PATH}"
	echo -e "Swap size: ${SWAP_SIZE_COUNT}"
	echo -e "Swap size in GiB: ${SWAP_SIZE_GiB}"
	echo -e "Will be added to fstab as: ${SWAP_PATH} swap swap defaults 0 0 \n"

	sleep 1
	read -p "Keep defaults? [y/n]  " defaultchoice
}

main(){

defaults

case $defaultchoice in
	y|Y|yes|YES)
			display-var-details
			sleep 1
			mk-swap
			;;
	n|N|no|NO)
			choose-custom
			sleep 1
			display-var-details
			;;
		*)
			echo -e "invalid choice. quitting"
			sleep 0.5
			exit 1
			;;
esac
}


main
