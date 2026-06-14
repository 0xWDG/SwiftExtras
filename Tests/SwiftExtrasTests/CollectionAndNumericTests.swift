import Foundation
import Testing
@testable import SwiftExtras

@Test func safeCollectionSubscriptAndConvenienceAccessors() {
    let empty: [Int] = []
    let single = [1]
    let values = [1, 2, 3, 4]

    #expect(values[safe: 0] == 1)
    #expect(values[safe: 3] == 4)
    #expect(values[safe: 4] == nil)
    #expect(empty.second == nil)
    #expect(empty.third == nil)
    #expect(empty.penultimate == nil)
    #expect(single.second == nil)
    #expect(single.penultimate == nil)
    #expect(values.second == 2)
    #expect(values.third == 3)
    #expect(values.penultimate == 3)
}

@Test func sequenceSumAndCollectionAverage() {
    let values = [2, 4, 9]
    let integerAverage: Int = values.average()
    let floatingAverage: Double = values.average()

    #expect(values.sum() == 15)
    #expect([Int]().sum() == 0)
    #expect(integerAverage == 5)
    #expect(floatingAverage == 5)
}

@Test func optionalCollectionsReportNilOrEmpty() {
    let missing: [Int]? = nil
    let empty: [Int]? = []
    let populated: [Int]? = [1]

    #expect(missing.isNilOrEmpty)
    #expect(empty.isNilOrEmpty)
    #expect(!populated.isNilOrEmpty)
}

@Test func floatingPointCleanFormatting() {
    #expect((3.0 as Double).clean == "3")
    #expect((3.25 as Double).clean == "3.25")
    #expect((4.0 as Float).clean == "4")
}

@Test func lengthConversionUsesFoundationMeasurements() {
    #expect(abs(1.0.convert(.kilometers, to: .meters) - 1_000) < 0.0001)
    #expect(abs(12.0.convert(.inches, to: .feet) - 1) < 0.0001)
}

@Test func timeIntervalComponentsAndFormatting() {
    let interval: TimeInterval = 90_061.125
    let negative: TimeInterval = -3_661

    #expect(interval.days == 1)
    #expect(interval.hours == 25)
    #expect(interval.minutes == 1)
    #expect(interval.seconds == 1)
    #expect(interval.milliseconds == 125)
    #expect(interval.stringValue == "25:01:01")
    #expect(negative.absoluteHours == 1)
    #expect(negative.absoluteMinutes == 1)
    #expect(negative.absoluteSeconds == 1)
    #expect(TimeInterval.zero.stringValue == "unknown")
    #expect(TimeInterval.infinity.stringValue == "unknown")
}
