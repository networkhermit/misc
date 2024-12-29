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
#       neovim
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
#       hyperfine
#       jq
#       moreutils
#       ripgrep
#       tailspin
#       tree
#       uutils-coreutils
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
#       pwru
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
#       bcc
#       bpftool
#       bpftrace
#       docker
#       docker-compose
#       git
#       perf
#       tailscale
#       wireguard-tools
##################

case ${DISTRO} in
alpine | postmarketos)

    # SHELL
    apk add --interactive \
        bash{,-completion} \
        fish \
        zsh{,-autosuggestions,-syntax-highlighting} \
        man{doc,doc-apropos,-pages} \
        texinfo \
        vim \
        neovim \
        emacs-nox \
        shellcheck

    # UTIL
    apk add --interactive \
        bat \
        eza \
        fd \
        fzf \
        hexyl \
        hyperfine \
        jq \
        moreutils \
        ripgrep \
        tree \
        uutils-coreutils \
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
        python3 \
        py3-pip \
        rust \
        cargo

    # GAME
    apk add --interactive \
        cmatrix \
        fortune \
        sl

    # DevOps
    apk add --interactive \
        bcc-tools \
        py3-bcc \
        bpftool \
        bpftrace \
        docker{,-compose} \
        git{,-prompt} \
        perf \
        tailscale \
        wireguard-tools

    apk info --contents \
        openssh-server-common-openrc \
        | awk --field-separator '[/ ]' '/etc\/init.d\/.+[^/]$/ { printf "%-24s%s\n", "openssh", $NF }'

    apk info --who-owns /etc/bash/bashrc

    ;;&
arch)

    # SHELL
    pacman --sync --needed \
        bash{,-completion} \
        fish \
        zsh{,-autosuggestions,-syntax-highlighting} \
        man-{db,pages} \
        texinfo \
        vim \
        neovim \
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
        hyperfine \
        jq \
        moreutils \
        ripgrep \
        tailspin \
        tree \
        uutils-coreutils \
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
        pwru \
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
        tailscale \
        wireguard-tools

    pacman --files --list \
        openssh \
        | awk --field-separator '[/ ]' '/usr\/lib\/systemd\/.+\/.+\..+[^/]$/ { printf "%-24s%s\n", $1, $NF }'

    pacman --query --owns /etc/bash.bashrc

    ;;&
archarm)

    # SHELL
    pacman --sync --needed \
        bash{,-completion} \
        fish \
        zsh{,-autosuggestions,-syntax-highlighting} \
        man-{db,pages} \
        texinfo \
        vim \
        neovim \
        emacs-nox

    # UTIL
    pacman --sync --needed \
        b3sum \
        bat \
        eza \
        fd \
        fzf \
        hexyl \
        hyperfine \
        jq \
        moreutils \
        ripgrep \
        tailspin \
        tree \
        uutils-coreutils \
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
        pwru \
        rsync

    # PLT
    pacman --sync --needed \
        go \
        python{,-pip} \
        rust

    # GAME
    pacman --sync --needed \
        cmatrix \
        cowsay \
        fortune-mod \
        sl

    # DevOps
    pacman --sync --needed \
        bcc-tools \
        python-bcc \
        bpf \
        bpftrace \
        docker{,-buildx,-compose} \
        git \
        perf \
        tailscale \
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
        neovim \
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
        hexyl \
        hyperfine \
        tailspin \
        uutils-coreutils

    # SYSADMIN
    pacman --sync --needed \
        cronie-s6 \
        htop \
        lsof \
        tmux \
        sysstat \
        \
        iotop-c

    # NETWORK OPERATOR
    pacman --sync --needed \
        chrony-s6 \
        curl \
        ldns \
        openssh-s6 \
        rsync-s6 \
        \
        pwru

    # PLT
    pacman --sync --needed \
        go \
        python{,-pip} \
        rust \

    # GAME
    pacman --sync --needed \
        cmatrix \
        \
        cowsay \
        fortune-mod \
        sl

    # DevOps
    pacman --sync --needed \
        bpf \
        docker{,-buildx,-compose} \
        git \
        perf \
        tailscale \
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
        neovim \
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
        hyperfine \
        jq \
        moreutils \
        ripgrep \
        tree \
        uutils-coreutils \
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
        python3{,-pip} \
        rust \
        cargo

    # GAME
    dnf install --setopt metadata_expire=never \
        cmatrix \
        cowsay \
        fortune-mod \
        sl

    # DevOps
    dnf install --setopt metadata_expire=never \
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
        app-editors/neovim \
        app-editors/emacs \
        dev-util/shellcheck-bin

    # UTIL
    emerge --ask --getbinpkg --noreplace \
        sys-apps/bat \
        sys-apps/eza \
        sys-apps/fd \
        app-shells/fzf \
        app-benchmarks/hyperfine \
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
        dev-lang/python \
        dev-python/pip \
        dev-lang/rust

    # GAME
    emerge --ask --getbinpkg --noreplace \
        app-misc/cmatrix \
        games-misc/cowsay \
        games-misc/fortune-mod \
        app-misc/sl

    # DevOps
    emerge --ask --getbinpkg --noreplace \
        dev-util/bcc \
        dev-util/bpftool \
        dev-debug/bpftrace \
        app-containers/docker{,-compose} \
        dev-vcs/git \
        dev-util/perf \
        net-vpn/tailscale \
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
        neovim \
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
        hyperfine \
        jq \
        moreutils \
        ripgrep \
        tailspin \
        tree \
        rust-coreutils

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
        python3{,-pip} \
        rustc \
        cargo

    # GAME
    apt install \
        cmatrix \
        cowsay \
        fortunes \
        sl

    # DevOps
    apt install \
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
        neovim \
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
        hyperfine \
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
        pwru \
        rsync

    # PLT
    xbps-install \
        go \
        python3{,-pip} \
        rust \
        cargo

    # GAME
    xbps-install \
        cmatrix \
        cowsay \
        fortune-mod \
        sl

    # DevOps
    xbps-install \
        bcc-tools \
        python3-bcc \
        bpftool \
        bpftrace \
        docker{,-buildx,-compose} \
        git \
        perf \
        tailscale \
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
        neovim \
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
        hyperfine \
        jq \
        moreutils \
        ripgrep \
        tailspin \
        tree \
        rust-coreutils \
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
        python3 \
        py311-pip \
        rust

    # GAME
    pkg install --no-repo-update \
        cmatrix \
        cowsay \
        fortune-mod-freebsd-classic \
        sl

    # DevOps
    pkg install --no-repo-update \
        git \
        tailscale \
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
        neovim-- \
        emacs--no_x11 \
        shellcheck--

    # UTIL
    pkg_add \
        bat-- \
        eza-- \
        fd-- \
        fzf-- \
        hexyl-- \
        hyperfine-- \
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
        python--%3 \
        py3-pip-- \
        rust--

    # GAME
    pkg_add \
        cmatrix-- \
        cowsay-- \
        sl--

    # DevOps
    pkg_add \
        git-- \
        tailscale-- \
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
