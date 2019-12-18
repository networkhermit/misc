```bash
# shellcheck shell=bash

# erase bootstrap code on UEFI/GPT Protective MBR
sudo dd if="${DEVICE}" of=boot-sector.bin bs=446 count=1
sudo dd if=/dev/zero of="${DEVICE}" bs=446 count=1
sudo dd if="${DEVICE}" bs=446 count=1 status=none | od --address-radix d --format x2

# probe disk partition
sudo partx --show --output-all "${DEVICE}"
sudo partprobe --summary "${DEVICE}"
sudo partx --add --verbose "${DEVICE}"
sudo partx --delete --verbose "${DEVICE}"

# set xfs filesystem label
AG_COUNT=$(sudo xfs_db -c sb -c 'print agcount' "${DEVICE}" | awk --field-separator ' = ' '{ print $2 }')
for (( i = 0; i < AG_COUNT; i++ )); do
    sudo xfs_db -c "sb ${i}" -c "write fname \"${LABEL}\"" -x "${DEVICE}"
done
sudo xfs_db -c label "${DEVICE}"
unset AG_COUNT

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
