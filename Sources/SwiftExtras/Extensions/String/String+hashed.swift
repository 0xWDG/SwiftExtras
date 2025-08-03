//
//  String+hashed.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-04-19.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension String {
    /// Hashed string
    ///
    /// - Returns: Encoded string
    var hashed: UInt64 {
        var result = UInt64(5381)
        let buf = [UInt8](utf8)
        for item in buf {
            result = 127 * (result & 0x00FF_FFFF_FFFF_FFFF) + UInt64(item)
        }
        return result
    }

    // http://www.cse.yorku.ca/~oz/hash.html
    /// Hashed string
    ///
    /// this algorithm (k=33) was first reported by dan bernstein many years ago in comp.lang.c.
    /// another version of this algorithm (now favored by bernstein) uses xor: hash(i) = hash(i - 1) * 33 ^ str[i];
    /// the magic of number 33 (why it works better than many other constants, prime or not)
    /// has never been adequately explained.
    var djb2hash: Int {
        let unicodeScalars = unicodeScalars.map(\.value)
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }

    /// Hashed string
    ///
    /// this algorithm was created for sdbm (a public-domain reimplementation of ndbm) database library.
    /// it was found to do well in scrambling bits, causing better distribution of the keys and fewer splits.
    /// it also happens to be a good general hashing function with good distribution.
    /// the actual function is hash(i) = hash(i - 1) * 65599 + str[i];
    /// what is included below is the faster version used in gawk.
    /// [there is even a faster, duff-device version] the magic prime constant 65599 (2^6 + 2^16 - 1)
    /// was picked out of thin air while experimenting with many different constants.
    /// this is one of the algorithms used in berkeley db (see sleepycat) and elsewhere.
    var sdbmhash: Int {
        let unicodeScalars = unicodeScalars.map(\.value)
        return unicodeScalars.reduce(0) {
            (Int($1) &+ ($0 << 6) &+ ($0 << 16)).addingReportingOverflow(-$0).partialValue
        }
    }
}
