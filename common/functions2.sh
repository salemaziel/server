#!/bin/bash

## App installing functions

install_teamviewer() {
    echo_info " *** installing Teamviewer for Linux *** "
    wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
    sudo gdebi -n teamviewer_amd64.deb
    rm -rf $HOME/Downloads/teamviewer_amd64.deb
}

install_tor() {
    echo_info " *** installing Tor+Torsocks *** "
    source /etc/os-release
    echo "deb https://deb.torproject.org/torproject.org ${DISTRO_CODENAME} main" | sudo tee /etc/apt/sources.list.d/onions.list
    sudo bash -c 'curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import'
    sudo bash -c 'gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -'
    sudo apt update
    sudo apt install -y tor deb.torproject.org-keyring torsocks
}


install_node() {
    echo_info " *** Installing NodeJS 12 and npm node package manager *** "
    sudo apt install gcc g++ make -y
    curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
    sudo -v
    sudo apt update
    sudo apt install -y nodejs
}

local_globalnode() {
    mkdir $HOME/.npm-global
    npm config set prefix "$HOME/.npm-global"
    echo "export PATH=$HOME/.npm-global/bin:$PATH" | tee -a $HOME/.profile
    source $HOME/.profile
    npm install npm@latest -g
}

install_yarn() {
    echo_info " *** Installing Yarn: NodeJS package manager *** "
    if [[ -z $(which node) ]]; then
        install_node
    fi
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo DEBIAN_FRONTEND=noninteractive apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update && sudo apt-get install -y yarn
}

install_firejail() {
    echo_info " *** Installing Firejail: Linux SUID Sandbox *** "
    wget https://sourceforge.net/projects/firejail/files/LTS/firejail-apparmor_0.9.56.2-LTS_1_amd64.deb
    sudo gdebi -n firejail-apparmor_0.9.56.2-LTS_1_amd64.deb
}

install_dockerce() {
    echo_info " *** Installing Docker-CE *** "
    sudo apt remove docker docker-engine docker.io containerd runc -y
    sudo apt update && sudo apt -y full-upgrade
    case ${DISTRO} in 
        ubuntu)
            sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg-agent -y
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo DEBIAN_FRONTEND=noninteractive add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            ;;
        debian)
            sudo apt-get install apt-transport-https ca-certificates curl gnupg lsb-release -y
            curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            ;;
    esac
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io -y
    sleep 2
    sudo docker -v
}

install_dockerPortainer() {
    echo_note " Installing Portainer on port 9000"
    
    sudo docker volume create portainer_data
    sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
    
    echo_note "
#####################################################################################################


            Congrats Docker Portainer has been installed, running on port:     9000


######################################################################################################
    "
    sleep 2
    
    sudo docker -v
}

install_dockercompose() {
    if [[ -z $(which docker) ]]; then
        echo_warn "Need To install Docker first "
        sleep 2
        install_dockerce
    fi
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo docker-compose --version
}


install_inxi() {
    echo_info " *** Installing Inxi (System/Hardware Identifier) *** "
    wget -O inxi https://github.com/smxi/inxi/raw/master/inxi
    chmod +x inxi
    sudo mv inxi /usr/local/bin/inxi
    sudo chown root:root /usr/local/bin/inxi
}

install_googlecloudSDK() {
    echo_info " *** installing Google Cloud Platform SDK commandline tools  *** "
    cd ; export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo DEBIAN_FRONTEND=noninteractive apt-key add -
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    sudo -v
    sudo apt update
    sudo apt install -y google-cloud-sdk
}

apparmor_grub() {
    echo_info "  *** Hardening Linux security a bit with Apparmor *** "
    sudo mkdir -p /etc/default/grub.d
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT apparmor=1 security=apparmor"'  | sudo tee /etc/default/grub.d/apparmor.cfg
    sudo update-grub
    if [[ -z $(which firejail) ]]; then
        sudo aa-enforce firejail-default
    fi
}

wireguard_server() {
    echo_info " *** Installing Wireguard VPN server  *** "
    curl -O https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh
    chmod +x wireguard-install.sh
    ./wireguard-install.sh
}

wireguard_server_manager() {
    echo_info " *** Installing Wireguard VPN server & Manager  *** "
    curl -O https://raw.githubusercontent.com/angristan/wireguard-install/master/wireguard-install.sh --create-dirs -o /usr/local/bin/wireguard-manager.sh
    chmod +x /usr/local/bin/wireguard-install.sh
    bash /usr/local/bin/wireguard-install.sh
}


install_openssh() {
    echo_info " *** Installing OpenSSH server"
    sudo apt-get install openssh-server -y
    echo_info " *** Enabling UFW firewall and opening OpenSSH port"
    sudo ufw enable
    sudo ufw allow OpenSSH
    echo_info " *** Making backup copy of original sshd_config file *** "
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
    echo_prompt "** Disable root login by SSH? [ y/n ]"
    read "disable_root"
    case "$disable_root" in
    y)
        echo_info " *** Disabling root login by SSH. Rule will be active after machine or ssh service restart *** "
        echo 'PermitRootLogin no
        PermitEmptyPasswords no' | sudo tee -a /etc/ssh/sshd_config
        echo_warn " *** Don't reboot until you've added ssh keys to another user on this machine, or else youll be locked out *** "
        sleep 5
        ;;
    n)
        echo_info " Skipping... "
        sleep 3
        ;;
    esac
    echo_info " *** Adding file with suggested SSH settings to /etc/ssh/sshd_config.suggested *** "
    sleep 3
    sudo bash -c 'cat << EOF > /etc/ssh/sshd_config.suggested
#### Using this file as your sshd_config assumes you have created an
#### sshkey and copied it to your *users* (not roots) $HOME/.ssh/authorized_keys file
#### If you restart the service without doing this, you will be locked out.
#### Before restarting the service, test with: sshd -t
#### Extended test with: sshd -T

## Even if its perfect, you should use this instead, make it a habit:
## sudo kill -SIGHUP \$(pgrep -f "sshd -D")


## sshd rereads its configuration file when it receives a hangup
## signal, SIGHUP, by executing itself with the name and options
## it was started with, e.g. /usr/sbin/sshd.

## The pgrep -f "sshd -D" part will return only the PID of the
## sshd daemon process that listens for new connections


Port 22
PermitRootLogin no
PermitEmptyPasswords no
PasswordAuthentication no
ChallengeResponseAuthentication no

# Set this to yes to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to no.
UsePAM no

AuthenticationMethods publickey
PubkeyAuthentication yes

## Expect .ssh/authorized_keys2 to be disregarded by default in future.
AuthorizedKeysFile	.ssh/authorized_keys .ssh/authorized_keys2

ClientAliveInterval 300
ClientAliveCountMax 2

X11Forwarding no
AllowAgentForwarding no
AllowTcpForwarding no

MaxAuthTries 5
MaxSessions 2
TCPKeepAlive no
Compression no

## Allow client to pass locale environment variables
AcceptEnv LANG LC_*

## override default of no subsystems
Subsystem	sftp	/usr/lib/openssh/sftp-server


## Add your users or groups here
## Ex.
#AllowUsers john sarah erik
#AllowGroups group1 staff mybackups

#AllowUsers
#AllowGroups

## Logging
#SyslogFacility AUTH
LogLevel VERBOSE



## To receive emails** upon ssh logins getting root access,
## enter the following in /root/.bashrc , replacing
## ServerName and your@email.com with your own:
## **Must have mailx package installed**

# echo "ALERT - Root Shell Access (ServerName) on:" `date` `who` | mail -s "Alert: Root Access from `who | cut -d"(" -f2 | cut -d")" -f1`" your@email.com




#### UNUSED OR DEFAULTS FROM SYSTEM  ###

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

## For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
## Change to yes if you dont trust ~/.ssh/known_hosts for
## HostbasedAuthentication
#IgnoreUserKnownHosts no
## Dont read the users ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

## Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

## GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

#GatewayPorts no
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd no
#PrintLastLog yes

#PermitUserEnvironment no

#ClientAliveInterval 0
#UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server



####   SOURCES:  #####
## https://securitytrails.com/blog/mitigating-ssh-based-attacks-top-15-best-security-practices

## https://askubuntu.com/questions/462968/take-changes-in-file-sshd-config-file-without-server-reboot

## https://stribika.github.io/2015/01/04/secure-secure-shell.html
EOF'
    
    sudo systemctl enable ssh
}

install_fail2ban() {
    echo_info " *** Installing Fail2ban  *** "
    sudo apt-get install -y fail2ban
    sudo systemctl start fail2ban
    sudo systemctl enable fail2ban
    echo_info " *** Enabling Fail2ban *** "
    sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.original
    echo '[sshd]
    enabled = true
    port = 22
    filter = sshd
    logpath = /var/log/auth.log
    maxretry = 4' | sudo tee -a /etc/fail2ban/jail.local
    echo_warn " *** DONT FORGET TO ADJUST THIS IF YOU CHANGE THE DEFAULT SSH PORT *** "
}

install_speedtestcli() {
    echo_note " *** Installing speedtest-cli *** "
    sudo apt-get install speedtest-cli -y
}

setup_sftp() {
    echo_note " *** Starting SFTP server  *** "
    echo 'Match group sftp
    ChrootDirectory /home
    X11Forwarding no
    AllowTcpForwarding no
    ForceCommand internal-sftp' | sudo tee -a /etc/ssh/sshd_config
    sudo kill -SIGHUP $(pgrep -f "sshd -D")
}

# Message of the day
add_daymsg() {
    echo_note " *** Setting System stats Message of The Day *** "
    wget https://raw.githubusercontent.com/jwandrews99/Linux-Automation/master/misc/motd.sh
    sudo mv motd.sh /etc/update-motd.d/05-info
    sudo chmod +x /etc/update-motd.d/05-info
}

unattended_sec() {
    case ${DISTRO} in
        ubuntu)
            echo_note " *** Setting Automatic downloads of security updates *** "
            sudo apt-get install -y unattended-upgrades
            echo 'Unattended-Upgrade::Allowed-Origins {
            "${distro_id}:${distro_codename}-security";
//          "${distro_id}:${distro_codename}-updates";
//          "${distro_id}:${distro_codename}-proposed";
//          "${distro_id}:${distro_codename}-backports";
            Unattended-Upgrade::Automatic-Reboot "true";
    };' | sudo tee -a /etc/apt/apt.conf.d/50unattended-upgrades
            ;;
        *)
            echo_warn " *** Sorry, only available for Ubuntu *** "
            ;;
    esac
}



install_phpcomposer() {
    if [[ -z $(which php) ]]; then
        echo "Need To install PHP first "
        sudo apt install php php-common
    fi
    EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
    
    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
    then
        >&2 echo 'ERROR: Invalid installer checksum'
        rm composer-setup.php
        exit 1
    fi
    
    php composer-setup.php --quiet
    RESULT=$?
    rm composer-setup.php
    sudo mv composer.phar /usr/local/bin/composer
    exit $RESULT
}

sysctl_conf() {
    echo "## These are to use bbr, to make tcp protocol faster (aka most of the internet):"  | sudo tee -a /etc/sysctl.conf
    echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
    echo " " | sudo tee -a /etc/sysctl.conf
    echo "## This disables WPAD, auto-proxy finding, to fix security issue of malicious websites finding local ip addresses:"  | sudo tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_challenge_ack_limit = 999999999" | sudo tee -a /etc/sysctl.conf
    echo " " | sudo tee -a /etc/sysctl.conf
}

add_php_ppa() {
    sudo apt install software-properties-common -y
    sudo DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:ondrej/php
    sudo apt update
}

#
# If you are using apache2, you are advised to add ppa:ondrej/apache2
# If you are using nginx, you are advised to add ppa:ondrej/nginx-mainline
#   or ppa:ondrej/nginx
#
#
#
