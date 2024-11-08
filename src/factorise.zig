const std = @import("std");

pub fn factorise(T: type, allocator: std.mem.Allocator, n: T) ![]T {
    var _n: T = n;

    var factors = std.ArrayList(T).init(allocator);
    defer factors.deinit();

    var i: T = 2;
    while (_n > 1) {
        if (_n % i == 0) {
            try factors.append(i);
            _n /= i;
        } else {
            i += 1;
        }
    }
    return factors.toOwnedSlice();
}

test "factorise" {
    const allocator = std.testing.allocator;
    const T = u64;
    const result = try factorise(T, allocator, 2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 29);
    defer allocator.free(result);

    const expected = [_]T{ 2, 3, 5, 7, 11, 13, 17, 19, 29 };
    try std.testing.expectEqualSlices(T, result, &expected);
}
