//
//  DemoComponents.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import SwiftUI

@available(macOS 14, *)
struct DemoPage<Content: View>: View {
    let title: LocalizedStringResource
    let summary: LocalizedStringResource
    let content: Content

    init(
        _ title: LocalizedStringResource,
        summary: LocalizedStringResource,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.summary = summary
        self.content = content()
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                DemoPageHeader(title: title, summary: summary)
                content
            }
            .padding(24)
            .frame(maxWidth: 1_000, alignment: .leading)
        }
        .navigationTitle(Text(title))
    }
}

@available(macOS 14, *)
struct DemoPageHeader: View {
    let title: LocalizedStringResource
    let summary: LocalizedStringResource

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
            Text(summary)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
    }
}

@available(macOS 14, *)
struct DemoPanel<Content: View>: View {
    let title: LocalizedStringResource
    let systemImage: String
    let content: Content

    init(
        _ title: LocalizedStringResource,
        systemImage: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.systemImage = systemImage
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label {
                Text(title)
            } icon: {
                Image(systemName: systemImage)
            }
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background.secondary, in: RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(.separator.opacity(0.5))
                .accessibilityHidden(true)
        }
    }
}

struct DemoValueRow: View {
    let label: LocalizedStringResource
    let value: String

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
            Spacer(minLength: 24)
            Text(value)
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
        }
        .accessibilityElement(children: .combine)
    }
}

@available(macOS 14, *)
struct DemoUnavailable: View {
    let title: LocalizedStringResource
    let reason: LocalizedStringResource
    let systemImage: String

    var body: some View {
        ContentUnavailableView {
            Label {
                Text(title)
            } icon: {
                Image(systemName: systemImage)
            }
        } description: {
            Text(reason)
        }
        .frame(maxWidth: .infinity, minHeight: 140)
    }
}

struct DemoTag: Identifiable {
    let id: String
    let title: String
    let systemImage: String
}

@available(macOS 14, *)
#Preview("Demo Components") {
    DemoPage("Components", summary: "Reusable presentation building blocks.") {
        DemoPanel("Example", systemImage: "sparkles") {
            DemoValueRow(label: "Status", value: "Ready")
        }
    }
    .frame(width: 700, height: 500)
}
