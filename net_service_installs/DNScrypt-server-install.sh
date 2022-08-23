#!/bin/bash

# https://github.com/DNSCrypt/encrypted-dns-server

source ../common/download-github-release.sh

if [ -n "encrypted-dns*.deb" ]; then
  rm -rf encrypted-dns*.deb
fi

sudo apt -f install ./encrypted-dns*.deb

echo " *** Installed DNScrypt-server package *** "
echo "                                           "
echo " (DEBIAN/UBUNTU See example configs in     "
echo "       /usr/share/doc/encrypted-dns/       "