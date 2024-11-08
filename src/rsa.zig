const std = @import("std");
const modInverse = @import("./modInverse.zig").modInverse;
const isPrime = @import("./isPrime.zig").isPrime;
const getRand = @import("./getRand.zig").getRand;
const gcd = @import("./gcd.zig").gcd;

const errors = error{
    InvalidPrime,
};

pub fn RSA(T: type, comptime prime1: T, comptime prime2: T) !NewParams(T) {
    const t = try NewParams(T).init(prime1, prime2);
    return t;
}

fn NewParams(comptime T: type) type {
    return struct {
        p: T,
        q: T,
        n: T,
        e: T,
        d: T,

        const Self = @This();

        pub fn init(comptime p: T, comptime q: T) errors!Self {
            const n = try primesN(p, q);
            const e = findE(p, q);
            const d = modInverse(T, e, (p - 1) * (q - 1));

            return NewParams(T){ .p = p, .q = q, .n = n, .e = e, .d = d };
        }

        fn primesN(p: T, q: T) !T {
            if (!isPrime(T, p) or !isPrime(T, q)) {
                return error.InvalidPrime;
            }
            return p * q;
        }

        fn findE(p: T, q: T) T {
            const tot: T = ((p - 1) * (q - 1));
            var e = getRand(T, tot - 1) catch blk: {
                break :blk 2;
            };
            while (true) {
                if (gcd(T, e, tot) == 1) {
                    return e;
                }
                e += 1;
            }
        }

        fn Encrypt(self: *const Self, m: T) !T {
            var r: T = 1;
            var n = self.e;
            while (n > 0) {
                r = (r * m) % self.n;
                n -= 1;
            }
            return r;
        }

        fn EncryptMsg(self: *const Self, encrypted: []T, m: []const u8) !void {
            for (m, 0..) |c, i| {
                const r = try self.Encrypt(c);
                encrypted[i] = @intCast(r);
            }
        }

        fn Decrypt(self: *const Self, c: T) !T {
            var r: T = 1;
            var n = self.d;
            while (n > 0) {
                r = (r * c) % self.n;
                n -= 1;
            }
            return r;
        }

        fn DecryptMsg(self: *const Self, decrypted: []u8, m: []const T) !void {
            for (m, 0..) |c, i| {
                decrypted[i] = @intCast(try self.Decrypt(c));
            }
            return;
        }
    };
}

test "RSA" {
    const T = u64;
    const msg = "Hello, World! abcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()_+{}|:<>?~`-=[];',./";
    const rsa = try RSA(T, 61, 53);

    const allocator = std.heap.page_allocator;

    const encrypted = try allocator.alloc(T, msg.len);
    defer allocator.free(encrypted);
    try rsa.EncryptMsg(encrypted, msg);

    const decrypted = try allocator.alloc(u8, msg.len);
    defer allocator.free(decrypted);
    try rsa.DecryptMsg(decrypted, encrypted);

    try std.testing.expectEqualSlices(u8, msg, decrypted);
}
