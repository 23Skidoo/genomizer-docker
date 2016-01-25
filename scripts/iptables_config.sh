#!/bin/sh

## Flush all rules.

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X

## Accepted port ranges.

iptables -N INPUT_ports
iptables -A INPUT_ports -p tcp --dport 22 -j ACCEPT
iptables -A INPUT_ports -p tcp --dport 443  -j ACCEPT
iptables -A INPUT_ports -p tcp --dport 4443 -j ACCEPT
iptables -A INPUT_ports -p tcp --dport 4431 -j ACCEPT
iptables -A INPUT_ports -p tcp --dport 4432 -j ACCEPT
iptables -A INPUT_ports -p tcp --dport 4433 -j ACCEPT
iptables -A INPUT_ports -p tcp --dport 4434 -j ACCEPT
iptables -A INPUT_ports -p tcp --dport 4435 -j ACCEPT

## Accepted IP ranges (developers).

iptables -N INPUT_dev
iptables -A INPUT_dev -s 130.239.39.0/24 -j INPUT_ports
iptables -A INPUT_dev -s 130.239.40.0/24 -j INPUT_ports
iptables -A INPUT_dev -s 130.239.41.0/24 -j INPUT_ports
iptables -A INPUT_dev -s 130.239.42.0/24 -j INPUT_ports

## Accepted IP ranges (users).

iptables -N INPUT_users
iptables -A INPUT_users -s 130.239.192.0/24 -j INPUT_ports

## Plug the above into the INPUT chain.

# Don't drop established connections (so that we're not shut out of the server).
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j INPUT_dev
iptables -A INPUT -j INPUT_users

## Drop everything else.

iptables -P INPUT DROP
iptables -P FORWARD DROP

## Save firewall rules

service iptables save
