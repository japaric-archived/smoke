
case $TRAVIS_OS_NAME in
    linux)
        HOST=x86_64-unknown-linux-gnu
        LINUX=1
        ;;
    osx)
        HOST=x86_64-apple-darwin
        OSX=1
        ;;
esac

if [[ $LINUX ]]; then
    case $TARGET in
        aarch64-unknown-linux-gnu |\
            arm-unknown-linux-gnueabi |\
            arm*-unknown-linux-gnueabihf |\
            mips*-unknown-linux-gnu |\
            powerpc*-unknown-linux-gnu)
            QEMU_LD_PREFIX=${TARGET//unknown-/}
            ;;
        mips*-unknown-linux-musl)
            export STAGING_DIR=/openwrt/$TARGET/staging_dir
            QEMU_LD_PREFIX=$(echo $STAGING_DIR/toolchain-*)
            ;;
    esac

    export QEMU_LD_PREFIX
fi

if [[ -e ~/.cargo/env ]]; then
    source ~/.cargo/env
fi
