#!/bin/bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

warn () {
    if (( $# > 0 )); then
        echo "${@}" 1>&2
    fi
}

die () {
    warn "${@}"
    exit 1
}

notify () {
    local code=$?
    warn "✗ [FATAL] $(caller): ${BASH_COMMAND} (${code})"
}

trap notify ERR

display_help () {
    cat << EOF
Synopsis:
    ${0##*/} [OPTION]...

Options:
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit
EOF
}

while (( $# > 0 )); do
    case ${1} in
    -h | --help)
        display_help
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
    die "✗ argument parsing failed: unrecognizable argument ‘${1}’"
fi

if (( EUID != 0 )); then
    die '✗ This script must be run as root'
fi

clean_up () {
    true
}

trap clean_up EXIT

if [ "${OSTYPE}" != linux-gnu ] && [ "${OSTYPE}" != linux ]; then
    die "✗ unknown os type: ‘${OSTYPE}’"
fi

# shellcheck source=/dev/null
source <(grep '^ID=' /etc/os-release)
DISTRO=${ID:-linux}

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
#       bcc
#       caddy
#       certbot
#       dnsmasq
#       docker
#       docker-compose
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
        community/time \
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
        core/dnssec-anchors \
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
        extra/wireless_tools \
        community/wireshark-cli \
        core/wpa_supplicant
        #dnstracer
        #wrk

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
        community/gopls \
        community/ghc \
        community/haskell-language-server \
        extra/jdk-openjdk \
        extra/openjdk-doc \
        extra/sbcl \
        community/nodejs \
        extra/ocaml \
        extra/php \
        core/python \
        extra/python{-pip,-virtualenv} \
        community/python-black \
        community/mypy \
        extra/ruby{,-docs} \
        extra/rust \
        community/rust-analyzer

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
        community/bcc-tools \
        community/python-bcc \
        community/caddy \
        community/certbot \
        extra/dnsmasq \
        community/docker \
        community/docker-compose \
        extra/git \
        community/libguestfs \
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
        extra/wireguard-tools

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
        ntpsec \
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
        #wrk

    # PLT
    dnf install \
        gcc \
        cpp \
        gdb{-doc,-headless} \
        valgrind \
        gcc-c++ \
        clang{,-tools-extra} \
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
        black \
        python3-mypy \
        ruby{,-doc} \
        rust{,-doc,-src} \
        rustfmt \
        clippy \
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
        bcc-tools \
        python3-bcc \
        bcc-doc \
        caddy \
        certbot \
        dnsmasq \
        docker-compose \
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
        wireguard-tools

    ## docker [official]
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    ## docker [tsinghua]
    dnf config-manager --add-repo https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/fedora/docker-ce.repo
    dnf makecache
    dnf install docker-ce
    dnf clean packages

    curl --fail --location --silent --show-error --output /etc/pki/rpm-gpg/RPM-GPG-KEY-osquery https://pkg.osquery.io/rpm/GPG
    dnf config-manager --add-repo https://pkg.osquery.io/rpm/osquery-s3-rpm.repo
    dnf makecache
    dnf install osquery
    dnf clean packages

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
        exa \
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
        #hyperfine

    # SYSADMIN
    apt install \
        acl \
        borgbackup{,-doc} \
        btrfs-progs \
        cron \
        cryptsetup-initramfs \
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
        sysstat \
        systemtap \
        thin-provisioning-tools \
        tmux \
        tzdata \
        usbutils \
        xfsdump \
        xfsprogs
        #syslog-ng

    curl --fail --location --silent --show-error https://download.sysdig.com/DRAIOS-GPG-KEY.public | gpg --dearmor --output /etc/apt/trusted.gpg.d/sysdig.gpg
    echo /etc/apt/sources.list.d/sysdig.list
    apt update --list-cleanup
    apt install sysdig

    # NETWORK OPERATOR
    apt install \
        apache2-utils \
        bind9-{dnsutils,host} \
        ca-certificates \
        chrony \
        curl \
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
        ntp-doc \
        sntp \
        ntpsec-doc \
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
        #bridge-utils
        #ntp
        #ntpsec

    # PLT
    apt install \
        gcc{,-doc} \
        cpp{,-doc} \
        gdb{,-doc} \
        valgrind \
        g++ \
        clang{,-13-doc,d,-format} \
        llvm{,-13-doc} \
        lld \
        lldb \
        elixir \
        erlang-{doc,nox} \
        golang{,-doc,-src} \
        ghc{,-doc} \
        default-jdk-{doc,headless} \
        sbcl{,-doc} \
        nodejs{,-doc} \
        ocaml{,-doc} \
        php \
        python3{,-doc,-pip,-virtualenv} \
        black \
        mypy \
        ruby{,3.0-doc} \
        rust{c,-doc,-src} \
        rustfmt \
        rust-clippy \
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
        bpfcc-tools \
        python3-bpfcc \
        certbot \
        python-certbot-doc \
        dnsmasq \
        docker.io \
        docker-compose \
        git{,-doc} \
        libguestfs-tools \
        libvirt-{clients,daemon-system} \
        nginx-{doc,full} \
        libnginx-mod-http-{auth-pam,lua} \
        oathtool \
        libpam-{doc,modules{,-bin}} \
        qemu-{system-x86,utils} \
        salt-{api,cloud,master,minion,ssh,syndic} \
        tig \
        virtinst \
        wireguard-tools
        #libpam-google-authenticator

    curl --fail --location --silent --show-error --output /etc/apt/trusted.gpg.d/osquery.gpg https://pkg.osquery.io/deb/keyring.gpg
    echo /etc/apt/sources.list.d/osquery.list
    apt update --list-cleanup
    apt install osquery

    dpkg --listfiles \
        openssh-server \
        | awk --field-separator '[/ ]' '/\/lib\/systemd\/.+\/.+\..+/ { printf "%s\n", $NF }'

    dpkg --search /etc/bash.bashrc

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
        systemd{,-network,-sysvinit}

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
        #hexyl

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
        rsyslog-doc \
        syslog-ng \
        sysstat \
        systemtap \
        thin-provisioning-tools \
        tmux \
        timezone \
        usbutils \
        xfsdump \
        xfsprogs
        #exim
        #rsyslog

    # NETWORK OPERATOR
    zypper install \
        apache2-utils \
        bind-utils \
        bridge-utils \
        ca-certificates{,-mozilla} \
        chrony \
        curl \
        dnstracer \
        ethtool \
        fping \
        geoipupdate \
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
        ntpsec-doc \
        openssh \
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
        wireshark \
        wpa_supplicant \
        wrk
        #ntpsec

    # PLT
    zypper install \
        gcc{,-info} \
        cpp \
        gdb \
        valgrind \
        gcc-c++ \
        clang{,13-doc} \
        llvm{,13-doc} \
        lld \
        lldb \
        elixir{,-doc} \
        erlang{,-doc} \
        go{,-doc} \
        ghc \
        java-17-openjdk{-headless,-javadoc} \
        sbcl \
        nodejs16{,-docs} \
        ocaml \
        php8 \
        python3{,-doc,-pip,-virtualenv} \
        python3-black \
        python3-mypy \
        ruby{,3.0-doc} \
        rust \
        cargo

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
        bcc-tools \
        python3-bcc \
        bcc-docs \
        caddy \
        python3-certbot \
        dnsmasq \
        docker \
        docker-compose \
        git{,-doc} \
        guestfs-tools \
        libvirt \
        nginx \
        oath-toolkit \
        pam \
        qemu-{tools,x86} \
        salt{,-{api,cloud,master,minion,ssh,syndic}} \
        tig \
        virt-install \
        wireguard-tools

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
        exa \
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
        #hyperfine

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
        sysstat \
        systemtap \
        thin-provisioning-tools \
        tmux \
        tzdata \
        usbutils \
        xfsdump \
        xfsprogs
        #syslog-ng

    # NETWORK OPERATOR
    apt install \
        apache2-utils \
        bind9-{dnsutils,host} \
        bridge-utils \
        ca-certificates \
        chrony \
        curl \
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
        ntp-doc \
        sntp \
        ntpsec-doc \
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
        #ntp
        #ntpsec

    # PLT
    apt install \
        gcc{,-doc} \
        cpp{,-doc} \
        gdb{,-doc} \
        valgrind \
        g++ \
        clang{,-13-doc,d,-format} \
        llvm{,-13-doc} \
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
        black \
        mypy \
        ruby{,2.7-doc} \
        rust{c,-doc,-src} \
        rustfmt \
        rust-clippy \
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
        bpfcc-tools \
        python3-bpfcc \
        certbot \
        dnsmasq \
        python-certbot-doc \
        docker.io \
        docker-compose \
        git{,-doc} \
        libguestfs-tools \
        libvirt-{clients,daemon-system} \
        nginx-{doc,full} \
        libnginx-mod-http-auth-pam \
        oathtool \
        libpam-{doc,google-authenticator,modules{,-bin}} \
        qemu-{system-x86,utils} \
        salt-{api,cloud,master,minion,ssh,syndic} \
        tig \
        virtinst \
        wireguard-tools
        #libnginx-mod-http-lua

    curl --fail --location --silent --show-error --output /etc/apt/trusted.gpg.d/osquery.gpg https://pkg.osquery.io/deb/keyring.gpg
    echo /etc/apt/sources.list.d/osquery.list
    apt update --list-cleanup
    apt install osquery

    dpkg --listfiles \
        openssh-server \
        | awk --field-separator '[/ ]' '/\/lib\/systemd\/.+\/.+\..+/ { printf "%s\n", $NF }'

    dpkg --search /etc/bash.bashrc

        ;;
*)
    die "✗ unknown distro: ‘${DISTRO}’"
    ;;
esac

## Docker

echo /etc/docker/daemon.json

systemctl restart docker.service

# systemd system and service

systemd-detect-virt || true
systemctl get-default
systemctl list-machines --no-pager
systemctl is-system-running --quiet || systemctl list-units --failed

systemd-analyze time
systemd-analyze critical-chain --no-pager
systemd-analyze blame --no-pager

systemctl list-unit-files --no-pager --state enabled

mkdir --parents --verbose /etc/systemd/system-preset
systemctl list-unit-files \
    --no-legend \
    --no-pager \
    --state enabled,disabled \
    --type service,socket,timer \
    | awk '$2 != $3 { print substr($2, 1, length($2) - 1), $1 }' \
    | sort \
    | tee /etc/systemd/system-preset/00-local.preset.raw

systemctl list-units --no-pager --type service
systemctl list-sockets --no-pager --show-types
systemctl list-units --no-pager --type socket
systemctl list-timers --no-pager
systemctl list-units --no-pager --type timer
