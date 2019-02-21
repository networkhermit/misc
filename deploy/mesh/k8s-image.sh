#!/bin/bash

# print k8s.gcr.io images kubernetes will use
kubeadm config images list --kubernetes-version "$(kubeadm version --output short)"
curl -sL 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml' | awk '/\<image\>/ { print $2 }'
curl -sL 'https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8+/metrics-server-deployment.yaml' | awk '/\<image\>/ { print $2 }'

# pull container images from k8s.gcr.io
sudo kubeadm config images pull --kubernetes-version "$(kubeadm version --output short)"
sudo docker image pull "$(curl -sL 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml' | awk '/\<image\>/ { print $2 }')"
sudo docker image pull "$(curl -sL 'https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8+/metrics-server-deployment.yaml' | awk '/\<image\>/ { print $2 }')"

# pull container images from [aliyun]
mapfile -O ${#arr[@]} -t arr < <(kubeadm config images list --kubernetes-version "$(kubeadm version --output short)")
mapfile -O ${#arr[@]} -t arr < <(curl -sL 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml' | awk '/\<image\>/ { print $2 }')
mapfile -O ${#arr[@]} -t arr < <(curl -sL 'https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8+/metrics-server-deployment.yaml' | awk '/\<image\>/ { print $2 }')
for i in "${arr[@]}"; do
    IMAGE=$(echo "${i}" | awk -F '/' '{ print $2 }')
    sudo docker image pull registry.cn-shanghai.aliyuncs.com/qubit/"${IMAGE}"
    sudo docker image tag registry.cn-shanghai.aliyuncs.com/qubit/"${IMAGE}" "${i}"
    sudo docker image rm registry.cn-shanghai.aliyuncs.com/qubit/"${IMAGE}"
done
unset arr

# pull container images from [qingcloud]
sudo docker login --username sherlock --password-stdin dockerhub.qingcloud.com <<< 'IoSiUICUCHXzJ53sF0qJqC1vNJGfTyze'
mapfile -O ${#arr[@]} -t arr < <(kubeadm config images list --kubernetes-version "$(kubeadm version --output short)")
mapfile -O ${#arr[@]} -t arr < <(curl -sL 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml' | awk '/\<image\>/ { print $2 }')
mapfile -O ${#arr[@]} -t arr < <(curl -sL 'https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8+/metrics-server-deployment.yaml' | awk '/\<image\>/ { print $2 }')
for i in "${arr[@]}"; do
    IMAGE=$(echo "${i}" | awk -F '/' '{ print $2 }')
    sudo docker image pull dockerhub.qingcloud.com/qubit/"${IMAGE}"
    sudo docker image tag dockerhub.qingcloud.com/qubit/"${IMAGE}" "${i}"
    sudo docker image rm dockerhub.qingcloud.com/qubit/"${IMAGE}"
done
unset arr
sudo docker logout dockerhub.qingcloud.com

# inspect container images
mapfile -O ${#arr[@]} -t arr < <(kubeadm config images list --kubernetes-version "$(kubeadm version --output short)")
mapfile -O ${#arr[@]} -t arr < <(curl -sL 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml' | awk '/\<image\>/ { print $2 }')
mapfile -O ${#arr[@]} -t arr < <(curl -sL 'https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8+/metrics-server-deployment.yaml' | awk '/\<image\>/ { print $2 }')
for i in "${arr[@]}"; do
    sudo docker inspect --format '{{.Id}} {{.RepoTags}}' "${i}"
done
unset arr
