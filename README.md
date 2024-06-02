## Description
ubuntu qemu kit for cve-2022-32250

## Setup
```shell
./setup.sh
```

- boot folder created
- download boot image in boot folder
- set seed file in boot folder
- make kernel image in boot folder

## Boot
master folder in terminal 1
```shell
./boot.sh
```

master folder in terminal 2
```shell
./gdb -q ./boot/linux-5.15.25/vmlinux

gdb > target remote :1234
```

## Login
- username : ubuntu
- password : 1234

in cloud_config.yaml

---
kernel config setting is geared towards CVE-2022-32250.
