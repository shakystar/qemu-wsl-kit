    version=$1
    major=${kernel_version%%.*}

    wget https://cdn.kernel.org/pub/linux/kernel/v${major}.x/linux-${version}.tar.gz
    tar xvf linux-${version}.tar.gz linux-${version}
    rm linux-${version}.tar.gz

    MAKE="make -C linux-${version} -j $(getconf _NPROCESSORS_ONLN) LOCALVERSION="
    $MAKE distclean

    [ -d linux-${version} ] && {
        pushd linux-${version} > /dev/null

        make defconfig
        make kvm_guest.config

        ./scripts/config --enable CONFIG_CONFIGFS_FS
        ./scripts/config --enable CONFIG_DEBUG_INFO_DWARF5
        ./scripts/config --enable CONFIG_DEBUG_INFO
        ./scripts/config --disable CONFIG_RANDOMIZE_BASE
        ./scripts/config --enable CONFIG_GDB_SCRIPTS

        popd > /dev/null
    }
    $MAKE olddefconfig

    echo "[+] Build linux kernel ..."
    $MAKE