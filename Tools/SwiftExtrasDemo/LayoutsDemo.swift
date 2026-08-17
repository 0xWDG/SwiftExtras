//
//  LayoutsDemo.swift
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
struct LayoutsDemo: View {
    private let tags = [
        DemoTag(id: "swiftui", title: "SwiftUI", systemImage: "swift"),
        DemoTag(id: "layouts", title: "Layouts", systemImage: "square.grid.3x3"),
        DemoTag(id: "modifiers", title: "Modifiers", systemImage: "wand.and.stars"),
        DemoTag(id: "styles", title: "Styles", systemImage: "paintbrush"),
        DemoTag(id: "utilities", title: "Utilities", systemImage: "curlybraces"),
        DemoTag(id: "platforms", title: "Platforms", systemImage: "macbook.and.iphone")
    ]

    var body: some View {
        DemoPage(
            "Layouts & Shapes",
            summary: "Wrapping layouts, sticky content, geometry helpers, and custom shapes."
        ) {
            FlowLayoutDemo(tags: tags)
            WStackLayoutDemo(tags: tags)
            StickySectionDemo()
            GeometryAndShapeDemo()
        }
    }
}

@available(macOS 14, *)
struct FlowLayoutDemo: View {
    let tags: [DemoTag]

    var body: some View {
        DemoPanel("Flow", systemImage: "arrow.turn.down.right") {
            Flow(lineAlignment: .center, spacing: CGSize(width: 8, height: 8)) {
                ForEach(tags) { tag in
                    Label(tag.title, systemImage: tag.systemImage)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.blue.opacity(0.12), in: Capsule())
                }
            }
            .frame(maxWidth: 520, alignment: .leading)
        }
    }
}

@available(macOS 14, *)
struct WStackLayoutDemo: View {
    let tags: [DemoTag]

    var body: some View {
        DemoPanel("WStack", systemImage: "rectangle.split.3x1") {
            WStack(spacing: 8) {
                ForEach(tags) { tag in
                    Text(tag.title)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(.green.opacity(0.14), in: Capsule())
                }
            }
            .frame(maxWidth: 440, minHeight: 100, alignment: .topLeading)
        }
    }
}

@available(macOS 14, *)
struct StickySectionDemo: View {
    var body: some View {
        DemoPanel("StickySection and stretchy header", systemImage: "pin.fill") {
            ScrollView {
                LinearGradient(colors: [.indigo, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .overlay {
                        Text("Pull to stretch")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                    }
                    .asStretchyHeader(startingHeight: 180)
                    .accessibilityLabel("Stretchy gradient header")

                StickySection {
                    ForEach(1...8, id: \.self) { index in
                        Label("Layout item \(index)", systemImage: "square.grid.2x2")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 6)
                    }
                } header: {
                    Text("Full sticky header")
                        .font(.title2.bold())
                } minimizedHeader: {
                    Text("Sticky")
                        .font(.headline)
                }
            }
            .frame(height: 420)
        }
    }
}

@available(macOS 14, *)
struct GeometryAndShapeDemo: View {
    @State private var measuredSize = CGSize.zero
    @State private var measuredFrame = CGRect.zero

    var body: some View {
        DemoPanel("HexShape and geometry readers", systemImage: "hexagon") {
            HStack(spacing: 24) {
                HexShape()
                    .fill(.purple.gradient)
                    .frame(width: 120, height: 135)
                    .accessibilityLabel("Purple hexagon")

                Text("Measured content")
                    .padding()
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                    .saveSize(in: $measuredSize)
                    .read(frame: $measuredFrame)
                    .horizontallyCentered()
            }

            DemoValueRow(label: "Size", value: measuredSize.debugDescription)
            DemoValueRow(label: "Global frame", value: measuredFrame.debugDescription)
        }
    }
}

@available(macOS 14, *)
#Preview("Layouts") {
    LayoutsDemo()
        .frame(width: 900, height: 700)
}
