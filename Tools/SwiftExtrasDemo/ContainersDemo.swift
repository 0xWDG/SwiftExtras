//
//  ContainersDemo.swift
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
struct ContainersDemo: View {
    var body: some View {
        DemoPage(
            "Containers",
            summary: "Cards, carousels, disclosure sections, indexed lists, notifications, and metadata screens."
        ) {
            CardAndDisclosureDemo()
            CarouselDemo()
            IndexedListDemo()
            NotificationContainerDemo()
            MetadataViewsDemo()
            NavigationContainerDemo()
        }
    }
}

@available(macOS 14, *)
struct NavigationContainerDemo: View {
    var body: some View {
        DemoPanel("NavigationViewIfNeeded", systemImage: "point.topleft.down.to.point.bottomright.curvepath") {
            NavigationViewIfNeeded {
                Text("This content gains navigation only when its parent does not provide it.")
                    .navigationTitle("Conditional navigation")
                    .subtitle("Provided by SwiftExtras")
                    .toolbar {
                        Button("Example", systemImage: "sparkles") { }
                            .accessibilityHint("Example toolbar action")
                    }
            }
            .frame(height: 150)
        }
    }
}

@available(macOS 14, *)
struct CardAndDisclosureDemo: View {
    var body: some View {
        DemoPanel("CardView and DisclosureSection", systemImage: "rectangle.3.group") {
            CardView(title: "SwiftExtras", subtitle: "Reusable Swift helpers") {
                Label("Cross-platform SwiftUI", systemImage: "checkmark.circle.fill")
                Label("Foundation extensions", systemImage: "checkmark.circle.fill")
                Label("Accessible examples", systemImage: "checkmark.circle.fill")
            }
            .frame(height: 210)

            Form {
                DisclosureSection("What is included?", isExpanded: true) {
                    Text("Views and layouts")
                    Text("Modifiers and styles")
                    Text("Foundation utilities")
                }
                DisclosureSection("Collapsed example") {
                    Text("This content starts hidden.")
                }
            }
            .formStyle(.grouped)
            .frame(height: 190)
        }
    }
}

@available(macOS 14, *)
struct CarouselDemo: View {
    var body: some View {
        DemoPanel("CarouselView", systemImage: "rectangle.stack") {
            CarouselView(items: [
                Image(systemName: "swift"),
                Image(systemName: "sparkles"),
                Image(systemName: "shippingbox.fill")
            ])
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.blue)
            .frame(height: 260)
            .background(.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 14))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .accessibilityLabel("SwiftExtras symbol carousel")
        }
    }
}

@available(macOS 14, *)
struct IndexedListDemo: View {
    private let names = [
        "AsyncView", "CardView", "CarouselView", "DisclosureSection",
        "Flow", "HexShape", "IndexedList", "NotificationView", "WStack"
    ]

    var body: some View {
        DemoPanel("IndexedList", systemImage: "list.bullet.rectangle") {
            IndexedList(data: names) { name in
                Text(name)
            }
            .frame(height: 300)
        }
    }
}

@available(macOS 14, *)
struct NotificationContainerDemo: View {
    @State private var showsOverlay = false

    var body: some View {
        DemoPanel("NotificationView", systemImage: "bell.badge") {
            NotificationView(
                title: "SwiftExtras",
                message: "The notification component is running live.",
                onClick: { showsOverlay = false }
            )
            .frame(maxWidth: 520)

            Button("Toggle notification modifier") {
                showsOverlay.toggle()
            }
            .accessibilityHint("Shows or hides the notification modifier example")

            Text("Notification modifier target")
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                .notification(
                    title: showsOverlay ? "Modifier active" : "Modifier ready",
                    message: "Tap the notification to dismiss it.",
                    onClick: { showsOverlay = false }
                )
        }
    }
}

@available(macOS 14, *)
struct MetadataViewsDemo: View {
    var body: some View {
        DemoPanel("Acknowledgements and changelog", systemImage: "doc.text.magnifyingglass") {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 16) {
                    acknowledgementView
                    changeLogView
                }
                VStack(spacing: 16) {
                    acknowledgementView
                    changeLogView
                }
            }
        }
    }

    private var acknowledgementView: some View {
        NavigationStack {
            SEAcknowledgementView(entries: [
                SEAcknowledgement(
                    name: "OSLogViewer",
                    copyright: "0xWDG",
                    licence: "MIT",
                    url: "https://github.com/0xWDG/OSLogViewer"
                )
            ])
        }
        .frame(minWidth: 320, minHeight: 260)
    }

    private var changeLogView: some View {
        NavigationStack {
            SEChangeLogView(changeLog: [
                SEChangeLogEntry(version: "2.0", date: "2026-08-16", text: "Added the complete demo app."),
                SEChangeLogEntry(version: "1.0", date: "2025-01-10", text: "Initial release.")
            ])
        }
        .frame(minWidth: 320, minHeight: 260)
    }
}

@available(macOS 14, *)
#Preview("Containers") {
    ContainersDemo()
        .frame(width: 900, height: 700)
}
