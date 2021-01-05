!function() {
    !function(a) {
        function b(a, b, c) {
            this.low = 0 | a, this.high = 0 | b, this.unsigned = !!c;
        }
        var c, d, e, f, g, h;
        b.isLong = function(a) {
            return !0 === (a && a instanceof b);
        }, c = {}, d = {}, b.fromInt = function(a, e) {
            var f;
            if (e) {
                if (a >>>= 0, a >= 0 && 256 > a && (f = d[a])) return f;
                f = new b(a, 0 > (0 | a) ? -1 : 0, !0), a >= 0 && 256 > a && (d[a] = f);
            } else {
                if (a |= 0, a >= -128 && 128 > a && (f = c[a])) return f;
                f = new b(a, 0 > a ? -1 : 0, !1), a >= -128 && 128 > a && (c[a] = f);
            }
            return f;
        }, b.fromNumber = function(a, c) {
            return c = !!c, isNaN(a) || !isFinite(a) ? b.ZERO : !c && -g >= a ? b.MIN_VALUE : !c && a + 1 >= g ? b.MAX_VALUE : c && a >= f ? b.MAX_UNSIGNED_VALUE : 0 > a ? b.fromNumber(-a, c).negate() : new b(0 | a % e, 0 | a / e, c);
        }, b.fromBits = function(a, c, d) {
            return new b(a, c, d);
        }, b.fromString = function(a, c, d) {
            var e, f, g, h, i;
            if (0 === a.length) throw Error("number format error: empty string");
            if ("NaN" === a || "Infinity" === a || "+Infinity" === a || "-Infinity" === a) return b.ZERO;
            if ("number" == typeof c && (d = c, c = !1), d = d || 10, 2 > d || d > 36) throw Error("radix out of range: " + d);
            if (0 < (e = a.indexOf("-"))) throw Error('number format error: interior "-" character: ' + a);
            if (0 === e) return b.fromString(a.substring(1), c, d).negate();
            for (e = b.fromNumber(Math.pow(d, 8)), f = b.ZERO, g = 0; g < a.length; g += 8) h = Math.min(8, a.length - g), 
            i = parseInt(a.substring(g, g + h), d), 8 > h ? (h = b.fromNumber(Math.pow(d, h)), 
            f = f.multiply(h).add(b.fromNumber(i))) : (f = f.multiply(e), f = f.add(b.fromNumber(i)));
            return f.unsigned = c, f;
        }, b.fromValue = function(a) {
            return "number" == typeof a ? b.fromNumber(a) : "string" == typeof a ? b.fromString(a) : b.isLong(a) ? a : new b(a.low, a.high, a.unsigned);
        }, e = 4294967296, f = e * e, g = f / 2, h = b.fromInt(16777216), b.ZERO = b.fromInt(0), 
        b.UZERO = b.fromInt(0, !0), b.ONE = b.fromInt(1), b.UONE = b.fromInt(1, !0), b.NEG_ONE = b.fromInt(-1), 
        b.MAX_VALUE = b.fromBits(-1, 2147483647, !1), b.MAX_UNSIGNED_VALUE = b.fromBits(-1, -1, !0), 
        b.MIN_VALUE = b.fromBits(0, -2147483648, !1), b.prototype.toInt = function() {
            return this.unsigned ? this.low >>> 0 : this.low;
        }, b.prototype.toNumber = function() {
            return this.unsigned ? (this.high >>> 0) * e + (this.low >>> 0) : this.high * e + (this.low >>> 0);
        }, b.prototype.toString = function(a) {
            var c, d, e, f, g;
            if (a = a || 10, 2 > a || a > 36) throw RangeError("radix out of range: " + a);
            if (this.isZero()) return "0";
            if (this.isNegative()) return this.equals(b.MIN_VALUE) ? (c = b.fromNumber(a), d = this.div(c), 
            c = d.multiply(c).subtract(this), d.toString(a) + c.toInt().toString(a)) : "-" + this.negate().toString(a);
            for (d = b.fromNumber(Math.pow(a, 6), this.unsigned), c = this, e = ""; ;) {
                if (f = c.div(d), g = (c.subtract(f.multiply(d)).toInt() >>> 0).toString(a), c = f, 
                c.isZero()) return g + e;
                for (;6 > g.length; ) g = "0" + g;
                e = "" + g + e;
            }
        }, b.prototype.getHighBits = function() {
            return this.high;
        }, b.prototype.getHighBitsUnsigned = function() {
            return this.high >>> 0;
        }, b.prototype.getLowBits = function() {
            return this.low;
        }, b.prototype.getLowBitsUnsigned = function() {
            return this.low >>> 0;
        }, b.prototype.getNumBitsAbs = function() {
            if (this.isNegative()) return this.equals(b.MIN_VALUE) ? 64 : this.negate().getNumBitsAbs();
            for (var a = 0 != this.high ? this.high : this.low, c = 31; c > 0 && 0 == (a & 1 << c); c--) ;
            return 0 != this.high ? c + 33 : c + 1;
        }, b.prototype.isZero = function() {
            return 0 === this.high && 0 === this.low;
        }, b.prototype.isNegative = function() {
            return !this.unsigned && 0 > this.high;
        }, b.prototype.isPositive = function() {
            return this.unsigned || 0 <= this.high;
        }, b.prototype.isOdd = function() {
            return 1 === (1 & this.low);
        }, b.prototype.equals = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), this.unsigned !== a.unsigned && this.high >>> 31 !== a.high >>> 31 ? !1 : this.high === a.high && this.low === a.low;
        }, b.prototype.notEquals = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), !this.equals(a);
        }, b.prototype.lessThan = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), 0 > this.compare(a);
        }, b.prototype.lessThanOrEqual = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), 0 >= this.compare(a);
        }, b.prototype.greaterThan = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), 0 < this.compare(a);
        }, b.prototype.greaterThanOrEqual = function(a) {
            return 0 <= this.compare(a);
        }, b.prototype.compare = function(a) {
            if (this.equals(a)) return 0;
            var b = this.isNegative(), c = a.isNegative();
            return b && !c ? -1 : !b && c ? 1 : this.unsigned ? a.high >>> 0 > this.high >>> 0 || a.high === this.high && a.low >>> 0 > this.low >>> 0 ? -1 : 1 : this.subtract(a).isNegative() ? -1 : 1;
        }, b.prototype.negate = function() {
            return !this.unsigned && this.equals(b.MIN_VALUE) ? b.MIN_VALUE : this.not().add(b.ONE);
        }, b.prototype.add = function(a) {
            b.isLong(a) || (a = b.fromValue(a));
            var i, c = this.high >>> 16, d = 65535 & this.high, e = this.low >>> 16, f = a.high >>> 16, g = 65535 & a.high, h = a.low >>> 16;
            return i = 0 + ((65535 & this.low) + (65535 & a.low)), a = 0 + (i >>> 16), a += e + h, 
            e = 0 + (a >>> 16), e += d + g, d = 0 + (e >>> 16), d = 65535 & d + (c + f), b.fromBits((65535 & a) << 16 | 65535 & i, d << 16 | 65535 & e, this.unsigned);
        }, b.prototype.subtract = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), this.add(a.negate());
        }, b.prototype.multiply = function(a) {
            var c, d, e, f, g, i, j, k, l, m, n;
            return this.isZero() ? b.ZERO : (b.isLong(a) || (a = b.fromValue(a)), a.isZero() ? b.ZERO : this.equals(b.MIN_VALUE) ? a.isOdd() ? b.MIN_VALUE : b.ZERO : a.equals(b.MIN_VALUE) ? this.isOdd() ? b.MIN_VALUE : b.ZERO : this.isNegative() ? a.isNegative() ? this.negate().multiply(a.negate()) : this.negate().multiply(a).negate() : a.isNegative() ? this.multiply(a.negate()).negate() : this.lessThan(h) && a.lessThan(h) ? b.fromNumber(this.toNumber() * a.toNumber(), this.unsigned) : (c = this.high >>> 16, 
            d = 65535 & this.high, e = this.low >>> 16, f = 65535 & this.low, g = a.high >>> 16, 
            i = 65535 & a.high, j = a.low >>> 16, a = 65535 & a.low, n = 0 + f * a, m = 0 + (n >>> 16), 
            m += e * a, l = 0 + (m >>> 16), m = (65535 & m) + f * j, l += m >>> 16, m &= 65535, 
            l += d * a, k = 0 + (l >>> 16), l = (65535 & l) + e * j, k += l >>> 16, l &= 65535, 
            l += f * i, k += l >>> 16, l &= 65535, k = 65535 & k + (c * a + d * j + e * i + f * g), 
            b.fromBits(m << 16 | 65535 & n, k << 16 | l, this.unsigned)));
        }, b.prototype.div = function(a) {
            var c, d, e, f, g, h;
            if (b.isLong(a) || (a = b.fromValue(a)), a.isZero()) throw Error("division by zero");
            if (this.isZero()) return this.unsigned ? b.UZERO : b.ZERO;
            if (this.equals(b.MIN_VALUE)) return a.equals(b.ONE) || a.equals(b.NEG_ONE) ? b.MIN_VALUE : a.equals(b.MIN_VALUE) ? b.ONE : (c = this.shiftRight(1).div(a).shiftLeft(1), 
            c.equals(b.ZERO) ? a.isNegative() ? b.ONE : b.NEG_ONE : (d = this.subtract(a.multiply(c)), 
            e = c.add(d.div(a))));
            if (a.equals(b.MIN_VALUE)) return this.unsigned ? b.UZERO : b.ZERO;
            if (this.isNegative()) return a.isNegative() ? this.negate().div(a.negate()) : this.negate().div(a).negate();
            if (a.isNegative()) return this.div(a.negate()).negate();
            for (e = b.ZERO, d = this; d.greaterThanOrEqual(a); ) {
                for (c = Math.max(1, Math.floor(d.toNumber() / a.toNumber())), f = Math.ceil(Math.log(c) / Math.LN2), 
                f = 48 >= f ? 1 : Math.pow(2, f - 48), g = b.fromNumber(c), h = g.multiply(a); h.isNegative() || h.greaterThan(d); ) c -= f, 
                g = b.fromNumber(c, this.unsigned), h = g.multiply(a);
                g.isZero() && (g = b.ONE), e = e.add(g), d = d.subtract(h);
            }
            return e;
        }, b.prototype.modulo = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), this.subtract(this.div(a).multiply(a));
        }, b.prototype.not = function() {
            return b.fromBits(~this.low, ~this.high, this.unsigned);
        }, b.prototype.and = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), b.fromBits(this.low & a.low, this.high & a.high, this.unsigned);
        }, b.prototype.or = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), b.fromBits(this.low | a.low, this.high | a.high, this.unsigned);
        }, b.prototype.xor = function(a) {
            return b.isLong(a) || (a = b.fromValue(a)), b.fromBits(this.low ^ a.low, this.high ^ a.high, this.unsigned);
        }, b.prototype.shiftLeft = function(a) {
            return b.isLong(a) && (a = a.toInt()), 0 === (a &= 63) ? this : 32 > a ? b.fromBits(this.low << a, this.high << a | this.low >>> 32 - a, this.unsigned) : b.fromBits(0, this.low << a - 32, this.unsigned);
        }, b.prototype.shiftRight = function(a) {
            return b.isLong(a) && (a = a.toInt()), 0 === (a &= 63) ? this : 32 > a ? b.fromBits(this.low >>> a | this.high << 32 - a, this.high >> a, this.unsigned) : b.fromBits(this.high >> a - 32, 0 <= this.high ? 0 : -1, this.unsigned);
        }, b.prototype.shiftRightUnsigned = function(a) {
            if (b.isLong(a) && (a = a.toInt()), a &= 63, 0 === a) return this;
            var c = this.high;
            return 32 > a ? b.fromBits(this.low >>> a | c << 32 - a, c >>> a, this.unsigned) : 32 === a ? b.fromBits(c, 0, this.unsigned) : b.fromBits(c >>> a - 32, 0, this.unsigned);
        }, b.prototype.toSigned = function() {
            return this.unsigned ? new b(this.low, this.high, !1) : this;
        }, b.prototype.toUnsigned = function() {
            return this.unsigned ? this : new b(this.low, this.high, !0);
        }, "function" == typeof require && "object" == typeof module && module && module.id && "object" == typeof exports && exports ? module.exports = b : "function" == typeof define && define.amd ? define("Long", [], function() {
            return b;
        }) : (a.dcodeIO = a.dcodeIO || {}).Long = b;
    }(this);
}(), function(a) {
    function b(a) {
        function b(a, c, d) {
            if ("undefined" == typeof a && (a = b.DEFAULT_CAPACITY), "undefined" == typeof c && (c = b.DEFAULT_ENDIAN), 
            "undefined" == typeof d && (d = b.DEFAULT_NOASSERT), !d) {
                if (a |= 0, 0 > a) throw RangeError("Illegal capacity");
                c = !!c, d = !!d;
            }
            this.buffer = 0 === a ? f : new ArrayBuffer(a), this.view = 0 === a ? null : new DataView(this.buffer), 
            this.offset = 0, this.markedOffset = -1, this.limit = a, this.littleEndian = "undefined" != typeof c ? !!c : !1, 
            this.noAssert = !!d;
        }
        function c(a) {
            var b = 0;
            return function() {
                return b < a.length ? a.charCodeAt(b++) : null;
            };
        }
        function d() {
            var a = [], b = [];
            return function() {
                return 0 === arguments.length ? b.join("") + g.apply(String, a) : (1024 < a.length + arguments.length && (b.push(g.apply(String, a)), 
                a.length = 0), Array.prototype.push.apply(a, arguments), void 0);
            };
        }
        var e, f, g, h, j;
        return b.VERSION = "3.5.2", b.LITTLE_ENDIAN = !0, b.BIG_ENDIAN = !1, b.DEFAULT_CAPACITY = 16, 
        b.DEFAULT_ENDIAN = b.BIG_ENDIAN, b.DEFAULT_NOASSERT = !1, b.Long = a || null, e = b.prototype, 
        f = new ArrayBuffer(0), g = String.fromCharCode, b.allocate = function(a, c, d) {
            return new b(a, c, d);
        }, b.concat = function(a, c, d, e) {
            ("boolean" == typeof c || "string" != typeof c) && (e = d, d = c, c = void 0);
            for (var i, f = 0, g = 0, h = a.length; h > g; ++g) b.isByteBuffer(a[g]) || (a[g] = b.wrap(a[g], c)), 
            i = a[g].limit - a[g].offset, i > 0 && (f += i);
            if (0 === f) return new b(0, d, e);
            for (c = new b(f, d, e), e = new Uint8Array(c.buffer), g = 0; h > g; ) d = a[g++], 
            i = d.limit - d.offset, 0 >= i || (e.set(new Uint8Array(d.buffer).subarray(d.offset, d.limit), c.offset), 
            c.offset += i);
            return c.limit = c.offset, c.offset = 0, c;
        }, b.isByteBuffer = function(a) {
            return !0 === (a && a instanceof b);
        }, b.type = function() {
            return ArrayBuffer;
        }, b.wrap = function(a, c, d, f) {
            if ("string" != typeof c && (f = d, d = c, c = void 0), "string" == typeof a) switch ("undefined" == typeof c && (c = "utf8"), 
            c) {
              case "base64":
                return b.fromBase64(a, d);

              case "hex":
                return b.fromHex(a, d);

              case "binary":
                return b.fromBinary(a, d);

              case "utf8":
                return b.fromUTF8(a, d);

              case "debug":
                return b.fromDebug(a, d);

              default:
                throw Error("Unsupported encoding: " + c);
            }
            if (null === a || "object" != typeof a) throw TypeError("Illegal buffer");
            if (b.isByteBuffer(a)) return c = e.clone.call(a), c.markedOffset = -1, c;
            if (a instanceof Uint8Array) c = new b(0, d, f), 0 < a.length && (c.buffer = a.buffer, 
            c.offset = a.byteOffset, c.limit = a.byteOffset + a.length, c.view = 0 < a.length ? new DataView(a.buffer) : null); else if (a instanceof ArrayBuffer) c = new b(0, d, f), 
            0 < a.byteLength && (c.buffer = a, c.offset = 0, c.limit = a.byteLength, c.view = 0 < a.byteLength ? new DataView(a) : null); else {
                if ("[object Array]" !== Object.prototype.toString.call(a)) throw TypeError("Illegal buffer");
                for (c = new b(a.length, d, f), c.limit = a.length, i = 0; i < a.length; ++i) c.view.setUint8(i, a[i]);
            }
            return c;
        }, e.writeInt8 = function(a, b) {
            var d, c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal value: " + a + " (not an integer)");
                if (a |= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return b += 1, d = this.buffer.byteLength, b > d && this.resize((d *= 2) > b ? d : b), 
            this.view.setInt8(b - 1, a), c && (this.offset += 1), this;
        }, e.writeByte = e.writeInt8, e.readInt8 = function(a) {
            var b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 1 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+1) <= " + this.buffer.byteLength);
            }
            return a = this.view.getInt8(a), b && (this.offset += 1), a;
        }, e.readByte = e.readInt8, e.writeUint8 = function(a, b) {
            var d, c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal value: " + a + " (not an integer)");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return b += 1, d = this.buffer.byteLength, b > d && this.resize((d *= 2) > b ? d : b), 
            this.view.setUint8(b - 1, a), c && (this.offset += 1), this;
        }, e.readUint8 = function(a) {
            var b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 1 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+1) <= " + this.buffer.byteLength);
            }
            return a = this.view.getUint8(a), b && (this.offset += 1), a;
        }, e.writeInt16 = function(a, b) {
            var d, c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal value: " + a + " (not an integer)");
                if (a |= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return b += 2, d = this.buffer.byteLength, b > d && this.resize((d *= 2) > b ? d : b), 
            this.view.setInt16(b - 2, a, this.littleEndian), c && (this.offset += 2), this;
        }, e.writeShort = e.writeInt16, e.readInt16 = function(a) {
            var b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 2 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+2) <= " + this.buffer.byteLength);
            }
            return a = this.view.getInt16(a, this.littleEndian), b && (this.offset += 2), a;
        }, e.readShort = e.readInt16, e.writeUint16 = function(a, b) {
            var d, c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal value: " + a + " (not an integer)");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return b += 2, d = this.buffer.byteLength, b > d && this.resize((d *= 2) > b ? d : b), 
            this.view.setUint16(b - 2, a, this.littleEndian), c && (this.offset += 2), this;
        }, e.readUint16 = function(a) {
            var b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 2 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+2) <= " + this.buffer.byteLength);
            }
            return a = this.view.getUint16(a, this.littleEndian), b && (this.offset += 2), a;
        }, e.writeInt32 = function(a, b) {
            var d, c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal value: " + a + " (not an integer)");
                if (a |= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return b += 4, d = this.buffer.byteLength, b > d && this.resize((d *= 2) > b ? d : b), 
            this.view.setInt32(b - 4, a, this.littleEndian), c && (this.offset += 4), this;
        }, e.writeInt = e.writeInt32, e.readInt32 = function(a) {
            var b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 4 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+4) <= " + this.buffer.byteLength);
            }
            return a = this.view.getInt32(a, this.littleEndian), b && (this.offset += 4), a;
        }, e.readInt = e.readInt32, e.writeUint32 = function(a, b) {
            var d, c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal value: " + a + " (not an integer)");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return b += 4, d = this.buffer.byteLength, b > d && this.resize((d *= 2) > b ? d : b), 
            this.view.setUint32(b - 4, a, this.littleEndian), c && (this.offset += 4), this;
        }, e.readUint32 = function(a) {
            var b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 4 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+4) <= " + this.buffer.byteLength);
            }
            return a = this.view.getUint32(a, this.littleEndian), b && (this.offset += 4), a;
        }, a && (e.writeInt64 = function(b, c) {
            var e, d = "undefined" == typeof c;
            if (d && (c = this.offset), !this.noAssert) {
                if ("number" == typeof b) b = a.fromNumber(b); else if (!(b && b instanceof a)) throw TypeError("Illegal value: " + b + " (not an integer or Long)");
                if ("number" != typeof c || 0 !== c % 1) throw TypeError("Illegal offset: " + c + " (not an integer)");
                if (c >>>= 0, 0 > c || c + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + c + " (+0) <= " + this.buffer.byteLength);
            }
            return "number" == typeof b && (b = a.fromNumber(b)), c += 8, e = this.buffer.byteLength, 
            c > e && this.resize((e *= 2) > c ? e : c), c -= 8, this.littleEndian ? (this.view.setInt32(c, b.low, !0), 
            this.view.setInt32(c + 4, b.high, !0)) : (this.view.setInt32(c, b.high, !1), this.view.setInt32(c + 4, b.low, !1)), 
            d && (this.offset += 8), this;
        }, e.writeLong = e.writeInt64, e.readInt64 = function(b) {
            var c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 8 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+8) <= " + this.buffer.byteLength);
            }
            return b = this.littleEndian ? new a(this.view.getInt32(b, !0), this.view.getInt32(b + 4, !0), !1) : new a(this.view.getInt32(b + 4, !1), this.view.getInt32(b, !1), !1), 
            c && (this.offset += 8), b;
        }, e.readLong = e.readInt64, e.writeUint64 = function(b, c) {
            var e, d = "undefined" == typeof c;
            if (d && (c = this.offset), !this.noAssert) {
                if ("number" == typeof b) b = a.fromNumber(b); else if (!(b && b instanceof a)) throw TypeError("Illegal value: " + b + " (not an integer or Long)");
                if ("number" != typeof c || 0 !== c % 1) throw TypeError("Illegal offset: " + c + " (not an integer)");
                if (c >>>= 0, 0 > c || c + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + c + " (+0) <= " + this.buffer.byteLength);
            }
            return "number" == typeof b && (b = a.fromNumber(b)), c += 8, e = this.buffer.byteLength, 
            c > e && this.resize((e *= 2) > c ? e : c), c -= 8, this.littleEndian ? (this.view.setInt32(c, b.low, !0), 
            this.view.setInt32(c + 4, b.high, !0)) : (this.view.setInt32(c, b.high, !1), this.view.setInt32(c + 4, b.low, !1)), 
            d && (this.offset += 8), this;
        }, e.readUint64 = function(b) {
            var c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 8 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+8) <= " + this.buffer.byteLength);
            }
            return b = this.littleEndian ? new a(this.view.getInt32(b, !0), this.view.getInt32(b + 4, !0), !0) : new a(this.view.getInt32(b + 4, !1), this.view.getInt32(b, !1), !0), 
            c && (this.offset += 8), b;
        }), e.writeFloat32 = function(a, b) {
            var d, c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof a) throw TypeError("Illegal value: " + a + " (not a number)");
                if ("number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return b += 4, d = this.buffer.byteLength, b > d && this.resize((d *= 2) > b ? d : b), 
            this.view.setFloat32(b - 4, a, this.littleEndian), c && (this.offset += 4), this;
        }, e.writeFloat = e.writeFloat32, e.readFloat32 = function(a) {
            var b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 4 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+4) <= " + this.buffer.byteLength);
            }
            return a = this.view.getFloat32(a, this.littleEndian), b && (this.offset += 4), 
            a;
        }, e.readFloat = e.readFloat32, e.writeFloat64 = function(a, b) {
            var d, c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof a) throw TypeError("Illegal value: " + a + " (not a number)");
                if ("number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return b += 8, d = this.buffer.byteLength, b > d && this.resize((d *= 2) > b ? d : b), 
            this.view.setFloat64(b - 8, a, this.littleEndian), c && (this.offset += 8), this;
        }, e.writeDouble = e.writeFloat64, e.readFloat64 = function(a) {
            var b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 8 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+8) <= " + this.buffer.byteLength);
            }
            return a = this.view.getFloat64(a, this.littleEndian), b && (this.offset += 8), 
            a;
        }, e.readDouble = e.readFloat64, b.MAX_VARINT32_BYTES = 5, b.calculateVarint32 = function(a) {
            return a >>>= 0, 128 > a ? 1 : 16384 > a ? 2 : 2097152 > a ? 3 : 268435456 > a ? 4 : 5;
        }, b.zigZagEncode32 = function(a) {
            return ((a |= 0) << 1 ^ a >> 31) >>> 0;
        }, b.zigZagDecode32 = function(a) {
            return 0 | a >>> 1 ^ -(1 & a);
        }, e.writeVarint32 = function(a, c) {
            var e, f, d = "undefined" == typeof c;
            if (d && (c = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal value: " + a + " (not an integer)");
                if (a |= 0, "number" != typeof c || 0 !== c % 1) throw TypeError("Illegal offset: " + c + " (not an integer)");
                if (c >>>= 0, 0 > c || c + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + c + " (+0) <= " + this.buffer.byteLength);
            }
            return e = b.calculateVarint32(a), c += e, f = this.buffer.byteLength, c > f && this.resize((f *= 2) > c ? f : c), 
            c -= e, this.view.setUint8(c, e = 128 | a), a >>>= 0, a >= 128 ? (e = 128 | a >> 7, 
            this.view.setUint8(c + 1, e), a >= 16384 ? (e = 128 | a >> 14, this.view.setUint8(c + 2, e), 
            a >= 2097152 ? (e = 128 | a >> 21, this.view.setUint8(c + 3, e), a >= 268435456 ? (this.view.setUint8(c + 4, 15 & a >> 28), 
            e = 5) : (this.view.setUint8(c + 3, 127 & e), e = 4)) : (this.view.setUint8(c + 2, 127 & e), 
            e = 3)) : (this.view.setUint8(c + 1, 127 & e), e = 2)) : (this.view.setUint8(c, 127 & e), 
            e = 1), d ? (this.offset += e, this) : e;
        }, e.writeVarint32ZigZag = function(a, c) {
            return this.writeVarint32(b.zigZagEncode32(a), c);
        }, e.readVarint32 = function(a) {
            var e, c, d, b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 1 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+1) <= " + this.buffer.byteLength);
            }
            c = 0, d = 0;
            do {
                if (e = a + c, !this.noAssert && e > this.limit) throw a = Error("Truncated"), a.truncated = !0, 
                a;
                e = this.view.getUint8(e), 5 > c && (d |= (127 & e) << 7 * c >>> 0), ++c;
            } while (128 === (128 & e));
            return d |= 0, b ? (this.offset += c, d) : {
                value: d,
                length: c
            };
        }, e.readVarint32ZigZag = function(a) {
            return a = this.readVarint32(a), "object" == typeof a ? a.value = b.zigZagDecode32(a.value) : a = b.zigZagDecode32(a), 
            a;
        }, a && (b.MAX_VARINT64_BYTES = 10, b.calculateVarint64 = function(b) {
            "number" == typeof b && (b = a.fromNumber(b));
            var c = b.toInt() >>> 0, d = b.shiftRightUnsigned(28).toInt() >>> 0;
            return b = b.shiftRightUnsigned(56).toInt() >>> 0, 0 == b ? 0 == d ? 16384 > c ? 128 > c ? 1 : 2 : 2097152 > c ? 3 : 4 : 16384 > d ? 128 > d ? 5 : 6 : 2097152 > d ? 7 : 8 : 128 > b ? 9 : 10;
        }, b.zigZagEncode64 = function(b) {
            return "number" == typeof b ? b = a.fromNumber(b, !1) : !1 !== b.unsigned && (b = b.toSigned()), 
            b.shiftLeft(1).xor(b.shiftRight(63)).toUnsigned();
        }, b.zigZagDecode64 = function(b) {
            return "number" == typeof b ? b = a.fromNumber(b, !1) : !1 !== b.unsigned && (b = b.toSigned()), 
            b.shiftRightUnsigned(1).xor(b.and(a.ONE).toSigned().negate()).toSigned();
        }, e.writeVarint64 = function(c, d) {
            var f, g, h, i, j, e = "undefined" == typeof d;
            if (e && (d = this.offset), !this.noAssert) {
                if ("number" == typeof c) c = a.fromNumber(c); else if (!(c && c instanceof a)) throw TypeError("Illegal value: " + c + " (not an integer or Long)");
                if ("number" != typeof d || 0 !== d % 1) throw TypeError("Illegal offset: " + d + " (not an integer)");
                if (d >>>= 0, 0 > d || d + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + d + " (+0) <= " + this.buffer.byteLength);
            }
            switch ("number" == typeof c ? c = a.fromNumber(c, !1) : !1 !== c.unsigned && (c = c.toSigned()), 
            f = b.calculateVarint64(c), g = c.toInt() >>> 0, h = c.shiftRightUnsigned(28).toInt() >>> 0, 
            i = c.shiftRightUnsigned(56).toInt() >>> 0, d += f, j = this.buffer.byteLength, 
            d > j && this.resize((j *= 2) > d ? j : d), d -= f, f) {
              case 10:
                this.view.setUint8(d + 9, 1 & i >>> 7);

              case 9:
                this.view.setUint8(d + 8, 9 !== f ? 128 | i : 127 & i);

              case 8:
                this.view.setUint8(d + 7, 8 !== f ? 128 | h >>> 21 : 127 & h >>> 21);

              case 7:
                this.view.setUint8(d + 6, 7 !== f ? 128 | h >>> 14 : 127 & h >>> 14);

              case 6:
                this.view.setUint8(d + 5, 6 !== f ? 128 | h >>> 7 : 127 & h >>> 7);

              case 5:
                this.view.setUint8(d + 4, 5 !== f ? 128 | h : 127 & h);

              case 4:
                this.view.setUint8(d + 3, 4 !== f ? 128 | g >>> 21 : 127 & g >>> 21);

              case 3:
                this.view.setUint8(d + 2, 3 !== f ? 128 | g >>> 14 : 127 & g >>> 14);

              case 2:
                this.view.setUint8(d + 1, 2 !== f ? 128 | g >>> 7 : 127 & g >>> 7);

              case 1:
                this.view.setUint8(d, 1 !== f ? 128 | g : 127 & g);
            }
            return e ? (this.offset += f, this) : f;
        }, e.writeVarint64ZigZag = function(a, c) {
            return this.writeVarint64(b.zigZagEncode64(a), c);
        }, e.readVarint64 = function(b) {
            var d, e, f, g, h, c = "undefined" == typeof b;
            if (c && (b = this.offset), !this.noAssert) {
                if ("number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 1 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+1) <= " + this.buffer.byteLength);
            }
            if (d = b, e = 0, f = 0, g = 0, h = 0, h = this.view.getUint8(b++), e = 127 & h, 
            128 & h && (h = this.view.getUint8(b++), e |= (127 & h) << 7, 128 & h && (h = this.view.getUint8(b++), 
            e |= (127 & h) << 14, 128 & h && (h = this.view.getUint8(b++), e |= (127 & h) << 21, 
            128 & h && (h = this.view.getUint8(b++), f = 127 & h, 128 & h && (h = this.view.getUint8(b++), 
            f |= (127 & h) << 7, 128 & h && (h = this.view.getUint8(b++), f |= (127 & h) << 14, 
            128 & h && (h = this.view.getUint8(b++), f |= (127 & h) << 21, 128 & h && (h = this.view.getUint8(b++), 
            g = 127 & h, 128 & h && (h = this.view.getUint8(b++), g |= (127 & h) << 7, 128 & h)))))))))) throw Error("Buffer overrun");
            return e = a.fromBits(e | f << 28, f >>> 4 | g << 24, !1), c ? (this.offset = b, 
            e) : {
                value: e,
                length: b - d
            };
        }, e.readVarint64ZigZag = function(c) {
            return (c = this.readVarint64(c)) && c.value instanceof a ? c.value = b.zigZagDecode64(c.value) : c = b.zigZagDecode64(c), 
            c;
        }), e.writeCString = function(a, b) {
            var e, f, g, d = "undefined" == typeof b;
            if (d && (b = this.offset), f = a.length, !this.noAssert) {
                if ("string" != typeof a) throw TypeError("Illegal str: Not a string");
                for (e = 0; f > e; ++e) if (0 === a.charCodeAt(e)) throw RangeError("Illegal str: Contains NULL-characters");
                if ("number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return e = b, f = j.a(c(a))[1], b += f + 1, g = this.buffer.byteLength, b > g && this.resize((g *= 2) > b ? g : b), 
            b -= f + 1, j.c(c(a), function(a) {
                this.view.setUint8(b++, a);
            }.bind(this)), this.view.setUint8(b++, 0), d ? (this.offset = b - e, this) : f;
        }, e.readCString = function(a) {
            var e, c, f, b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 1 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+1) <= " + this.buffer.byteLength);
            }
            return c = a, f = -1, j.b(function() {
                if (0 === f) return null;
                if (a >= this.limit) throw RangeError("Illegal range: Truncated data, " + a + " < " + this.limit);
                return 0 === (f = this.view.getUint8(a++)) ? null : f;
            }.bind(this), e = d(), !0), b ? (this.offset = a, e()) : {
                string: e(),
                length: a - c
            };
        }, e.writeIString = function(a, b) {
            var f, e, g, d = "undefined" == typeof b;
            if (d && (b = this.offset), !this.noAssert) {
                if ("string" != typeof a) throw TypeError("Illegal str: Not a string");
                if ("number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            if (e = b, f = j.a(c(a), this.noAssert)[1], b += 4 + f, g = this.buffer.byteLength, 
            b > g && this.resize((g *= 2) > b ? g : b), b -= 4 + f, this.view.setUint32(b, f, this.littleEndian), 
            b += 4, j.c(c(a), function(a) {
                this.view.setUint8(b++, a);
            }.bind(this)), b !== e + 4 + f) throw RangeError("Illegal range: Truncated data, " + b + " == " + (b + 4 + f));
            return d ? (this.offset = b, this) : b - e;
        }, e.readIString = function(a) {
            var c, e, f, b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 4 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+4) <= " + this.buffer.byteLength);
            }
            return c = 0, e = a, c = this.view.getUint32(a, this.littleEndian), a += 4, f = a + c, 
            j.b(function() {
                return f > a ? this.view.getUint8(a++) : null;
            }.bind(this), c = d(), this.noAssert), c = c(), b ? (this.offset = a, c) : {
                string: c,
                length: a - e
            };
        }, b.METRICS_CHARS = "c", b.METRICS_BYTES = "b", e.writeUTF8String = function(a, b) {
            var e, f, g, d = "undefined" == typeof b;
            if (d && (b = this.offset), !this.noAssert) {
                if ("number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: " + b + " (not an integer)");
                if (b >>>= 0, 0 > b || b + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + b + " (+0) <= " + this.buffer.byteLength);
            }
            return f = b, e = j.a(c(a))[1], b += e, g = this.buffer.byteLength, b > g && this.resize((g *= 2) > b ? g : b), 
            b -= e, j.c(c(a), function(a) {
                this.view.setUint8(b++, a);
            }.bind(this)), d ? (this.offset = b, this) : b - f;
        }, e.writeString = e.writeUTF8String, b.calculateUTF8Chars = function(a) {
            return j.a(c(a))[0];
        }, b.calculateUTF8Bytes = function(a) {
            return j.a(c(a))[1];
        }, e.readUTF8String = function(a, c, e) {
            var f, i, g, h, k;
            if ("number" == typeof c && (e = c, c = void 0), f = "undefined" == typeof e, f && (e = this.offset), 
            "undefined" == typeof c && (c = b.METRICS_CHARS), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal length: " + a + " (not an integer)");
                if (a |= 0, "number" != typeof e || 0 !== e % 1) throw TypeError("Illegal offset: " + e + " (not an integer)");
                if (e >>>= 0, 0 > e || e + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + e + " (+0) <= " + this.buffer.byteLength);
            }
            if (g = 0, h = e, c === b.METRICS_CHARS) {
                if (i = d(), j.g(function() {
                    return a > g && e < this.limit ? this.view.getUint8(e++) : null;
                }.bind(this), function(a) {
                    ++g, j.e(a, i);
                }.bind(this)), g !== a) throw RangeError("Illegal range: Truncated data, " + g + " == " + a);
                return f ? (this.offset = e, i()) : {
                    string: i(),
                    length: e - h
                };
            }
            if (c === b.METRICS_BYTES) {
                if (!this.noAssert) {
                    if ("number" != typeof e || 0 !== e % 1) throw TypeError("Illegal offset: " + e + " (not an integer)");
                    if (e >>>= 0, 0 > e || e + a > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + e + " (+" + a + ") <= " + this.buffer.byteLength);
                }
                if (k = e + a, j.b(function() {
                    return k > e ? this.view.getUint8(e++) : null;
                }.bind(this), i = d(), this.noAssert), e !== k) throw RangeError("Illegal range: Truncated data, " + e + " == " + k);
                return f ? (this.offset = e, i()) : {
                    string: i(),
                    length: e - h
                };
            }
            throw TypeError("Unsupported metrics: " + c);
        }, e.readString = e.readUTF8String, e.writeVString = function(a, d) {
            var g, h, f, i, e = "undefined" == typeof d;
            if (e && (d = this.offset), !this.noAssert) {
                if ("string" != typeof a) throw TypeError("Illegal str: Not a string");
                if ("number" != typeof d || 0 !== d % 1) throw TypeError("Illegal offset: " + d + " (not an integer)");
                if (d >>>= 0, 0 > d || d + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + d + " (+0) <= " + this.buffer.byteLength);
            }
            if (f = d, g = j.a(c(a), this.noAssert)[1], h = b.calculateVarint32(g), d += h + g, 
            i = this.buffer.byteLength, d > i && this.resize((i *= 2) > d ? i : d), d -= h + g, 
            d += this.writeVarint32(g, d), j.c(c(a), function(a) {
                this.view.setUint8(d++, a);
            }.bind(this)), d !== f + g + h) throw RangeError("Illegal range: Truncated data, " + d + " == " + (d + g + h));
            return e ? (this.offset = d, this) : d - f;
        }, e.readVString = function(a) {
            var c, e, f, b = "undefined" == typeof a;
            if (b && (a = this.offset), !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 1 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+1) <= " + this.buffer.byteLength);
            }
            return c = this.readVarint32(a), e = a, a += c.length, c = c.value, f = a + c, c = d(), 
            j.b(function() {
                return f > a ? this.view.getUint8(a++) : null;
            }.bind(this), c, this.noAssert), c = c(), b ? (this.offset = a, c) : {
                string: c,
                length: a - e
            };
        }, e.append = function(a, c, d) {
            var e, f;
            if (("number" == typeof c || "string" != typeof c) && (d = c, c = void 0), e = "undefined" == typeof d, 
            e && (d = this.offset), !this.noAssert) {
                if ("number" != typeof d || 0 !== d % 1) throw TypeError("Illegal offset: " + d + " (not an integer)");
                if (d >>>= 0, 0 > d || d + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + d + " (+0) <= " + this.buffer.byteLength);
            }
            return a instanceof b || (a = b.wrap(a, c)), c = a.limit - a.offset, 0 >= c ? this : (d += c, 
            f = this.buffer.byteLength, d > f && this.resize((f *= 2) > d ? f : d), new Uint8Array(this.buffer, d - c).set(new Uint8Array(a.buffer).subarray(a.offset, a.limit)), 
            a.offset += c, e && (this.offset += c), this);
        }, e.appendTo = function(a, b) {
            return a.append(this, b), this;
        }, e.assert = function(a) {
            return this.noAssert = !a, this;
        }, e.capacity = function() {
            return this.buffer.byteLength;
        }, e.clear = function() {
            return this.offset = 0, this.limit = this.buffer.byteLength, this.markedOffset = -1, 
            this;
        }, e.clone = function(a) {
            var c = new b(0, this.littleEndian, this.noAssert);
            return a ? (a = new ArrayBuffer(this.buffer.byteLength), new Uint8Array(a).set(this.buffer), 
            c.buffer = a, c.view = new DataView(a)) : (c.buffer = this.buffer, c.view = this.view), 
            c.offset = this.offset, c.markedOffset = this.markedOffset, c.limit = this.limit, 
            c;
        }, e.compact = function(a, b) {
            var c, d;
            if ("undefined" == typeof a && (a = this.offset), "undefined" == typeof b && (b = this.limit), 
            !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal begin: Not an integer");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal end: Not an integer");
                if (b >>>= 0, 0 > a || a > b || b > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + a + " <= " + b + " <= " + this.buffer.byteLength);
            }
            return 0 === a && b === this.buffer.byteLength ? this : (c = b - a, 0 === c ? (this.buffer = f, 
            this.view = null, 0 <= this.markedOffset && (this.markedOffset -= a), this.limit = this.offset = 0, 
            this) : (d = new ArrayBuffer(c), new Uint8Array(d).set(new Uint8Array(this.buffer).subarray(a, b)), 
            this.buffer = d, this.view = new DataView(d), 0 <= this.markedOffset && (this.markedOffset -= a), 
            this.offset = 0, this.limit = c, this));
        }, e.copy = function(a, c) {
            if ("undefined" == typeof a && (a = this.offset), "undefined" == typeof c && (c = this.limit), 
            !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal begin: Not an integer");
                if (a >>>= 0, "number" != typeof c || 0 !== c % 1) throw TypeError("Illegal end: Not an integer");
                if (c >>>= 0, 0 > a || a > c || c > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + a + " <= " + c + " <= " + this.buffer.byteLength);
            }
            if (a === c) return new b(0, this.littleEndian, this.noAssert);
            var d = c - a, e = new b(d, this.littleEndian, this.noAssert);
            return e.offset = 0, e.limit = d, 0 <= e.markedOffset && (e.markedOffset -= a), 
            this.copyTo(e, 0, a, c), e;
        }, e.copyTo = function(a, c, d, e) {
            var f, g, h;
            if (!this.noAssert && !b.isByteBuffer(a)) throw TypeError("Illegal target: Not a ByteBuffer");
            if (c = (g = "undefined" == typeof c) ? a.offset : 0 | c, d = (f = "undefined" == typeof d) ? this.offset : 0 | d, 
            e = "undefined" == typeof e ? this.limit : 0 | e, 0 > c || c > a.buffer.byteLength) throw RangeError("Illegal target range: 0 <= " + c + " <= " + a.buffer.byteLength);
            if (0 > d || e > this.buffer.byteLength) throw RangeError("Illegal source range: 0 <= " + d + " <= " + this.buffer.byteLength);
            return h = e - d, 0 === h ? a : (a.ensureCapacity(c + h), new Uint8Array(a.buffer).set(new Uint8Array(this.buffer).subarray(d, e), c), 
            f && (this.offset += h), g && (a.offset += h), this);
        }, e.ensureCapacity = function(a) {
            var b = this.buffer.byteLength;
            return a > b ? this.resize((b *= 2) > a ? b : a) : this;
        }, e.fill = function(a, b, c) {
            var d = "undefined" == typeof b;
            if (d && (b = this.offset), "string" == typeof a && 0 < a.length && (a = a.charCodeAt(0)), 
            "undefined" == typeof b && (b = this.offset), "undefined" == typeof c && (c = this.limit), 
            !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal value: " + a + " (not an integer)");
                if (a |= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal begin: Not an integer");
                if (b >>>= 0, "number" != typeof c || 0 !== c % 1) throw TypeError("Illegal end: Not an integer");
                if (c >>>= 0, 0 > b || b > c || c > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + b + " <= " + c + " <= " + this.buffer.byteLength);
            }
            if (b >= c) return this;
            for (;c > b; ) this.view.setUint8(b++, a);
            return d && (this.offset = b), this;
        }, e.flip = function() {
            return this.limit = this.offset, this.offset = 0, this;
        }, e.mark = function(a) {
            if (a = "undefined" == typeof a ? this.offset : a, !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal offset: " + a + " (not an integer)");
                if (a >>>= 0, 0 > a || a + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + a + " (+0) <= " + this.buffer.byteLength);
            }
            return this.markedOffset = a, this;
        }, e.order = function(a) {
            if (!this.noAssert && "boolean" != typeof a) throw TypeError("Illegal littleEndian: Not a boolean");
            return this.littleEndian = !!a, this;
        }, e.LE = function(a) {
            return this.littleEndian = "undefined" != typeof a ? !!a : !0, this;
        }, e.BE = function(a) {
            return this.littleEndian = "undefined" != typeof a ? !a : !1, this;
        }, e.prepend = function(a, c, d) {
            var e, g, f, h;
            if (("number" == typeof c || "string" != typeof c) && (d = c, c = void 0), e = "undefined" == typeof d, 
            e && (d = this.offset), !this.noAssert) {
                if ("number" != typeof d || 0 !== d % 1) throw TypeError("Illegal offset: " + d + " (not an integer)");
                if (d >>>= 0, 0 > d || d + 0 > this.buffer.byteLength) throw RangeError("Illegal offset: 0 <= " + d + " (+0) <= " + this.buffer.byteLength);
            }
            return a instanceof b || (a = b.wrap(a, c)), c = a.limit - a.offset, 0 >= c ? this : (f = c - d, 
            f > 0 ? (h = new ArrayBuffer(this.buffer.byteLength + f), g = new Uint8Array(h), 
            g.set(new Uint8Array(this.buffer).subarray(d, this.buffer.byteLength), c), this.buffer = h, 
            this.view = new DataView(h), this.offset += f, 0 <= this.markedOffset && (this.markedOffset += f), 
            this.limit += f, d += f) : g = new Uint8Array(this.buffer), g.set(new Uint8Array(a.buffer).subarray(a.offset, a.limit), d - c), 
            a.offset = a.limit, e && (this.offset -= c), this);
        }, e.prependTo = function(a, b) {
            return a.prepend(this, b), this;
        }, e.printDebug = function(a) {
            "function" != typeof a && (a = console.log.bind(console)), a(this.toString() + "\n-------------------------------------------------------------------\n" + this.toDebug(!0));
        }, e.remaining = function() {
            return this.limit - this.offset;
        }, e.reset = function() {
            return 0 <= this.markedOffset ? (this.offset = this.markedOffset, this.markedOffset = -1) : this.offset = 0, 
            this;
        }, e.resize = function(a) {
            if (!this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal capacity: " + a + " (not an integer)");
                if (a |= 0, 0 > a) throw RangeError("Illegal capacity: 0 <= " + a);
            }
            return this.buffer.byteLength < a && (a = new ArrayBuffer(a), new Uint8Array(a).set(new Uint8Array(this.buffer)), 
            this.buffer = a, this.view = new DataView(a)), this;
        }, e.reverse = function(a, b) {
            if ("undefined" == typeof a && (a = this.offset), "undefined" == typeof b && (b = this.limit), 
            !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal begin: Not an integer");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal end: Not an integer");
                if (b >>>= 0, 0 > a || a > b || b > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + a + " <= " + b + " <= " + this.buffer.byteLength);
            }
            return a === b ? this : (Array.prototype.reverse.call(new Uint8Array(this.buffer).subarray(a, b)), 
            this.view = new DataView(this.buffer), this);
        }, e.skip = function(a) {
            if (!this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal length: " + a + " (not an integer)");
                a |= 0;
            }
            var b = this.offset + a;
            if (!this.noAssert && (0 > b || b > this.buffer.byteLength)) throw RangeError("Illegal length: 0 <= " + this.offset + " + " + a + " <= " + this.buffer.byteLength);
            return this.offset = b, this;
        }, e.slice = function(a, b) {
            if ("undefined" == typeof a && (a = this.offset), "undefined" == typeof b && (b = this.limit), 
            !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal begin: Not an integer");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal end: Not an integer");
                if (b >>>= 0, 0 > a || a > b || b > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + a + " <= " + b + " <= " + this.buffer.byteLength);
            }
            var c = this.clone();
            return c.offset = a, c.limit = b, c;
        }, e.toBuffer = function(a) {
            var d, b = this.offset, c = this.limit;
            if (b > c && (d = b, b = c, c = d), !this.noAssert) {
                if ("number" != typeof b || 0 !== b % 1) throw TypeError("Illegal offset: Not an integer");
                if (b >>>= 0, "number" != typeof c || 0 !== c % 1) throw TypeError("Illegal limit: Not an integer");
                if (c >>>= 0, 0 > b || b > c || c > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + b + " <= " + c + " <= " + this.buffer.byteLength);
            }
            return a || 0 !== b || c !== this.buffer.byteLength ? b === c ? f : (a = new ArrayBuffer(c - b), 
            new Uint8Array(a).set(new Uint8Array(this.buffer).subarray(b, c), 0), a) : this.buffer;
        }, e.toArrayBuffer = e.toBuffer, e.toString = function(a, b, c) {
            if ("undefined" == typeof a) return "ByteBufferAB(offset=" + this.offset + ",markedOffset=" + this.markedOffset + ",limit=" + this.limit + ",capacity=" + this.capacity() + ")";
            switch ("number" == typeof a && (c = b = a = "utf8"), a) {
              case "utf8":
                return this.toUTF8(b, c);

              case "base64":
                return this.toBase64(b, c);

              case "hex":
                return this.toHex(b, c);

              case "binary":
                return this.toBinary(b, c);

              case "debug":
                return this.toDebug();

              case "columns":
                return this.m();

              default:
                throw Error("Unsupported encoding: " + a);
            }
        }, h = function() {
            for (var a = {}, b = [ 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43, 47 ], c = [], d = 0, e = b.length; e > d; ++d) c[b[d]] = d;
            return a.i = function(a, c) {
                for (var d, e; null !== (d = a()); ) c(b[63 & d >> 2]), e = (3 & d) << 4, null !== (d = a()) ? (e |= 15 & d >> 4, 
                c(b[63 & (e | 15 & d >> 4)]), e = (15 & d) << 2, null !== (d = a()) ? (c(b[63 & (e | 3 & d >> 6)]), 
                c(b[63 & d])) : (c(b[63 & e]), c(61))) : (c(b[63 & e]), c(61), c(61));
            }, a.h = function(a, b) {
                function d(a) {
                    throw Error("Illegal character code: " + a);
                }
                for (var e, f, g; null !== (e = a()); ) if (f = c[e], "undefined" == typeof f && d(e), 
                null !== (e = a()) && (g = c[e], "undefined" == typeof g && d(e), b(f << 2 >>> 0 | (48 & g) >> 4), 
                null !== (e = a()))) {
                    if (f = c[e], "undefined" == typeof f) {
                        if (61 === e) break;
                        d(e);
                    }
                    if (b((15 & g) << 4 >>> 0 | (60 & f) >> 2), null !== (e = a())) {
                        if (g = c[e], "undefined" == typeof g) {
                            if (61 === e) break;
                            d(e);
                        }
                        b((3 & f) << 6 >>> 0 | g);
                    }
                }
            }, a.test = function(a) {
                return /^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$/.test(a);
            }, a;
        }(), e.toBase64 = function(a, b) {
            if ("undefined" == typeof a && (a = this.offset), "undefined" == typeof b && (b = this.limit), 
            !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal begin: Not an integer");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal end: Not an integer");
                if (b >>>= 0, 0 > a || a > b || b > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + a + " <= " + b + " <= " + this.buffer.byteLength);
            }
            var c;
            return h.i(function() {
                return b > a ? this.view.getUint8(a++) : null;
            }.bind(this), c = d()), c();
        }, b.fromBase64 = function(a, d, e) {
            if (!e) {
                if ("string" != typeof a) throw TypeError("Illegal str: Not a string");
                if (0 !== a.length % 4) throw TypeError("Illegal str: Length not a multiple of 4");
            }
            var f = new b(3 * (a.length / 4), d, e), g = 0;
            return h.h(c(a), function(a) {
                f.view.setUint8(g++, a);
            }), f.limit = g, f;
        }, b.btoa = function(a) {
            return b.fromBinary(a).toBase64();
        }, b.atob = function(a) {
            return b.fromBase64(a).toBinary();
        }, e.toBinary = function(a, b) {
            if (a = "undefined" == typeof a ? this.offset : a, b = "undefined" == typeof b ? this.limit : b, 
            !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal begin: Not an integer");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal end: Not an integer");
                if (b >>>= 0, 0 > a || a > b || b > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + a + " <= " + b + " <= " + this.buffer.byteLength);
            }
            if (a === b) return "";
            for (var c = [], d = []; b > a; ) c.push(this.view.getUint8(a++)), 1024 <= c.length && (d.push(String.fromCharCode.apply(String, c)), 
            c = []);
            return d.join("") + String.fromCharCode.apply(String, c);
        }, b.fromBinary = function(a, c, d) {
            if (!d && "string" != typeof a) throw TypeError("Illegal str: Not a string");
            for (var e = 0, f = a.length, g = new b(f, c, d); f > e; ) {
                if (c = a.charCodeAt(e), !d && c > 255) throw RangeError("Illegal charCode at " + e + ": 0 <= " + c + " <= 255");
                g.view.setUint8(e++, c);
            }
            return g.limit = f, g;
        }, e.toDebug = function(a) {
            for (var d, b = -1, c = this.buffer.byteLength, e = "", f = "", g = ""; c > b; ) {
                if (-1 !== b && (d = this.view.getUint8(b), e = 16 > d ? e + ("0" + d.toString(16).toUpperCase()) : e + d.toString(16).toUpperCase(), 
                a && (f += d > 32 && 127 > d ? String.fromCharCode(d) : ".")), ++b, a && b > 0 && 0 === b % 16 && b !== c) {
                    for (;51 > e.length; ) e += " ";
                    g += e + f + "\n", e = f = "";
                }
                e = b === this.offset && b === this.limit ? e + (b === this.markedOffset ? "!" : "|") : b === this.offset ? e + (b === this.markedOffset ? "[" : "<") : b === this.limit ? e + (b === this.markedOffset ? "]" : ">") : e + (b === this.markedOffset ? "'" : a || 0 !== b && b !== c ? " " : "");
            }
            if (a && " " !== e) {
                for (;51 > e.length; ) e += " ";
                g += e + f + "\n";
            }
            return a ? g : e;
        }, b.fromDebug = function(a, c, d) {
            var h, f, g, i, j, k, l, m, e = a.length;
            for (c = new b(0 | (e + 1) / 3, c, d), f = 0, g = 0, i = !1, j = !1, k = !1, l = !1, 
            m = !1; e > f; ) {
                switch (h = a.charAt(f++)) {
                  case "!":
                    if (!d) {
                        if (j || k || l) {
                            m = !0;
                            break;
                        }
                        j = k = l = !0;
                    }
                    c.offset = c.markedOffset = c.limit = g, i = !1;
                    break;

                  case "|":
                    if (!d) {
                        if (j || l) {
                            m = !0;
                            break;
                        }
                        j = l = !0;
                    }
                    c.offset = c.limit = g, i = !1;
                    break;

                  case "[":
                    if (!d) {
                        if (j || k) {
                            m = !0;
                            break;
                        }
                        j = k = !0;
                    }
                    c.offset = c.markedOffset = g, i = !1;
                    break;

                  case "<":
                    if (!d) {
                        if (j) {
                            m = !0;
                            break;
                        }
                        j = !0;
                    }
                    c.offset = g, i = !1;
                    break;

                  case "]":
                    if (!d) {
                        if (l || k) {
                            m = !0;
                            break;
                        }
                        l = k = !0;
                    }
                    c.limit = c.markedOffset = g, i = !1;
                    break;

                  case ">":
                    if (!d) {
                        if (l) {
                            m = !0;
                            break;
                        }
                        l = !0;
                    }
                    c.limit = g, i = !1;
                    break;

                  case "'":
                    if (!d) {
                        if (k) {
                            m = !0;
                            break;
                        }
                        k = !0;
                    }
                    c.markedOffset = g, i = !1;
                    break;

                  case " ":
                    i = !1;
                    break;

                  default:
                    if (!d && i) {
                        m = !0;
                        break;
                    }
                    if (h = parseInt(h + a.charAt(f++), 16), !d && (isNaN(h) || 0 > h || h > 255)) throw TypeError("Illegal str: Not a debug encoded string");
                    c.view.setUint8(g++, h), i = !0;
                }
                if (m) throw TypeError("Illegal str: Invalid symbol at " + f);
            }
            if (!d) {
                if (!j || !l) throw TypeError("Illegal str: Missing offset or limit");
                if (g < c.buffer.byteLength) throw TypeError("Illegal str: Not a debug encoded string (is it hex?) " + g + " < " + e);
            }
            return c;
        }, e.toHex = function(a, b) {
            if (a = "undefined" == typeof a ? this.offset : a, b = "undefined" == typeof b ? this.limit : b, 
            !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal begin: Not an integer");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal end: Not an integer");
                if (b >>>= 0, 0 > a || a > b || b > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + a + " <= " + b + " <= " + this.buffer.byteLength);
            }
            for (var d, c = Array(b - a); b > a; ) d = this.view.getUint8(a++), 16 > d ? c.push("0", d.toString(16)) : c.push(d.toString(16));
            return c.join("");
        }, b.fromHex = function(a, c, d) {
            var e, f, g, h;
            if (!d) {
                if ("string" != typeof a) throw TypeError("Illegal str: Not a string");
                if (0 !== a.length % 2) throw TypeError("Illegal str: Length not a multiple of 2");
            }
            for (e = a.length, c = new b(0 | e / 2, c), g = 0, h = 0; e > g; g += 2) {
                if (f = parseInt(a.substring(g, g + 2), 16), !d && (!isFinite(f) || 0 > f || f > 255)) throw TypeError("Illegal str: Contains non-hex characters");
                c.view.setUint8(h++, f);
            }
            return c.limit = h, c;
        }, j = function() {
            var a = {
                k: 1114111,
                j: function(a, b) {
                    var c = null;
                    for ("number" == typeof a && (c = a, a = function() {
                        return null;
                    }); null !== c || null !== (c = a()); ) 128 > c ? b(127 & c) : (2048 > c ? b(192 | 31 & c >> 6) : (65536 > c ? b(224 | 15 & c >> 12) : (b(240 | 7 & c >> 18), 
                    b(128 | 63 & c >> 12)), b(128 | 63 & c >> 6)), b(128 | 63 & c)), c = null;
                },
                g: function(a, b) {
                    function c(a) {
                        a = a.slice(0, a.indexOf(null));
                        var b = Error(a.toString());
                        throw b.name = "TruncatedError", b.bytes = a, b;
                    }
                    for (var d, e, f, g; null !== (d = a()); ) if (0 === (128 & d)) b(d); else if (192 === (224 & d)) null === (e = a()) && c([ d, e ]), 
                    b((31 & d) << 6 | 63 & e); else if (224 === (240 & d)) null !== (e = a()) && null !== (f = a()) || c([ d, e, f ]), 
                    b((15 & d) << 12 | (63 & e) << 6 | 63 & f); else {
                        if (240 !== (248 & d)) throw RangeError("Illegal starting byte: " + d);
                        null !== (e = a()) && null !== (f = a()) && null !== (g = a()) || c([ d, e, f, g ]), 
                        b((7 & d) << 18 | (63 & e) << 12 | (63 & f) << 6 | 63 & g);
                    }
                },
                d: function(a, b) {
                    for (var c, d = null; null !== (c = null !== d ? d : a()); ) c >= 55296 && 57343 >= c && null !== (d = a()) && d >= 56320 && 57343 >= d ? (b(1024 * (c - 55296) + d - 56320 + 65536), 
                    d = null) : b(c);
                    null !== d && b(d);
                },
                e: function(a, b) {
                    var c = null;
                    for ("number" == typeof a && (c = a, a = function() {
                        return null;
                    }); null !== c || null !== (c = a()); ) 65535 >= c ? b(c) : (c -= 65536, b((c >> 10) + 55296), 
                    b(c % 1024 + 56320)), c = null;
                },
                c: function(b, c) {
                    a.d(b, function(b) {
                        a.j(b, c);
                    });
                },
                b: function(b, c) {
                    a.g(b, function(b) {
                        a.e(b, c);
                    });
                },
                f: function(a) {
                    return 128 > a ? 1 : 2048 > a ? 2 : 65536 > a ? 3 : 4;
                },
                l: function(b) {
                    for (var c, d = 0; null !== (c = b()); ) d += a.f(c);
                    return d;
                },
                a: function(b) {
                    var c = 0, d = 0;
                    return a.d(b, function(b) {
                        ++c, d += a.f(b);
                    }), [ c, d ];
                }
            };
            return a;
        }(), e.toUTF8 = function(a, b) {
            if ("undefined" == typeof a && (a = this.offset), "undefined" == typeof b && (b = this.limit), 
            !this.noAssert) {
                if ("number" != typeof a || 0 !== a % 1) throw TypeError("Illegal begin: Not an integer");
                if (a >>>= 0, "number" != typeof b || 0 !== b % 1) throw TypeError("Illegal end: Not an integer");
                if (b >>>= 0, 0 > a || a > b || b > this.buffer.byteLength) throw RangeError("Illegal range: 0 <= " + a + " <= " + b + " <= " + this.buffer.byteLength);
            }
            var c;
            try {
                j.b(function() {
                    return b > a ? this.view.getUint8(a++) : null;
                }.bind(this), c = d());
            } catch (e) {
                if (a !== b) throw RangeError("Illegal range: Truncated data, " + a + " != " + b);
            }
            return c();
        }, b.fromUTF8 = function(a, d, e) {
            if (!e && "string" != typeof a) throw TypeError("Illegal str: Not a string");
            var f = new b(j.a(c(a), !0)[1], d, e), g = 0;
            return j.c(c(a), function(a) {
                f.view.setUint8(g++, a);
            }), f.limit = g, f;
        }, b;
    }
    "function" == typeof require && "object" == typeof module && module && module.id && "object" == typeof exports && exports ? module.exports = function() {
        var a;
        try {
            a = require("Long");
        } catch (c) {}
        return b(a);
    }() : "function" == typeof define && define.amd ? define("ByteBuffer", [ "Long" ], function(a) {
        return b(a);
    }) : (a.dcodeIO = a.dcodeIO || {}).ByteBuffer = b(a.dcodeIO.Long);
}(this), function(a) {
    function b(a) {
        var b = {
            VERSION: "3.7.0",
            WIRE_TYPES: {}
        };
        return b.WIRE_TYPES.VARINT = 0, b.WIRE_TYPES.BITS64 = 1, b.WIRE_TYPES.LDELIM = 2, 
        b.WIRE_TYPES.STARTGROUP = 3, b.WIRE_TYPES.ENDGROUP = 4, b.WIRE_TYPES.BITS32 = 5, 
        b.PACKABLE_WIRE_TYPES = [ b.WIRE_TYPES.VARINT, b.WIRE_TYPES.BITS64, b.WIRE_TYPES.BITS32 ], 
        b.TYPES = {
            int32: {
                name: "int32",
                wireType: b.WIRE_TYPES.VARINT
            },
            uint32: {
                name: "uint32",
                wireType: b.WIRE_TYPES.VARINT
            },
            sint32: {
                name: "sint32",
                wireType: b.WIRE_TYPES.VARINT
            },
            int64: {
                name: "int64",
                wireType: b.WIRE_TYPES.VARINT
            },
            uint64: {
                name: "uint64",
                wireType: b.WIRE_TYPES.VARINT
            },
            sint64: {
                name: "sint64",
                wireType: b.WIRE_TYPES.VARINT
            },
            bool: {
                name: "bool",
                wireType: b.WIRE_TYPES.VARINT
            },
            "double": {
                name: "double",
                wireType: b.WIRE_TYPES.BITS64
            },
            string: {
                name: "string",
                wireType: b.WIRE_TYPES.LDELIM
            },
            bytes: {
                name: "bytes",
                wireType: b.WIRE_TYPES.LDELIM
            },
            fixed32: {
                name: "fixed32",
                wireType: b.WIRE_TYPES.BITS32
            },
            sfixed32: {
                name: "sfixed32",
                wireType: b.WIRE_TYPES.BITS32
            },
            fixed64: {
                name: "fixed64",
                wireType: b.WIRE_TYPES.BITS64
            },
            sfixed64: {
                name: "sfixed64",
                wireType: b.WIRE_TYPES.BITS64
            },
            "float": {
                name: "float",
                wireType: b.WIRE_TYPES.BITS32
            },
            "enum": {
                name: "enum",
                wireType: b.WIRE_TYPES.VARINT
            },
            message: {
                name: "message",
                wireType: b.WIRE_TYPES.LDELIM
            },
            group: {
                name: "group",
                wireType: b.WIRE_TYPES.STARTGROUP
            }
        }, b.ID_MIN = 1, b.ID_MAX = 536870911, b.ByteBuffer = a, b.Long = a.Long || null, 
        b.convertFieldsToCamelCase = !1, b.populateAccessors = !0, b.Util = function() {
            Object.create || (Object.create = function(a) {
                function b() {}
                if (1 < arguments.length) throw Error("Object.create polyfill only accepts the first parameter.");
                return b.prototype = a, new b();
            });
            var a = {
                IS_NODE: !1
            };
            try {
                a.IS_NODE = "function" == typeof require && "function" == typeof require("fs").readFileSync && "function" == typeof require("path").resolve;
            } catch (b) {}
            return a.XHR = function() {
                for (var a = [ function() {
                    return new XMLHttpRequest();
                }, function() {
                    return new ActiveXObject("Msxml2.XMLHTTP");
                }, function() {
                    return new ActiveXObject("Msxml3.XMLHTTP");
                }, function() {
                    return new ActiveXObject("Microsoft.XMLHTTP");
                } ], b = null, c = 0; c < a.length; c++) {
                    try {
                        b = a[c]();
                    } catch (d) {
                        continue;
                    }
                    break;
                }
                if (!b) throw Error("XMLHttpRequest is not supported");
                return b;
            }, a.fetch = function(b, c) {
                if (c && "function" != typeof c && (c = null), a.IS_NODE) if (c) require("fs").readFile(b, function(a, b) {
                    a ? c(null) : c("" + b);
                }); else try {
                    return require("fs").readFileSync(b);
                } catch (d) {
                    return null;
                } else {
                    var e = a.XHR();
                    if (e.open("GET", b, c ? !0 : !1), e.setRequestHeader("Accept", "text/plain"), "function" == typeof e.overrideMimeType && e.overrideMimeType("text/plain"), 
                    !c) return e.send(null), 200 == e.status || 0 == e.status && "string" == typeof e.responseText ? e.responseText : null;
                    e.onreadystatechange = function() {
                        4 == e.readyState && (200 == e.status || 0 == e.status && "string" == typeof e.responseText ? c(e.responseText) : c(null));
                    }, 4 != e.readyState && e.send(null);
                }
            }, a.isArray = Array.isArray || function(a) {
                return "[object Array]" === Object.prototype.toString.call(a);
            }, a;
        }(), b.Lang = {
            OPEN: "{",
            CLOSE: "}",
            OPTOPEN: "[",
            OPTCLOSE: "]",
            OPTEND: ",",
            EQUAL: "=",
            END: ";",
            STRINGOPEN: '"',
            STRINGCLOSE: '"',
            STRINGOPEN_SQ: "'",
            STRINGCLOSE_SQ: "'",
            COPTOPEN: "(",
            COPTCLOSE: ")",
            DELIM: /[\s\{\}=;\[\],'"\(\)]/g,
            RULE: /^(?:required|optional|repeated)$/,
            TYPE: /^(?:double|float|int32|uint32|sint32|int64|uint64|sint64|fixed32|sfixed32|fixed64|sfixed64|bool|string|bytes)$/,
            NAME: /^[a-zA-Z_][a-zA-Z_0-9]*$/,
            TYPEDEF: /^[a-zA-Z][a-zA-Z_0-9]*$/,
            TYPEREF: /^(?:\.?[a-zA-Z_][a-zA-Z_0-9]*)+$/,
            FQTYPEREF: /^(?:\.[a-zA-Z][a-zA-Z_0-9]*)+$/,
            NUMBER: /^-?(?:[1-9][0-9]*|0|0x[0-9a-fA-F]+|0[0-7]+|([0-9]*\.[0-9]+([Ee][+-]?[0-9]+)?))$/,
            NUMBER_DEC: /^(?:[1-9][0-9]*|0)$/,
            NUMBER_HEX: /^0x[0-9a-fA-F]+$/,
            NUMBER_OCT: /^0[0-7]+$/,
            NUMBER_FLT: /^[0-9]*\.[0-9]+([Ee][+-]?[0-9]+)?$/,
            ID: /^(?:[1-9][0-9]*|0|0x[0-9a-fA-F]+|0[0-7]+)$/,
            NEGID: /^\-?(?:[1-9][0-9]*|0|0x[0-9a-fA-F]+|0[0-7]+)$/,
            WHITESPACE: /\s/,
            STRING: /['"]([^'"\\]*(\\.[^"\\]*)*)['"]/g,
            BOOL: /^(?:true|false)$/i
        }, b.DotProto = function(a, b) {
            var f, c = {}, d = function(a) {
                this.source = "" + a, this.index = 0, this.line = 1, this.stack = [], this.readingString = !1, 
                this.stringEndsWith = b.STRINGCLOSE;
            }, e = d.prototype;
            return e._readString = function() {
                b.STRING.lastIndex = this.index - 1;
                var a;
                if (null !== (a = b.STRING.exec(this.source))) return a = a[1], this.index = b.STRING.lastIndex, 
                this.stack.push(this.stringEndsWith), a;
                throw Error("Unterminated string at line " + this.line + ", index " + this.index);
            }, e.next = function() {
                if (0 < this.stack.length) return this.stack.shift();
                if (this.index >= this.source.length) return null;
                if (this.readingString) return this.readingString = !1, this._readString();
                var a, c;
                do {
                    for (a = !1; b.WHITESPACE.test(c = this.source.charAt(this.index)); ) if (this.index++, 
                    "\n" === c && this.line++, this.index === this.source.length) return null;
                    if ("/" === this.source.charAt(this.index)) if ("/" === this.source.charAt(++this.index)) {
                        for (;"\n" !== this.source.charAt(this.index); ) if (this.index++, this.index == this.source.length) return null;
                        this.index++, this.line++, a = !0;
                    } else {
                        if ("*" !== this.source.charAt(this.index)) throw Error("Unterminated comment at line " + this.line + ": /" + this.source.charAt(this.index));
                        for (c = ""; "*/" !== c + (c = this.source.charAt(this.index)); ) if (this.index++, 
                        "\n" === c && this.line++, this.index === this.source.length) return null;
                        this.index++, a = !0;
                    }
                } while (a);
                if (this.index === this.source.length) return null;
                if (a = this.index, b.DELIM.lastIndex = 0, b.DELIM.test(this.source.charAt(a))) ++a; else for (++a; a < this.source.length && !b.DELIM.test(this.source.charAt(a)); ) a++;
                return a = this.source.substring(this.index, this.index = a), a === b.STRINGOPEN ? (this.readingString = !0, 
                this.stringEndsWith = b.STRINGCLOSE) : a === b.STRINGOPEN_SQ && (this.readingString = !0, 
                this.stringEndsWith = b.STRINGCLOSE_SQ), a;
            }, e.peek = function() {
                if (0 === this.stack.length) {
                    var a = this.next();
                    if (null === a) return null;
                    this.stack.push(a);
                }
                return this.stack[0];
            }, e.toString = function() {
                return "Tokenizer(" + this.index + "/" + this.source.length + " at line " + this.line + ")";
            }, c.Tokenizer = d, e = function(a) {
                this.tn = new d(a);
            }, f = e.prototype, f.parse = function() {
                for (var b, a = {
                    name: "[ROOT]",
                    "package": null,
                    messages: [],
                    enums: [],
                    imports: [],
                    options: {},
                    services: []
                }, c = !0; b = this.tn.next(); ) switch (b) {
                  case "package":
                    if (!c || null !== a["package"]) throw Error("Unexpected package at line " + this.tn.line);
                    a["package"] = this._parsePackage(b);
                    break;

                  case "import":
                    if (!c) throw Error("Unexpected import at line " + this.tn.line);
                    a.imports.push(this._parseImport(b));
                    break;

                  case "message":
                    this._parseMessage(a, null, b), c = !1;
                    break;

                  case "enum":
                    this._parseEnum(a, b), c = !1;
                    break;

                  case "option":
                    if (!c) throw Error("Unexpected option at line " + this.tn.line);
                    this._parseOption(a, b);
                    break;

                  case "service":
                    this._parseService(a, b);
                    break;

                  case "extend":
                    this._parseExtend(a, b);
                    break;

                  case "syntax":
                    this._parseIgnoredStatement(a, b);
                    break;

                  default:
                    throw Error("Unexpected token at line " + this.tn.line + ": " + b);
                }
                return delete a.name, a;
            }, f._parseNumber = function(a) {
                var c = 1;
                if ("-" == a.charAt(0) && (c = -1, a = a.substring(1)), b.NUMBER_DEC.test(a)) return c * parseInt(a, 10);
                if (b.NUMBER_HEX.test(a)) return c * parseInt(a.substring(2), 16);
                if (b.NUMBER_OCT.test(a)) return c * parseInt(a.substring(1), 8);
                if (b.NUMBER_FLT.test(a)) return c * parseFloat(a);
                throw Error("Illegal number at line " + this.tn.line + ": " + (0 > c ? "-" : "") + a);
            }, f._parseString = function() {
                var c, a = "";
                do {
                    if (this.tn.next(), a += this.tn.next(), c = this.tn.next(), c !== this.tn.stringEndsWith) throw Error("Illegal end of string at line " + this.tn.line + ": " + c);
                    c = this.tn.peek();
                } while (c === b.STRINGOPEN || c === b.STRINGOPEN_SQ);
                return a;
            }, f._parseId = function(a, c) {
                var d = -1, e = 1;
                if ("-" == a.charAt(0) && (e = -1, a = a.substring(1)), b.NUMBER_DEC.test(a)) d = parseInt(a); else if (b.NUMBER_HEX.test(a)) d = parseInt(a.substring(2), 16); else {
                    if (!b.NUMBER_OCT.test(a)) throw Error("Illegal id at line " + this.tn.line + ": " + (0 > e ? "-" : "") + a);
                    d = parseInt(a.substring(1), 8);
                }
                if (d = 0 | e * d, !c && 0 > d) throw Error("Illegal id at line " + this.tn.line + ": " + (0 > e ? "-" : "") + a);
                return d;
            }, f._parsePackage = function(a) {
                if (a = this.tn.next(), !b.TYPEREF.test(a)) throw Error("Illegal package name at line " + this.tn.line + ": " + a);
                var c = a;
                if (a = this.tn.next(), a != b.END) throw Error("Illegal end of package at line " + this.tn.line + ": " + a);
                return c;
            }, f._parseImport = function(a) {
                if (a = this.tn.peek(), "public" === a && (this.tn.next(), a = this.tn.peek()), 
                a !== b.STRINGOPEN && a !== b.STRINGOPEN_SQ) throw Error("Illegal start of import at line " + this.tn.line + ": " + a);
                var c = this._parseString();
                if (a = this.tn.next(), a !== b.END) throw Error("Illegal end of import at line " + this.tn.line + ": " + a);
                return c;
            }, f._parseOption = function(a, c) {
                var d, e;
                if (c = this.tn.next(), d = !1, c == b.COPTOPEN && (d = !0, c = this.tn.next()), 
                !b.TYPEREF.test(c) && !/google\.protobuf\./.test(c)) throw Error("Illegal option name in message " + a.name + " at line " + this.tn.line + ": " + c);
                if (e = c, c = this.tn.next(), d) {
                    if (c !== b.COPTCLOSE) throw Error("Illegal end in message " + a.name + ", option " + e + " at line " + this.tn.line + ": " + c);
                    e = "(" + e + ")", c = this.tn.next(), b.FQTYPEREF.test(c) && (e += c, c = this.tn.next());
                }
                if (c !== b.EQUAL) throw Error("Illegal operator in message " + a.name + ", option " + e + " at line " + this.tn.line + ": " + c);
                if (c = this.tn.peek(), c === b.STRINGOPEN || c === b.STRINGOPEN_SQ) d = this._parseString(); else if (this.tn.next(), 
                b.NUMBER.test(c)) d = this._parseNumber(c, !0); else if (b.BOOL.test(c)) d = "true" === c; else {
                    if (!b.TYPEREF.test(c)) throw Error("Illegal option value in message " + a.name + ", option " + e + " at line " + this.tn.line + ": " + c);
                    d = c;
                }
                if (c = this.tn.next(), c !== b.END) throw Error("Illegal end of option in message " + a.name + ", option " + e + " at line " + this.tn.line + ": " + c);
                a.options[e] = d;
            }, f._parseIgnoredStatement = function(a, c) {
                for (var d; ;) {
                    if (d = this.tn.next(), null === d) throw Error("Unexpected EOF in " + a.name + ", " + c + " at line " + this.tn.line);
                    if (d === b.END) break;
                }
            }, f._parseService = function(a, c) {
                if (c = this.tn.next(), !b.NAME.test(c)) throw Error("Illegal service name at line " + this.tn.line + ": " + c);
                var d = c, e = {
                    name: d,
                    rpc: {},
                    options: {}
                };
                if (c = this.tn.next(), c !== b.OPEN) throw Error("Illegal start of service " + d + " at line " + this.tn.line + ": " + c);
                do if (c = this.tn.next(), "option" === c) this._parseOption(e, c); else if ("rpc" === c) this._parseServiceRPC(e, c); else if (c !== b.CLOSE) throw Error("Illegal type of service " + d + " at line " + this.tn.line + ": " + c); while (c !== b.CLOSE);
                a.services.push(e);
            }, f._parseServiceRPC = function(a, c) {
                var e, f, d = c;
                if (c = this.tn.next(), !b.NAME.test(c)) throw Error("Illegal method name in service " + a.name + " at line " + this.tn.line + ": " + c);
                if (e = c, f = {
                    request: null,
                    response: null,
                    options: {}
                }, c = this.tn.next(), c !== b.COPTOPEN) throw Error("Illegal start of request type in service " + a.name + "#" + e + " at line " + this.tn.line + ": " + c);
                if (c = this.tn.next(), !b.TYPEREF.test(c)) throw Error("Illegal request type in service " + a.name + "#" + e + " at line " + this.tn.line + ": " + c);
                if (f.request = c, c = this.tn.next(), c != b.COPTCLOSE) throw Error("Illegal end of request type in service " + a.name + "#" + e + " at line " + this.tn.line + ": " + c);
                if (c = this.tn.next(), "returns" !== c.toLowerCase()) throw Error("Illegal delimiter in service " + a.name + "#" + e + " at line " + this.tn.line + ": " + c);
                if (c = this.tn.next(), c != b.COPTOPEN) throw Error("Illegal start of response type in service " + a.name + "#" + e + " at line " + this.tn.line + ": " + c);
                if (c = this.tn.next(), f.response = c, c = this.tn.next(), c !== b.COPTCLOSE) throw Error("Illegal end of response type in service " + a.name + "#" + e + " at line " + this.tn.line + ": " + c);
                if (c = this.tn.next(), c === b.OPEN) {
                    do if (c = this.tn.next(), "option" === c) this._parseOption(f, c); else if (c !== b.CLOSE) throw Error("Illegal start of option inservice " + a.name + "#" + e + " at line " + this.tn.line + ": " + c); while (c !== b.CLOSE);
                    this.tn.peek() === b.END && this.tn.next();
                } else if (c !== b.END) throw Error("Illegal delimiter in service " + a.name + "#" + e + " at line " + this.tn.line + ": " + c);
                "undefined" == typeof a[d] && (a[d] = {}), a[d][e] = f;
            }, f._parseMessage = function(a, c, d) {
                var e = {}, f = "group" === d;
                if (d = this.tn.next(), !b.NAME.test(d)) throw Error("Illegal " + (f ? "group" : "message") + " name" + (a ? " in message " + a.name : "") + " at line " + this.tn.line + ": " + d);
                if (e.name = d, f) {
                    if (d = this.tn.next(), d !== b.EQUAL) throw Error("Illegal id assignment after group " + e.name + " at line " + this.tn.line + ": " + d);
                    d = this.tn.next();
                    try {
                        c.id = this._parseId(d);
                    } catch (g) {
                        throw Error("Illegal field id value for group " + e.name + "#" + c.name + " at line " + this.tn.line + ": " + d);
                    }
                    e.isGroup = !0;
                }
                if (e.fields = [], e.enums = [], e.messages = [], e.options = {}, e.oneofs = {}, 
                d = this.tn.next(), d === b.OPTOPEN && c && (this._parseFieldOptions(e, c, d), d = this.tn.next()), 
                d !== b.OPEN) throw Error("Illegal start of " + (f ? "group" : "message") + " " + e.name + " at line " + this.tn.line + ": " + d);
                for (;;) {
                    if (d = this.tn.next(), d === b.CLOSE) {
                        d = this.tn.peek(), d === b.END && this.tn.next();
                        break;
                    }
                    if (b.RULE.test(d)) this._parseMessageField(e, d); else if ("oneof" === d) this._parseMessageOneOf(e, d); else if ("enum" === d) this._parseEnum(e, d); else if ("message" === d) this._parseMessage(e, null, d); else if ("option" === d) this._parseOption(e, d); else if ("extensions" === d) e.extensions = this._parseExtensions(e, d); else {
                        if ("extend" !== d) throw Error("Illegal token in message " + e.name + " at line " + this.tn.line + ": " + d);
                        this._parseExtend(e, d);
                    }
                }
                return a.messages.push(e), e;
            }, f._parseMessageField = function(a, c) {
                var d = {}, e = null;
                if (d.rule = c, d.options = {}, c = this.tn.next(), "group" === c) {
                    if (e = this._parseMessage(a, d, c), !/^[A-Z]/.test(e.name)) throw Error("Group names must start with a capital letter");
                    d.type = e.name, d.name = e.name.toLowerCase(), c = this.tn.peek(), c === b.END && this.tn.next();
                } else {
                    if (!b.TYPE.test(c) && !b.TYPEREF.test(c)) throw Error("Illegal field type in message " + a.name + " at line " + this.tn.line + ": " + c);
                    if (d.type = c, c = this.tn.next(), !b.NAME.test(c)) throw Error("Illegal field name in message " + a.name + " at line " + this.tn.line + ": " + c);
                    if (d.name = c, c = this.tn.next(), c !== b.EQUAL) throw Error("Illegal token in field " + a.name + "#" + d.name + " at line " + this.tn.line + ": " + c);
                    c = this.tn.next();
                    try {
                        d.id = this._parseId(c);
                    } catch (f) {
                        throw Error("Illegal field id in message " + a.name + "#" + d.name + " at line " + this.tn.line + ": " + c);
                    }
                    if (c = this.tn.next(), c === b.OPTOPEN && (this._parseFieldOptions(a, d, c), c = this.tn.next()), 
                    c !== b.END) throw Error("Illegal delimiter in message " + a.name + "#" + d.name + " at line " + this.tn.line + ": " + c);
                }
                return a.fields.push(d), d;
            }, f._parseMessageOneOf = function(a, c) {
                if (c = this.tn.next(), !b.NAME.test(c)) throw Error("Illegal oneof name in message " + a.name + " at line " + this.tn.line + ": " + c);
                var e, d = c, f = [];
                if (c = this.tn.next(), c !== b.OPEN) throw Error("Illegal start of oneof " + d + " at line " + this.tn.line + ": " + c);
                for (;this.tn.peek() !== b.CLOSE; ) e = this._parseMessageField(a, "optional"), 
                e.oneof = d, f.push(e.id);
                this.tn.next(), a.oneofs[d] = f;
            }, f._parseFieldOptions = function(a, c, d) {
                for (var e = !0; ;) {
                    if (d = this.tn.next(), d === b.OPTCLOSE) break;
                    if (d === b.OPTEND) {
                        if (e) throw Error("Illegal start of options in message " + a.name + "#" + c.name + " at line " + this.tn.line + ": " + d);
                        d = this.tn.next();
                    }
                    this._parseFieldOption(a, c, d), e = !1;
                }
            }, f._parseFieldOption = function(a, c, d) {
                var f, e = !1;
                if (d === b.COPTOPEN && (d = this.tn.next(), e = !0), !b.TYPEREF.test(d)) throw Error("Illegal field option in " + a.name + "#" + c.name + " at line " + this.tn.line + ": " + d);
                if (f = d, d = this.tn.next(), e) {
                    if (d !== b.COPTCLOSE) throw Error("Illegal delimiter in " + a.name + "#" + c.name + " at line " + this.tn.line + ": " + d);
                    f = "(" + f + ")", d = this.tn.next(), b.FQTYPEREF.test(d) && (f += d, d = this.tn.next());
                }
                if (d !== b.EQUAL) throw Error("Illegal token in " + a.name + "#" + c.name + " at line " + this.tn.line + ": " + d);
                if (d = this.tn.peek(), d === b.STRINGOPEN || d === b.STRINGOPEN_SQ) a = this._parseString(); else if (b.NUMBER.test(d, !0)) a = this._parseNumber(this.tn.next(), !0); else if (b.BOOL.test(d)) a = "true" === this.tn.next().toLowerCase(); else {
                    if (!b.TYPEREF.test(d)) throw Error("Illegal value in message " + a.name + "#" + c.name + ", option " + f + " at line " + this.tn.line + ": " + d);
                    a = this.tn.next();
                }
                c.options[f] = a;
            }, f._parseEnum = function(a, c) {
                var d = {};
                if (c = this.tn.next(), !b.NAME.test(c)) throw Error("Illegal enum name in message " + a.name + " at line " + this.tn.line + ": " + c);
                if (d.name = c, c = this.tn.next(), c !== b.OPEN) throw Error("Illegal start of enum " + d.name + " at line " + this.tn.line + ": " + c);
                for (d.values = [], d.options = {}; ;) {
                    if (c = this.tn.next(), c === b.CLOSE) {
                        c = this.tn.peek(), c === b.END && this.tn.next();
                        break;
                    }
                    if ("option" == c) this._parseOption(d, c); else {
                        if (!b.NAME.test(c)) throw Error("Illegal name in enum " + d.name + " at line " + this.tn.line + ": " + c);
                        this._parseEnumValue(d, c);
                    }
                }
                a.enums.push(d);
            }, f._parseEnumValue = function(a, c) {
                var d = {};
                if (d.name = c, c = this.tn.next(), c !== b.EQUAL) throw Error("Illegal token in enum " + a.name + " at line " + this.tn.line + ": " + c);
                c = this.tn.next();
                try {
                    d.id = this._parseId(c, !0);
                } catch (e) {
                    throw Error("Illegal id in enum " + a.name + " at line " + this.tn.line + ": " + c);
                }
                if (a.values.push(d), c = this.tn.next(), c === b.OPTOPEN && (this._parseFieldOptions(a, {
                    options: {}
                }, c), c = this.tn.next()), c !== b.END) throw Error("Illegal delimiter in enum " + a.name + " at line " + this.tn.line + ": " + c);
            }, f._parseExtensions = function(c, d) {
                var e = [];
                if (d = this.tn.next(), "min" === d ? e.push(a.ID_MIN) : "max" === d ? e.push(a.ID_MAX) : e.push(this._parseNumber(d)), 
                d = this.tn.next(), "to" !== d) throw Error("Illegal extensions delimiter in message " + c.name + " at line " + this.tn.line + ": " + d);
                if (d = this.tn.next(), "min" === d ? e.push(a.ID_MIN) : "max" === d ? e.push(a.ID_MAX) : e.push(this._parseNumber(d)), 
                d = this.tn.next(), d !== b.END) throw Error("Illegal extensions delimiter in message " + c.name + " at line " + this.tn.line + ": " + d);
                return e;
            }, f._parseExtend = function(a, c) {
                if (c = this.tn.next(), !b.TYPEREF.test(c)) throw Error("Illegal message name at line " + this.tn.line + ": " + c);
                var d = {};
                if (d.ref = c, d.fields = [], c = this.tn.next(), c !== b.OPEN) throw Error("Illegal start of extend " + d.name + " at line " + this.tn.line + ": " + c);
                for (;;) {
                    if (c = this.tn.next(), c === b.CLOSE) {
                        c = this.tn.peek(), c == b.END && this.tn.next();
                        break;
                    }
                    if (!b.RULE.test(c)) throw Error("Illegal token in extend " + d.name + " at line " + this.tn.line + ": " + c);
                    this._parseMessageField(d, c);
                }
                return a.messages.push(d), d;
            }, f.toString = function() {
                return "Parser";
            }, c.Parser = e, c;
        }(b, b.Lang), b.Reflect = function(b) {
            function c(a, d) {
                var e = d.readVarint32(), f = 7 & e, e = e >> 3;
                switch (f) {
                  case b.WIRE_TYPES.VARINT:
                    do e = d.readUint8(); while (128 === (128 & e));
                    break;

                  case b.WIRE_TYPES.BITS64:
                    d.offset += 8;
                    break;

                  case b.WIRE_TYPES.LDELIM:
                    e = d.readVarint32(), d.offset += e;
                    break;

                  case b.WIRE_TYPES.STARTGROUP:
                    c(e, d);
                    break;

                  case b.WIRE_TYPES.ENDGROUP:
                    if (e === a) return !1;
                    throw Error("Illegal GROUPEND after unknown group: " + e + " (" + a + " expected)");

                  case b.WIRE_TYPES.BITS32:
                    d.offset += 4;
                    break;

                  default:
                    throw Error("Illegal wire type in unknown group " + a + ": " + f);
                }
                return !0;
            }
            function d(a, c) {
                if (a && "number" == typeof a.low && "number" == typeof a.high && "boolean" == typeof a.unsigned && a.low === a.low && a.high === a.high) return new b.Long(a.low, a.high, "undefined" == typeof c ? a.unsigned : c);
                if ("string" == typeof a) return b.Long.fromString(a, c || !1, 10);
                if ("number" == typeof a) return b.Long.fromNumber(a, c || !1);
                throw Error("not convertible to Long");
            }
            var h, i, j, k, l, m, n, e = {}, f = function(a, b, c) {
                this.builder = a, this.parent = b, this.name = c;
            }, g = f.prototype;
            return g.fqn = function() {
                for (var a = this.name, b = this; ;) {
                    if (b = b.parent, null == b) break;
                    a = b.name + "." + a;
                }
                return a;
            }, g.toString = function(a) {
                return (a ? this.className + " " : "") + this.fqn();
            }, g.build = function() {
                throw Error(this.toString(!0) + " cannot be built directly");
            }, e.T = f, h = function(a, b, c, d) {
                f.call(this, a, b, c), this.className = "Namespace", this.children = [], this.options = d || {};
            }, g = h.prototype = Object.create(f.prototype), g.getChildren = function(a) {
                if (a = a || null, null == a) return this.children.slice();
                for (var b = [], c = 0, d = this.children.length; d > c; ++c) this.children[c] instanceof a && b.push(this.children[c]);
                return b;
            }, g.addChild = function(a) {
                var b;
                if (b = this.getChild(a.name)) if (b instanceof i.Field && b.name !== b.originalName && null === this.getChild(b.originalName)) b.name = b.originalName; else {
                    if (!(a instanceof i.Field && a.name !== a.originalName && null === this.getChild(a.originalName))) throw Error("Duplicate name in namespace " + this.toString(!0) + ": " + a.name);
                    a.name = a.originalName;
                }
                this.children.push(a);
            }, g.getChild = function(a) {
                for (var b = "number" == typeof a ? "id" : "name", c = 0, d = this.children.length; d > c; ++c) if (this.children[c][b] === a) return this.children[c];
                return null;
            }, g.resolve = function(a, b) {
                var c = a.split("."), d = this, f = 0;
                if ("" === c[f]) {
                    for (;null !== d.parent; ) d = d.parent;
                    f++;
                }
                do {
                    do {
                        if (d = d.getChild(c[f]), !(d && d instanceof e.T) || b && d instanceof e.Message.Field) {
                            d = null;
                            break;
                        }
                        f++;
                    } while (f < c.length);
                    if (null != d) break;
                    if (null !== this.parent) return this.parent.resolve(a, b);
                } while (null != d);
                return d;
            }, g.build = function() {
                for (var e, a = {}, b = this.children, c = 0, d = b.length; d > c; ++c) e = b[c], 
                e instanceof h && (a[e.name] = e.build());
                return Object.defineProperty && Object.defineProperty(a, "$options", {
                    value: this.buildOpt()
                }), a;
            }, g.buildOpt = function() {
                for (var a = {}, b = Object.keys(this.options), c = 0, d = b.length; d > c; ++c) a[b[c]] = this.options[b[c]];
                return a;
            }, g.getOption = function(a) {
                return "undefined" == typeof a ? this.options : "undefined" != typeof this.options[a] ? this.options[a] : null;
            }, e.Namespace = h, i = function(a, c, d, e, f) {
                h.call(this, a, c, d, e), this.className = "Message", this.extensions = [ b.ID_MIN, b.ID_MAX ], 
                this.clazz = null, this.isGroup = !!f, this._fieldsByName = this._fieldsById = this._fields = null;
            }, j = i.prototype = Object.create(h.prototype), j.build = function(c) {
                if (this.clazz && !c) return this.clazz;
                c = function(b, c) {
                    function d(b, c) {
                        var f, e = {};
                        for (f in b) b.hasOwnProperty(f) && (null === b[f] || "object" != typeof b[f] ? e[f] = b[f] : b[f] instanceof a ? c && (e[f] = b.toBuffer()) : e[f] = d(b[f], c));
                        return e;
                    }
                    var i, j, e = c.getChildren(b.Reflect.Message.Field), f = c.getChildren(b.Reflect.Message.OneOf), g = function(c) {
                        var g, h, i;
                        for (b.Builder.Message.call(this), g = 0, h = f.length; h > g; ++g) this[f[g].name] = null;
                        for (g = 0, h = e.length; h > g; ++g) i = e[g], this[i.name] = i.repeated ? [] : null, 
                        i.required && null !== i.defaultValue && (this[i.name] = i.defaultValue);
                        if (0 < arguments.length) if (1 !== arguments.length || "object" != typeof c || "function" == typeof c.encode || b.Util.isArray(c) || c instanceof a || c instanceof ArrayBuffer || b.Long && c instanceof b.Long) for (g = 0, 
                        h = arguments.length; h > g; ++g) this.$set(e[g].name, arguments[g]); else for (i = Object.keys(c), 
                        g = 0, h = i.length; h > g; ++g) this.$set(i[g], c[i[g]]);
                    }, h = g.prototype = Object.create(b.Builder.Message.prototype);
                    for (h.add = function(a, d, e) {
                        var f = c._fieldsByName[a];
                        if (!e) {
                            if (!f) throw Error(this + "#" + a + " is undefined");
                            if (!(f instanceof b.Reflect.Message.Field)) throw Error(this + "#" + a + " is not a field: " + f.toString(!0));
                            if (!f.repeated) throw Error(this + "#" + a + " is not a repeated field");
                        }
                        null === this[f.name] && (this[f.name] = []), this[f.name].push(e ? d : f.verifyValue(d, !0));
                    }, h.$add = h.add, h.set = function(a, d, e) {
                        if (a && "object" == typeof a) {
                            for (var f in a) a.hasOwnProperty(f) && this.$set(f, a[f], e);
                            return this;
                        }
                        if (f = c._fieldsByName[a], e) this[f.name] = d; else {
                            if (!f) throw Error(this + "#" + a + " is not a field: undefined");
                            if (!(f instanceof b.Reflect.Message.Field)) throw Error(this + "#" + a + " is not a field: " + f.toString(!0));
                            this[f.name] = d = f.verifyValue(d);
                        }
                        return f.oneof && (null !== d ? (null !== this[f.oneof.name] && (this[this[f.oneof.name]] = null), 
                        this[f.oneof.name] = f.name) : f.oneof.name === a && (this[f.oneof.name] = null)), 
                        this;
                    }, h.$set = h.set, h.get = function(a, d) {
                        if (d) return this[a];
                        var e = c._fieldsByName[a];
                        if (!(e && e instanceof b.Reflect.Message.Field)) throw Error(this + "#" + a + " is not a field: undefined");
                        if (!(e instanceof b.Reflect.Message.Field)) throw Error(this + "#" + a + " is not a field: " + e.toString(!0));
                        return this[e.name];
                    }, h.$get = h.get, i = 0; i < e.length; i++) j = e[i], j instanceof b.Reflect.Message.ExtensionField || c.builder.options.populateAccessors && function(a) {
                        var b = a.originalName.replace(/(_[a-zA-Z])/g, function(a) {
                            return a.toUpperCase().replace("_", "");
                        }), b = b.substring(0, 1).toUpperCase() + b.substring(1), d = a.originalName.replace(/([A-Z])/g, function(a) {
                            return "_" + a;
                        }), e = function(b, c) {
                            return this[a.name] = c ? b : a.verifyValue(b), this;
                        }, f = function() {
                            return this[a.name];
                        };
                        null === c.getChild("set" + b) && (h["set" + b] = e), null === c.getChild("set_" + d) && (h["set_" + d] = e), 
                        null === c.getChild("get" + b) && (h["get" + b] = f), null === c.getChild("get_" + d) && (h["get_" + d] = f);
                    }(j);
                    return h.encode = function(b, d) {
                        var e, f;
                        "boolean" == typeof b && (d = b, b = void 0), e = !1, b || (b = new a(), e = !0), 
                        f = b.littleEndian;
                        try {
                            return c.encode(this, b.LE(), d), (e ? b.flip() : b).LE(f);
                        } catch (g) {
                            throw b.LE(f), g;
                        }
                    }, h.calculate = function() {
                        return c.calculate(this);
                    }, h.encodeDelimited = function(b) {
                        var e, d = !1;
                        return b || (b = new a(), d = !0), e = new a().LE(), c.encode(this, e).flip(), b.writeVarint32(e.remaining()), 
                        b.append(e), d ? b.flip() : b;
                    }, h.encodeAB = function() {
                        try {
                            return this.encode().toArrayBuffer();
                        } catch (a) {
                            throw a.encoded && (a.encoded = a.encoded.toArrayBuffer()), a;
                        }
                    }, h.toArrayBuffer = h.encodeAB, h.encodeNB = function() {
                        try {
                            return this.encode().toBuffer();
                        } catch (a) {
                            throw a.encoded && (a.encoded = a.encoded.toBuffer()), a;
                        }
                    }, h.toBuffer = h.encodeNB, h.encode64 = function() {
                        try {
                            return this.encode().toBase64();
                        } catch (a) {
                            throw a.encoded && (a.encoded = a.encoded.toBase64()), a;
                        }
                    }, h.toBase64 = h.encode64, h.encodeHex = function() {
                        try {
                            return this.encode().toHex();
                        } catch (a) {
                            throw a.encoded && (a.encoded = a.encoded.toHex()), a;
                        }
                    }, h.toHex = h.encodeHex, h.toRaw = function(a) {
                        return d(this, !!a);
                    }, g.decode = function(b, d) {
                        var e, f;
                        "string" == typeof b && (b = a.wrap(b, d ? d : "base64")), b = b instanceof a ? b : a.wrap(b), 
                        e = b.littleEndian;
                        try {
                            return f = c.decode(b.LE()), b.LE(e), f;
                        } catch (g) {
                            throw b.LE(e), g;
                        }
                    }, g.decodeDelimited = function(b, d) {
                        var e, f, g;
                        if ("string" == typeof b && (b = a.wrap(b, d ? d : "base64")), b = b instanceof a ? b : a.wrap(b), 
                        1 > b.remaining()) return null;
                        if (e = b.offset, f = b.readVarint32(), b.remaining() < f) return b.offset = e, 
                        null;
                        try {
                            return g = c.decode(b.slice(b.offset, b.offset + f).LE()), b.offset += f, g;
                        } catch (h) {
                            throw b.offset += f, h;
                        }
                    }, g.decode64 = function(a) {
                        return g.decode(a, "base64");
                    }, g.decodeHex = function(a) {
                        return g.decode(a, "hex");
                    }, h.toString = function() {
                        return c.toString();
                    }, Object.defineProperty && (Object.defineProperty(g, "$options", {
                        value: c.buildOpt()
                    }), Object.defineProperty(h, "$type", {
                        get: function() {
                            return c;
                        }
                    })), g;
                }(b, this), this._fields = [], this._fieldsById = {}, this._fieldsByName = {};
                for (var f, d = 0, e = this.children.length; e > d; d++) if (f = this.children[d], 
                f instanceof l) c[f.name] = f.build(); else if (f instanceof i) c[f.name] = f.build(); else if (f instanceof i.Field) f.build(), 
                this._fields.push(f), this._fieldsById[f.id] = f, this._fieldsByName[f.name] = f; else if (!(f instanceof i.OneOf || f instanceof m)) throw Error("Illegal reflect child of " + this.toString(!0) + ": " + children[d].toString(!0));
                return this.clazz = c;
            }, j.encode = function(a, b, c) {
                for (var e, h, d = null, f = 0, g = this._fields.length; g > f; ++f) e = this._fields[f], 
                h = a[e.name], e.required && null === h ? null === d && (d = e) : e.encode(c ? h : e.verifyValue(h), b);
                if (null !== d) throw a = Error("Missing at least one required field for " + this.toString(!0) + ": " + d), 
                a.encoded = b, a;
                return b;
            }, j.calculate = function(a) {
                for (var e, f, b = 0, c = 0, d = this._fields.length; d > c; ++c) {
                    if (e = this._fields[c], f = a[e.name], e.required && null === f) throw Error("Missing at least one required field for " + this.toString(!0) + ": " + e);
                    b += e.calculate(f);
                }
                return b;
            }, j.decode = function(a, d, e) {
                d = "number" == typeof d ? d : -1;
                for (var h, i, j, f = a.offset, g = new this.clazz(); a.offset < f + d || -1 === d && 0 < a.remaining(); ) {
                    if (h = a.readVarint32(), i = 7 & h, j = h >> 3, i === b.WIRE_TYPES.ENDGROUP) {
                        if (j !== e) throw Error("Illegal group end indicator for " + this.toString(!0) + ": " + j + " (" + (e ? e + " expected" : "not a group") + ")");
                        break;
                    }
                    if (h = this._fieldsById[j]) h.repeated && !h.options.packed ? g[h.name].push(h.decode(i, a)) : (g[h.name] = h.decode(i, a), 
                    h.oneof && (null !== this[h.oneof.name] && (this[this[h.oneof.name]] = null), g[h.oneof.name] = h.name)); else switch (i) {
                      case b.WIRE_TYPES.VARINT:
                        a.readVarint32();
                        break;

                      case b.WIRE_TYPES.BITS32:
                        a.offset += 4;
                        break;

                      case b.WIRE_TYPES.BITS64:
                        a.offset += 8;
                        break;

                      case b.WIRE_TYPES.LDELIM:
                        h = a.readVarint32(), a.offset += h;
                        break;

                      case b.WIRE_TYPES.STARTGROUP:
                        for (;c(j, a); ) ;
                        break;

                      default:
                        throw Error("Illegal wire type for unknown field " + j + " in " + this.toString(!0) + "#decode: " + i);
                    }
                }
                for (a = 0, d = this._fields.length; d > a; ++a) if (h = this._fields[a], null === g[h.name]) {
                    if (h.required) throw a = Error("Missing at least one required field for " + this.toString(!0) + ": " + h.name), 
                    a.decoded = g, a;
                    null !== h.defaultValue && (g[h.name] = h.defaultValue);
                }
                return g;
            }, e.Message = i, k = function(a, b, c, d, e, g, h, j) {
                f.call(this, a, b, e), this.className = "Message.Field", this.required = "required" === c, 
                this.repeated = "repeated" === c, this.type = d, this.resolvedType = null, this.id = g, 
                this.options = h || {}, this.defaultValue = null, this.oneof = j || null, this.originalName = this.name, 
                !this.builder.options.convertFieldsToCamelCase || this instanceof i.ExtensionField || (this.name = k._toCamelCase(this.name));
            }, k._toCamelCase = function(a) {
                return a.replace(/_([a-zA-Z])/g, function(a, b) {
                    return b.toUpperCase();
                });
            }, j = k.prototype = Object.create(f.prototype), j.build = function() {
                this.defaultValue = "undefined" != typeof this.options["default"] ? this.verifyValue(this.options["default"]) : null;
            }, j.verifyValue = function(c, e) {
                var f, g, j;
                if (e = e || !1, f = function(a, b) {
                    throw Error("Illegal value for " + this.toString(!0) + " of type " + this.type.name + ": " + a + " (" + b + ")");
                }.bind(this), null === c) return this.required && f(typeof c, "required"), null;
                if (this.repeated && !e) {
                    for (b.Util.isArray(c) || (c = [ c ]), f = [], g = 0; g < c.length; g++) f.push(this.verifyValue(c[g], !0));
                    return f;
                }
                switch (!this.repeated && b.Util.isArray(c) && f(typeof c, "no array expected"), 
                this.type) {
                  case b.TYPES.int32:
                  case b.TYPES.sint32:
                  case b.TYPES.sfixed32:
                    return ("number" != typeof c || c === c && 0 !== c % 1) && f(typeof c, "not an integer"), 
                    c > 4294967295 ? 0 | c : c;

                  case b.TYPES.uint32:
                  case b.TYPES.fixed32:
                    return ("number" != typeof c || c === c && 0 !== c % 1) && f(typeof c, "not an integer"), 
                    0 > c ? c >>> 0 : c;

                  case b.TYPES.int64:
                  case b.TYPES.sint64:
                  case b.TYPES.sfixed64:
                    if (b.Long) try {
                        return d(c, !1);
                    } catch (h) {
                        f(typeof c, h.message);
                    } else f(typeof c, "requires Long.js");

                  case b.TYPES.uint64:
                  case b.TYPES.fixed64:
                    if (b.Long) try {
                        return d(c, !0);
                    } catch (i) {
                        f(typeof c, i.message);
                    } else f(typeof c, "requires Long.js");

                  case b.TYPES.bool:
                    return "boolean" != typeof c && f(typeof c, "not a boolean"), c;

                  case b.TYPES["float"]:
                  case b.TYPES["double"]:
                    return "number" != typeof c && f(typeof c, "not a number"), c;

                  case b.TYPES.string:
                    return "string" == typeof c || c && c instanceof String || f(typeof c, "not a string"), 
                    "" + c;

                  case b.TYPES.bytes:
                    return c && c instanceof a ? c : a.wrap(c);

                  case b.TYPES["enum"]:
                    for (j = this.resolvedType.getChildren(l.Value), g = 0; g < j.length; g++) if (j[g].name == c || j[g].id == c) return j[g].id;
                    f(c, "not a valid enum value");

                  case b.TYPES.group:
                  case b.TYPES.message:
                    if (c && "object" == typeof c || f(typeof c, "object expected"), c instanceof this.resolvedType.clazz) return c;
                    if (c instanceof b.Builder.Message) {
                        f = {};
                        for (g in c) c.hasOwnProperty(g) && (f[g] = c[g]);
                        c = f;
                    }
                    return new this.resolvedType.clazz(c);
                }
                throw Error("[INTERNAL] Illegal value for " + this.toString(!0) + ": " + c + " (undefined type " + this.type + ")");
            }, j.encode = function(c, d) {
                var e, f, g, h, i;
                if (null === this.type || "object" != typeof this.type) throw Error("[INTERNAL] Unresolved type in " + this.toString(!0) + ": " + this.type);
                if (null === c || this.repeated && 0 == c.length) return d;
                try {
                    if (this.repeated) if (this.options.packed && 0 <= b.PACKABLE_WIRE_TYPES.indexOf(this.type.wireType)) {
                        for (d.writeVarint32(this.id << 3 | b.WIRE_TYPES.LDELIM), d.ensureCapacity(d.offset += 1), 
                        f = d.offset, e = 0; e < c.length; e++) this.encodeValue(c[e], d);
                        g = d.offset - f, h = a.calculateVarint32(g), h > 1 && (i = d.slice(f, d.offset), 
                        f += h - 1, d.offset = f, d.append(i)), d.writeVarint32(g, f - h);
                    } else for (e = 0; e < c.length; e++) d.writeVarint32(this.id << 3 | this.type.wireType), 
                    this.encodeValue(c[e], d); else d.writeVarint32(this.id << 3 | this.type.wireType), 
                    this.encodeValue(c, d);
                } catch (j) {
                    throw Error("Illegal value for " + this.toString(!0) + ": " + c + " (" + j + ")");
                }
                return d;
            }, j.encodeValue = function(c, d) {
                if (null === c) return d;
                switch (this.type) {
                  case b.TYPES.int32:
                    0 > c ? d.writeVarint64(c) : d.writeVarint32(c);
                    break;

                  case b.TYPES.uint32:
                    d.writeVarint32(c);
                    break;

                  case b.TYPES.sint32:
                    d.writeVarint32ZigZag(c);
                    break;

                  case b.TYPES.fixed32:
                    d.writeUint32(c);
                    break;

                  case b.TYPES.sfixed32:
                    d.writeInt32(c);
                    break;

                  case b.TYPES.int64:
                  case b.TYPES.uint64:
                    d.writeVarint64(c);
                    break;

                  case b.TYPES.sint64:
                    d.writeVarint64ZigZag(c);
                    break;

                  case b.TYPES.fixed64:
                    d.writeUint64(c);
                    break;

                  case b.TYPES.sfixed64:
                    d.writeInt64(c);
                    break;

                  case b.TYPES.bool:
                    "string" == typeof c ? d.writeVarint32("false" === c.toLowerCase() ? 0 : !!c) : d.writeVarint32(c ? 1 : 0);
                    break;

                  case b.TYPES["enum"]:
                    d.writeVarint32(c);
                    break;

                  case b.TYPES["float"]:
                    d.writeFloat32(c);
                    break;

                  case b.TYPES["double"]:
                    d.writeFloat64(c);
                    break;

                  case b.TYPES.string:
                    d.writeVString(c);
                    break;

                  case b.TYPES.bytes:
                    if (0 > c.remaining()) throw Error("Illegal value for " + this.toString(!0) + ": " + c.remaining() + " bytes remaining");
                    var e = c.offset;
                    d.writeVarint32(c.remaining()), d.append(c), c.offset = e;
                    break;

                  case b.TYPES.message:
                    e = new a().LE(), this.resolvedType.encode(c, e), d.writeVarint32(e.offset), d.append(e.flip());
                    break;

                  case b.TYPES.group:
                    this.resolvedType.encode(c, d), d.writeVarint32(this.id << 3 | b.WIRE_TYPES.ENDGROUP);
                    break;

                  default:
                    throw Error("[INTERNAL] Illegal value to encode in " + this.toString(!0) + ": " + c + " (unknown type)");
                }
                return d;
            }, j.calculate = function(c) {
                var d, e, f;
                if (c = this.verifyValue(c), null === this.type || "object" != typeof this.type) throw Error("[INTERNAL] Unresolved type in " + this.toString(!0) + ": " + this.type);
                if (null === c || this.repeated && 0 == c.length) return 0;
                d = 0;
                try {
                    if (this.repeated) if (this.options.packed && 0 <= b.PACKABLE_WIRE_TYPES.indexOf(this.type.wireType)) {
                        for (d += a.calculateVarint32(this.id << 3 | b.WIRE_TYPES.LDELIM), e = f = 0; e < c.length; e++) f += this.calculateValue(c[e]);
                        d += a.calculateVarint32(f), d += f;
                    } else for (e = 0; e < c.length; e++) d += a.calculateVarint32(this.id << 3 | this.type.wireType), 
                    d += this.calculateValue(c[e]); else d += a.calculateVarint32(this.id << 3 | this.type.wireType), 
                    d += this.calculateValue(c);
                } catch (g) {
                    throw Error("Illegal value for " + this.toString(!0) + ": " + c + " (" + g + ")");
                }
                return d;
            }, j.calculateValue = function(c) {
                if (null === c) return 0;
                switch (this.type) {
                  case b.TYPES.int32:
                    return 0 > c ? a.calculateVarint64(c) : a.calculateVarint32(c);

                  case b.TYPES.uint32:
                    return a.calculateVarint32(c);

                  case b.TYPES.sint32:
                    return a.calculateVarint32(a.zigZagEncode32(c));

                  case b.TYPES.fixed32:
                  case b.TYPES.sfixed32:
                  case b.TYPES["float"]:
                    return 4;

                  case b.TYPES.int64:
                  case b.TYPES.uint64:
                    return a.calculateVarint64(c);

                  case b.TYPES.sint64:
                    return a.calculateVarint64(a.zigZagEncode64(c));

                  case b.TYPES.fixed64:
                  case b.TYPES.sfixed64:
                    return 8;

                  case b.TYPES.bool:
                    return 1;

                  case b.TYPES["enum"]:
                    return a.calculateVarint32(c);

                  case b.TYPES["double"]:
                    return 8;

                  case b.TYPES.string:
                    return c = a.calculateUTF8Bytes(c), a.calculateVarint32(c) + c;

                  case b.TYPES.bytes:
                    if (0 > c.remaining()) throw Error("Illegal value for " + this.toString(!0) + ": " + c.remaining() + " bytes remaining");
                    return a.calculateVarint32(c.remaining()) + c.remaining();

                  case b.TYPES.message:
                    return c = this.resolvedType.calculate(c), a.calculateVarint32(c) + c;

                  case b.TYPES.group:
                    return c = this.resolvedType.calculate(c), c + a.calculateVarint32(this.id << 3 | b.WIRE_TYPES.ENDGROUP);
                }
                throw Error("[INTERNAL] Illegal value to encode in " + this.toString(!0) + ": " + c + " (unknown type)");
            }, j.decode = function(a, c, d) {
                if (a != this.type.wireType && (d || a != b.WIRE_TYPES.LDELIM || !this.repeated)) throw Error("Illegal wire type for field " + this.toString(!0) + ": " + a + " (" + this.type.wireType + " expected)");
                if (a == b.WIRE_TYPES.LDELIM && this.repeated && this.options.packed && 0 <= b.PACKABLE_WIRE_TYPES.indexOf(this.type.wireType) && !d) {
                    for (a = c.readVarint32(), a = c.offset + a, d = []; c.offset < a; ) d.push(this.decode(this.type.wireType, c, !0));
                    return d;
                }
                switch (this.type) {
                  case b.TYPES.int32:
                    return 0 | c.readVarint32();

                  case b.TYPES.uint32:
                    return c.readVarint32() >>> 0;

                  case b.TYPES.sint32:
                    return 0 | c.readVarint32ZigZag();

                  case b.TYPES.fixed32:
                    return c.readUint32() >>> 0;

                  case b.TYPES.sfixed32:
                    return 0 | c.readInt32();

                  case b.TYPES.int64:
                    return c.readVarint64();

                  case b.TYPES.uint64:
                    return c.readVarint64().toUnsigned();

                  case b.TYPES.sint64:
                    return c.readVarint64ZigZag();

                  case b.TYPES.fixed64:
                    return c.readUint64();

                  case b.TYPES.sfixed64:
                    return c.readInt64();

                  case b.TYPES.bool:
                    return !!c.readVarint32();

                  case b.TYPES["enum"]:
                    return c.readVarint32();

                  case b.TYPES["float"]:
                    return c.readFloat();

                  case b.TYPES["double"]:
                    return c.readDouble();

                  case b.TYPES.string:
                    return c.readVString();

                  case b.TYPES.bytes:
                    if (a = c.readVarint32(), c.remaining() < a) throw Error("Illegal number of bytes for " + this.toString(!0) + ": " + a + " required but got only " + c.remaining());
                    return d = c.clone(), d.limit = d.offset + a, c.offset += a, d;

                  case b.TYPES.message:
                    return a = c.readVarint32(), this.resolvedType.decode(c, a);

                  case b.TYPES.group:
                    return this.resolvedType.decode(c, -1, this.id);
                }
                throw Error("[INTERNAL] Illegal wire type for " + this.toString(!0) + ": " + a);
            }, e.Message.Field = k, j = function(a, b, c, d, e, f, g) {
                k.call(this, a, b, c, d, e, f, g);
            }, j.prototype = Object.create(k.prototype), e.Message.ExtensionField = j, e.Message.OneOf = function(a, b, c) {
                f.call(this, a, b, c), this.fields = [];
            }, l = function(a, b, c, d) {
                h.call(this, a, b, c, d), this.className = "Enum", this.object = null;
            }, (l.prototype = Object.create(h.prototype)).build = function() {
                for (var a = {}, b = this.getChildren(l.Value), c = 0, d = b.length; d > c; ++c) a[b[c].name] = b[c].id;
                return Object.defineProperty && Object.defineProperty(a, "$options", {
                    value: this.buildOpt()
                }), this.object = a;
            }, e.Enum = l, j = function(a, b, c, d) {
                f.call(this, a, b, c), this.className = "Enum.Value", this.id = d;
            }, j.prototype = Object.create(f.prototype), e.Enum.Value = j, m = function(a, b, c, d) {
                f.call(this, a, b, c), this.field = d;
            }, m.prototype = Object.create(f.prototype), e.Extension = m, j = function(a, b, c, d) {
                h.call(this, a, b, c, d), this.className = "Service", this.clazz = null;
            }, (j.prototype = Object.create(h.prototype)).build = function(a) {
                return this.clazz && !a ? this.clazz : this.clazz = function(a, b) {
                    var e, f, c = function(b) {
                        a.Builder.Service.call(this), this.rpcImpl = b || function(a, b, c) {
                            setTimeout(c.bind(this, Error("Not implemented, see: https://github.com/dcodeIO/ProtoBuf.js/wiki/Services")), 0);
                        };
                    }, d = c.prototype = Object.create(a.Builder.Service.prototype);
                    for (Object.defineProperty && (Object.defineProperty(c, "$options", {
                        value: b.buildOpt()
                    }), Object.defineProperty(d, "$options", {
                        value: c.$options
                    })), e = b.getChildren(a.Reflect.Service.RPCMethod), f = 0; f < e.length; f++) !function(a) {
                        d[a.name] = function(c, d) {
                            try {
                                c && c instanceof a.resolvedRequestType.clazz ? this.rpcImpl(a.fqn(), c, function(c, e) {
                                    if (c) d(c); else {
                                        try {
                                            e = a.resolvedResponseType.clazz.decode(e);
                                        } catch (f) {}
                                        e && e instanceof a.resolvedResponseType.clazz ? d(null, e) : d(Error("Illegal response type received in service method " + b.name + "#" + a.name));
                                    }
                                }) : setTimeout(d.bind(this, Error("Illegal request type provided to service method " + b.name + "#" + a.name)), 0);
                            } catch (e) {
                                setTimeout(d.bind(this, e), 0);
                            }
                        }, c[a.name] = function(b, d, e) {
                            new c(b)[a.name](d, e);
                        }, Object.defineProperty && (Object.defineProperty(c[a.name], "$options", {
                            value: a.buildOpt()
                        }), Object.defineProperty(d[a.name], "$options", {
                            value: c[a.name].$options
                        }));
                    }(e[f]);
                    return c;
                }(b, this);
            }, e.Service = j, n = function(a, b, c, d) {
                f.call(this, a, b, c), this.className = "Service.Method", this.options = d || {};
            }, (n.prototype = Object.create(f.prototype)).buildOpt = g.buildOpt, e.Service.Method = n, 
            g = function(a, b, c, d, e, f) {
                n.call(this, a, b, c, f), this.className = "Service.RPCMethod", this.requestName = d, 
                this.responseName = e, this.resolvedResponseType = this.resolvedRequestType = null;
            }, g.prototype = Object.create(n.prototype), e.Service.RPCMethod = g, e;
        }(b), b.Builder = function(a, b, c) {
            var d = function(a) {
                this.ptr = this.ns = new c.Namespace(this, null, ""), this.resolved = !1, this.result = null, 
                this.files = {}, this.importRoot = null, this.options = a || {};
            }, e = d.prototype;
            return e.reset = function() {
                this.ptr = this.ns;
            }, e.define = function(a, d) {
                if ("string" != typeof a || !b.TYPEREF.test(a)) throw Error("Illegal package: " + a);
                var f, e = a.split(".");
                for (f = 0; f < e.length; f++) if (!b.NAME.test(e[f])) throw Error("Illegal package: " + e[f]);
                for (f = 0; f < e.length; f++) null === this.ptr.getChild(e[f]) && this.ptr.addChild(new c.Namespace(this, this.ptr, e[f], d)), 
                this.ptr = this.ptr.getChild(e[f]);
                return this;
            }, d.isValidMessage = function(c) {
                var e, g, f;
                if ("string" != typeof c.name || !b.NAME.test(c.name) || "undefined" != typeof c.values || "undefined" != typeof c.rpc) return !1;
                if ("undefined" != typeof c.fields) {
                    if (!a.Util.isArray(c.fields)) return !1;
                    for (f = [], e = 0; e < c.fields.length; e++) {
                        if (!d.isValidMessageField(c.fields[e])) return !1;
                        if (g = parseInt(c.fields[e].id, 10), 0 <= f.indexOf(g)) return !1;
                        f.push(g);
                    }
                }
                if ("undefined" != typeof c.enums) {
                    if (!a.Util.isArray(c.enums)) return !1;
                    for (e = 0; e < c.enums.length; e++) if (!d.isValidEnum(c.enums[e])) return !1;
                }
                if ("undefined" != typeof c.messages) {
                    if (!a.Util.isArray(c.messages)) return !1;
                    for (e = 0; e < c.messages.length; e++) if (!d.isValidMessage(c.messages[e]) && !d.isValidExtend(c.messages[e])) return !1;
                }
                return "undefined" == typeof c.extensions || a.Util.isArray(c.extensions) && 2 === c.extensions.length && "number" == typeof c.extensions[0] && "number" == typeof c.extensions[1] ? !0 : !1;
            }, d.isValidMessageField = function(a) {
                if ("string" != typeof a.rule || "string" != typeof a.name || "string" != typeof a.type || "undefined" == typeof a.id || !(b.RULE.test(a.rule) && b.NAME.test(a.name) && b.TYPEREF.test(a.type) && b.ID.test("" + a.id))) return !1;
                if ("undefined" != typeof a.options) {
                    if ("object" != typeof a.options) return !1;
                    for (var e, c = Object.keys(a.options), d = 0; d < c.length; d++) if ("string" != typeof (e = c[d]) || "string" != typeof a.options[e] && "number" != typeof a.options[e] && "boolean" != typeof a.options[e]) return !1;
                }
                return !0;
            }, d.isValidEnum = function(c) {
                if ("string" != typeof c.name || !b.NAME.test(c.name) || "undefined" == typeof c.values || !a.Util.isArray(c.values) || 0 == c.values.length) return !1;
                for (var d = 0; d < c.values.length; d++) if ("object" != typeof c.values[d] || "string" != typeof c.values[d].name || "undefined" == typeof c.values[d].id || !b.NAME.test(c.values[d].name) || !b.NEGID.test("" + c.values[d].id)) return !1;
                return !0;
            }, e.create = function(b) {
                var e, f, g, h, i, j, k, l, m, n;
                if (!b) return this;
                if (a.Util.isArray(b) || (b = [ b ]), 0 == b.length) return this;
                for (e = [], e.push(b); 0 < e.length; ) {
                    if (b = e.pop(), !a.Util.isArray(b)) throw Error("Not a valid namespace: " + JSON.stringify(b));
                    for (;0 < b.length; ) if (f = b.shift(), d.isValidMessage(f)) {
                        if (g = new c.Message(this, this.ptr, f.name, f.options, f.isGroup), h = {}, f.oneofs) for (i = Object.keys(f.oneofs), 
                        j = 0, k = i.length; k > j; ++j) g.addChild(h[i[j]] = new c.Message.OneOf(this, g, i[j]));
                        if (f.fields && 0 < f.fields.length) for (j = 0, k = f.fields.length; k > j; ++j) {
                            if (i = f.fields[j], null !== g.getChild(i.id)) throw Error("Duplicate field id in message " + g.name + ": " + i.id);
                            if (i.options) for (l = Object.keys(i.options), m = 0, n = l.length; n > m; ++m) {
                                if ("string" != typeof l[m]) throw Error("Illegal field option name in message " + g.name + "#" + i.name + ": " + l[m]);
                                if ("string" != typeof i.options[l[m]] && "number" != typeof i.options[l[m]] && "boolean" != typeof i.options[l[m]]) throw Error("Illegal field option value in message " + g.name + "#" + i.name + "#" + l[m] + ": " + i.options[l[m]]);
                            }
                            if (l = null, "string" == typeof i.oneof && (l = h[i.oneof], "undefined" == typeof l)) throw Error("Illegal oneof in message " + g.name + "#" + i.name + ": " + i.oneof);
                            i = new c.Message.Field(this, g, i.rule, i.type, i.name, i.id, i.options, l), l && l.fields.push(i), 
                            g.addChild(i);
                        }
                        if (h = [], "undefined" != typeof f.enums && 0 < f.enums.length) for (j = 0; j < f.enums.length; j++) h.push(f.enums[j]);
                        if (f.messages && 0 < f.messages.length) for (j = 0; j < f.messages.length; j++) h.push(f.messages[j]);
                        f.extensions && (g.extensions = f.extensions, g.extensions[0] < a.ID_MIN && (g.extensions[0] = a.ID_MIN), 
                        g.extensions[1] > a.ID_MAX && (g.extensions[1] = a.ID_MAX)), this.ptr.addChild(g), 
                        0 < h.length && (e.push(b), b = h, this.ptr = g);
                    } else if (d.isValidEnum(f)) {
                        for (g = new c.Enum(this, this.ptr, f.name, f.options), j = 0; j < f.values.length; j++) g.addChild(new c.Enum.Value(this, g, f.values[j].name, f.values[j].id));
                        this.ptr.addChild(g);
                    } else if (d.isValidService(f)) {
                        g = new c.Service(this, this.ptr, f.name, f.options);
                        for (j in f.rpc) f.rpc.hasOwnProperty(j) && g.addChild(new c.Service.RPCMethod(this, g, j, f.rpc[j].request, f.rpc[j].response, f.rpc[j].options));
                        this.ptr.addChild(g);
                    } else {
                        if (!d.isValidExtend(f)) throw Error("Not a valid definition: " + JSON.stringify(f));
                        if (g = this.ptr.resolve(f.ref)) for (j = 0; j < f.fields.length; j++) {
                            if (null !== g.getChild(f.fields[j].id)) throw Error("Duplicate extended field id in message " + g.name + ": " + f.fields[j].id);
                            if (f.fields[j].id < g.extensions[0] || f.fields[j].id > g.extensions[1]) throw Error("Illegal extended field id in message " + g.name + ": " + f.fields[j].id + " (" + g.extensions.join(" to ") + " expected)");
                            h = f.fields[j].name, this.options.convertFieldsToCamelCase && (h = c.Message.Field._toCamelCase(f.fields[j].name)), 
                            i = new c.Message.ExtensionField(this, g, f.fields[j].rule, f.fields[j].type, this.ptr.fqn() + "." + h, f.fields[j].id, f.fields[j].options), 
                            h = new c.Extension(this, this.ptr, f.fields[j].name, i), i.extension = h, this.ptr.addChild(h), 
                            g.addChild(i);
                        } else if (!/\.?google\.protobuf\./.test(f.ref)) throw Error("Extended message " + f.ref + " is not defined");
                    }
                    this.ptr = this.ptr.parent;
                }
                return this.resolved = !1, this.result = null, this;
            }, e["import"] = function(b, c) {
                var d, e, f, g, h, i;
                if ("string" == typeof c) {
                    if (a.Util.IS_NODE && (c = require("path").resolve(c)), !0 === this.files[c]) return this.reset(), 
                    this;
                    this.files[c] = !0;
                }
                if (b.imports && 0 < b.imports.length) {
                    for (e = "/", f = !1, "object" == typeof c ? (this.importRoot = c.root, f = !0, 
                    d = this.importRoot, c = c.file, (0 <= d.indexOf("\\") || 0 <= c.indexOf("\\")) && (e = "\\")) : "string" == typeof c ? this.importRoot ? d = this.importRoot : 0 <= c.indexOf("/") ? (d = c.replace(/\/[^\/]*$/, ""), 
                    "" === d && (d = "/")) : 0 <= c.indexOf("\\") ? (d = c.replace(/\\[^\\]*$/, ""), 
                    e = "\\") : d = "." : d = null, g = 0; g < b.imports.length; g++) if ("string" == typeof b.imports[g]) {
                        if (!d) throw Error("Cannot determine import root: File name is unknown");
                        if (h = b.imports[g], !/^google\/protobuf\//.test(h) && (h = d + e + h, !0 !== this.files[h])) {
                            if (/\.proto$/i.test(h) && !a.DotProto && (h = h.replace(/\.proto$/, ".json")), 
                            i = a.Util.fetch(h), null === i) throw Error("Failed to import '" + h + "' in '" + c + "': File not found");
                            /\.json$/i.test(h) ? this["import"](JSON.parse(i + ""), h) : this["import"](new a.DotProto.Parser(i + "").parse(), h);
                        }
                    } else c ? /\.(\w+)$/.test(c) ? this["import"](b.imports[g], c.replace(/^(.+)\.(\w+)$/, function(a, b, c) {
                        return b + "_import" + g + "." + c;
                    })) : this["import"](b.imports[g], c + "_import" + g) : this["import"](b.imports[g]);
                    f && (this.importRoot = null);
                }
                return b.messages && (b["package"] && this.define(b["package"], b.options), this.create(b.messages), 
                this.reset()), b.enums && (b["package"] && this.define(b["package"], b.options), 
                this.create(b.enums), this.reset()), b.services && (b["package"] && this.define(b["package"], b.options), 
                this.create(b.services), this.reset()), b["extends"] && (b["package"] && this.define(b["package"], b.options), 
                this.create(b["extends"]), this.reset()), this;
            }, d.isValidService = function(a) {
                return !("string" != typeof a.name || !b.NAME.test(a.name) || "object" != typeof a.rpc);
            }, d.isValidExtend = function(c) {
                var e, g, f;
                if ("string" != typeof c.ref || !b.TYPEREF.test(c.ref)) return !1;
                if ("undefined" != typeof c.fields) {
                    if (!a.Util.isArray(c.fields)) return !1;
                    for (f = [], e = 0; e < c.fields.length; e++) {
                        if (!d.isValidMessageField(c.fields[e])) return !1;
                        if (g = parseInt(c.id, 10), 0 <= f.indexOf(g)) return !1;
                        f.push(g);
                    }
                }
                return !0;
            }, e.resolveAll = function() {
                var d, e, f;
                if (null != this.ptr && "object" != typeof this.ptr.type) {
                    if (this.ptr instanceof c.Namespace) for (d = this.ptr.children, e = 0, f = d.length; f > e; ++e) this.ptr = d[e], 
                    this.resolveAll(); else if (this.ptr instanceof c.Message.Field) if (b.TYPE.test(this.ptr.type)) this.ptr.type = a.TYPES[this.ptr.type]; else {
                        if (!b.TYPEREF.test(this.ptr.type)) throw Error("Illegal type reference in " + this.ptr.toString(!0) + ": " + this.ptr.type);
                        if (d = (this.ptr instanceof c.Message.ExtensionField ? this.ptr.extension.parent : this.ptr.parent).resolve(this.ptr.type, !0), 
                        !d) throw Error("Unresolvable type reference in " + this.ptr.toString(!0) + ": " + this.ptr.type);
                        if (this.ptr.resolvedType = d, d instanceof c.Enum) this.ptr.type = a.TYPES["enum"]; else {
                            if (!(d instanceof c.Message)) throw Error("Illegal type reference in " + this.ptr.toString(!0) + ": " + this.ptr.type);
                            this.ptr.type = d.isGroup ? a.TYPES.group : a.TYPES.message;
                        }
                    } else if (!(this.ptr instanceof a.Reflect.Enum.Value)) if (this.ptr instanceof a.Reflect.Service.Method) {
                        if (!(this.ptr instanceof a.Reflect.Service.RPCMethod)) throw Error("Illegal service type in " + this.ptr.toString(!0));
                        if (d = this.ptr.parent.resolve(this.ptr.requestName), !(d && d instanceof a.Reflect.Message)) throw Error("Illegal type reference in " + this.ptr.toString(!0) + ": " + this.ptr.requestName);
                        if (this.ptr.resolvedRequestType = d, d = this.ptr.parent.resolve(this.ptr.responseName), 
                        !(d && d instanceof a.Reflect.Message)) throw Error("Illegal type reference in " + this.ptr.toString(!0) + ": " + this.ptr.responseName);
                        this.ptr.resolvedResponseType = d;
                    } else if (!(this.ptr instanceof a.Reflect.Message.OneOf || this.ptr instanceof a.Reflect.Extension)) throw Error("Illegal object in namespace: " + typeof this.ptr + ":" + this.ptr);
                    this.reset();
                }
            }, e.build = function(a) {
                if (this.reset(), this.resolved || (this.resolveAll(), this.resolved = !0, this.result = null), 
                null == this.result && (this.result = this.ns.build()), a) {
                    a = a.split(".");
                    for (var b = this.result, c = 0; c < a.length; c++) {
                        if (!b[a[c]]) {
                            b = null;
                            break;
                        }
                        b = b[a[c]];
                    }
                    return b;
                }
                return this.result;
            }, e.lookup = function(a) {
                return a ? this.ns.resolve(a) : this.ns;
            }, e.toString = function() {
                return "Builder";
            }, d.Message = function() {}, d.Service = function() {}, d;
        }(b, b.Lang, b.Reflect), b.loadProto = function(a, c, d) {
            return ("string" == typeof c || c && "string" == typeof c.file && "string" == typeof c.root) && (d = c, 
            c = void 0), b.loadJson(new b.DotProto.Parser(a).parse(), c, d);
        }, b.protoFromString = b.loadProto, b.loadProtoFile = function() {
            var a = "cGFja2FnZSBNb2R1bGVzOwptZXNzYWdlIHByb2J1ZiB7CiAgICBtZXNzYWdlIE5vdGlmeU1zZyB7CiAgICAgICAgcmVxdWlyZWQgaW50MzIgdHlwZSA9IDE7CiAgICAgICAgb3B0aW9uYWwgaW50NjQgdGltZSA9IDI7CiAgICB9CiAgICBtZXNzYWdlIFN5bmNSZXF1ZXN0TXNnIHsKICAgICAgICByZXF1aXJlZCBpbnQ2NCBzeW5jVGltZSA9IDE7CiAgICAgICAgcmVxdWlyZWQgYm9vbCBpc3BvbGxpbmcgPSAyOwogICAgICAgIG9wdGlvbmFsIGJvb2wgaXN3ZWI9MzsKICAgICAgICBvcHRpb25hbCBib29sIGlzUHVsbFNlbmQ9NDsKICAgICAgICBvcHRpb25hbCBib29sIGlzS2VlcGluZz01OwogICAgfQogICAgbWVzc2FnZSBVcFN0cmVhbU1lc3NhZ2UgewogICAgICAgIHJlcXVpcmVkIGludDMyIHNlc3Npb25JZCA9IDE7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIGNsYXNzbmFtZSA9IDI7CiAgICAgICAgcmVxdWlyZWQgYnl0ZXMgY29udGVudCA9IDM7CiAgICAgICAgb3B0aW9uYWwgc3RyaW5nIHB1c2hUZXh0ID0gNDsKICAgICAgICBvcHRpb25hbCBzdHJpbmcgYXBwRGF0YSA9IDU7CiAgICB9CiAgICBtZXNzYWdlIERvd25TdHJlYW1NZXNzYWdlcyB7CiAgICAgICAgcmVwZWF0ZWQgRG93blN0cmVhbU1lc3NhZ2UgbGlzdCA9IDE7CiAgICAgICAgcmVxdWlyZWQgaW50NjQgc3luY1RpbWUgPSAyOwogICAgfQogICAgbWVzc2FnZSBEb3duU3RyZWFtTWVzc2FnZSB7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIGZyb21Vc2VySWQgPSAxOwogICAgICAgIHJlcXVpcmVkIENoYW5uZWxUeXBlIHR5cGUgPSAyOwogICAgICAgIG9wdGlvbmFsIHN0cmluZyBncm91cElkID0gMzsKICAgICAgICByZXF1aXJlZCBzdHJpbmcgY2xhc3NuYW1lID0gNDsKICAgICAgICByZXF1aXJlZCBieXRlcyBjb250ZW50ID0gNTsKICAgICAgICByZXF1aXJlZCBpbnQ2NCBkYXRhVGltZSA9IDY7CiAgICAgICAgcmVxdWlyZWQgaW50NjQgc3RhdHVzID0gNzsKICAgICAgICBvcHRpb25hbCBpbnQ2NCBleHRyYSA9IDg7CiAgICAgICAgb3B0aW9uYWwgc3RyaW5nIG1zZ0lkID0gOTsKICAgICAgICBvcHRpb25hbCBpbnQzMiBkaXJlY3Rpb24gPSAxMDsKICAgIH0KICAgIGVudW0gQ2hhbm5lbFR5cGUgewogICAgICAgIFBFUlNPTiA9IDE7CiAgICAgICAgUEVSU09OUyA9IDI7CiAgICAgICAgR1JPVVAgPSAzOwogICAgICAgIFRFTVBHUk9VUCA9IDQ7CiAgICAgICAgQ1VTVE9NRVJTRVJWSUNFID0gNTsKICAgICAgICBOT1RJRlkgPSA2OwogICAgfQogICAgbWVzc2FnZSBDcmVhdGVEaXNjdXNzaW9uSW5wdXQgewogICAgICAgIG9wdGlvbmFsIHN0cmluZyBuYW1lID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgQ3JlYXRlRGlzY3Vzc2lvbk91dHB1dCB7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIGlkID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgQ2hhbm5lbEludml0YXRpb25JbnB1dCB7CiAgICAgICAgcmVwZWF0ZWQgc3RyaW5nIHVzZXJzID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgTGVhdmVDaGFubmVsSW5wdXQgewogICAgICAgIHJlcXVpcmVkIGludDMyIG5vdGhpbmcgPSAxOwogICAgfQogICAgbWVzc2FnZSBDaGFubmVsRXZpY3Rpb25JbnB1dCB7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIHVzZXIgPSAxOwogICAgfQogICAgbWVzc2FnZSBSZW5hbWVDaGFubmVsSW5wdXQgewogICAgICAgIHJlcXVpcmVkIHN0cmluZyBuYW1lID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgQ2hhbm5lbEluZm9JbnB1dCB7CiAgICAgICAgcmVxdWlyZWQgaW50MzIgbm90aGluZyA9IDE7CiAgICB9CiAgICBtZXNzYWdlIENoYW5uZWxJbmZvT3V0cHV0IHsKICAgICAgICByZXF1aXJlZCBDaGFubmVsVHlwZSB0eXBlID0gMTsKICAgICAgICByZXF1aXJlZCBzdHJpbmcgY2hhbm5lbElkID0gMjsKICAgICAgICByZXF1aXJlZCBzdHJpbmcgY2hhbm5lbE5hbWUgPSAzOwogICAgICAgIHJlcXVpcmVkIHN0cmluZyBhZG1pblVzZXJJZCA9IDQ7CiAgICAgICAgcmVwZWF0ZWQgc3RyaW5nIGZpcnN0VGVuVXNlcklkcyA9IDU7CiAgICAgICAgcmVxdWlyZWQgaW50MzIgb3BlblN0YXR1cyA9IDY7CiAgICB9CiAgICBtZXNzYWdlIENoYW5uZWxJbmZvc0lucHV0IHsKICAgICAgICByZXF1aXJlZCBpbnQzMiBwYWdlID0gMTsKICAgICAgICBvcHRpb25hbCBpbnQzMiBudW1iZXIgPSAyOwogICAgfQogICAgbWVzc2FnZSBDaGFubmVsSW5mb3NPdXRwdXQgewogICAgICAgIHJlcGVhdGVkIENoYW5uZWxJbmZvT3V0cHV0IGNoYW5uZWxzID0gMTsKICAgICAgICByZXF1aXJlZCBpbnQzMiB0b3RhbCA9IDI7CiAgICB9CiAgICBtZXNzYWdlIE1lbWJlckluZm8gewogICAgICAgIHJlcXVpcmVkIHN0cmluZyB1c2VySWQgPSAxOwogICAgICAgIHJlcXVpcmVkIHN0cmluZyB1c2VyTmFtZSA9IDI7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIHVzZXJQb3J0cmFpdCA9IDM7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIGV4dGVuc2lvbiA9IDQ7CiAgICB9CiAgICBtZXNzYWdlIEdyb3VwTWVtYmVyc0lucHV0IHsKICAgICAgICByZXF1aXJlZCBpbnQzMiBwYWdlID0gMTsKICAgICAgICBvcHRpb25hbCBpbnQzMiBudW1iZXIgPSAyOwogICAgfQogICAgbWVzc2FnZSBHcm91cE1lbWJlcnNPdXRwdXQgewogICAgICAgIHJlcGVhdGVkIE1lbWJlckluZm8gbWVtYmVycyA9IDE7CiAgICAgICAgcmVxdWlyZWQgaW50MzIgdG90YWwgPSAyOwogICAgfQogICAgbWVzc2FnZSBHZXRVc2VySW5mb0lucHV0IHsKICAgICAgICByZXF1aXJlZCBpbnQzMiBub3RoaW5nID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgR2V0VXNlckluZm9PdXRwdXQgewogICAgICAgIHJlcXVpcmVkIHN0cmluZyB1c2VySWQgPSAxOwogICAgICAgIHJlcXVpcmVkIHN0cmluZyB1c2VyTmFtZSA9IDI7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIHVzZXJQb3J0cmFpdCA9IDM7CiAgICB9CiAgICBtZXNzYWdlIEdldFNlc3Npb25JZElucHV0IHsKICAgICAgICByZXF1aXJlZCBpbnQzMiBub3RoaW5nID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgR2V0U2Vzc2lvbklkT3V0cHV0IHsKICAgICAgICByZXF1aXJlZCBpbnQzMiBzZXNzaW9uSWQgPSAxOwogICAgfQogICAgZW51bSBGaWxlVHlwZSB7CiAgICAgICAgaW1hZ2UgPSAxOwogICAgICAgIGF1ZGlvID0gMjsKICAgICAgICB2aWRlbyA9IDM7CiAgICB9CiAgICBtZXNzYWdlIEdldFFOdXBUb2tlbklucHV0IHsKICAgICAgICByZXF1aXJlZCBGaWxlVHlwZSB0eXBlID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgR2V0UU5kb3dubG9hZFVybElucHV0IHsKICAgICAgICByZXF1aXJlZCBGaWxlVHlwZSB0eXBlID0gMTsKICAgICAgICByZXF1aXJlZCBzdHJpbmcga2V5ID0gMjsKICAgIH0KICAgIG1lc3NhZ2UgR2V0UU51cFRva2VuT3V0cHV0IHsKICAgICAgICByZXF1aXJlZCBpbnQ2NCBkZWFkbGluZSA9IDE7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIHRva2VuID0gMjsKICAgIH0KICAgIG1lc3NhZ2UgR2V0UU5kb3dubG9hZFVybE91dHB1dCB7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIGRvd25sb2FkVXJsID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgQWRkMkJsYWNrTGlzdElucHV0IHsKICAgICAgICByZXF1aXJlZCBzdHJpbmcgdXNlcklkID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgUmVtb3ZlRnJvbUJsYWNrTGlzdElucHV0IHsKICAgICAgICByZXF1aXJlZCBzdHJpbmcgdXNlcklkID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgUXVlcnlCbGFja0xpc3RJbnB1dCB7CiAgICAgICAgcmVxdWlyZWQgaW50MzIgbm90aGluZyA9IDE7CiAgICB9CiAgICBtZXNzYWdlIFF1ZXJ5QmxhY2tMaXN0T3V0cHV0IHsKICAgICAgICByZXBlYXRlZCBzdHJpbmcgdXNlcklkcyA9IDE7CiAgICB9CiAgICBtZXNzYWdlIEJsYWNrTGlzdFN0YXR1c0lucHV0IHsKICAgICAgICByZXF1aXJlZCBzdHJpbmcgdXNlcklkID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgQmxvY2tQdXNoSW5wdXQgewogICAgICAgIHJlcXVpcmVkIHN0cmluZyBibG9ja2VlSWQgPSAxOwogICAgfQogICAgbWVzc2FnZSBNb2RpZnlQZXJtaXNzaW9uSW5wdXQgewogICAgICAgIHJlcXVpcmVkIGludDMyIG9wZW5TdGF0dXMgPSAxOwogICAgfQogICAgbWVzc2FnZSBHcm91cElucHV0IHsKICAgICAgICByZXBlYXRlZCBHcm91cEluZm8gZ3JvdXBJbmZvID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgR3JvdXBPdXRwdXQgewogICAgICAgIHJlcXVpcmVkIGludDMyIG5vdGhpbmcgPSAxOwogICAgfQogICAgbWVzc2FnZSBHcm91cEluZm8gewogICAgICAgIHJlcXVpcmVkIHN0cmluZyBpZCA9IDE7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIG5hbWUgPSAyOwogICAgfQogICAgbWVzc2FnZSBHcm91cEhhc2hJbnB1dCB7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIHVzZXJJZCA9IDE7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIGdyb3VwSGFzaENvZGUgPSAyOwogICAgfQogICAgbWVzc2FnZSBHcm91cEhhc2hPdXRwdXQgewogICAgICAgIHJlcXVpcmVkIEdyb3VwSGFzaFR5cGUgcmVzdWx0ID0gMTsKICAgIH0KICAgIGVudW0gR3JvdXBIYXNoVHlwZSB7CiAgICAgICAgZ3JvdXBfc3VjY2VzcyA9IDB4MDA7CiAgICAgICAgZ3JvdXBfZmFpbHVyZSA9IDB4MDE7CiAgICB9CiAgICBtZXNzYWdlIENocm1JbnB1dCB7CiAgICAgICAgcmVxdWlyZWQgaW50MzIgbm90aGluZyA9IDE7CiAgICB9CiAgICBtZXNzYWdlIENocm1PdXRwdXQgewogICAgICAgIHJlcXVpcmVkIGludDMyIG5vdGhpbmcgPSAxOwogICAgfQogICAgbWVzc2FnZSBDaHJtUHVsbE1zZyB7CiAgICAgICAgcmVxdWlyZWQgaW50NjQgc3luY1RpbWUgPSAxOwogICAgICAgIHJlcXVpcmVkIGludDMyIGNvdW50ID0gMjsKICAgIH0KICAgIG1lc3NhZ2UgUmVsYXRpb25zSW5wdXQKICAgIHsKICAgICAgICByZXF1aXJlZCBDaGFubmVsVHlwZSB0eXBlID0gMTsKICAgICAgICBvcHRpb25hbCBEb3duU3RyZWFtTWVzc2FnZSBtc2cgPTI7CiAgICB9CiAgICBtZXNzYWdlIFJlbGF0aW9uc091dHB1dAogICAgewogICAgICAgIHJlcGVhdGVkIFJlbGF0aW9uSW5mbyBpbmZvID0gMTsKICAgIH0KICAgIG1lc3NhZ2UgUmVsYXRpb25JbmZvCiAgICB7CiAgICAgICAgcmVxdWlyZWQgQ2hhbm5lbFR5cGUgdHlwZSA9IDE7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIHVzZXJJZCA9IDI7CiAgICAgICAgb3B0aW9uYWwgRG93blN0cmVhbU1lc3NhZ2UgbXNnID0zOwogICAgfQogICAgbWVzc2FnZSBIaXN0b3J5TWVzc2FnZUlucHV0CiAgICB7CiAgICAgICAgcmVxdWlyZWQgc3RyaW5nIHRhcmdldElkID0gMTsKICAgICAgICByZXF1aXJlZCBpbnQ2NCBkYXRhVGltZSA9MjsKICAgICAgICByZXF1aXJlZCBpbnQzMiBzaXplICA9IDM7CiAgICB9CgogICAgbWVzc2FnZSBIaXN0b3J5TWVzc2FnZXNPdXB1dAogICAgewogICAgICAgIHJlcGVhdGVkIERvd25TdHJlYW1NZXNzYWdlIGxpc3QgPSAxOwogICAgICAgIHJlcXVpcmVkIGludDY0IHN5bmNUaW1lID0gMjsKICAgICAgICByZXF1aXJlZCBpbnQzMiBoYXNNc2cgPSAzOwogICAgfQp9";
            return b.loadProto(this.ByteBuffer.atob(a), void 0, "");
        }, b.protoFromFile = b.loadProtoFile, b.newBuilder = function(a) {
            return a = a || {}, "undefined" == typeof a.convertFieldsToCamelCase && (a.convertFieldsToCamelCase = b.convertFieldsToCamelCase), 
            "undefined" == typeof a.populateAccessors && (a.populateAccessors = b.populateAccessors), 
            new b.Builder(a);
        }, b.loadJson = function(a, c, d) {
            return ("string" == typeof c || c && "string" == typeof c.file && "string" == typeof c.root) && (d = c, 
            c = null), c && "object" == typeof c || (c = b.newBuilder()), "string" == typeof a && (a = JSON.parse(a)), 
            c["import"](a, d), c.resolveAll(), c.build(), c;
        }, b.loadJsonFile = function(a, c, d) {
            if (c && "object" == typeof c ? (d = c, c = null) : c && "function" == typeof c || (c = null), 
            c) return b.Util.fetch("string" == typeof a ? a : a.root + "/" + a.file, function(e) {
                if (null === e) c(Error("Failed to fetch file")); else try {
                    c(null, b.loadJson(JSON.parse(e), d, a));
                } catch (f) {
                    c(f);
                }
            });
            var e = b.Util.fetch("object" == typeof a ? a.root + "/" + a.file : a);
            return null === e ? null : b.loadJson(JSON.parse(e), d, a);
        }, b;
    }
    "function" == typeof require && "object" == typeof module && module && module.id && "object" == typeof exports && exports ? module.exports = b(require("ByteBuffer")) : "function" == typeof define && define.amd ? define("ProtoBuf", [ "ByteBuffer" ], function(a) {
        return b(a);
    }) : (a.dcodeIO = a.dcodeIO || {}).ProtoBuf = b(a.dcodeIO.ByteBuffer);
}(this), function(a) {
    a.dcodeIO && a.RongIMClient ? (a.Modules = a.dcodeIO.ProtoBuf.loadProtoFile().build("Modules").probuf, 
    RongIMClient.connect.token && RongIMClient.getInstance().connect(RongIMClient.connect.token, RongIMClient.connect.callback)) : (require([ "ProtoBuf" ], function(b) {
        a.Modules = b.loadProtoFile().build("Modules").probuf;
    }), require([ "RongIMLib" ], function(a) {
        a.connect.token && a.getInstance().connect(a.connect.token, a.connect.callback);
    }));
}(this);