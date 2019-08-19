#!/bin/bash

sudo install --mode 600 /dev/null /etc/wireguard/private.key
wg genkey | sudo tee /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key

wg genpsk
sudo install --mode 600 /dev/stdin /etc/wireguard/preshared.key << 'EOF'
PRESHARED_KEY
EOF

## [ Server ]
sudo install --mode 600 /dev/stdin /etc/wireguard/wg0.conf << 'EOF'
[Interface]
PostUp = wg set %i private-key /etc/wireguard/private.key
Address = 172.20.0.1/16
ListenPort = 51820
PostUp = wg set %i peer PEER_PUBLIC_KEY preshared-key /etc/wireguard/preshared.key

[Peer]
PublicKey = PEER_PUBLIC_KEY
AllowedIPs = 172.20.0.2/32, 192.168.0.0/16
EOF

## [ Client ]
sudo install --mode 600 /dev/stdin /etc/wireguard/wg0.conf << 'EOF'
[Interface]
PostUp = wg set %i private-key /etc/wireguard/private.key
Address = 172.20.0.2/16
PostUp = iptables --table nat --append POSTROUTING --out-interface wlan0 --jump MASQUERADE
PostUp = iptables --table filter --append FORWARD --in-interface wlan0 --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT
PostUp = iptables --table filter --append FORWARD --in-interface %i --out-interface wlan0 --jump ACCEPT
PreDown = iptables --table nat --delete POSTROUTING --out-interface wlan0 --jump MASQUERADE
PreDown = iptables --table filter --delete FORWARD --in-interface wlan0 --out-interface %i --match conntrack --ctstate ESTABLISHED,RELATED --jump ACCEPT
PreDown = iptables --table filter --delete FORWARD --in-interface %i --out-interface wlan0 --jump ACCEPT
PostUp = wg set %i peer PEER_PUBLIC_KEY preshared-key /etc/wireguard/preshared.key

[Peer]
PublicKey = PEER_PUBLIC_KEY
AllowedIPs = 172.20.0.0/16
Endpoint = PEER_ENDPOINT:51820
PersistentKeepalive = 15
EOF

sudo wg-quick up wg0
sudo systemctl enable wg-quick@wg0
sudo wg show

sudo sysctl net.ipv4.ip_forward
sudo sysctl net.ipv4.conf.all.proxy_arp
sudo iptables --table nat --list POSTROUTING --numeric --verbose --line-numbers
sudo iptables --table filter --list FORWARD --numeric --verbose --line-numbers
