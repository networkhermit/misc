#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

trap 'echo ✗ fatal error: errexit trapped with status $? 1>&2' ERR

if (( EUID != 0 )); then
    echo "✗ This script must be run as root" 1>&2
    exit 1
fi

DIRECTORY=/var/local/images

while (( $# > 0 )); do
    case "${1}" in
        --directory)
            DIRECTORY=${2?✗ argument parsing failed: missing parameter for argument ‘${1}’}
            shift 2
            ;;
        -h | --help)
            cat << EOF
Usage:
    ${0##*/} [OPTION]... SOURCE TARGET

Optional arguments:
    --directory DIRECTORY
        directory to store the disk image (default: /var/local/images)
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit

Positional arguments:
    SOURCE
        name of the original guest to be cloned
    TARGET
        name of the new guest virtual machine instance
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

SOURCE=${1?✗ argument parsing failed: missing positional argument ‘SOURCE’}
TARGET=${2?✗ argument parsing failed: missing positional argument ‘TARGET’}
shift 2

if (( $# > 0 )); then
    echo "✗ argument parsing failed: unrecognizable argument ‘${1}’" 1>&2
    exit 1
fi

virt-clone \
    --file "${DIRECTORY}/${TARGET}.qcow2" \
    --name "${TARGET}" \
    --original "${SOURCE}"
