use std::panic;

#[test]
fn catch_unwind() {
    assert!(panic::catch_unwind(|| panic!()).is_err());
}
