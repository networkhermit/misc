#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

trap 'echo ✗ fatal error: errexit trapped with status $? 1>&2' ERR

while (( $# > 0 )); do
    case "${1}" in
        -h | --help)
            cat << EOF
Usage:
    ${0##*/} [OPTION]...

Optional arguments:
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit
EOF
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
    echo "✗ argument parsing failed: unrecognizable argument ‘${1}’" 1>&2
    exit 1
fi

sudo install --directory --mode 700 /etc/wireguard

sudo install --mode 600 /dev/null /etc/wireguard/private.key
wg genkey | sudo tee /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key

## [ Server ]
sudo install --mode 600 /dev/stdin /etc/wireguard/wg0.conf << 'EOF'
[Interface]
PostUp = wg set %i private-key /etc/wireguard/private.key
Address = 172.20.0.X/16
ListenPort = 51820
PostUp = iptables --table nat --insert POSTROUTING --out-interface %i --jump MASQUERADE
PostUp = iptables --table filter --insert FORWARD --in-interface %i --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT
PostUp = iptables --table filter --insert FORWARD --in-interface %i --out-interface %i --jump ACCEPT
PreDown = iptables --table nat --delete POSTROUTING --out-interface %i --jump MASQUERADE || true
PreDown = iptables --table filter --delete FORWARD --in-interface %i --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT || true
PreDown = iptables --table filter --delete FORWARD --in-interface %i --out-interface %i --jump ACCEPT || true
PostUp = wg set %i peer PEER_PUBLIC_KEY preshared-key /etc/wireguard/preshared-key/172.20.0.X-172.20.0.Y.key

[Peer]
PublicKey = PEER_PUBLIC_KEY
AllowedIPs = 172.20.0.Y/32, 192.168.0.0/16
EOF
sudo firewall-cmd --permanent --new-service wireguard
sudo firewall-cmd --permanent --service wireguard --add-port 51820/udp
sudo firewall-cmd --permanent --service wireguard --get-ports
sudo firewall-cmd --permanent --add-service wireguard --zone FedoraServer
sudo firewall-cmd --permanent --add-masquerade --zone FedoraServer
sudo firewall-cmd --reload

## [ Client ]
sudo install --mode 600 /dev/stdin /etc/wireguard/wg0.conf << 'EOF'
[Interface]
PostUp = wg set %i private-key /etc/wireguard/private.key
Address = 172.20.0.Y/16
#PostUp = iptables --table nat --insert POSTROUTING --out-interface wlan0 --jump MASQUERADE
#PostUp = iptables --table filter --insert FORWARD --in-interface wlan0 --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT
#PostUp = iptables --table filter --insert FORWARD --in-interface %i --out-interface wlan0 --jump ACCEPT
#PreDown = iptables --table nat --delete POSTROUTING --out-interface wlan0 --jump MASQUERADE || true
#PreDown = iptables --table filter --delete FORWARD --in-interface wlan0 --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT || true
#PreDown = iptables --table filter --delete FORWARD --in-interface %i --out-interface wlan0 --jump ACCEPT || true
PostUp = wg set %i peer PEER_PUBLIC_KEY preshared-key /etc/wireguard/preshared-key/172.20.0.Y-172.20.0.X.key

[Peer]
PublicKey = PEER_PUBLIC_KEY
AllowedIPs = 172.20.0.X/32, 172.20.0.0/16
Endpoint = PEER_ENDPOINT:51820
PersistentKeepalive = 15
EOF

sudo install --directory --mode 700 /etc/wireguard/preshared-key
PAIR=( 172.20.0.X-172.20.0.Y )
for i in "${PAIR[@]}"; do
    sudo install --mode 600 /dev/stdin "/etc/wireguard/preshared-key/${i}.key" << EOF
$(wg genpsk)
EOF
done

sudo wg-quick down wg0
sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0.service
sudo wg show

sudo sysctl net.ipv4.conf.{all,default}.forwarding
sudo sysctl net.ipv6.conf.{all,default}.forwarding
sudo sysctl net.ipv4.conf.{all,default}.proxy_arp
sudo sysctl net.ipv6.conf.{all,default}.proxy_ndp

sudo iptables --table nat --list-rules POSTROUTING --verbose
sudo iptables --table filter --list-rules FORWARD --verbose
sudo ip6tables --table nat --list-rules POSTROUTING --verbose
sudo ip6tables --table filter --list-rules FORWARD --verbose

sudo iptables --table nat --list POSTROUTING --numeric --verbose --line-numbers
sudo iptables --table filter --list FORWARD --numeric --verbose --line-numbers
sudo ip6tables --table nat --list POSTROUTING --numeric --verbose --line-numbers
sudo ip6tables --table filter --list FORWARD --numeric --verbose --line-numbers
