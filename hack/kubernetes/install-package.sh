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

# trust kubernetes package signing key
curl --fail --location --silent --show-error https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key \
    | gpg --dearmor --output /etc/apt/keyrings/kubernetes-archive-keyring.gpg

# add kubernetes repository
(
pushd "$(dirname "$(realpath "${0}")")" &> /dev/null
install -D --mode 644 --target-directory /etc/apt/sources.list.d "$(git rev-parse --show-toplevel)/config/etc/apt/sources.list.d/kubernetes.list"
)

KUBERNETES_VERSION=

# install kubernetes packages
apt update --list-cleanup
if [[ -n "${KUBERNETES_VERSION}" ]]; then
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
