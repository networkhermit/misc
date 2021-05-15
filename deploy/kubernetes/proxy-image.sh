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

if (( EUID != 0 )); then
    die '✗ This script must be run as root'
fi

clean_up () {
    true
}

trap clean_up EXIT

transfer_image () {
    if (( $# != 2 )); then
        return 1
    fi

    local image
    image=$(awk --field-separator / '{ print $NF }' <<< "${1}")

    docker image tag "${1}" "${2}/${image}"
    docker image push "${2}/${image}"
    docker image rm "${2}/${image}"
}

## push k8s.gcr.io images to [${REGISTRY}]

docker login --username "${USERNAME}" "${REGISTRY}"

arr=()
get_image_list arr
for i in "${arr[@]}"; do
    transfer_image "${i}" "${REGISTRY}/${NAMESPACE}"
done

docker logout "${REGISTRY}"
