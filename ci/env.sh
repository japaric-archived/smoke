export HOST=x86_64-unknown-linux-gnu

case $TARGET in
    aarch64-unknown-linux-gnu)
        export PREFIX=aarch64-linux-gnu-
        export QEMU_LD_PREFIX=/usr/aarch64-linux-gnu
        ;;
    arm*-unknown-linux-gnueabi)
        export PREFIX=arm-linux-gnueabi-
        export QEMU_LD_PREFIX=/usr/arm-linux-gnueabi
        ;;
    arm-unknown-linux-gnueabihf)
        export PREFIX=arm-linux-gnueabihf-
        export QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf
        ;;
    armv7-unknown-linux-gnueabihf)
        export PREFIX=arm-linux-gnueabihf-
        export QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf
        ;;
    i586-unknown-linux-gnu)
        # NOTE $DOCKER values: 'y' (yes, call docker), 'i' (inside a docker container) or 'n' ("no)
        if [[ -z $DOCKER ]]; then
            export DOCKER=y
        fi
        ;;
    i686-unknown-linux-musl)
        if [[ -z $DOCKER ]]; then
            export DOCKER=y
        fi
        ;;
    mips-unknown-linux-gnu)
        if [[ -z $DOCKER ]]; then
            export DOCKER=y
        fi
        export PREFIX=mips-linux-gnu-
        export QEMU=qemu-mips
        export QEMU_LD_PREFIX=/usr/mips-linux-gnu
        ;;
    mipsel-unknown-linux-gnu)
        if [[ -z $DOCKER ]]; then
            export DOCKER=y
        fi
        export PREFIX=mipsel-linux-gnu-
        export QEMU=qemu-mipsel
        export QEMU_LD_PREFIX=/usr/mipsel-linux-gnu
        ;;
    mipsel-unknown-linux-musl)
        if [[ -z $DOCKER ]]; then
            export DOCKER=y
        fi
        export PREFIX=mipsel-openwrt-linux-
        export QEMU=qemu-mipsel
        export QEMU_LD_PREFIX=/usr/local/mipsel-openwrt-linux
        ;;
    powerpc-unknown-linux-gnu)
        export PREFIX=powerpc-linux-gnu-
        export QEMU_LD_PREFIX=/usr/powerpc-linux-gnu
        ;;
    powerpc64-unknown-linux-gnu)
        if [[ -z $DOCKER ]]; then
            export DOCKER=y
        fi
        export PREFIX=powerpc64-linux-gnu-
        export QEMU=qemu-ppc64
        export QEMU_LD_PREFIX=/usr/powerpc64-linux-gnu
        ;;
    powerpc64le-unknown-linux-gnu)
        if [[ -z $DOCKER ]]; then
            export DOCKER=y
        fi
        export PREFIX=powerpc64le-linux-gnu-
        export QEMU=qemu-ppc64le
        export QEMU_LD_PREFIX=/usr/powerpc64le-linux-gnu
        ;;
esac
