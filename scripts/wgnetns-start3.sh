#!/bin/bash

set -u -o pipefail

readonly WHT="\033[1;37m"
readonly YEL="\033[1;33m"
readonly PRPL="\033[1;35m"
readonly RST="\033[0m"

print_color() {
    printf "\n%b%s%b\n" "$2" "$1" "$RST"
}


readonly WGNS_DIR=$HOME/.wg-netns
[[ -d $WGNS_DIR ]] || {
    echo "Directory $WGNS_DIR doesnt exist so no configs to use. Quitting"
    exit 1
}

WGNS_LIST=$(ls -1 "$WGNS_DIR" | grep -v yaml | grep json | cut -d . -f 1)

check_valid_namespace() {
    if ! echo "$WGNS_LIST" | grep -q "^$1\$"; then
        print_color "Invalid or missing WireGuard namespace. Please, choose one from the list." "$YEL"
        exit 1
    fi
}

check_valid_application() {
    if ! [[ "$1" =~ ^(firefox|librewolf|google-chrome|vivaldi|vivaldi-stable|vivaldi-snapshot|code|code-insiders|bash)$ ]]; then
        echo -e "Invalid application name. Only browsers, vscode and bash are allowed."
        exit 1
    fi
}

run_application() {
    print_color "Application to run? " "$PRPL"
    read -r APP2RUN
    check_valid_application "$APP2RUN"


    case "$APP2RUN" in
    firefox | librewolf)
        APP2RUN="$APP2RUN --no-remote"
        ;;
    bash)
        APP2RUN="$APP2RUN -i"
        ;;
    q | x)
        exit 0
        ;;
    esac

    export APP2RUN
    sudo -E ip netns exec "$WGNS_CHOICE" sudo -u "$USER" "HOME=$HOME" "PULSE_SERVER=/run/user/$(id -u)/pulse/native" "PULSE_COOKIE=$HOME/.config/pulse/cookie" $APP2RUN || {
        echo "Failed to run $APP2RUN" && return 1
    }
}

main() {
    WGNS_CHECK=$(wg-netns list)
    if [[ -n "$WGNS_CHECK" ]]; then
        print_color "Existing WG Namespaces already up" "$YEL"
        printf "%b%s%b\n" "$WGNS_CHECK"
        printf "\n%b%s%b\n" "---------------------"
    fi

    print_color "Which WG connection?" "$PRPL"
    echo -e "${WHT}$WGNS_LIST${RST}\n"
    read -r WGNS_CHOICE
    check_valid_namespace "$WGNS_CHOICE"

    WGNS_CONFIG="${WGNS_CHOICE}.json"
    WGNS_PATH="$WGNS_DIR/$WGNS_CONFIG"

    if [[ -n $(wg-netns list | grep "$WGNS_CHOICE") ]]; then
        print_color "The network namespace $WGNS_CHOICE is already up." "$YEL"
        read -p "Would you like to bring it down? [y/n] " -n 1 -r
        printf "\n%b%s%b\n" "---------------------"

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            wg-netns down "$WGNS_PATH"
            exit 0
        else
            print_color "Leaving net namespace $WGNS_CHOICE up." "$YEL"
            run_application
        fi

    elif [[ "$WGNS_CHOICE" == "q" ]] || [[ "$WGNS_CHOICE" == "x" ]]; then
        exit 0
    else
        print_color "Creating and connecting to $WGNS_CHOICE" "$YEL"
        wg-netns up "$WGNS_PATH"
        run_application
    fi
}

main

#main "$@"

# line 13 - 15
# Where i originally had below
#WGNS_CHECK=$(wg-netns list)

# line 41 - 44
    #if ! [[ "$APP2RUN" =~ ^(firefox|librewolf|google-chrome|vivaldi|vivaldi-stable|vivaldi-snapshot|code|code-insiders|bash)$ ]]; then
    #    echo -e "Invalid application name. Only browsers, vscode and bash are allowed."
    #    exit 1
    #fi

# line 62 at top of main function
    # Codemancer recommended putting below here
