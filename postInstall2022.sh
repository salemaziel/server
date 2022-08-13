#!/bin/bash

set -eu -o pipefail


ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

echo_cmd()    { printf "${ANSI_BLU}${@}${ANSI_RST}"; }
echo_prompt() { printf "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_note()   { printf "${ANSI_GRN}${@}${ANSI_RST}"; }
echo_info()   { printf "${ANSI_WHT}${@}${ANSI_RST}"; }
echo_warn()   { printf "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_debug()  { printf "${ANSI_VIO}${@}${ANSI_RST}"; }
echo_fail()   { printf "${ANSI_RED}${@}${ANSI_RST}"; }

echo_cmd "is this working? \n"