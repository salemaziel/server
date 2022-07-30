#!/usr/bin/env bash

set -eu -o pipefail

    if [[ -n $(which curl) ]]; then
        curl https://getcroc.schollz.com | bash
    elif [[ -n $(which wget) ]]; then
        wget -qO- https://getcroc.schollz.com | bash
    else
        echo "No curl or wget found. Please install curl or wget."
        exit 1
    fi