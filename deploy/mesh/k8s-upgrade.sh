#!/bin/bash

KUBERNETES_VERSION=''

sudo apt update --list-cleanup

if [ -n "${KUBERNETES_VERSION}" ]; then
    for i in kube{adm,ctl,let}; do
        K8S_PKG_VER["${i}"]=$(apt-cache madison "${i}" | grep "${KUBERNETES_VERSION}" | awk '{ print $3 }')
    done
fi

sudo apt install --allow-change-held-packages --assume-yes kubeadm${K8S_PKG_VER:+=${K8S_PKG_VER[kubeadm]}} < /dev/null
sudo apt-mark hold kubeadm

kubeadm config images list --kubernetes-version "$(kubeadm version --output short)"

# master node only
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply "$(kubeadm version --output short)" --yes

sudo apt install --allow-change-held-packages --assume-yes kubectl${K8S_PKG_VER:+=${K8S_PKG_VER[kubectl]}} < /dev/null
sudo apt-mark hold kubectl

# master node only
kubectl --namespace kube-system delete daemonsets kube-proxy

kubectl drain "${HOSTNAME,,}" --delete-local-data --ignore-daemonsets

sudo apt install --allow-change-held-packages --assume-yes kubelet${K8S_PKG_VER:+=${K8S_PKG_VER[kubelet]}} < /dev/null
sudo apt-mark hold kubelet

# worker node only
sudo kubeadm upgrade node config --kubelet-version "$(kubelet --version | cut --delimiter ' ' --fields 2)"

sudo systemctl restart kubelet.service

kubectl uncordon "${HOSTNAME,,}"

kubectl cluster-info
kubectl get nodes --output wide
kubectl get pods --all-namespaces --output wide

# master node only
sudo rm --force --recursive --verbose /etc/kubernetes/tmp

sudo docker image ls --format '{{.Repository}}:{{.Tag}}' | grep --word-regexp 'k8s.gcr.io' | sort
