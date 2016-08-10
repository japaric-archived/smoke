set -ex

. $(dirname $0)/env.sh

install_deps() {
    if [[ ${DOCKER} == "i" ]]; then
        apt-get update
        apt-get install -y --no-install-recommends \
                ca-certificates curl
    fi
}

install_qemu() {
    case $TARGET in
        mipsel-unknown-linux-* | \
        powerpc64le-unknown-linux-gnu)
            apt-get install -y --no-install-recommends \
                    qemu-user
            ;;
        mips-unknown-linux-gnu | \
        powerpc64-unknown-linux-gnu)
            dpkg --add-architecture i386
            apt-get update
            apt-get install -y --no-install-recommends \
                    qemu-user:i386
            ;;
    esac
}

install_c_toolchain() {
    local openwrt_url=https://downloads.openwrt.org/snapshots/trunk
    local mipsel_tarball=malta/generic/OpenWrt-Toolchain-malta-le_gcc-5.3.0_musl-1.1.14.Linux-x86_64.tar.bz2

    case $TARGET in
        aarch64-unknown-linux-gnu)
            sudo apt-get install -y --no-install-recommends \
                 gcc-aarch64-linux-gnu libc6-dev-arm64-cross
            ;;
        i586-unknown-linux-gnu | \
        i686-unknown-linux-musl)
            apt-get install -y --no-install-recommends \
                    gcc libc6-dev-i386 lib32gcc-5-dev
            ;;
        mips-unknown-linux-gnu)
            apt-get install -y --no-install-recommends \
                    gcc-mips-linux-gnu libc6-dev-mips-cross
            ;;
        mipsel-unknown-linux-gnu)
            apt-get install -y --no-install-recommends \
                    gcc-mipsel-linux-gnu libc6-dev-mipsel-cross
            ;;
        mipsel-unknown-linux-musl)
            apt-get install -y --no-install-recommends \
                    bzip2
            curl -sL $openwrt_url/$mipsel_tarball | \
                tar --strip-components=2 --wildcards -C /usr/local -xj 'OpenWrt*/toolchain*'
            ;;
        powerpc64-unknown-linux-gnu)
            apt-get install -y --no-install-recommends \
                    gcc-powerpc64-linux-gnu libc6-dev-ppc64-cross
            ;;
        powerpc64le-unknown-linux-gnu)
            apt-get install -y --no-install-recommends \
                    gcc-powerpc64le-linux-gnu libc6-dev-ppc64el-cross
            ;;
    esac
}

install_rust() {
    curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=nightly

    rustc -V
    cargo -V
}

add_rustup_target() {
    if [[ $TARGET != $HOST ]]; then
        rustup target add $TARGET
    fi
}

configure_cargo() {
    if [[ $PREFIX ]]; then
        ${PREFIX}gcc -v

        mkdir -p .cargo
        cat >>.cargo/config <<EOF
[target.$TARGET]
linker = "${PREFIX}gcc"
EOF
    fi
}

main() {
    if [[ ${DOCKER:-n} != "y" ]]; then
        install_deps
        install_qemu
        install_c_toolchain
        install_rust
        add_rustup_target
        configure_cargo
    fi
}

main
