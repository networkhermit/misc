#!/bin/bash

get_image_list () {
    if (( $# != 1 )); then
        return 1
    fi

    local -n arr_ref=$1

    arr_ref=()
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(kubeadm config images list --kubernetes-version "$(kubeadm version --output short)")
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --location --silent 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml' | awk '/\<image\>/ { print $2 }')
    mapfile -O ${#arr_ref[@]} -t arr_ref < <(curl --location --silent 'https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8+/metrics-server-deployment.yaml' | awk '/\<image\>/ { print $2 }')
}

construct_image () {
    if (( $# != 2 )); then
        return 1
    fi

    local image
    image=$(echo "${1}" | awk --field-separator '/' '{ print $NF }')

    sudo docker image pull "${2}/${image}"
    sudo docker image tag "${2}/${image}" "${1}"
    sudo docker image rm "${2}/${image}"
}

# print k8s.gcr.io images kubernetes will use
arr=()
get_image_list arr
printf '%s\n' "${arr[@]}"

## pull container images from [gcr]
sudo kubeadm config images pull --kubernetes-version "$(kubeadm version --output short)"
arr=()
get_image_list arr
printf '%s\0' "${arr[@]}" | xargs --max-args 1 --null sudo docker image pull

## pull container images from [azure]
arr=()
get_image_list arr
for i in "${arr[@]}"; do
    construct_image "${i}" gcr.azk8s.cn/google_containers
done

## pull container images from [aliyun]
arr=()
get_image_list arr
for i in "${arr[@]}"; do
    construct_image "${i}" registry.cn-shanghai.aliyuncs.com/qubit
done

## pull container images from [qingcloud]
sudo docker login --username sherlock --password-stdin dockerhub.qingcloud.com <<< 'IoSiUICUCHXzJ53sF0qJqC1vNJGfTyze'
arr=()
get_image_list arr
for i in "${arr[@]}"; do
    construct_image "${i}" dockerhub.qingcloud.com/qubit
done
sudo docker logout dockerhub.qingcloud.com

# inspect container images
arr=()
get_image_list arr
printf '%s\0' "${arr[@]}" | xargs --max-args 1 --null sudo docker image inspect --format '{{.Id}} {{.RepoTags}}'
