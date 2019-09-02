```bash
# shellcheck shell=bash

## [ linux kernel archive ]
BASE_URL='https://mirrors.kernel.org/archlinux'
## [ tsinghua ]
BASE_URL='https://mirrors.tuna.tsinghua.edu.cn/archlinux'

SNAPSHOT=$(date '+%Y.%m.01')

curl --fail --location --silent --show-error --remote-name "${BASE_URL}/iso/${SNAPSHOT}/archlinux-${SNAPSHOT}-x86_64.iso"
curl --fail --location --silent --show-error --remote-name "${BASE_URL}/iso/${SNAPSHOT}/archlinux-bootstrap-${SNAPSHOT}-x86_64.tar.gz"
curl --fail --location --silent --show-error --remote-name "${BASE_URL}/iso/${SNAPSHOT}/sha1sums.txt"
```
