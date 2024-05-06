seed_file=$1
yaml_file=$2

sudo apt install cloud-image-utils

if [ ! -f "$yaml_file" ]; then
    echo "#cloud-config" > "$yaml_file"
    echo "password: 1234" >> "$yaml_file"
    echo "chpasswd: { expire: false }" >> "$yaml_file"
    echo "ssh_pwauth: false" >> "$yaml_file"
    echo "$yaml_file 파일이 생성되었습니다."
else
    echo "$yaml_file 파일이 이미 존재합니다."
fi

if [ ! -f "$seed_file" ]; then
    cloud-localds "$seed_file" "$yaml_file"
else
    echo "$seed_file 파일이 이미 존재합니다."
fi