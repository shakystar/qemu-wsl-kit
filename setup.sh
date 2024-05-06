#!/usr/bin/bash

run_cmd()
{
    echo "$*"

    eval "$*" || {
        echo "ERROR: $*"
        exit 1
    }
}

install_packages()
{
    run_cmd sudo apt install bc zstd gawk flex bison openssl dkms autoconf llvm gdb
    run_cmd sudo apt install libncurses-dev libssl-dev libelf-dev libudev-dev libpci-dev libiberty-dev
    run_cmd sudo apt install libvirt-clients libvirt-daemon libvirt-daemon-system
    run_cmd sudo apt install bridge-utils virtinst

    run_cmd sudo apt install aptitude
    run_cmd sudo aptitude install qemu-kvm
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

    pushd build > /dev/null

    run_cmd sudo chmod +x build_seed.sh

    run_cmd ./build_seed.sh "$seed_file" "$yaml_file"

    popd > /dev/null    
}

build_image()
{
    local image_file="ubuntu-22.04-minimal-cloudimg-amd64.img"
    local download_url="https://cloud-images.ubuntu.com/minimal/releases/jammy/release-20220420/ubuntu-22.04-minimal-cloudimg-amd64.img"

    pushd build > /dev/null

    run_cmd sudo chmod +x build_image.sh

    run_cmd ./build_image.sh "$image_file" "$download_url"

    popd > /dev/null
}

build_kernel()
{
    local version="5.15.25"

    pushd build > /dev/null

    run_cmd sudo chmod +x build_kernel.sh

    run_cmd ./build_kernel.sh "$version"

    popd > /dev/null
}

install_packages
setup_virt

build_seed
build_image
build_kernel

mkdir boot
mv ./build/seed.raw ./boot
mv ./build/ubuntu-22.04-minimal-cloudimg-amd64.img ./boot
mv ./build/linux-5.15.25/arch/x86/boot/bzImage ./boot

echo "[+] SETUP END... Don't run it again"