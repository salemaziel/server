#!/bin/bash

ubuntu-2204-generate() {
    ##    Re-generate the RSA and ED25519 keys
    rm /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    #    Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv /etc/ssh/moduli.safe /etc/ssh/moduli

    #    Enable the RSA and ED25519 keys
    ##   Enable the RSA and ED25519 HostKey directives in the /etc/ssh/sshd_config file:
    sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config

    # Restrict supported key exchange, cipher, and MAC algorithms
    echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org,gss-curve25519-sha256-,diffie-hellman-group16-sha512,gss-group16-sha512-,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com" >/etc/ssh/sshd_config.d/ssh-audit_hardening.conf

    #    Restart OpenSSH server
#    service ssh restart
}

ubuntu-2004-generate() {
    ##    Re-generate the RSA and ED25519 keys

    rm /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    #    Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe

    mv /etc/ssh/moduli.safe /etc/ssh/moduli

    #    Enable the RSA and ED25519 keys
    ##   Enable the RSA and ED25519 HostKey directives in the /etc/ssh/sshd_config file:
    sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config

    # Restrict supported key exchange, cipher, and MAC algorithms

    echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com" >/etc/ssh/sshd_config.d/ssh-audit_hardening.conf

    #    Restart OpenSSH server
#    service ssh restart
}

ubuntu-1804-generate() {

    ##    Re-generate the RSA and ED25519 keys
    rm /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    #    Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv /etc/ssh/moduli.safe /etc/ssh/moduli

    #    Disable the DSA and ECDSA host keys
    ##    Comment out the DSA and ECDSA HostKey directives in the /etc/ssh/sshd_config file:
    sed -i 's/^HostKey \/etc\/ssh\/ssh_host_\(dsa\|ecdsa\)_key$/\#HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config

    # Restrict supported key exchange, cipher, and MAC algorithms
    echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com" >>/etc/ssh/sshd_config

    #    Restart OpenSSH server
#    systemctl ssh restart
}

ubuntu-1804-core-generate() {

    ##    Re-generate the RSA and ED25519 keys
    #    Note: It is highly recommended that you run the ssh-keygen commands below on another host. Some IoT devices do not have good entropy sources to generate sufficient keys with!
    ssh-keygen -t rsa -b 4096 -f ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f ssh_host_ed25519_key -N ""

    #    Be sure to upload the following 4 files to the target device's /etc/ssh directory:
    ssh_host_ed25519_key
    ssh_host_ed25519_key.pub
    ssh_host_rsa_key
    ssh_host_rsa_key.pub

    #    Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv /etc/ssh/moduli.safe /etc/ssh/moduli

    # Restrict supported key exchange, cipher, and MAC algorithms
    echo -e "\n# Only enable RSA and ED25519 host keys.\nHostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_ed25519_key\n\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com" >>/etc/ssh/sshd_config

    #    Restart OpenSSH server
    service ssh reload

}

ubuntu-1604-generate() {

    #    Re-generate ED25519 key
    rm /etc/ssh/ssh_host_*
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    #    Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv /etc/ssh/moduli.safe /etc/ssh/moduli

    #    Disable the RSA, DSA, and ECDSA host keys
    ##    Comment out the RSA, DSA and ECDSA HostKey directives in the /etc/ssh/sshd_config file:
    sed -i 's/^HostKey \/etc\/ssh\/ssh_host_\(rsa\|dsa\|ecdsa\)_key$/\#HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config

    # Restrict supported key exchange, cipher, and MAC algorithms
    echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com" >>/etc/ssh/sshd_config

    #    Restart OpenSSH server
    service ssh restart
}

debian-11-bullseye-generate() {

    ## Re-generate the RSA and ED25519 keys
    rm -f /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    # Enable the RSA and ED25519 keys
    ## Enable the RSA and ED25519 HostKey directives in the /etc/ssh/sshd_config file:
    sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config

    # Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv -f /etc/ssh/moduli.safe /etc/ssh/moduli

    # Restrict supported key exchange, cipher, and MAC algorithms
    echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com" >/etc/ssh/sshd_config.d/ssh-audit_hardening.conf

    # Restart OpenSSH server
    service ssh restart
}

debian-10-buster-generate() {

    # Re-generate the RSA and ED25519 keys
    rm -f /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    # Enable the RSA and ED25519 keys
    ## Enable the RSA and ED25519 HostKey directives in the /etc/ssh/sshd_config file:
    sed -i 's/^\#HostKey \/etc\/ssh\/ssh_host_\(rsa\|ed25519\)_key$/HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config

    # Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv -f /etc/ssh/moduli.safe /etc/ssh/moduli

    #    Restrict supported key exchange, cipher, and MAC algorithms
    echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com\nHostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com" >>/etc/ssh/sshd_config

    # Restart OpenSSH server
    service ssh restart
}

rhel-centos-8-generate() {

    #   Re-generate the RSA and ED25519 keys
    rm -f /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
    chgrp ssh_keys /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_rsa_key
    chmod g+r /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_rsa_key

    # Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv -f /etc/ssh/moduli.safe /etc/ssh/moduli

    # Disable ECDSA host key
    # Comment out the ECDSA HostKey directive in the /etc/ssh/sshd_config file:
    sed -i 's/^HostKey \/etc\/ssh\/ssh_host_ecdsa_key$/\#HostKey \/etc\/ssh\/ssh_host_ecdsa_key/g' /etc/ssh/sshd_config

    # Restrict supported key exchange, cipher, and MAC algorithms
    cp /etc/crypto-policies/back-ends/opensshserver.config /etc/crypto-policies/back-ends/opensshserver.config.orig
    echo -e "CRYPTO_POLICY='-oCiphers=chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr -oMACs=hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com -oGSSAPIKexAlgorithms=gss-curve25519-sha256- -oKexAlgorithms=curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256 -oHostKeyAlgorithms=ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512 -oPubkeyAcceptedKeyTypes=ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512'" >/etc/crypto-policies/back-ends/opensshserver.config

    #    Restart OpenSSH server
    systemctl restart sshd.service
}

rhel-centos-7-generate() {

    #    Disable automatic re-generation of RSA & ECDSA keys
    sed -i '/ssh_host_rsa_key/d' /usr/lib/systemd/system/sshd-keygen.service
    sed -i '/ssh_host_ecdsa_key/d' /usr/lib/systemd/system/sshd-keygen.service
    systemctl daemon-reload

    # Re-generate the ED25519 key
    rm -f /etc/ssh/ssh_host_*
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
    chgrp ssh_keys /etc/ssh/ssh_host_ed25519_key
    chmod g+r /etc/ssh/ssh_host_ed25519_key

    #    Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv -f /etc/ssh/moduli.safe /etc/ssh/moduli

    #    Disable the RSA, DSA, and ECDSA host keys
    #    Comment out the RSA, DSA, and ECDSA HostKey directives in the /etc/ssh/sshd_config file:
    sed -i 's/^HostKey \/etc\/ssh\/ssh_host_\(rsa\|dsa\|ecdsa\)_key$/\#HostKey \/etc\/ssh\/ssh_host_\1_key/g' /etc/ssh/sshd_config

    #    Restrict supported key exchange, cipher, and MAC algorithms
    echo -e "\n# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group18-sha512,diffie-hellman-group16-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com" >>/etc/ssh/sshd_config
    #    Restart OpenSSH server
    systemctl restart sshd.service

}

## Might be outdated
pfsense-2.4-generate() {

    #    Re-generate the RSA and ED25519 keys
    rm /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    #    Remove small Diffie-Hellman moduli
    awk '$5 >= 3071' /etc/ssh/moduli >/etc/ssh/moduli.safe
    mv -f /etc/ssh/moduli.safe /etc/ssh/moduli

    #    Restrict supported key exchange, cipher, and MAC algorithms
    sed -i.bak 's/^MACs \(.*\)$/\#MACs \1/g' /etc/ssh/sshd_config && rm /etc/ssh/sshd_config.bak
    echo "" | echo "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com" >>/etc/ssh/sshd_config

    #    Restart OpenSSH server
    service sshd onerestart

}

openbsd-6.2-generate() {

    #    Re-generate the RSA and ED25519 keys
    rm /etc/ssh/ssh_host_*
    ssh-keygen -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N ""
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""

    #    Create custom Diffie-Hellman groups
    ssh-keygen -G /etc/ssh/moduli -b 3072

    #    Note: This will likely take some time to complete.
    #    Disable the DSA and ECDSA host keys
    echo -e "\n# Restrict host keys to ED25519 and RSA only.\nHostKeyAlgorithms ssh-ed25519\n" >>/etc/ssh/sshd_config

    # Restrict supported key exchange, cipher, and MAC algorithms
    echo -e "# Restrict key exchange, cipher, and MAC algorithms, as per sshaudit.com\n# hardening guide.\nKexAlgorithms curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256\nCiphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr\nMACs hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,umac-128-etm@openssh.com" >>/etc/ssh/sshd_config

    #    Restart OpenSSH server
    kill -HUP $(cat /var/run/sshd.pid)

}
