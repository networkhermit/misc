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

ROLE=cluster-admin

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

if [[ "${ROLE}" = cluster-admin ]]; then
    install \
        --directory \
        --group "$(id --group "${SUDO_USER}")" \
        --mode 700 \
        --owner "$(id --user "${SUDO_USER}")" \
        "/home/${SUDO_USER}/.kube"
    install \
        --group "$(id --group "${SUDO_USER}")" \
        --mode 600 \
        --no-target-directory \
        --owner "$(id --user "${SUDO_USER}")" \
        --preserve-timestamps \
        /etc/kubernetes/admin.conf "/home/${SUDO_USER}/.kube/config"
else
    kubeadm alpha kubeconfig user --client-name "${SUDO_USER}"
    kubectl create clusterrolebinding
fi
