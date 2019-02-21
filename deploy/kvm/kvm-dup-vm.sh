#!/bin/bash

if (( EUID != 0 )); then
    echo "This script must be run as root" 1>&2
    exit 1
fi

if [ $# != 2 ]; then
    exit
fi

virt-clone \
    --file "/var/local/images/${2}.img" \
    --name "${2}" \
    --original "${1}"
