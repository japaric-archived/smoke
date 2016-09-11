set -ex

main() {
    apt-get update

    apt-get install --no-install-recommends -y \
            `# QEMU` binfmt-support qemu-user-static \
            `# aarch64-unknown-linux-gnu` gcc-aarch64-linux-gnu libc6-dev-arm64-cross \
            `# arm*-unknown-linux-gnueabihf` gcc-arm-linux-gnueabihf libc6-dev-armhf-cross \
            `# arm-unknown-linux-gnueabi` gcc-arm-linux-gnueabi libc6-dev-armel-cross \
            `# i*86-unknown-linux-gnu` lib32gcc-5-dev libc6-dev-i386 \
            `# i686-unknown-linux-musl` make \
            `# mips*-unknown-linux-musl` bzip2 \
            `# mips-unknown-linux-gnu` gcc-mips-linux-gnu libc6-dev-mips-cross \
            `# mipsel-unknown-linux-gnu` gcc-mipsel-linux-gnu libc6-dev-mipsel-cross \
            `# powerpc-unknown-linux-gnu` gcc-powerpc-linux-gnu libc6-dev-powerpc-cross \
            `# powerpc64-unknown-linux-gnu` gcc-powerpc64-linux-gnu libc6-dev-ppc64-cross \
            `# powerpc64-unknown-linux-gnu` gcc-powerpc64le-linux-gnu libc6-dev-ppc64el-cross \
            `# rustup` ca-certificates curl \
            `# x86_64-unknown-linux-gnu` gcc libc6-dev \
            sudo

    x86_musl
    mips_musl
    passwordless_sudo
    cleanup
}

mips_musl() {
    local openwrt=https://downloads.openwrt.org/snapshots/trunk

    mkdir -p /openwrt/mips{,el}-unknown-linux-musl
    curl -sL $openwrt/ar71xx/generic/OpenWrt-SDK-ar71xx-generic_gcc-5.3.0_musl-1.1.15.Linux-x86_64.tar.bz2 | \
        tar --strip-components 1 -C /openwrt/mips-unknown-linux-musl -xj
    curl -sL $openwrt/malta/generic/OpenWrt-SDK-malta-le_gcc-5.3.0_musl-1.1.15.Linux-x86_64.tar.bz2 | \
        tar --strip-components 1 -C /openwrt/mipsel-unknown-linux-musl -xj

    local f g
    for f in $(echo /openwrt/mips*-unknown-linux-musl/staging_dir/toolchain*/bin/*); do
        g=$(basename $f)
        ln -fs $f /usr/local/bin/$g
    done
}

x86_musl() {
    local version=1.1.14

    mkdir -p /musl/i686-unknown-linux-musl

    pushd /musl
    curl -sL https://www.musl-libc.org/releases/musl-$version.tar.gz | \
        tar -xz

    pushd musl-$version
    CFLAGS="$CFLAGS -m32" ./configure \
          --prefix=/musl/i686-unknown-linux-musl \
          --disable-shared \
          --target=i686
    make -j$(nproc)
    make install
    popd

    rm -rf musl-$version
    popd
}

passwordless_sudo() {
    echo 'ALL ALL=(ALL) NOPASSWD: ALL' | (EDITOR="tee -a" visudo)
}

cleanup() {
    rm /setup.sh
}

main
