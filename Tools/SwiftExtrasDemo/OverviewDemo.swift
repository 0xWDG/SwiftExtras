//
//  OverviewDemo.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import SwiftExtras
import SwiftUI

@available(macOS 14, *)
struct OverviewDemo: View {
    private let categories = DemoCategory.allCases.filter { $0 != .overview }

    var body: some View {
        DemoPage(
            "SwiftExtras Demo",
            summary: "A live catalog of views, modifiers, styles, platform helpers, and Foundation utilities."
        ) {
            OverviewHero()
            OverviewCategories(categories: categories)
            OverviewCoverage()
        }
    }
}

@available(macOS 14, *)
struct OverviewHero: View {
    var body: some View {
        DemoPanel("Package at a glance", systemImage: "shippingbox.fill") {
            HStack(spacing: 28) {
                OverviewMetric(value: "30+", label: "SwiftUI components")
                OverviewMetric(value: "25+", label: "View modifiers")
                OverviewMetric(value: "60+", label: "Utility APIs")
                OverviewMetric(value: "4", label: "Apple platforms")
            }
            .accessibilityElement(children: .contain)

            Text("Select a category in the sidebar. Every example is interactive and uses SwiftExtras directly.")
                .foregroundStyle(.secondary)
        }
    }
}

@available(macOS 14, *)
struct OverviewMetric: View {
    let value: String
    let label: LocalizedStringResource

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(.title, design: .rounded, weight: .bold))
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
    }
}

@available(macOS 14, *)
struct OverviewCategories: View {
    let categories: [DemoCategory]

    var body: some View {
        DemoPanel("Catalog", systemImage: "square.grid.2x2") {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 190), spacing: 12)], spacing: 12) {
                ForEach(categories) { category in
                    Label {
                        Text(category.title)
                    } icon: {
                        Image(systemName: category.systemImage)
                    }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                        .accessibilityLabel(Text(category.title))
                }
            }
        }
    }
}

@available(macOS 14, *)
struct OverviewCoverage: View {
    var body: some View {
        DemoPanel("Coverage", systemImage: "checkmark.seal.fill") {
            Label("Views, layouts, shapes, and styles have live visual examples.", systemImage: "eye")
            Label("String, date, data, JSON, and numeric helpers show computed results.", systemImage: "function")
            Label("Unavailable platform APIs explain where they can run.", systemImage: "iphone.and.arrow.forward")
            Label("Potentially disruptive actions require an explicit button press.", systemImage: "hand.tap")
        }
    }
}

@available(macOS 14, *)
#Preview("Overview") {
    OverviewDemo()
        .frame(width: 900, height: 700)
}
