#!/bin/bash
        read -p "Enter space separated list of ports: " ports

        read -a tcp_ports <<< $ports
        for ports in "${tcp_ports[@]}" ; do
    
#        ipxtables -A VDFIREWALL -p tcp -m tcp --dport "${p}" -j ACCEPT
        echo "${ports}"
        done
        echo "Done"
        echo -e Whitelisting the following ports: "${tcp_ports[@]}"