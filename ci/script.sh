set -ex

. $(dirname $0)/env.sh

run() {
    cargo run --target $TARGET --bin "${@}"
}

run_apps() {
    run start
    run hello
    set +e
    run panic
    [[ $? == "101" ]] || exit 1
    set -e

    run start --release
    run hello --release
    set +e
    run panic --release
    [[ $? == "101" ]] || exit 1
    set -e
}

run_tests() {
    export RUST_TEST_THREADS=1

    cargo test --target $TARGET
    cargo test --target $TARGET --release
}

main() {
    if [[ ${IN_DOCKER_CONTAINER:-n} == "n" ]]; then
        local tag=2016-08-13

        docker run \
               --privileged \
               -e IN_DOCKER_CONTAINER=y \
               -e TARGET=$TARGET \
               -v $(pwd):/mnt \
               japaric/rustc-builtins:$tag \
               sh -c 'set -ex;
                      cd /mnt;
                      export PATH="$PATH:/root/.cargo/bin";
                      bash ci/install.sh;
                      bash ci/script.sh'
    else
        run_apps
        run_tests
    fi
}

main
