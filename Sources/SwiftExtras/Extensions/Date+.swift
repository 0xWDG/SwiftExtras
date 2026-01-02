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
        time(timeZone: .current)
    }

    /// Date in YYYY-MM-DD format (zero-padded, sortable)
    public var yyyymmdd: String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: self)
        let month = calendar.component(.month, from: self)
        let day = calendar.component(.day, from: self)
        return String(format: "%04d-%02d-%02d", year, month, day)
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

    /// Start of the current year
    public var startOfYear: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year], from: self)
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        return calendar.date(from: components) ?? Date()
    }

    /// End of the current year
    public var endOfYear: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year], from: self)
        components.month = 12
        components.day = 31
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components) ?? Date()
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

    /// Full date string in the format "EE dd MMMM yyyy"
    public var smallDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }

    /// Full date string in the format "dd MMMM yyyy"
    public var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: self)
    }

    /// Full date string in the format "dd mm yyyy"
    public var extraSmallDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy"
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
    public var calendarGrid: [Date] {
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

    /// Random date in the current month (can not be in the future)
    ///
    /// Returns a random date in the range of dates.
    ///
    /// - Parameter range: The range of dates
    /// - Returns: A random date in the range
    public static var random: Date {
        let calendar = Calendar.current
        let today = Date()

        // Generate a random day within the current day and the first day of the month
        let randomDay = Int.random(in: 1 ..< Date().day)

        // Create the date with the random day
        var components = calendar.dateComponents([.year, .month], from: today)
        components.day = randomDay
        components.hour = Int.random(in: 0...23)
        components.minute = Int.random(in: 0...59)
        components.second = Int.random(in: 0...59)

        return calendar.date(from: components) ?? Date()
    }

    /// Random date in the current month (can be in the future)
    ///
    /// Returns a random date in the range of dates.
    ///
    /// - Parameter range: The range of dates
    /// - Returns: A random date in the range
    public static var randomInMonth: Date {
        let calendar = Calendar.current
        let today = Date()

        // Generate a random day within the current day and the first day of the month
        let randomDay = Int.random(in: calendar.range(of: .day, in: .month, for: today) ?? 1 ..< Date().day)

        // Create the date with the random day
        var components = calendar.dateComponents([.year, .month], from: today)
        components.day = randomDay
        components.hour = Int.random(in: 0...23)
        components.minute = Int.random(in: 0...59)
        components.second = Int.random(in: 0...59)

        return calendar.date(from: components) ?? Date()
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

    /// Get local date from provided date
    public func localDate() -> Date {
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {
            return self
        }

        return localDate
    }

    /// Change date to timezone.
    public func to(timeZone outputTimeZone: TimeZone, from inputTimeZone: TimeZone) -> Date {
        let delta = TimeInterval(outputTimeZone.secondsFromGMT(for: self) - inputTimeZone.secondsFromGMT(for: self))
        return addingTimeInterval(delta)
    }

    /// Create a date from specified parameters
    ///
    /// - Parameters:
    ///   - year: The desired year
    ///   - month: The desired month
    ///   - day: The desired day
    public init(year: Int, month: Int, day: Int) {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        self.init(timeIntervalSince1970: calendar.date(from: dateComponents)?.timeIntervalSince1970 ?? 0)
    }

    /// Create a date from specified parameters
    ///
    /// - Parameters:
    ///   - year: The desired year
    ///   - month: The desired month
    ///   - day: The desired day
    ///   - hour: The desired hour
    ///   - minute: The desired minute
    ///   - second: The desired second
    public init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int = 0) {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        self.init(timeIntervalSince1970: calendar.date(from: dateComponents)?.timeIntervalSince1970 ?? 0)
    }

    /// Is the date between a range of dates?
    /// 
    /// - Parameters:
    ///  - date1: The first date of the range
    ///  - date2: The second date of the range
    /// - Returns: `true` if the date is between the two dates, `false` otherwise
    public func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2)...max(date1, date2)).contains(self)
    }

    /// Time in HH:MM format
    public func time(timeZone: TimeZone = .current) -> String {
        var calendar = Calendar.current
        calendar.timeZone = timeZone

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
}
// swiftlint:disable:this file_length
