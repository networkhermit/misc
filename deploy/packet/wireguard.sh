#!/bin/bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

warn () {
    if (( $# > 0 )); then
        echo "${@}" 1>&2
    fi
}

die () {
    warn "${@}"
    exit 1
}

notify () {
    local code=$?
    warn "✗ [FATAL] $(caller): ${BASH_COMMAND} (${code})"
}

trap notify ERR

if (( EUID != 0 )); then
    die '✗ This script must be run as root'
fi

display_help () {
    cat << EOF
Synopsis:
    ${0##*/} [OPTION]...

Options:
    -s, --server
        use server mode (default: false)
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit
EOF
}

IP_ADDRESS=172.20.0.10/16
SUBNET=172.20.0.0/16
PEER_LIST=( 172.20.0.{10..15} )
PORT=51820

# shellcheck disable=SC1090
source "$(git -C "$(dirname "$(realpath "${0}")")" rev-parse --show-toplevel)/.privacy/wireguard.cfg"

PAIR=()
for i in "${PEER_LIST[@]}"; do
    PAIR+=( "${IP_ADDRESS%/*}-${i}" )
done

SERVER_MODE=false

while (( $# > 0 )); do
    case ${1} in
    -s | --server)
        SERVER_MODE=true
        shift
        ;;
    -h | --help)
        display_help
        shift
        exit
        ;;
    -v | --version)
        echo v0.1.0
        shift
        exit
        ;;
    --)
        shift
        break
        ;;
    *)
        break
        ;;
    esac
done

if (( $# > 0 )); then
    die "✗ argument parsing failed: unrecognizable argument ‘${1}’"
fi

clean_up () {
    true
}

trap clean_up EXIT

if [ -d /etc/wireguard/wg0.conf ]; then
    for i in "${PEER_LIST[@]}"; do
        ping -c 4 "${i}"
    done
    exit
fi

install --directory --mode 700 /etc/wireguard

install --mode 600 /dev/null /etc/wireguard/private.key
wg genkey | tee /etc/wireguard/private.key | wg pubkey | tee /etc/wireguard/public.key

install --directory --mode 700 /etc/wireguard/preshared-key

for i in "${PAIR[@]}"; do
    install --mode 600 /dev/stdin "/etc/wireguard/preshared-key/${i}.key" << EOF
$(wg genpsk)
EOF
done

if [ "${SERVER_MODE}" = true ]; then
    install --mode 600 /dev/stdin /etc/wireguard/wg0.conf << EOF
[Interface]
PostUp = wg set %i private-key /etc/wireguard/private.key
Address = ${IP_ADDRESS}
ListenPort = ${PORT}
PostUp = iptables --table nat --insert POSTROUTING --source ${SUBNET} --out-interface %i --jump MASQUERADE
PostUp = iptables --table filter --insert FORWARD --in-interface %i --out-interface %i --jump ACCEPT
PreDown = iptables --table nat --delete POSTROUTING --source ${SUBNET} --out-interface %i --jump MASQUERADE || true
PreDown = iptables --table filter --delete FORWARD --in-interface %i --out-interface %i --jump ACCEPT || true
PostUp = wg set %i peer PEER_PUBLIC_KEY preshared-key /etc/wireguard/preshared-key/${IP_ADDRESS%/*}-${PEER_LIST[0]}.key

[Peer]
PublicKey = PEER_PUBLIC_KEY
#AllowedIPs = ${PEER_LIST[0]}/32, 192.168.0.0/16
AllowedIPs = ${PEER_LIST[0]}/32
#Endpoint = PEER_ENDPOINT:${PORT}
#PersistentKeepalive = 15
EOF
else
    install --mode 600 /dev/stdin /etc/wireguard/wg0.conf << EOF
[Interface]
PostUp = wg set %i private-key /etc/wireguard/private.key
Address = ${IP_ADDRESS}
#PostUp = iptables --table nat --insert POSTROUTING --source ${SUBNET} --out-interface wlan0 --jump MASQUERADE
#PostUp = iptables --table filter --insert FORWARD --in-interface wlan0 --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT
#PostUp = iptables --table filter --insert FORWARD --in-interface %i --out-interface wlan0 --jump ACCEPT
#PreDown = iptables --table nat --delete POSTROUTING --source ${SUBNET} --out-interface wlan0 --jump MASQUERADE || true
#PreDown = iptables --table filter --delete FORWARD --in-interface wlan0 --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT || true
#PreDown = iptables --table filter --delete FORWARD --in-interface %i --out-interface wlan0 --jump ACCEPT || true
PostUp = wg set %i peer PEER_PUBLIC_KEY preshared-key /etc/wireguard/preshared-key/${IP_ADDRESS%/*}-${PEER_LIST[0]}.key

[Peer]
PublicKey = PEER_PUBLIC_KEY
#AllowedIPs = ${PEER_LIST[0]}/32
AllowedIPs = ${SUBNET}
Endpoint = PEER_ENDPOINT:${PORT}
PersistentKeepalive = 15
EOF
fi

: << EOF
firewall-cmd --permanent --new-service wireguard
firewall-cmd --permanent --service wireguard --add-port ${PORT}/udp
firewall-cmd --permanent --service wireguard --get-ports
firewall-cmd --permanent --add-service wireguard --zone FedoraServer
firewall-cmd --permanent --add-masquerade --zone FedoraServer
firewall-cmd --reload
EOF

systemctl enable wg-quick@wg0.service
