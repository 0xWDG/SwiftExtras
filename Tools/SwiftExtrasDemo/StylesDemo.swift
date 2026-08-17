//
//  StylesDemo.swift
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
struct StylesDemo: View {
    var body: some View {
        DemoPage(
            "Styles",
            summary: "Button and toggle styles with enabled, disabled, light, and dark variants."
        ) {
            ColoredButtonStylesDemo()
            OtherButtonStylesDemo()
            ToggleStylesDemo()
        }
    }
}

@available(macOS 14, *)
struct ColoredButtonStylesDemo: View {
    var body: some View {
        DemoPanel("ColoredButtonStyle", systemImage: "paintpalette") {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) { buttons }
                VStack(alignment: .leading, spacing: 12) { buttons }
            }
        }
    }

    @ViewBuilder
    private var buttons: some View {
        Button("Blue") { }
            .buttonStyle(.blueColor)
        Button("Green") { }
            .buttonStyle(.greenColor)
        Button("Purple") { }
            .buttonStyle(.purpleColor)
        Button("Accent") { }
            .buttonStyle(.accentColor)
        Button("Disabled") { }
            .buttonStyle(.redColor)
            .disabled(true)
    }
}

@available(macOS 14, *)
struct OtherButtonStylesDemo: View {
    var body: some View {
        DemoPanel("Gray, list, and toggle buttons", systemImage: "button.programmable") {
            HStack(spacing: 12) {
                Button("Gray") { }
                    .buttonStyle(.gray)
                Button("Toggle style") { }
                    .buttonStyle(.toggle)
            }

            List {
                Button("List button") { }
                Button("Disabled list button") { }
                    .disabled(true)
            }
            .buttonStyle(.list)
            .frame(height: 110)
        }
    }
}

@available(macOS 14, *)
struct ToggleStylesDemo: View {
    @State private var bordered = true
    @State private var plainBordered = false

    var body: some View {
        DemoPanel("Toggle styles", systemImage: "switch.2") {
            Toggle("Bordered toggle", isOn: $bordered)
                .toggleStyle(.bordered)
            Toggle("Plain bordered toggle", isOn: $plainBordered)
                .toggleStyle(.plainBordered)
        }
    }
}

@available(macOS 14, *)
#Preview("Styles") {
    StylesDemo()
        .frame(width: 800, height: 650)
}
