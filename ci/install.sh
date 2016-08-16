set -ex

. $(dirname $0)/env.sh

install_qemu() {
    apt-get install -y --no-install-recommends \
            binfmt-support qemu-user-static
}

install_c_toolchain() {
    local openwrt_root_url=https://downloads.openwrt.org/snapshots/trunk
    local mips_tarball=ar71xx/generic/OpenWrt-SDK-ar71xx-generic_gcc-5.3.0_musl-1.1.14.Linux-x86_64.tar.bz2
    local mipsel_tarball=malta/generic/OpenWrt-SDK-malta-le_gcc-5.3.0_musl-1.1.14.Linux-x86_64.tar.bz2
    case $TARGET in
        mips-unknown-linux-musl)
            local url=$openwrt_root_url/$mips_tarball
            ;;
        mipsel-unknown-linux-musl)
            local url=$openwrt_root_url/$mipsel_tarball
            ;;
        *)
            return
            ;;
    esac

    apt-get install -y --no-install-recommends \
            bzip2
    mkdir /openwrt
    curl -sL $url | tar --strip-components=1 -C /openwrt -xj
    ln -s $STAGING_DIR/toolchain-*/bin/$(echo $TARGET | cut -d'-' -f1)-openwrt-linux-gcc \
       /usr/bin/${TARGET//unknown-/}-gcc
}

install_rust() {
    rustup default nightly

    rustc -V
    cargo -V
}

add_rustup_target() {
    if [[ $TARGET != $HOST ]]; then
        rustup target add $TARGET
    fi
}

configure_cargo() {
    if [[ ${CONFIGURE_CARGO:-n} == "y" ]]; then
        cat >>~/.cargo/config <<EOF
[target.$TARGET]
linker = "${TARGET//unknown-/}-gcc"
EOF
    fi
}

main() {
    apt-get update
    install_qemu
    install_c_toolchain
    install_rust
    add_rustup_target
    configure_cargo
}

main
