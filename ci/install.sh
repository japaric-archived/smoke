set -ex

. $(dirname $0)/env.sh

install_qemu() {
    apt-get install -y --no-install-recommends \
            binfmt-support qemu-user-static
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

main() {
    apt-get update
    install_qemu
    install_rust
    add_rustup_target
}

main
