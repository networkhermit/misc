Meta
====

```bash
# shellcheck shell=bash

# change root password
passwd root

# check sudo support
sudo install -D --mode 640 --target-directory /etc/sudoers.d config/etc/sudoers.d/10-local
SUDO_EDITOR=vim visudo

# add default sysadmin
sudo groupadd --gid 256 --system sysadmin
sudo groupadd --gid 1000 vac
sudo useradd --create-home --gid 1000 --shell /bin/bash --uid 1000 vac
sudo gpasswd --add vac wheel
sudo gpasswd --add vac sysadmin
sudo passwd vac
if [[ -n "${ANSIBLE_USER}" ]]; then
    sudo groupadd --gid 8128 --system "${ANSIBLE_USER}"
    sudo useradd --create-home --gid 8128 --shell /bin/bash --system --uid 8128 "${ANSIBLE_USER}"
    sudo gpasswd --add "${ANSIBLE_USER}" wheel
    sudo gpasswd --add "${ANSIBLE_USER}" sysadmin
    sudo SUDO_EDITOR=tee visudo --file "/etc/sudoers.d/${ANSIBLE_USER}" << EOF
${ANSIBLE_USER} ALL=(ALL:ALL) NOPASSWD:ALL
EOF
    sudo passwd --delete "${ANSIBLE_USER}"
    sudo passwd --lock "${ANSIBLE_USER}"
    sudo install --directory --group "${ANSIBLE_USER}" --mode 700 --owner "${ANSIBLE_USER}" "/home/${ANSIBLE_USER}/.ssh"
    sudo install --group "${ANSIBLE_USER}" --mode 600 --owner "${ANSIBLE_USER}" /dev/null "/home/${ANSIBLE_USER}/.ssh/authorized_keys"
    if [[ -n "${ANSIBLE_USER_DEFAULT_KEY}" ]]; then
        sudo install --group "${ANSIBLE_USER}" --mode 600 --owner "${ANSIBLE_USER}" /dev/stdin "/home/${ANSIBLE_USER}/.ssh/authorized_keys" << EOF
${ANSIBLE_USER_DEFAULT_KEY}
EOF
    fi
fi
ls --directory --human-readable -l / /home/* /root
sudo passwd --delete root
sudo passwd --lock root

# manage system service
sudo install -D --mode 644 --target-directory /etc/systemd/system-preset config/etc/systemd/system-preset/00-local.preset
sudo systemctl preset-all

# change hostname
sudo hostnamectl set-hostname stem || sudo hostname stem
sudo install -D --mode 644 --target-directory /etc config/etc/hostname

# check internet connection
sudo ip address add 192.168.1.10/24 dev eth0
# sudo ip link set eth0 down
# sudo ip link set eth0 up
# ip link show dev eth0
# sudo ip link set dev eth0 mtu 1420
sudo ip route add default via 192.168.1.1 dev eth0
ping -c 4 1.1.1.1

# modify dns resolver
sudo install -D --mode 644 --target-directory /etc config/etc/resolv.conf

# configure default address selection
sudo install -D --mode 644 --target-directory /etc config/etc/gai.conf

# modify default ntp server
sudo install -D --mode 644 --target-directory /etc/systemd/timesyncd.conf.d config/etc/systemd/timesyncd.conf.d/10-local.conf
systemd-analyze cat-config systemd/timesyncd.conf --no-pager
sudo install -D --mode 644 --target-directory /etc/chrony.d config/etc/chrony.d/10-local.conf
sudo vim /etc/chrony.conf # kali: /etc/chrony/chrony.conf
sudo systemctl restart chronyd.service

# update system clock
timedatectl status
systemctl status chronyd.service

# modify time zone
sudo ln --force --no-dereference --symbolic /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sudo timedatectl set-timezone Asia/Shanghai
sudo hwclock --systohc

# configure system network
sudo install -D --mode 644 --target-directory /etc/systemd/network config/etc/systemd/network/10-eth0.network
sudo systemctl restart systemd-networkd.service

# change distro source
## arch
sudo install -D --mode 644 --target-directory /etc/pacman.d config/etc/pacman.d/mirrorlist
## fedora
sudo install -D --mode 644 --target-directory /etc/yum.repos.d config/etc/yum.repos.d/fedora{,-updates}.repo
## kali
sudo install -D --mode 644 --target-directory /etc/apt config/etc/apt/sources.list
## freebsd
sudo install -D --mode 644 --target-directory /usr/local/etc/pkg/repos config/bsd/usr/local/etc/pkg/repos/FreeBSD.conf
## openbsd
sudo install -D --mode 644 --target-directory /etc config/etc/installurl

# make distro sync
# reference script=sys-sync
# reference script=sys-duck

# update message of the day
sudo mv --no-clobber --verbose /etc/motd{,.original}
sudo install -D --mode 644 --target-directory /etc config/etc/motd
# shellcheck source=/dev/null
source <(grep '^NAME=' /etc/os-release)
: "${NAME:=Linux}"
OS_RELEASE_NAME=${NAME% Linux}
OS_RELEASE_NAME=${OS_RELEASE_NAME% GNU/Linux}
sudo sed --in-place "s%OS_RELEASE_NAME%${OS_RELEASE_NAME}%g" /etc/motd
unset NAME OS_RELEASE_NAME

# modify secure shell daemon
sudo install -D --mode 644 --target-directory /etc/ssh/sshd_config.d config/etc/ssh/sshd_config.d/10-local.conf
sudo rm --force --verbose /etc/ssh/ssh_host_*_key{,.pub}
declare -A host_key=(['ed25519']=256 ['rsa']=4096)
for type in "${!host_key[@]}"; do
    sudo ssh-keygen -a 100 -b "${host_key[${type}]}" -f "/etc/ssh/ssh_host_${type}_key" -t "${type}" -C "sysadmin@$(uname -n)" -N ''
done
unset host_key
sudo sshd -T | sort | less
sudo systemctl restart sshd.service

# update initramfs image
# reference script=sys-boot

# update boot loader
cat /proc/cmdline
sudo vim /etc/default/grub
# reference script=sys-boot

# network control
sudo install -D --mode 644 --target-directory /etc/sysctl.d config/etc/sysctl.d/network-control.conf

# disable dynamic resolver
## systemd-resolved
ls --human-readable -l /etc/resolv.conf
## networkmanager
sudo install -D --mode 644 --target-directory /etc/NetworkManager/conf.d config/etc/NetworkManager/conf.d/no-dns.conf
## resolvd
rcctl check resolvd

# install command-not-found
## arch
{ yes || true; } | sudo pacman --sync --needed pkgfile
sudo tee --append /etc/bash.bashrc << 'EOF'

[[ -r /usr/share/doc/pkgfile/command-not-found.bash ]] && . /usr/share/doc/pkgfile/command-not-found.bash
EOF
## fedora
sudo dnf install --assumeyes PackageKit-command-not-found
## kali
sudo apt install --assume-yes command-not-found < /dev/null
sudo apt update
sudo update-command-not-found
## openbsd
sudo pkg_add pkglocatedb--

# reboot system
sudo sync
sudo reboot
```

Arch
====

> Add `console=ttyS0,115200n8` to boot parameters for KVM.

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
sudo pacstrap /mnt base linux{,-firmware} iptables-nft {amd,intel}-ucode grub efibootmgr sudo vim openssh gptfdisk xfsprogs zram-generator
sudo ln --force --no-dereference --relative --symbolic --verbose "$(command -v vim)" /usr/bin/vi
genfstab -t PARTUUID /mnt | sudo tee /mnt/etc/fstab
sudo cp --verbose {,/mnt}/etc/resolv.conf

# chroot into node
sudo arch-chroot /mnt

# change root password

# check sudo support

# add default sysadmin
sudo touch /etc/subuid /etc/subgid
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 vac

# manage system service

# change hostname
sudo install -D --mode 644 --target-directory /etc config/etc/hosts

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

# install command-not-found

# update system locale
sudo install -D --mode 644 --target-directory /etc config/etc/locale.conf
sudo sed --in-place 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sudo locale-gen
sudo install -D --mode 644 --target-directory /etc config/etc/vconsole.conf

# color setup for ls
sudo tee --append /etc/bash.bashrc << 'EOF'

if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
EOF

# install arch-install-scripts
{ yes || true; } | sudo pacman --sync --needed arch-install-scripts

# setup mdns (optional)
{ yes || true; } | sudo pacman --sync --needed avahi nss-mdns

# exit chroot
#exit
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

# manage system service

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
sudo semanage port --add --type ssh_port_t --proto tcp 321
sudo firewall-cmd --permanent --service ssh --add-port 321/tcp
sudo firewall-cmd --permanent --service ssh --remove-port 22/tcp
sudo firewall-cmd --permanent --service ssh --get-ports
sudo firewall-cmd --reload

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# install command-not-found

# modify dnf configuration
sudo sed --in-place 's/^\(installonly_limit\)=.*/\1=2/' /etc/dnf/dnf.conf

# change selinux to permissive mode
sudo vim /etc/selinux/config
sudo fixfiles -F onboot

# setup mdns (optional)
sudo dnf install --assumeyes avahi nss-mdns
sudo firewall-cmd --permanent --add-service mdns

# reboot system
```

Kali
====

> netboot iso
> https://archive.kali.org/kali/dists/kali-rolling/main/installer-amd64/current/images/netboot/mini.iso

```bash
# shellcheck shell=bash

# change root password

# check sudo support
SUDO_EDITOR=vim visudo --file /etc/sudoers.d/10-local

# add default sysadmin
sudo gpasswd --add vac sudo
if [[ -n "${ANSIBLE_USER}" ]]; then
    sudo gpasswd --add "${ANSIBLE_USER}" sudo
fi

# manage system service

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
sudo apt install --assume-yes kali-linux-default < /dev/null

# update message of the day

# modify secure shell daemon
sudo systemctl restart ssh.service

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# install command-not-found

# enable tmpfs for /tmp
sudo cp /usr/share/systemd/tmp.mount /etc/systemd/system/
sudo systemctl enable tmp.mount
sudo mkdir /mnt/root
sudo mount --bind / /mnt/root
sudo find /mnt/root/tmp -mindepth 1 # -delete
sudo umount /mnt/root
sudo rmdir /mnt/root

# setup mdns (optional)
sudo apt install --assume-yes avahi-daemon libnss-mdns < /dev/null

# reboot system
```

FreeBSD
=======

```bash
# shellcheck shell=bash

# change root password

# check sudo support
pkg install --yes doas sudo
sudo install -D --mode 600 --target-directory /etc config/etc/doas.conf
sudo install -D --mode 640 --target-directory /usr/local/etc/sudoers.d config/etc/sudoers.d/10-local

# add default sysadmin
sudo pw groupadd sysadmin -g 256
sudo pw groupadd vac -g 1000
sudo adduser -M 700 -g 1000 -s /bin/sh -u 1000 -w no
sudo pw groupmod wheel -m vac
sudo pw groupmod sysadmin -m vac
sudo passwd vac
ls -dhl / /home/* /root
sudo pw usermod root -w no
sudo pw lock root

# manage system service
service -e

# change hostname
sudo sysrc hostname=stem

# check internet connection
sudo ifconfig em0 inet 192.168.1.10/24
# sudo ifconfig em0 down
# sudo ifconfig em0 up
# ifconfig em0
# sudo ifconfig em0 mtu 1420
sudo route add default 192.168.1.1
ping -c 4 1.1.1.1

# modify dns resolver

# configure default address selection
sudo sysrc ip6addrctl_policy=ipv4_prefer

# modify default ntp server
sudo vim /etc/ntp.conf
sudo service ntpd restart

# update system clock
ntpq --numeric --peers
service ntpd status

# modify time zone
sudo ln -fns /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sysctl machdep.disable_rtc_set

# configure system network
sudo vim /etc/rc.conf
sudo service netif restart

# change distro source

# make distro sync

# update message of the day

# modify secure shell daemon
sudo install -D --mode 644 --target-directory /etc/ssh/sshd_config.d config/etc/ssh/sshd_config.d/00-freebsd.conf
sudo service sshd restart

# update boot loader
sudo install -D --mode 644 --target-directory /boot config/bsd/boot/loader.conf

# network control
sudo install -D --mode 644 --target-directory /etc config/etc/sysctl.conf.local

# disable dynamic resolver

# install command-not-found

# update system locale
sudo vim /etc/login.conf
sudo cap_mkdb /etc/login.conf

# enable tmpfs for /tmp
sudo sysrc tmpmfs=YES
sudo sysrc tmpsize=4054866k
sudo mkdir /mnt/root
sudo mount -t nullfs / /mnt/root
sudo find /mnt/root/tmp -mindepth 1 # -delete
sudo umount /mnt/root
sudo rmdir /mnt/root

# setup mdns (optional)
sudo pkg install --yes mDNSResponder mDNSResponder_nss

# reboot system
```

OpenBSD
=======

> Type `set tty com0` and `boot` in the boot loader to use serial console.

```bash
# shellcheck shell=bash

# change root password

# check sudo support
pkg_add sudo--
sudo install -D --mode 600 --target-directory /etc config/etc/doas.conf

# add default sysadmin
sudo groupadd -g 256 sysadmin
sudo groupadd -g 1000 vac
sudo useradd -g 1000 -m -s /bin/ksh -u 1000 vac
sudo usermod -G wheel vac
sudo usermod -G sysadmin vac
sudo passwd vac
ls -dhl / /home/* /root
sudo vipw

# manage system service
rcctl ls on

# change hostname
sudo install -D --mode 644 --target-directory /etc config/etc/myname

# check internet connection
sudo ifconfig em0 inet 192.168.1.10/24
# sudo ifconfig em0 down
# sudo ifconfig em0 up
# ifconfig em0
# sudo ifconfig em0 mtu 1420
sudo route add default 192.168.1.1
ping -c 4 1.1.1.1

# modify dns resolver

# configure default address selection

# modify default ntp server
sudo vim /etc/ntp.conf
sudo rcctl restart ntpd

# update system clock
ntpctl -s peers
rcctl check ntpd

# modify time zone
sudo ln -fns /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# configure system network
sudo vim /etc/hostname.em0
sudo sh /etc/netstart -n em0
sudo sh /etc/netstart em0

# change distro source

# make distro sync

# update message of the day

# modify secure shell daemon
sudo rcctl restart sshd

# update boot loader
sudo install -D --mode 644 --target-directory /etc config/etc/boot.conf

# network control

# disable dynamic resolver

# install command-not-found

# update system locale
sudo vim /etc/profile

# setup mdns (optional)
sudo pkg_add openmdns--

# reboot system
```
