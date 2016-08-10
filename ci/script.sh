set -ex

. $(dirname $0)/env.sh

build() {
    cargo build --target $TARGET
    cargo build --target $TARGET --release
    cargo test --target $TARGET --no-run
    cargo test --target $TARGET --no-run --release
}

run_tests() {
    export RUST_TEST_THREADS=1

    if [[ $QEMU ]]; then
        # DEBUG
        $QEMU target/$TARGET/debug/start
        $QEMU target/$TARGET/debug/hello
        set +e
        $QEMU target/$TARGET/debug/panic
        [[ $? == "101" ]] || exit 1
        set -e
        $QEMU target/$TARGET/debug/it_works-*
        $QEMU target/$TARGET/debug/should_panic-*
        $QEMU target/$TARGET/debug/catch_uwwind-*

        # RELEASE
        $QEMU target/$TARGET/release/start
        $QEMU target/$TARGET/release/hello
        set +e
        $QEMU target/$TARGET/release/panic
        [[ $? == "101" ]] || exit 1
        set -e
        $QEMU target/$TARGET/release/it_works-*
        $QEMU target/$TARGET/release/should_panic-*
        $QEMU target/$TARGET/release/catch_uwwind-*
    else
        # DEBUG
        cargo run --bin start
        cargo run --bin hello
        set +e
        cargo run --bin panic
        [[ $? == "101" ]] || exit 1
        set -e
        cargo test --target $TARGET

        # RELEASE
        cargo run --bin start --release
        cargo run --bin hello --release
        set +e
        cargo run --bin panic --release
        [[ $? == "101" ]] || exit 1
        set -e
        cargo test --target $TARGET --release
    fi
}

main() {
    if [[ $DOCKER == "y" ]]; then
        docker run \
               -e DOCKER=i \
               -e TARGET=$TARGET \
               -v $(pwd):/mnt \
               ubuntu:16.04 \
               sh -c 'set -ex;
                      cd /mnt;
                      export PATH="$PATH:$HOME/.cargo/bin";
                      bash ci/install.sh;
                      bash ci/script.sh'
    else
        build
        run_tests
    fi
}

main
