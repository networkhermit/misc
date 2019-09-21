#!/bin/bash

get_image_list () {
    if (( $# != 1 )); then
        return 1
    fi

    local -n arr_ref=${1}

    arr_ref=()
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(kubeadm config images list --kubernetes-version "$(kubeadm version --output short)")
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --fail --location --silent --show-error 'https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/kubeadm-kuberouter-all-features.yaml' | awk '/\<image:\s*k8s.gcr.io\// { print $2 }')
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --fail --location --silent --show-error 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml' | awk '/\<image:\s*k8s.gcr.io\// { print $2 }')
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --fail --location --silent --show-error 'https://raw.githubusercontent.com/kubernetes/kube-state-metrics/master/kubernetes/kube-state-metrics-deployment.yaml' | awk '/\<image:\s*k8s.gcr.io\// { print $2 }')
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --fail --location --silent --show-error 'https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8+/metrics-server-deployment.yaml' | awk '/\<image:\s*k8s.gcr.io\// { print $2 }')
}

construct_image () {
    if (( $# != 2 )); then
        return 1
    fi

    local image
    image=$(awk --field-separator '/' '{ print $NF }' <<< "${1}")

    sudo docker image pull "${2}/${image}"
    sudo docker image tag "${2}/${image}" "${1}"
    sudo docker image rm "${2}/${image}"
}

# list container images
arr=()
get_image_list arr
printf '%s\n' "${arr[@]}"

# pull container images
## [gcr]
sudo kubeadm config images pull --kubernetes-version "$(kubeadm version --output short)"
printf '%s\0' "${arr[@]}" | xargs --max-args 1 --null sudo docker image pull
## [azure]
for i in "${arr[@]}"; do
    construct_image "${i}" gcr.azk8s.cn/google_containers
done

# inspect container images
printf '%s\0' "${arr[@]}" | xargs --max-args 1 --null sudo docker image inspect --format '{{.Id}} {{.RepoTags}}'
