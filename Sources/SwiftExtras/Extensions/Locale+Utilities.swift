//
//  Locale+Utilities.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-22.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

public extension Locale {
    /// The user's country/region identifier (e.g., "US")
    static var userCountry: String { current.region?.identifier ?? "Unknown" }

    /// The user's preferred language (e.g., "en")
    static var userLanguage: String { current.language.languageCode?.identifier ?? "Unknown" }

    /// The user's currency code (e.g., "USD")
    static var userCurrencyCode: String { current.currency?.identifier ?? "Unknown" }

    /// The user's currency symbol (e.g., "$")
    static var userCurrencySymbol: String { current.currencySymbol ?? "Unknown" }

    /// The measurement system used (e.g., metric, US)
    static var deviceMeasurementSystem: Locale.MeasurementSystem { current.measurementSystem }

    /// The user's time zone identifier (e.g., "America/New_York")
    static var userTimeZone: String { TimeZone.current.identifier }

    /// The preferred calendar identifier (e.g., "gregorian")
    static var userCalendar: String { String(describing: current.calendar.identifier) }

    /// The user's collation identifier (sorting order preference)
    static var collationIdentifier: String { current.collation.identifier }
}
