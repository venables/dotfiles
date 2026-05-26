//! Clone a directory tree with APFS copy-on-write via clonefile(2).
//!
//! clonefile copies an entire hierarchy in a single syscall, ~10x faster than
//! `cp -cR` (which issues one clonefile per file). The post-worktree-add hook
//! builds this on demand, caches the binary, and uses it to seed a new
//! worktree's node_modules. See that hook for the build/fallback logic.
//!
//! Usage: clone_dir <src> <dst>   (dst must not already exist)

use std::ffi::CString;
use std::os::raw::c_char;
use std::os::unix::ffi::OsStrExt;

extern "C" {
    fn clonefile(src: *const c_char, dst: *const c_char, flags: u32) -> i32;
}

fn main() {
    let args: Vec<_> = std::env::args_os().collect();
    if args.len() != 3 {
        eprintln!("usage: clone_dir <src> <dst>");
        std::process::exit(2);
    }
    let src = CString::new(args[1].as_bytes()).expect("src path contains NUL");
    let dst = CString::new(args[2].as_bytes()).expect("dst path contains NUL");
    let rc = unsafe { clonefile(src.as_ptr(), dst.as_ptr(), 0) };
    std::process::exit(if rc == 0 { 0 } else { 1 });
}
