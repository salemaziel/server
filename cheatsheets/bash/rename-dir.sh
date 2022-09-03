#!/bin/bash

#Searches for directories and renames them according to the specified pattern

BASE_DIR="$(realpath .)"

cd "$BASE_DIR" || exit

for dir in *
do
	if [[ -d "$dir" ]]; then
		cd ./"$dir" || exit
		for d in *
		do
   	 		if [ -d "$d" ]; then
				rename -v 'y/season_/Season /'
#      				mv -- "$d" "{d}_$(date +%Y%m%d)"
				cd "$BASE_DIR" || exit
	    		fi
		done
	fi
	cd "$BASE_DIR" || exit
done
