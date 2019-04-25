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

## push k8s.gcr.io images to [${REGISTRY}]

sudo docker login --username "${USERNAME}" "${REGISTRY}"

arr=()
get_image_list arr
for i in "${arr[@]}"; do
    transfer_image "${i}" "${REGISTRY}/${NAMESPACE}"
done

sudo docker logout "${REGISTRY}"
