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

run_unit_tests() {
    if [[ $QEMU_LD_PREFIX ]]; then
        export RUST_TEST_THREADS=1
    fi

    cargo test --target $TARGET
    cargo test --target $TARGET --release
}

run_std_tests() {
    local linker=CC_${TARGET//-/_}
    local crates=(
        alloc
        alloc_system
        collections
        collectionstest
        coretest
        getopts
        panic_abort
        rand
        rustc_bitflags
        std
        term
        test
        unwind
    )

    local crate lib_rs
    for crate in ${crates[@]}; do
        lib_rs=$(rustc --print sysroot)/lib/rustlib/src/rust/src/lib$crate/lib.rs

        if [[ ${!linker} ]]; then
            rustc --test --target $TARGET -C linker=${!linker} $lib_rs
        else
            rustc --test --target $TARGET $lib_rs
        fi
        ./$crate || ./lib

        if [[ ${!linker} ]]; then
            rustc --test --release --target $TARGET -C linker=${!linker} $lib_rs
        else
            rustc --test --release --target $TARGET $lib_rs
        fi
        ./$crate || ./lib

        rm $crate || rm lib
    done

}

run_libc_test() {
    cargo run --target $TARGET --manifest-path libc/libc-test/Cargo.toml
}

main() {
    if [[ $LINUX && ${IN_DOCKER_CONTAINER:-n} == n ]]; then
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
        run_unit_tests
        run_std_tests
        run_libc_test
    fi
}

main
