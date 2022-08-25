#!/bin/bash






# Script to help with the Vultr CLI
function check_vultr-cli_installed(){
if [[ -z $(command -v vultr-cli) ]]; then
    echo "Vultr CLI not found. Please install it first."
    exit 1
fi
}

# Display plans
function display_plans_full() {
    echo "Available plans:"
    cat <<\EOF
ID				        VCPU COUNT	     RAM	    DISK	    BANDWIDTH GB	PRICE PER MONTH		TYPE            REGIONS
vc2-1c-1gb			        1		     1024	    25			1024		    5					vc2				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel bom]
vc2-1c-1gb-sc1		        1		     1024	    25			1024		    7.5					vc2				[sao]
vc2-1c-2gb			        1		     2048	    55			2048		    10					vc2				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel bom]
vc2-1c-2gb-sc1		        1		     2048	    55			2048	    	15					vc2				[sao]
vc2-2c-4gb			        2		     4096	    80			3072	    	20					vc2				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel bom]
vc2-2c-4gb-sc1		        2		     4096	    80			3072		    30					vc2				[sao]
vc2-4c-8gb			        4		     8192	    160			4096		    40					vc2				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel bom]
vc2-4c-8gb-sc1		        4		     8192	    160			4096		    60					vc2				[sao]
vc2-6c-16gb			        6		     16384	    320			5120		    80					vc2				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel bom]
vc2-6c-16gb-sc1		        6		     16384	    320			5120		    120					vc2				[sao]
vc2-8c-32gb			        8		     32768	    640			6144		    160					vc2				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel bom]
vc2-8c-32gb-sc1		        8		     32768	    640			6144		    240					vc2				[]
vc2-16c-64gb		        16		     65536	    1280		10240		    320					vc2				[ewr ord dfw sea atl ams lhr fra sjc syd yto cdg nrt waw mad mia sgp sto mex mel bom]
vc2-16c-64gb-sc1	        16           65536	    1280		10240		    480					vc2				[]
vc2-24c-96gb		        24		     98304	    1600		15360		    640					vc2				[ord dfw sea sjc yto waw mad sto mex mel bom]
vc2-24c-96gb-sc1	        24		     98304	    1600		15360		    960					vc2				[]
vhf-1c-1gb			        1		     1024       32			1024		    6					vhf				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex]
vhf-1c-1gb-sc1		        1		     1024	    32			1024		    9					vhf				[sao]
vhf-1c-2gb			        1		     2048	    64			2048		    12					vhf				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex]
vhf-1c-2gb-sc1		        1		     2048	    64			2048		    18					vhf				[]
vhf-2c-2gb                  2		     2048	    80			3072		    18					vhf				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex]
vhf-2c-2gb-sc1		        2		     2048	    80			3072		    27					vhf				[]
vhf-2c-4gb			        2		     4096	    128			3072		    24					vhf				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex]
vhf-2c-4gb-sc1		        2		     4096	    128			3072		    36					vhf				[]
vhf-3c-8gb			        3		     8192	    256			4096		    48					vhf				[ewr sea lax atl ams lhr fra sjc syd yto nrt waw mad icn mia sgp sto mex]
vhf-3c-8gb-sc1		        3		     8192	    256			4096		    72					vhf				[]
vhf-4c-16gb			        4		     16384	    384			5120		    96					vhf				[ewr lax atl ams lhr fra sjc syd yto nrt waw mad icn mia sgp sto mex]
vhf-4c-16gb-sc1		        4		     16384	    384			5120		    144					vhf				[]
vhf-6c-24gb			        6		     24576	    448			6144		    144					vhf				[ewr lax lhr sjc yto nrt waw mad icn sgp sto mex]
vhf-6c-24gb-sc1		        6		     24576	    448			6144		    216					vhf				[]
vhf-8c-32gb			        8		     32768	    512			7168		    192					vhf				[ewr lax sjc nrt waw mad sto mex]
vhf-8c-32gb-sc1		        8		     32768	    512			7168		    288					vhf				[]
vhf-12c-48gb		        12		     49152	    768			8192		    256					vhf				[lax waw mad]
vhf-12c-48gb-sc1	        12		     49152	    768			8192		    384					vhf				[]
vhp-1c-1gb-amd		        1		     1024	    25			2048		    6					vhp				[ewr ord dfw sea lax atl ams lhr fra syd yto cdg nrt waw icn mia sgp sto mex mel hnl bom]
vhp-1c-2gb-amd		        1		     2048	    50			3072		    12					vhp				[ewr ord dfw sea lax atl ams lhr fra syd yto cdg nrt waw icn mia sgp sto mex mel hnl bom]
vhp-2c-2gb-amd		        2		     2048	    60			4096		    18					vhp				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw icn mia sgp sto mex mel hnl bom]
vhp-2c-4gb-amd			    2		     4096	    100			5120		    24					vhp				[ewr ord dfw sea lax atl ams lhr fra syd yto cdg nrt waw icn mia sgp sto mex mel hnl bom]
vhp-4c-8gb-amd			    4		     8192	    180			6144		    48					vhp				[ewr ord dfw sea lax atl ams lhr fra syd yto cdg nrt waw icn mia sgp sto mex mel hnl bom]
vhp-4c-12gb-amd			    4		     12288	    260			7168		    72					vhp				[ewr ord dfw sea lax atl ams lhr fra syd yto cdg nrt waw icn mia sgp sto mex mel hnl bom]
vhp-8c-16gb-amd			    8		     16384	    350			8192		    96					vhp				[ewr ord dfw sea lax atl ams lhr fra syd yto cdg nrt waw icn mia sgp sto mex mel hnl bom]
vhp-12c-24gb-amd		    12		     24576	    500			12288		    144					vhp				[ewr ord dfw sea lax atl ams lhr fra syd yto cdg nrt waw icn mia sgp sto mex mel hnl bom]
vhp-1c-1gb-intel		    1		     1024	    25			2048		    6					vhp				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel hnl bom]
vhp-1c-2gb-intel		    1		     2048	    50			3072		    12					vhp				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel hnl bom]
vhp-2c-2gb-intel		    2		     2048	    60			4096		    18					vhp				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel hnl bom]
vhp-2c-4gb-intel		    2		     4096	    100			5120		    24					vhp				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel hnl bom]
vhp-4c-8gb-intel		    4		     8192	    180			6144		    48					vhp				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel hnl bom]
vhp-4c-12gb-intel		    4		     12288	    260			7168		    72					vhp				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel hnl bom]
vhp-8c-16gb-intel		    8		     16384	    350			8192		    96					vhp				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel hnl bom]
vhp-12c-24gb-intel		    12		     24576	    500			12288		    144					vhp				[ewr ord dfw sea lax atl ams lhr fra sjc syd yto cdg nrt waw mad icn mia sgp sto mex mel hnl bom]
voc-c-1c-2gb-25s-amd		1		     2048	    25			4096		    28					voc				[ewr ord dfw sea atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-g-1c-4gb-30s-amd		1		     4096	    30			4096		    30					voc				[ewr ord dfw sea atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-1c-8gb-50s-amd		1		     8192	    50			5120		    40					voc				[ewr ord dfw sea atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-c-2c-4gb-50s-amd		2		     4096	    50			5120		    40					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-g-2c-8gb-50s-amd		2		     8192	    50			5120		    60					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-c-2c-4gb-75s-amd		2		     4096	    75			5120		    45					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-c-4c-8gb-75s-amd		4		     8192	    75			6144		    80					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-g-4c-16gb-80s-amd		4		     16384	    80			6144		    120					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-2c-16gb-100s-amd		2		     16384	    100			6144		    80					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-s-1c-8gb-150s-amd		1		     8192	    150			4096		    75					voc				[ewr ord dfw sea atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-c-4c-8gb-150s-amd		4		     8192	    150			6144		    90					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-c-8c-16gb-150s-amd		8		     16384	    150			7168		    160					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-g-8c-32gb-160s-amd		8		     32768	    160			7168		    240					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-2c-16gb-200s-amd		2		     16384	    200			6144		    100					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-4c-32gb-200s-amd		4		     32768	    200			8192		    160					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-c-8c-16gb-300s-amd		8		     16384	    300			7168		    180					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-c-16c-32gb-300s-amd		16		     32768	    300			8192		    320					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex hnl bom]
voc-s-2c-16gb-320s-amd		2		     16384	    320			6144		    125					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-g-16c-64gb-320s-amd		16		     65536	    320			8192		    480					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex hnl bom]
voc-m-2c-16gb-400s-amd		2		     16384	    400			6144		    125					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-4c-32gb-400s-amd		4		     32768	    400			8192		    195					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-8c-64gb-400s-amd		8		     65536	    400			9216		    320					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-s-2c-16gb-480s-amd		2		     16384	    480			6144		    155					voc				[ewr ord dfw atl ams lhr fra sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-g-24c-96gb-480s-amd		24		     98304	    480			9216		    720					voc				[ewr ord lhr sjc syd cdg nrt icn sgp mex hnl bom]
voc-c-16c-32gb-500s-amd		16		     32768	    500			8192		    360					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex hnl bom]
voc-c-32c-64gb-500s-amd		32		     65536	    500			9216		    640					voc				[ewr ord lhr sjc syd nrt icn sgp mex bom]
voc-s-4c-32gb-640s-amd		4		     32768	    640			7168		    250					voc				[ewr ord dfw atl ams lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-g-32c-128gb-640s-amd	32		     131072	    640			9216		    960					voc				[ewr ord lhr sjc syd nrt icn sgp mex bom]
voc-g-40c-160gb-768s-amd	40		     163840	    768			10240		    1200				voc				[ewr ord lhr sjc syd nrt icn mex bom]
voc-m-4c-32gb-800s-amd		4		     32768	    800			8192		    250					voc				[ewr ord dfw atl ams lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-8c-64gb-800s-amd		8		     65536	    800			9216		    390					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-16c-128gb-800s-amd	16		     131072  	800			10240		    640					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex hnl bom]
voc-s-4c-32gb-960s-amd		4		     32768	    960			7168		    310					voc				[ewr ord dfw atl ams lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-g-64c-192gb-960s-amd	64		     196608  	960			11264	        1920				voc				[ewr ord syd mex bom]
voc-c-32c-64gb-1000s-amd	32		     65536	    1000		10240		    720					voc				[ewr ord lhr sjc syd nrt icn sgp mex bom]
voc-m-24c-192gb-1200s-amd	24		     196608  	1200		11264		    960					voc				[ewr ord lhr sjc syd cdg nrt icn sgp mex hnl bom]
voc-s-8c-64gb-1280s-amd		8		     65536	    1280		8192		    500					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-g-96c-256gb-1280s-amd	96		     261120  	1280		12288		    3840				voc				[ewr]
voc-m-8c-64gb-1600s-amd		8		     65536	    1600		9216		    500					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-16c-128gb-1600s-amd	16		     131072	    1600		10240		    785					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex hnl bom]
voc-m-32c-256gb-1600s-amd	32		     262144	    1600		12288		    1280				voc				[ewr ord lhr sjc syd nrt icn sgp mex bom]
voc-s-8c-64gb-1920s-amd		8		     65536	    1920		8192		    620					voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex mel hnl bom]
voc-m-24c-192gb-2400s-amd	24		     196608	    2400		11264		    1175				voc				[ewr ord lhr sjc syd cdg nrt icn sgp mex hnl bom]
voc-s-16c-128gb-2560s-amd	16		     131072	    2560		9216		    1000				voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex hnl bom]
voc-m-16c-128gb-3200s-amd	16		     131072	    3200		10240		    1000				voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex hnl bom]
voc-m-32c-256gb-3200s-amd	32		     262144	    3200		12288		    1565				voc				[ewr ord lhr sjc syd nrt icn sgp mex bom]
voc-s-16c-128gb-3840s-amd	16		     131072	    3840		9216		    1240				voc				[ewr ord atl lhr sjc syd cdg nrt waw icn sgp mex hnl bom]
voc-s-24c-192gb-3840s-amd	24		     196608	    3840		10240		    1500				voc				[ewr ord lhr sjc syd cdg nrt icn sgp mex hnl bom]
voc-m-24c-192gb-4800s-amd	24		     196608	    4800		11264		    1500				voc				[ewr ord lhr sjc syd cdg nrt icn sgp mex hnl bom]
voc-s-24c-192gb-5760s-amd	24		     196608	    5760		10240		    1850				voc				[ewr ord lhr sjc syd cdg nrt icn sgp mex hnl bom]
EOF

}

function display_plans() {
    echo "Available plans:"
    echo "----------------"
    vultr-cli plans list | grep "$plan" | awk '{ print $1 }'
}


function plans_display_ram() {
vultr-cli plans list | grep "$plan" | awk '{ print $3 }'
}

function plans_display_price() {
vultr-cli plans list | grep "$plan" | awk '{ print $7 }'
}

function plans_display_vcpu() {
vultr-cli plans list | grep "$plan" | awk '{ print $2 }'
}

function plans_display_disk() {
vultr-cli plans list | grep "$plan" | awk '{ print $4 }'
}







function display_regions() {
    echo -e "\n"
    vultr-cli regions list
    echo -e "\n"
}

function display_os() {
    echo -e "\n"
    vultr-cli os list
    echo -e "\n"
}

function display_sshkeys() {
    echo -e "\n"
    vultr-cli ssh-key list
    echo -e "\n"
}


function instance_create_choose_plan(){
    read -p "Enter plan name for instance, or p to see all plans: " "plan"
   
    while [ "$plan" == "p" ]; do
        display_plans
        read -p "Enter plan name for instance, or p to see all plans: " "plan"
    done
        PLAN="$plan"
}

function instance_create_choose_region(){
    read -p "Enter region for instance, or r to see all regions: " "region"
    while [ "$region" == "r" ]; do
        display_regions
        read -p "Enter region for instance, or r to see all regions: " "region"
    done
         REGION="$region"

}


function instance_create_choose_os(){
    read -p "Enter OS for instance, or o to see all OS: " "os"
    while [ "$os" == "o" ]; do
        display_os
        read -p "Enter OS for instance, or o to see all OS: " "os"
    done
       OS="$os"
}

function instance_create_choose_sshkey(){
    read -p "Enter SSH key ID for instance, or s to see all SSH keys: " "sshkey"
    while [ "$sshkey" == "s" ]; do
        display_sshkeys
        read -p "Enter SSH key ID for instance, or s to see all SSH keys: " "sshkey"
    done
         SSHKEY="$sshkey"

}


function enable_ipv6() {
    read -p "Enable IPv6? (Y/n): " "ipv6"
    if [ "$ipv6" == "y" ]; then
        IPV6='true'
    elif [ "$ipv6" == "n" ]; then
        IPV6='false'
    else
        echo "Invalid option"
        echo -e "Choosing default option: --ipv6 true"
    fi
}

function assign_label() {
    read -p "Assign label to instance? (y/N): " "label"
    if [ "$label" == "y" ] || [ "$label" == "Y" ]; then
        read -p "Enter label: " "label"
        LABEL="$label"
    elif [ "$label" == "n" ] || [ "$label" == "N" ]; then
        echo -e "Not assigning label"
    else
        echo "Invalid option"
        echo -e "Choosing default option: no label"
    fi
}

function assign_hostname() {
    read -p "Assign hostname to instance? (Y/n): " "hostname"
    if [ "$hostname" == "y" ] || [ "$hostname" == "Y" ]; then
        read -p "Enter hostame: " "hostname"
        HOSTNAME="$hostname"
    elif [ "$hostname" == "n" ] || [ "$hostname" == "N" ]; then
        echo -e "Not assigning hostname; will be assigned automatically"
    else
        echo "Invalid option"
        echo -e "Not assigning hostname; will be assigned automatically"
    fi
}






function set_instance_properties(){
    instance_create_choose_plan
    instance_create_choose_region
    instance_create_choose_os
    instance_create_choose_sshkey
    enable_ipv6
    assign_label
    assign_hostname
    vultr-cli instance create --plan "$PLAN" --region "$REGION" --os "$OS" --sshkey "$SSHKEY" --ipv6 "$IPV6" --label "$LABEL" --hostname "$HOSTNAME"
}


function create_instance(){
    set_instance_properties
        
    if [ -z "$HOSTNAME" ]; then
        if [ -z "$LABEL" ]; then
            vultr-cli instance create --plan "$PLAN" --region "$REGION" --os "$OS" --sshkey "$SSHKEY" --ipv6 "$IPV6"
        fi
    elif [ -z "$LABEL" ]; then
        vultr-cli instance create --plan "$PLAN" --region "$REGION" --os "$OS" --sshkey "$SSHKEY" --ipv6 "$IPV6" --hostname "$HOSTNAME"
    else
        vultr-cli instance create --plan "$PLAN" --region "$REGION" --os "$OS" --sshkey "$SSHKEY" --ipv6 "$IPV6" --hostname "$HOSTNAME" --label "$LABEL"
    fi

}


echo -e "Not done yet"

exit 0

check_vultr-cli_installed

set_instance_properties

create_instance