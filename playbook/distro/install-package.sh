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

if [[ "${OSTYPE}" != linux-gnu ]] && [[ "${OSTYPE}" != linux ]]; then
    die "✗ unknown os type: ‘${OSTYPE}’"
fi

# shellcheck source=/dev/null
source <(grep '^ID=' /etc/os-release)
DISTRO=${ID:-linux}

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
#       iotop
#       lsof
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
#       neofetch
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
#       wireguard-tools
##################

case ${DISTRO} in
arch|archarm)

    # SHELL
    pacman --sync --needed \
        bash{,-completion} \
        zsh{,-autosuggestions,-syntax-highlighting} \
        man-{db,pages} \
        texinfo \
        vim \
        emacs \
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
        iotop \
        lsof \
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
        ruff{,-lsp} \
        rust{,-analyzer} \
        cargo-{audit,outdated} \
        mold \
        sccache

    # GAME
    pacman --sync --needed \
        cmatrix \
        cowsay \
        fortune-mod \
        neofetch \
        sl

    # DevOps
    pacman --sync --needed \
        ansible{,-lint} \
        python-argcomplete \
        bcc-tools \
        python-bcc \
        bpf \
        bpftrace \
        docker{,-compose} \
        git \
        wireguard-tools

    pacman --files --list \
        openssh \
        | awk --field-separator '[/ ]' '/usr\/lib\/systemd\/.+\/.+\..+[^/]$/ { printf "%-24s%s\n", $1, $NF }'

    pacman --query --owns /etc/bash.bashrc

    ;;
fedora)

    # SHELL
    dnf install \
        bash{,-completion} \
        zsh{,-autosuggestions,-syntax-highlighting} \
        man-{db,pages} \
        info \
        vim-enhanced \
        emacs \
        ShellCheck

    # UTIL
    dnf install \
        bat \
        eza \
        fd-find \
        fzf \
        hexyl \
        jq \
        moreutils \
        ripgrep \
        tree

    # SYSADMIN
    dnf install \
        cronie \
        htop \
        iotop \
        lsof \
        tmux

    # NETWORK OPERATOR
    dnf install \
        chrony \
        curl \
        ldns-utils \
        openssh-server \
        rsync

    # PLT
    dnf install \
        golang \
        delve \
        python3{,-pip} \
        black \
        python3-mypy \
        rust{,-analyzer} \
        rustfmt \
        clippy \
        cargo \
        mold

    # GAME
    dnf install \
        cmatrix \
        cowsay \
        fortune-mod \
        neofetch \
        sl

    # DevOps
    dnf install \
        ansible \
        python3-ansible-lint \
        python3-argcomplete \
        bcc-tools \
        python3-bcc \
        bpftool \
        bpftrace \
        git \
        wireguard-tools

    ## docker [official]
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    ## docker [tsinghua]
    dnf config-manager --add-repo https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/fedora/docker-ce.repo
    dnf makecache
    dnf install docker-ce docker-compose-plugin
    dnf clean packages

    rpm --query \
        openssh-server \
        --list \
        | awk --field-separator '[/ ]' '/\/lib\/systemd\/.+\/.+\..+/ { printf "%s\n", $NF }'

    rpm --query --file /etc/bashrc

    ;;
kali)

    # SHELL
    apt install \
        bash{,-completion} \
        zsh{,-autosuggestions,-syntax-highlighting} \
        manpages{,-dev} \
        info \
        vim \
        emacs \
        shellcheck

    # UTIL
    apt install \
        b3sum \
        bat \
        exa \
        fd-find \
        fzf \
        hexyl \
        jq \
        moreutils \
        ripgrep \
        tree

    # SYSADMIN
    apt install \
        cron \
        htop \
        iotop \
        lsof \
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
        rustc \
        rustfmt \
        rust-clippy \
        cargo \
        mold \
        sccache

    # GAME
    apt install \
        cmatrix \
        cowsay \
        fortunes \
        neofetch \
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
        wireguard-tools

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
    | LC_ALL=C sort \
    | tee /etc/systemd/system-preset/00-local.preset.raw

systemctl list-units --no-pager --type service
systemctl list-sockets --no-pager --show-types
systemctl list-units --no-pager --type socket
systemctl list-timers --no-pager
systemctl list-units --no-pager --type timer
