#!/bin/bash

source ./text-styling.sh



## create regular use with sudo privileges
function create-sudo-user() {
echo_prompt "Create a new regular user with sudo privileges? [y/n] "
read create_user
case $create_user in
    Y|y)
        echo_prompt "Enter username: "
        read new_user
        if [[ -n $(getent passwd | grep $new_user) ]]; then
            echo_fail "User $new_user already exists!"
            sleep 2
            echo_prompt "Change password for $new_user? [y/n] "
            read change_passwd
            case $change_passwd in
                y)
                    echo_note "Ok, lets update that password"
                    echo_info "Must be 8+ characters with mix of letters, digits, & symbols"
                    read -rp  ${COL_YELLOW}"Enter password for new user: "{$COL_RESET} "${TEXT_HIDDEN}new_passwd2${TEXT_HIDDEN_RESET}"
#                    read new_passwd2
                    sudo echo -e "$new_passwd2\n$new_passwd2" | passwd $new_user > /dev/null 2>&1
                    echo_note "Password for $new_user successfully changed"
                        ;;
                n)
                    echo_note "Ok, continuing"
                    sleep 2
                        ;;
            esac
        else
            echo_info "Must be 8+ characters with mix of letters, digits, & symbols"
            read -rp  ${COL_YELLOW}"Enter password for new user: "{$COL_RESET} "${TEXT_HIDDEN}new_passwd${TEXT_HIDDEN_RESET}"
#            read new_passwd
            add_usersudo
            sleep 2
        fi
            ;;
    N|n)
        echo_note "Fsho."
        sleep 2
            ;;
    *)
        echo_fail "Bruh."
        sleep 1
        echo_warn "You only had TWO options."
        sleep 2
        echo_warn "Terrible. Take a lap."
        sleep 2
        exit 1
            ;;
esac
}


add_usersudo() {
    echo_note " *** Creating new user with sudo privileges *** "
    useradd -m -s /bin/bash -U $new_user
    usermod -aG sudo $new_user
    sudo echo -e "$new_passwd\n$new_passwd" | passwd $new_user > /dev/null 2>&1
    if [[ -a $HOME/.ssh/authorized_keys ]]; then
        echo_note "Copying SSH authorized_keys file to new user"
        sleep 2
        cp -r $HOME/.ssh /home/$new_user/.ssh
        chown -R $new_user:$new_user /home/$new_user/.ssh
    fi
    echo_note "New user $new_user successfully created with sudo privileges"
    sleep 2
}




#create-sudo-user

