iptables/ip6tables

==================

```bash
# shellcheck shell=bash

# Forwarding Incoming Connection

## [ short option ]

iptables -t nat -I PREROUTING -p tcp --dport "${HOST_PORT}" -j DNAT --to "${GUEST_IP}":"${GUEST_PORT}"
iptables -t filter -I FORWARD -p tcp -d "${GUEST_IP}" --dport "${GUEST_PORT}" -j ACCEPT

iptables -t nat -C PREROUTING -p tcp --dport "${HOST_PORT}" -j DNAT --to "${GUEST_IP}":"${GUEST_PORT}"
iptables -t filter -C FORWARD -p tcp -d "${GUEST_IP}" --dport "${GUEST_PORT}" -j ACCEPT

iptables -t nat -D PREROUTING -p tcp --dport "${HOST_PORT}" -j DNAT --to "${GUEST_IP}":"${GUEST_PORT}"
iptables -t filter -D FORWARD -p tcp -d "${GUEST_IP}" --dport "${GUEST_PORT}" -j ACCEPT

iptables -t nat -L PREROUTING -n -v --line-numbers
iptables -t filter -L FORWARD -n -v --line-numbers

## [ long option ]

iptables \
    --table nat \
    --insert PREROUTING \
    --protocol tcp --dport "${HOST_PORT}" \
    --jump DNAT --to "${GUEST_IP}":"${GUEST_PORT}"

iptables \
    --table filter \
    --insert FORWARD \
    --protocol tcp --destination "${GUEST_IP}" --dport "${GUEST_PORT}" \
    --jump ACCEPT

iptables \
    --table nat \
    --check PREROUTING \
    --protocol tcp --dport "${HOST_PORT}" \
    --jump DNAT --to "${GUEST_IP}":"${GUEST_PORT}"

iptables \
    --table filter \
    --check FORWARD \
    --protocol tcp --destination "${GUEST_IP}" --dport "${GUEST_PORT}" \
    --jump ACCEPT

iptables \
    --table nat \
    --delete PREROUTING \
    --protocol tcp --dport "${HOST_PORT}" \
    --jump DNAT --to "${GUEST_IP}":"${GUEST_PORT}"

iptables \
    --table filter \
    --delete FORWARD \
    --protocol tcp --destination "${GUEST_IP}" --dport "${GUEST_PORT}" \
    --jump ACCEPT

iptables \
    --table nat \
    --list PREROUTING \
    --numeric \
    --verbose \
    --line-numbers

iptables \
    --table filter \
    --list FORWARD \
    --numeric \
    --verbose \
    --line-numbers
```
