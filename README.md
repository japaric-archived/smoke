[![Travis][travis]](https://travis-ci.org/japaric/smoke)
[![AppVeyor][appveyor]](https://ci.appveyor.com/project/japaric/smoke)

[appveyor]: https://ci.appveyor.com/api/projects/status/67t9m8nhj5wb965b?svg=true
[travis]: https://travis-ci.org/japaric/smoke.svg?branch=master

# `smoke`

> Smoke testing Rust's cross compilation targets

## Supported targets

### Travis (Linux)

Native-ish

- [x] i586-unknown-linux-gnu
- [x] i686-unknown-linux-gnu
- [x] i686-unknown-linux-musl
- [x] x86_64-unknown-linux-gnu
- [x] x86_64-unknown-linux-musl

QEMU

- [x] aarch64-unknown-linux-gnu
- [x] arm-unknown-linux-gnueabi
- [x] arm-unknown-linux-gnueabihf
- [x] armv7-unknown-linux-gnueabihf
- [x] mips-unknown-linux-gnu
- [x] mips-unknown-linux-musl
- [x] mipsel-unknown-linux-gnu
- [x] mipsel-unknown-linux-musl
- [x] powerpc-unknown-linux-gnu
- [x] powerpc64-unknown-linux-gnu
- [x] powerpc64le-unknown-linux-gnu (\*)

(\*) QEMU is broken so we can't run any test.

Waiting for releases of `std` for these targets

- [ ] arm-unknown-linux-musleabi
- [ ] arm-unknown-linux-musleabihf
- [ ] armv7-unknown-linux-musleabihf
- [ ] mips-unknown-linux-uclibc
- [ ] mipsel-unknown-linux-uclibc
- [ ] s390x-unknown-linux-gnu

No idea how to test these

- [ ] aarch64-linux-android
- [ ] arm-linux-androideabi
- [ ] armv7-linux-androideabi
- [ ] asmjs-unknown-emscripten
- [ ] i686-linux-android
- [ ] le32-unknown-nacl

### Travis (OSX)

- [x] i686-apple-darwin
- [x] x86_64-apple-darwin

No idea how to test these

- [ ] aarch64-apple-ios
- [ ] armv7-apple-ios
- [ ] armv7s-apple-ios
- [ ] i386-apple-ios
- [ ] x86_64-apple-ios

### AppVeyor

- [ ] i586-pc-windows-msvc
- [x] i686-pc-windows-gnu
- [ ] i686-pc-windows-msvc
- [x] x86_64-pc-windows-gnu
- [x] x86_64-pc-windows-msvc

### ???

No CI service where to test these

- [ ] i686-unknown-dragonfly
- [ ] i686-unknown-freebsd
- [ ] x86_64-rumprun-netbsd
- [ ] x86_64-sun-solaris
- [ ] x86_64-unknown-bitrig
- [ ] x86_64-unknown-dragonfly
- [ ] x86_64-unknown-freebsd
- [ ] x86_64-unknown-netbsd
- [ ] x86_64-unknown-openbsd

## License

Licensed under either of

- Apache License, Version 2.0 ([LICENSE-APACHE](LICENSE-APACHE) or
  http://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

### Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the
work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without any
additional terms or conditions.
