//
//  StringAndURLTests.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-06-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
import Testing
@testable import SwiftExtras

@Test func stringCleaningTrimmingAndSlugification() {
    #expect("  Héllo Wörld  ".clean() == "  Hello World  ")
    #expect(" \n value \t".trimmed() == "value")
    #expect("  Hello Swift World  ".slugified == "hello-swift-world")
}

@Test func base64RoundTripsUnicodeText() {
    let original = "Swift Extras: café"
    let encoded = original.base64Encoded()

    #expect(encoded?.base64Decoded() == original)
    #expect("U3dpZnQgRXh0cmFz".base64UrlDecode() == "Swift Extras")
    #expect("not valid base64".base64Decoded() == nil)
}

@Test func stringSliceFindsContentBetweenMarkers() {
    let value = "prefix[start]content[end]suffix"

    #expect(value.slice(from: "[start]", to: "[end]") == "content")
    #expect(value.slice(from: "[missing]", to: "[end]") == nil)
    #expect(value.slice(from: "[start]", to: "[missing]") == nil)
}

@Test func stringContainsSupportsCaseSensitivity() {
    #expect("SwiftExtras".contains("Extras", caseSensitive: true))
    #expect(!"SwiftExtras".contains("extras", caseSensitive: true))
    #expect("SwiftExtras".contains("extras", caseSensitive: false))
}

@Test func regularExpressionOperatorsMatchAndReject() {
    #expect("release-42" =~ #"^release-\d+$"#)
    #expect("release-x" !~ #"^release-\d+$"#)
}

@Test func safeURLAddsSchemeAndValidatesWebURLs() throws {
    let inferred = try #require(URL(safeString: "example.com/path"))
    let explicit = try #require(URL(safeString: "http://example.com"))
    let file = URL(fileURLWithPath: "/tmp/example")

    #expect(inferred.scheme == "https")
    #expect(inferred.host() == "example.com")
    #expect(inferred.isWebURL)
    #expect(explicit.scheme == "http")
    #expect(explicit.isValid)
    #expect(!file.isWebURL)
}
