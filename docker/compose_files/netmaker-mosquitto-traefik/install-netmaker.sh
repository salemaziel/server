#!/bin/bash

set -e

echo -e "Did you remember to change default DNS inside this script?"
sleep 1
echo -e "You probably didnt. Do that first, then delete this and run again"

exit 1

cat << "EOF"
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
                                                                                         
 __   __     ______     ______   __    __     ______     __  __     ______     ______    
/\ "-.\ \   /\  ___\   /\__  _\ /\ "-./  \   /\  __ \   /\ \/ /    /\  ___\   /\  == \   
\ \ \-.  \  \ \  __\   \/_/\ \/ \ \ \-./\ \  \ \  __ \  \ \  _"-.  \ \  __\   \ \  __<   
 \ \_\\"\_\  \ \_____\    \ \_\  \ \_\ \ \_\  \ \_\ \_\  \ \_\ \_\  \ \_____\  \ \_\ \_\ 
  \/_/ \/_/   \/_____/     \/_/   \/_/  \/_/   \/_/\/_/   \/_/\/_/   \/_____/   \/_/ /_/ 
                                                                                                                                                                                                 

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
EOF

NETMAKER_BASE_DOMAIN=nm.$(curl -s ifconfig.me | tr . -).nip.io
COREDNS_IP=$(ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p')
SERVER_PUBLIC_IP=$(curl -s ifconfig.me)
MASTER_KEY=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 30 ; echo '')
EMAIL="fake@email.com"

echo "Default Base Domain: $NETMAKER_BASE_DOMAIN"
echo "To Override, add a Wildcard (*.netmaker.example.com) DNS record pointing to $SERVER_PUBLIC_IP"
echo "Or, add three DNS records pointing to $SERVER_PUBLIC_IP for the following (Replacing 'netmaker.example.com' with the domain of your choice):"
echo "   dashboard.netmaker.example.com"
echo "         api.netmaker.example.com"
echo "        grpc.netmaker.example.com"
echo "-----------------------------------------------------"
read -p "Domain (Hit 'enter' to use $NETMAKER_BASE_DOMAIN): " domain
read -p "Contact Email: " email

if [ -n "$domain" ]; then
  NETMAKER_BASE_DOMAIN=$domain
fi
if [ -n "$email" ]; then
  EMAIL=$email
fi

while true; do
    read -p 'Configure a default network automatically? [y/n]: ' yn
    case $yn in
        [Yy]* ) MESH_SETUP="true"; break;;
        [Nn]* ) MESH_SETUP="false"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p 'Configure a VPN gateway automatically? [y/n]: ' yn
    case $yn in
        [Yy]* ) VPN_SETUP="true"; break;;
        [Nn]* ) VPN_SETUP="false"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ "${VPN_SETUP}" == "true" ]; then
while :; do
    read -ep '# of VPN clients to configure by default: ' num_clients
    [[ $num_clients =~ ^[[:digit:]]+$ ]] || continue
    (( ( (num_clients=(10#$num_clients)) <= 200 ) && num_clients >= 0 )) || continue
    break
done
fi

if [ -n "$num_clients" ]; then
  NUM_CLIENTS=$num_clients
fi

echo "-----------------------------------------------------------------"
echo "                SETUP ARGUMENTS"
echo "-----------------------------------------------------------------"
echo "        domain: $NETMAKER_BASE_DOMAIN"
echo "         email: $EMAIL"
echo "     public ip: $SERVER_PUBLIC_IP"
echo "   setup mesh?: $MESH_SETUP"
echo "    setup vpn?: $VPN_SETUP"
if [ "${VPN_SETUP}" == "true" ]; then
echo "     # clients: $NUM_CLIENTS"
fi

while true; do
    read -p 'Does everything look right? [y/n]: ' yn
    case $yn in
        [Yy]* ) override="true"; break;;
        [Nn]* ) echo "exiting..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


echo "Beginning installation in 5 seconds..."

sleep 5

echo "Setting docker-compose..."

sed -i "s/NETMAKER_BASE_DOMAIN/$NETMAKER_BASE_DOMAIN/g" /root/docker-compose.yml
sed -i "s/SERVER_PUBLIC_IP/$SERVER_PUBLIC_IP/g" /root/docker-compose.yml
sed -i "s/REPLACE_MASTER_KEY/$MASTER_KEY/g" /root/docker-compose.yml
sed -i "s/YOUR_EMAIL/$EMAIL/g" /root/docker-compose.yml

echo "Starting containers..."

docker-compose -f /root/docker-compose.yml up -d

sleep 2

test_connection() {

echo "testing Traefik setup (please be patient, this may take 1-2 minutes)"
for i in 1 2 3 4 5 6
do
curlresponse=$(curl -vIs https://api.${NETMAKER_BASE_DOMAIN} 2>&1)

if [[ "$i" == 6 ]]; then
  echo "    Traefik is having an issue setting up certificates, please investigate (docker logs traefik)"
  echo "    exiting..."
  exit 1
elif [[ "$curlresponse" == *"failed to verify the legitimacy of the server"* ]]; then
  echo "    certificates not yet configured, retrying..."

elif [[ "$curlresponse" == *"left intact"* ]]; then
  echo "    certificates ok"
  break
else
  secs=$(($i*5+10))
  echo "    issue establishing connection...retrying in $secs seconds..."       
fi
sleep $secs
done
}


setup_mesh() {( set -e
sleep 5
echo "creating netmaker network (10.101.0.0/16)"

curl -s -o /dev/null -d '{"addressrange":"10.101.0.0/16","netid":"netmaker"}' -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/networks

sleep 5

echo "creating netmaker access key"

curlresponse=$(curl -s -d '{"uses":99999,"name":"netmaker-key"}' -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/networks/netmaker/keys)
ACCESS_TOKEN=$(jq -r '.accessstring' <<< ${curlresponse})

sleep 5

echo "configuring netmaker server as ingress gateway"

curlresponse=$(curl -s -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/nodes/netmaker)
SERVER_ID=$(jq -r '.[0].id' <<< ${curlresponse})

curl -o /dev/null -s -X POST -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/nodes/netmaker/$SERVER_ID/createingress

sleep 5
)}

mesh_connect_logs() {
sleep 5
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "DEFAULT NETWORK CLIENT INSTALL INSTRUCTIONS:"
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
sleep 5
echo "For Linux and Mac clients, install with the following command:"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "curl -sfL https://raw.githubusercontent.com/gravitl/netmaker/develop/scripts/netclient-install.sh | sudo KEY=$VPN_ACCESS_TOKEN sh -"
sleep 5
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "For Windows clients, perform the following from powershell, as administrator:"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "1. Make sure WireGuardNT is installed - https://download.wireguard.com/windows-client/wireguard-installer.exe"
echo "2. Download netclient.exe - wget https://github.com/gravitl/netmaker/releases/download/latest/netclient.exe"
echo "3. Install Netclient - powershell.exe .\\netclient.exe join -t $VPN_ACCESS_TOKEN"
echo "4. Whitelist C:\ProgramData\Netclient in Windows Defender"
sleep 5
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "For Android and iOS clients, perform the following steps:"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "1. Log into UI at dashboard.$NETMAKER_BASE_DOMAIN"
echo "2. Navigate to \"EXTERNAL CLIENTS\" tab"
echo "3. Select the gateway and create clients"
echo "4. Scan the QR Code from WireGuard app in iOS or Android"
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
sleep 5
}

setup_vpn() {( set -e

echo "creating vpn network (10.201.0.0/16)"

sleep 5
curl -s -o /dev/null -d '{"addressrange":"10.201.0.0/16","netid":"vpn","defaultextclientdns":"45.90.28.0"}' -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/networks

sleep 5

echo "configuring netmaker server as vpn inlet..."

curlresponse=$(curl -s -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/nodes/vpn)
SERVER_ID=$(jq -r '.[0].id' <<< ${curlresponse})

curl -s -o /dev/null -X POST -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/nodes/vpn/$SERVER_ID/createingress

echo "waiting 10 seconds for server to apply configuration..."

sleep 10


echo "configuring netmaker server vpn gateway..."

[ -z "$GATEWAY_IFACE" ] && GATEWAY_IFACE=$(ip -4 route ls | grep default | grep -Po '(?<=dev )(\S+)')

echo "gateway iface: $GATEWAY_IFACE"

curlresponse=$(curl -s -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/nodes/vpn)
SERVER_ID=$(jq -r '.[0].id' <<< ${curlresponse})

EGRESS_JSON=$( jq -n \
                  --arg gw "$GATEWAY_IFACE" \
                  '{ranges: ["0.0.0.0/5","8.0.0.0/7","11.0.0.0/8","12.0.0.0/6","16.0.0.0/4","32.0.0.0/3","64.0.0.0/2","128.0.0.0/3","160.0.0.0/5","168.0.0.0/6","172.0.0.0/12","172.32.0.0/11","172.64.0.0/10","172.128.0.0/9","173.0.0.0/8","174.0.0.0/7","176.0.0.0/4","192.0.0.0/9","192.128.0.0/11","192.160.0.0/13","192.169.0.0/16","192.170.0.0/15","192.172.0.0/14","192.176.0.0/12","192.192.0.0/10","193.0.0.0/8","194.0.0.0/7","196.0.0.0/6","200.0.0.0/5","208.0.0.0/4"], interface: $gw}' )

echo "egress json: $EGRESS_JSON"
curl -s -o /dev/null -X POST -d "$EGRESS_JSON" -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/nodes/vpn/$SERVER_ID/creategateway

echo "creating client configs..."

for ((a=1; a <= $NUM_CLIENTS; a++))
do
        CLIENT_JSON=$( jq -n \
                  --arg clientid "vpnclient-$a" \
                  '{clientid: $clientid}' )

        curl -s -o /dev/null -d "$CLIENT_JSON" -H "Authorization: Bearer $MASTER_KEY" -H 'Content-Type: application/json' https://api.${NETMAKER_BASE_DOMAIN}/api/extclients/vpn/$SERVER_ID
done
sleep 5
)}

vpn_connect_logs() {
sleep 5
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "VPN GATEWAY CLIENT INSTALL INSTRUCTIONS:"
echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "1. log into dashboard.$NETMAKER_BASE_DOMAIN"
echo "2. Navigate to \"EXTERNAL CLIENTS\" tab"
echo "3. Download or scan a client config (vpnclient-x) to the appropriate device"
echo "4. Follow the steps for your system to configure WireGuard on the appropriate device"
echo "5. Create and delete clients as necessary. Changes to netmaker server settings require regenerating ext clients."
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
sleep 5
}

set +e
test_connection

if [ "${MESH_SETUP}" != "false" ]; then
        setup_mesh
fi

if [ "${VPN_SETUP}" == "true" ]; then
        setup_vpn
fi

echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"
echo "Netmaker setup is now complete. You are ready to begin using Netmaker."
echo "Visit dashboard.$NETMAKER_BASE_DOMAIN to log in"
echo "-----------------------------------------------------------------"
echo "-----------------------------------------------------------------"

cp -f /etc/skel/.bashrc /root/.bashrc
