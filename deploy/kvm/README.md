```bash
# shellcheck shell=bash

# list filesystems in disk image
virt-filesystems --add "${DISK_IMAGE}" --all --human-readable --long

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
```
