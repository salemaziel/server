
PUBLIC_NIC=enp1s0

SSH_PORT=22

TCPDNS_PORT=8953

UDPDNS_PORT=53

WG_PORT=443



## Allow SSH
sudo iptables -A INPUT -i "$PUBLIC_NIC" -p tcp -m tcp --dport "$SSH_PORT" -j ACCEPT

## Set Default Policies
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT


## Allow in and out from localhost
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT


## Allow TCP DNS port 8953 (for unbound)
sudo iptables -A OUTPUT -p tcp --dport "$TCPDNS_PORT" -m state --state NEW -j ACCEPT

## Allow UDP DNS port
sudo iptables -A OUTPUT -p udp --dport "$UDPDNS_PORT" -m state --state NEW -j ACCEPT

## Allow Wireguard UDP port out
sudo iptables -A OUTPUT -p udp --dport "$WG_PORT" -m state --state NEW -j ACCEPT

sudo iptables -A INPUT -p udp --dport 443 -m state --state NEW -j ACCEPT

## Allow related,established connections out
sudo iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

## Allow related,established connections in
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

## Allow in all to Wireguard interface
iptables -I INPUT 1 -i wg0 -j ACCEPT

## Accept packets to be forwarded from Public net interface to Wireguard interface
iptables -I FORWARD 1 -i "$PUBLIC_NIC" -o wg0 -j ACCEPT

## Accept packets to be forwarded from Wireguard interface to public net interface
iptables -I FORWARD 1 -i wg0 -o enp1s0 -j ACCEPT

## Allow in on Public net interface on port where Wireguard server is listening
iptables -I INPUT 1 -i "$PUBLIC_NIC" -p udp --dport "$WG_PORT" -j ACCEPT


sudo netfilter-persistent save
sudo netfilter-persistent reload
