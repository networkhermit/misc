#!/usr/bin/env bash

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

OS=$(uname -s)

case ${OS} in
Linux | FreeBSD)
    # shellcheck source=/dev/null
    source <(grep '^ID=' /etc/os-release)
    DISTRO=${ID:-linux}
    ;;
OpenBSD)
    DISTRO=openbsd
    ;;
*)
    die "✗ unknown os: ‘${OS}’"
esac

##################
# SHELL
#       bash
#       fish
#       zsh
#       man-pages
#       info
#       vim
#       emacs
#       \shellcheck
##################

##################
# UTIL
#       b3sum
#       bat
#       eza
#       fd
#       fzf
#       hexyl
#       jq
#       moreutils
#       ripgrep
#       tree
#       yq-go
##################

##################
# SYSADMIN
#       cronie
#       htop
#       iotop-c
#       lsof
#       sysstat
#       tmux
##################

##################
# NETWORK OPERATOR
#       chrony
#       curl
#       ldnsutils
#       openssh
#       rsync
##################

##################
# PLT
#       go
#       python
#       rust
##################

##################
# GAME
#       cmatrix
#       cowsay
#       fortunes
#       sl
##################

##################
# DevOps
#       ansible
#       bcc
#       bpftool
#       bpftrace
#       docker
#       docker-compose
#       git
#       perf
#       wireguard-tools
##################

case ${DISTRO} in
alpine)

    # SHELL
    apk add --interactive \
        bash{,-completion} \
        fish \
        zsh{,-autosuggestions,-syntax-highlighting} \
        man{doc,doc-apropos,-pages} \
        texinfo \
        vim \
        emacs-nox \
        shellcheck

    # UTIL
    apk add --interactive \
        b3sum \
        bat \
        eza \
        fd \
        fzf \
        hexyl \
        jq \
        moreutils \
        ripgrep \
        tree \
        yq-go

    # SYSADMIN
    apk add --interactive \
        cronie \
        htop \
        iotop-c \
        lsof \
        sysstat \
        tmux

    # NETWORK OPERATOR
    apk add --interactive \
        chrony \
        curl \
        drill \
        openssh \
        rsync

    # PLT
    apk add --interactive \
        go \
        gopls \
        staticcheck \
        golangci-lint \
        delve \
        python3 \
        black \
        py3-pip \
        py3-mypy \
        ruff \
        rust{,-analyzer} \
        cargo \
        rustfmt \
        rust-clippy \
        cargo-{audit,outdated} \
        mold \
        sccache

    # GAME
    apk add --interactive \
        cmatrix \
        fortune \
        sl

    # DevOps
    apk add --interactive \
        ansible{,-lint} \
        py3-argcomplete \
        bcc-tools \
        py3-bcc \
        bpftool \
        bpftrace \
        docker{,-compose} \
        git{,-prompt} \
        perf \
        wireguard-tools

    apk info --contents \
        openssh-server-common-openrc \
        | awk --field-separator '[/ ]' '/etc\/init.d\/.+[^/]$/ { printf "%-24s%s\n", "openssh", $NF }'

    apk info --who-owns /etc/bash/bashrc

    ;;&
arch | archarm)

    # SHELL
    pacman --sync --needed \
        bash{,-completion} \
        fish \
        zsh{,-autosuggestions,-syntax-highlighting} \
        man-{db,pages} \
        texinfo \
        vim \
        emacs-nox \
        shellcheck

    # UTIL
    pacman --sync --needed \
        b3sum \
        bat \
        eza \
        fd \
        fzf \
        hexyl \
        jq \
        moreutils \
        ripgrep \
        tree \
        go-yq

    # SYSADMIN
    pacman --sync --needed \
        cronie \
        htop \
        iotop-c \
        lsof \
        sysstat \
        tmux

    # NETWORK OPERATOR
    pacman --sync --needed \
        chrony \
        curl \
        ldns \
        openssh \
        rsync

    # PLT
    pacman --sync --needed \
        go \
        gopls \
        go-tools \
        staticcheck \
        delve \
        python{,-black,-pip} \
        mypy \
        ruff \
        rust{,-analyzer} \
        cargo-{audit,outdated} \
        mold \
        sccache

    # GAME
    pacman --sync --needed \
        cmatrix \
        cowsay \
        fortune-mod \
        sl

    # DevOps
    pacman --sync --needed \
        ansible{,-lint} \
        python-argcomplete \
        bcc-tools \
        python-bcc \
        bpf \
        bpftrace \
        docker{,-buildx,-compose} \
        git \
        perf \
        wireguard-tools

    pacman --files --list \
        openssh \
        | awk --field-separator '[/ ]' '/usr\/lib\/systemd\/.+\/.+\..+[^/]$/ { printf "%-24s%s\n", $1, $NF }'

    pacman --query --owns /etc/bash.bashrc

    ;;&
artix)

    # SHELL
    pacman --sync --needed \
        bash{,-completion} \
        fish \
        zsh{,-autosuggestions,-syntax-highlighting} \
        man-{db,pages} \
        texinfo \
        vim \
        emacs-nox \
        shellcheck-bin

    # UTIL
    pacman --sync --needed \
        fzf \
        jq \
        moreutils \
        ripgrep \
        tree \
        go-yq \
        \
        b3sum \
        bat \
        eza \
        fd \
        hexyl

    # SYSADMIN
    pacman --sync --needed \
        cronie-s6 \
        htop \
        lsof \
        tmux \
        \
        iotop-c \
        sysstat

    # NETWORK OPERATOR
    pacman --sync --needed \
        chrony-s6 \
        curl \
        ldns \
        openssh-s6 \
        rsync-s6

    # PLT
    pacman --sync --needed \
        go \
        go-tools \
        python{,-black,-pip} \
        mypy \
        ruff \
        rust \
        mold \
        \
        gopls \
        staticcheck \
        delve \
        rust-analyzer \
        cargo-{audit,outdated} \
        sccache

    # GAME
    pacman --sync --needed \
        \
        cmatrix \
        cowsay \
        fortune-mod \
        sl

    # DevOps
    pacman --sync --needed \
        ansible{,-lint} \
        python-argcomplete \
        bpf \
        docker{,-buildx,-compose} \
        git \
        perf \
        wireguard-s6 \
        \
        bcc-tools \
        python-bcc \
        bpftrace

    pacman --files --list \
        openssh-s6 \
        | awk --field-separator '[/ ]' '/etc\/s6\/sv\/[^/]+\/$/ { printf "%-24s%s\n", $1, $(NF-1) }'

    pacman --query --owns /etc/bash/bashrc

    ;;&
fedora)

    # SHELL
    dnf install --setopt metadata_expire=never \
        bash{,-completion} \
        fish \
        zsh{,-autosuggestions,-syntax-highlighting} \
        man-{db,pages} \
        info \
        vim-enhanced \
        emacs-nw \
        ShellCheck

    # UTIL
    dnf install --setopt metadata_expire=never \
        b3sum \
        bat \
        eza \
        fd-find \
        fzf \
        hexyl \
        jq \
        moreutils \
        ripgrep \
        tree \
        yq

    # SYSADMIN
    dnf install --setopt metadata_expire=never \
        cronie \
        htop \
        iotop-c \
        lsof \
        sysstat \
        tmux

    # NETWORK OPERATOR
    dnf install --setopt metadata_expire=never \
        chrony \
        curl \
        ldns-utils \
        openssh-server \
        rsync

    # PLT
    dnf install --setopt metadata_expire=never \
        golang \
        golang-x-tools-{gopls,goimports} \
        golang-honnef-tools \
        delve \
        python3{,-pip} \
        black \
        python3-mypy \
        ruff \
        rust{,-analyzer} \
        cargo \
        rustfmt \
        clippy \
        mold

    # GAME
    dnf install --setopt metadata_expire=never \
        cmatrix \
        cowsay \
        fortune-mod \
        sl

    # DevOps
    dnf install --setopt metadata_expire=never \
        ansible \
        python3-ansible-lint \
        python3-argcomplete \
        bcc-tools \
        python3-bcc \
        bpftool \
        bpftrace \
        git \
        perf \
        wireguard-tools

    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    dnf makecache
    dnf install --setopt metadata_expire=never docker-ce docker-compose-plugin
    dnf clean packages

    rpm --query \
        openssh-server \
        --list \
        | awk --field-separator '[/ ]' '/\/lib\/systemd\/.+\/.+\..+/ { printf "%s\n", $NF }'

    rpm --query --file /etc/bashrc

    ;;&
gentoo)

    # SHELL
    emerge --ask --getbinpkg --noreplace \
        app-shells/bash{,-completion} \
        app-shells/fish \
        app-shells/zsh{,-syntax-highlighting} \
        sys-apps/man-{db,pages} \
        sys-apps/texinfo \
        app-editors/vim \
        app-editors/emacs \
        dev-util/shellcheck-bin

    # UTIL
    emerge --ask --getbinpkg --noreplace \
        sys-apps/bat \
        sys-apps/eza \
        sys-apps/fd \
        app-shells/fzf \
        app-misc/jq \
        sys-apps/moreutils \
        sys-apps/ripgrep \
        app-text/tree \
        app-misc/yq-go

    # SYSADMIN
    emerge --ask --getbinpkg --noreplace \
        sys-process/cronie \
        sys-process/htop \
        sys-process/iotop-c \
        sys-process/lsof \
        app-admin/sysstat \
        app-misc/tmux

    # NETWORK OPERATOR
    emerge --ask --getbinpkg --noreplace \
        net-misc/chrony \
        net-misc/curl \
        net-libs/ldns \
        net-misc/openssh \
        net-misc/rsync

    # PLT
    emerge --ask --getbinpkg --noreplace \
        dev-lang/go \
        dev-go/gopls \
        dev-lang/python \
        dev-python/pip \
        dev-python/mypy \
        dev-python/black \
        dev-lang/rust \
        sys-devel/mold

    # GAME
    emerge --ask --getbinpkg --noreplace \
        app-misc/cmatrix \
        games-misc/cowsay \
        games-misc/fortune-mod \
        app-misc/sl

    # DevOps
    emerge --ask --getbinpkg --noreplace \
        app-admin/ansible \
        app-admin/ansible-lint \
        dev-python/argcomplete \
        dev-util/bcc \
        dev-util/bpftool \
        dev-debug/bpftrace \
        app-containers/docker{,-compose} \
        dev-vcs/git \
        dev-util/perf \
        net-vpn/wireguard-tools

    qlist \
        net-misc/openssh \
        | awk --field-separator '[/ ]' '/etc\/init.d\/.+[^/]$/ { printf "%-24s%s\n", "openssh", $NF }'

    qfile /etc/bash/bashrc

    ;;&
kali)

    # SHELL
    apt install \
        bash{,-completion} \
        fish \
        zsh{,-autosuggestions,-syntax-highlighting} \
        manpages{,-dev} \
        info \
        vim \
        emacs-nox \
        shellcheck

    # UTIL
    apt install \
        b3sum \
        bat \
        eza \
        fd-find \
        fzf \
        hexyl \
        jq \
        moreutils \
        ripgrep \
        tree

    ln --force --no-dereference --relative --symbolic --verbose "$(command -v batcat)" /usr/local/bin/bat

    # SYSADMIN
    apt install \
        cron \
        htop \
        iotop-c \
        lsof \
        sysstat \
        tmux

    # NETWORK OPERATOR
    apt install \
        chrony \
        curl \
        ldnsutils \
        openssh-server \
        rsync

    # PLT
    apt install \
        golang \
        gopls \
        golang-golang-x-tools \
        delve \
        python3{,-pip} \
        black \
        mypy \
        rust{c,-src} \
        cargo \
        rustfmt \
        rust-clippy \
        cargo-outdated \
        mold \
        sccache

    # GAME
    apt install \
        cmatrix \
        cowsay \
        fortunes \
        sl

    # DevOps
    apt install \
        ansible{,-lint} \
        python3-argcomplete \
        bpfcc-tools \
        python3-bpfcc \
        bpftool \
        bpftrace \
        docker.io \
        git \
        linux-perf \
        wireguard-tools

    dpkg --listfiles \
        openssh-server \
        | awk --field-separator '[/ ]' '/\/lib\/systemd\/.+\/.+\..+/ { printf "%s\n", $NF }'

    dpkg --search /etc/bash.bashrc

    ;;&
void)

    # SHELL
    xbps-install \
        bash{,-completion} \
        fish-shell \
        zsh{,-autosuggestions,-syntax-highlighting} \
        mdocml \
        man-pages \
        texinfo \
        vim \
        emacs \
        shellcheck

    # UTIL
    xbps-install \
        b3sum \
        bat \
        eza \
        fd \
        fzf \
        hexyl \
        jq \
        moreutils \
        ripgrep \
        tree \
        yq-go

    # SYSADMIN
    xbps-install \
        cronie \
        htop \
        iotop-c \
        lsof \
        sysstat \
        tmux

    # NETWORK OPERATOR
    xbps-install \
        chrony \
        curl \
        ldns \
        openssh \
        rsync

    # PLT
    xbps-install \
        go \
        gopls \
        golangci-lint \
        delve \
        python3{,-pip,-mypy} \
        black \
        ruff \
        rust{,-analyzer,-src} \
        rust-cargo-audit \
        mold \
        rust-sccache

    # GAME
    xbps-install \
        cmatrix \
        cowsay \
        fortune-mod \
        sl

    # DevOps
    xbps-install \
        ansible \
        python3-ansible-lint \
        python3-argcomplete \
        bcc-tools \
        python3-bcc \
        bpftool \
        bpftrace \
        docker{,-buildx,-compose} \
        git \
        perf \
        wireguard-tools

    xbps-query --files \
        openssh \
        | awk --field-separator '[/ ]' '/etc\/sv\/.+[^/]$/ { printf "%-24s%s\n", "openssh", $4 }' \
        | uniq

    xbps-query --ownedby /etc/bash/bashrc

    ;;&
freebsd)

    # SHELL
    pkg install --no-repo-update \
        bash{,-completion} \
        fish \
        zsh{,-autosuggestions,-syntax-highlighting} \
        texinfo \
        vim \
        emacs-nox \
        hs-ShellCheck

    # UTIL
    pkg install --no-repo-update \
        b3sum \
        bat \
        eza \
        fd-find \
        fzf \
        hexyl \
        jq \
        moreutils \
        ripgrep \
        tree \
        go-yq

    # SYSADMIN
    pkg install --no-repo-update \
        htop \
        lsof \
        tmux

    # NETWORK OPERATOR
    pkg install --no-repo-update \
        chrony \
        curl \
        ldns \
        rsync

    # PLT
    pkg install --no-repo-update \
        go \
        gopls \
        go-tools \
        golangci-lint \
        delve \
        python3 \
        py311-{black,pip,mypy} \
        ruff \
        rust{,-analyzer} \
        cargo-audit \
        mold \
        sccache

    # GAME
    pkg install --no-repo-update \
        cmatrix \
        cowsay \
        fortune-mod-freebsd-classic \
        sl

    # DevOps
    pkg install --no-repo-update \
        py311-ansible{,-lint} \
        py311-argcomplete \
        git \
        wireguard-tools

    pkg query '%n %Fp' \
        chrony \
        | awk -F '[/ ]' '/usr\/local\/etc\/rc.d\/.+$/ { printf "%-24s%s\n", $1, $NF }'

    pkg which /usr/local/bin/bash

    ;;
openbsd)

    # SHELL
    pkg_add \
        bash{,-completion}-- \
        fish-- \
        zsh{,-syntax-highlighting}-- \
        vim--no_x11 \
        emacs--no_x11 \
        shellcheck--

    # UTIL
    pkg_add \
        bat-- \
        eza-- \
        fd-- \
        fzf-- \
        hexyl-- \
        jq-- \
        moreutils-- \
        ripgrep-- \
        colortree--

    # SYSADMIN
    pkg_add \
        htop--

    # NETWORK OPERATOR
    pkg_add \
        curl-- \
        drill-- \
        rsync--

    # PLT
    pkg_add \
        go-- \
        gopls-- \
        go-tools-- \
        python--%3 \
        py3-{black,pip,mypy}-- \
        rust{,-rustfmt,-clippy,-analyzer,-src}-- \
        cargo-audit-- \
        sccache--

    # GAME
    pkg_add \
        cmatrix-- \
        cowsay-- \
        sl--

    # DevOps
    pkg_add \
        ansible{,-lint}-- \
        py3-argcomplete-- \
        git-- \
        wireguard-tools--

    pkg_info -L \
        tailscale-- \
        | awk -F '[/ ]' '/etc\/rc.d\/.+$/ { printf "%-24s%s\n", "tailscale", $NF }'

    pkg_info -E /usr/local/bin/bash

    ;;
alpine | arch | archarm | artix | fedora | gentoo | kali | void)
    ## Docker

    pushd "$(dirname "$(realpath "${0}")")" &> /dev/null

    install -D --mode 644 --target-directory /etc/docker "$(git rev-parse --show-toplevel)/config/etc/docker/daemon.json"
    ;;
*)
    die "✗ unknown distro: ‘${DISTRO}’"
    ;;
esac
