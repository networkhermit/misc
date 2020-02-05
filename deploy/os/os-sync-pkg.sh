#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

trap 'echo ✗ fatal error: errexit trapped with status $? 1>&2' ERR

if (( EUID != 0 )); then
    echo "✗ This script must be run as root" 1>&2
    exit 1
fi

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

if [ "${OSTYPE}" != linux-gnu ]; then
    echo "✗ unknown os type: ‘${OSTYPE}’" 1>&2
    exit 1
fi

DISTRO=$(awk --field-separator = '/^ID=/ { print $2; exit }' /etc/os-release)

##################
# CORE
#       base-files
#       glibc
#       linux
#       coreutils
#       util-linux
#       systemd
##################

##################
# SHELL
#       bash
#       zsh
#       man-pages
#       info
#       vim
#       \shellcheck
##################

##################
# UTIL
#       at
#       bc
#       binutils
#       bzip2
#       cpio
#       diffutils
#       dos2unix
#       dosfstools
#       exa
#       file
#       findutils
#       finger
#       gawk
#       gnupg
#       grep
#       gzip
#       less
#       lynx
#       lz4
#       lzop
#       moreutils
#       most
#       ncurses
#       pandoc
#       parallel
#       pigz
#       pygmentize
#       readline
#       sed
#       tar
#       time
#       tree
#       unzip
#       which
#       words
#       xz
#       zip
#       zstd
##################

##################
# SYSADMIN
#       acl
#       btrfs-progs
#       cronie
#       cryptsetup
#       dkms
#       dmidecode
#       device-mapper
#       e2fsprogs
#       exim
#       fakeroot
#       gptfdisk
#       haveged
#       hdparm
#       htop
#       initramfs-tools
#       irqbalance
#       keyutils
#       kmod
#       libosinfo
#       lm-sensors
#       logrotate
#       lsb-release
#       lsof
#       lvm2
#       mdadm
#       numad
#       parted
#       pciutils
#       procps
#       psmisc
#       rng-tools
#       shadow
#       smartmontools
#       strace
#       sudo
#       syslogd
#       sysstat
#       thin-provisioning-tools
#       tmux
#       tzdata
#       usbutils
#       xfsdump
#       xfsprogs
##################

##################
# NETWORK OPERATOR
#       bind-tools
#       bridge-utils
#       ca-certificates
#       chrony
#       curl
#       dhcp-client
#       dns-root-data
#       dnstracer
#       ethtool
#       fping
#       geoip
#       hostname
#       httpie
#       iperf3
#       iproute2
#       ipset
#       iptables
#       iputils
#       ipvsadm
#       ldnsutils
#       mosh
#       mtr
#       net-tools
#       netcat
#       nftables
#       nikto
#       nmap
#       ntp
#       openssh
#       openssl
#       publicsuffix
#       rsync
#       socat
#       sslscan
#       swaks
#       tcpdump
#       telnet
#       testssl.sh
#       traceroute
#       wget
#       whois
#       wireless-tools
#       wireshark
#       wpa-supplicant
##################

##################
# PLT
#       c
#       c++
#       elixir
#       erlang
#       go
#       haskell
#       java
#       lisp
#       nodejs
#       ocaml
#       php
#       python
#       ruby
#       rust
##################

##################
# GAME
#       cmatrix
#       cowsay
#       fortunes
#       neofetch
#       screenfetch
#       sl
##################

##################
# DevOps
#       ansible
#       certbot
#       dnsmasq
#       docker
#       git
#       libguestfs-tools
#       libvirt
#       nginx
#       oathtool
#       pam
#       qemu
#       salt
#       virtinst
#       wireguard
##################

case "${DISTRO}" in
    arch)

        # CORE
        pacman --sync --needed \
            core/filesystem \
            core/iana-etc \
            core/glibc \
            core/linux{,-api-headers,-docs,-firmware,-headers} \
            core/coreutils \
            core/util-linux \
            core/systemd{,-sysvcompat}

        # SHELL
        pacman --sync --needed \
            core/bash \
            extra/bash-completion \
            extra/zsh{,-doc} \
            core/man-pages \
            core/texinfo \
            extra/vim \
            community/shellcheck

        # UTIL
        pacman --sync --needed \
            community/at \
            extra/bc \
            core/binutils \
            core/bzip2 \
            extra/cpio \
            core/diffutils \
            community/dos2unix \
            core/dosfstools \
            community/exa \
            core/file \
            core/findutils \
            core/gawk \
            core/gnupg \
            core/grep \
            core/gzip \
            core/less \
            extra/lynx \
            core/lz4 \
            extra/lzop \
            community/moreutils \
            extra/most \
            core/ncurses \
            community/pandoc \
            community/parallel \
            community/pigz \
            community/pygmentize \
            core/readline \
            core/sed \
            core/tar \
            extra/time \
            extra/tree \
            extra/unzip \
            core/which \
            community/words \
            core/xz \
            extra/zip \
            core/zstd

        # SYSADMIN
        pacman --sync --needed \
            core/acl \
            core/btrfs-progs \
            core/cronie \
            core/cryptsetup \
            extra/dkms \
            extra/dmidecode \
            core/device-mapper \
            core/e2fsprogs \
            community/exim \
            core/fakeroot \
            extra/gptfdisk \
            extra/haveged \
            core/hdparm \
            extra/htop \
            core/mkinitcpio{,-busybox} \
            extra/irqbalance \
            core/keyutils \
            core/kmod \
            community/libosinfo \
            extra/lm_sensors \
            core/logrotate \
            community/lsb-release \
            extra/lsof \
            core/lvm2 \
            core/mdadm \
            extra/parted \
            core/pciutils \
            core/procps-ng \
            core/psmisc \
            community/rng-tools \
            core/shadow \
            extra/smartmontools \
            extra/strace \
            core/sudo \
            extra/syslog-ng \
            community/sysstat \
            core/thin-provisioning-tools \
            community/tmux \
            core/tzdata \
            core/usbutils \
            community/xfsdump \
            core/xfsprogs

        # NETWORK OPERATOR
        pacman --sync --needed \
            extra/bind-tools \
            core/bridge-utils \
            core/ca-certificates{,-mozilla,-utils} \
            community/chrony \
            core/curl \
            core/dhcpcd \
            extra/dhclient \
            core/dnssec-anchors \
            community/dnstracer \
            extra/ethtool \
            extra/fping \
            extra/geoip{,-database{,-extra}} \
            core/inetutils \
            community/httpie \
            community/iperf3 \
            core/iproute2 \
            extra/ipset \
            core/iptables \
            core/iputils \
            community/ipvsadm \
            core/ldns \
            community/mosh \
            extra/mtr \
            core/net-tools \
            extra/gnu-netcat \
            extra/nftables \
            community/nikto \
            extra/nmap \
            extra/ntp \
            core/openssh \
            core/openssl \
            extra/publicsuffix-list \
            extra/rsync \
            extra/socat \
            community/sslscan \
            community/swaks \
            extra/tcpdump \
            community/testssl.sh \
            core/traceroute \
            extra/wget \
            extra/whois \
            core/wireless_tools \
            community/wireshark-cli \
            core/wpa_supplicant

        # PLT
        pacman --sync --needed \
            core/gcc \
            extra/gdb \
            extra/valgrind \
            extra/clang \
            extra/llvm \
            community/elixir \
            community/erlang-{docs,nox} \
            community/go \
            community/ghc \
            extra/jdk-openjdk \
            extra/openjdk-doc \
            extra/sbcl \
            community/nodejs \
            extra/ocaml \
            extra/php \
            extra/python{,-pip,-virtualenv} \
            extra/ruby{,-docs} \
            extra/rust{,-docs}

        # GAME
        pacman --sync --needed \
            community/cmatrix \
            extra/cowsay \
            community/fortune-mod \
            community/neofetch \
            community/screenfetch \
            community/sl

        # DevOps
        pacman --sync --needed \
            community/ansible{,-lint} \
            community/python-argcomplete \
            community/certbot \
            extra/dnsmasq \
            community/docker \
            extra/git \
            community/libvirt \
            extra/nginx \
            community/nginx-mod-auth-pam \
            community/oath-toolkit \
            core/pam \
            community/libpam-google-authenticator \
            extra/qemu-headless \
            community/salt \
            community/virt-install \
            community/wireguard-{dkms,tools}

        systemctl disable --now \
            dnsmasq.service \
            libvirt{d,-guests}.service \
            virtlogd.service \
            nginx.service \
            salt-{api,master,minion,syndic}.service

        systemctl enable --now \
            docker.service

        pacman --files --list \
            openssh \
            | awk --field-separator '[/ ]' '/usr\/lib\/systemd\/.+\/.+\..+[^/]$/ { printf "%-24s%s\n", $1, $NF }'

        pacman --query --owns /etc/bash.bashrc

        ;;
    fedora)

        # CORE
        dnf install \
            basesystem \
            filesystem \
            rootfiles \
            setup \
            glibc{,-devel} \
            kernel{,-devel,-headers} \
            linux-firmware \
            coreutils \
            util-linux \
            systemd \
            initscripts

        # SHELL
        dnf install \
            bash{,-completion,-doc} \
            zsh \
            man-{db,pages} \
            info \
            vim-enhanced \
            ShellCheck

        # UTIL
        dnf install \
            at \
            bc \
            binutils \
            bzip2 \
            cpio \
            diffutils \
            dos2unix \
            dosfstools \
            exa \
            file \
            findutils \
            finger \
            gawk{,-doc} \
            gnupg2 \
            grep \
            gzip \
            less \
            lynx \
            lz4 \
            lzop \
            moreutils \
            most \
            ncurses{,-base} \
            pandoc \
            parallel \
            pigz \
            python3-pygments \
            readline \
            sed \
            tar \
            time \
            tree \
            unzip \
            which \
            words \
            xz \
            zip \
            zstd

        # SYSADMIN
        dnf install \
            acl \
            btrfs-progs \
            cronie \
            crontabs \
            cryptsetup \
            dkms \
            dmidecode \
            device-mapper \
            e2fsprogs \
            exim \
            fakeroot \
            gdisk \
            haveged \
            hdparm \
            htop \
            dracut \
            irqbalance \
            keyutils \
            kmod \
            libosinfo \
            lm_sensors \
            logrotate \
            redhat-lsb \
            lsof \
            lvm2 \
            mdadm \
            numad \
            parted \
            pciutils \
            procps-ng \
            psmisc \
            rng-tools \
            passwd \
            shadow-utils \
            smartmontools \
            strace \
            sudo \
            rsyslog{,-doc} \
            syslog-ng \
            sysstat \
            device-mapper-persistent-data \
            tmux \
            tzdata \
            usbutils \
            xfsdump \
            xfsprogs

        # NETWORK OPERATOR
        dnf install \
            bind-utils \
            bridge-utils \
            ca-certificates \
            chrony \
            curl \
            dhcp-client \
            dnstracer \
            ethtool \
            fping \
            GeoIP{,-GeoLite-data{,-extra}} \
            hostname \
            httpie \
            iperf3 \
            iproute{,-doc} \
            ipset \
            iptables \
            iputils \
            ipvsadm \
            ldns-utils \
            mosh \
            mtr \
            net-tools \
            nmap-ncat \
            nftables \
            nikto \
            nmap \
            ntp{,-doc} \
            sntp \
            openssh{,-clients,-server} \
            openssl \
            publicsuffix-list \
            rsync \
            socat \
            sslscan \
            swaks \
            tcpdump \
            telnet \
            testssl \
            traceroute \
            wget \
            whois \
            wireless-tools \
            wireshark-cli \
            wpa_supplicant

        # PLT
        dnf install \
            gcc \
            cpp \
            gdb{-doc,-headless} \
            valgrind \
            gcc-c++ \
            clang \
            llvm{,-doc} \
            elixir{,-doc} \
            erlang{,-doc} \
            golang{,-docs,-src} \
            ghc \
            java-latest-openjdk{-headless,-javadoc} \
            sbcl \
            nodejs{,-docs} \
            ocaml{,-docs} \
            php \
            python3{,-docs,-pip,-virtualenv} \
            ruby{,-doc} \
            rust{,-doc,-src} \
            cargo{,-doc}

        # GAME
        dnf install \
            cmatrix \
            cowsay \
            fortune-mod \
            neofetch \
            screenfetch \
            sl

        # DevOps
        dnf install \
            ansible{,-doc} \
            python3-argcomplete \
            certbot \
            dnsmasq \
            git \
            libguestfs-tools \
            libvirt \
            nginx \
            oathtool \
            pam \
            qemu-{img,system-x86} \
            salt{,-{api,cloud,master,minion,ssh,syndic}} \
            virt-install \
            wireguard-{dkms,tools}

        ## docker [official]
        dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        ## docker [tsinghua]
        dnf config-manager --add-repo https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/fedora/docker-ce.repo
        dnf makecache
        dnf install docker-ce
        dnf clean packages

        systemctl disable --now \
            dnsmasq.service \
            libvirt{d,-guests}.service \
            virtlogd.service \
            nginx.service \
            salt-{api,master,minion,syndic}.service

        systemctl enable --now \
            docker.service

        rpm --query \
            openssh-server \
            --list \
            | awk --field-separator '[/ ]' '/\/lib\/systemd\/.+\/.+\..+/ { printf "%s\n", $NF }'

        rpm --query --file /etc/bashrc

        ;;
    kali)

        # CORE
        apt install \
            base-{files,passwd} \
            netbase \
            libc{6,6-dev,-bin,-dev-bin} \
            glibc-doc \
            linux-{doc,headers-amd64,image-amd64} \
            firmware-linux \
            coreutils \
            util-linux \
            bsdutils \
            systemd{,-sysv} \
            init-system-helpers

        # SHELL
        apt install \
            bash{,-completion,-doc} \
            zsh{,-doc} \
            manpages{,-dev} \
            info \
            vim{,-doc} \
            shellcheck

        # UTIL
        apt install \
            at \
            bc \
            binutils{,-doc} \
            bzip2 \
            cpio{,-doc} \
            diffutils{,-doc} \
            dos2unix \
            dosfstools \
            file \
            findutils \
            finger \
            gawk{,-doc} \
            gnupg{,-utils} \
            grep \
            gzip \
            less \
            lynx \
            lz4 \
            lzop \
            moreutils \
            most \
            ncurses-{base,bin,doc} \
            pandoc \
            parallel \
            pigz \
            python3-pygments \
            readline-{common,doc} \
            sed \
            tar \
            time \
            tree \
            unzip \
            debianutils \
            dictionaries-common \
            wamerican \
            xz-utils \
            zip \
            zstd

        # SYSADMIN
        apt install \
            acl \
            btrfs-progs \
            cron \
            cryptsetup-{initramfs,run} \
            dkms \
            dmidecode \
            dmsetup \
            e2fsprogs \
            exim4-daemon-light \
            fakeroot \
            gdisk \
            haveged \
            hdparm \
            htop \
            initramfs-tools \
            irqbalance \
            keyutils \
            kmod \
            libosinfo-bin \
            lm-sensors \
            logrotate \
            lsb-release \
            lsof \
            lvm2 \
            mdadm \
            numad \
            parted{,-doc} \
            pciutils \
            procps \
            sysvinit-utils \
            psmisc \
            rng-tools \
            login \
            passwd \
            smartmontools \
            strace \
            sudo \
            rsyslog{,-doc} \
            syslog-ng \
            sysstat \
            thin-provisioning-tools \
            tmux \
            tzdata \
            usbutils \
            xfsdump \
            xfsprogs

        # NETWORK OPERATOR
        apt install \
            bind9-host \
            dnsutils \
            bridge-utils \
            ca-certificates \
            chrony \
            curl \
            isc-dhcp-client \
            dns-root-data \
            dnstracer \
            ethtool \
            fping \
            geoip-{bin,database} \
            hostname \
            httpie \
            iperf3 \
            iproute2{,-doc} \
            ipset \
            iptables \
            iputils-{arping,ping,tracepath} \
            ipvsadm \
            ldnsutils \
            mosh \
            mtr-tiny \
            net-tools \
            netcat-openbsd \
            nftables \
            nikto \
            nmap \
            ntp{,-doc} \
            sntp \
            openssh-{client,server,sftp-server} \
            openssl \
            publicsuffix \
            rsync \
            socat \
            sslscan \
            swaks \
            tcpdump \
            telnet \
            testssl.sh \
            traceroute \
            wget \
            whois \
            wireless-tools \
            wireshark{,-doc} \
            wpasupplicant

        # PLT
        apt install \
            gcc{,-doc} \
            cpp{,-doc} \
            gdb{,-doc} \
            valgrind \
            g++ \
            clang{,-8-doc,-format} \
            llvm{,-8-doc} \
            elixir \
            erlang-{doc,nox} \
            golang{,-doc,-src} \
            ghc{,-doc} \
            default-jdk-{doc,headless} \
            sbcl{,-doc} \
            nodejs{,-doc} \
            ocaml-{doc,nox} \
            php \
            python3{,-doc,-pip,-virtualenv} \
            ruby{,2.5-doc} \
            rust{c,-doc,-src} \
            cargo{,-doc}

        # GAME
        apt install \
            cmatrix \
            cowsay \
            fortunes \
            neofetch \
            screenfetch \
            sl

        # DevOps
        apt install \
            ansible{,-lint} \
            python3-argcomplete \
            certbot \
            python-certbot-doc \
            dnsmasq \
            git{,-doc} \
            libguestfs-tools \
            libvirt-{clients,daemon-system} \
            nginx-{doc,full} \
            libnginx-mod-http-{auth-pam,lua} \
            oathtool \
            libpam-{doc,google-authenticator,modules{,-bin}} \
            qemu-{system-x86,utils} \
            virtinst \
            wireguard

        curl --fail --location --silent --show-error 'https://download.docker.com/linux/debian/gpg' | apt-key add -
        rm --force --recursive /etc/apt/trusted.gpg~
        ## docker [official]
        tee /etc/apt/sources.list.d/docker.list << 'EOF'
deb [arch=amd64] https://download.docker.com/linux/debian buster stable
EOF
        ## docker [tsinghua]
        tee /etc/apt/sources.list.d/docker.list << 'EOF'
deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian buster stable
EOF
        apt update --list-cleanup
        apt install docker-ce

        curl --fail --location --silent --show-error 'https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub' | apt-key add -
        rm --force --recursive /etc/apt/trusted.gpg~
        ## saltstack [official]
        tee /etc/apt/sources.list.d/saltstack.list << 'EOF'
deb [arch=amd64] https://repo.saltstack.com/apt/debian/9/amd64/latest stretch main
EOF
        ## saltstack [tsinghua]
        tee /etc/apt/sources.list.d/saltstack.list << 'EOF'
deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/saltstack/apt/debian/9/amd64/latest stretch main
EOF
        apt update --list-cleanup
        apt install salt-{api,cloud,master,minion,ssh,syndic}

        systemctl disable --now \
            dnsmasq.service \
            libvirt{d,-guests}.service \
            virtlogd.service \
            nginx.service \
            salt-{api,master,minion,syndic}.service

        systemctl enable --now \
            docker.service

        dpkg --listfiles \
            openssh-server \
            | awk --field-separator '[/ ]' '/\/lib\/systemd\/.+\/.+\..+/ { printf "%s\n", $NF }'

        dpkg --search /etc/bash.bashrc

        ;;
    manjaro)

        # CORE
        pacman --sync --needed \
            core/filesystem \
            core/iana-etc \
            core/glibc \
            core/linux{,-api-headers,-firmware,-headers} \
            core/coreutils \
            core/util-linux \
            core/systemd{,-sysvcompat}

        # SHELL
        pacman --sync --needed \
            core/bash \
            extra/bash-completion \
            extra/zsh{,-doc} \
            core/man-pages \
            core/texinfo \
            extra/vim \
            community/shellcheck

        # UTIL
        pacman --sync --needed \
            community/at \
            extra/bc \
            core/binutils \
            core/bzip2 \
            extra/cpio \
            core/diffutils \
            community/dos2unix \
            core/dosfstools \
            community/exa \
            core/file \
            core/findutils \
            core/gawk \
            core/gnupg \
            core/grep \
            core/gzip \
            core/less \
            extra/lynx \
            core/lz4 \
            extra/lzop \
            community/moreutils \
            extra/most \
            core/ncurses \
            community/pandoc \
            community/parallel \
            community/pigz \
            community/pygmentize \
            core/readline \
            core/sed \
            core/tar \
            extra/time \
            extra/tree \
            extra/unzip \
            core/which \
            community/words \
            core/xz \
            extra/zip \
            core/zstd

        # SYSADMIN
        pacman --sync --needed \
            core/acl \
            core/btrfs-progs \
            core/cronie \
            core/cryptsetup \
            extra/dkms \
            extra/dmidecode \
            core/device-mapper \
            core/e2fsprogs \
            community/exim \
            core/fakeroot \
            extra/gptfdisk \
            extra/haveged \
            core/hdparm \
            extra/htop \
            core/mkinitcpio{,-busybox} \
            extra/irqbalance \
            core/keyutils \
            core/kmod \
            community/libosinfo \
            extra/lm_sensors \
            core/logrotate \
            core/lsb-release \
            extra/lsof \
            core/lvm2 \
            core/mdadm \
            extra/parted \
            core/pciutils \
            core/procps-ng \
            core/psmisc \
            community/rng-tools \
            core/shadow \
            extra/smartmontools \
            extra/strace \
            core/sudo \
            extra/syslog-ng \
            community/sysstat \
            core/thin-provisioning-tools \
            community/tmux \
            core/tzdata \
            core/usbutils \
            community/xfsdump \
            core/xfsprogs

        # NETWORK OPERATOR
        pacman --sync --needed \
            extra/bind-tools \
            core/bridge-utils \
            core/ca-certificates{,-mozilla,-utils} \
            community/chrony \
            core/curl \
            core/dhcpcd \
            extra/dhclient \
            core/dnssec-anchors \
            community/dnstracer \
            extra/ethtool \
            extra/fping \
            extra/geoip{,-database{,-extra}} \
            core/inetutils \
            community/httpie \
            community/iperf3 \
            core/iproute2 \
            extra/ipset \
            core/iptables \
            core/iputils \
            community/ipvsadm \
            core/ldns \
            community/mosh \
            extra/mtr \
            core/net-tools \
            extra/gnu-netcat \
            extra/nftables \
            community/nikto \
            extra/nmap \
            extra/ntp \
            core/openssh \
            core/openssl \
            extra/publicsuffix-list \
            extra/rsync \
            extra/socat \
            community/sslscan \
            community/swaks \
            extra/tcpdump \
            community/testssl.sh \
            core/traceroute \
            extra/wget \
            extra/whois \
            core/wireless_tools \
            community/wireshark-cli \
            core/wpa_supplicant

        # PLT
        pacman --sync --needed \
            core/gcc \
            extra/gdb \
            extra/valgrind \
            extra/clang \
            extra/llvm \
            community/elixir \
            community/erlang-{docs,nox} \
            community/go \
            community/ghc \
            extra/jdk-openjdk \
            extra/openjdk-doc \
            extra/sbcl \
            community/nodejs \
            extra/ocaml \
            extra/php \
            extra/python{,-pip,-virtualenv} \
            extra/ruby{,-docs} \
            extra/rust{,-docs}

        # GAME
        pacman --sync --needed \
            community/cmatrix \
            extra/cowsay \
            community/fortune-mod \
            community/neofetch \
            community/screenfetch \
            community/sl

        # DevOps
        pacman --sync --needed \
            community/ansible{,-lint} \
            community/python-argcomplete \
            community/certbot \
            extra/dnsmasq \
            community/docker \
            extra/git \
            community/libvirt \
            extra/nginx \
            community/nginx-mod-auth-pam \
            community/oath-toolkit \
            core/pam \
            community/libpam-google-authenticator \
            extra/qemu-headless \
            community/salt \
            community/virt-install \
            community/wireguard-{dkms,tools}

        systemctl disable --now \
            dnsmasq.service \
            libvirt{d,-guests}.service \
            virtlogd.service \
            nginx.service \
            salt-{api,master,minion,syndic}.service

        systemctl enable --now \
            docker.service

        pacman --files --list \
            openssh \
            | awk --field-separator '[/ ]' '/usr\/lib\/systemd\/.+\/.+\..+[^/]$/ { printf "%-24s%s\n", $1, $NF }'

        pacman --query --owns /etc/bash.bashrc

        ;;
    opensuse*)

        # CORE
        zypper install \
            aaa_base{,-extras} \
            filesystem \
            openSUSE-release \
            glibc{,-devel} \
            kernel-{default{,-devel},devel,docs} \
            kernel-firmware-all \
            coreutils \
            util-linux \
            systemd{,-sysvinit}

        # SHELL
        zypper install \
            bash{,-completion,-doc} \
            zsh \
            man{,-pages} \
            info \
            vim \
            ShellCheck

        # UTIL
        zypper install \
            at \
            bc \
            binutils \
            bzip2 \
            cpio \
            diffutils \
            dos2unix \
            dosfstools \
            exa \
            file \
            findutils \
            finger \
            gawk \
            gpg2 \
            grep \
            gzip \
            less \
            lynx \
            lz4 \
            lzop \
            moreutils \
            most \
            ncurses-{devel,utils} \
            pandoc \
            gnu_parallel \
            pigz \
            python3-Pygments \
            libreadline8 \
            readline-doc \
            sed \
            tar \
            time \
            tree \
            unzip \
            which \
            words \
            xz \
            zip \
            zstd

        # SYSADMIN
        zypper install \
            acl \
            btrfsprogs \
            cron \
            cronie \
            cryptsetup \
            dkms \
            dmidecode \
            device-mapper \
            e2fsprogs \
            exim \
            fakeroot \
            gptfdisk \
            haveged \
            hdparm \
            htop \
            dracut \
            irqbalance \
            keyutils \
            kmod \
            libosinfo \
            sensors \
            logrotate \
            lsb-release \
            lsof \
            lvm2 \
            mdadm \
            numad \
            parted \
            pciutils \
            procps \
            psmisc \
            rng-tools \
            shadow \
            smartmontools \
            strace \
            sudo \
            rsyslog{,-doc} \
            syslog-ng \
            sysstat \
            thin-provisioning-tools \
            tmux \
            timezone \
            usbutils \
            xfsdump \
            xfsprogs

        # NETWORK OPERATOR
        zypper install \
            bind-utils \
            bridge-utils \
            ca-certificates{,-mozilla} \
            chrony \
            curl \
            dhcp-client \
            dnstracer \
            ethtool \
            fping \
            GeoIP{,-data} \
            hostname \
            python3-httpie \
            iperf \
            iproute2 \
            ipset \
            iptables \
            iputils \
            ipvsadm \
            ldns \
            mosh \
            mtr \
            net-tools \
            netcat-openbsd \
            nftables \
            nikto \
            nmap \
            ntp{,-doc} \
            openssh \
            openssl \
            publicsuffix \
            rsync \
            socat \
            sslscan \
            swaks \
            tcpdump \
            telnet \
            traceroute \
            wget \
            whois \
            wireless-tools \
            wireshark \
            wpa_supplicant

        # PLT
        zypper install \
            gcc{,-info} \
            cpp \
            gdb \
            valgrind \
            gcc-c++ \
            clang \
            llvm{,9-doc} \
            elixir{,-doc} \
            erlang{,-doc} \
            go{,-doc} \
            ghc \
            java-13-openjdk{-headless,-javadoc} \
            sbcl \
            nodejs12{,-docs} \
            ocaml \
            php7 \
            python3{,-doc,-pip,-virtualenv} \
            ruby{,2.6-doc} \
            rust{,-doc,-src} \
            cargo{,-doc}

        # GAME
        zypper install \
            cmatrix \
            cowsay \
            fortune \
            neofetch \
            screenfetch \
            sl

        # DevOps
        zypper install \
            ansible{,-doc} \
            python3-argcomplete \
            python3-certbot \
            dnsmasq \
            git{,-doc} \
            libguestfs0 \
            libvirt \
            nginx \
            oath-toolkit \
            pam \
            qemu-{tools,x86} \
            salt{,-{api,cloud,master,minion,ssh,syndic}} \
            virt-install \
            wireguard-{kmp-default,tools}

        zypper install docker
        zypper clean

        systemctl disable --now \
            dnsmasq.service \
            libvirt{d,-guests}.service \
            virtlogd.service \
            nginx.service \
            salt-{api,master,minion,syndic}.service

        systemctl enable --now \
            docker.service

        rpm --query \
            openssh \
            --list \
            | awk --field-separator '[/ ]' '/\/lib\/systemd\/.+\/.+\..+/ { printf "%s\n", $NF }'

        rpm --query --file /etc/bash.bashrc

        ;;
    ubuntu)

        # CORE
        apt install \
            base-{files,passwd} \
            netbase \
            libc{6,6-dev,-bin,-dev-bin} \
            glibc-doc \
            linux-{doc,firmware,headers-generic,image-generic} \
            coreutils \
            util-linux \
            bsdutils \
            systemd{,-sysv} \
            init-system-helpers

        # SHELL
        apt install \
            bash{,-completion,-doc} \
            zsh{,-doc} \
            manpages{,-dev} \
            info \
            vim{,-doc} \
            shellcheck

        # UTIL
        apt install \
            at \
            bc \
            binutils{,-doc} \
            bzip2 \
            cpio{,-doc} \
            diffutils{,-doc} \
            dos2unix \
            dosfstools \
            file \
            findutils \
            finger \
            gawk{,-doc} \
            gnupg{,-utils} \
            grep \
            gzip \
            less \
            lynx \
            liblz4-tool \
            lzop \
            moreutils \
            most \
            ncurses-{base,bin,doc} \
            pandoc \
            parallel \
            pigz \
            python3-pygments \
            readline-{common,doc} \
            sed \
            tar \
            time \
            tree \
            unzip \
            debianutils \
            dictionaries-common \
            wamerican \
            xz-utils \
            zip \
            zstd

        # SYSADMIN
        apt install \
            acl \
            btrfs-progs \
            cron \
            cryptsetup{,-bin} \
            dkms \
            dmidecode \
            dmsetup \
            e2fsprogs \
            exim4-daemon-light \
            fakeroot \
            gdisk \
            haveged \
            hdparm \
            htop \
            initramfs-tools \
            irqbalance \
            keyutils \
            kmod \
            libosinfo-bin \
            lm-sensors \
            logrotate \
            lsb-release \
            lsof \
            lvm2 \
            mdadm \
            numad \
            parted{,-doc} \
            pciutils \
            procps \
            sysvinit-utils \
            psmisc \
            rng-tools \
            login \
            passwd \
            smartmontools \
            strace \
            sudo \
            rsyslog{,-doc} \
            syslog-ng \
            sysstat \
            thin-provisioning-tools \
            tmux \
            tzdata \
            usbutils \
            xfsdump \
            xfsprogs

        # NETWORK OPERATOR
        apt install \
            bind9-host \
            dnsutils \
            bridge-utils \
            ca-certificates \
            chrony \
            curl \
            isc-dhcp-client \
            dns-root-data \
            dnstracer \
            ethtool \
            fping \
            geoip-{bin,database{,-extra}} \
            hostname \
            httpie \
            iperf3 \
            iproute2{,-doc} \
            ipset \
            iptables \
            iputils-{arping,ping,tracepath} \
            ipvsadm \
            ldnsutils \
            mosh \
            mtr-tiny \
            net-tools \
            netcat-openbsd \
            nftables \
            nikto \
            nmap \
            ntp{,-doc} \
            sntp \
            openssh-{client,server,sftp-server} \
            openssl \
            publicsuffix \
            rsync \
            socat \
            sslscan \
            swaks \
            tcpdump \
            telnet \
            testssl.sh \
            traceroute \
            wget \
            whois \
            wireless-tools \
            wireshark{,-doc} \
            wpasupplicant

        # PLT
        apt install \
            gcc{,-doc} \
            cpp{,-doc} \
            gdb{,-doc} \
            valgrind \
            g++ \
            clang{,-6.0-doc,-format} \
            llvm{,-6.0-doc} \
            elixir \
            erlang-{doc,nox} \
            golang{,-doc,-src} \
            ghc{,-doc} \
            default-jdk-{doc,headless} \
            sbcl{,-doc} \
            nodejs{,-doc} \
            ocaml-{doc,nox} \
            php \
            python3{,-doc,-pip,-virtualenv} \
            ruby{,2.5-doc} \
            rust{c,-doc,-src} \
            cargo{,-doc}

        # GAME
        apt install \
            cmatrix \
            cowsay \
            fortunes \
            neofetch \
            screenfetch \
            sl

        # DevOps
        apt install \
            ansible{,-lint} \
            python3-argcomplete \
            certbot \
            dnsmasq \
            python-certbot-doc \
            git{,-doc} \
            libguestfs-tools \
            libvirt-{clients,daemon-system} \
            nginx-{doc,full} \
            libnginx-mod-http-{auth-pam,lua} \
            oathtool \
            libpam-{doc,google-authenticator,modules{,-bin}} \
            qemu-{system-x86,utils} \
            virtinst \
            wireguard

        curl --fail --location --silent --show-error 'https://download.docker.com/linux/ubuntu/gpg' | apt-key add -
        rm --force --recursive /etc/apt/trusted.gpg~
        ## docker [official]
        tee /etc/apt/sources.list.d/docker.list << 'EOF'
deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable
EOF
        ## docker [tsinghua]
        tee /etc/apt/sources.list.d/docker.list << 'EOF'
deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu bionic stable
EOF
        apt update --list-cleanup
        apt install docker-ce

        curl --fail --location --silent --show-error 'https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub' | apt-key add -
        rm --force --recursive /etc/apt/trusted.gpg~
        ## saltstack [official]
        tee /etc/apt/sources.list.d/saltstack.list << 'EOF'
deb [arch=amd64] https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest bionic main
EOF
        ## saltstack [tsinghua]
        tee /etc/apt/sources.list.d/saltstack.list << 'EOF'
deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/saltstack/apt/ubuntu/18.04/amd64/latest bionic main
EOF
        apt update --list-cleanup
        apt install salt-{api,cloud,master,minion,ssh,syndic}

        systemctl disable --now \
            dnsmasq.service \
            libvirt{d,-guests}.service \
            virtlogd.service \
            nginx.service \
            qemu-kvm.service \
            salt-{api,master,minion,syndic}.service

        systemctl enable --now \
            docker.service

        dpkg --listfiles \
            openssh-server \
            | awk --field-separator '[/ ]' '/\/lib\/systemd\/.+\/.+\..+/ { printf "%s\n", $NF }'

        dpkg --search /etc/bash.bashrc

            ;;
    *)
        echo "✗ unknown distro: ‘${DISTRO}’" 1>&2
        exit 1
        ;;
esac

## Docker

tee /etc/docker/daemon.json << 'EOF'
{
    "log-driver": "json-file",
    "log-opts": {
        "max-file": "10",
        "max-size": "10m"
    }
}
EOF

systemctl restart docker.service

# systemd system and service

systemd-detect-virt
systemctl get-default

systemd-analyze blame --no-pager
systemd-analyze critical-chain --no-pager
systemd-analyze security --no-pager

systemctl list-units --no-pager --type service
systemctl list-units --no-pager --type socket
systemctl list-units --no-pager --type timer
systemctl list-jobs --no-pager
