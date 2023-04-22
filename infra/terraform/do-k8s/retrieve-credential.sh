#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

if [[ ! -e vault ]]; then
    mkdir vault
fi

for o in kubeconfig talosconfig; do
    install --mode 600 <(terraform output -raw "${o}") "vault/${o}"
done
