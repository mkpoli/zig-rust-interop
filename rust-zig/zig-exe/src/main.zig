const std = @import("std");

pub fn main() !void {
    var dll = try std.DynLib.open("rust_lib.dll");
    const add = dll.lookup(*fn (i32, i32) i32, "add").?;

    std.debug.print("rust_lib.dll: add({}, {}) = {}\n", .{
        1,
        2,
        add(1, 2),
    });
}
