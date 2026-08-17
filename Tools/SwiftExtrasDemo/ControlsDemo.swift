//
//  ControlsDemo.swift
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
struct ControlsDemo: View {
    var body: some View {
        DemoPage(
            "Controls",
            summary: "Text entry, selection, confirmation, progress, and asynchronous controls."
        ) {
            TextEntryDemo()
            SelectionControlsDemo()
            ActionControlsDemo()
            AsyncControlsDemo()
            VerificationControlDemo()
        }
    }
}

@available(macOS 14, *)
struct TextEntryDemo: View {
    @State private var name = "SwiftExtras"
    @State private var note = "Reusable"
    @State private var changedValue = ""

    var body: some View {
        DemoPanel("Text entry", systemImage: "text.cursor") {
            LabeledTextField("Project name", text: $name, shouldDrawBorder: true)
            LimitedTextField("Short note", text: $note, characterLimit: 24)
            TextField("Binding onChange", text: $changedValue.onChange { _ in })
                .textFieldStyle(.roundedBorder)
                .accessibilityHint("Uses the SwiftExtras Binding onChange helper")
            CopyableLabeledContent("Current name", value: name)
        }
    }
}

@available(macOS 14, *)
struct SelectionControlsDemo: View {
    @State private var selectedItems = ["star", "heart"]
    @State private var selectedMonth = Calendar.current.component(.month, from: .now)
    @State private var selectedYear = Calendar.current.component(.year, from: .now)

    private let symbols = ["star", "heart", "bolt", "leaf"]

    var body: some View {
        DemoPanel("Selection", systemImage: "checklist") {
            MultiSelectView(sourceItems: symbols, selectedItems: $selectedItems) { symbol in
                Label(symbol.capitalized, systemImage: symbol)
            }
            .frame(height: 150)

            MultiSelectPickerView(
                sourceItems: symbols,
                selectedItems: $selectedItems,
                pickerLabel: {
                    Text("Selected symbols")
                },
                selectionLabel: { symbol in
                    Label(symbol.capitalized, systemImage: symbol)
                }
            )

            MonthYearPickerView(selectedMonth: $selectedMonth, selectedYear: $selectedYear)
                .frame(height: 150)
                .accessibilityLabel("Month and year")
        }
    }
}

@available(macOS 14, *)
struct ActionControlsDemo: View {
    @State private var actionMessage = "No action yet"

    var body: some View {
        DemoPanel("Actions", systemImage: "button.programmable") {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) {
                    controls
                }
                VStack(alignment: .leading, spacing: 12) {
                    controls
                }
            }

            HorizontalStepper(step: 3, total: 7, primaryColor: .green)
                .frame(height: 14)
                .accessibilityLabel("Step 3 of 7")

            Text(actionMessage)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .accessibilityLabel("Last action: \(actionMessage)")
        }
    }

    @ViewBuilder
    private var controls: some View {
        ConfirmationButton("Delete", systemImage: "trash") {
            actionMessage = "Delete confirmed"
        }
        .buttonStyle(.bordered)

        SplitActionButton(
            primaryTitle: "Publish",
            primarySystemImage: "paperplane",
            secondaryTitle: "Save Draft",
            secondarySystemImage: "doc",
            primaryAction: { actionMessage = "Published" },
            secondaryAction: { actionMessage = "Draft saved" }
        )
        .buttonStyle(.borderedProminent)
    }
}

@available(macOS 14, *)
struct AsyncControlsDemo: View {
    var body: some View {
        DemoPanel("AsyncView and AsyncTask", systemImage: "clock.arrow.circlepath") {
            AsyncView {
                try? await Task.sleep(for: .milliseconds(350))
                return "Loaded with AsyncView"
            } content: { result in
                Label(result, systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }

            Label(
                "AsyncTask is deprecated because it intentionally renders no content.",
                systemImage: "exclamationmark.triangle"
            )
                .foregroundStyle(.secondary)
        }
    }
}

@available(macOS 14, *)
struct VerificationControlDemo: View {
    var body: some View {
        DemoPanel("VerificationField", systemImage: "number.square") {
            #if os(iOS)
            VerificationControlContent()
            #else
            DemoUnavailable(
                title: "VerificationField is iOS-only",
                reason: "Run this demo target in an iOS host app to enter one-time codes.",
                systemImage: "iphone"
            )
            #endif
        }
    }
}

#if os(iOS)
struct VerificationControlContent: View {
    @State private var code = ""

    var body: some View {
        VerificationField(type: .six, value: $code) { value in
            value.count == 6 ? .valid : .typing
        }
    }
}
#endif

@available(macOS 14, *)
#Preview("Controls") {
    ControlsDemo()
        .frame(width: 800, height: 700)
}
