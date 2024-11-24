pub const gcd = @import("gcd.zig").gcd;
pub const isPrime = @import("isPrime.zig").isPrime;
pub const modInverse = @import("modInverse.zig").modInverse;
pub const pow = @import("pow.zig").pow;
pub const mpow = @import("pow.zig").mpow;
pub const factorise = @import("factorise.zig").factorise;
pub const RSA = @import("rsa.zig").RSA;
pub const ElGamal = @import("elgamal.zig").ElGamal;

test {
    const std = @import("std");
    std.testing.log_level = .warn;
    std.testing.refAllDeclsRecursive(@This());
}
