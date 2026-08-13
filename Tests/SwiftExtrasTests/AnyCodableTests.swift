//
//  AnyCodableTests.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
import Testing
@testable import SwiftExtras

@Test(arguments: ["null", "true", "42", "3.5", #""SwiftExtras""#])
func anyCodableRoundTripsScalarJSON(_ json: String) throws {
    let data = Data(json.utf8)
    let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)
    let encoded = try JSONEncoder().encode(decoded)

    #expect(try jsonValue(from: encoded) == jsonValue(from: data))
}

@Test func anyCodableRoundTripsNestedCollections() throws {
    let data = Data(
        #"{"name":"SwiftExtras","values":[1,true,null],"metadata":{"stable":true}}"#.utf8
    )
    let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)
    let encoded = try JSONEncoder().encode(decoded)

    #expect(try jsonValue(from: encoded) == jsonValue(from: data))
}

@Test func anyCodablePreservesWrappedInstancesAndReflection() {
    let original = AnyCodable("SwiftExtras")
    let wrappedAgain = AnyCodable(original)

    #expect(wrappedAgain.value as? String == "SwiftExtras")
    #expect(wrappedAgain.customMirror.children.first?.value as? String == "SwiftExtras")
}

@Test func anyCodableRejectsValuesThatAreNotEncodable() {
    #expect(throws: EncodingError.self) {
        try JSONEncoder().encode(AnyCodable(NonEncodableValue(number: 42)))
    }
}

private struct NonEncodableValue: Sendable {
    let number: Int
}

private func jsonValue(from data: Data) throws -> NSObject {
    let value = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
    return try #require(value as? NSObject)
}
