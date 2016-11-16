set -ex

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
test \$? = 101
"

    try 'start.release' "run start --release"
    try 'hello.release' "run hello --release"
    try 'panic.release' "
run panic --release
test \$? = 101
"
}

run_unit_tests() {
    try 'cargo_test.debug' "cargo test --target $TARGET"
    try 'cargo_test.release' "cargo test --target $TARGET --release"
}

run_std_tests() {
    local linker=CARGO_TARGET_$(echo $TARGET | tr '[a-z]-' '[A-Z]_')_LINKER
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
        flags="--crate-name $crate --target $TARGET --test --out-dir /tmp"
        lib_rs=$(rustc --print sysroot)/lib/rustlib/src/rust/src/lib$crate/lib.rs

        # debug
        if [[ ${!linker} ]]; then
            rustc $flags -C linker=${!linker} $lib_rs
        else
            rustc $flags $lib_rs
        fi
        try "$crate.debug" "/tmp/$crate"

        # release
        if [[ ${!linker} ]]; then
            rustc $flags -C linker=${!linker} -C opt-level=3 $lib_rs
        else
            rustc $flags -C opt-level=3 $lib_rs
        fi
        try "$crate.release" "/tmp/$crate"

        rm /tmp/$crate
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
    run_apps
    run_unit_tests

    case $TARGET in
        # TODO the ARM-musl targets need an arm-musl-gcc toolchain
        arm*musleabi*) ;;
        *) run_libc_test
    esac

    run_std_tests
    report_failures
}

main
