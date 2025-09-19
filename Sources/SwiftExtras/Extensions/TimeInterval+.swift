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

extension TimeInterval {
    /// Returns the time interval in years
    public var years: Int {
        return Int(self) / 31536000
    }

    /// Returns the time interval in months
    public var months: Int {
        return Int(self) / 2592000
    }

    /// Returns the time interval in weeks
    public var weeks: Int {
        return Int(self) / 604800
    }

    /// Returns the time interval in days
    public var days: Int {
        return Int(self) / 86400
    }

    /// Returns the time interval in hours
    public var hours: Int {
        return Int(self) / 3600
    }

    /// Returns the time interval in minutes
    public var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    /// Returns the time interval in seconds
    public var seconds: Int {
        return Int(self) % 60
    }

    /// Returns the time interval in milliseconds
    public var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }

    /// Returns the time interval in absolute years
    public var absoluteYears: Int {
        return Int(abs(self)) / 31536000
    }

    /// Returns the time interval in absolute months
    public var absoluteMonths: Int {
        return Int(abs(self)) / 2592000
    }

    /// Returns the time interval in absolute weeks
    public var absoluteWeeks: Int {
        return Int(abs(self)) / 604800
    }

    /// Returns the time interval in absolute days
    public var absoluteDays: Int {
        return Int(abs(self)) / 86400
    }

    /// Returns the time interval in absolute hours
    public var absoluteHours: Int {
        return Int(abs(self)) / 3600
    }

    /// Returns the time interval in absolute minutes
    public var absoluteMinutes: Int {
        return (Int(abs(self)) / 60) % 60
    }

    /// Returns the time interval in absolute seconds
    public var absoluteSeconds: Int {
        return Int(abs(self)) % 60
    }

    /// Returns the time interval as HH:MM:SS
    public var stringValue: String {
        guard self > 0 && self < Double.infinity else {
            return "unknown"
        }
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || os(macOS)
    /// Returns the time interval in relative time
    public var timeString: String {
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
