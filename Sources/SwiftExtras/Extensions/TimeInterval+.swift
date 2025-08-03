//
//  TimeInterval+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2024-10-15.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension TimeInterval {
    /// Returns the time interval in years
    var years: Int {
        Int(self) / 31_536_000
    }

    /// Returns the time interval in months
    var months: Int {
        Int(self) / 2_592_000
    }

    /// Returns the time interval in weeks
    var weeks: Int {
        Int(self) / 604_800
    }

    /// Returns the time interval in days
    var days: Int {
        Int(self) / 86400
    }

    /// Returns the time interval in hours
    var hours: Int {
        Int(self) / 3600
    }

    /// Returns the time interval in minutes
    var minutes: Int {
        (Int(self) / 60) % 60
    }

    /// Returns the time interval in seconds
    var seconds: Int {
        Int(self) % 60
    }

    /// Returns the time interval in milliseconds
    var milliseconds: Int {
        Int(truncatingRemainder(dividingBy: 1) * 1000)
    }

    /// Returns the time interval in absolute years
    var absoluteYears: Int {
        Int(abs(self)) / 31_536_000
    }

    /// Returns the time interval in absolute months
    var absoluteMonths: Int {
        Int(abs(self)) / 2_592_000
    }

    /// Returns the time interval in absolute weeks
    var absoluteWeeks: Int {
        Int(abs(self)) / 604_800
    }

    /// Returns the time interval in absolute days
    var absoluteDays: Int {
        Int(abs(self)) / 86400
    }

    /// Returns the time interval in absolute hours
    var absoluteHours: Int {
        Int(abs(self)) / 3600
    }

    /// Returns the time interval in absolute minutes
    var absoluteMinutes: Int {
        (Int(abs(self)) / 60) % 60
    }

    /// Returns the time interval in absolute seconds
    var absoluteSeconds: Int {
        Int(abs(self)) % 60
    }

    #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || os(macOS)
        /// Returns the time interval in relative time
        var timeString: String {
            if self == 0 {
                return NSLocalizedString("At time of event", comment: "At time of event")
            }

            return RelativeDateTimeFormatter()
                .localizedString(fromTimeInterval: self)
                .components(separatedBy: " ")
                .dropLast()
                .joined(separator: " ")
                + " " + NSLocalizedString("before", comment: "before")
        }
    #endif
}
