image_file=$1
download_url=$2

if [ ! -f "$image_file" ]; then
    wget $download_url
    qemu-img resize $image_file +2G
fi