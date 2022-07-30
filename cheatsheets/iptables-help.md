## Syntax


##### sudo iptables -A INPUT -p tcp -m tcp --dport 22 --m geoip --src-cc PE -j ACCEPT

-A INPUT add a rule to the INPUT chain, a chain is a group of rules, the ones we use most on this guide will be INPUT, OUTPUT and PREROUTING.

-p tcp set tcp as the protocol this rule will apply to, you can also use other protocols such as udp, icmp or all.

-m tcp use the tcp module. iptables supports additional features via modules, some of which come already preinstalled with iptables and others, such as the geoip module.

--dport 22 the commands starting with -- indicate additional options for the previously used module, in this case we will tell the tcp module to only apply to port 22.

-m geoip use the geoip module. It will limit packets on a country basis (more information at step 5).

--src-cc PE tell the geoip module to limit the incoming packets to the ones that come from Peru. For more country codes search for ISO 3166 country codes on the internet.

-j ACCEPT the -j argument tells iptables what to do if a packet matches the constraints specified in the previous arguments. In this case it will ACCEPT those packets, other options are REJECT, DROP and more. You can find more options by searching iptables jump targets on the internet.


1. Basics

List all rules.
##### sudo iptables -L


List all commands that were used to create the currently used rules, useful to edit or delete rules.
##### sudo iptables -S


To delete a specific rule choose a rule from sudo iptables -S and replace -A with -D.
##### -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
##### sudo iptables -D INPUT -p tcp -m tcp --dport 22 -j ACCEPT


List all numbered rules in the INPUT chain.
##### sudo iptables -L INPUT --line-numbers


Delete a numbered rule.
##### sudo iptables -D INPUT 2


To clear all rules.
##### sudo iptables -F

Warning: you might lose connection if connected by SSH.


Clear only rules in the OUTPUT chain.
##### sudo iptables -F OUTPUT


2. Create initial rules

Allow SSH on eth0 interface
##### sudo iptables -A INPUT -i eth0 -p tcp -m tcp --dport 22 -j ACCEPT
-i eth0 apply rule to a specific interface, to allow from any interface remove this command.


To limit incoming packets to a specific IP (i.e. 10.0.3.1/32).
##### sudo iptables -A INPUT -i eth0 -s 10.0.3.1/32 -p tcp -m tcp --dport 22 -j ACCEPT
-s 10.0.3.1/32 specifies an IP/subnet to allow connections from.


## Set default chain rules.
Warning: before proceeding make sure you have applied the correct SSH rules if working on a remote server.
##### sudo iptables -P INPUT DROP
##### sudo iptables -P FORWARD DROP 
##### sudo iptables -P OUTPUT ACCEPT 
-P INPUT DROP denies all incoming packets (i.e. no one will be able to connect to your running servers such as Apache, SQL, etc).
-P FORWARD DROP denies all forwarded packets (i.e. when you are using your system as router).
-P OUTPUT ACCEPT allows all outgoing packets (i.e. when you perform an HTTP request).


Allow all traffic on loopback interface (recommended).
##### sudo iptables -A INPUT -i lo -j ACCEPT
##### sudo iptables -A OUTPUT -o lo -j ACCEPT



3. Make rules persistent

Save the current iptables rules.
##### sudo netfilter-persistent save
##### sudo netfilter-persistent reload
If you are running inside a container the netfilter-persistent command most likely will not work, so you need to reconfigure the iptables-persistent package.

sudo dpkg-reconfigure iptables-persistent



4. Allow outgoing connections

Allow DNS queries.
##### sudo iptables -A OUTPUT -p tcp --dport 53 -m state --state NEW -j ACCEPT
##### sudo iptables -A OUTPUT -p udp --dport 53 -m state --state NEW -j ACCEPT


Use the state module to allow RELATED and ESTABLISHED outgoing packets.
##### sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT


Allow the desired ports; in this case, HTTP ports.
##### sudo iptables -A OUTPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT


More ports you might want to use.

FTP: tcp at port 21
HTTPS: tcp at port 443
DHCP: udp at port 67
NTP: udp at port 123
Note: If you want to allow apt-get it might be necessary to allow FTP and HTTPS.



Allow the returned traffic only for RELATED and already ESTABLISHED connections (recommended because sometimes bidirectional communication is required).
##### sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT


Other useful rules

Allow ping requests from outside.
##### sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
##### sudo iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT


Forward traffic on eth0 port 2200 to 10.0.3.21:22 (useful if you want to expose an SSH server that is running inside a container).
##### sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 2200 -j DNAT --to-destination 10.0.3.21:22


If you successfully login to your server by using SSH, a persistent connection will be created (i.e. no new connections even if you are connected for more than 1 hour). If you fail and try to login again, a new connection will be created. This will block continuous SSH login attempts by limiting new connections per hour.
##### sudo iptables -I INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
##### sudo iptables -I INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 3600 --hitcount 4 -j DROP


Redirect all requests on port 443 to port 4430 (useful if you want to bind to port 443 without root).
##### sudo iptables -t nat -A PREROUTING -i ens3 -p tcp --dport 443 -j REDIRECT --to-port 4430
##### sudo iptables -A INPUT -p tcp -m tcp --dport 4430 -m geoip --src-cc PE -j ACCEPT
ens3 the network interface.
-m geoip country block module (see step 5).

Warning: Do not use lo, the OS will discard all packets redirected to the loopback interface.


5. Allow or block whole countries

5.1 Install xtables-addons
You can install the xtables-addons module using various methods, feel free to use the installation method that works best for you.

Install usingapt-get.

sudo apt-get install xtables-addons-common
Install using module-assistant.

sudo apt-get install module-assistant xtables-addons-source
sudo module-assistant --verbose --text-mode auto-install xtables-addons
Install from source.

sudo apt-get install git bc libncurses5-dev libtext-csv-xs-perl autoconf automake libtool xutils-dev iptables-dev
git clone git://git.code.sf.net/p/xtables-addons/xtables-addons
cd xtables-addons
./autogen.sh
./configure
make
sudo make install
Build a "countries" database.

sudo apt-get install libtext-csv-xs-perl unzip
sudo mkdir /usr/share/xt_geoip
sudo /usr/lib/xtables-addons/xt_geoip_dl
sudo /usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip *.csv
sudo rm GeoIPCountryCSV.zip GeoIPCountryWhois.csv GeoIPv6.csv
Reboot your system.

sudo reboot
After xtables-addons has been successfully installed, after the first reboot, run depmod otherwise country blocking will not work properly (this is only required for the first time).

sudo depmod 
Create a script at /etc/cron.monthly/geoip-updater to update the geoip database monthly.

#!/usr/bin/env bash
# this script is intended to run with sudo privileges

echo 'Removing old database---------------------------------------------------'
rm -rf /usr/share/xt_geoip/*
mkdir -p /usr/share/xt_geoip

echo 'Downloading country databases-------------------------------------------'
mkdir /tmp/geoip-updater
cd /tmp/geoip-updater
/usr/lib/xtables-addons/xt_geoip_dl

echo 'Building geoip database-------------------------------------------------'
/usr/lib/xtables-addons/xt_geoip_build -D /usr/share/xt_geoip *.csv

echo 'Removing temporary files------------------------------------------------'
cd /tmp
rm -rf /tmp/geoip-updater
Make /etc/cron.monthly/geoip-updater executable.

sudo chmod +x /etc/cron.monthly/geoip-updater
5.2 Example rules
_Note: If you are receiving an iptables: No chain/target/match by that name error when trying to apply a geoip rule, it's possible that xtables-addons has not been installed correctly. Try another installation method.


Block all incoming packets from China, Hong Kong, Russia and Korea.
##### sudo iptables -A INPUT -m geoip --src-cc CN,HK,RU,KR -j DROP


Allow incoming packets on port 80 from everywhere except the countries above.
##### sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT


Allow incoming packets on the ens3 interface on port 22 only from Peru (feel free to choose the country code you want to accept packets from, for example, US for United States).
##### sudo iptables -A INPUT -i ens3 -p tcp -m tcp --dport 22 -m geoip --src-cc PE -j ACCEPT


Allow incoming packets on port 443 only from Peru.
##### sudo iptables -A INPUT -p tcp -m tcp --dport 443 -m geoip --src-cc PE -j ACCEPT
