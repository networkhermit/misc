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

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl get certificatesigningrequests --sort-by '{.metadata.creationTimestamp}'
# kubectl certificate approve csr-abcde
kubectl get certificatesigningrequests \
    --output jsonpath='{.items[?(@.spec.signerName=="kubernetes.io/kubelet-serving")].metadata.name}' \
    | xargs --max-args 1 --no-run-if-empty kubectl certificate approve

# install pod network add-on
## cilium
cilium install --helm-values ../../infra/manifest/cilium.yaml --version 1.13.2 |& tee /etc/kubernetes/cilium.log

kubectl --namespace kube-system rollout restart deployment coredns

cilium hubble enable --ui

kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/1.13.2/examples/kubernetes/addons/prometheus/monitoring-example.yaml

kubectl apply --filename https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
kubectl --namespace kubernetes-dashboard create serviceaccount cluster-admin-dashboard
kubectl create clusterrolebinding cluster-admin-dashboard --clusterrole cluster-admin --serviceaccount kubernetes-dashboard:cluster-admin-dashboard

for component in cluster-role-binding cluster-role deployment service-account service; do
    kubectl apply --filename "https://raw.githubusercontent.com/kubernetes/kube-state-metrics/v2.8.2/examples/standard/${component}.yaml"
done

kubectl apply --filename https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.3/components.yaml

kubectl apply --filename https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cert-manager.yaml

kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.0/deploy/static/provider/baremetal/deploy.yaml

istioctl install --skip-confirmation
# https://istio.io/latest/docs/setup/getting-started
kubectl create namespace istio-demo
kubectl label namespace istio-demo istio-injection=enabled
kubectl --namespace istio-demo apply --filename samples/bookinfo/platform/kube/bookinfo.yaml
kubectl --namespace istio-demo apply --filename samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl --namespace istio-demo apply --filename samples/addons

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm install rancher rancher-stable/rancher \
    --create-namespace \
    --namespace cattle-system \
    --set hostname=rancher.cncf.site \
    --set bootstrapPassword=admin \
    --version 2.7.2
# helm pull rancher-stable/rancher
