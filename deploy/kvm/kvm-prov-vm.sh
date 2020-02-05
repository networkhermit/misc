#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

trap 'echo ✗ fatal error: errexit trapped with status $? 1>&2' ERR

if (( EUID != 0 )); then
    echo "✗ This script must be run as root" 1>&2
    exit 1
fi

CPU=4
DIRECTORY=/var/local/images
MEMORY=8192
SIZE=40

while (( $# > 0 )); do
    case "${1}" in
        --cpu)
            CPU=${2?✗ argument parsing failed: missing parameter for argument ‘${1}’}
            shift 2
            ;;
        --directory)
            DIRECTORY=${2?✗ argument parsing failed: missing parameter for argument ‘${1}’}
            shift 2
            ;;
        --memory)
            MEMORY=${2?✗ argument parsing failed: missing parameter for argument ‘${1}’}
            shift 2
            ;;
        --size)
            SIZE=${2?✗ argument parsing failed: missing parameter for argument ‘${1}’}
            shift 2
            ;;
        -h | --help)
            cat << EOF
Usage:
    ${0##*/} [OPTION]... DISTRO NAME

Optional arguments:
    --cpu N
        number of virtual cpus to configure for the guest (default: 4)
    --directory DIRECTORY
        directory to store the disk image (default: /var/local/images)
    --memory N (MiB)
        memory to allocate for the guest (default: 8192)
    --size N (GiB)
        size of the disk image to be created (default: 40)
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit

Positional arguments:
    DISTRO
        linux distro name (arch | fedora | kali | opensuse | ubuntu)
    NAME
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

DISTRO=${1?✗ argument parsing failed: missing positional argument ‘DISTRO’}
NAME=${2?✗ argument parsing failed: missing positional argument ‘NAME’}
shift 2

if (( $# > 0 )); then
    echo "✗ argument parsing failed: unrecognizable argument ‘${1}’" 1>&2
    exit 1
fi

EXTRA_ARGUMENT=()

INSTALLER_PARAMETER=(--extra-args 'console=ttyS0,115200n8 nameserver=1.0.0.1')

case "${DISTRO}" in
    arch)
        IMAGE=$(find images/ -type f -name 'archlinux-*-x86_64.iso' | sort --version-sort | tail --lines 1)

        EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
        EXTRA_ARGUMENT+=(--os-variant auto)
        ;;
    fedora)
        EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/31/Server/x86_64/os)
        EXTRA_ARGUMENT+=("${INSTALLER_PARAMETER[@]}")
        EXTRA_ARGUMENT+=(--os-variant fedora31)
        ;;
    kali)
        EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/kali/dists/kali-rolling/main/installer-amd64)
        EXTRA_ARGUMENT+=("${INSTALLER_PARAMETER[@]}")
        EXTRA_ARGUMENT+=(--os-variant debiantesting)
        ;;
    opensuse)
        EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/opensuse/tumbleweed/repo/oss)
        EXTRA_ARGUMENT+=("${INSTALLER_PARAMETER[@]}")
        EXTRA_ARGUMENT+=(--os-variant opensusetumbleweed)
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
    --autostart \
    --connect qemu:///system \
    --console char_type=pty,target_type=serial \
    --cpu host \
    --disk "device=disk,format=qcow2,path=${DIRECTORY}/${NAME}.qcow2,size=${SIZE}" \
    --features kvm_hidden=off \
    --graphics none \
    --hvm \
    --memory "${MEMORY}" \
    --name "${NAME}" \
    --network model=virtio,network=default \
    --os-type linux \
    --serial char_type=pty,target_type=isa-serial \
    --vcpus cpuset=auto,vcpus="${CPU}" \
    --virt-type kvm \
    "${EXTRA_ARGUMENT[@]}"
