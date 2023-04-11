#!/usr/bin/env bash

# Variables
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
declare -r -x SCRIPT_DIR
# declare -r -x SCRIPT_DIR=$(dirname "$(readlink -f """$0""")")