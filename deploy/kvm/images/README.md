```bash
# shellcheck shell=bash

## [ berkeley ]
BASE_URL='https://mirrors.ocf.berkeley.edu/archlinux'
## [ tsinghua ]
BASE_URL='https://mirrors.tuna.tsinghua.edu.cn/archlinux'

SNAPSHOT=$(date '+%Y.%m.01')
curl --location --remote-name "${BASE_URL}/iso/${SNAPSHOT}/archlinux-${SNAPSHOT}-x86_64.iso"
curl --location --remote-name "${BASE_URL}/iso/${SNAPSHOT}/archlinux-bootstrap-${SNAPSHOT}-x86_64.tar.gz"
curl --location --remote-name "${BASE_URL}/iso/${SNAPSHOT}/sha1sums.txt"
unset SNAPSHOT
```
