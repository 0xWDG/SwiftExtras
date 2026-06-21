//
//  SwiftExtrasTests.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(Testing)
import Testing
@testable import SwiftExtras

#if canImport(SwiftUI)
import SwiftUI

@Test func malformedColorPayloadThrows() {
    let malformed = Data(#""1;0;0""#.utf8)
    #expect(throws: DecodingError.self) {
        try JSONDecoder().decode(Color.self, from: malformed)
    }
}

@Test func legacyColorPayloadIsNormalized() throws {
    let legacy = Data(#""255;128;0;255""#.utf8)
    let color = try JSONDecoder().decode(Color.self, from: legacy)
    let components = color.components

    #expect(abs(components.red - 1) < 0.001)
    #expect(abs(components.green - (128.0 / 255.0)) < 0.001)
    #expect(abs(components.blue) < 0.001)
    #expect(abs(components.opacity - 1) < 0.001)
}

@Test func normalizedColorPayloadRoundTrips() throws {
    let original = Color(red: 0.25, green: 0.5, blue: 0.75, alpha: 0.8)
    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(Color.self, from: data)

    #expect(approximatelyEqual(decoded.components.red, 0.25))
    #expect(approximatelyEqual(decoded.components.green, 0.5))
    #expect(approximatelyEqual(decoded.components.blue, 0.75))
    #expect(approximatelyEqual(decoded.components.opacity, 0.8))
}

@Test func kMeansSingleClusterAveragesAllChannels() {
    let result = kMeansCluster(
        colors: [.init(red: 1, green: 0, blue: 0), .init(red: 0, green: 0, blue: 1)],
        clusters: 1,
        iterations: 1
    )

    let components = result[0].components
    #expect(abs(components.red - 0.5) < 0.001)
    #expect(abs(components.green) < 0.001)
    #expect(abs(components.blue - 0.5) < 0.001)
}

@Test func kMeansHandlesInvalidAndLargeClusterCounts() {
    #expect(kMeansCluster(colors: [], clusters: 2).isEmpty)
    #expect(kMeansCluster(colors: [.red], clusters: 0).isEmpty)
    #expect(kMeansCluster(colors: [.red, .blue], clusters: 4, iterations: 0).count == 4)
}

@Test func customErrorEqualityUsesStoredValues() {
    let first = CustomError(message: "Network failed", errorCode: 2, domain: "SwiftExtras.Tests")
    let duplicate = CustomError(message: "Network failed", errorCode: 2, domain: "SwiftExtras.Tests")
    let changedMessage = CustomError(message: "Request timed out", errorCode: 2, domain: "SwiftExtras.Tests")
    let changedCode = CustomError(message: "Network failed", errorCode: 3, domain: "SwiftExtras.Tests")
    let changedDomain = CustomError(message: "Network failed", errorCode: 2, domain: "SwiftExtras.Other")

    #expect(first == duplicate)
    #expect(first != changedMessage)
    #expect(first != changedCode)
    #expect(first != changedDomain)
}

@Test func customErrorProvidesNSErrorAndLocalizedMetadata() {
    let error = CustomError(message: "Network failed", errorCode: 42, domain: "SwiftExtras.Tests")
    let nsError = error as NSError

    #expect(error.errorDomain == "SwiftExtras.Tests")
    #expect(error.errorCode == 42)
    #expect(error.errorDescription == "Network failed")
    #expect(error.errorUserInfo[NSLocalizedDescriptionKey] as? String == "Network failed")
    #expect(nsError.code == 42)
    #expect(nsError.userInfo[NSLocalizedDescriptionKey] as? String == "Network failed")
}

@Test func localizedStringKeyStringValueFallsBackToKey() {
    let key: LocalizedStringKey = "SwiftExtras.Test.Key"

    #expect(key.stringValue == "SwiftExtras.Test.Key")
}

@Test func colorHexAndLuminanceUseNormalizedComponents() {
    let color = Color(red: 1, green: 0.5, blue: 0, opacity: 0.25)
    let components = color.components

    #expect(abs(components.red - 1) < 0.001)
    #expect(abs(components.green - 0.5) < 0.001)
    #expect(abs(components.blue) < 0.001)
    #expect(abs(components.opacity - 0.25) < 0.001)
    #expect(color.hex == "#ff7f00")
    #expect(color.hex8 == "#ff7f003f")
    #expect(color.hex6 == "#ff7f00")
    #expect(Color.black.luminance == 0)
    #expect(abs(Color.white.luminance - 1) < 0.001)
}

private func approximatelyEqual(_ lhs: CGFloat, _ rhs: CGFloat) -> Bool {
    abs(lhs - rhs) < 0.001
}
#endif
#endif
