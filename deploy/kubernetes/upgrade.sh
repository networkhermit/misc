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

clean_up () {
    true
}

trap clean_up EXIT

sudo apt update --list-cleanup

KUBERNETES_VERSION=
if [ -n "${KUBERNETES_VERSION}" ]; then
    for i in kube{adm,ctl,let}; do
        K8S_PKG_VER["${i}"]=$(apt-cache madison "${i}" | grep "${KUBERNETES_VERSION}" | awk '{ print $3 }')
    done
fi

sudo apt install --allow-change-held-packages --assume-yes kubeadm${K8S_PKG_VER:+=${K8S_PKG_VER[kubeadm]}} < /dev/null
sudo apt-mark hold kubeadm
kubeadm config images list --kubernetes-version "$(kubeadm version --output short)"

# primary control plane only
sudo kubeadm upgrade plan
sudo kubeadm upgrade diff "$(kubeadm version --output short)"
sudo kubeadm upgrade apply "$(kubeadm version --output short)" --dry-run
sudo kubeadm upgrade apply "$(kubeadm version --output short)" --yes

sudo apt install --allow-change-held-packages --assume-yes kubectl${K8S_PKG_VER:+=${K8S_PKG_VER[kubectl]}} < /dev/null
sudo apt-mark hold kubectl

# primary control plane only
kubectl --namespace kube-system delete daemonsets kube-proxy

kubectl drain "${HOSTNAME,,}" --delete-local-data --ignore-daemonsets
sudo apt install --allow-change-held-packages --assume-yes kubelet${K8S_PKG_VER:+=${K8S_PKG_VER[kubelet]}} < /dev/null
sudo apt-mark hold kubelet
# [replica control plane] [worker]
sudo kubeadm upgrade node --kubelet-version "$(kubelet --version | cut --delimiter ' ' --fields 2)"
sudo systemctl restart kubelet.service
kubectl uncordon "${HOSTNAME,,}"

apt list kube{adm,ctl,let} --installed
apt-mark showhold
kubectl cluster-info
kubectl get nodes --output wide
kubectl get pods --all-namespaces --output wide

# primary control plane only
sudo rm --force --recursive --verbose /etc/kubernetes/tmp

sudo docker image ls --format '{{.Repository}}:{{.Tag}}' | grep --word-regexp 'k8s.gcr.io' | sort
