#!/bin/bash

apt -y install unbound unbound-host

curl -o /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache

cat << EOF > /etc/unbound/unbound.conf
# Unbound configuration file for Debian.
#
# See the unbound.conf(5) man page.
#
# See /usr/share/doc/unbound/examples/unbound.conf for a commented
# reference config file.
#
# The following line includes additional configuration files from the
# /etc/unbound/unbound.conf.d directory.
server:

  num-threads: 4
  port: 5353
  verbosity: 1
  root-hints: "/var/lib/unbound/root.hints"
  auto-trust-anchor-file: "/var/lib/unbound/root.key"
  interface: 0.0.0.0
  max-udp-size: 3072
  access-control: 0.0.0.0/0                 refuse
  access-control: 127.0.0.1                 allow
  access-control: 192.168.0.0/16 allow
  # VPN IP subnet in slash notation
  access-control: 10.0.0.0/0         allow
  private-address: 192.168.0.0/16

  hide-identity: yes
  hide-version: yes
  harden-glue: yes
  harden-dnssec-stripped: yes
  harden-referral-path: yes
  unwanted-reply-threshold: 10000000
  val-log-level: 1
  cache-min-ttl: 1800
  cache-max-ttl: 14400
  prefetch: yes
  prefetch-key: yes
EOF

chown -R unbound:unbound /var/lib/unbound

systemctl enable --now unbound
