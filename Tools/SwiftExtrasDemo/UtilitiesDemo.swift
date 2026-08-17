//
//  UtilitiesDemo.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
import SwiftExtras
import SwiftUI

@available(macOS 14, *)
struct UtilitiesDemo: View {
    var body: some View {
        DemoPage(
            "Utilities & Data",
            summary: "Live output from string, date, collection, numeric, data, Codable, and JSON helpers."
        ) {
            StringUtilitiesDemo()
            DateUtilitiesDemo()
            CollectionAndNumericDemo()
            DataAndCodingDemo()
            DynamicJSONDemo()
            LocaleAndProcessDemo()
        }
    }
}

@available(macOS 14, *)
struct StringUtilitiesDemo: View {
    @State private var input = "  Café SwiftExtras Demo  "

    var body: some View {
        DemoPanel("String helpers", systemImage: "textformat") {
            TextField("Input", text: $input)
                .textFieldStyle(.roundedBorder)
                .accessibilityLabel("String utility input")

            DemoValueRow(label: "Trimmed", value: input.trimmed())
            DemoValueRow(label: "Diacritics removed", value: input.clean())
            DemoValueRow(label: "Slugified", value: input.slugified)
            DemoValueRow(label: "Quoted", value: input.quoted)
            DemoValueRow(label: "URL encoded", value: input.urlEncoded)
            DemoValueRow(label: "Base64", value: input.base64Encoded() ?? "Unable to encode")
            DemoValueRow(label: "Groups of five", value: input.split(every: 5).formatted())
            DemoValueRow(label: "Slice", value: "[SwiftExtras]".slice(from: "[", to: "]") ?? "Not found")
            DemoValueRow(label: "Fuzzy ‘set’", value: input.fuzzyMatches("set").description)
            DemoValueRow(
                label: "Case-insensitive contains",
                value: input.contains("swift", caseSensitive: false).description
            )
            DemoValueRow(label: "Stable hash", value: input.hashed.formatted())
            DemoValueRow(label: "DJB2 / SDBM", value: "\(input.djb2hash) / \(input.sdbmhash)")
            DemoValueRow(label: "Subscript 0...3", value: input.isEmpty ? "" : input[0...min(3, input.count - 1)])
            DemoValueRow(label: "Regex operator", value: (input =~ ".*SwiftExtras.*").description)
        }
    }
}

@available(macOS 14, *)
struct DateUtilitiesDemo: View {
    private let date = Date(year: 2026, month: 8, day: 16, hour: 14, minute: 30)

    var body: some View {
        DemoPanel("Date and time", systemImage: "calendar.badge.clock") {
            DemoValueRow(label: "YYYY-MM-DD", value: date.yyyymmdd)
            DemoValueRow(label: "DD-MM-YYYY", value: date.ddmmyyyy)
            DemoValueRow(label: "Day and month", value: "\(date.dayName), \(date.monthAndYear)")
            DemoValueRow(label: "Full date", value: date.fullDateString)
            DemoValueRow(label: "Relative", value: date.timeAgo)
            DemoValueRow(label: "Weekend", value: date.isWeekend.description)
            DemoValueRow(label: "Days in month", value: date.numberOfDaysInMonth.formatted())
            DemoValueRow(label: "Calendar grid cells", value: date.calendarGrid.count.formatted())
            DemoValueRow(label: "Start / end", value: "\(date.startOfDay.time) – \(date.endOfDay.time)")
            DemoValueRow(label: "Formatted template", value: date.formatted("yyyy-MM-dd HH:mm"))
            DemoValueRow(label: "TimeInterval", value: TimeInterval(3_725).stringValue)
        }
    }
}

@available(macOS 14, *)
struct CollectionAndNumericDemo: View {
    private let values = [2, 4, 6, 8, 10]
    private let optionalValues: [Int]? = nil

    var body: some View {
        DemoPanel("Collections and numbers", systemImage: "number") {
            DemoValueRow(label: "Sum", value: values.sum().formatted())
            DemoValueRow(label: "Average", value: values.average().formatted())
            DemoValueRow(label: "Safe index 20", value: values[safe: 20]?.formatted() ?? "nil")
            DemoValueRow(label: "Second / third", value: "\(values.second ?? 0) / \(values.third ?? 0)")
            DemoValueRow(label: "Penultimate", value: values.penultimate?.formatted() ?? "nil")
            DemoValueRow(label: "Optional is nil or empty", value: optionalValues.isNilOrEmpty.description)
            DemoValueRow(label: "Clean floating point", value: Double(42.0).clean)
            DemoValueRow(label: "Meters to kilometers", value: 2_500.0.convert(.meters, to: .kilometers).clean)
            DemoValueRow(label: "Currency", value: 1_250.toCurrency(digits: 2))
            DemoValueRow(label: "Default spacing", value: CGFloat.defaultSpacing.formatted())
            DemoValueRow(label: "Default text height", value: CGFloat.defaultTextHeight.formatted())
        }
    }
}

@available(macOS 14, *)
struct DataAndCodingDemo: View {
    private let text = "SwiftExtras compression fixture"

    var body: some View {
        let data = Data(text.utf8)
        let compressed = data.deflate()
        let inflated = compressed?.inflate()
        let dictionary = ["framework": "SwiftExtras", "license": "MIT"]
        let anyCodable = AnyCodable(["Swift", "SwiftUI"])

        DemoPanel("Data, Codable, and raw representations", systemImage: "externaldrive") {
            DemoValueRow(label: "Data hexadecimal", value: data.hexString)
            DemoValueRow(label: "Compressed bytes", value: compressed?.count.formatted() ?? "Unavailable")
            DemoValueRow(label: "Inflated value", value: inflated?.stringValue ?? "Unable to inflate")
            DemoValueRow(label: "Dictionary raw value", value: dictionary.rawValue)
            DemoValueRow(
                label: "Dictionary round trip",
                value: Dictionary(rawValue: dictionary.rawValue)?.description ?? "Failed"
            )
            DemoValueRow(label: "AnyCodable reflection", value: String(describing: anyCodable.customMirror.subjectType))
        }
    }
}

@available(macOS 14, *)
struct DynamicJSONDemo: View {
    private let json = JSON([
        "name": "SwiftExtras",
        "features": ["Views", "Modifiers", "Utilities"],
        "stable": true,
        "count": 3
    ])

    var body: some View {
        DemoPanel("Dynamic JSON", systemImage: "curlybraces.square") {
            DemoValueRow(label: "Name", value: json["name"]?.string ?? "Missing")
            DemoValueRow(label: "First feature", value: json["features"]?[0]?.string ?? "Missing")
            DemoValueRow(label: "Feature count", value: json["features"]?.array?.count.formatted() ?? "0")
            DemoValueRow(label: "Boolean conversion", value: json["stable"]?.bool?.description ?? "Missing")
            DemoValueRow(label: "Serialized bytes", value: json.data().count.formatted())
        }
    }
}

@available(macOS 14, *)
struct LocaleAndProcessDemo: View {
    var body: some View {
        DemoPanel("Locale and process", systemImage: "globe") {
            DemoValueRow(label: "Country", value: Locale.userCountry)
            DemoValueRow(label: "Language", value: Locale.userLanguage)
            DemoValueRow(label: "Currency", value: "\(Locale.userCurrencyCode) (\(Locale.userCurrencySymbol))")
            DemoValueRow(label: "Measurement", value: String(describing: Locale.deviceMeasurementSystem))
            DemoValueRow(label: "Time zone", value: Locale.userTimeZone)
            DemoValueRow(label: "Calendar", value: Locale.userCalendar)
            DemoValueRow(label: "SwiftUI preview", value: ProcessInfo.isSwiftUIPreview.description)
            DemoValueRow(label: "Unit testing", value: ProcessInfo.isUnitTesting.description)
            DemoValueRow(label: "Low-power mode", value: ProcessInfo.isLowPowerModeActive.description)
        }
    }
}

@available(macOS 14, *)
#Preview("Utilities") {
    UtilitiesDemo()
        .frame(width: 900, height: 700)
}
