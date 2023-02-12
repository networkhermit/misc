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
#       exa
#       fzf
#       hexyl
#       jq
#       moreutils
#       most
#       ripgrep
#       tree
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
#       screenfetch
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
#       osquery
#       wireguard-tools
##################

case ${DISTRO} in
arch)

    # SHELL
    pacman --sync --needed \
        core/bash \
        extra/bash-completion \
        extra/zsh \
        core/man-{db,pages} \
        core/texinfo \
        extra/vim \
        extra/emacs \
        community/shellcheck

    # UTIL
    pacman --sync --needed \
        community/exa \
        community/fzf \
        community/hexyl \
        community/jq \
        community/moreutils \
        extra/most \
        community/ripgrep \
        extra/tree

    # SYSADMIN
    pacman --sync --needed \
        core/cronie \
        extra/htop \
        community/iotop \
        extra/lsof \
        community/tmux

    # NETWORK OPERATOR
    pacman --sync --needed \
        community/chrony \
        core/curl \
        core/ldns \
        core/openssh \
        extra/rsync

    # PLT
    pacman --sync --needed \
        community/go \
        community/gopls \
        community/go-tools \
        community/staticcheck \
        core/python \
        extra/python{-pip,-virtualenv} \
        community/mypy \
        community/python-black \
        community/python-isort \
        community/bandit \
        community/flake8 \
        community/python-pylint \
        extra/rust \
        community/rust-analyzer \
        community/cargo-{audit,outdated} \
        community/mold \
        community/sccache

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
        community/bpf \
        community/bpftrace \
        community/docker \
        community/docker-compose \
        extra/git \
        community/osquery \
        extra/wireguard-tools

    pacman --files --list \
        openssh \
        | awk --field-separator '[/ ]' '/usr\/lib\/systemd\/.+\/.+\..+[^/]$/ { printf "%-24s%s\n", $1, $NF }'

    pacman --query --owns /etc/bash.bashrc

    ;;
fedora)

    # SHELL
    dnf install \
        bash{,-completion} \
        zsh \
        man-{db,pages} \
        info \
        vim-enhanced \
        emacs \
        ShellCheck

    # UTIL
    dnf install \
        exa \
        fzf \
        hexyl \
        jq \
        moreutils \
        most \
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
        golang-x-tools-{gopls,goimports} \
        golang-honnef-tools \
        python3{,-pip,-virtualenv} \
        python3-mypy \
        black \
        python3-isort \
        bandit \
        python3-flake8 \
        pylint \
        rust \
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
        screenfetch \
        sl

    # DevOps
    dnf install \
        ansible \
        python3-argcomplete \
        bcc-tools \
        python3-bcc \
        bpftool \
        bpftrace \
        docker-compose \
        git \
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

    # SHELL
    apt install \
        bash{,-completion} \
        zsh \
        manpages{,-dev} \
        info \
        vim \
        emacs \
        shellcheck

    # UTIL
    apt install \
        exa \
        fzf \
        hexyl \
        jq \
        moreutils \
        most \
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
        python3{,-pip,-virtualenv} \
        mypy \
        black \
        isort \
        bandit \
        flake8 \
        pylint \
        rustc, \
        rustfmt \
        rust-clippy \
        cargo \
        mold

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
        bpftool \
        bpftrace \
        docker.io \
        docker-compose \
        git \
        wireguard-tools

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
    | LC_ALL=C sort \
    | tee /etc/systemd/system-preset/00-local.preset.raw

systemctl list-units --no-pager --type service
systemctl list-sockets --no-pager --show-types
systemctl list-units --no-pager --type socket
systemctl list-timers --no-pager
systemctl list-units --no-pager --type timer
