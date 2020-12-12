#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

trap 'echo ✗ fatal error: errexit trapped with status $? 1>&2' ERR

if (( EUID != 0 )); then
    echo '✗ This script must be run as root' 1>&2
    exit 1
fi

REGISTRY=gcr

while (( $# > 0 )); do
    case ${1} in
    --registry)
        : "${2?✗ argument parsing failed: missing parameter for argument ‘${1}’}"
        case ${2} in
        gcr | aliyun-registry)
            REGISTRY=${2}
            shift 2
            ;;
        *)
            echo "✗ argument parsing failed: acceptable values for ‘${1}’ are gcr | aliyun-registry" 1>&2
            exit 1
            ;;
        esac
        ;;
    -h | --help)
        cat << EOF
Usage:
    ${0##*/} [OPTION]...

Optional arguments:
    --registry REGISTRY (gcr | aliyun-registry)
        container registry to pull images from (default: gcr)
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

get_image_list () {
    if (( $# != 1 )); then
        return 1
    fi

    local -n arr_ref=${1}

    arr_ref=()
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(kubeadm config images list --kubernetes-version "$(kubeadm version --output short)")
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --fail --location --silent --show-error 'https://raw.githubusercontent.com/cilium/cilium/1.9.1/install/kubernetes/quick-install.yaml' | awk '/\<image:\s*k8s.gcr.io\// { print $NF }')
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --fail --location --silent --show-error 'https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml' | awk '/\<image:\s*k8s.gcr.io\// { print $NF }')
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --fail --location --silent --show-error 'https://raw.githubusercontent.com/kubernetes/dashboard/v2.1.0/aio/deploy/recommended.yaml' | awk '/\<image:\s*k8s.gcr.io\// { print $NF }')
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --fail --location --silent --show-error 'https://github.com/kubernetes/kube-state-metrics/blob/v1.9.7/examples/standard/deployment.yaml' | awk '/\<image:\s*k8s.gcr.io\// { print $NF }')
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --fail --location --silent --show-error 'https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml' | awk '/\<image:\s*k8s.gcr.io\// { print $NF }')
}

construct_image () {
    if (( $# != 2 )); then
        return 1
    fi

    local image
    image=$(awk --field-separator / '{ print $NF }' <<< "${1}")

    docker image pull "${2}/${image}"
    docker image tag "${2}/${image}" "${1}"
    docker image rm "${2}/${image}"
}

# list container images
arr=()
get_image_list arr
printf '%s\n' "${arr[@]}"

# pull container images
case ${REGISTRY} in
gcr)
    kubeadm config images pull --kubernetes-version "$(kubeadm version --output short)"
    printf '%s\0' "${arr[@]}" | xargs --max-args 1 --no-run-if-empty --null docker image pull
    ;;
*)
    for i in "${arr[@]}"; do
        construct_image "${i}" registry.aliyuncs.com/google_containers
    done
    ;;
esac

# inspect container images
printf '%s\0' "${arr[@]}" | xargs --max-args 1 --no-run-if-empty --null docker image inspect --format '{{.Id}} {{.RepoTags}}'
