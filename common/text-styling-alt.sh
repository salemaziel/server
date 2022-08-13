#!/usr/bin/env bash

# Foreground/Text Colors
TEXT_BLACK=$(tput setaf 0)
TEXT_RED="$(tput setaf 1)"
TEXT_GREEN="$(tput setaf 2)"
TEXT_YELLOW="$(tput setaf 3)"
TEXT_BLUE="$(tput setaf 4)"
TEXT_MAGENTA="$(tput setaf 5)"
TEXT_CYAN="$(tput setaf 6)"
TEXT_WHITE="$(tput setaf 7)"

TEXT_DEFAULT_COLOR="$(tput setaf 9)"

# Text Styles
TEXT_BOLD=$(tput bold)
TEXT_DIM=$(tput dim)
TEXT_STANDOUT=$(tput smso)
TEXT_UNDERLINE=$(tput smul)
TEXT_BLINK=$(tput blink)
TEXT_REVERSE=$(tput rev)
TEXT_RESET=$(tput sgr0)


# Background Colors
BG_BLACK="$(tput setab 0)"
BG_RED="$(tput setab 1)"
BG_GREEN="$(tput setab 2)"
BG_YELLOW="$(tput setab 3)"
BG_BLUE="$(tput setab 4)"
BG_MAGENTA="$(tput setab 5)"
BG_CYAN="$(tput setab 6)"
BG_WHITE="$(tput setab 7)"
BG_DEFAULT="$(tput setab 9)"



echo "${BOLD}HEADING${RESET}"


echo "It's ${BOLD}${COL_RED}red${COL_NORM}${RESET} ${BOLD}and ${COL_GREEN}kinda${RESET} green${COL_NORM} - have you seen?"

