#!/bin/bash

# trust google cloud package signing key
## google repository
curl --location https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
## azure repository
curl --location https://mirror.azure.cn/kubernetes/packages/apt/doc/apt-key.gpg | sudo apt-key add -

# add kubernetes repository
## [official]
SOURCE_URI='https://packages.cloud.google.com/apt'
## [azure]
SOURCE_URI='https://mirror.azure.cn/kubernetes/packages/apt'
## [ustc]
SOURCE_URI='https://mirrors.ustc.edu.cn/kubernetes/apt'
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
sudo apt-mark showhold
sudo systemctl disable --now kubelet.service

# configure kernel parameter
sudo tee /etc/sysctl.d/k8s.conf << 'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
