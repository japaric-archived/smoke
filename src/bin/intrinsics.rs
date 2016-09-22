#![allow(unused_features)]
#![deny(dead_code)]
#![feature(compiler_builtins_lib)]
#![feature(lang_items)]
#![feature(start)]
#![no_std]

extern crate compiler_builtins;

// adddf3
fn aeabi_dadd(a: f64, b: f64) -> f64 {
    a + b
}

// divdf3
fn aeabi_ddiv(a: f64, b: f64) -> f64 {
    a / b
}

// muldf3
fn aeabi_dmul(a: f64, b: f64) -> f64 {
    a * b
}

// subdf3
fn aeabi_dsub(a: f64, b: f64) -> f64 {
    a - b
}

// addsf3
fn aeabi_fadd(a: f32, b: f32) -> f32 {
    a + b
}

// divsf3
fn aeabi_fdiv(a: f32, b: f32) -> f32 {
    a / b
}

// mulsf3
fn aeabi_fmul(a: f32, b: f32) -> f32 {
    a * b
}

// subsf3
fn aeabi_fsub(a: f32, b: f32) -> f32 {
    a - b
}

fn aeabi_idivmod(a: i32, b: i32) -> i32 {
    a % b
}

// divdi3
fn aeabi_ldivmod(a: i64, b: i64) -> i64 {
    a / b
}

fn aeabi_uidiv(a: u32, b: u32) -> u32 {
    a / b
}

fn aeabi_uidivmod(a: u32, b: u32) -> u32 {
    a % b
}

// udivdi3
fn aeabi_uldivmod(a: u64, b: u64) -> u64 {
    a * b
}

fn moddi3(a: i64, b: i64) -> i64 {
    a % b
}

fn mulodi4(a: i64, b: i64) -> i64 {
    a * b
}

fn umoddi3(a: u64, b: u64) -> u64 {
    a % b
}

#[start]
fn main(_: isize, _: *const *const u8) -> isize {
    aeabi_dadd(2., 3.);
    aeabi_ddiv(2., 3.);
    aeabi_dmul(2., 3.);
    aeabi_dsub(2., 3.);
    aeabi_fadd(2., 3.);
    aeabi_fdiv(2., 3.);
    aeabi_fmul(2., 3.);
    aeabi_fsub(2., 3.);
    aeabi_idivmod(2, 3);
    aeabi_ldivmod(2, 3);
    aeabi_uidiv(2, 3);
    aeabi_uidivmod(2, 3);
    aeabi_uldivmod(2, 3);
    moddi3(2, 3);
    mulodi4(2, 3);
    umoddi3(2, 3);

    0
}

#[link(name = "c")]
extern "C" {}

// ARM targets need these symbols
#[no_mangle]
pub fn __aeabi_unwind_cpp_pr0() {}

#[no_mangle]
pub fn __aeabi_unwind_cpp_pr1() {}

// Lang items
#[lang = "eh_personality"]
extern fn eh_personality() {}

#[lang = "panic_fmt"]
extern fn panic_fmt() {}
