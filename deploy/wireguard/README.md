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
