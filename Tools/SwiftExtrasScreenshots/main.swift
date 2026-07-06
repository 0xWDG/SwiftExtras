//
//  main.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-07-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(AppKit)
import AppKit
import SwiftExtras
import SwiftUI

@main
enum ScreenshotGenerator {
    static func main() throws {
        let output = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            .appendingPathComponent("Sources/SwiftExtras/SwiftExtras.docc/Resources")
        try FileManager.default.createDirectory(at: output, withIntermediateDirectories: true)

        for spec in specs {
            try render(spec, output: output)
        }
    }

    private static var specs: [ScreenshotSpec] {
        var specs = standardSpecs

        if #available(macOS 14, *) {
            specs.append(contentsOf: modernSpecs)
        }

        return specs
    }

    private static var standardSpecs: [ScreenshotSpec] {
        controlSpecs + actionSpecs + containerSpecs + listSpecs
    }

    private static var controlSpecs: [ScreenshotSpec] {
        [
            .init(name: "labeled-text-field", size: .init(width: 620, height: 280)) {
                ExampleFrame(title: "LabeledTextField") {
                    VStack(spacing: 18) {
                        LabeledTextField("Email", text: .constant(""))
                        LabeledTextField("Name", text: .constant("Wesley de Groot"), shouldDrawBorder: true)
                        LabeledTextField("Website", text: .constant("swift-extras.example"), shouldDrawBorder: true)
                    }
                }
            },
            .init(name: "limited-text-field", size: .init(width: 620, height: 220)) {
                ExampleFrame(title: "LimitedTextField") {
                    LimitedTextField("Release note", text: .constant("Initial version"), characterLimit: 24)
                }
            }
        ]
    }

    private static var actionSpecs: [ScreenshotSpec] {
        [
            .init(name: "multi-select-view", size: .init(width: 620, height: 360)) {
                ExampleFrame(title: "MultiSelectView") {
                    MultiSelectView(
                        sourceItems: ["star", "person", "rainbow", "heart"],
                        selectedItems: .constant(["star", "rainbow"])
                    ) { item in
                        Label(item.capitalized, systemImage: item)
                    }
                    .frame(height: 230)
                }
            },
            .init(name: "multi-select-picker-view", size: .init(width: 620, height: 240)) {
                ExampleFrame(title: "MultiSelectPickerView") {
                    NavigationStack {
                        List {
                            MultiSelectPickerView(
                                sourceItems: ["star", "person", "rainbow"],
                                selectedItems: .constant(["person"]),
                                pickerLabel: {
                                Text("Pick your symbols")
                                },
                                selectionLabel: { item in
                                    Label(item.capitalized, systemImage: item)
                                }
                            )
                        }
                    }
                    .frame(height: 120)
                }
            },
            .init(name: "split-action-button", size: .init(width: 620, height: 220)) {
                ExampleFrame(title: "SplitActionButton") {
                    HStack(spacing: 18) {
                        SplitActionButton(
                            primaryTitle: "Publish",
                            primarySystemImage: "paperplane",
                            secondaryTitle: "Save Draft",
                            secondarySystemImage: "doc",
                            primaryAction: { },
                            secondaryAction: { }
                        )
                        .buttonStyle(.borderedProminent)

                        SplitActionButton(
                            primaryTitle: "Publish",
                            primarySystemImage: "paperplane",
                            secondaryTitle: "Schedule",
                            secondarySystemImage: "calendar",
                            primaryAction: { },
                            secondaryAction: { },
                            label: {
                                Label("Custom", systemImage: "sparkles")
                            }
                        )
                        .buttonStyle(.bordered)
                    }
                }
            }
        ]
    }

    private static var containerSpecs: [ScreenshotSpec] {
        [
            .init(name: "card-view", size: .init(width: 620, height: 380)) {
                CardView(title: "Project", subtitle: "Ready to ship") {
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Three reusable components", systemImage: "checkmark.circle.fill")
                        Label("Documented with DocC", systemImage: "doc.text")
                        Text(cardDescription)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 620, height: 380)
                .background(Color(nsColor: .windowBackgroundColor))
            },
            .init(name: "disclosure-section", size: .init(width: 620, height: 320)) {
                ExampleFrame(title: "DisclosureSection") {
                    Form {
                        DisclosureSection("Build Settings", isExpanded: true) {
                            Text("Enable warnings")
                            Text("Run tests before release")
                        }
                        DisclosureSection("Advanced") {
                            Text("Hidden until expanded")
                        }
                    }
                    .formStyle(.grouped)
                    .frame(height: 190)
                }
            },
            .init(name: "horizontal-stepper", size: .init(width: 620, height: 180)) {
                ExampleFrame(title: "HorizontalStepper") {
                    HorizontalStepper(step: 4, total: 7, primaryColor: .green)
                        .frame(height: 16)
                }
            },
            .init(name: "wstack", size: .init(width: 620, height: 280)) {
                ExampleFrame(title: "WStack") {
                    WStack(spacing: 8) {
                        ForEach(wstackLabels, id: \.self) { label in
                            Text(label)
                                .font(.callout.weight(.medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.accentColor.opacity(0.14))
                                .clipShape(Capsule())
                        }
                    }
                    .frame(width: 500, height: 120, alignment: .topLeading)
                }
            }
        ]
    }

    private static var listSpecs: [ScreenshotSpec] {
        [
            .init(name: "indexed-list", size: .init(width: 620, height: 420)) {
                ExampleFrame(title: "IndexedList") {
                    IndexedList(data: indexedListItems) { item in
                        Text(item)
                    }
                    .frame(height: 280)
                }
            },
            .init(name: "se-changelog-view", size: .init(width: 620, height: 420)) {
                NavigationStack {
                    SEChangeLogView(changeLog: [
                        .init(version: "1.2.0", date: "2026-07-06", text: "Added DocC screenshots for custom views."),
                        .init(version: "1.1.0", date: "2026-06-20", text: "Added SplitActionButton.")
                    ])
                }
                .frame(width: 620, height: 420)
            },
            .init(name: "se-acknowledgement-view", size: .init(width: 620, height: 420)) {
                NavigationStack {
                    SEAcknowledgementView(entries: [
                        .init(name: "ExampleKit", copyright: "Example Author", licence: "MIT")
                    ])
                }
                .frame(width: 620, height: 420)
            }
        ]
    }

    @available(macOS 14, *)
    private static var modernSpecs: [ScreenshotSpec] {
        [
            .init(name: "month-year-picker-view", size: .init(width: 620, height: 360)) {
                ExampleFrame(title: "MonthYearPickerView") {
                    MonthYearPickerView(
                        selectedMonth: .constant(7),
                        selectedYear: .constant(2026),
                        minimumDate: date(year: 2024, month: 1),
                        maximumDate: date(year: 2028, month: 12)
                    )
                    .frame(height: 220)
                }
            },
            .init(name: "confirmation-button", size: .init(width: 620, height: 220)) {
                ExampleFrame(title: "ConfirmationButton") {
                    HStack {
                        ConfirmationButton("Delete Project", systemImage: "trash") { }
                            .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                }
            },
            .init(name: "carousel-view", size: .init(width: 620, height: 420)) {
                ExampleFrame(title: "CarouselView") {
                    CarouselView(items: [
                        Image(systemName: "star.fill"),
                        Image(systemName: "rainbow"),
                        Image(systemName: "heart.fill")
                    ])
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.blue)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            },
            .init(name: "notification-view", size: .init(width: 620, height: 220)) {
                ZStack(alignment: .top) {
                    Color(nsColor: .windowBackgroundColor)
                    NotificationView(
                        title: "Export Complete",
                        message: "Screenshots were saved to the DocC catalog.",
                        onClick: { }
                    )
                        .frame(maxWidth: .infinity)
                        .padding(.top, 24)
                }
                .frame(width: 620, height: 220)
            }
        ]
    }

}

private let cardDescription = """
CardView keeps the title, subtitle, close action, and custom scrollable content together.
"""

private let wstackLabels = [
    "SwiftUI",
    "DocC",
    "Views",
    "Styles",
    "Layout",
    "Utilities",
    "Screenshots"
]

private let indexedListItems = [
    "Apple",
    "Apricot",
    "Banana",
    "Blueberry",
    "Cherry",
    "Grape",
    "Orange",
    "Pear",
    "Plum"
]

@MainActor
private func render(_ spec: ScreenshotSpec, output: URL) throws {
    let view = NSHostingView(rootView:
        spec.content()
            .frame(width: spec.size.width, height: spec.size.height)
            .environment(\.colorScheme, .light)
            .tint(.blue)
    )
    view.frame = CGRect(origin: .zero, size: spec.size)
    view.setFrameSize(spec.size)

    let window = NSWindow(
        contentRect: CGRect(origin: .zero, size: spec.size),
        styleMask: [.borderless],
        backing: .buffered,
        defer: false
    )
    window.contentView = view
    window.makeKeyAndOrderFront(nil)

    view.layoutSubtreeIfNeeded()
    RunLoop.main.run(until: Date().addingTimeInterval(5))
    view.layoutSubtreeIfNeeded()

    let representation = view.bitmapImageRepForCachingDisplay(in: view.bounds)
    guard let bitmap = representation else {
        throw ScreenshotError.renderFailed(spec.name)
    }

    view.cacheDisplay(in: view.bounds, to: bitmap)
    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw ScreenshotError.renderFailed(spec.name)
    }
    window.orderOut(nil)
    try data.write(to: output.appendingPathComponent("\(spec.name).png"))
}

struct ScreenshotSpec {
    let name: String
    let size: CGSize
    let content: @MainActor () -> AnyView

    init<Content: View>(
        name: String,
        size: CGSize,
        @ViewBuilder content: @escaping @MainActor () -> Content
    ) {
        self.name = name
        self.size = size
        self.content = { AnyView(content()) }
    }
}

struct ExampleFrame<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.title3.weight(.semibold))

            content

            Spacer(minLength: 0)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

enum ScreenshotError: Error {
    case renderFailed(String)
}

private func date(year: Int, month: Int) -> Date {
    guard let date = DateComponents(calendar: .current, year: year, month: month, day: 1).date else {
        preconditionFailure("Invalid screenshot date components.")
    }

    return date
}
#endif
