//
//  DynamicJSONTests.swift
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

@Test func dynamicJSONParsesAndNavigatesNestedValues() throws {
    let data = Data(
        #"{"user":{"name":"Wesley"},"values":[1,true,null]}"#.utf8
    )
    let json = try JSON(data: data)

    #expect(json.user?.name?.string == "Wesley")
    #expect(json.values?[0]?.int == 1)
    #expect(json.values?[1]?.bool == true)
    #expect(json.values?[2]?.string == nil)
    #expect(json.values?[-1] == nil)
    #expect(json.values?[3] == nil)
    #expect(json.missing == nil)
}

@Test func dynamicJSONConvertsScalarRepresentations() {
    #expect(JSON.string("42.5").double == 42.5)
    #expect(JSON.string("YES").bool == true)
    #expect(JSON.string("no").bool == false)
    #expect(JSON.string("maybe").bool == nil)
    #expect(JSON.bool(true).string == "true")
    #expect(JSON.number(7).string == "7")
    #expect(JSON.null.number == nil)
}

@Test func dynamicJSONInitializesUnsupportedValuesAsNull() {
    let json = JSON(Date(timeIntervalSince1970: 0))

    guard case .null = json else {
        Issue.record("Unsupported values should become JSON null")
        return
    }
}

@Test func dynamicJSONSerializesObjectsAndTopLevelFragments() throws {
    let object = JSON([
        "name": "SwiftExtras",
        "enabled": true,
        "values": [1, 2, 3]
    ])
    let decodedObject = try JSON(data: object.data())
    let decodedFragment = try JSON(data: JSON.string("value").data(), options: .fragmentsAllowed)

    #expect(decodedObject.name?.string == "SwiftExtras")
    #expect(decodedObject.enabled?.bool == true)
    #expect(decodedObject.values?[2]?.int == 3)
    #expect(decodedFragment.string == "value")
}

@Test func dynamicJSONThrowsForMalformedDataAndDataInitializerFallsBackToNull() throws {
    let malformed = Data("not-json".utf8)

    #expect(throws: (any Error).self) {
        try JSON(data: malformed)
    }

    guard case .null = JSON(malformed) else {
        Issue.record("Malformed Data should become JSON null")
        return
    }
}
