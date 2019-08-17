Meta
====

```bash
# shellcheck shell=bash

# change root password
sudo passwd root

# check sudo support
sudo EDITOR=vim visudo

# add default sysadmin
sudo useradd --create-home --shell /bin/bash --uid 1000 vac
sudo passwd vac
sudo groupadd --gid 27 --system sudo
sudo gpasswd --add vac sudo
sudo groupadd --gid 64 --system sysadmin
sudo gpasswd --add vac sysadmin
sudo passwd --lock root

# change hostname
sudo hostname STEM
sudo hostnamectl set-hostname STEM
echo 'STEM' | sudo tee /etc/hostname

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

# configure default address selection
sudo sed --in-place '\%^#precedence ::ffff:0:0/96  100$%r /dev/stdin' /etc/gai.conf << 'EOF'

precedence  ::1/128       50
precedence  ::/0          40
precedence  2002::/16     30
precedence ::/96          20
precedence ::ffff:0:0/96  100
EOF

# modify default ntp server
## apple
sudo sed --in-place '/^#NTP=$/r /dev/stdin' /etc/systemd/timesyncd.conf << 'EOF'
NTP=time1.apple.com time2.apple.com time3.apple.com time4.apple.com
EOF
## google
sudo sed --in-place '/^#NTP=$/r /dev/stdin' /etc/systemd/timesyncd.conf << 'EOF'
NTP=time1.google.com time2.google.com time3.google.com time4.google.com
EOF
sudo systemctl restart systemd-timesyncd.service
sudo systemctl enable systemd-timesyncd.service

# update system clock
sudo timedatectl set-ntp true
timedatectl status

# modify time zone
sudo ln --force --no-dereference --symbolic /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sudo timedatectl set-timezone Asia/Shanghai
sudo hwclock --systohc

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
sudo systemctl enable systemd-networkd.service

# change distro source
## arch
sudo tee /etc/pacman.d/mirrorlist << 'EOF'
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
EOF
## fedora
sudo tee /etc/yum.repos.d/fedora.repo << 'EOF'
[fedora]
name=Fedora $releasever - $basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/$releasever/Everything/$basearch/os/
enabled=1
metadata_expire=7d
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False
EOF
sudo tee /etc/yum.repos.d/fedora-updates.repo << 'EOF'
[updates]
name=Fedora $releasever - $basearch - Updates
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/updates/$releasever/Everything/$basearch/
enabled=1
repo_gpgcheck=0
type=rpm
gpgcheck=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False
EOF
sudo tee /etc/yum.repos.d/fedora-modular.repo << 'EOF'
[fedora-modular]
name=Fedora Modular $releasever - $basearch
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/$releasever/Modular/$basearch/os/
enabled=1
metadata_expire=7d
repo_gpgcheck=0
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False
EOF
sudo tee /etc/yum.repos.d/fedora-updates-modular.repo << 'EOF'
[updates-modular]
name=Fedora Modular $releasever - $basearch - Updates
failovermethod=priority
baseurl=https://mirrors.tuna.tsinghua.edu.cn/fedora/updates/$releasever/Modular/$basearch/
enabled=1
repo_gpgcheck=0
type=rpm
gpgcheck=1
metadata_expire=6h
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
skip_if_unavailable=False
EOF
## kali
sudo tee /etc/apt/sources.list << 'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib
deb-src https://mirrors.tuna.tsinghua.edu.cn/kali kali-rolling main non-free contrib
EOF
## ubuntu
sudo tee /etc/apt/sources.list << 'EOF'
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu bionic-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu bionic-security main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu bionic-updates main restricted universe multiverse

deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu bionic main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu bionic-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu bionic-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu bionic-updates main restricted universe multiverse
EOF

# make distro sync
## arch
sudo pacman --sync --refresh --sysupgrade --color auto
yes | sudo pacman --sync --clean --clean --color auto
## fedora
sudo dnf makecache
sudo dnf distro-sync
sudo dnf autoremove
sudo dnf clean packages
## kali | ubuntu
sudo apt update --list-cleanup
sudo apt full-upgrade --purge
sudo apt clean
sudo apt autoremove --purge
sudo find /etc -type f \( -name '*.dpkg-*' -o -name '*.ucf-*' \)
apt list --installed | awk --field-separator '/' '/,local]/ { print $1 }' | xargs --no-run-if-empty sudo apt purge --assume-yes

# update message of the day
sudo tee /etc/motd << 'EOF'

The programs included with the OS_RELEASE_ID GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

OS_RELEASE_ID GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
EOF
OS_RELEASE_ID=$(awk --field-separator '=' '/^ID=/ { print $2; exit }' /etc/os-release)
sudo sed --in-place "s/OS_RELEASE_ID/${OS_RELEASE_ID^}/g" /etc/motd
unset OS_RELEASE_ID

# modify secure shell daemon
sudo vim /etc/ssh/sshd_config
sudo rm --verbose /etc/ssh/ssh_host_*_key{,.pub}
declare -A host_key=(['ed25519']=256 ['rsa']=4096)
for type in "${!host_key[@]}"; do
    sudo ssh-keygen -a 100 -b "${host_key[${type}]}" -f "/etc/ssh/ssh_host_${type}_key" -t "${type}" -C 'sysadmin@local.domain' -N ''
done
unset host_key

# update initramfs image
## arch
sudo mkinitcpio --preset linux
## fedora
sudo dracut --force --verbose
## kali | ubuntu
sudo update-initramfs -k all -u

# update boot loader
cat /proc/cmdline
sudo vim /etc/default/grub
## arch
sudo grub-mkconfig --output /boot/grub/grub.cfg
## fedora
sudo grub2-mkconfig --output /boot/grub2/grub.cfg
## kali | ubuntu
sudo grub-mkconfig --output /boot/grub/grub.cfg

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
## dhcpcd
sudo tee --append /etc/dhcpcd.conf << 'EOF'

nohook resolv.conf
EOF
## isc-dhcp-client
sudo tee /etc/dhcp/dhclient-enter-hooks.d/no-dns << 'EOF'
#!/bin/sh

make_resolv_conf() {
    :
}
EOF
sudo chmod u+x /etc/dhcp/dhclient-enter-hooks.d/no-dns
## networkmanager
sudo tee /etc/NetworkManager/conf.d/no-dns.conf << 'EOF'
[main]
dns=none
EOF
## openresolv
sudo tee --append /etc/resolvconf.conf << 'EOF'

resolvconf=NO
EOF
## systemd
sudo systemctl disable --now systemd-resolved.service

# manage system service
## fedora
sudo systemctl disable --now \
    dnf-makecache.timer
## kali
sudo systemctl disable --now \
    apt-daily{,-upgrade}.timer
## ubuntu
sudo systemctl disable --now \
    apt-daily{,-upgrade}.timer \
    motd-news.timer

# install command-not-found
## arch
yes | sudo pacman --sync --needed pkgfile
sudo tee --append /etc/bash.bashrc << 'EOF'

[ -r /usr/share/doc/pkgfile/command-not-found.bash ] && . /usr/share/doc/pkgfile/command-not-found.bash
EOF
sudo systemctl enable --now pkgfile-update.timer
## kali | ubuntu
sudo apt install --assume-yes command-not-found < /dev/null
sudo apt update --list-cleanup
sudo update-command-not-found

# reboot system
sudo sync
sudo reboot
```

Arch
====

```bash
# shellcheck shell=bash

# check internet connection

# modify dns resolver

# configure default address selection

# modify default ntp server

# update system clock

# modify time zone

# configure system network

# change distro source

# format disk partition
sudo fdisk --list
sudo fdisk /dev/sda
sudo mkfs.xfs -f -L Arch /dev/sda1

# mount file system
sudo mount /dev/sda1 /mnt

# bootstrap base system
sudo pacstrap /mnt base sudo vim openssh intel-ucode grub
genfstab -U /mnt | sudo tee /mnt/etc/fstab
sudo cp --verbose {,/mnt}/etc/resolv.conf

# chroot into node
sudo arch-chroot /mnt

# change root password

# check sudo support
sudo groupadd --gid 27 --system sudo
sudo ln --force --no-dereference --symbolic /usr/{bin/vim,local/bin/vi}

# add default sysadmin

# change hostname
sudo tee /etc/hosts << 'EOF'
127.0.0.1       localhost
127.0.1.1       STEM

::1             localhost
EOF

# check internet connection

# modify dns resolver

# configure default address selection

# modify default ntp server

# update system clock

# modify time zone

# configure system network

# change distro source

# make distro sync

# update message of the day

# modify secure shell daemon
sudo systemctl restart sshd.service
sudo systemctl enable sshd.service

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# manage system service

# install command-not-found

# update system locale
echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf
sudo sed --in-place 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen

# color setup for ls
sudo tee --append /etc/bash.bashrc << 'EOF'

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
EOF

# install arch-install-scripts
yes | sudo pacman --sync --needed arch-install-scripts

# exit chroot
exit
sudo umount --recursive /mnt

# reboot system
```

Fedora
====

```bash
# shellcheck shell=bash

# change root password

# check sudo support

# add default sysadmin

# change hostname

# check internet connection

# modify dns resolver

# configure default address selection

# modify default ntp server

# update system clock

# modify time zone

# configure system network

# change distro source

# make distro sync

# update message of the day

# modify secure shell daemon
sudo dnf install policycoreutils-python-utils
sudo semanage port --add --type ssh_port_t --proto tcp 321
sudo firewall-cmd --permanent --service ssh --add-port 321/tcp
sudo firewall-cmd --permanent --service ssh --get-ports
sudo firewall-cmd --reload
sudo systemctl restart sshd.service
sudo systemctl enable sshd.service

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# manage system service

# install command-not-found

# reboot system
```

Kali
====

```bash
# shellcheck shell=bash

# change root password

# check sudo support

# add default sysadmin

# change hostname

# check internet connection

# modify dns resolver

# configure default address selection

# modify default ntp server

# update system clock

# modify time zone

# configure system network

## change distro source [debian]
sudo tee /etc/apt/sources.list << 'EOF'
deb http://mirrors.tuna.tsinghua.edu.cn/debian stable main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian stable-updates main contrib non-free

deb-src http://mirrors.tuna.tsinghua.edu.cn/debian stable main contrib non-free
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian stable-updates main contrib non-free
EOF

## remove foreign architecture
dpkg --print-architecture
dpkg --print-foreign-architectures
dpkg --print-foreign-architectures | xargs --no-run-if-empty sudo dpkg --remove-architecture

## make package manager support https
sudo apt update --list-cleanup
sudo apt install --assume-yes apt-transport-https < /dev/null
sudo apt clean
sudo apt autoremove --purge --assume-yes

## secure debian source
sudo sed --in-place 's/http:/https:/' /etc/apt/sources.list

## make initial system upgrade
sudo apt update --list-cleanup
sudo apt full-upgrade --purge --assume-yes
sudo apt purge --assume-yes apt-transport-https installation-report
sudo apt clean
sudo apt autoremove --purge --assume-yes

## install kali archive keyring
sudo curl --fail --location --silent --show-error --remote-name 'https://mirrors.tuna.tsinghua.edu.cn/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2018.2_all.deb'
sudo dpkg --install kali-archive-keyring_*_all.deb
sudo rm --force --verbose kali-archive-keyring_*_all.deb

# change distro source

# make distro sync
sudo apt install --assume-yes kali-{defaults,linux-{core,default,large}} < /dev/null

# update message of the day

# modify secure shell daemon
sudo systemctl restart ssh.service
sudo systemctl enable ssh.service

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# manage system service

# install command-not-found

# modify shell environment
sudo mv --verbose /etc/profile.d/kali.sh{,.forbid}

# install default plymouth
sudo apt install --assume-yes plymouth{,-themes} < /dev/null
sudo plymouth-set-default-theme kali
sudo grub-mkconfig --output /boot/grub/grub.cfg

# reboot system
```

Ubuntu
======

```bash
# shellcheck shell=bash

# change root password

# check sudo support

# add default sysadmin

# change hostname

# check internet connection

# modify dns resolver

# configure default address selection

# modify default ntp server

# update system clock

# modify time zone

# configure system network

# change distro source

# make distro sync

# update message of the day

# modify secure shell daemon

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# manage system service

# install command-not-found

# reboot system
```

```
> Add `console=ttyS0,115200n8` to boot parameter list for KVM.

# berkeley mirror
Server = https://mirrors.ocf.berkeley.edu/archlinux/$repo/os/$arch
```

```
# mirror list
https://http.kali.org/README.mirrorlist

# netboot iso
## [official]
https://http.kali.org/dists/kali-rolling/main/installer-amd64/current/images/netboot/mini.iso
## [berkeley]
https://mirrors.ocf.berkeley.edu/kali/dists/kali-rolling/main/installer-amd64/current/images/netboot/mini.iso
## [tsinghua]
https://mirrors.tuna.tsinghua.edu.cn/kali/dists/kali-rolling/main/installer-amd64/current/images/netboot/mini.iso

# berkeley mirror
deb https://mirrors.ocf.berkeley.edu/kali kali-rolling main non-free contrib
deb-src https://mirrors.ocf.berkeley.edu/kali kali-rolling main non-free contrib
```

```
# berkeley mirror
deb https://mirrors.ocf.berkeley.edu/ubuntu bionic main restricted universe multiverse
deb https://mirrors.ocf.berkeley.edu/ubuntu bionic-backports main restricted universe multiverse
deb https://mirrors.ocf.berkeley.edu/ubuntu bionic-security main restricted universe multiverse
deb https://mirrors.ocf.berkeley.edu/ubuntu bionic-updates main restricted universe multiverse

deb-src https://mirrors.ocf.berkeley.edu/ubuntu bionic main restricted universe multiverse
deb-src https://mirrors.ocf.berkeley.edu/ubuntu bionic-backports main restricted universe multiverse
deb-src https://mirrors.ocf.berkeley.edu/ubuntu bionic-security main restricted universe multiverse
deb-src https://mirrors.ocf.berkeley.edu/ubuntu bionic-updates main restricted universe multiverse
```
