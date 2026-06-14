import Testing
@testable import SwiftExtras

@Test func acknowledgementIdentityAndHashingUseStoredValues() {
    let first = SEAcknowledgement(
        name: "SwiftExtras",
        copyright: "Wesley",
        licence: "MIT"
    )
    let duplicate = first
    let changedLicence = SEAcknowledgement(
        name: "SwiftExtras",
        copyright: "Wesley",
        licence: "Apache-2.0"
    )

    #expect(first.id == "SwiftExtras")
    #expect(first == duplicate)
    #expect(first != changedLicence)
    #expect(Set([first, duplicate, changedLicence]).count == 2)
}

@Test func changeLogIdentityUsesVersion() {
    let entry = SEChangeLogEntry(version: "1.2.3", date: "2026-06-14", text: "Changes")

    #expect(entry.id == "1.2.3")
    #expect(entry.version == "1.2.3")
    #expect(entry.date == "2026-06-14")
}
