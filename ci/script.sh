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
    [[ $? == 101 ]] || exit 1
    set -e

    run start --release
    run hello --release
    set +e
    run panic --release
    [[ $? == 101 ]] || exit 1
    set -e
}

run_tests() {
    if [[ $QEMU_LD_PREFIX ]]; then
        export RUST_TEST_THREADS=1
    fi

    cargo test --target $TARGET
    cargo test --target $TARGET --release
}

libc_test() {
    git clone --depth 1 https://github.com/rust-lang/libc
    cargo run --target $TARGET --manifest-path libc/libc-test/Cargo.toml
}

main() {
    if [[ ${IN_DOCKER_CONTAINER:-n} == "n" ]]; then
        local gid=$(id -g) group=$(id -g -n) uid=$(id -u) user=$(id -u -n)

        docker run \
               --entrypoint bash \
               --privileged \
               -e IN_DOCKER_CONTAINER=y \
               -e TARGET=$TARGET \
               -e TRAVIS_OS_NAME=$TRAVIS_OS_NAME \
               -v $(pwd):/mnt \
               japaric/smoke \
               -c "
set -ex
update-binfmts --import
groupadd -g $gid $group
useradd -m -g $gid -u $uid $user
cd /mnt
su -c 'bash ci/install.sh && bash ci/script.sh' $user
"
    else
        run_apps
        run_tests
        libc_test
    fi
}

main
