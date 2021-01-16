```bash
# shellcheck shell=bash

# verify uniqueness of node
hostname
ip link
sudo cat /sys/class/dmi/id/product_uuid

# enable command line completion
# shellcheck source=/dev/null
source <(kubeadm completion bash)

# enable command line completion
# shellcheck source=/dev/null
source <(kubectl completion bash)

# discovery kubernetes api
kubectl api-resources --sort-by name
kubectl api-versions

# list all container images running in a cluster
kubectl get pods --all-namespaces --output jsonpath='{.items[*].spec.containers[*].image}' \
    | tr --squeeze-repeats '[:space:]' '\n' \
    | sort \
    | uniq
```
