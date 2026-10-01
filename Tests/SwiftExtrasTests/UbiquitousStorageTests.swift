//
//  UbiquitousStorageTests.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-10-01.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import Foundation
@testable import SwiftExtras
import Testing

private enum SharedLayout: String {
    case compact
    case detail
}

@Test func appGroupBackendSharesValuesBetweenStorageInstances() throws {
    let suiteName = "SwiftExtrasTests.UbiquitousStorage.\(UUID().uuidString)"
    let defaults = try #require(UserDefaults(suiteName: suiteName))
    defer {
        defaults.removePersistentDomain(forName: suiteName)
    }

    var appStorage = UbiquitousStorage<Bool>(
        wrappedValue: false,
        "showsCalendar",
        backend: .appGroup(suiteName)
    )
    let widgetStorage = UbiquitousStorage<Bool>(
        wrappedValue: false,
        "showsCalendar",
        backend: .appGroup(suiteName)
    )

    appStorage.wrappedValue = true

    #expect(widgetStorage.wrappedValue)
}

@Test func appGroupBackendRoundTripsStringRawRepresentableValues() throws {
    let suiteName = "SwiftExtrasTests.UbiquitousStorage.\(UUID().uuidString)"
    let defaults = try #require(UserDefaults(suiteName: suiteName))
    defer {
        defaults.removePersistentDomain(forName: suiteName)
    }

    var appStorage = UbiquitousStorage<SharedLayout>(
        wrappedValue: .compact,
        "layout",
        backend: .appGroup(suiteName)
    )
    let widgetStorage = UbiquitousStorage<SharedLayout>(
        wrappedValue: .compact,
        "layout",
        backend: .appGroup(suiteName)
    )

    appStorage.wrappedValue = .detail

    #expect(widgetStorage.wrappedValue == .detail)
}
#endif
