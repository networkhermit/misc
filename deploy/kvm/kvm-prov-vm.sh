#!/bin/bash

if (( EUID != 0 )); then
    echo "✗ This script must be run as root" 1>&2
    exit 1
fi

if (( $# != 2 )); then
    exit
fi

EXTRA_ARGUMENT=()

INSTALLER_PARAMETER=(--extra-args 'console=ttyS0,115200n8 nameserver=1.0.0.1')

case "${1}" in
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
        echo "✗ unknown distro: ‘${1}’" 1>&2
        exit
        ;;
esac

virt-install \
    --connect qemu:///system \
    --console pty,target_type=serial \
    --cpu host \
    --disk format=qcow2,path="/var/local/images/${2}.img",size=20 \
    --features kvm_hidden=off \
    --graphics none \
    --hvm \
    --memory 2048 \
    --name "${2}" \
    --network network=default \
    --os-type linux \
    --vcpus 2,maxvcpus=4 \
    --virt-type kvm \
    "${EXTRA_ARGUMENT[@]}"
