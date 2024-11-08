const std = @import("std");

pub fn modInverse(comptime T: type, n: T, p: T) T {
    var p0: i64 = @intCast(p);
    var n0: i64 = @intCast(n);
    var y: i64 = 0;
    var x: i64 = 1;
    if (p == 1) {
        return 0;
    }

    while (n0 > 1) {
        const q = @divTrunc(n0, p0); // n0 / p0
        var t = p0;
        p0 = @mod(n0, p0); // n0 % p0;
        n0 = t;
        t = y;
        y = x - q * y;
        x = t;
    }

    if (x < 0) {
        x += @intCast(p);
    }
    return @intCast(x);
}

test "mod inverse" {
    const test_case = @import("./testcase.zig").TestCases([2]u32, u32);
    const testcases = [_]test_case{
        .{
            .input = .{ 342952340, 4230493243 },
            .expected = 583739113,
        },
        .{
            .input = .{ 937513, 638471 },
            .expected = 426364,
        },
        .{
            .input = .{ 197, 3000 },
            .expected = 533,
        },
        .{
            .input = .{ 15, 26 },
            .expected = 7,
        },
    };

    for (testcases) |testcase| {
        const result = modInverse(u32, testcase.input[0], testcase.input[1]);
        std.testing.expect(result == testcase.expected) catch |err| {
            std.debug.print("Error: {}; Expected: {} but got {}\n", .{ err, testcase.expected, result });
        };
    }
}
