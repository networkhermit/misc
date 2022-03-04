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

# trust google cloud package signing key
## google repository
curl --fail --location --silent --show-error --output /etc/apt/trusted.gpg.d/kubernetes.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
## aliyun repository
curl --fail --location --silent --show-error --output /etc/apt/trusted.gpg.d/kubernetes.gpg https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg

# add kubernetes repository
echo /etc/apt/sources.list.d/kubernetes.list

KUBERNETES_VERSION=

# install kubernetes packages
apt update --list-cleanup
if [ -n "${KUBERNETES_VERSION}" ]; then
    for i in kube{adm,ctl,let}; do
        K8S_PKG_VER["${i}"]=$(apt-cache madison "${i}" | grep "${KUBERNETES_VERSION}" | awk '{ print $3 }')
    done
fi
apt install --allow-change-held-packages --assume-yes \
    kubeadm${K8S_PKG_VER:+=${K8S_PKG_VER[kubeadm]}} \
    kubectl${K8S_PKG_VER:+=${K8S_PKG_VER[kubectl]}} \
    kubelet${K8S_PKG_VER:+=${K8S_PKG_VER[kubelet]}} \
    < /dev/null
apt-mark hold kube{adm,ctl,let}
apt list kube{adm,ctl,let} --installed
apt-mark showhold

systemctl disable --now kubelet.service
