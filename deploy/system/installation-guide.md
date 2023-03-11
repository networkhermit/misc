Meta
====

```bash
# shellcheck shell=bash

# change root password
sudo passwd root

# check sudo support
echo /etc/sudoers.d/10-local
sudo SUDO_EDITOR=vim visudo

# add default sysadmin
sudo groupadd --gid 27 --system sudo
sudo groupadd --gid 256 --system sysadmin
sudo groupadd --gid 1000 vac
sudo useradd --create-home --gid 1000 --shell /bin/bash --uid 1000 vac
sudo gpasswd --add vac sudo
sudo gpasswd --add vac sysadmin
sudo passwd vac
if [[ -n "${ANSIBLE_USER}" ]]; then
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
echo /etc/systemd/system-preset/00-local.preset
sudo systemctl preset-all

# change hostname
sudo hostname STEM
sudo hostnamectl set-hostname STEM
echo /etc/hostname

# check internet connection
ip address add 192.168.1.10/24 dev eth0
ip route add default via 192.168.1.1
ping -c 4 1.1.1.1

# modify dns resolver
echo /etc/resolv.conf

# configure default address selection
echo /etc/gai.conf

# modify default ntp server
echo /etc/systemd/timesyncd.conf.d/10-local.conf
systemd-analyze cat-config systemd/timesyncd.conf --no-pager
sudo systemctl restart systemd-timesyncd.service

# update system clock
sudo timedatectl set-ntp true
timedatectl status

# modify time zone
sudo ln --force --no-dereference --symbolic /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sudo timedatectl set-timezone Asia/Shanghai
sudo hwclock --systohc

# configure system network
echo /etc/systemd/network/10-eth0.network
sudo systemctl restart systemd-networkd.service

# change distro source
## arch
echo /etc/pacman.d/mirrorlist
## fedora
echo /etc/yum.repos.d/fedora.repo
echo /etc/yum.repos.d/fedora-updates.repo
echo /etc/yum.repos.d/fedora-modular.repo
echo /etc/yum.repos.d/fedora-updates-modular.repo
## kali
echo /etc/apt/sources.list

# make distro sync
# reference script=sys-sync
# reference script=sys-obs

# update message of the day
sudo mv --no-clobber --verbose /etc/motd{,.original}
echo /etc/motd
# shellcheck source=/dev/null
source <(grep '^NAME=' /etc/os-release)
: "${NAME:=Linux}"
OS_RELEASE_NAME=${NAME% Linux}
OS_RELEASE_NAME=${OS_RELEASE_NAME% GNU/Linux}
sudo sed --in-place "s%OS_RELEASE_NAME%${OS_RELEASE_NAME}%g" /etc/motd
unset NAME OS_RELEASE_NAME

# modify secure shell daemon
sudo mkdir --parents --verbose /etc/ssh/sshd_config.d
echo /etc/ssh/sshd_config.d/10-local.conf
sudo rm --force --verbose /etc/ssh/ssh_host_*_key{,.pub}
declare -A host_key=(['ed25519']=256 ['rsa']=4096)
for type in "${!host_key[@]}"; do
    sudo ssh-keygen -a 100 -b "${host_key[${type}]}" -f "/etc/ssh/ssh_host_${type}_key" -t "${type}" -C 'sysadmin@local.domain' -N ''
done
unset host_key
sudo sshd -T | sort | less

# update initramfs image
# reference script=sys-boot

# update boot loader
cat /proc/cmdline
sudo vim /etc/default/grub
# reference script=sys-boot

# network control
echo /etc/sysctl.d/network-control.conf

# disable dynamic resolver
## systemd-resolved
ls --human-readable -l /etc/resolv.conf
## networkmanager
echo /etc/NetworkManager/conf.d/no-dns.conf

# install command-not-found
## arch
{ yes || true; } | sudo pacman --sync --needed pkgfile
sudo tee --append /etc/bash.bashrc << 'EOF'

[[ -r /usr/share/doc/pkgfile/command-not-found.bash ]] && . /usr/share/doc/pkgfile/command-not-found.bash
EOF
## kali
sudo apt install --assume-yes command-not-found < /dev/null
sudo apt update
sudo update-command-not-found

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
sudo pacstrap /mnt base linux{,-firmware} intel-ucode grub efibootmgr sudo vim openssh gptfdisk xfsprogs
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
echo /etc/hosts

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

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# install command-not-found

# update system locale
echo /etc/locale.conf
sudo sed --in-place 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sudo locale-gen
echo /etc/vconsole.conf

# color setup for ls
sudo tee --append /etc/bash.bashrc << 'EOF'

if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
EOF

# install arch-install-scripts
{ yes || true; } | sudo pacman --sync --needed arch-install-scripts

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
sudo dnf install policycoreutils-python-utils
sudo semanage port --add --type ssh_port_t --proto tcp 321
sudo firewall-cmd --permanent --service ssh --add-port 321/tcp
sudo firewall-cmd --permanent --service ssh --remove-port 22/tcp
sudo firewall-cmd --permanent --service ssh --get-ports
sudo firewall-cmd --reload
sudo systemctl restart sshd.service

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# install command-not-found

# modify dnf configuration
sudo sed --in-place 's/^\(installonly_limit\)=.*/\1=2/' /etc/dnf/dnf.conf

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
sudo apt install --assume-yes kali-linux-default < /dev/null

# update message of the day

# modify secure shell daemon
sudo systemctl restart ssh.service

# update initramfs image

# update boot loader

# network control

# disable dynamic resolver

# install command-not-found

# modify shell environment
sudo mv --verbose /etc/profile.d/kali.sh{,.forbid}

# reboot system
```
