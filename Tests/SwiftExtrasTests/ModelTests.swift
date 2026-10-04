//
//  ModelTests.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-06-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

@testable import SwiftExtras
import Testing

@Test func acknowledgementIdentityAndHashingUseStoredValues() {
    let first = Acknowledgement(
        name: "SwiftExtras",
        copyright: "Wesley",
        licence: "MIT"
    )
    let duplicate = first
    let changedLicence = Acknowledgement(
        name: "SwiftExtras",
        copyright: "Wesley",
        licence: "Apache-2.0"
    )

    #expect(first.id == "SwiftExtras")
    #expect(first == duplicate)
    #expect(first != changedLicence)
    #expect(Set([first, duplicate, changedLicence]).count == 2)

    let linked = Acknowledgement(
        name: "ExampleKit",
        copyright: "Example",
        licence: "MIT",
        url: "https://example.com"
    )
    #expect(linked.url == "https://example.com")
}

@Test func changeLogIdentityUsesVersion() {
    let entry = ChangeLogEntry(version: "1.2.3", date: "2026-06-14", text: "Changes")

    #expect(entry.id == "1.2.3")
    #expect(entry.version == "1.2.3")
    #expect(entry.date == "2026-06-14")
    #expect(entry.text == "Changes")

    let undated = ChangeLogEntry(version: "1.2.4", text: "Fixed tests")
    #expect(undated.id == "1.2.4")
    #expect(undated.date == nil)
    #expect(undated.text == "Fixed tests")
}
