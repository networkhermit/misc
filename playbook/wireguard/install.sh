#!/usr/bin/env bash

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

display_help () {
    cat << EOF
Synopsis:
    ${0##*/} [OPTION]...

Options:
    -s, --server
        use server mode (default: ${SERVER_MODE})
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit
EOF
}

CONFIG_PATH=/etc/wireguard
INTERFACE_NAME=wg0
IP_ADDRESS='172.20.0.10/16, fd00:ebee:172:2000::10/56'
PEER_LIST=( 172.20.0.{10..15} )
PORT=51820
SUBNET='172.20.0.0/16, fd00:ebee:172:2000::/56'

IFS='[, ]' read -a SUBNET_LIST -r <<< "${SUBNET}"

# shellcheck source=/dev/null
source "$(git -C "$(dirname "$(realpath "${0}")")" rev-parse --show-toplevel)/config/vault/wireguard.cfg"

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

if (( EUID != 0 )); then
    die '✗ This script must be run as root'
fi

clean_up () {
    true
}

trap clean_up EXIT

if [[ -d "${CONFIG_PATH}/${INTERFACE_NAME}.conf" ]]; then
    for i in "${PEER_LIST[@]}"; do
        ping -c 4 "${i}"
    done
    exit
fi

install --directory --mode 700 "${CONFIG_PATH}"

pushd "${CONFIG_PATH}" &> /dev/null

install --mode 600 --no-target-directory /dev/null private.key
wg genkey | tee private.key | wg pubkey | tee public.key

install --directory --mode 700 preshared-key

for i in "${PAIR[@]}"; do
    install --mode 600 --no-target-directory /dev/stdin "preshared-key/${i}.key" << EOF
$(wg genpsk)
EOF
done

if [[ "${SERVER_MODE}" = true ]]; then
    install --mode 600 --no-target-directory /dev/stdin "${INTERFACE_NAME}.conf" << EOF
[Interface]
PostUp = wg set %i private-key ${CONFIG_PATH}/private.key
Address = ${IP_ADDRESS}
ListenPort = ${PORT}
Table = off
#PostUp = iptables --table nat --insert POSTROUTING --source ${SUBNET_LIST[0]} --out-interface %i --jump MASQUERADE
#PostUp = iptables --table filter --insert FORWARD --in-interface %i --out-interface %i --jump ACCEPT
#PreDown = iptables --table nat --delete POSTROUTING --source ${SUBNET_LIST[0]} --out-interface %i --jump MASQUERADE || true
#PreDown = iptables --table filter --delete FORWARD --in-interface %i --out-interface %i --jump ACCEPT || true
PostUp = wg set %i peer PEER_PUBLIC_KEY preshared-key ${CONFIG_PATH}/preshared-key/${IP_ADDRESS%/*}-${PEER_LIST[0]}.key

[Peer]
PublicKey = PEER_PUBLIC_KEY
#AllowedIPs = ${PEER_LIST[0]}/32, 192.168.0.0/16
AllowedIPs = ${PEER_LIST[0]}/32
#Endpoint = PEER_ENDPOINT:${PORT}
#PersistentKeepalive = 15
EOF

    : << EOF
firewall-cmd --permanent --new-service wireguard
firewall-cmd --permanent --service wireguard --add-port ${PORT}/udp
firewall-cmd --permanent --service wireguard --get-ports
firewall-cmd --permanent --add-service wireguard --zone FedoraServer
firewall-cmd --permanent --add-masquerade --zone FedoraServer
firewall-cmd --reload
EOF
else
    install --mode 600 --no-target-directory /dev/stdin "${INTERFACE_NAME}.conf" << EOF
[Interface]
PostUp = wg set %i private-key ${CONFIG_PATH}/private.key
Address = ${IP_ADDRESS}
#PostUp = iptables --table nat --insert POSTROUTING --source ${SUBNET_LIST[0]} --out-interface wlan0 --jump MASQUERADE
#PostUp = iptables --table filter --insert FORWARD --in-interface wlan0 --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT
#PostUp = iptables --table filter --insert FORWARD --in-interface %i --out-interface wlan0 --jump ACCEPT
#PreDown = iptables --table nat --delete POSTROUTING --source ${SUBNET_LIST[0]} --out-interface wlan0 --jump MASQUERADE || true
#PreDown = iptables --table filter --delete FORWARD --in-interface wlan0 --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT || true
#PreDown = iptables --table filter --delete FORWARD --in-interface %i --out-interface wlan0 --jump ACCEPT || true
PostUp = wg set %i peer PEER_PUBLIC_KEY preshared-key ${CONFIG_PATH}/preshared-key/${IP_ADDRESS%/*}-${PEER_LIST[0]}.key

[Peer]
PublicKey = PEER_PUBLIC_KEY
#AllowedIPs = ${PEER_LIST[0]}/32
AllowedIPs = ${SUBNET}
Endpoint = PEER_ENDPOINT:${PORT}
PersistentKeepalive = 15
EOF
fi

systemctl enable "wg-quick@${INTERFACE_NAME}.service"
