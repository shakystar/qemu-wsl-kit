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
    make kvm_guest.config

    ./scripts/config --disable SYSTEM_TRUSTED_KEYS
    ./scripts/config --disable SYSTEM_REVOCATION_KEYS
    ./scripts/config --disable CONFIG_RANDOMIZE_BASE
    ./scripts/config --disable CONFIG_DEBUG_INFO_BTF

    ./scripts/config --enable CONFIG_DEBUG_KERNEL
    ./scripts/config --enable CONFIG_DEBUG_INFO
    ./scripts/config --enable CONFIG_GDB_SCRIPTS
    ./scripts/config --enable CONFIG_SLUB_DEBUG
    ./scripts/config --enable CONFIG_KRETPROBES
    ./scripts/config --enable CONFIG_KPROBES
    ./scripts/config --enable CONFIG_KGDB

    ./scripts/config --enable CONFIG_CONFIGFS_FS
    ./scripts/config --enable CONFIG_DEBUG_INFO_DWARF5

    popd > /dev/null
}
$MAKE olddefconfig

echo "[+] Build linux kernel ..."
$MAKE