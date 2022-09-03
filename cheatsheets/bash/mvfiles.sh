#!/bin/bash

BASE_DIR="$(realpath .)"

#ARRAY=($(ls))

cd "$BASE_DIR" || exit
while true; do
	for dir in * ; do
		cd "$dir" || exit
		if [[ -z $(ls | grep '~Get Your Files Here !') ]]; then
			echo -e "not in here"
			sleep 3
			cd "$BASE_DIR" || exit
			echo $PWD
			sleep 3
		elif [[ -n $(ls | grep '~Get Your Files Here !') ]]; then
			echo -e "present in this directory"
			sleep 3
			#mv ./'~Get Your Files Here !'/* .
			echo -e "Moved files"
			sleep 1
			echo -e "checking if anything left"
			ls ./'~Get Your Files Here !'/

			# rm -rf '~Get Your Files Here !'
		else
			cd "$BASE_DIR"
			echo $PWD
		fi
	done
done
