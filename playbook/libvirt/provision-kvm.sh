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
    ${0##*/} [OPTION]... DISTRO NAME

Options:
    --cpu N
        number of virtual cpus to configure for the guest (default: ${CPU})
    --bridge INTERFACE
        bridge interface to use if you don't want to use NAT
    --directory DIRECTORY
        directory to store the disk image (default: ${DIRECTORY})
    --memory N (MiB)
        memory to allocate for the guest (default: ${MEMORY})
    --size N (GiB)
        size of the disk image to be created (default: ${SIZE})
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit

Arguments:
    DISTRO
        linux/bsd distro name (arch | fedora | kali | freebsd)
    NAME
        name of the new guest virtual machine instance
EOF
}

CPU=4
DIRECTORY=/var/lib/libvirt/images
MEMORY=8192
SIZE=40

while (( $# > 0 )); do
    case ${1} in
    --cpu)
        CPU=${2?✗ option parsing failed: missing value for argument ‘${1}’}
        shift 2
        ;;
    --bridge)
        BRIDGE=${2?✗ option parsing failed: missing value for argument ‘${1}’}
        shift 2
        ;;
    --directory)
        DIRECTORY=${2?✗ option parsing failed: missing value for argument ‘${1}’}
        shift 2
        ;;
    --memory)
        MEMORY=${2?✗ option parsing failed: missing value for argument ‘${1}’}
        shift 2
        ;;
    --size)
        SIZE=${2?✗ option parsing failed: missing value for argument ‘${1}’}
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

DISTRO=${1?✗ argument parsing failed: missing argument ‘DISTRO’}
NAME=${2?✗ argument parsing failed: missing argument ‘NAME’}
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

EXTRA_ARGUMENT=()

KERNEL_ARGUMENT=(--extra-args 'console=ttyS0,115200n8 nameserver=1.0.0.1')

case ${DISTRO} in
arch)
    IMAGE=$(find "${DIRECTORY}" -type f -name 'archlinux-*.*.*-x86_64.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant archlinux)
    ;;
fedora)
    EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/39/Server/x86_64/os)
    EXTRA_ARGUMENT+=("${KERNEL_ARGUMENT[@]}")
    EXTRA_ARGUMENT+=(--os-variant fedora-rawhide)
    ;;
kali)
    EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/kali/dists/kali-rolling/main/installer-amd64)
    EXTRA_ARGUMENT+=("${KERNEL_ARGUMENT[@]}")
    EXTRA_ARGUMENT+=(--os-variant debiantesting)
    ;;
freebsd)
    IMAGE=$(find "${DIRECTORY}" -type f -name 'FreeBSD-*.*-RELEASE-amd64-disc1.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant freebsd14.0)
    ;;
*)
    die "✗ unknown distro: ‘${DISTRO}’"
    ;;
esac

if [[ -z "${BRIDGE}" ]]; then
    NETWORK_OPTION=model=virtio,network=default
else
    NETWORK_OPTION=bridge=${BRIDGE}
fi

if [[ -x "$(command -v numad)" ]]; then
    VCPUS_OPTION=cpuset=auto,vcpus=${CPU}
else
    VCPUS_OPTION=vcpus=${CPU}
fi

virt-install \
    --autostart \
    --boot uefi \
    --connect qemu:///system \
    --console type=pty,target.type=serial \
    --cpu host \
    --disk "device=disk,format=qcow2,path=${DIRECTORY}/${NAME}.qcow2,size=${SIZE}" \
    --graphics none \
    --hvm \
    --memory "${MEMORY}" \
    --name "${NAME}" \
    --network "${NETWORK_OPTION}" \
    --vcpus "${VCPUS_OPTION}" \
    --virt-type kvm \
    "${EXTRA_ARGUMENT[@]}"
