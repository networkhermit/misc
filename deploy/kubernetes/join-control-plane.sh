#!/usr/bin/env bash

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

warn () {
    if (( $# > 0 )); then
        echo "${@}" 1>&2
    fi
}

die () {
    warn "${@}"
    exit 1
}

notify () {
    local code=$?
    warn "✗ [FATAL] $(caller): ${BASH_COMMAND} (${code})"
}

trap notify ERR

display_help () {
    cat << EOF
Synopsis:
    ${0##*/} [OPTION]...

Options:
    -h, --help
        show this help message and exit
    -v, --version
        output version information and exit
EOF
}

while (( $# > 0 )); do
    case ${1} in
    -h | --help)
        display_help
        shift
        exit
        ;;
    -v | --version)
        echo v0.1.0
        shift
        exit
        ;;
    --)
        shift
        break
        ;;
    *)
        break
        ;;
    esac
done

if (( $# > 0 )); then
    die "✗ argument parsing failed: unrecognizable argument ‘${1}’"
fi

if (( EUID != 0 )); then
    die '✗ This script must be run as root'
fi

clean_up () {
    true
}

trap clean_up EXIT

#kubeadm config print join-defaults

#KEY=$(kubeadm certs certificate-key)
#kubeadm init phase upload-certs --certificate-key "${KEY}" --upload-certs

kubeadm token list
#TOKEN=$(kubeadm token create --ttl 2h)
#HASH=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt \
#    | openssl rsa -pubin -outform der 2> /dev/null \
#    | openssl dgst -sha256 -hex | sed 's/^.* //')
#kubeadm token create --certificate-key "${KEY}" --print-join-command

install --mode 600 /dev/null /etc/kubernetes/kubeadm.log
kubeadm join --config manifest/kubeadm-join-control-plane.yaml |& tee /etc/kubernetes/kubeadm.log
systemctl enable kubelet.service
