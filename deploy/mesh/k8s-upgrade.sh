#!/bin/bash

sudo apt update --list-cleanup

sudo apt install --allow-change-held-packages --assume-yes kubeadm < /dev/null
sudo apt-mark hold kubeadm

kubeadm config images list --kubernetes-version "$(kubeadm version --output short)"

# master node only
sudo kubeadm upgrade plan
sudo kubeadm upgrade apply "$(kubeadm version --output short)" --yes

sudo apt install --allow-change-held-packages --assume-yes kubectl < /dev/null
sudo apt-mark hold kubectl

# master node only
kubectl --namespace kube-system delete daemonsets kube-proxy

kubectl drain "${HOSTNAME,,}" --delete-local-data --ignore-daemonsets

sudo apt install --allow-change-held-packages --assume-yes kubelet < /dev/null
sudo apt-mark hold kubelet

# worker node only
sudo kubeadm upgrade node config --kubelet-version "$(kubelet --version | cut -d ' ' -f 2)"

sudo systemctl restart kubelet.service

kubectl uncordon "${HOSTNAME,,}"

kubectl cluster-info
kubectl get nodes --output wide
kubectl get pods --all-namespaces --output wide

# master node only
sudo rm -frv /etc/kubernetes/tmp

sudo docker image ls --format '{{.Repository}}:{{.Tag}}' | grep -w 'k8s.gcr.io' | sort
