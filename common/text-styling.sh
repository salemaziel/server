#!/usr/bin/env bash

# Text Styles
readonly ESC_SEQ="\x1b["
readonly COL_RESET=$ESC_SEQ"39;49;00m"
readonly TEXT_NORMAL=$ESC_SEQ"0m"

readonly TEXT_BLINK=$ESC_SEQ"5m"
readonly TEXT_BLINK_RESET=$ESC_SEQ"25m"

readonly TEXT_HIDDEN=$ESC_SEQ"8m"
readonly TEXT_HIDDEN_RESET=$ESC_SEQ"28m"

readonly TEXT_COLOR_INVERSE=$ESC_SEQ"7m"
readonly TEXT_INVERSE_RESET=$ESC_SEQ"27m"

readonly TEXT_BOLD=$ESC_SEQ"1m"
readonly TEXT_BOLD_RESET=$ESC_SEQ"22m"
readonly TEXT_BOLD_OFF=$ESC_SEQ"21m"

readonly TEXT_UNDERLINE=$ESC_SEQ"4m"
readonly TEXT_UNDERLINE_RESET=$ESC_SEQ"24m"


# Foreground/Text Colors
readonly COL_RED=$ESC_SEQ"31;01m"
readonly COL_RED_LITE=$ESC_SEQ"91;01m"

readonly COL_GREEN=$ESC_SEQ"32;01m"
readonly COL_GREEN_LITE=$ESC_SEQ"92;01m"

readonly COL_YELLOW=$ESC_SEQ"33;01m"
readonly COL_YELLOW_LITE=$ESC_SEQ"93;01m"

readonly COL_BLUE=$ESC_SEQ"34;01m"
readonly COL_BLUE_LITE=$ESC_SEQ"94;01m"

readonly COL_MAGENTA=$ESC_SEQ"35;01m"
readonly COL_MAGENTA_LITE=$ESC_SEQ"95;01m"

readonly COL_CYAN=$ESC_SEQ"36;01m"
readonly COL_CYAN_LITE=$ESC_SEQ"96;01m"

readonly COL_GRAY=$ESC_SEQ"90;01m"
readonly COL_GRAY_LITE=$ESC_SEQ"37;01m"

readonly COL_WHITE=$ESC_SEQ"97;01m"





### Deprecated but leaving for compatibility.. will remove eventually
## Add some color

ANSI_RED=$'\033[1;31m'
ANSI_YEL=$'\033[1;33m'
ANSI_GRN=$'\033[1;32m'
ANSI_VIO=$'\033[1;35m'
ANSI_BLU=$'\033[1;36m'
ANSI_WHT=$'\033[1;37m'
ANSI_RST=$'\033[0m'

echo_cmd()    { echo -e "${ANSI_BLU}${@}${ANSI_RST}"; }
echo_prompt() { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_note()   { echo -e "${ANSI_GRN}${@}${ANSI_RST}"; }
echo_info()   { echo -e "${ANSI_WHT}${@}${ANSI_RST}"; }
echo_warn()   { echo -e "${ANSI_YEL}${@}${ANSI_RST}"; }
echo_debug()  { echo -e "${ANSI_VIO}${@}${ANSI_RST}"; }
echo_fail()   { echo -e "${ANSI_RED}${@}${ANSI_RST}"; }