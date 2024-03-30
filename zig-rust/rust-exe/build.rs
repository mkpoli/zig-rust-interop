use std::{env, fs, path::Path};

const LIB_NAME: &str = "zig-lib";
const ZIG_OUT_DIR: &str = "../zig-lib/zig-out/lib";

fn main() {
    // println!("cargo:rustc-link-search=native={}", ZIG_OUT_DIR);
    // println!("cargo:rustc-link-lib=dylib={}", LIB_NAME);

    let rust_root = env::var("CARGO_MANIFEST_DIR").unwrap();
    let profile = env::var("PROFILE").unwrap();
    let dll_name = format!("{}.dll", LIB_NAME);
    let out_dir = Path::new(&rust_root).join("target").join(&profile);

    let src_path = Path::new(ZIG_OUT_DIR).join(&dll_name);
    let dst_path = Path::new(&out_dir).join(&dll_name);

    if !src_path.exists() {
        panic!(
            "{} not found. Run `cd ../zig-lib && zig build` first.",
            src_path.display()
        );
    }

    fs::copy(&src_path, &dst_path).unwrap();
}
