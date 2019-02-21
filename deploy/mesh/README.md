```bash
# shellcheck shell=bash

#
# PodSpec = container manifest
#
# https://kubernetes.io/docs/concepts
# https://kubernetes.io/docs/reference
# https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.13
# https://kubernetes.io/docs/reference/glossary
# https://kubernetes.io/docs/setup
# https://kubernetes.io/docs/tasks
# https://kubernetes.io/docs/tutorials
#
# https://git.k8s.io/community/contributors/devel/api-conventions.md
#

# verify uniqueness of node
hostnamectl
ip link
sudo cat /sys/class/dmi/id/product_uuid

# enable command line completion
# shellcheck disable=SC1090
source <(kubeadm completion bash)

# enable command line completion
# shellcheck disable=SC1090
source <(kubectl completion bash)

# verify cluster status
kubectl cluster-info
kubectl get apiservices --output wide
kubectl get clusterroles --output wide
kubectl get clusterrolebindings --output wide
kubectl get componentstatuses --output wide
kubectl get namespaces --output wide
kubectl get nodes --output wide
kubectl get persistentvolumes --output wide
kubectl get storageclasses --output wide

# discovery kubernetes api
kubectl api-resources --namespaced=false
kubectl api-resources --namespaced=true
kubectl api-versions
kubectl config view
kubectl get services --all-namespaces --output wide
kubectl get endpoints --all-namespaces --output wide
kubectl get roles --all-namespaces --output wide
kubectl get rolebindings --all-namespaces --output wide
kubectl get serviceaccounts --all-namespaces --output wide
kubectl get ingresses --all-namespaces --output wide
kubectl get networkpolicies --all-namespaces --output wide
kubectl get pods --all-namespaces --output wide
kubectl get daemonsets --all-namespaces --output wide
kubectl get deployments --all-namespaces --output wide
kubectl get replicasets --all-namespaces --output wide
kubectl get statefulsets --all-namespaces --output wide
kubectl get cronjobs --all-namespaces --output wide
kubectl get jobs --all-namespaces --output wide
kubectl get configmaps --all-namespaces --output wide
kubectl get secrets --all-namespaces --output wide
kubectl get persistentvolumeclaims --all-namespaces --output wide

# display the documentation of api resources
kubectl api-resources --no-headers | awk '{ print $1 }' | xargs -n 1 kubectl explain --recursive=true | less -N
```
