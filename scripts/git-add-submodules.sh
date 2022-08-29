#!/usr/bin/env bash

# This script is used to add submodules to a git repository.


SCRIPT_DIR="$( cd "$(dirname "$0")" && pwd -P )"

#if [ "$SCRIPT_DIR" === "$(pwd | cut -f 4)" ]; then
#    echo "Error: Could not determine script directory."
#    exit 1
#fi

BASE_DIR="$(cd "$SCRIPT_DIR" && cd ../ && pwd -P)"
#else
#    #BASE_DIR="$( cd ../"$(dirname "$0")" ; pwd -P )/scripts"
#    echo "scripts not found in proper dirs"
#fi

#SUBMODULE_PATH="${BASE_DIR}/"



echo $BASE_DIR

# Choose directory to download submodule to
echo -e "Enter path to directory to download submodule to: "
echo -e "Options are:\n
            app_installs/\n
            cheatsheets/\n
            common/\n
            confs/\n
            dev_installs/\n
            docker/\n
            docker/compose_files/\n
            docker/Dockerfiles/\n
            linux-fde-install/\n
            net_dev_installs/\n
            script_templates/\n
            scripts/\n
            ${BASE_DIR}/\n
" 
read -p "Enter path: " SUBMODULE_PATH

SUBMODULE_PATH=$(echo $SUBMODULE_PATH | cut -d / -f 1)

echo $SUBMODULE_PATH


# Prompt to enter list array of repos to add as submodules

read -p "Enter space-separated list of git repo URLS to add as submodules: " repo_urls
        read -a git_urls <<< $repo_urls
        echo -e "Cloning the following repos:" "${git_urls[@]}"

for url in "${git_urls[@]}" ; do 
    REPO=$(echo "$url" | cut -d / -f 5 | tr -d \")
    git submodule add  --depth=1 "$url" "$BASE_DIR"/"${SUBMODULE_PATH}"/"${REPO}" ; 
done