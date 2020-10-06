#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

trap 'echo ✗ fatal error: errexit trapped with status $? 1>&2' ERR

if (( EUID != 0 )); then
    echo '✗ This script must be run as root' 1>&2
    exit 1
fi

while (( $# > 0 )); do
    case ${1} in
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
#       emacs
#       \shellcheck
##################

##################
# UTIL
#       at
#       bat
#       bc
#       binutils
#       bzip2
#       colordiff
#       cpio
#       diffutils
#       dos2unix
#       dosfstools
#       exa
#       fd
#       file
#       findutils
#       finger
#       fzf
#       gawk
#       gnupg
#       grep
#       gzip
#       hexyl
#       hyperfine
#       jq
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
#       qrencode
#       readline
#       ripgrep
#       sed
#       tar
#       the_silver_searcher
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
#       borg
#       btrfs-progs
#       cronie
#       cryptsetup
#       device-mapper
#       dkms
#       dmidecode
#       e2fsprogs
#       exim
#       fakeroot
#       glances
#       gptfdisk
#       haveged
#       hdparm
#       htop
#       initramfs-tools
#       iotop
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
#       ncdu
#       numad
#       parted
#       pciutils
#       procps
#       psmisc
#       restic
#       rng-tools
#       shadow
#       smartmontools
#       strace
#       sudo
#       sysdig
#       syslogd
#       sysstat
#       systemtap
#       thin-provisioning-tools
#       tmux
#       tzdata
#       usbutils
#       xfsdump
#       xfsprogs
##################

##################
# NETWORK OPERATOR
#       ab
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
#       goaccess
#       hostname
#       httpie
#       iftop
#       iperf3
#       iproute2
#       ipset
#       iptables-nft
#       iputils
#       ipvsadm
#       ldnsutils
#       mitmproxy
#       mosh
#       mtr
#       net-tools
#       netcat
#       nethogs
#       netsniff-ng
#       nftables
#       ngrep
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
#       wrk
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
#       caddy
#       certbot
#       dnsmasq
#       docker
#       git
#       libguestfs-tools
#       libvirt
#       nginx
#       oathtool
#       osquery
#       pam
#       qemu
#       salt
#       tig
#       virtinst
#       wireguard
##################

case ${DISTRO} in
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
        core/man-{db,pages} \
        core/texinfo \
        extra/vim \
        extra/emacs \
        community/shellcheck

    # UTIL
    pacman --sync --needed \
        community/at \
        community/bat \
        extra/bc \
        core/binutils \
        core/bzip2 \
        community/colordiff \
        extra/cpio \
        core/diffutils \
        community/dos2unix \
        core/dosfstools \
        community/exa \
        community/fd \
        core/file \
        core/findutils \
        community/fzf \
        core/gawk \
        core/gnupg \
        core/grep \
        core/gzip \
        community/hexyl \
        community/hyperfine \
        community/jq \
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
        community/python-pygments \
        extra/qrencode \
        core/readline \
        community/ripgrep \
        core/sed \
        core/tar \
        community/the_silver_searcher \
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
        community/borg \
        core/btrfs-progs \
        core/cronie \
        core/cryptsetup \
        core/device-mapper \
        extra/dkms \
        extra/dmidecode \
        core/e2fsprogs \
        community/exim \
        core/fakeroot \
        community/glances \
        extra/gptfdisk \
        extra/haveged \
        core/hdparm \
        extra/htop \
        core/mkinitcpio{,-busybox} \
        community/iotop \
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
        community/ncdu \
        extra/parted \
        core/pciutils \
        core/procps-ng \
        core/psmisc \
        community/restic \
        community/rng-tools \
        core/shadow \
        extra/smartmontools \
        extra/strace \
        core/sudo \
        community/sysdig \
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
        extra/apache \
        extra/bind \
        extra/bridge-utils \
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
        community/goaccess \
        core/inetutils \
        community/httpie \
        community/iftop \
        community/iperf3 \
        core/iproute2 \
        extra/ipset \
        core/iptables-nft \
        core/iputils \
        community/ipvsadm \
        core/ldns \
        community/mitmproxy \
        community/mosh \
        extra/mtr \
        core/net-tools \
        community/openbsd-netcat \
        community/nethogs \
        community/netsniff-ng \
        extra/nftables \
        community/ngrep \
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
        core/wpa_supplicant \
        community/wrk

    # PLT
    pacman --sync --needed \
        core/gcc \
        extra/gdb \
        extra/valgrind \
        extra/clang \
        extra/llvm \
        extra/lld \
        extra/lldb \
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
        community/osquery \
        core/pam \
        community/libpam-google-authenticator \
        extra/qemu-headless \
        community/salt \
        community/tig \
        community/virt-install \
        extra/wireguard-{dkms,tools}

    systemctl disable --now \
        dnsmasq.service \
        libvirt{d,-guests}.service \
        virtlogd.service \
        nginx.service \
        salt-{api,master,minion,syndic}.service

    systemctl enable --now \
        docker.service \
        osqueryd.service

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
        kernel{,-core,-devel,-headers} \
        linux-firmware \
        coreutils \
        util-linux \
        systemd \
        chkconfig \
        initscripts

    # SHELL
    dnf install \
        bash{,-completion,-doc} \
        zsh \
        man-{db,pages} \
        info \
        vim-enhanced \
        emacs \
        ShellCheck

    # UTIL
    dnf install \
        at \
        bat \
        bc \
        binutils \
        bzip2 \
        colordiff \
        cpio \
        diffutils \
        dos2unix \
        dosfstools \
        exa \
        fd-find \
        file \
        findutils \
        finger \
        fzf \
        gawk{,-doc} \
        gnupg2 \
        grep \
        gzip \
        hexyl \
        hyperfine \
        jq \
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
        qrencode \
        readline \
        ripgrep \
        sed \
        tar \
        the_silver_searcher \
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
        borgbackup \
        btrfs-progs \
        cronie \
        crontabs \
        cryptsetup \
        device-mapper \
        dkms \
        dmidecode \
        e2fsprogs \
        exim \
        fakeroot \
        glances \
        gdisk \
        haveged \
        hdparm \
        htop \
        dracut \
        iotop \
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
        ncdu \
        numad \
        parted \
        pciutils \
        procps-ng \
        psmisc \
        restic \
        rng-tools \
        passwd \
        shadow-utils \
        smartmontools \
        strace \
        sudo \
        rsyslog{,-doc} \
        syslog-ng \
        sysstat \
        systemtap \
        device-mapper-persistent-data \
        tmux \
        tzdata \
        usbutils \
        xfsdump \
        xfsprogs

    dnf config-manager --add-repo http://download.sysdig.com/stable/rpm/draios.repo
    dnf makecache
    dnf install sysdig
    dnf clean packages

    # NETWORK OPERATOR
    dnf install \
        httpd-tools \
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
        goaccess \
        hostname \
        httpie \
        iftop \
        iperf3 \
        iproute \
        ipset \
        iptables-nft \
        iputils \
        ipvsadm \
        ldns-utils \
        mosh \
        mtr \
        net-tools \
        nmap-ncat \
        nethogs \
        netsniff-ng \
        nftables \
        ngrep \
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
        wpa_supplicant \
        wrk

    # PLT
    dnf install \
        gcc \
        cpp \
        gdb{-doc,-headless} \
        valgrind \
        gcc-c++ \
        clang \
        llvm{,-doc} \
        lld \
        lldb \
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
        caddy \
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
        tig \
        virt-install \
        wireguard-{dkms,tools}

    ## docker [official]
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    ## docker [tsinghua]
    dnf config-manager --add-repo https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/fedora/docker-ce.repo
    dnf makecache
    dnf install docker-ce
    dnf clean packages

    curl --fail --location --silent --show-error https://pkg.osquery.io/rpm/GPG | tee /etc/pki/rpm-gpg/RPM-GPG-KEY-osquery
    dnf config-manager --add-repo https://pkg.osquery.io/rpm/osquery-s3-rpm.repo
    dnf makecache
    dnf install osquery
    dnf clean packages

    systemctl disable --now \
        caddy.service \
        dnsmasq.service \
        libvirt{d,-guests}.service \
        virtlogd.service \
        nginx.service \
        salt-{api,master,minion,syndic}.service

    systemctl enable --now \
        docker.service \
        osqueryd.service

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
        emacs \
        shellcheck

    # UTIL
    apt install \
        at \
        bat \
        bc \
        binutils{,-doc} \
        bzip2 \
        colordiff \
        cpio{,-doc} \
        diffutils{,-doc} \
        dos2unix \
        dosfstools \
        fd-find \
        file \
        findutils \
        finger \
        fzf \
        gawk{,-doc} \
        gnupg{,-utils} \
        grep \
        gzip \
        hexyl \
        hyperfine \
        jq \
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
        qrencode \
        readline-{common,doc} \
        ripgrep \
        sed \
        tar \
        silversearcher-ag \
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
        borgbackup{,-doc} \
        btrfs-progs \
        cron \
        cryptsetup-{initramfs,run} \
        dkms \
        dmidecode \
        dmsetup \
        e2fsprogs \
        exim4-daemon-light \
        fakeroot \
        glances \
        gdisk \
        haveged \
        hdparm \
        htop \
        initramfs-tools \
        iotop \
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
        ncdu \
        numad \
        parted{,-doc} \
        pciutils \
        procps \
        sysvinit-utils \
        psmisc \
        restic \
        rng-tools5 \
        login \
        passwd \
        smartmontools \
        strace \
        sudo \
        rsyslog{,-doc} \
        syslog-ng \
        sysstat \
        systemtap \
        thin-provisioning-tools \
        tmux \
        tzdata \
        usbutils \
        xfsdump \
        xfsprogs

    GPG_HOME_DIR=$(mktemp --directory)
    curl --fail --location --silent --show-error https://download.sysdig.com/DRAIOS-GPG-KEY.public | gpg --homedir "${GPG_HOME_DIR}" --no-default-keyring --keyring gnupg-ring:sysdig.gpg --import
    install --mode 644 "${GPG_HOME_DIR}/sysdig.gpg" /etc/apt/trusted.gpg.d
    rm --force --recursive "${GPG_HOME_DIR}"
    unset GPG_HOME_DIR
    tee /etc/apt/sources.list.d/osquery.list << EOF
deb https://download.sysdig.com/stable/deb stable-$(ARCH)/
EOF
    apt update --list-cleanup
    apt install sysdig

    # NETWORK OPERATOR
    apt install \
        apache2-utils \
        bind9-{dnsutils,host} \
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
        goaccess \
        hostname \
        httpie \
        iftop \
        iperf3 \
        iproute2{,-doc} \
        ipset \
        iptables \
        iputils-{arping,ping,tracepath} \
        ipvsadm \
        ldnsutils \
        mitmproxy \
        mosh \
        mtr-tiny \
        net-tools \
        netcat-openbsd \
        nethogs \
        netsniff-ng \
        nftables \
        ngrep \
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
        wpasupplicant \
        wrk

    # PLT
    apt install \
        gcc{,-doc} \
        cpp{,-doc} \
        gdb{,-doc} \
        valgrind \
        g++ \
        clang{,-9-doc,-format} \
        llvm{,-9-doc} \
        lld \
        lldb \
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
        ruby{,2.7-doc} \
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
        tig \
        virtinst \
        wireguard

    GPG_HOME_DIR=$(mktemp --directory)
    curl --fail --location --silent --show-error https://download.docker.com/linux/debian/gpg | gpg --homedir "${GPG_HOME_DIR}" --no-default-keyring --keyring gnupg-ring:docker.gpg --import
    install --mode 644 "${GPG_HOME_DIR}/docker.gpg" /etc/apt/trusted.gpg.d
    rm --force --recursive "${GPG_HOME_DIR}"
    unset GPG_HOME_DIR
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

    GPG_HOME_DIR=$(mktemp --directory)
    curl --fail --location --silent --show-error https://repo.saltstack.com/py3/debian/10/amd64/latest/SALTSTACK-GPG-KEY.pub | gpg --homedir "${GPG_HOME_DIR}" --no-default-keyring --keyring gnupg-ring:saltstack.gpg --import
    install --mode 644 "${GPG_HOME_DIR}/saltstack.gpg" /etc/apt/trusted.gpg.d
    rm --force --recursive "${GPG_HOME_DIR}"
    unset GPG_HOME_DIR
    ## saltstack [official]
    tee /etc/apt/sources.list.d/saltstack.list << 'EOF'
deb [arch=amd64] https://repo.saltstack.com/py3/debian/10/amd64/latest buster main
EOF
    ## saltstack [tsinghua]
    tee /etc/apt/sources.list.d/saltstack.list << 'EOF'
deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/saltstack/py3/debian/10/amd64/latest buster main
EOF
    apt update --list-cleanup
    apt install salt-{api,cloud,master,minion,ssh,syndic}

    GPG_HOME_DIR=$(mktemp --directory)
    gpg --homedir "${GPG_HOME_DIR}" --no-default-keyring --keyring gnupg-ring:osquery.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
    install --mode 644 "${GPG_HOME_DIR}/osquery.gpg" /etc/apt/trusted.gpg.d
    rm --force --recursive "${GPG_HOME_DIR}"
    unset GPG_HOME_DIR
    tee /etc/apt/sources.list.d/osquery.list << 'EOF'
deb [arch=amd64] https://pkg.osquery.io/deb deb main
EOF
    apt update --list-cleanup
    apt install osquery

    systemctl disable --now \
        dnsmasq.service \
        libvirt{d,-guests}.service \
        virtlogd.service \
        nginx.service \
        salt-{api,master,minion,syndic}.service

    systemctl enable --now \
        docker.service \
        osqueryd.service

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
        core/man-{db,pages} \
        core/texinfo \
        extra/vim \
        extra/emacs \
        community/shellcheck

    # UTIL
    pacman --sync --needed \
        community/at \
        community/bat \
        extra/bc \
        core/binutils \
        core/bzip2 \
        community/colordiff \
        extra/cpio \
        core/diffutils \
        community/dos2unix \
        core/dosfstools \
        community/exa \
        community/fd \
        core/file \
        core/findutils \
        community/fzf \
        core/gawk \
        core/gnupg \
        core/grep \
        core/gzip \
        community/hexyl \
        community/hyperfine \
        community/jq \
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
        community/python-pygments \
        extra/qrencode \
        core/readline \
        community/ripgrep \
        core/sed \
        core/tar \
        community/the_silver_searcher \
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
        community/borg \
        core/btrfs-progs \
        core/cronie \
        core/cryptsetup \
        core/device-mapper \
        extra/dkms \
        extra/dmidecode \
        core/e2fsprogs \
        community/exim \
        core/fakeroot \
        community/glances \
        extra/gptfdisk \
        extra/haveged \
        core/hdparm \
        extra/htop \
        core/mkinitcpio{,-busybox} \
        community/iotop \
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
        community/ncdu \
        extra/parted \
        core/pciutils \
        core/procps-ng \
        core/psmisc \
        community/restic \
        community/rng-tools \
        core/shadow \
        extra/smartmontools \
        extra/strace \
        core/sudo \
        community/sysdig \
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
        extra/apache \
        extra/bind \
        extra/bridge-utils \
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
        community/goaccess \
        core/inetutils \
        community/httpie \
        community/iftop \
        community/iperf3 \
        core/iproute2 \
        extra/ipset \
        core/iptables-nft \
        core/iputils \
        community/ipvsadm \
        core/ldns \
        community/mitmproxy \
        community/mosh \
        extra/mtr \
        core/net-tools \
        community/openbsd-netcat \
        community/nethogs \
        community/netsniff-ng \
        extra/nftables \
        community/ngrep \
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
        core/wpa_supplicant \
        community/wrk

    # PLT
    pacman --sync --needed \
        core/gcc \
        extra/gdb \
        extra/valgrind \
        extra/clang \
        extra/llvm \
        extra/lld \
        extra/lldb \
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
        community/osquery \
        core/pam \
        community/libpam-google-authenticator \
        extra/qemu-headless \
        community/salt \
        community/tig \
        community/virt-install \
        extra/wireguard-{dkms,tools}

    systemctl disable --now \
        dnsmasq.service \
        libvirt{d,-guests}.service \
        virtlogd.service \
        nginx.service \
        salt-{api,master,minion,syndic}.service

    systemctl enable --now \
        docker.service \
        osqueryd.service

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
        emacs \
        ShellCheck

    # UTIL
    zypper install \
        at \
        bat \
        bc \
        binutils \
        bzip2 \
        colordiff \
        cpio \
        diffutils \
        dos2unix \
        dosfstools \
        exa \
        fd \
        file \
        findutils \
        finger \
        fzf \
        gawk \
        gpg2 \
        grep \
        gzip \
        hexyl \
        hyperfine \
        jq \
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
        qrencode \
        readline-doc \
        ripgrep \
        sed \
        tar \
        the_silver_searcher \
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
        borgbackup \
        btrfsprogs \
        cron \
        cronie \
        cryptsetup \
        device-mapper \
        dkms \
        dmidecode \
        e2fsprogs \
        exim \
        fakeroot \
        glances \
        gptfdisk \
        haveged \
        hdparm \
        htop \
        dracut \
        iotop \
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
        ncdu \
        numad \
        parted \
        pciutils \
        procps \
        psmisc \
        restic \
        rng-tools \
        shadow \
        smartmontools \
        strace \
        sudo \
        sysdig \
        rsyslog{,-doc} \
        syslog-ng \
        sysstat \
        systemtap \
        thin-provisioning-tools \
        tmux \
        timezone \
        usbutils \
        xfsdump \
        xfsprogs

    # NETWORK OPERATOR
    zypper install \
        apache2-utils \
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
        goaccess \
        hostname \
        python3-httpie \
        iftop \
        iperf \
        iproute2 \
        ipset \
        iptables-backend-nft \
        iputils \
        ipvsadm \
        ldns \
        python3-mitmproxy \
        mosh \
        mtr \
        net-tools \
        netcat-openbsd \
        nethogs \
        netsniff-ng \
        nftables \
        ngrep \
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
        wpa_supplicant \
        wrk

    # PLT
    zypper install \
        gcc{,-info} \
        cpp \
        gdb \
        valgrind \
        gcc-c++ \
        clang{,10-doc} \
        llvm{,10-doc} \
        lld \
        lldb \
        elixir{,-doc} \
        erlang{,-doc} \
        go{,-doc} \
        ghc \
        java-14-openjdk{-headless,-javadoc} \
        sbcl \
        nodejs14{,-docs} \
        ocaml \
        php7 \
        python3{,-doc,-pip,-virtualenv} \
        ruby{,2.7-doc} \
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
        docker \
        git{,-doc} \
        libguestfs0 \
        libvirt \
        nginx \
        oath-toolkit \
        pam \
        qemu-{tools,x86} \
        salt{,-{api,cloud,master,minion,ssh,syndic}} \
        tig \
        virt-install \
        wireguard-{kmp-default,tools}

    systemctl disable --now \
        dnsmasq.service \
        libvirt{d,-guests}.service \
        virtlogd.service \
        nginx.service \
        salt-{api,master,minion,syndic}.service

    systemctl enable --now \
        docker.service \
        osqueryd.service

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
        emacs \
        shellcheck

    # UTIL
    apt install \
        at \
        bat \
        bc \
        binutils{,-doc} \
        bzip2 \
        colordiff \
        cpio{,-doc} \
        diffutils{,-doc} \
        dos2unix \
        dosfstools \
        fd-find \
        file \
        findutils \
        finger \
        fzf \
        gawk{,-doc} \
        gnupg{,-utils} \
        grep \
        gzip \
        hexyl \
        hyperfine \
        jq \
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
        qrencode \
        readline-{common,doc} \
        ripgrep \
        sed \
        tar \
        silversearcher-ag \
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
        borgbackup{,-doc} \
        btrfs-progs \
        cron \
        cryptsetup{,-bin} \
        dkms \
        dmidecode \
        dmsetup \
        e2fsprogs \
        exim4-daemon-light \
        fakeroot \
        glances \
        gdisk \
        haveged \
        hdparm \
        htop \
        initramfs-tools \
        iotop \
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
        ncdu \
        numad \
        parted{,-doc} \
        pciutils \
        procps \
        sysvinit-utils \
        psmisc \
        restic \
        rng-tools5 \
        login \
        passwd \
        smartmontools \
        strace \
        sudo \
        sysdig \
        rsyslog{,-doc} \
        syslog-ng \
        sysstat \
        systemtap \
        thin-provisioning-tools \
        tmux \
        tzdata \
        usbutils \
        xfsdump \
        xfsprogs

    # NETWORK OPERATOR
    apt install \
        apache2-utils \
        bind9-{dnsutils,host} \
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
        goaccess \
        hostname \
        httpie \
        iftop \
        iperf3 \
        iproute2{,-doc} \
        ipset \
        iptables \
        iputils-{arping,ping,tracepath} \
        ipvsadm \
        ldnsutils \
        mitmproxy \
        mosh \
        mtr-tiny \
        net-tools \
        netcat-openbsd \
        nethogs \
        netsniff-ng \
        nftables \
        ngrep \
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
        wpasupplicant \
        wrk

    # PLT
    apt install \
        gcc{,-doc} \
        cpp{,-doc} \
        gdb{,-doc} \
        valgrind \
        g++ \
        clang{,-10-doc,-format} \
        llvm{,-10-doc} \
        lld \
        lldb \
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
        ruby{,2.7-doc} \
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
        tig \
        virtinst \
        wireguard

    GPG_HOME_DIR=$(mktemp --directory)
    curl --fail --location --silent --show-error https://download.docker.com/linux/ubuntu/gpg | gpg --homedir "${GPG_HOME_DIR}" --no-default-keyring --keyring gnupg-ring:docker.gpg --import
    install --mode 644 "${GPG_HOME_DIR}/docker.gpg" /etc/apt/trusted.gpg.d
    rm --force --recursive "${GPG_HOME_DIR}"
    unset GPG_HOME_DIR
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

    GPG_HOME_DIR=$(mktemp --directory)
    curl --fail --location --silent --show-error https://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | gpg --homedir "${GPG_HOME_DIR}" --no-default-keyring --keyring gnupg-ring:saltstack.gpg --import
    install --mode 644 "${GPG_HOME_DIR}/saltstack.gpg" /etc/apt/trusted.gpg.d
    rm --force --recursive "${GPG_HOME_DIR}"
    unset GPG_HOME_DIR
    ## saltstack [official]
    tee /etc/apt/sources.list.d/saltstack.list << 'EOF'
deb [arch=amd64] https://repo.saltstack.com/py3/ubuntu/18.04/amd64/latest bionic main
EOF
    ## saltstack [tsinghua]
    tee /etc/apt/sources.list.d/saltstack.list << 'EOF'
deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/saltstack/py3/ubuntu/18.04/amd64/latest bionic main
EOF
    apt update --list-cleanup
    apt install salt-{api,cloud,master,minion,ssh,syndic}

    GPG_HOME_DIR=$(mktemp --directory)
    gpg --homedir "${GPG_HOME_DIR}" --no-default-keyring --keyring gnupg-ring:osquery.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
    install --mode 644 "${GPG_HOME_DIR}/osquery.gpg" /etc/apt/trusted.gpg.d
    rm --force --recursive "${GPG_HOME_DIR}"
    unset GPG_HOME_DIR
    tee /etc/apt/sources.list.d/osquery.list << 'EOF'
deb [arch=amd64] https://pkg.osquery.io/deb deb main
EOF
    apt update --list-cleanup
    apt install osquery

    systemctl disable --now \
        dnsmasq.service \
        libvirt{d,-guests}.service \
        virtlogd.service \
        nginx.service \
        qemu-kvm.service \
        salt-{api,master,minion,syndic}.service

    systemctl enable --now \
        docker.service \
        osqueryd.service

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
    "exec-opts": [
        "native.cgroupdriver=systemd"
    ],
    "log-driver": "json-file",
    "log-opts": {
        "max-file": "10",
        "max-size": "10m"
    },
    "storage-driver": "overlay2"
}
EOF

systemctl restart docker.service

# systemd system and service

systemd-detect-virt || true
systemctl get-default
systemctl list-machines --no-pager
systemctl is-system-running --quiet || systemctl list-units --failed

systemd-analyze time
systemd-analyze critical-chain --no-pager
systemd-analyze blame --no-pager

systemctl list-unit-files \
    --no-legend \
    --no-pager \
    --state enabled,disabled \
    --type service,socket,timer \
    | awk '$2 != $3 { print "systemctl", substr($2, 1, length($2) - 1), $1 }' \
    | sort --key 2,3
systemctl list-unit-files --no-pager --state enabled

systemctl list-units --no-pager --type service
systemctl list-sockets --no-pager --show-types
systemctl list-units --no-pager --type socket
systemctl list-timers --no-pager
systemctl list-units --no-pager --type timer
