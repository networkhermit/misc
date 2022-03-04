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

kubeadm config print init-defaults --component-configs KubeletConfiguration,KubeProxyConfiguration

install --mode 600 /dev/null /etc/kubernetes/kubeadm.log
#kubeadm init \
#    --apiserver-advertise-address 172.20.16.10 \
#    --control-plane-endpoint k8s.cncf.site \
#    --cri-socket /run/containerd/containerd.sock \
#    --image-repository k8s.gcr.io \
#    --kubernetes-version "$(kubeadm version --output short)" \
#    --pod-network-cidr 10.0.0.0/16 \
#    --service-cidr 10.96.0.0/12 \
#    |& tee /etc/kubernetes/kubeadm.log
kubeadm init --config manifest/kubeadm-init-control-plane.yaml --upload-certs |& tee /etc/kubernetes/kubeadm.log
#kubeadm init --config manifest/kubeadm-init-control-plane.yaml --skip-phases addon/kube-proxy |& tee /etc/kubernetes/kubeadm.log
systemctl enable kubelet.service

export KUBECONFIG=/etc/kubernetes/admin.conf

# install pod network add-on
## cilium
cilium install --version v1.11.2

# remove master node isolation
kubectl taint nodes --all node-role.kubernetes.io/master-
