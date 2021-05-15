```bash
# shellcheck shell=bash

# verify uniqueness of node
hostname
ip link
sudo cat /sys/class/dmi/id/product_uuid

# discovery kubernetes api
kubectl api-resources --sort-by name
kubectl api-versions

# list all container images running in a cluster
kubectl get pods --all-namespaces --output jsonpath='{.items[*].spec.containers[*].image}' \
    | tr --squeeze-repeats '[:space:]' '\n' \
    | sort \
    | uniq

# access kubernetes dashboard
kubectl get secret "$(kubectl get serviceaccount cluster-admin-dashboard --namespace kube-system --output jsonpath='{.secrets[].name}')" --namespace kube-system --output jsonpath="{.data['token']}" | base64 --decode && echo
echo http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy
kubectl proxy

# update kubernetes dashboard
kubectl delete "$(kubectl get pod --namespace kube-system --output name | grep --word-regexp 'kubernetes-dashboard')" --namespace kube-system
```
