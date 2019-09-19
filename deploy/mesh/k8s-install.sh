#!/bin/bash

# review default init configuration
kubeadm config print init-defaults

# initialize master node
install --directory --mode 700 ~/.kube
sudo kubeadm init --apiserver-advertise-address 172.24.0.1 --pod-network-cidr 10.0.0.0/16 --service-cidr 10.96.0.0/12 --kubernetes-version "$(kubeadm version --output short)" --ignore-preflight-errors NumCPU,SystemVerification |& tee ~/.kube/log
sudo systemctl enable kubelet.service

# configure kubectl authentication
## [root user]
(( EUID == 0 )) && export KUBECONFIG=/etc/kubernetes/admin.conf
## [non-root user]
sudo install --mode 600 --owner "$(id --user)" --group "$(id --group)" --preserve-timestamps /etc/kubernetes/admin.conf ~/.kube/config

# install pod network add-on
kubectl apply --filename 'https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml'
kubectl --namespace kube-system delete daemonsets kube-proxy

# remove master node isolation
kubectl taint nodes --all node-role.kubernetes.io/master-

# deploy kubernetes dashboard
kubectl apply --filename 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml'
kubectl create serviceaccount cluster-admin-dashboard --namespace kube-system
kubectl create clusterrolebinding cluster-admin-dashboard --clusterrole cluster-admin --serviceaccount kube-system:cluster-admin-dashboard

# verify cluster status
kubeadm config view
kubectl cluster-info
kubectl get configmaps --namespace kube-system kubeadm-config --output yaml
kubectl get nodes --output wide
kubectl get pods --all-namespaces --output wide

# access kubernetes dashboard
kubectl get secret "$(kubectl get serviceaccount cluster-admin-dashboard --namespace kube-system --output jsonpath='{.secrets[].name}')" --namespace kube-system --output jsonpath="{.data['token']}" | base64 --decode && echo
echo 'http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy'
kubectl proxy

# update kubernetes dashboard
kubectl delete "$(kubectl get pod --namespace kube-system --output name | grep --word-regexp 'kubernetes-dashboard')" --namespace kube-system

# review default join configuration
kubeadm config print join-defaults

# join node to cluster
install --directory --mode 700 ~/.kube
sudo kubeadm join '<MASTER-IP>':'<MASTER-PORT>' --token '<TOKEN>' --discovery-token-ca-cert-hash sha256:'<HASH>' --ignore-preflight-errors NumCPU,SystemVerification |& tee ~/.kube/log
sudo systemctl enable kubelet.service

# create new token after current token expired
sudo kubeadm token list
sudo kubeadm token create --print-join-command
sudo openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt \
    | openssl rsa -pubin -outform der 2> /dev/null \
    | openssl dgst -sha256 -hex | sed 's/^.* //'

# revert deployment changes
kubectl get nodes --output wide
kubectl drain "${HOSTNAME,,}" --delete-local-data --force --ignore-daemonsets
kubectl delete node "${HOSTNAME,,}"
sudo kubeadm reset --force
sudo ipvsadm --clear
sudo systemctl disable --now kubelet.service
find ~/.kube -delete
