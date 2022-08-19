#!/bin/bash



# Delete extra .gitignore files for damn git to commit empty directories
clean_up(){
	rm ./*/.gitignore
	rm ./*/*/.gitignore
}


# Require script to be run as root
function super-user-check() {
  if [ "${EUID}" -ne 0 ]; then
    echo "You need to run this script as super user."
	sleep 1
  fi
}


## For check_ports:
## After running, in your browser access http://${IP_ADDRESS}:${PORT/PORT_RANGE}
## It should show you your browser IP address and user agent. You should also see the request logged in the port-checker output.
check_ports(){
# Check for root
super-user-check
echo "enter port/port range to check:"
read "ports_check"
export PORTS_CHECK="$ports_check"
sudo docker exec -it gluetun /bin/sh
# Change amd64 to your CPU architecture
wget -qO port-checker https://github.com/qdm12/port-checker/releases/download/v0.3.0/port-checker_0.3.0_linux_amd64
chmod +x port-checker
./port-checker -port "$PORTS_CHECK"
}


check_dnsleak(){
# Check for root
super-user-check
sudo docker run --rm --network=container:testing_gluetun_1 alpine:3.14 \
	 sh -c "apk add curl iputils bash && curl https://raw.githubusercontent.com/macvk/dnsleaktest/master/dnsleaktest.sh -o dnsleaktest.sh \
		&& chmod a+x dnsleaktest.sh \
			&& bash ./dnsleaktest.sh"
}



# You can run the docker container in CLI operation, check the possible options with:
# docker run -it --rm qmcgaw/gluetun update -help
# To update your servers.json file with, for example mullvad, use this
# Note that this operation is very quick 🚀 for some providers (pia, mullvad, nordvpn, ...) 
# and very slow 🐢 for other providers (cyberghost, windscribe, ...).
# ⚠️ This will show your ISP/Government/Sniffing actors that you access some VPN service 
# providers and try to resolve their server hostnames. That might not be the best solution depending on your location. Plus some of the requests might be blocked, hence not allowing certain server information to be updated.
update_vpnlist(){
# Check for root
super-user-check
read -p "Enter vpn provider name: " "vpn_provider"
export VPN_PROVIDER="$vpn_provider"
sudo docker run -it --rm -v ./gluetun-data:/gluetun qmcgaw/gluetun update -enduser -providers "$VPN_PROVIDER"
}


download_docker() {
# Check for root
super-user-check
# Download Docker
curl -fsSL get.docker.com -o get-docker.sh
# Install Docker using the stable channel (instead of the default "edge")
CHANNEL=stable sh get-docker.sh
# Remove Docker install script
}

download_docker-compose() {
# Check for root
super-user-check
# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Make it executable
chmod +x /usr/local/bin/docker-compose
# Install command completion
sudo curl \
    -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
    -o /etc/bash_completion.d/docker-compose
# Source .bashrc so completion becomes active
source $HOME/.bashrc
# Test command and show version
docker-compose --version
}


# Display menu with options of script to run
run_scripts() {
    echo "What do you want to do?"
    echo "   1) Check Ports"
    echo "   2) Check for DNS leak"
    echo "   3) Install Docker and Docker-Compose"
    echo "   4) Update VPN list for gluetun container"
    echo "   5) Clean up extra gitignore files"
    until [[ "${USER_OPTIONS}" =~ ^[0-9]+$ ]] && [ "${USER_OPTIONS}" -ge 1 ] && [ "${USER_OPTIONS}" -le 5 ]; do
      read -rp "Select an Option [1-5]: " -e -i 1 USER_OPTIONS
    done
    case ${USER_OPTIONS} in
    1)
      echo "Checking ports, select container next"
      sleep 2
      check_ports
      ;;
    2)
      echo "Checking for DNS leak, select container next"
      sleep 2
      check_ports
      ;;
    3)
      echo "Installing Docker first"
      sleep 2
      download_docker
      
      echo "Now installing Docker-Compose"
      sleep 2
      download_docker-compose      
      ;;
    4)
      echo "Updating VPN provider list in gluetun container"
	  sleep 2
	  update_vpnlist
      ;;
    5)
      echo "Cleaning up extra gitignore files"
	  sleep 2
	  clean_up
      ;;
    esac
  }

# Display the menu
