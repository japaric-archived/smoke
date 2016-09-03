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

main() {
    if [[ $OSX || ${IN_DOCKER_CONTAINER:-n} == y ]]; then
        install_rust
        add_rustup_target
    fi
}

main
