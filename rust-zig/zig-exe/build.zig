const std = @import("std");
const fs = std.fs;

const RUST_DIR = "../rust-lib";
const RUST_RELEASE_DIR = RUST_DIR ++ "/target/release";
const DLL_NAME = "rust_lib.dll";

const RUST_DLL_RELEASE_PATH = RUST_RELEASE_DIR ++ "/" ++ DLL_NAME;
const ZIG_BIN_OUT_DIR = "zig-out/bin";

pub fn build(b: *std.Build) !void {
    _ = b.run(&[_][]const u8{ "cargo", "build", "--manifest-path", RUST_DIR ++ "/Cargo.toml", "--release" });
    const cwd = fs.cwd();
    std.debug.print("Copying {s} to {s}\n", .{ RUST_DLL_RELEASE_PATH, ZIG_BIN_OUT_DIR });
    try fs.Dir.copyFile(cwd, RUST_DLL_RELEASE_PATH, cwd, ZIG_BIN_OUT_DIR ++ "/" ++ DLL_NAME, .{});
    std.debug.print("Copied rust-lib.dll to {s}\n", .{ZIG_BIN_OUT_DIR});

    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zig-exe",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
