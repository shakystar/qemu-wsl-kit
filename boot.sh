#!/bin/bash

ALLOCATED_RAM="2048" # MiB
CPU_SOCKETS="1"
CPU_CORES="2"
CPU_THREADS="2"

BOOT=./boot
FILE_IMAGE=${BOOT}/ubuntu-22.04-minimal-cloudimg-amd64.img
FILE_SEED=${BOOT}/seed.raw
FILE_KERNEL=${BOOT}/linux-5.15.25/arch/x86/boot/bzImage

args=(
        -m "$ALLOCATED_RAM"
        -smp "$CPU_THREADS",cores="$CPU_CORES",sockets="$CPU_SOCKETS"
        -kernel "$FILE_KERNEL"
        -drive if=virtio,format=qcow2,file="$FILE_IMAGE"
        -drive if=virtio,format=raw,file="$FILE_SEED"
        -append "root=/dev/vda1 console=ttyS0 earlyprintk=serial net.ifnames=0 nokaslr"
        -netdev id=net00,type=user,hostfwd=tcp::2222-:22
        -device virtio-net-pci,netdev=net00
        -enable-kvm
        -nographic
        -s
)
qemu-system-x86_64 "${args[@]}" 2>&1 | tee vm.log
