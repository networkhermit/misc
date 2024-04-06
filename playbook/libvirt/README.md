```bash
# shellcheck shell=bash

# reallocate kvm cpu/memory
sudo virsh nodeinfo
sudo virsh dominfo "${DOMAIN}"
sudo virsh vcpucount "${DOMAIN}"
sudo virsh memtune "${DOMAIN}"
sudo virsh shutdown "${DOMAIN}"
sudo virsh setvcpus "${DOMAIN}" 4 --config --maximum
sudo virsh setvcpus "${DOMAIN}" 4 --config
sudo virsh setmaxmem "${DOMAIN}" 8G --config
sudo virsh setmem "${DOMAIN}" 8G --config
sudo virsh start "${DOMAIN}"

# attach/detach disk to/from kvm
sudo virsh domblklist --details "${DOMAIN}"
sudo virsh attach-disk "${DOMAIN}" /var/lib/libvirt/boot/archlinux-*.*.*-x86_64.iso sda --type cdrom
sudo virsh attach-disk "${DOMAIN}" "${SOURCE}" "${TARGET}" --persistent
sudo virsh detach-disk "${DOMAIN}" "${TARGET}" --persistent

# check filesystem usage in disk image
virt-filesystems --add "${DISK_IMAGE}" --all --human-readable --long
virt-df --add "${DISK_IMAGE}" --human-readable

# defrag or optimize qcow2 disk
sudo qemu-img check "${FILENAME}"
sudo qemu-img convert -O qcow2 -o lazy_refcounts=on,preallocation=metadata "${FILENAME}" "${OUTPUT_FILENAME}"
sudo qemu-img amend -o lazy_refcounts=on "${FILENAME}"
sudo qemu-img info --output json "${FILENAME}" | jq '."format-specific".data."lazy-refcounts"'

# mount disk image

## via libguestfs
guestmount --add "${DISK_IMAGE}" --inspector --ro "${MOUNT_POINT}"
guestmount --add "${DISK_IMAGE}" --mount "${DEVICE}" --ro "${MOUNT_POINT}"
guestunmount "${MOUNT_POINT}"

## via loop device [raw]
sudo losetup --find "${DISK_IMAGE}" --nooverlap --partscan --read-only
sudo losetup --detach "${LOOP_DEVICE}"

## via network block device
sudo modprobe nbd
sudo qemu-nbd --connect /dev/nbdX --read-only "${DISK_IMAGE}"
sudo qemu-nbd --disconnect /dev/nbdX
sudo modprobe --remove nbd

# mount iso image
mount --options loop,ro "${ISO_IMAGE}" "${MOUNT_POINT}"
umount "${MOUNT_POINT}"
```
