version=$1
major=${version%%.*}

if [ ! -d "linux-$version" ]; then
    wget https://cdn.kernel.org/pub/linux/kernel/v${major}.x/linux-${version}.tar.gz
    tar xvf linux-${version}.tar.gz linux-${version}
    rm linux-${version}.tar.gz
fi


MAKE="make -C linux-${version} -j $(getconf _NPROCESSORS_ONLN) LOCALVERSION="
$MAKE distclean

[ -d linux-${version} ] && {
    pushd linux-${version} > /dev/null

    cp ../.config ./
    # make defconfig
    # make kvm_guest.config

    popd > /dev/null
}

echo "[+] Build linux kernel ..."
$MAKE
# $MAKE module_install
# $MAKE install
