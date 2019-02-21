Arch
====

> Add `console=ttyS0,115200n8` to boot parameter list for KVM.

```
# berkeley mirror
Server = https://mirrors.ocf.berkeley.edu/archlinux/$repo/os/$arch

# tsinghua mirror
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

```bash
# shellcheck shell=bash

# check internet connection
ping -c 4 1.1.1.1

# modify dns resolver
sudo tee /etc/resolv.conf << 'EOF'
# Electronic Frontier Foundation

options attempts:1 rotate timeout:1 use-vc

# [[ cloudflare ]]
#nameserver ::1
nameserver 1.1.1.1
#nameserver 1.0.0.1

# [[ opendns ]]
nameserver 208.67.222.222
#nameserver 208.67.220.220

# [[ quad9 ]]
nameserver 9.9.9.9
#nameserver 149.112.112.112
EOF

# update system clock
sudo timedatectl set-ntp true
timedatectl status

# format disk partition
sudo fdisk -l
sudo fdisk /dev/sda
sudo mkfs.xfs -f -L Arch /dev/sda1

# mount file system
sudo mount /dev/sda1 /mnt

# change arch source
sudo tee /etc/pacman.d/mirrorlist << 'EOF'
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
EOF

# bootstrap base system
sudo pacstrap /mnt base
genfstab -U /mnt | sudo tee /mnt/etc/fstab
sudo cp -v {,/mnt}/etc/resolv.conf

# chroot into node
sudo arch-chroot /mnt

# change root password
passwd root

# check sudo support
yes | pacman -S --needed sudo
sudo groupadd --gid 27 sudo
sudo groupadd --gid 1024 sysadmin
yes | sudo pacman -S --needed vim
sudo ln -fs /usr/{bin/vim,local/bin/vi}
sudo EDITOR=vim visudo
sudo vim /usr/share/bash-completion/completions/sudo

# change hostname
sudo hostname STEM
echo 'STEM' | sudo tee /etc/hostname
sudo tee /etc/hosts << 'EOF'
127.0.0.1       localhost
127.0.1.1       STEM

::1             localhost

127.0.0.1       local.site
EOF

# update message of the day
sudo tee /etc/motd << 'EOF'

The programs included with the Arch GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Arch GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
EOF

# update system locale
echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf
sudo sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen

# modify time zone
sudo ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sudo hwclock --systohc

# update initramfs image
yes | sudo pacman -S --needed intel-ucode
sudo mkinitcpio -p linux

# update boot loader
yes | sudo pacman -S --needed grub
sudo vim /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo grub-install --target=i386-pc /dev/sda

# network control
sudo tee /etc/sysctl.d/network-control.conf << 'EOF'
# ICMP Black Hole
net.ipv4.tcp_base_mss = 1024
net.ipv4.tcp_mtu_probing = 1

# TCP Congestion Control [BBR]
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
# TCP Congestion Control [CUBIC]
#net.core.default_qdisc = fq_codel
#net.ipv4.tcp_congestion_control = cubic

# TCP Fast Open
net.ipv4.tcp_fastopen = 3
EOF

# disable dynamic resolver
sudo tee -a /etc/resolvconf.conf << 'EOF'

resolvconf=NO
EOF

# configure default address selection
sudo sed -i '\%^#precedence ::ffff:0:0/96  100$%r /dev/stdin' /etc/gai.conf << 'EOF'

precedence  ::1/128       50
precedence  ::/0          40
precedence  2002::/16     30
precedence ::/96          20
precedence ::ffff:0:0/96  100
EOF

# modify default ntp server
sudo sed -i '/^#NTP=$/r /dev/stdin' /etc/systemd/timesyncd.conf << 'EOF'
NTP=time1.google.com time2.google.com time3.google.com time4.google.com
EOF
sudo sed -i '/^#NTP=$/r /dev/stdin' /etc/systemd/timesyncd.conf << 'EOF'
NTP=time1.apple.com time2.apple.com time3.apple.com time4.apple.com
EOF
sudo systemctl restart systemd-timesyncd.service

# modify secure shell daemon
yes | sudo pacman -S --needed openssh
sudo vim /etc/ssh/sshd_config
sudo rm -v /etc/ssh/ssh_host_*_key{,.pub}
declare -A host_key=(['ed25519']=256 ['rsa']=4096)
for type in "${!host_key[@]}"; do
    sudo ssh-keygen -a 100 -b "${host_key[${type}]}" -f "/etc/ssh/ssh_host_${type}_key" -t "${type}" -C 'sysadmin@local.domain' -N ''
done
unset host_key
sudo systemctl restart sshd.service

# configure system network
sudo tee /etc/systemd/network/10-eth0.network << 'EOF'
[Match]
Name=eth0

[Network]
DHCP=yes

[DHCP]
UseDNS=no
UseNTP=no
EOF

# manage system service
sudo systemctl enable --now \
    sshd.service \
    systemd-{network,timesync}d.service
sudo systemctl disable --now \
    systemd-resolved.service

# add default sysadmin
sudo useradd --create-home --groups sudo --uid 1000 vac
sudo passwd vac

# exit chroot
exit

# reboot system
sudo umount -R /mnt
sudo reboot

# install arch-install-scripts
yes | sudo pacman -S --needed arch-install-scripts

# color setup for ls
sudo tee -a /etc/bash.bashrc << 'EOF'

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
EOF

# install command-not-found
yes | sudo pacman -S --needed pkgfile
sudo tee -a /etc/bash.bashrc << 'EOF'

[ -r /usr/share/doc/pkgfile/command-not-found.bash ] && . /usr/share/doc/pkgfile/command-not-found.bash
EOF
sudo systemctl enable --now pkgfile-update.timer
```

Kali
====

```
# mirror list
https://http.kali.org/README.mirrorlist

# netboot iso
https://http.kali.org/dists/kali-rolling/main/installer-amd64/current/images/netboot/mini.iso
# netboot iso [berkeley]
https://mirrors.ocf.berkeley.edu/kali/dists/kali-rolling/main/installer-amd64/current/images/netboot/mini.iso
# netboot iso [tsinghua]
https://mirrors.tuna.tsinghua.edu.cn/kali/dists/kali-rolling/main/installer-amd64/current/images/netboot/mini.iso
```

```
# berkeley mirror
deb https://mirrors.ocf.berkeley.edu/kali kali-rolling main non-free contrib
deb-src https://mirrors.ocf.berkeley.edu/kali kali-rolling main non-free contrib

# tsinghua mirror
deb https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib
```

```bash
# shellcheck shell=bash

# change root password
sudo passwd root

# check sudo support
sudo groupadd --gid 1024 sysadmin
sudo EDITOR=vim visudo
sudo vim /usr/share/bash-completion/completions/sudo

# change hostname
sudo hostname STEM
echo 'STEM' | sudo tee /etc/hostname
sudo tee -a /etc/hosts << 'EOF'

127.0.0.1       local.site
EOF
sudo vim /etc/hosts

# modify dns resolver
sudo tee /etc/resolv.conf << 'EOF'
# Electronic Frontier Foundation

options attempts:1 rotate timeout:1 use-vc

# [[ cloudflare ]]
#nameserver ::1
nameserver 1.1.1.1
#nameserver 1.0.0.1

# [[ opendns ]]
nameserver 208.67.222.222
#nameserver 208.67.220.220

# [[ quad9 ]]
nameserver 9.9.9.9
#nameserver 149.112.112.112
EOF

# change debian source
sudo tee /etc/apt/sources.list << 'EOF'
deb http://mirrors.tuna.tsinghua.edu.cn/debian stable main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian stable-updates main contrib non-free

deb-src http://mirrors.tuna.tsinghua.edu.cn/debian stable main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian stable-updates main contrib non-free
EOF

# remove foreign architecture
dpkg --print-architecture
dpkg --print-foreign-architectures
dpkg --print-foreign-architectures | xargs --no-run-if-empty sudo dpkg --remove-architecture

# make package manager support https
sudo apt update --list-cleanup
sudo apt install --assume-yes apt-transport-https < /dev/null
sudo apt clean
sudo apt autoremove --assume-yes --purge

# secure debian source
sudo sed -i 's/http:/https:/' /etc/apt/sources.list

# make initial system upgrade
sudo apt update --list-cleanup
sudo apt purge --assume-yes installation-report
sudo apt purge --assume-yes '<other unneeded packages>'
sudo apt full-upgrade --assume-yes --purge
sudo apt clean
sudo apt autoremove --assume-yes --purge

# install kali archive keyring
sudo curl -LO 'https://mirrors.tuna.tsinghua.edu.cn/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2018.1_all.deb'
sudo dpkg --install kali-archive-keyring_*_all.deb
sudo rm -fv kali-archive-keyring_*_all.deb

# change to kali source
sudo tee /etc/apt/sources.list << 'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib
EOF

# make one more system upgrade
sudo apt update --list-cleanup
sudo apt full-upgrade --assume-yes --purge
sudo apt purge --assume-yes apt-transport-https
sudo apt install --assume-yes kali-defaults < /dev/null
sudo apt clean
sudo apt autoremove --assume-yes --purge

# modify shell environment
sudo mv -v /etc/profile.d/kali.sh{,.forbid}

# update message of the day
sudo tee /etc/motd << 'EOF'

The programs included with the Kali GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Kali GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
EOF

# update initramfs image
sudo update-initramfs -k all -u

# list obsolete configuration
sudo find /etc -type f \( -name '*.dpkg-*' -o -name '*.ucf-*' \)

# update boot loader
sudo vim /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

# network control
sudo tee /etc/sysctl.d/network-control.conf << 'EOF'
# ICMP Black Hole
net.ipv4.tcp_base_mss = 1024
net.ipv4.tcp_mtu_probing = 1

# TCP Congestion Control [BBR]
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
# TCP Congestion Control [CUBIC]
#net.core.default_qdisc = fq_codel
#net.ipv4.tcp_congestion_control = cubic

# TCP Fast Open
net.ipv4.tcp_fastopen = 3
EOF

# disable dynamic resolver
sudo tee /etc/dhcp/dhclient-enter-hooks.d/no-dns << 'EOF'
#!/bin/sh

make_resolv_conf() {
    :
}
EOF
sudo chmod u+x /etc/dhcp/dhclient-enter-hooks.d/no-dns

# do not modify resolv.conf
sudo tee /etc/NetworkManager/conf.d/no-dns.conf << 'EOF'
[main]
dns=none
EOF

# configure default address selection
sudo sed -i '\%^#precedence ::ffff:0:0/96  100$%r /dev/stdin' /etc/gai.conf << 'EOF'

precedence  ::1/128       50
precedence  ::/0          40
precedence  2002::/16     30
precedence ::/96          20
precedence ::ffff:0:0/96  100
EOF

# modify default ntp server
sudo sed -i '/^#NTP=$/r /dev/stdin' /etc/systemd/timesyncd.conf << 'EOF'
NTP=time1.google.com time2.google.com time3.google.com time4.google.com
EOF
sudo sed -i '/^#NTP=$/r /dev/stdin' /etc/systemd/timesyncd.conf << 'EOF'
NTP=time1.apple.com time2.apple.com time3.apple.com time4.apple.com
EOF
sudo systemctl restart systemd-timesyncd.service

# modify secure shell daemon
sudo vim /etc/ssh/sshd_config
sudo rm -v /etc/ssh/ssh_host_*_key{,.pub}
declare -A host_key=(['ed25519']=256 ['rsa']=4096)
for type in "${!host_key[@]}"; do
    sudo ssh-keygen -a 100 -b "${host_key[${type}]}" -f "/etc/ssh/ssh_host_${type}_key" -t "${type}" -C 'sysadmin@local.domain' -N ''
done
unset host_key
sudo systemctl restart ssh.service

# configure system network
sudo tee /etc/systemd/network/10-eth0.network << 'EOF'
[Match]
Name=eth0

[Network]
DHCP=yes

[DHCP]
UseDNS=no
UseNTP=no
EOF

# manage system service
sudo systemctl enable --now \
    ssh.service \
    systemd-{network,timesync}d.service
sudo systemctl disable --now \
    apt-daily{,-upgrade}.timer \
    systemd-resolved.service

# add default sysadmin
sudo adduser --uid 1000 vac
sudo addgroup vac sudo

# reboot system
sudo reboot

# remove locally installed package
apt list --installed | awk -F '/' '/,local]/ { print $1 }' | xargs --no-run-if-empty sudo apt purge --assume-yes

# install kali linux full
sudo apt install --assume-yes kali-linux-full < /dev/null

# install command-not-found
sudo apt install --assume-yes command-not-found < /dev/null
sudo apt update --list-cleanup
sudo update-command-not-found

# install default plymouth
sudo apt install --assume-yes plymouth{,-themes} < /dev/null
sudo plymouth-set-default-theme kali
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Ubuntu
======

```bash
# shellcheck shell=bash

# manage system service
sudo systemctl disable --now \
    motd-news.timer \
    snapd{,.autoimport,.core-fixup,.seeded,.system-shutdown}.service \
    snapd.socket \
    snapd.snap-repair.timer
```
