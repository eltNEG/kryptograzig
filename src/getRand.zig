const std = @import("std");

pub fn getRand(comptime T: type, at_most: T) !T {
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    const rand = prng.random();
    const d = rand.intRangeAtMost(T, 2, at_most);
    return d;
}

test "getRand" {
    var x: [10]u32 = undefined;
    var y: [10]u32 = undefined;

    for (0..10) |i| {
        x[i] = try getRand(u32, 10);
        y[i] = try getRand(u32, 10);
    }

    try std.testing.expect(!std.mem.eql(u32, &x, &y));
}
