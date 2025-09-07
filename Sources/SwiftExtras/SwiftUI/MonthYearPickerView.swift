//
//  MonthYearPickerView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

#if canImport(SwiftUI)
import SwiftUI

/// A view that allows users to select a month and year.
/// This view provides a picker for selecting a month and a year, with options to limit the selection range.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct MonthYearPickerView: View {
    /// The selected month, bound to an external state.
    @Binding var selectedMonth: Int

    /// The selected year, bound to an external state.
    @Binding var selectedYear: Int

    /// The minimum date that can be selected.
    private var minimumDate: Date

    /// The maximum date that can be selected.
    private var maximumDate: Date

    /// The list of month names.
    private var months: [String]

    /// The list of years available for selection.
    private var years: [Int] = []

    /// Computes the available years based on the minimum and maximum dates.
    private var availableYears: [Int] {
        let minYear = Calendar.current.component(.year, from: minimumDate)
        let maxYear = Calendar.current.component(.year, from: maximumDate)
        return Array(minYear...maxYear)
    }

    /// Initializes a new instance of `MonthYearPickerView`.
    /// - Parameters:
    ///   - selectedMonth: A binding to the selected month (1-12).
    ///   - selectedYear: A binding to the selected year.
    ///   - minimumDate: The earliest date that can be selected (default is 1970-01-01).
    ///   - maximumDate: The latest date that can be selected (default is distant future).
    public init(
        selectedMonth: Binding<Int>,
        selectedYear: Binding<Int>,
        minimumDate: Date = Date(timeIntervalSince1970: 0),
        maximumDate: Date = Date.distantFuture
    ) {
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self._selectedMonth = selectedMonth
        self._selectedYear = selectedYear
        self.months = Calendar.current.monthSymbols.map { $0.capitalized }
        self.years = availableYears
    }

    /// The body of the view.
    public var body: some View {
        HStack {
            Picker("Month", selection: $selectedMonth) {
                ForEach(1...12, id: \.self) { month in
                    Text(self.months[month - 1])
                        .tag(month)
                }
            }
#if os(macOS) || os(watchOS) || os(tvOS)
            .pickerStyle(.inline)
#else
            .pickerStyle(.wheel)
#endif

            Picker("Year", selection: $selectedYear) {
                ForEach(availableYears, id: \.self) { year in
                    Text(verbatim: "\(year)").tag(year)
                }
            }
#if os(macOS) || os(watchOS) || os(tvOS)
            .pickerStyle(.inline)
#else
            .pickerStyle(.wheel)
#endif

        }
        .onChange(of: selectedMonth) {
            guard
                let date = DateComponents(
                    calendar: Calendar.current,
                    year: selectedYear,
                    month: selectedMonth,
                    day: 1,
                    hour: 0,
                    minute: 0,
                    second: 0
                ).date
            else { return }

            if date < minimumDate {
                selectedYear = Calendar.current.component(.year, from: minimumDate)
                selectedMonth = Calendar.current.component(.month, from: minimumDate)
            } else if date > maximumDate {
                selectedYear = Calendar.current.component(.year, from: maximumDate)
                selectedMonth = Calendar.current.component(.month, from: maximumDate)
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview {
    @Previewable @State var selectedMonth: Int = 1
    @Previewable @State var selectedYear: Int = 2021
    MonthYearPickerView(
        selectedMonth: $selectedMonth,
        selectedYear: $selectedYear
    )
}
#endif
