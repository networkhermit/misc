#!/bin/bash

# trust google cloud package signing key
## google repository
curl --location https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
## aliyun repository
curl --location https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
## ubuntu keyserver
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --search-keys 54A647F9048D5688D7DA2ABE6A030B21BA07F4FB

# add kubernetes repository
## [official]
sudo tee /etc/apt/sources.list.d/kubernetes.list << 'EOF'
deb https://packages.cloud.google.com/apt kubernetes-xenial main
EOF
## [aliyun]
sudo tee /etc/apt/sources.list.d/kubernetes.list << 'EOF'
deb https://mirrors.aliyun.com/kubernetes/apt kubernetes-xenial main
EOF
## [ustc]
sudo tee /etc/apt/sources.list.d/kubernetes.list << 'EOF'
deb https://mirrors.ustc.edu.cn/kubernetes/apt kubernetes-xenial main
EOF

# install kubernetes packages
sudo apt update --list-cleanup
sudo apt install --allow-change-held-packages --assume-yes kube{adm,ctl,let} < /dev/null
sudo apt-mark hold kube{adm,ctl,let}
sudo apt-mark showhold
sudo systemctl disable --now kubelet.service

# configure kernel parameter
sudo tee /etc/sysctl.d/k8s.conf << 'EOF'
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
sudo sysctl --system
