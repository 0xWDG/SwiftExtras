//
//  UtilityExtensionTests.swift
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

@Test func dictionaryRawRepresentationRoundTripsAndRejectsInvalidJSON() throws {
    let original = ["language": "Swift", "package": "SwiftExtras"]
    let decoded = try #require([String: String](rawValue: original.rawValue))

    #expect(decoded == original)
    #expect([String: String](rawValue: "not-json") == nil)
    #expect([String: String](rawValue: #"{"value":1}"#) == nil)
}

@Test func fuzzyMatchingRequiresOrderedCharactersAndIgnoresCase() {
    #expect("Rijksmuseum".fuzzyMatches("rjks"))
    #expect("SwiftExtras".fuzzyMatches("SET"))
    #expect("SwiftExtras".fuzzyMatches(""))
    #expect(!"SwiftExtras".fuzzyMatches("ExtraSwift"))
    #expect(!"".fuzzyMatches("S"))
}

@Test func htmlDetectionDistinguishesMarkupFromPlainComparisons() {
    #expect("<p>Hello</p>".containsHTML)
    #expect(#"<a href="https://example.com">Link</a>"#.containsHTML)
    #expect(!"SwiftExtras".containsHTML)
}

@Test func ansiColorOperatorsPlaceEscapeSequencesAroundText() {
    #expect(ANSIColors.red + "Error" == "\u{001B}[0;31mError")
    #expect("Done" + ANSIColors.default == "Done\u{001B}[0;0m")
}

@Test func identifiersRemainStableForTheSameValue() {
    let string = "SwiftExtras"
    let date = Date(timeIntervalSince1970: 1_700_000_000)

    #expect(string.id == string.hash)
    #expect(date.id == date.description.hashValue)
}

@Test func localeUtilitiesReflectCurrentFoundationSettings() {
    #expect(Locale.userCountry == (Locale.current.region?.identifier ?? "Unknown"))
    #expect(Locale.userLanguage == (Locale.current.language.languageCode?.identifier ?? "Unknown"))
    #expect(Locale.userCurrencyCode == (Locale.current.currency?.identifier ?? "Unknown"))
    #expect(Locale.userCurrencySymbol == (Locale.current.currencySymbol ?? "Unknown"))
    #expect(Locale.deviceMeasurementSystem == Locale.current.measurementSystem)
    #expect(Locale.userTimeZone == TimeZone.current.identifier)
    #expect(Locale.userCalendar == String(describing: Locale.current.calendar.identifier))
    #expect(Locale.collationIdentifier == Locale.current.collation.identifier)
}

@Test func processInfoUtilitiesReportHostCapabilities() {
    #expect(ProcessInfo.isUnitTesting)
    #expect(ProcessInfo.isLowPowerModeActive == false)
    #expect(ProcessInfo.isRunningiOSAppOnMac == false)
}

@Test func deviceMetadataMatchesProcessInfo() {
    #expect(!Device.model.isEmpty)
    #expect(Device.osVersion == ProcessInfo.processInfo.operatingSystemVersionString)
    #expect(!AppInfo.appName.isEmpty)
    #expect(!AppInfo.versionNumber.isEmpty)
    #expect(!AppInfo.buildNumber.isEmpty)
    #expect(!AppInfo.bundleIdentifier.isEmpty)
}

@Test func platformSpacingConstantsMatchTheCurrentPlatform() {
#if os(tvOS)
    #expect(CGFloat.defaultSpacing == 30)
    #expect(CGFloat.defaultTextHeight == 45.5)
#elseif os(macOS)
    #expect(CGFloat.defaultSpacing == 8)
    #expect(CGFloat.defaultTextHeight == 18)
#elseif os(watchOS)
    #expect(CGFloat.defaultSpacing == 8)
    #expect(CGFloat.defaultTextHeight == 20.5)
#else
    #expect(CGFloat.defaultSpacing == 16)
    #expect(CGFloat.defaultTextHeight == 20.5)
#endif
}

@Test func currencyFormattingMatchesFoundationForRequestedDigits() {
    let formatter = NumberFormatter()
    formatter.locale = .current
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 2

    #expect(42.toCurrency(digits: 2) == formatter.string(from: 42 as NSNumber))
}
