#!/bin/bash

set -eu -o pipefail

## Goal: Script which automatically sets up a new Ubuntu Machine after installation
## This is a basic install, easily configurable to your needs

SCRIPT_DIR=$(dirname $(readlink -f $0))
#SCRIPT_DIR="$PWD"

#CONF_NAME="none"

## Add some color

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

# shellcheck disable=SC2145
echo_cmd() { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_prompt() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_note() { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_info() { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_warn() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_debug() { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
# shellcheck disable=SC2145
echo_fail() { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }

# shellcheck source=./confs/install-conf.func
source ./confs/install-conf-func

## Require script to be run as root
super-user-check

## Detect Operating System
dist-check

## Pre-Checks system requirements
installing-system-requirements

## Ask to Install
ask-to-install

#ask-install-dotfiles

#ask-install-sysctld

#ask-install-resolved

#ask-install-grub-confs

#ask-install-sshd