const std = @import("std");
const pow = @import("pow.zig").pow;
const modInverse = @import("modInverse.zig").modInverse;
const getRand = @import("getRand.zig").getRand;

pub fn ElGamal(comptime T: type, comptime prime: T, comptime generator: T) !NewParams(T) {
    const t = try NewParams(T).init(prime, generator);
    return t;
}

fn NewParams(comptime T: type) type {
    return struct {
        p: T,
        g: T,
        priv: T,
        pubk: T,

        const Self = @This();

        pub fn init(comptime prime: T, comptime generator: T) !Self {
            const privkey = try getRand(T, prime - 1);
            const pubkey = pow(T, generator, privkey) % prime;
            return NewParams(T){ .p = prime, .g = generator, .priv = privkey, .pubk = pubkey };
        }

        fn initWithPk(prime: T, generator: T, privkey: T) !Self {
            const pubkey = pow(T, generator, privkey) % prime;
            return NewParams(T){ .p = prime, .g = generator, .priv = privkey, .pubk = pubkey };
        }

        fn encrypt(self: *const Self, msg: T) ![2]T {
            const r = try getRand(T, self.p - 1);
            const c1 = pow(T, self.g, r) % self.p;
            const c2 = (msg * pow(T, self.pubk, r)) % self.p;
            return [2]T{ c1, c2 };
        }

        fn encryptWithk(self: *const Self, msg: T, k: T) ![2]T {
            const r = k;
            const c1 = pow(T, self.g, r) % self.p;
            const c2 = (msg * pow(T, self.pubk, r)) % self.p;
            return [2]T{ c1, c2 };
        }

        fn decrypt(self: *const Self, c: [2]T) T {
            const s = pow(T, c[0], self.priv) % self.p;
            const v = modInverse(T, s, self.p);
            const msg = (c[1] * v) % self.p;
            return msg;
        }
    };
}

test "ElGamal" {
    const ElgamalU64 = try ElGamal(u64, 23, 11);
    const msg = 4;

    const encrypted = try ElgamalU64.encrypt(msg);

    const decrypted = ElgamalU64.decrypt(encrypted);

    try std.testing.expectEqual(decrypted, msg);
}
