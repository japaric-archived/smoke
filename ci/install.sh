set -ex

. $(dirname $0)/env.sh

install_qemu() {
    apt-get install -y --no-install-recommends \
            binfmt-support qemu-user-static
}

install_c_toolchain() {
    local openwrt_url=https://downloads.openwrt.org/snapshots/trunk
    local mipsel_tarball=malta/generic/OpenWrt-SDK-malta-le_gcc-5.3.0_musl-1.1.14.Linux-x86_64.tar.bz2

    apt-get install -y --no-install-recommends \
            bzip2
    case $TARGET in
        mipsel-unknown-linux-musl)
            mkdir /openwrt
            curl -sL $openwrt_url/$mipsel_tarball | \
                tar --strip-components=1 -C /openwrt -xj
            ln -s $STAGING_DIR/toolchain-*/bin/mipsel-openwrt-linux-gcc /usr/bin/${TARGET//unknown-/}-gcc
            ;;
    esac
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
