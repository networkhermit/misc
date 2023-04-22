```bash
# shellcheck shell=bash

# probe disk partition
sudo partx --show --output-all "${DEVICE}"
sudo partprobe --summary "${DEVICE}"
sudo partx --add --verbose "${DEVICE}"
sudo partx --delete --verbose "${DEVICE}"

# change the active state of LVs
sudo lvscan
sudo lvchange --activate y "${LOGICAL_VOLUME:-${VOLUME_GROUP}}"
sudo lvchange --activate n "${LOGICAL_VOLUME:-${VOLUME_GROUP}}"
sudo vgscan
sudo vgchange --activate y "${VOLUME_GROUP:-}"
sudo vgchange --activate n "${VOLUME_GROUP:-}"

# deactivate MD array
sudo mdadm --detail --scan --verbose
sudo mdadm --stop --scan --verbose "${MD_DEVICE:-}"
```
