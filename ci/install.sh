set -ex

. $(dirname $0)/env.sh

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

add_rust_src() {
    rustup component add rust-src
}

main() {
    if [[ $OSX || ${IN_DOCKER_CONTAINER:-n} == y ]]; then
        install_rust
        add_rustup_target
        add_rust_src

        # FIXME this should be installed in the docker image itself
        if [[ $TARGET =~ .*86.*musl ]]; then
            sudo apt-get install -y musl-tools
        fi

        if [[ $QEMU_LD_PREFIX ]]; then
            # FIXME don't do this, instead use update-binfmts to register the binfmts
            sudo apt-get remove -y qemu-user-static
            sudo apt-get install -y qemu-user-static
        fi
    fi
}

main
