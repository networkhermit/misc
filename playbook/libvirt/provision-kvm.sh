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
    --boot-path BOOT_PATH
        directory to store the boot image (default: ${BOOT_PATH})
    --bridge INTERFACE
        bridge interface to use if you don't want to use NAT
    --cpu N
        number of virtual cpus to configure for the guest (default: ${CPU})
    --images-path IMAGES_PATH
        directory to store the disk image (default: ${IMAGES_PATH})
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
        linux/bsd distro name (alpine | arch | artix | fedora | gentoo | kali | nixos | void | freebsd | openbsd)
    NAME
        name of the new guest virtual machine instance
EOF
}

BOOT_PATH=/var/lib/libvirt/boot
BRIDGE=
CPU=4
IMAGES_PATH=/var/lib/libvirt/images
MEMORY=8192
SIZE=40

while (( $# > 0 )); do
    case ${1} in
    --boot-path)
        BOOT_PATH=${2?✗ option parsing failed: missing value for argument ‘${1}’}
        shift 2
        ;;
    --bridge)
        BRIDGE=${2?✗ option parsing failed: missing value for argument ‘${1}’}
        shift 2
        ;;
    --cpu)
        CPU=${2?✗ option parsing failed: missing value for argument ‘${1}’}
        shift 2
        ;;
    --images-path)
        IMAGES_PATH=${2?✗ option parsing failed: missing value for argument ‘${1}’}
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
alpine)
    IMAGE=$(find "${BOOT_PATH}" -type f -name 'alpine-standard-*.*.*-x86_64.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant alpinelinux3.20)
    ;;
arch)
    IMAGE=$(find "${BOOT_PATH}" -type f -name 'archlinux-*.*.*-x86_64.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant archlinux)
    ;;
artix)
    IMAGE=$(find "${BOOT_PATH}" -type f -name 'artix-base-s6-*-x86_64.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant archlinux)
    ;;
fedora)
    EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/fedora/releases/41/Server/x86_64/os)
    EXTRA_ARGUMENT+=("${KERNEL_ARGUMENT[@]}")
    EXTRA_ARGUMENT+=(--os-variant fedora41)
    ;;
gentoo)
    IMAGE=$(find "${BOOT_PATH}" -type f -name 'install-amd64-minimal-*.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant gentoo)
    ;;
kali)
    EXTRA_ARGUMENT+=(--location https://mirrors.tuna.tsinghua.edu.cn/kali/dists/kali-rolling/main/installer-amd64)
    EXTRA_ARGUMENT+=("${KERNEL_ARGUMENT[@]}")
    EXTRA_ARGUMENT+=(--os-variant debiantesting)
    ;;
nixos)
    IMAGE=$(find "${BOOT_PATH}" -type f -name 'nixos-minimal-*.*.*.*-x86_64-linux.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant nixos-24.05)
    ;;
void)
    IMAGE=$(find "${BOOT_PATH}" -type f -name 'void-live-x86_64-*-base.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant voidlinux)
    ;;
freebsd)
    IMAGE=$(find "${BOOT_PATH}" -type f -name 'FreeBSD-*.*-RELEASE-amd64-disc1.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant freebsd14.1)
    ;;
openbsd)
    IMAGE=$(find "${BOOT_PATH}" -type f -name 'install[0-9]*.iso' | sort --version-sort | tail --lines 1)

    EXTRA_ARGUMENT+=(--cdrom "${IMAGE}")
    EXTRA_ARGUMENT+=(--os-variant openbsd7.6)
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
    --disk "device=disk,format=qcow2,path=${IMAGES_PATH}/${NAME}.qcow2,size=${SIZE}" \
    --graphics none \
    --hvm \
    --memory "${MEMORY}" \
    --name "${NAME}" \
    --network "${NETWORK_OPTION}" \
    --vcpus "${VCPUS_OPTION}" \
    --virt-type kvm \
    "${EXTRA_ARGUMENT[@]}"
