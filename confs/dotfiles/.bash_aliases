# Experimental
alias bat="batcat"


# Common use
alias updatepc="sudo apt update && sudo apt -y full-upgrade"
alias speed="speedtest-cli --single --secure"
#alias ipcheck="curl --tlsv1.3 -4 https://ifconfig.me/all"
alias ipcheck="curl https://ifconfig.me/all"
alias ipinfo="curl https://ipinfo.io"
alias lynx="lynx -force_secure"
alias ddgr="ddgr --colorize -x --unsafe -n 25"
alias ytdl="youtube-dl --geo-bypass --no-call-home -f mp4"
alias ifc="ifconfig -a | grep wlp | awk '{ print $1 }' | cut -d : -f 1"

alias rmrfcache="rm -rf $HOME/.cache/* && echo 'cache cleared'"










## cd'ing around




## buku bookmark manager
#alias b="buku"
#alias bs="buku -s"
#alias bS="buku -S"
#alias bsdeep="buku -s --deep"
#alias bSdeep="buku -S --deep"



alias aliases="less -R $HOME/.bash_aliases"
alias editalias="nano $HOME/.bash_aliases && source $HOME/.bashrc"

alias editbashrc="nano $HOME/.bashrc && source $HOME/.bashrc"

alias editssh="nano $HOME/.ssh/config"



## Web Dev
#alias gd="gatsby develop"
#alias gdc="gatsby clean"
#alias gdp="gatsby develop -p"
#alias gbgs="gatsby build && gatsby serve"
#alias gdcgd="gatsby clean && gatsby develop"
#alias gdcgbgs="gatsby clean && gatsby build && gatsby serve"
#alias ycc="yarn cache clean"
#alias ycys="yarn cache clean && yarn start"
#alias ycyb="yarn cache clean && yarn build"
#alias ycybs="yarn cache clean && yarn build && yarn serve"
#alias ghc="git clone"
#alias sg="surge teardown"


#alias reactget="export HERE=$PWD && cd $HOME/scripts-n-tools/react-components && bash copycomponents.sh && cd $HERE"



## VPN



#alias wgstopall="WG_IF=$(ifconfig -a | grep wg0 | awk '{ print $1 }' | sed 's/.$//') && sudo systemctl stop wg-quick@WG_IF"

## alias wgstop="sudo systemctl stop wg-quick@wg0"

#alias wgstatus="sudo systemctl status wg-quick@*"
#alias wgcheck="sudo wg"


#alias ovon="openvpn3 session-start -c"
#alias ovoff="openvpn3 session-manage -D -c"
#alias ovr="openvpn3 session-manage --restart -c"
#alias ovcheck="openvpn3 sessions-list"




## SSH Shortcuts
alias sshnew-e="ssh-keygen -t ed25519 -o -a 100"
alias sshnew-r="ssh-keygen -t rsa -b 4096 -o -a 100"








alias sshalias="cat $HOME/.bash_aliases | grep ssh | grep -v \#" 




# vultr-cli
#alias vcli="vultr-cli"





## IP Tables
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias firewall=iptlist






## Quick net checks for sys admins
## All of our servers eth1 is connected to the Internets via vlan / router etc  ##
#alias dnstop='dnstop -l 5  eth1'
alias dnstop="dnstop -l 5 $1"

#alias vnstat='vnstat -i eth1'
alias vnstat="vnstat -i $1"

#alias iftop='iftop -i eth1'
alias iftop="iftop -i eth1 $1"

#alias tcpdump='tcpdump -i eth1'
alias tcpdump="tcpdump -i $1"

#alias ethtool='ethtool eth1'
alias ethtool="ethtool $1"

# work on wlan0 by default #
# Only useful for laptop as all servers are without wireless interface
#alias iwconfig='iwconfig wlan0'
alias iwconfig="iwconfig $1"


## pass options to free ##
## get top process eating memory
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'

## get top process eating cpu ##
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3

## Get server cpu info ##'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10' ## Get server cpu info ##

## Get server cpu info ##
alias cpuinfo='lscpu'

## older system use /proc/cpuinfo ##
##alias cpuinfo='less /proc/cpuinfo' ## 

## get GPU ram on desktop / laptop##
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'

# Show text in a file without comment (#) lines alias 
alias nocomment="grep -Ev '''^(#|$)'''"

# copy pasting to and from a terminal using x and mouse
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'



alias trace='mtr --report-wide --curses $1'
alias killtcp='sudo ngrep -qK 1 $1 -d wlp0s20f3'
alias usage='ifconfig wlp0s20f3 | grep 'bytes''
alias connections='sudo lsof -n -P -i +c 15'

## function to make backups with date in name
#bu() { cp $@ $@.backup-`date +%y%m%d`; echo "`date +%Y-%m-%d` backed up $PWD/$@" >> ~/.backups.log; }

