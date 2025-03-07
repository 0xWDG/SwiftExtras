//
//  Date+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2024-08-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

extension Date {
    /// Is the date the current day?
    public var isCurrentDay: Bool {
        Calendar.current.isDate(
            self,
            equalTo: Date.now,
            toGranularity: .day
        )
    }

    /// Is the date in the weekend?
    public var isWeekend: Bool {
        Calendar.current.isDateInWeekend(self)
    }

    /// Time in HH:MM format
    public var time: String {
        let calendar = Calendar.current

        var hour = "\(calendar.component(.hour, from: self))"
        if hour.count == 1 {
            hour = "0\(hour)"
        }

        var minute = "\(calendar.component(.minute, from: self))"
        if minute.count == 1 {
            minute.append("0")
        }

        return "\(hour):\(minute)"
    }

    /// Date in YYYY-MM-DD format
    public var yyyymmdd: String {
        let calendar = Calendar.current
        return "\(calendar.component(.year, from: self))-\(calendar.component(.month, from: self))-\(calendar.component(.day, from: self))"
        // swiftlint:disable:previous line_length
    }

    /// Date in DD-MM-YYYY format
    public var ddmmyyyy: String {
        let calendar = Calendar.current
        return "\(calendar.component(.day, from: self))-\(calendar.component(.month, from: self))-\(calendar.component(.year, from: self))"
        // swiftlint:disable:previous line_length
    }

    /// Day component of the date
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    /// Month component of the date
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    /// Year component of the date
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    /// Weekday name component of the date
    public var dayName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }

    /// Month and year component of the date
    public var monthAndYear: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let formattedDate = dateFormatter.string(from: self)

        return formattedDate.prefix(1).uppercased() + formattedDate.dropFirst()
    }

    /// Full date string in the format "EEEE dd MMMM yyyy"
    public var fullDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }

    /// First day of the week
    public static var firstDayOfWeek = Calendar.current.firstWeekday

    /// Array of capitalized first letters of the weekdays
    public static var capitalizedFirstLettersOfWeekdays: [String] {
        let calendar = Calendar.current
        var weekdays = calendar.shortWeekdaySymbols
        if firstDayOfWeek > 1 {
            for _ in 1..<firstDayOfWeek {
                if let first = weekdays.first {
                    weekdays.append(first)
                    weekdays.removeFirst()
                }
            }
        }
        return weekdays.map { $0.capitalized }
    }

    /// Array of full month names
    public static var fullMonthNames: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current

        return (1...12).compactMap { month in
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
            let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
            return date.map { dateFormatter.string(from: $0) }
        }
    }

    /// Start of the month (first day)
    public var startOfMonth: Date {
        guard let start = Calendar.current.dateInterval(of: .month, for: self)?.start else {
            fatalError("Unable to determine the start of the month")
        }
        return start
    }

    /// End of the month (last day)
    public var endOfMonth: Date {
        guard let lastDay = Calendar.current.dateInterval(of: .month, for: self)?.end,
              let end = Calendar.current.date(byAdding: .day, value: -1, to: lastDay) else {
            fatalError("Unable to determine the end of the month")
        }
        return end
    }

    /// Start of the previous month (first day)
    public var startOfPreviousMonth: Date {
        guard let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self) else {
            fatalError("Unable to determine the start of the previous month")
        }
        return dayInPreviousMonth.startOfMonth
    }

    /// Number of days in the month
    public var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }

    /// Weeknumber component of the date
    public var weekNumber: Int {
        Calendar.current.component(.weekOfYear, from: self)
    }

    /// First weekday before the start of the month
    public var firstWeekDayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        var numberFromPreviousMonth = startOfMonthWeekday - Self.firstDayOfWeek

        if numberFromPreviousMonth < 0 {
            numberFromPreviousMonth += 7
        }

        guard let firstWeekDay = Calendar.current.date(
            byAdding: .day,
            value: -numberFromPreviousMonth,
            to: startOfMonth
        ) else {
            fatalError("Unable to determine the first weekday before the start of the month")
        }

        return firstWeekDay
    }

    /// Grid of dates for the month
    ///
    /// The grid is an array of 42 dates, starting with the days from the previous month to fill the grid.
    /// The grid is used to display the calendar in a grid format.
    public var calendatGrid: [Date] {
        var days: [Date] = []
        // Start with days from the previous month to fill the grid
        let firstDisplayDay = firstWeekDayBeforeStart
        var day = firstDisplayDay

        while day < startOfMonth {
            if let newDay = Calendar.current.date(byAdding: .day, value: 1, to: day) {
                days.append(day)
                day = newDay
            }
        }

        var dayOffset = 0
        while days.count <= 41 {
            if let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth) {
                days.append(newDay)
            }
            dayOffset += 1
        }

        precondition(
            days.count != 41,
            "The amount of items is incorrect, cannot continue."
        )

        return days
    }

    /// Start of the day
    public var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// Random date in the range
    ///
    /// Returns a random date in the range of dates.
    ///
    /// - Parameter range: The range of dates
    /// - Returns: A random date in the range
    public static func random(in range: Range<Date>) -> Date {
        Date(
            timeIntervalSinceNow: .random(
                in: range.lowerBound.timeIntervalSinceNow...range.upperBound.timeIntervalSinceNow
            )
        )
    }

    /// End of the day
    public var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1

        guard let endOfDay = Calendar.current.date(byAdding: components, to: startOfDay) else {
            fatalError("Unable to determine the end of the day")
        }

        return endOfDay
    }
}
