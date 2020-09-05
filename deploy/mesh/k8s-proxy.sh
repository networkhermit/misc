#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

trap 'echo ✗ fatal error: errexit trapped with status $? 1>&2' ERR

while (( $# > 0 )); do
    case ${1} in
    -h | --help)
        cat << EOF
Usage:
    ${0##*/} [OPTION]...

Optional arguments:
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

transfer_image () {
    if (( $# != 2 )); then
        return 1
    fi

    local image
    image=$(awk --field-separator / '{ print $NF }' <<< "${1}")

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
