Meta
====

```bash
# shellcheck shell=bash

# change root password
sudo passwd root

# check sudo support
sudo SUDO_EDITOR=vim visudo

# add default sysadmin
sudo groupadd --gid 27 --system sudo
sudo groupadd --gid 256 --system sysadmin
sudo groupadd --gid 1000 vac
sudo useradd --create-home --gid 1000 --shell /bin/bash --uid 1000 vac
sudo gpasswd --add vac sudo
sudo gpasswd --add vac sysadmin
sudo passwd vac
if [ -n "${ANSIBLE_USER}" ]; then
    sudo groupadd --gid 8128 --system "${ANSIBLE_USER}"
    sudo useradd --create-home --gid 8128 --shell /bin/bash --system --uid 8128 "${ANSIBLE_USER}"
    sudo gpasswd --add "${ANSIBLE_USER}" sudo
    sudo gpasswd --add "${ANSIBLE_USER}" sysadmin
    sudo SUDO_EDITOR=tee visudo --file "/etc/sudoers.d/${ANSIBLE_USER}" << EOF
${ANSIBLE_USER} ALL=(ALL:ALL) NOPASSWD:ALL
EOF
    sudo passwd --delete "${ANSIBLE_USER}"
    sudo passwd --lock "${ANSIBLE_USER}"
    sudo install --directory --group "${ANSIBLE_USER}" --mode 700 --owner "${ANSIBLE_USER}" "/home/${ANSIBLE_USER}/.ssh"
    sudo install --group "${ANSIBLE_USER}" --mode 600 --owner "${ANSIBLE_USER}" /dev/null "/home/${ANSIBLE_USER}/.ssh/authorized_keys"
    if [ -n "${ANSIBLE_USER_DEFAULT_KEY}" ]; then
        sudo install --group "${ANSIBLE_USER}" --mode 600 --owner "${ANSIBLE_USER}" /dev/stdin "/home/${ANSIBLE_USER}/.ssh/authorized_keys" << EOF
$(echo ${ANSIBLE_USER_DEFAULT_KEY})
EOF
    fi
fi
ls --directory --human-readable -l / /home/* /root
sudo passwd --delete root
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
## cloudflare | apple
: "${NTP_LIST:=time.cloudflare.com time1.apple.com time2.apple.com time3.apple.com time4.apple.com}"
## cloudflare | google
: "${NTP_LIST:=time.cloudflare.com time1.google.com time2.google.com time3.google.com time4.google.com}"
sudo sed --in-place '/^#NTP=$/r /dev/stdin' /etc/systemd/timesyncd.conf << EOF
NTP=${NTP_LIST}
EOF
unset NTP_LIST
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
: "${DEVICE:=eth0}"
sudo tee "/etc/systemd/network/10-${DEVICE}.network" << EOF
[Match]
Name=${DEVICE}

[Network]
DHCP=yes

[DHCP]
UseDNS=no
UseNTP=no

#[Address]
#Address=192.168.0.10/16

#[Route]
#Gateway=192.168.0.1

#[Address]
#Address=fd00::/8
EOF
unset DEVICE
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

#deb https://kali.download/kali kali-rolling main non-free contrib
#deb-src https://kali.download/kali kali-rolling main non-free contrib
EOF
## manjaro
sudo tee /etc/pacman.d/mirrorlist << 'EOF'
Server = https://mirrors.tuna.tsinghua.edu.cn/manjaro/stable/$repo/$arch
EOF
## opensuse
sudo zypper addrepo --check --gpgcheck --no-refresh https://mirrors.tuna.tsinghua.edu.cn/opensuse/tumbleweed/repo/oss tumbleweed-oss
sudo zypper addrepo --check --gpgcheck --no-refresh https://mirrors.tuna.tsinghua.edu.cn/opensuse/tumbleweed/repo/non-oss tumbleweed-non-oss
sudo zypper addrepo --check --gpgcheck --no-refresh https://download.opensuse.org/update/tumbleweed/ tumbleweed-update
# https://build.opensuse.org/project
# https://download.opensuse.org
sudo zypper addrepo --check --gpgcheck --no-refresh https://download.opensuse.org/repositories/network/openSUSE_Tumbleweed/network.repo
sudo zypper addrepo --check --gpgcheck --no-refresh https://download.opensuse.org/repositories/security/openSUSE_Tumbleweed/security.repo
sudo zypper addrepo --check --gpgcheck --no-refresh https://download.opensuse.org/repositories/utilities/openSUSE_Factory/utilities.repo
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
# reference script=sys-sync
# reference script=sys-obs

# update message of the day
sudo mv --no-clobber --verbose /etc/motd{,.original}
sudo tee /etc/motd << 'EOF'

The programs included with the OS_RELEASE_NAME GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

OS_RELEASE_NAME GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
EOF
# shellcheck disable=SC1090
source <(grep '^NAME=' /etc/os-release)
: "${NAME:=Linux}"
OS_RELEASE_NAME=${NAME% Linux}
OS_RELEASE_NAME=${OS_RELEASE_NAME% GNU/Linux}
sudo sed --in-place "s%OS_RELEASE_NAME%${OS_RELEASE_NAME}%g" /etc/motd
unset NAME OS_RELEASE_NAME

# modify secure shell daemon
sudo mkdir --parents --verbose /etc/ssh/sshd_config.d
sudo tee /etc/ssh/sshd_config.d/local.conf << 'EOF'
Port 321

HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256
PubkeyAcceptedKeyTypes ssh-ed25519-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-256

Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
KexAlgorithms curve25519-sha256,diffie-hellman-group18-sha512,diffie-hellman-group16-sha512,diffie-hellman-group14-sha256,diffie-hellman-group-exchange-sha256
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com

LogLevel VERBOSE

AllowGroups sysadmin

LoginGraceTime 42s
PermitRootLogin no

PasswordAuthentication no

ClientAliveInterval 20
EOF
sudo sshd -T | sort | less
sudo rm --verbose /etc/ssh/ssh_host_*_key{,.pub}
declare -A host_key=(['ed25519']=256 ['rsa']=4096)
for type in "${!host_key[@]}"; do
    sudo ssh-keygen -a 100 -b "${host_key[${type}]}" -f "/etc/ssh/ssh_host_${type}_key" -t "${type}" -C 'sysadmin@local.domain' -N ''
done
unset host_key

# update initramfs image
# reference script=sys-boot

# update boot loader
cat /proc/cmdline
sudo vim /etc/default/grub
# reference script=sys-boot

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
sudo systemctl enable --now fstrim.timer
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
## arch | manjaro
(yes || true) | sudo pacman --sync --needed pkgfile
sudo tee --append /etc/bash.bashrc << 'EOF'

[ -r /usr/share/doc/pkgfile/command-not-found.bash ] && . /usr/share/doc/pkgfile/command-not-found.bash
EOF
sudo systemctl enable --now pkgfile-update.timer
## kali | ubuntu
sudo apt install --assume-yes command-not-found < /dev/null
sudo apt update
sudo update-command-not-found
## opensuse
sudo zypper install command-not-found

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

# manipulate disk partition
lsblk --fs
sudo fdisk --list
sudo gdisk /dev/vda
sudo mkfs.xfs -f -L Arch /dev/vdaX

# mount file system
sudo mount /dev/vdaX /mnt

# bootstrap base system
sudo pacstrap /mnt base linux{,-firmware} sudo vim openssh {amd,intel}-ucode grub efibootmgr
genfstab -t PARTUUID /mnt | sudo tee /mnt/etc/fstab
sudo cp --verbose {,/mnt}/etc/resolv.conf

# chroot into node
sudo arch-chroot /mnt

# change root password

# check sudo support
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
sudo sed --in-place 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sudo locale-gen

# color setup for ls
sudo tee --append /etc/bash.bashrc << 'EOF'

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
EOF

# install arch-install-scripts
(yes || true) | sudo pacman --sync --needed arch-install-scripts

# exit chroot
exit
sudo umount --recursive /mnt

# reboot system
```

Fedora
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
sudo dnf install policycoreutils-python-utils
sudo semanage port --add --type ssh_port_t --proto tcp 321
sudo firewall-cmd --permanent --service ssh --add-port 321/tcp
sudo firewall-cmd --permanent --service ssh --remove-port 22/tcp
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

# modify dnf configuration
sudo sed --in-place 's/^\(installonly_limit\)=.*/\1=2/' /etc/dnf/dnf.conf

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
sudo curl --fail --location --silent --show-error --remote-name 'https://mirrors.tuna.tsinghua.edu.cn/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2020.2_all.deb'
sudo dpkg --install kali-archive-keyring_*_all.deb
sudo rm --force --verbose kali-archive-keyring_*_all.deb

# change distro source

# make distro sync
sudo apt install --assume-yes kali-{defaults,linux-{default,large}} < /dev/null

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

Manjaro
=======

```bash
# shellcheck shell=bash

# change root password

# check sudo support
sudo ln --force --no-dereference --symbolic /usr/{bin/vim,local/bin/vi}

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
sudo systemctl restart sshd.service
sudo systemctl enable sshd.service

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# manage system service

# install command-not-found

# install arch-install-scripts
(yes || true) | sudo pacman --sync --needed arch-install-scripts

# reboot system
```

openSUSE
========

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
sudo firewall-cmd --permanent --service ssh --add-port 321/tcp
sudo firewall-cmd --permanent --service ssh --remove-port 22/tcp
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
sudo systemctl restart ssh.service
sudo systemctl enable ssh.service

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# manage system service

# install command-not-found

# reboot system
```

```
> Add `console=ttyS0,115200n8` to boot parameters for KVM.

# linux kernel archive
Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
```

```
# archive
deb https://archive.kali.org/kali kali-rolling main non-free contrib
deb-src https://archive.kali.org/kali kali-rolling main non-free contrib

# netboot iso
https://archive.kali.org/kali/dists/kali-rolling/main/installer-amd64/current/images/netboot/mini.iso
```

```
# linux kernel archive
deb https://mirrors.kernel.org/ubuntu bionic main restricted universe multiverse
deb https://mirrors.kernel.org/ubuntu bionic-backports main restricted universe multiverse
deb https://mirrors.kernel.org/ubuntu bionic-security main restricted universe multiverse
deb https://mirrors.kernel.org/ubuntu bionic-updates main restricted universe multiverse

deb-src https://mirrors.kernel.org/ubuntu bionic main restricted universe multiverse
deb-src https://mirrors.kernel.org/ubuntu bionic-backports main restricted universe multiverse
deb-src https://mirrors.kernel.org/ubuntu bionic-security main restricted universe multiverse
deb-src https://mirrors.kernel.org/ubuntu bionic-updates main restricted universe multiverse
```
