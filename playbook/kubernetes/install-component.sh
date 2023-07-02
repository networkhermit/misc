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

kubectl --namespace kube-system rollout restart deployment coredns

kubectl --namespace kubernetes-dashboard create serviceaccount cluster-admin-dashboard
kubectl create clusterrolebinding cluster-admin-dashboard --clusterrole cluster-admin --serviceaccount kubernetes-dashboard:cluster-admin-dashboard

# https://istio.io/latest/docs/setup/getting-started
kubectl create namespace istio-demo
kubectl label namespace istio-demo istio-injection=enabled
kubectl --namespace istio-demo apply --filename samples/bookinfo/platform/kube/bookinfo.yaml
kubectl --namespace istio-demo apply --filename samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl --namespace istio-demo apply --filename samples/addons
