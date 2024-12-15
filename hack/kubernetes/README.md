```bash
# shellcheck shell=bash

# list all container images running in a cluster
for ns in $(kubectl get namespaces -o jsonpath="{ .items[*].metadata.name }"); do
    echo "==== ${ns} ===="
    kubectl get pods --namespace "${ns}" --output jsonpath="{.items[*].spec['containers', 'initContainers'][*].image}" \
        | tr --squeeze-repeats '[:space:]' '\n' \
        | sort \
        | uniq
done

# mirroring images
REGISTRY_HOST=
REGISTRY_USERNAME=
REGISTRY_PASSWORD=
IMAGE_REPOSITORY=${REGISTRY_HOST}/k8s

for i in $(kubeadm config images list --kubernetes-version "$(kubeadm version --output short)") registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.14.0 registry.k8s.io/metrics-server/metrics-server:v0.7.2; do
    image=$(cut --delimiter / --fields 2- <<< "${i}" | tr / _)
    #image=$(cut --delimiter / --fields 2- <<< "${i}")
    skopeo copy --all --preserve-digests --retry-times 5 "docker://${i}" "docker://${IMAGE_REPOSITORY}/${image}"
done

sudo docker run --rm -it --entrypoint /bin/bash quay.io/skopeo/stable:latest
echo "${REGISTRY_PASSWORD}" | skopeo login --username "${REGISTRY_USERNAME}" --password-stdin "${REGISTRY_HOST}"
skopeo logout "${REGISTRY_HOST}"

# create kubeconfig for new user
export KUBECONFIG=/etc/kubernetes/admin.conf
kubeadm kubeconfig user --config <(kubectl --namespace kube-system get configmaps kubeadm-config --output jsonpath='{.data.ClusterConfiguration}') --org devops --client-name vac --validity-period 24h

# checking api access
kubectl auth can-i delete namespace

# access hubble
cilium hubble port-forward
cilium hubble ui

# access kubernetes dashboard
kubectl --namespace kubernetes-dashboard create token cluster-admin-dashboard
echo http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
kubectl proxy

# approve kubernetes csr
kubectl get certificatesigningrequests --sort-by '{.metadata.creationTimestamp}'
# kubectl certificate approve csr-abcde
kubectl get certificatesigningrequests \
    --output jsonpath='{.items[?(@.spec.signerName=="kubernetes.io/kubelet-serving")].metadata.name}' \
    | xargs --max-args 1 --no-run-if-empty kubectl certificate approve
```
