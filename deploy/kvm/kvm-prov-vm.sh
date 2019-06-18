#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

if (( EUID != 0 )); then
    echo "✗ This script must be run as root" 1>&2
    exit 1
fi

ARGC=4
LEAST_ARGC=2

if (( $# > ARGC )); then
    echo "✗ number of arguments exceeds limit: ‘${#}/${ARGC}’" 1>&2
    exit 1
elif (( $# < LEAST_ARGC )); then
    echo "✗ too few arguments: ‘${#}/${LEAST_ARGC}’" 1>&2
    exit 1
fi

DISTRO=${1}

NAME=${2}
CPU=${3:-4}
MEMORY=${4:-8192}

EXTRA_ARGUMENT=()

INSTALLER_PARAMETER=(--extra-args 'console=ttyS0,115200n8 nameserver=1.0.0.1')

case "${DISTRO}" in
    arch)
        IMAGE=$(find images/ -type f -name 'archlinux-*-x86_64.iso' | sort --version-sort | tail --lines 1)

        EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
        EXTRA_ARGUMENT+=(--os-variant auto)
        ;;
    fedora)
        EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/29/Server/x86_64/os)
        EXTRA_ARGUMENT+=("${INSTALLER_PARAMETER[@]}")
        EXTRA_ARGUMENT+=(--os-variant fedora29)
        ;;
    kali)
        EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/kali/dists/kali-rolling/main/installer-amd64)
        EXTRA_ARGUMENT+=("${INSTALLER_PARAMETER[@]}")
        EXTRA_ARGUMENT+=(--os-variant debiantesting)
        ;;
    ubuntu)
        EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/ubuntu/dists/bionic/main/installer-amd64)
        EXTRA_ARGUMENT+=("${INSTALLER_PARAMETER[@]}")
        EXTRA_ARGUMENT+=(--os-variant ubuntu18.04)
        ;;
    *)
        echo "✗ unknown distro: ‘${DISTRO}’" 1>&2
        exit
        ;;
esac

virt-install \
    --connect qemu:///system \
    --console char_type=pty,target_type=serial \
    --cpu host \
    --disk device=disk,format=qcow2,path="/var/local/images/${NAME}.img",size=40 \
    --features kvm_hidden=off \
    --graphics none \
    --hvm \
    --memory "${MEMORY}" \
    --name "${NAME}" \
    --network model=virtio,network=default \
    --os-type linux \
    --vcpus cpuset=auto,vcpus="${CPU}" \
    --virt-type kvm \
    --autostart \
    "${EXTRA_ARGUMENT[@]}"
