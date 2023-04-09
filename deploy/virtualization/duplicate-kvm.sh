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
    ${0##*/} [OPTION]... SOURCE TARGET

Options:
    --directory DIRECTORY
        directory to store the disk image (default: /var/local/images)
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit

Arguments:
    SOURCE
        name of the original guest to be cloned
    TARGET
        name of the new guest virtual machine instance
EOF
}

DIRECTORY=/var/local/images

while (( $# > 0 )); do
    case ${1} in
    --directory)
        DIRECTORY=${2?✗ option parsing failed: missing value for argument ‘${1}’}
        shift 2
        ;;
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

SOURCE=${1?✗ argument parsing failed: missing argument ‘SOURCE’}
TARGET=${2?✗ argument parsing failed: missing argument ‘TARGET’}
shift 2

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

virt-clone \
    --file "${DIRECTORY}/${TARGET}.qcow2" \
    --name "${TARGET}" \
    --original "${SOURCE}"
