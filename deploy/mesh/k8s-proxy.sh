#!/bin/bash

transfer_image () {
    if (( $# != 2 )); then
        return 1
    fi

    local image
    image=$(echo "${1}" | awk --field-separator '/' '{ print $NF }')

    sudo docker image tag "${1}" "${2}/${image}"
    sudo docker image push "${2}/${image}"
    sudo docker image rm "${2}/${image}"
}

## push k8s.gcr.io images to [aliyun]

sudo docker login --username dot.fun@protonmail.com registry.cn-shanghai.aliyuncs.com

arr=()
get_image_list arr
for i in "${arr[@]}"; do
    transfer_image "${i}" registry.cn-shanghai.aliyuncs.com/qubit
done

sudo docker logout registry.cn-shanghai.aliyuncs.com

## push k8s.gcr.io images to [qingcloud]

sudo docker login --username vac dockerhub.qingcloud.com

arr=()
get_image_list arr
for i in "${arr[@]}"; do
    transfer_image "${i}" dockerhub.qingcloud.com/qubit
done

sudo docker logout dockerhub.qingcloud.com
