#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

trap 'echo ✗ fatal error: errexit trapped with status $? 1>&2' ERR

while (( $# > 0 )); do
    case "${1}" in
        -h | --help)
            cat << EOF
Usage:
    ${0##*/} [OPTION]...

Optional arguments:
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit
EOF
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
    echo "✗ argument parsing failed: unrecognizable argument ‘${1}’" 1>&2
    exit 1
fi

# trust google cloud package signing key
## google repository
curl --fail --location --silent --show-error https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
## aliyun repository
curl --fail --location --silent --show-error https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
sudo rm --force --recursive /etc/apt/trusted.gpg~

# add kubernetes repository
## [official]
SOURCE_URI='https://packages.cloud.google.com/apt'
## [aliyun]
SOURCE_URI='https://mirrors.aliyun.com/kubernetes/apt'
sudo tee /etc/apt/sources.list.d/kubernetes.list << EOF
deb ${SOURCE_URI} kubernetes-xenial main
EOF

KUBERNETES_VERSION=''

# install kubernetes packages
sudo apt update --list-cleanup
if [ -n "${KUBERNETES_VERSION}" ]; then
    for i in kube{adm,ctl,let}; do
        K8S_PKG_VER["${i}"]=$(apt-cache madison "${i}" | grep "${KUBERNETES_VERSION}" | awk '{ print $3 }')
    done
fi
sudo apt install --allow-change-held-packages --assume-yes \
    kubeadm${K8S_PKG_VER:+=${K8S_PKG_VER[kubeadm]}} \
    kubectl${K8S_PKG_VER:+=${K8S_PKG_VER[kubectl]}} \
    kubelet${K8S_PKG_VER:+=${K8S_PKG_VER[kubelet]}} \
    < /dev/null
sudo apt-mark hold kube{adm,ctl,let}
apt list kube{adm,ctl,let} --installed
apt-mark showhold
sudo systemctl disable --now kubelet.service

# configure kernel parameter
sudo tee /etc/sysctl.d/k8s.conf << 'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
