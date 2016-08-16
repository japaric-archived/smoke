export HOST=x86_64-unknown-linux-gnu

case $TARGET in
    aarch64-unknown-linux-gnu)
        export QEMU_LD_PREFIX=/usr/aarch64-linux-gnu
        ;;
    arm-unknown-linux-gnueabi)
        export QEMU_LD_PREFIX=/usr/arm-linux-gnueabi
        ;;
    arm*-unknown-linux-gnueabihf)
        export QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf
        ;;
    mips-unknown-linux-gnu)
        export QEMU_LD_PREFIX=/usr/mips-linux-gnu
        ;;
    mipsel-unknown-linux-gnu)
        export QEMU_LD_PREFIX=/usr/mipsel-linux-gnu
        ;;
    powerpc-unknown-linux-gnu)
        export QEMU_LD_PREFIX=/usr/powerpc-linux-gnu
        ;;
    powerpc64-unknown-linux-gnu)
        export QEMU_LD_PREFIX=/usr/powerpc64-linux-gnu
        ;;
    powerpc64le-unknown-linux-gnu)
        export QEMU_LD_PREFIX=/usr/powerpc64le-linux-gnu
        ;;
esac
