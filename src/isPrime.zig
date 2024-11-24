pub fn isPrime(T: type, n: T) bool {
    if (n <= 1) {
        return false;
    } else if (n <= 3) {
        return true;
    } else if (n % 2 == 0 or n % 3 == 0) {
        return false;
    }

    var i: T = 5;
    while (i * i <= n) {
        if (n % i == 0 or n % (i + 2) == 0) {
            return false;
        }
        i += 6;
    }
    return true;
}

test "isPrime" {
    const primeLessThan100 = [_]u8{ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97 };

    var got: [primeLessThan100.len]u8 = undefined;

    var n: usize = 0;
    for (0..100) |i| {
        const j: u8 = @intCast(i);
        if (isPrime(u8, j)) {
            got[n] = j;
            n += 1;
        }
    }
    const std = @import("std");
    std.testing.expect(std.mem.eql(u8, &primeLessThan100, &got)) catch |err| {
        std.debug.print("Error: {}; Expected: {any} but got {any}\n", .{ err, primeLessThan100, got });
    };

    const test_cases = [_]@import("./testcase.zig").TestCases(u128, bool){
        .{
            .input = 10089886811898868001,
            .expected = true,
        },
        .{
            .input = 10089886811898868000,
            .expected = false,
        },
        // .{
        //     .input = 10092003300140014003,
        //     .expected = true,
        // },
        .{
            .input = 10092003300140014005,
            .expected = false,
        },
    };

    for (test_cases) |tc| {
        const _got = isPrime(u128, tc.input);
        if (_got != tc.expected) {
            std.debug.print("Error: Expected: {} but got {}\n", .{ tc.expected, _got });
        }
    }
}
