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

# review default init configuration
sudo kubeadm config print init-defaults

# initialize master node
install --directory --mode 700 ~/.kube
#sudo kubeadm init --apiserver-advertise-address 172.24.0.1 --control-plane-endpoint k8s-raddest --cri-socket /run/containerd/containerd.sock --pod-network-cidr 10.0.0.0/16 --service-cidr 10.96.0.0/12 --kubernetes-version "$(kubeadm version --output short)" |& tee ~/.kube/log
sudo kubeadm init --config kubeadm-config.yaml |& tee ~/.kube/log
sudo systemctl enable kubelet.service

# configure kubectl authentication
## [root user]
(( EUID == 0 )) && export KUBECONFIG=/etc/kubernetes/admin.conf
## [non-root user]
sudo install --group "$(id --group)" --mode 600 --owner "$(id --user)" --preserve-timestamps /etc/kubernetes/admin.conf ~/.kube/config

# install pod network add-on
## cilium
kubectl apply --filename https://raw.githubusercontent.com/cilium/cilium/1.9.1/install/kubernetes/quick-install.yaml
## kuberouter
#kubectl apply --filename https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml
#kubectl --namespace kube-system delete daemonsets kube-proxy

# remove master node isolation
kubectl taint nodes --all node-role.kubernetes.io/master-

# deploy kubernetes dashboard
kubectl apply --filename https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml
kubectl create serviceaccount cluster-admin-dashboard --namespace kubernetes-dashboard
kubectl create clusterrolebinding cluster-admin-dashboard --clusterrole cluster-admin --serviceaccount kubernetes-dashboard:cluster-admin-dashboard

# verify cluster status
kubectl cluster-info
kubectl get configmaps --namespace kube-system kubeadm-config --output yaml
kubectl get nodes --output wide
kubectl get pods --all-namespaces --output wide

# access kubernetes dashboard
kubectl get secret "$(kubectl get serviceaccount cluster-admin-dashboard --namespace kube-system --output jsonpath='{.secrets[].name}')" --namespace kube-system --output jsonpath="{.data['token']}" | base64 --decode && echo
echo http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy
kubectl proxy

# update kubernetes dashboard
kubectl delete "$(kubectl get pod --namespace kube-system --output name | grep --word-regexp 'kubernetes-dashboard')" --namespace kube-system

# review default join configuration
kubeadm config print join-defaults

# join node to cluster
install --directory --mode 700 ~/.kube
sudo kubeadm join "${CONTROL_PLANE_ENDPOINT}:${CONTROL_PLANE_PORT}" --discovery-token-ca-cert-hash "sha256:${HASH}" --token "${TOKEN}" |& tee ~/.kube/log
sudo systemctl enable kubelet.service

# create new token after current token expired
sudo kubeadm token list
sudo kubeadm token create
sudo openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt \
    | openssl rsa -pubin -outform der 2> /dev/null \
    | openssl dgst -sha256 -hex | sed 's/^.* //'

# revert deployment changes
kubectl get nodes --output wide
kubectl drain "${HOSTNAME,,}" --delete-emptydir-data --force --ignore-daemonsets
kubectl delete node "${HOSTNAME,,}"
sudo kubeadm reset --force
sudo ipvsadm --clear
sudo systemctl disable --now kubelet.service
find ~/.kube -delete
