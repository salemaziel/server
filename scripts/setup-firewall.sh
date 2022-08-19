#!/bin/bash

set -eu -o pipefail

echo "==> Setting up firewall"

has_ipv6=$(cat /proc/net/if_inet6 >/dev/null 2>&1 && echo "yes" || echo "no")

# wait for 120 seconds for xtables lock, checking every 1 second
readonly iptables="iptables --wait 120 --wait-interval 1"
readonly ip6tables="ip6tables --wait 120 --wait-interval 1"

function ipxtables() {
    $iptables "$@"
    [[ "${has_ipv6}" == "yes" ]] && $ip6tables "$@"
}


create_fwchain() { 
echo -e "Creating Firewall chain: VDFIREWALL"
ipxtables -t filter -N VDFIREWALL || true
ipxtables -t filter -F VDFIREWALL # empty any existing rules
}


# first setup any user IP block lists
#ipset create cloudron_blocklist hash:net || true
#ipset create cloudron_blocklist6 hash:net family inet6 || true
#/home/yellowtent/box/src/scripts/setblocklist.sh

#$iptables -t filter -A VDFIREWALL -m set --match-set cloudron_blocklist src -j DROP


# the DOCKER-USER chain is not cleared on docker restart
#if ! $iptables -t filter -C DOCKER-USER -m set --match-set cloudron_blocklist src -j DROP; then
#    $iptables -t filter -I DOCKER-USER 1 -m set --match-set cloudron_blocklist src -j DROP
#fi

#$ip6tables -t filter -A VDFIREWALL -m set --match-set cloudron_blocklist6 src -j DROP

# there is no DOCKER-USER chain in ip6tables, bug?
#$ip6tables -D FORWARD -m set --match-set cloudron_blocklist6 src -j DROP || true
#$ip6tables -I FORWARD 1 -m set --match-set cloudron_blocklist6 src -j DROP

allow_related_established() {
# allow related and establisted connections
read -p "Allow related and established connections for webserver (22,80,443) or ssh(22) only? (w/s) " allow_related_established_choice

if [ "$allow_related_established_choice" == "w" ]; then
    echo -e "Allowing related and established connections for webserver"
        ipxtables -t filter -A VDFIREWALL -m state --state RELATED,ESTABLISHED -j ACCEPT
        ipxtables -t filter -A VDFIREWALL -p tcp -m tcp -m multiport --dports 22,80,443 -j ACCEPT 
elif [ "$allow_related_established_choice" == "s" ]; then
    echo -e "Allowing related and established connections for ssh only"
        ipxtables -t filter -A VDFIREWALL -m state --state RELATED,ESTABLISHED -j ACCEPT
        ipxtables -t filter -A VDFIREWALL -p tcp -m tcp -m multiport --dports 22 -j ACCEPT 
else
    allow_related_established_choice
fi


}


whitelist_ports_selection() {
    until [[ "${confirm_ports}" == "y" || "${confirm_ports}" == "Y" ]]; do
        read -p "Enter space separated list of ports: " ports
        read -a whitelist_ports <<< $ports
        echo -e Whitelisting the following ports: "${whitelist_ports[@]}"
        read -p "Is this correct? [y/n] " confirm_ports
    done

}
# whitelist any user ports. we used to use --dports but it has a 15 port limit (XT_MULTI_PORTS)
#ports_json="/home/yellowtent/platformdata/firewall/ports.json"
#if allowed_tcp_ports=$(node -e "console.log(JSON.parse(fs.readFileSync('${ports_json}', 'utf8')).allowed_tcp_ports.join(' '))" 2>/dev/null); then
allowed_tcp_ports(){
    read -p "White list any TCP ports? [y/n] " whitelist_tcp
    if [ "$whitelist_tcp" == "y" ] || [ "$whitelist_tcp" == "Y" ]; then
        read -p "Enter space separated list of ports: " ports
        read -a tcp_ports <<< $ports
        echo -e Whitelisting the following ports: "${tcp_ports[@]}"
#        whitelist_ports_selection

        read -p "Is this correct? [y/n] " confirm_ports
        if [ "$confirm_ports" == "y" ] || [ "$confirm_ports" == "Y" ]; then
            for ports in "${tcp_ports[@]}" ; do
                ipxtables -t filter -A VDFIREWALL -p tcp -m tcp --dport "${ports}" -j ACCEPT
            done
        else
            echo "Please re-run the script"
            sleep 1
            echo "actually do it manually, i'm not going to do it for you"
            sleep 1
        fi
    fi
#    read -p "Enter comma separated list of allowed tcp ports: " allowed_tcp_ports
#if allowed_tcp_ports=$(node -e "console.log(JSON.parse(fs.readFileSync('${ports_json}', 'utf8')).allowed_tcp_ports.join(' '))" 2>/dev/null); then
#    for p in $allowed_tcp_ports; do
#        ipxtables -A VDFIREWALL -p tcp -m tcp --dport "${p}" -j ACCEPT
#    done
#fi
}

allowed_udp_ports(){
    read -p "White list any UDP ports? [y/n] " whitelist_udp
    if [ "$whitelist_udp" == "y" ] || [ "$whitelist_udp" == "Y" ]; then
        read -p "Enter space separated list of ports: " ports
        read -a udp_ports <<< $ports
        echo -e Whitelisting the following ports: "${udp_ports[@]}"
#        whitelist_ports_selection

        read -p "Is this correct? [y/n] " confirm_ports
        if [ "$confirm_ports" == "y" ] || [ "$confirm_ports" == "Y" ]; then
            for ports in "${udp_ports[@]}" ; do
                ipxtables -A VDFIREWALL -p udp -m udp --dport "${ports}" -j ACCEPT
            done
        else
            echo "Please re-run the script"
            sleep 1
            echo "actually do it manually, i'm not going to do it for you"
            sleep 1
        fi
    fi

}


#if allowed_udp_ports=$(node -e "console.log(JSON.parse(fs.readFileSync('${ports_json}', 'utf8')).allowed_udp_ports.join(' '))" 2>/dev/null); then
#    for p in $allowed_udp_ports; do
#        ipxtables -A VDFIREWALL -p udp -m udp --dport "${p}" -j ACCEPT
#    done
#fi

# LDAP user directory allow list
#ipset create cloudron_ldap_allowlist hash:net || true
#ipset flush cloudron_ldap_allowlist

#ipset create cloudron_ldap_allowlist6 hash:net family inet6 || true
#ipset flush cloudron_ldap_allowlist6

#ldap_allowlist_json="/home/yellowtent/platformdata/firewall/ldap_allowlist.txt"


# delete any existing redirect rule
#$iptables -t nat -D PREROUTING -p tcp --dport 636 -j REDIRECT --to-ports 3004 2>/dev/null || true
#$ip6tables -t nat -D PREROUTING -p tcp --dport 636 -j REDIRECT --to-ports 3004 >/dev/null || true
#if [[ -f "${ldap_allowlist_json}" ]]; then
#    # without the -n block, any last line without a new line won't be read it!
#    while read -r line || [[ -n "$line" ]]; do
#        [[ -z "${line}" ]] && continue # ignore empty lines
#        [[ "$line" =~ ^#.*$ ]] && continue # ignore lines starting with #
#        if [[ "$line" == *":"* ]]; then
#            ipset add -! cloudron_ldap_allowlist6 "${line}" # the -! ignore duplicates
#        else
#            ipset add -! cloudron_ldap_allowlist "${line}" # the -! ignore duplicates
#        fi
#    done < "${ldap_allowlist_json}"

    # ldap server we expose 3004 and also redirect from standard ldaps port 636
#    $iptables -t nat -I PREROUTING -p tcp --dport 636 -j REDIRECT --to-ports 3004
#    $iptables -t filter -A VDFIREWALL -m set --match-set cloudron_ldap_allowlist src -p tcp --dport 3004 -j ACCEPT

#    $ip6tables -t nat -I PREROUTING -p tcp --dport 636 -j REDIRECT --to-ports 3004
#    $ip6tables -t filter -A VDFIREWALL -m set --match-set cloudron_ldap_allowlist6 src -p tcp --dport 3004 -j ACCEPT
#fi


turn_stun() {
# turn and stun service
ipxtables -t filter -A VDFIREWALL -p tcp -m multiport --dports 3478,5349 -j ACCEPT
ipxtables -t filter -A VDFIREWALL -p udp -m multiport --dports 3478,5349 -j ACCEPT
ipxtables -t filter -A VDFIREWALL -p udp -m multiport --dports 50000:51000 -j ACCEPT
}


allow_icmp() {
# ICMPv6 is very fundamental to IPv6 connectivity unlike ICMPv4
$iptables -t filter -A VDFIREWALL -p icmp --icmp-type echo-request -j ACCEPT
$iptables -t filter -A VDFIREWALL -p icmp --icmp-type echo-reply -j ACCEPT
$ip6tables -t filter -A VDFIREWALL -p ipv6-icmp -j ACCEPT
}


allow_dns_docker_localhost() {
ipxtables -t filter -A VDFIREWALL -p udp --sport 53 -j ACCEPT
$iptables -t filter -A VDFIREWALL -s 172.18.0.0/16 -j ACCEPT # required to accept any connections from apps to our IP:<public port>
ipxtables -t filter -A VDFIREWALL -i lo -j ACCEPT # required for localhost connections (mysql)
}


log_dropped_in() {
# log dropped incoming. keep this at the end of all the rules
ipxtables -t filter -A VDFIREWALL -m limit --limit 2/min -j LOG --log-prefix "Packet dropped: " --log-level 7
ipxtables -t filter -A VDFIREWALL -j DROP
}

prepend_chain() {
# prepend our chain to the filter table
$iptables -t filter -C INPUT -j VDFIREWALL 2>/dev/null || $iptables -t filter -I INPUT -j VDFIREWALL
$ip6tables -t filter -C INPUT -j VDFIREWALL 2>/dev/null || $ip6tables -t filter -I INPUT -j VDFIREWALL
}


rate_limit() {
# Setup rate limit chain (the recent info is at /proc/net/xt_recent)
ipxtables -t filter -N VDFIREWALL_RATELIMIT || true
ipxtables -t filter -F VDFIREWALL_RATELIMIT # empty any existing rules
}

log_dropped_incoming() {
# log dropped incoming. keep this at the end of all the rules
ipxtables -t filter -N VDFIREWALL_RATELIMIT_LOG || true
ipxtables -t filter -F VDFIREWALL_RATELIMIT_LOG # empty any existing rules
ipxtables -t filter -A VDFIREWALL_RATELIMIT_LOG -m limit --limit 2/min -j LOG --log-prefix "IPTables RateLimit: " --log-level 7
ipxtables -t filter -A VDFIREWALL_RATELIMIT_LOG -j DROP
}


allow_http_https() {
# http https
for port in 80 443; do
    ipxtables -A VDFIREWALL_RATELIMIT -p tcp --syn --dport ${port} -m connlimit --connlimit-above 5000 -j VDFIREWALL_RATELIMIT_LOG
done
}

allow_ssh() {
# ssh
#for port in 22; do
#    ipxtables -A VDFIREWALL_RATELIMIT -p tcp --dport ${port} -m state --state NEW -m recent --set --name "public-${port}"
#    ipxtables -A VDFIREWALL_RATELIMIT -p tcp --dport ${port} -m state --state NEW -m recent --update --name "public-${port}" --seconds 10 --hitcount 5 -j VDFIREWALL_RATELIMIT_LOG
#done
ipxtables -A VDFIREWALL_RATELIMIT -p tcp --dport 22 -m state --state NEW -m recent --set --name "public-22"
ipxtables -A VDFIREWALL_RATELIMIT -p tcp --dport 22 -m state --state NEW -m recent --update --name "public-22" --seconds 10 --hitcount 5 -j VDFIREWALL_RATELIMIT_LOG
}


# ldaps
#for port in 636 3004; do
#    ipxtables -A VDFIREWALL_RATELIMIT -p tcp --syn --dport ${port} -m connlimit --connlimit-above 5000 -j VDFIREWALL_RATELIMIT_LOG
#done


translate_docker() {
# docker translates (dnat) 25, 587, 993, 4190 in the PREROUTING step
for port in 2525 4190 9993; do
    $iptables -A VDFIREWALL_RATELIMIT -p tcp --syn ! -s 172.18.0.0/16 -d 172.18.0.0/16 --dport ${port} -m connlimit --connlimit-above 50 -j VDFIREWALL_RATELIMIT_LOG
done
}


ldap_mail() {
# msa, ldap, imap, sieve, pop3
for port in 2525 3002 4190 9993 9995; do
    $iptables -A VDFIREWALL_RATELIMIT -p tcp --syn -s 172.18.0.0/16 -d 172.18.0.0/16 --dport ${port} -m connlimit --connlimit-above 500 -j VDFIREWALL_RATELIMIT_LOG
done
}

docker_net() {
# cloudron docker network: mysql postgresql redis mongodb
for port in 3306 5432 6379 27017; do
    $iptables -A VDFIREWALL_RATELIMIT -p tcp --syn -s 172.18.0.0/16 -d 172.18.0.0/16 --dport ${port} -m connlimit --connlimit-above 5000 -j VDFIREWALL_RATELIMIT_LOG
done
}

ratelimit_input() {
# Add the rate limit chain to input chain
$iptables -t filter -C INPUT -j VDFIREWALL_RATELIMIT 2>/dev/null || $iptables -t filter -I INPUT 1 -j VDFIREWALL_RATELIMIT
$ip6tables -t filter -C INPUT -j VDFIREWALL_RATELIMIT 2>/dev/null || $ip6tables -t filter -I INPUT 1 -j VDFIREWALL_RATELIMIT
}


docker_workaround() {
# Workaround issue where Docker insists on adding itself first in FORWARD table
ipxtables -D FORWARD -j VDFIREWALL_RATELIMIT || true
ipxtables -I FORWARD 1 -j VDFIREWALL_RATELIMIT
}





## Dialog multiple choice menu for selecting apps to install
cmd=(dialog --separate-output --checklist "Default is to Install None. Navigate with Up/Down Arrows. \n 
Select/Unselect with Spacebar. Hit Enter key When Finished To Continue. \n
ESC key/Cancel will continue without installing any options \n
Use Ctrl+c to quit" 22 126 16)
options=(1 "Allow ICMP" on
         2 "Allow Docker DNS to localhost" off
         3 "Allow SSH" on
         4 "Allow Webserver" on
         5 "Whitelist Custom TCP Ports" off
         6 "Whitelist Custom UDP Ports" off
         7 "Allow Stun/TURN" off
         8 "Fix for docker adding itself first in FORWARD table" off
#         8 "Translate docker dnat ports in PREROUTING step" off
#         9 "" off
        )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)



# Create FW Chain
create_fwchain

# Allow related and established connections
allow_related_established


for FWRULES in $choices
do
    case $FWRULES in
        1)
#            ICMP=1
            allow_icmp
            ;;
        2)
#            allow_dns_docker_localhost
            DNSDOCKER=1
            ;;
        3)
#            allow_ssh
            SSH=1
            ;;
        4)
#            allow_webserver
            WEBSERVER=1
            ;;
        5)
#            allowed_tcp_ports
            CUSTOMTCP=1
            ;;
        6)
#            allowed_udp_ports
            CUSTOMUDP=1
            ;;
        7) 
#            allow_stun_turn
            STUN=1
            ;;
        8) 
#            docker_workaround
            DOCKERWORKAROUND=1
            ;;
    esac
done

if [ $STUN -eq 1 ]; then
    allow_stun_turn
fi

if [ $ICMP -eq 1 ]; then
    allow_icmp
fi
if [ $DNSDOCKER -eq 1 ]; then
    allow_dns_docker_localhost
fi

log_dropped_in

prepend_chain

rate_limit

log_dropped_incoming

if [ $WEBSERVER -eq 1 ]; then
    allow_webserver
fi

if [ $SSH -eq 1 ]; then
    allow_ssh
fi

if [ $CUSTOMTCP -eq 1 ]; then
    allowed_tcp_ports
fi

if [ $CUSTOMUDP -eq 1 ]; then
    allowed_udp_ports
fi
if [ $DOCKERWORKAROUND -eq 1 ]; then
    docker_workaround
fi


# add rate limit chain to input chain
ratelimit_input


# Workaround for docker adding itself first in FORWARD table
docker_workaround

exit 0

# Ask allow turn and stun ports: 3478, 5349, 50000:51000 on tcp and udp
#read -p "Allow Turn and Stun ports?  " "turnstunports"
#case $turnstunports in
#    y)
#    turn_stun
#    ;;
#    n)
#    sleep 0.5
#    ;;
#esac


# Allow ICMP & ICMPv6
allow_icmp

# required to accept any connections from apps to our IP:<public port>
allow_dns_docker_localhost

# Log dropped incoming. keep this at end of rules
log_dropped_in


# Prepend our chain to filter table
prepend_chain

# Setup rate limit chain
rate_limit

# Log dropped incoming. Keep this at end of rules
log_dropped_incoming

# Allow tcp 80 & 443
allow_http_https

# Allow ssh on 22
allow_ssh


# Ask allow translate 
#read -p "Translate docker ports for 2525, 4190, 9993 (mail, sieve,ldap?)  #" "translatedocker"
#case $translatedocker in
#    y)
#    translate_docker
#    ldap_mail
#    ;;
#    n)
#    sleep 0.5
#    ;;
#esac


# Ask allow internal services, mysql, postgresql, redis, mongodb
read -p "Allow internal services, mysql, postgresql, redis, mongodb  " "allowinternal"
case $allowinternal in
    y)
    docker_net
    ;;
    n)
    sleep 0.5
    ;;
esac


# add rate limit chain to input chain
ratelimit_input


# Workaround for docker adding itself first in FORWARD table
docker_workaround

