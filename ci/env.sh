# rustup
export PATH="$HOME/.cargo/bin:$PATH"

case $TRAVIS_OS_NAME in
    linux)
        HOST=x86_64-unknown-linux-gnu
        LINUX=1
        SED=sed
        ;;
    osx)
        HOST=x86_64-apple-darwin
        OSX=1
        SED=gsed
        ;;
esac

if [[ $LINUX ]]; then
    case $TARGET in
        armv7-unknown-linux-gnueabihf)
            QEMU_LD_PREFIX=/usr/arm-linux-gnueabihf
            ;;
        aarch64-unknown-linux-gnu |\
            arm-unknown-linux-gnueabi |\
            arm*-unknown-linux-gnueabihf |\
            mips*-unknown-linux-gnu |\
            powerpc*-unknown-linux-gnu)
            QEMU_LD_PREFIX=/usr/${TARGET//unknown-/}
            ;;
        mips*-unknown-linux-musl)
            export STAGING_DIR=/openwrt/$TARGET/staging_dir
            QEMU_LD_PREFIX=$(echo $STAGING_DIR/toolchain-*)
            ;;
    esac

    export QEMU_LD_PREFIX
fi
