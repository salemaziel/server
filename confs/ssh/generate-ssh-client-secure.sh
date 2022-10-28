#!/bin/bash

ubuntu-mint-2004-ssh-client(){

#    Run the following in a terminal to harden the SSH client for the local user:
    mkdir -p -m 0700 ~/.ssh; 

    echo -e "\nHost *\n Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\n MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\n HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com\n" >> ~/.ssh/config

}

ubuntu-mint-1804-ssh-client(){

#    Run the following in a terminal to harden the SSH client for the local user:
    mkdir -p -m 0700 ~/.ssh; 
    
    echo -e "\nHost *\n Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n KexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\n MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\n HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512\n" >> ~/.ssh/config

}

ubuntu-mint-1604-ssh-client(){

#    Run the following in a terminal to harden the SSH client for the local user:
    mkdir -p -m 0700 ~/.ssh; 
    
    echo -e "\nHost *\n Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\n KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256\n MACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\n HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512\n" >> ~/.ssh/config
    
}