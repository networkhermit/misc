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

export KUBECONFIG=/etc/kubernetes/admin.conf

apt update --list-cleanup

KUBERNETES_VERSION=
if [[ -n "${KUBERNETES_VERSION}" ]]; then
    for i in kube{adm,ctl,let}; do
        K8S_PKG_VER["${i}"]=$(apt-cache madison "${i}" | grep "${KUBERNETES_VERSION}" | awk '{ print $3 }')
    done
fi

apt install --allow-change-held-packages --assume-yes kubeadm${K8S_PKG_VER:+=${K8S_PKG_VER[kubeadm]}} < /dev/null
apt-mark hold kubeadm
kubeadm config images list --kubernetes-version "$(kubeadm version --output short)"

# [primary control plane]
kubeadm upgrade plan
kubeadm upgrade diff "$(kubeadm version --output short)"
kubeadm upgrade apply "$(kubeadm version --output short)" --dry-run
kubeadm upgrade apply "$(kubeadm version --output short)" --yes

# [replica control plane] [worker]
kubeadm upgrade node --dry-run
kubeadm upgrade node

kubectl drain "${HOSTNAME,,}" --delete-emptydir-data --ignore-daemonsets
apt install --allow-change-held-packages --assume-yes kubelet${K8S_PKG_VER:+=${K8S_PKG_VER[kubelet]}} kubectl${K8S_PKG_VER:+=${K8S_PKG_VER[kubectl]}} < /dev/null
apt-mark hold kubelet kubectl
systemctl restart kubelet.service
kubectl uncordon "${HOSTNAME,,}"

apt list kube{adm,ctl,let} --installed
apt-mark showhold

# control plane
rm --force --recursive --verbose /etc/kubernetes/tmp

crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock rmi --prune
