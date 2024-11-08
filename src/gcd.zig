pub fn gcd(T: type, a: T, b: T) T {
    var x = a;
    var y = b;
    while (y != 0) {
        const t = y;
        y = x % y;
        x = t;
    }
    return x;
}

test "gcd" {
    const TestCase = @import("./testcase.zig").TestCases([2]u128, u128);
    const test_cases = [_]TestCase{
        .{
            .input = .{ 3, 11 },
            .expected = 1,
        },
        .{
            .input = .{ 287, 91 },
            .expected = 7,
        },
        .{
            .input = .{ 499017086208, 676126714752 },
            .expected = 93312,
        },
        .{
            .input = .{ 5988737349, 578354589 },
            .expected = 9,
        },
    };

    for (test_cases) |tc| {
        const a = tc.input[0];
        const b = tc.input[1];
        const result = gcd(u128, a, b);
        const std = @import("std");
        std.testing.expect(result == tc.expected) catch |err| {
            std.debug.print("Error: {}; Expected: {} but got {}\n", .{ err, tc.expected, result });
        };
    }
}
