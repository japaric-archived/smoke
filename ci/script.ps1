Set-PSDebug -Trace 1

cargo run --target $Env:TARGET --bin start
cargo run --target $Env:TARGET --bin hello

# TODO How do I check the exit code?
# - cargo run --target %TARGET% --bin panic

cargo run --target $Env:TARGET --bin start --release
cargo run --target $Env:TARGET --bin hello --release

# TODO How do I check the exit code?
# - cargo run --target %TARGET% --bin panic --release

cargo test --target $Env:TARGET
cargo test --target $Env:TARGET --release

git clone --depth 1 https://github.com/rust-lang/libc
cargo run --target $Env:TARGET --manifest-path libc/libc-test/Cargo.toml

$crates = @(
    'alloc',
    'alloc_system',
    'collections',
    'collectionstest',
    'coretest',
    'getopts',
    'panic_abort',
    'rand',
    'rustc_bitflags',
    'std',
    'term',
    'test',
    'unwind'
)

rustup component add rust-src

ForEach ($crate in $crates) {
    $flags = @('--crate-name', "$crate", '--target', "$Env:TARGET", '--test')
    $lib_rs = "$(rustc --print sysroot)\lib\rustlib\src\rust\src\lib$crate\lib.rs"

    rustc $flags $lib_rs

    & ".\$crate"

    rustc $flags -C opt-level=3 $lib_rs

    & ".\$crate"
}



