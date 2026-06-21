//
//  FoundationExtensionTests.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-06-20.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
import Testing
@testable import SwiftExtras

@Test func dataHexStringAndStringValueExposeByteRepresentations() {
    let bytes = Data([0x00, 0x0f, 0xa5, 0xff])
    let text = Data("SwiftExtras".utf8)
    let invalidUTF8 = Data([0xff, 0xfe])

    #expect(bytes.hexString == "000fa5ff")
    #expect(text.stringValue == "SwiftExtras")
    #expect(invalidUTF8.stringValue == nil)
}

#if canImport(Compression)
@Test func dataDeflateAndInflateRoundTripTextPayloads() throws {
    let payload = Data(String(repeating: "SwiftExtras compression ", count: 20).utf8)
    let compressed = try #require(payload.deflate())
    let inflated = try #require(compressed.inflate())

    #expect(inflated == payload)
    #expect(Data("not compressed".utf8).inflate() == nil)
}
#endif

@Test func userDefaultsSubscriptsReadWriteAndRemoveValues() throws {
    let suiteName = "SwiftExtrasTests.UserDefaults.\(UUID().uuidString)"
    let defaults = try #require(UserDefaults(suiteName: suiteName))
    defer {
        defaults.removePersistentDomain(forName: suiteName)
    }

    defaults["name"] = "SwiftExtras"
    defaults["enabled"] = true

    let storedName: Any? = defaults["name"]
    let storedFlag: Bool = defaults["enabled"]

    #expect(storedName as? String == "SwiftExtras")
    #expect(storedFlag)

    defaults.removeAll()

    let removedName: Any? = defaults["name"]
    let removedFlag: Bool = defaults["enabled"]

    #expect(removedName == nil)
    #expect(!removedFlag)
}

@Test func errorCodeReturnsNSErrorCode() {
    let error: Error = NSError(domain: "SwiftExtrasTests", code: 404)

    #expect(error.errorCode == 404)
}
