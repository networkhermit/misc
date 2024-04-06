```bash
# shellcheck shell=bash

# probe disk partition
sudo partx --show --output-all "${DEVICE}"
sudo partprobe --summary "${DEVICE}"
sudo partx --add --verbose "${DEVICE}"
sudo partx --delete --verbose "${DEVICE}"

# wipe signature
sudo wipefs --all --backup "${DEVICE}"

# set up lvm or thin lvm
sudo pvcreate "${DEVICE}"
sudo pvscan --verbose
sudo pvdisplay --maps --verbose
sudo vgcreate "${VOLUME_GROUP}" "${DEVICE}"
sudo vgscan --verbose
sudo lvcreate --name "${LOGICAL_VOLUME}" --size 64G "${VOLUME_GROUP}"
sudo lvcreate --name "${THIN_POOL}" --poolmetadatasize 1G --size 256G --type thin-pool "${VOLUME_GROUP}"
sudo lvcreate --name "${LOGICAL_VOLUME}" --thinpool "${THIN_POOL}" --virtualsize 40G "${VOLUME_GROUP}"
sudo lvscan --verbose

# change the active state of LVs
sudo lvchange --activate y "${LOGICAL_VOLUME:-${VOLUME_GROUP}}"
sudo lvchange --activate n "${LOGICAL_VOLUME:-${VOLUME_GROUP}}"
sudo vgchange --activate y "${VOLUME_GROUP:-}"
sudo vgchange --activate n "${VOLUME_GROUP:-}"

# deactivate MD array
sudo mdadm --detail --scan --verbose
sudo mdadm --stop --scan --verbose "${MD_DEVICE:-}"
```
