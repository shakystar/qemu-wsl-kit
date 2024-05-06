#!/usr/bin/bash

PUSH_BUILD="pushd build > /dev/null"
POP="popd > /dev/null"

run_cmd()
{
    echo "$*"

    eval "$*" || {
        echo "ERROR: $*"
        exit 1
    }
}

run_chroot()
{
    root=$1
    script=$2

    sudo chroot ${root} /bin/bash -c """
set -ex
${script}
exit
"""
    [[ $? -ne 0 ]] && {
        echo "ERROR: chroot failed"
        exit 1
    }
}

install_packages()
{
    run_cmd sudo apt install bc zstd gawk flex bison openssl dkms autoconf llvm gdb
    run_cmd sudo apt install libncurses-dev libssl-dev libelf-dev libudev-dev libpci-dev libiberty-dev
    run_cmd sudo apt install libvirt-clients libvirt-daemon libvirt-daemon-system
    run_cmd sudo apt install qemu-kvm bridge-utils virtinst
}

setup_virt()
{
    local username=$(whoami)

    if ! getent group kvm > /dev/null; then
        run_cmd sudo groupadd kvm
    fi

    if ! getent group libvirt > /dev/null; then
        run_cmd sudo groupadd libvirt
    fi

    run_cmd sudo usermod -aG kvm $username
    run_cmd sudo usermod -aG libvirt $username
    run_cmd sudo systemctl enable --now libvirtd
}

build_seed()
{
    local seed_file="seed.raw"
    local yaml_file="cloud_config.yaml"

    PUSH_BUILD

    run_cmd sudo chmod +x build_seed.sh

    run_cmd ./build_seed.sh "$seed_file" "$yaml_file"

    POP
}

build_image()
{
    local image_file="ubuntu-22.04-minimal-cloudimg-amd64.img"
    local download_url="https://cloud-images.ubuntu.com/minimal/releases/jammy/release-20220420/ubuntu-22.04-minimal-cloudimg-amd64.img"

    PUSH_BUILD

    run_cmd sudo chmod +x build_image.sh

    run_cmd ./build_image.sh "$image_file" "$download_url"

    POP
}

build_kernel()
{
    local version="5.15.25"

    PUSH_BUILD

    run_cmd sudo chmod +x build_kernel.sh

    run_cmd ./build_kernel.sh "$version"

    POP
}

install_packages()
setup_virt()

build_seed()
build_image()
build_kernel()
