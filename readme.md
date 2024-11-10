# Cryptography

Simple public key cryptography algorithms implemented in zig. For educational purposes only.

## Algorithms
- RSA
- ElGamal

## Installation
Fetch this dependency by running the following command in your project:
```bash
zig fetch --save git+https://github.com/eltNEG/kryptograzig#master
```

Then add the following to your `build.zig` file:
```zig
b.installArtifact(exe); // this line should already be in your build.zig file

const cryptography = b.dependency("kryptograzig", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("kryptograzig", cryptography.module("kryptograzig"));
```

## Usage
Import the library and use the functions as shown below:
```zig
const std = @import("std");
const kryptograzig = @import("kryptograzig");

pub fn main() !void {
    std.debug.print("Hello, world!\n", .{});
    const r = kryptograzig.gcd(u8, 10, 5);
    std.debug.print("gcd(10, 5) = {}\n", .{r});

    const alloc = std.heap.page_allocator;
    const factors = try kryptograzig.factorise(u128, alloc, 2 * 2 * 17 * 17 * 19 * 19 * 29 * 29 * 97 * 97 * 101 * 101 * 103 * 103);
    defer alloc.free(factors);
    std.debug.print("factors = {any}\n", .{factors});
}
```


## Tests
```bash
zig build test
```

## Dependencies
- [Zig v0.13.0](https://ziglang.org/)
