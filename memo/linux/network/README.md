IP and Socket
=============

```bash
# shellcheck shell=bash

# Check Routing Table

ip route get 1.1.1.1 | awk '{ print $7; exit }'

# Check Local IP Address

ip -4 address | awk '/\<inet\>/ { print $2 }' | sort --field-separator / --key 1,1V --key 2,2n

ip -6 address | awk '/\<inet6\>/ { print $2 }' | sort

# Check Public IP Address

## [ ipinfo ]

curl --fail --location --silent --show-error https://ipinfo.io | jq

## [ opendns ]

{
    drill -Q myip.opendns.com @208.67.222.222 a
    drill -Q myip.opendns.com @208.67.220.220 a
} | uniq

## [ amazonaws ]

curl --fail --location --silent --show-error https://checkip.amazonaws.com

## [ google ]

{
    drill -Q o-o.myaddr.l.google.com @216.239.32.10 txt
    drill -Q o-o.myaddr.l.google.com @216.239.34.10 txt
} | tr --delete \" | uniq

# Check Local Socket

lsof -nP -iTCP -sTCP:LISTEN
lsof -nP -iUDP

ss --tcp --udp --raw --listening --numeric --processes

netstat --tcp --udp --raw --listening --numeric --programs
```

iptables/ip6tables
==================

```bash
# shellcheck shell=bash

# Inspect Firewall Status

sysctl net.ipv4.conf.{all,default}.forwarding
sysctl net.ipv4.conf.{all,default}.proxy_arp
sysctl net.ipv6.conf.{all,default}.forwarding
sysctl net.ipv6.conf.{all,default}.proxy_ndp

iptables-save --counters
iptables-save --counters --table nat
iptables-save --counters --table filter

iptables --table nat --list-rules --verbose
iptables --table nat --list-rules PREROUTING --verbose
iptables --table nat --list-rules INPUT --verbose
iptables --table nat --list-rules POSTROUTING --verbose
iptables --table nat --list-rules OUPUT --verbose
iptables --table filter --list-rules --verbose
iptables --table filter --list-rules INPUT --verbose
iptables --table filter --list-rules FORWARD --verbose
iptables --table filter --list-rules OUPUT --verbose

iptables --table nat --list --numeric --verbose --line-numbers
iptables --table nat --list PREROUTING --numeric --verbose --line-numbers
iptables --table nat --list INPUT --numeric --verbose --line-numbers
iptables --table nat --list POSTROUTING --numeric --verbose --line-numbers
iptables --table nat --list OUPUT --numeric --verbose --line-numbers
iptables --table filter --list --numeric --verbose --line-numbers
iptables --table filter --list INPUT --numeric --verbose --line-numbers
iptables --table filter --list FORWARD --numeric --verbose --line-numbers
iptables --table filter --list OUPUT --numeric --verbose --line-numbers

# Forwarding Incoming Connection

## [ short option ]

iptables -t nat -I PREROUTING -p tcp --dport "${HOST_PORT}" -j DNAT --to-destination "${GUEST_IP}":"${GUEST_PORT}"
iptables -t filter -I FORWARD -p tcp -d "${GUEST_IP}" --dport "${GUEST_PORT}" -j ACCEPT

iptables -t nat -C PREROUTING -p tcp --dport "${HOST_PORT}" -j DNAT --to-destination "${GUEST_IP}":"${GUEST_PORT}"
iptables -t filter -C FORWARD -p tcp -d "${GUEST_IP}" --dport "${GUEST_PORT}" -j ACCEPT

iptables -t nat -D PREROUTING -p tcp --dport "${HOST_PORT}" -j DNAT --to-destination "${GUEST_IP}":"${GUEST_PORT}"
iptables -t filter -D FORWARD -p tcp -d "${GUEST_IP}" --dport "${GUEST_PORT}" -j ACCEPT

## [ long option ]

iptables \
    --table nat \
    --insert PREROUTING \
    --protocol tcp --destination-port "${HOST_PORT}" \
    --jump DNAT --to-destination "${GUEST_IP}":"${GUEST_PORT}"

iptables \
    --table filter \
    --insert FORWARD \
    --protocol tcp --destination "${GUEST_IP}" --destination-port "${GUEST_PORT}" \
    --jump ACCEPT

iptables \
    --table nat \
    --check PREROUTING \
    --protocol tcp --destination-port "${HOST_PORT}" \
    --jump DNAT --to-destination "${GUEST_IP}":"${GUEST_PORT}"

iptables \
    --table filter \
    --check FORWARD \
    --protocol tcp --destination "${GUEST_IP}" --destination-port "${GUEST_PORT}" \
    --jump ACCEPT

iptables \
    --table nat \
    --delete PREROUTING \
    --protocol tcp --destination-port "${HOST_PORT}" \
    --jump DNAT --to-destination "${GUEST_IP}":"${GUEST_PORT}"

iptables \
    --table filter \
    --delete FORWARD \
    --protocol tcp --destination "${GUEST_IP}" --destination-port "${GUEST_PORT}" \
    --jump ACCEPT
```
