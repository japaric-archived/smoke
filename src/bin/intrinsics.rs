#![allow(unused_features)]
#![deny(dead_code)]
#![feature(compiler_builtins_lib)]
#![feature(core_float)]
#![feature(lang_items)]
#![feature(libc)]
#![feature(start)]
#![no_std]

extern crate compiler_builtins;
extern crate libc;

use core::num::Float;

// trunccdfsf2
fn aeabi_d2f(x: f64) -> f32 {
    x as f32
}

// fixdfsi
fn aeabi_d2i(x: f64) -> i32 {
    x as i32
}

// fixdfdi
fn aeabi_d2l(x: f64) -> i64 {
    x as i64
}

// fixunsdfsi
fn aeabi_d2ui(x: f64) -> u32 {
    x as u32
}

// fixunsdfdi
fn aeabi_d2ul(x: f64) -> u64 {
    x as u64
}

// adddf3
fn aeabi_dadd(a: f64, b: f64) -> f64 {
    a + b
}

// eqdf2
fn aeabi_dcmpeq(a: f64, b: f64) -> bool {
    a == b
}

// gtdf2
fn aeabi_dcmpgt(a: f64, b: f64) -> bool {
    a > b
}

// ltdf2
fn aeabi_dcmplt(a: f64, b: f64) -> bool {
    a < b
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

// extendsfdf2
fn aeabi_f2d(x: f32) -> f64 {
    x as f64
}

// fixsfsi
fn aeabi_f2i(x: f32) -> i32 {
    x as i32
}

// fixsfdi
fn aeabi_f2l(x: f32) -> i64 {
    x as i64
}

// fixunssfsi
fn aeabi_f2ui(x: f32) -> u32 {
    x as u32
}

// fixunssfdi
fn aeabi_f2ul(x: f32) -> u64 {
    x as u64
}

// addsf3
fn aeabi_fadd(a: f32, b: f32) -> f32 {
    a + b
}

// eqsf2
fn aeabi_fcmpeq(a: f32, b: f32) -> bool {
    a == b
}

// gtsf2
fn aeabi_fcmpgt(a: f32, b: f32) -> bool {
    a > b
}

// ltsf2
fn aeabi_fcmplt(a: f32, b: f32) -> bool {
    a < b
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

// floatsidf
fn aeabi_i2d(x: i32) -> f64 {
    x as f64
}

// floatsisf
fn aeabi_i2f(x: i32) -> f32 {
    x as f32
}

fn aeabi_idivmod(a: i32, b: i32) -> i32 {
    a % b
}

// floatdidf
fn aeabi_l2d(x: i64) -> f64 {
    x as f64
}

// floatdisf
fn aeabi_l2f(x: i64) -> f32 {
    x as f32
}

// divdi3
fn aeabi_ldivmod(a: i64, b: i64) -> i64 {
    a / b
}

// muldi3
fn aeabi_lmul(a: i64, b: i64) -> i64 {
    a.wrapping_mul(b)
}

// floatunsidf
fn aeabi_ui2d(x: u32) -> f64 {
    x as f64
}

// floatunsisf
fn aeabi_ui2f(x: u32) -> f32 {
    x as f32
}

fn aeabi_uidiv(a: u32, b: u32) -> u32 {
    a / b
}

fn aeabi_uidivmod(a: u32, b: u32) -> u32 {
    a % b
}

// floatundidf
fn aeabi_ul2d(x: u64) -> f64 {
    x as f64
}

// floatundisf
fn aeabi_ul2f(x: u64) -> f32 {
    x as f32
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

fn powidf2(a: f64, b: i32) -> f64 {
    a.powi(b)
}

fn powisf2(a: f32, b: i32) -> f32 {
    a.powi(b)
}

fn umoddi3(a: u64, b: u64) -> u64 {
    a % b
}

#[start]
fn main(_: isize, _: *const *const u8) -> isize {
    aeabi_d2f(2.);
    aeabi_d2i(2.);
    aeabi_d2l(2.);
    aeabi_d2ui(2.);
    aeabi_d2ul(2.);
    aeabi_dadd(2., 3.);
    aeabi_dcmpeq(2., 3.);
    aeabi_dcmpgt(2., 3.);
    aeabi_dcmplt(2., 3.);
    aeabi_ddiv(2., 3.);
    aeabi_dmul(2., 3.);
    aeabi_dsub(2., 3.);
    aeabi_f2d(2.);
    aeabi_f2i(2.);
    aeabi_f2l(2.);
    aeabi_f2ui(2.);
    aeabi_f2ul(2.);
    aeabi_fadd(2., 3.);
    aeabi_fcmpeq(2., 3.);
    aeabi_fcmpgt(2., 3.);
    aeabi_fcmplt(2., 3.);
    aeabi_fdiv(2., 3.);
    aeabi_fmul(2., 3.);
    aeabi_fsub(2., 3.);
    aeabi_i2d(2);
    aeabi_i2f(2);
    aeabi_idivmod(2, 3);
    aeabi_l2d(2);
    aeabi_l2f(2);
    aeabi_ldivmod(2, 3);
    aeabi_lmul(2, 3);
    aeabi_ui2d(2);
    aeabi_ui2f(2);
    aeabi_uidiv(2, 3);
    aeabi_uidivmod(2, 3);
    aeabi_ul2d(2);
    aeabi_ul2f(2);
    aeabi_uldivmod(2, 3);
    moddi3(2, 3);
    mulodi4(2, 3);
    powidf2(2., 3);
    powisf2(2., 3);
    umoddi3(2, 3);

    0
}

// ARM targets need these symbols
#[no_mangle]
pub fn __aeabi_unwind_cpp_pr0() {}

#[no_mangle]
pub fn __aeabi_unwind_cpp_pr1() {}

// Lang items
#[cfg(not(test))]
#[lang = "eh_personality"]
extern fn eh_personality() {}

#[cfg(not(test))]
#[lang = "panic_fmt"]
extern fn panic_fmt() {}
