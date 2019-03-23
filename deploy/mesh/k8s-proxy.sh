#!/bin/bash

# push k8s.gcr.io images to [aliyun]

sudo docker login --username dot.fun@protonmail.com registry.cn-shanghai.aliyuncs.com

mapfile -O ${#arr[@]} -t arr < <(kubeadm config images list --kubernetes-version "$(kubeadm version --output short)")
mapfile -O ${#arr[@]} -t arr < <(curl --location --silent 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml' | awk '/\<image\>/ { print $2 }')
mapfile -O ${#arr[@]} -t arr < <(curl --location --silent 'https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8+/metrics-server-deployment.yaml' | awk '/\<image\>/ { print $2 }')
for i in "${arr[@]}"; do
    IMAGE=$(echo "${i}" | awk --field-separator '/' '{ print $2 }')
    sudo docker image tag "${i}" registry.cn-shanghai.aliyuncs.com/qubit/"${IMAGE}"
    sudo docker image push registry.cn-shanghai.aliyuncs.com/qubit/"${IMAGE}"
    sudo docker image rm registry.cn-shanghai.aliyuncs.com/qubit/"${IMAGE}"
done
unset arr

sudo docker logout registry.cn-shanghai.aliyuncs.com

# push k8s.gcr.io images to [qingcloud]

sudo docker login --username vac dockerhub.qingcloud.com

mapfile -O ${#arr[@]} -t arr < <(kubeadm config images list --kubernetes-version "$(kubeadm version --output short)")
mapfile -O ${#arr[@]} -t arr < <(curl --location --silent 'https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml' | awk '/\<image\>/ { print $2 }')
mapfile -O ${#arr[@]} -t arr < <(curl --location --silent 'https://raw.githubusercontent.com/kubernetes-incubator/metrics-server/master/deploy/1.8+/metrics-server-deployment.yaml' | awk '/\<image\>/ { print $2 }')
for i in "${arr[@]}"; do
    IMAGE=$(echo "${i}" | awk --field-separator '/' '{ print $2 }')
    sudo docker image tag "${i}" dockerhub.qingcloud.com/qubit/"${IMAGE}"
    sudo docker image push dockerhub.qingcloud.com/qubit/"${IMAGE}"
    sudo docker image rm dockerhub.qingcloud.com/qubit/"${IMAGE}"
done
unset arr

sudo docker logout dockerhub.qingcloud.com
