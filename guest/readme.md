## QEMU

### QEMU 로그인
ID : your host username
PW : 1234
---
ID : ubuntu
PW : 1234

### QEUM 나가기
ctrl + A, X

## 첫 실행 후

### ssh 환경 세팅
```shell
#!/usr/bin/bash

run_cmd()
{
    echo "$*"

    eval "$*" || {
        echo "ERROR: $*"
        exit 1
    }
}

service_ssh()
{
    local config_file=$1

    sudo -s

    sed -i '/PermitRootLogin/d' "$config_file"
    sed -i '/PasswordAuthentication/d' "$config_file"

    echo "PermitRootLogin yes" >> "$config_file"
    echo "PasswordAuthentication yes" >> "$config_file"

    systemctl enable ssh
    systemctl restart ssh

    exit
}

run_cmd sudo apt update
run_cmd sudo apt install linux-headers-5.15.0-25-generic 
run_cmd sudo apt install linux-image-unsigned-5.15.0-25-generic 
run_cmd sudo apt install linux-modules-5.15.0-25-generic
run_cmd sudo apt install linux-modules-extra-5.15.0-25-generic

service_ssh "/etc/ssh/sshd_config"
```

Boot 스크립트 기준 Default 포트는 2222번임.
```shell
-netdev id=net00,type=user,hostfwd=tcp::2222-:22
```

### 