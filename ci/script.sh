set -ex

. $(dirname $0)/env.sh

failures=()

try() {
    set +e
    eval "$2"

    if [[ $? != 0 ]]; then
        failures+=( $1 )
    fi
    set -e
}

run() {
    cargo run --target $TARGET --bin "${@}"
}

run_apps() {
    try 'start.debug' "run start"
    try 'hello.debug' "run hello"
    try 'panic.debug' "
run panic
[[ \$? == 101 ]] || exit 1
"

    try 'start.release' "run start --release"
    try 'hello.release' "run hello --release"
    try 'panic.release' "
run panic --release
[[ \$? == 101 ]] || exit 1
"
}

run_intrinsics() {
    if [[ $LINUX ]]; then
        try 'intrinsics' "cargo build --target $TARGET --bin intrinsics"

        cp src/bin/intrinsics.rs{,.bk}
        sed -i '/compiler_builtins/d' src/bin/intrinsics.rs
        echo 'Intrinsics provided by compiler_builtins'
        cargo build --target $TARGET --bin intrinsics 2>&1 | grep undefined | cut -d'`' -f2
        mv src/bin/intrinsics.rs{.bk,}
    fi
}

run_unit_tests() {
    if [[ $QEMU_LD_PREFIX ]]; then
        export RUST_TEST_THREADS=1
    fi

    try 'cargo_test.debug' "cargo test --target $TARGET"
    try 'cargo_test.release' "cargo test --target $TARGET --release"
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
        term
        test
        unwind
    )
    # FIXME re-enable std
    # This has been disabled because it fails when cross testing targets like arm, aarch64 and mips
    # due to QEMU limitations
    # std

    local crate flags lib_rs
    for crate in ${crates[@]}; do
        flags="--crate-name $crate --target $TARGET --test"
        lib_rs=$(rustc --print sysroot)/lib/rustlib/src/rust/src/lib$crate/lib.rs

        # debug
        if [[ ${!linker} ]]; then
            rustc $flags -C linker=${!linker} $lib_rs
        else
            rustc $flags $lib_rs
        fi
        try "$crate.debug" "./$crate"

        # release
        if [[ ${!linker} ]]; then
            rustc $flags -C linker=${!linker} -C opt-level=3 $lib_rs
        else
            rustc $flags -C opt-level=3 $lib_rs
        fi
        try "$crate.release" "./$crate"

        rm $crate
    done
}

run_libc_test() {
    try 'libc_test' "cargo run --target $TARGET --manifest-path libc/libc-test/Cargo.toml"
}

report_failures() {
    set +x

    if [[ $failures ]]; then
        echo FAILURES
        echo --------

        for failure in ${failures[@]}; do
            echo $failure
        done

        exit 1
    fi

    set -x
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
        run_intrinsics
        run_unit_tests
        run_libc_test
        run_std_tests
        report_failures
    fi
}

main
