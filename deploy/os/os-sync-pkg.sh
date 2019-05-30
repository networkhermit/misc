#!/bin/bash

if (( EUID != 0 )); then
    echo "✗ This script must be run as root" 1>&2
    exit 1
fi

if [ "${OSTYPE}" != 'linux-gnu' ]; then
    echo "✗ unknown os type: ‘${OSTYPE}’" 1>&2
    exit 1
fi

DISTRO=$(awk --field-separator '=' '/^ID=/ { print $2; exit }' /etc/os-release)

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
#       binutils
#       bzip2
#       diffutils
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
#       cronie
#       cryptsetup
#       dkms
#       e2fsprogs
#       exim
#       fakeroot
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
#       parted
#       pciutils
#       procps
#       psmisc
#       shadow
#       strace
#       sudo
#       sysstat
#       thin-provisioning-tools
#       tmux
#       tzdata
#       usbutils
#       xfsprogs
##################

##################
# NETWORK OPERATOR
#       bind-tools
#       bridge-utils
#       ca-certificates
#       curl
#       dhcp-client
#       dns-root-data
#       dnstracer
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
#       rsync
#       socat
#       sslscan
#       swaks
#       tcpdump
#       testssl.sh
#       traceroute
#       wget
#       whois
#       wireguard
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
#       qemu-utils
#       salt
#       virtinst
##################

case "${DISTRO}" in
    arch)

        # CORE
        pacman --sync --needed \
            core/filesystem \
            core/iana-etc \
            core/glibc \
            core/linux{,-api-headers,-headers,-docs,-firmware} \
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
            core/binutils \
            core/bzip2 \
            core/diffutils \
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
            core/cronie \
            core/cryptsetup \
            extra/dkms \
            core/e2fsprogs \
            community/exim \
            core/fakeroot \
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
            core/shadow \
            extra/strace \
            core/sudo \
            community/sysstat \
            core/thin-provisioning-tools \
            community/tmux \
            core/tzdata \
            core/usbutils \
            core/xfsprogs

        # NETWORK OPERATOR
        pacman --sync --needed \
            extra/bind-tools \
            core/bridge-utils \
            core/ca-certificates{,-mozilla,-utils} \
            core/curl \
            core/dhcpcd \
            extra/dhclient \
            core/dnssec-anchors \
            community/dnstracer \
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
            extra/rsync \
            extra/socat \
            community/sslscan \
            community/swaks \
            extra/tcpdump \
            community/testssl.sh \
            core/traceroute \
            extra/wget \
            extra/whois \
            community/wireguard-{dkms,tools}

        # PLT
        pacman --sync --needed \
            core/gcc \
            extra/gdb \
            extra/valgrind \
            extra/clang \
            extra/llvm \
            community/elixir \
            community/erlang-{nox,docs} \
            community/go \
            community/ghc \
            extra/jdk10-openjdk \
            extra/openjdk10-doc \
            extra/sbcl \
            community/nodejs \
            extra/ocaml \
            extra/php \
            extra/python{,-pip,-virtualenv} \
            extra/ruby{,-docs} \
            community/rust{,-docs}

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
            community/virt-install

        systemctl disable --now \
            dnsmasq.service \
            libvirt{d,-guests}.service \
            nginx.service \
            qemu-kvm.service \
            salt-{api,master,minion,syndic}.service

        systemctl enable --now \
            docker.service

        pacman --files --list \
            openssh \
            | awk --field-separator '[/ ]' '/usr\/lib\/systemd\/.*\/.*\..*/ { printf "%-24s%s\n", $1, $NF }'

        ;;
    fedora)

        # DevOps

        ## docker [official]
        dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        ## docker [tsinghua]
        dnf config-manager --add-repo https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/fedora/docker-ce.repo
        dnf makecache
        dnf install docker-ce
        dnf clean packages

        systemctl enable --now \
            docker.service

        ;;
    kali)

        # CORE
        apt install \
            base-{files,passwd} \
            netbase \
            libc{6,6-dev,-bin,-dev-bin} \
            glibc-doc \
            linux-{image-amd64,headers-amd64,doc} \
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
            binutils{,-doc} \
            bzip2 \
            diffutils{,-doc} \
            dosfstools \
            exa \
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
            cron \
            cryptsetup-{run,initramfs} \
            dkms \
            e2fsprogs \
            exim4-daemon-light \
            fakeroot \
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
            parted{,-doc} \
            pciutils \
            procps \
            sysvinit-utils \
            psmisc \
            login \
            passwd \
            strace \
            sudo \
            sysstat \
            thin-provisioning-tools \
            tmux \
            tzdata \
            usbutils \
            xfsprogs

        # NETWORK OPERATOR
        apt install \
            bind9-host \
            dnsutils \
            bridge-utils \
            ca-certificates \
            curl \
            isc-dhcp-client \
            dns-root-data \
            dnstracer \
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
            openssh-{client,server,sftp-server} \
            openssl \
            rsync \
            socat \
            sslscan \
            swaks \
            tcpdump \
            testssl.sh \
            traceroute \
            wget \
            whois \
            wireguard

        # PLT
        apt install \
            gcc{,-doc} \
            cpp{,-doc} \
            gdb{,-doc} \
            valgrind \
            g++ \
            clang{,-format,-6.0-doc} \
            llvm{,-6.0-doc} \
            elixir \
            erlang-{nox,doc} \
            golang{,-doc,-src} \
            ghc{,-doc} \
            default-jdk-{headless,doc} \
            sbcl{,-doc} \
            nodejs{,-doc} \
            ocaml-{nox,doc} \
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
            certbot \
            python-certbot-doc \
            dnsmasq \
            git{,-doc} \
            libguestfs-tools \
            libvirt-{clients,daemon-system} \
            nginx-{full,doc} \
            libnginx-mod-http-{auth-pam,lua} \
            oathtool \
            libpam-{modules{,-bin},doc,google-authenticator} \
            qemu-utils \
            virtinst

        curl --location 'https://download.docker.com/linux/debian/gpg' | apt-key add -
        rm --force --recursive /etc/apt/trusted.gpg~
        ## docker [official]
        tee /etc/apt/sources.list.d/docker.list << 'EOF'
deb [arch=amd64] https://download.docker.com/linux/debian stretch stable
EOF
        ## docker [tsinghua]
        tee /etc/apt/sources.list.d/docker.list << 'EOF'
deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian stretch stable
EOF
        apt update --list-cleanup
        apt install docker-ce

        curl --location 'https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub' | apt-key add -
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
            nginx.service \
            qemu-kvm.service \
            salt-{api,master,minion,syndic}.service

        systemctl enable --now \
            docker.service

        dpkg --listfiles \
            openssh-server \
            | awk --field-separator '[/ ]' '/\/lib\/systemd\/.*\/.*\..*/ { printf "%s\n", $NF }'

        ;;
    ubuntu)

        # CORE
        apt install \
            base-{files,passwd} \
            netbase \
            libc{6,6-dev,-bin,-dev-bin} \
            glibc-doc \
            linux-{image-generic,headers-generic,doc,firmware} \
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
            binutils{,-doc} \
            bzip2 \
            diffutils{,-doc} \
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
            cron \
            cryptsetup-{run,initramfs} \
            dkms \
            e2fsprogs \
            exim4-daemon-light \
            fakeroot \
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
            parted{,-doc} \
            pciutils \
            procps \
            sysvinit-utils \
            psmisc \
            login \
            passwd \
            strace \
            sudo \
            sysstat \
            thin-provisioning-tools \
            tmux \
            tzdata \
            usbutils \
            xfsprogs

        # NETWORK OPERATOR
        apt install \
            bind9-host \
            dnsutils \
            bridge-utils \
            ca-certificates \
            curl \
            isc-dhcp-client \
            dns-root-data \
            dnstracer \
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
            openssh-{client,server,sftp-server} \
            openssl \
            rsync \
            socat \
            sslscan \
            swaks \
            tcpdump \
            testssl.sh \
            traceroute \
            wget \
            whois \
            wireguard

        # PLT
        apt install \
            gcc{,-doc} \
            cpp{,-doc} \
            gdb{,-doc} \
            valgrind \
            g++ \
            clang{,-format,-6.0-doc} \
            llvm{,-6.0-doc} \
            elixir \
            erlang-{nox,doc} \
            golang{,-doc,-src} \
            ghc{,-doc} \
            default-jdk-{headless,doc} \
            sbcl{,-doc} \
            nodejs{,-doc} \
            ocaml-{nox,doc} \
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
            certbot \
            dnsmasq \
            python-certbot-doc \
            git{,-doc} \
            libguestfs-tools \
            libvirt-{clients,daemon-system} \
            nginx-{full,doc} \
            libnginx-mod-http-{auth-pam,lua} \
            oathtool \
            libpam-{modules{,-bin},doc,google-authenticator} \
            qemu-utils \
            virtinst

        curl --location 'https://download.docker.com/linux/ubuntu/gpg' | apt-key add -
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

        curl --location 'https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub' | apt-key add -
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
            nginx.service \
            qemu-kvm.service \
            salt-{api,master,minion,syndic}.service

        systemctl enable --now \
            docker.service

        dpkg --listfiles \
            openssh-server \
            | awk --field-separator '[/ ]' '/\/lib\/systemd\/.*\/.*\..*/ { printf "%s\n", $NF }'

            ;;
    *)
        echo "✗ unknown distro: ‘${DISTRO}’" 1>&2
        exit 1
        ;;
esac

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
