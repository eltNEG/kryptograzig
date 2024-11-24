pub fn pow(comptime T: type, b: T, e: T) T {
    var r: T = 1;
    for (e) |_| {
        r *= b;
    }
    return r;
}
pub fn mpow(comptime T: type, b: T, e: T, m: T) T {
    var r: T = 1;
    for (e) |_| {
        r *= b;
        r = r % m;
    }
    return r;
}

test "pow" {
    const std = @import("std");
    try std.testing.expect(pow(u64, 2, 2) == 4);
    try std.testing.expect(pow(u64, 4, 2) == 16);
    try std.testing.expect(mpow(u64, 4, 2, 17) == 16);
}
