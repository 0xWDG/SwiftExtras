//
//  DynamicTests.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-05.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(ObjectiveC)
import Foundation
import Testing
@testable import SwiftExtras

private final class DynamicTestObject: NSObject {
    @objc dynamic var title: NSString = "Original"

    @objc
    func greeting() -> NSString {
        "Hello"
    }

    @objc
    func greeting(_ name: NSString) -> NSString {
        "Hello, \(name)" as NSString
    }
}

@Suite("Dynamic")
struct DynamicTests {
    @Test
    func readsAndWritesKeyValueCodingProperties() {
        let object = DynamicTestObject()
        let dynamic = Dynamic(object)

        #expect(dynamic["title"].as(NSString.self) == "Original")

        dynamic["title"] = Dynamic("Updated" as NSString)

        #expect(object.title == "Updated")
        #expect(dynamic.title.as(NSString.self) == "Updated")
    }

    @Test
    func callsSelectorsWithAndWithoutArguments() {
        let object = DynamicTestObject()
        let dynamic = Dynamic(object)

        #expect(dynamic.greeting().as(NSString.self) == "Hello")
        #expect(dynamic.greeting("Wesley" as NSString).as(NSString.self) == "Hello, Wesley")
    }

    @Test
    func wrapsClassesByName() {
        let dynamicClass = Dynamic(classNamed: "NSObject")

        #expect(dynamicClass.object != nil)
    }
}
#endif
