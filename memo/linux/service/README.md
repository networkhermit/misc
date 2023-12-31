systemd
=======

```bash
# shellcheck shell=bash

systemd-detect-virt || true
systemctl get-default
systemctl list-machines --no-pager
systemctl is-system-running --quiet || systemctl list-units --failed

systemd-analyze time
systemd-analyze critical-chain --no-pager
systemd-analyze blame --no-pager

systemctl list-unit-files --no-pager --state enabled

systemctl list-unit-files \
    --no-legend \
    --no-pager \
    --state enabled,disabled \
    --type service,socket,timer \
    | awk '$2 != $3 { print substr($2, 1, length($2) - 1), $1 }' \
    | LC_ALL=C sort

systemctl list-units --no-pager --type service
systemctl list-sockets --no-pager --show-types
systemctl list-units --no-pager --type socket
systemctl list-timers --no-pager
systemctl list-units --no-pager --type timer
```

magic SysRq key
===============

```bash
# shellcheck shell=bash

# influences only the invocation via key combination
#echo 1 > /proc/sys/kernel/sysrq # enable all magic SysRq key
echo 176 > /proc/sys/kernel/sysrq # enable certain magic SysRq key

# invoke via the procfs
echo s > /proc/sysrq-trigger # sync (16)
echo u > /proc/sysrq-trigger # remount read-only (32)
echo b > /proc/sysrq-trigger # reboot (128)
#echo o > /proc/sysrq-trigger # poweroff (128)
```
