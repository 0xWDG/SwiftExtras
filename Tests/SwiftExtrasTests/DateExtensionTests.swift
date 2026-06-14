//
//  DateExtensionTests.swift
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

@Test func dateComponentsAndBoundaries() {
    let date = Date(year: 2024, month: 2, day: 15, hour: 12, minute: 34, second: 56)

    #expect(date.year == 2024)
    #expect(date.month == 2)
    #expect(date.day == 15)
    #expect(date.startOfYear.year == 2024)
    #expect(date.startOfYear.month == 1)
    #expect(date.startOfYear.day == 1)
    #expect(date.endOfYear.month == 12)
    #expect(date.endOfYear.day == 31)
    #expect(date.startOfMonth.day == 1)
    #expect(date.endOfMonth.day == 29)
    #expect(date.numberOfDaysInMonth == 29)
    #expect(date.startOfPreviousMonth.month == 1)
}

@Test func calendarGridContainsSixConsecutiveWeeks() {
    let grid = Date(year: 2024, month: 2, day: 15).calendarGrid

    #expect(grid.count == 42)
    for pair in zip(grid, grid.dropFirst()) {
        #expect(Calendar.current.dateComponents([.day], from: pair.0, to: pair.1).day == 1)
    }
}

@Test func dateRangeChecksIncludeBoundariesAndSupportReverseOrder() {
    let lower = Date(timeIntervalSince1970: 100)
    let middle = Date(timeIntervalSince1970: 150)
    let upper = Date(timeIntervalSince1970: 200)

    #expect(lower.isBetween(lower, and: upper))
    #expect(middle.isBetween(lower, and: upper))
    #expect(middle.isBetween(upper, and: lower))
    #expect(upper.isBetween(lower, and: upper))
    #expect(!Date(timeIntervalSince1970: 201).isBetween(lower, and: upper))
}

@Test func randomDatesStayInsideRequestedRange() {
    let lower = Date(timeIntervalSince1970: 1_000)
    let upper = Date(timeIntervalSince1970: 2_000)

    for _ in 0..<100 {
        let value = Date.random(in: lower..<upper)
        #expect(value >= lower)
        #expect(value < upper)
    }
}

@Test func timeFormattingUsesRequestedTimeZone() throws {
    let utc = try #require(TimeZone(secondsFromGMT: 0))
    let plusTwo = try #require(TimeZone(secondsFromGMT: 7_200))
    let date = Date(timeIntervalSince1970: 0)

    #expect(date.time(timeZone: utc) == "00:00")
    #expect(date.time(timeZone: plusTwo) == "02:00")
}
