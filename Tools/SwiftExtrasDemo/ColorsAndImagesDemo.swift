//
//  ColorsAndImagesDemo.swift
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

struct DemoColorSwatch: Identifiable {
    let id: String
    let color: Color
}

@available(macOS 14, *)
struct ColorsAndImagesDemo: View {
    var body: some View {
        DemoPage(
            "Colors & Images",
            summary: "Semantic colors, conversion, accessibility simulation, image rendering, cropping, and clustering."
        ) {
            SemanticColorsDemo()
            ColorComponentsDemo()
            ColorVisionDemo()
            ColorClusteringDemo()
            ImageExtensionsDemo()
            ImageRenderingDemo()
        }
    }
}

@available(macOS 14, *)
struct SemanticColorsDemo: View {
    private let colors = [
        DemoColorSwatch(id: "label", color: .label),
        DemoColorSwatch(id: "secondaryLabel", color: .secondaryLabel),
        DemoColorSwatch(id: "systemBlue", color: .systemBlue),
        DemoColorSwatch(id: "systemGreen", color: .systemGreen),
        DemoColorSwatch(id: "systemOrange", color: .systemOrange),
        DemoColorSwatch(id: "systemRed", color: .systemRed),
        DemoColorSwatch(id: "systemGray", color: .systemGray)
    ]

    var body: some View {
        DemoPanel("Semantic and initialized colors", systemImage: "paintpalette.fill") {
            HStack(spacing: 8) {
                ForEach(colors) { swatch in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(swatch.color)
                        .frame(height: 76)
                        .accessibilityLabel(swatch.id)
                }
            }

            HStack(spacing: 8) {
                Color(hex: "#5B5BD6")
                    .accessibilityLabel("Color initialized from hexadecimal")
                Color(red: 0.2, green: 0.7, blue: 0.4, alpha: 1)
                    .accessibilityLabel("Color initialized from RGB components")
                Color(light: .yellow, dark: .indigo)
                    .accessibilityLabel("Dynamic light and dark color")
                Color.random
                    .accessibilityLabel("Random color")
            }
            .frame(height: 76)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Text("Gradient foreground")
                .font(.largeTitle.bold())
                .foregroundLinearGradient(colors: [.purple, .blue, .mint])
        }
    }
}

@available(macOS 14, *)
struct ColorComponentsDemo: View {
    private let color = Color(hex: "#3478D4")

    var body: some View {
        DemoPanel("Components, contrast, and coding", systemImage: "slider.horizontal.3") {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .overlay {
                        Text("Contrast")
                            .foregroundStyle(color.contrast)
                    }
                    .accessibilityLabel("Original color with calculated contrast text")
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.complementary)
                    .accessibilityLabel("Complementary color")
            }
            .frame(height: 100)

            DemoValueRow(label: "HEX", value: color.hex)
            DemoValueRow(label: "HEX with alpha", value: color.hex8)
            DemoValueRow(label: "RGB", value: color.rgbString())
            DemoValueRow(label: "HSB", value: color.hsbString())
            DemoValueRow(label: "HSL", value: color.hslString())
            DemoValueRow(label: "XYZ", value: color.xyzString())
            DemoValueRow(label: "LAB", value: color.labString())
            DemoValueRow(
                label: "Luminance",
                value: color.luminance.formatted(.number.precision(.fractionLength(4)))
            )
            DemoValueRow(label: "RawRepresentable bytes", value: color.rawValue.count.formatted())
        }
    }
}

@available(macOS 14, *)
struct ColorVisionDemo: View {
    private let colors = [
        DemoColorSwatch(id: "Original", color: .orange),
        DemoColorSwatch(id: "Protanopia", color: Color.orange.protanopia),
        DemoColorSwatch(id: "Deuteranopia", color: Color.orange.deuteranopia),
        DemoColorSwatch(id: "Tritanopia", color: Color.orange.tritanopia),
        DemoColorSwatch(id: "Inverted", color: Color.orange.inverted)
    ]

    var body: some View {
        DemoPanel("Color-vision transformations", systemImage: "eye") {
            HStack(spacing: 10) {
                ForEach(colors) { swatch in
                    VStack {
                        Circle()
                            .fill(swatch.color)
                            .frame(width: 56, height: 56)
                            .accessibilityHidden(true)
                        Text(swatch.id)
                            .font(.caption)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }
}

@available(macOS 14, *)
struct ColorClusteringDemo: View {
    private let sourceSwatches = [
        DemoColorSwatch(id: "red", color: .red),
        DemoColorSwatch(id: "orange", color: .orange),
        DemoColorSwatch(id: "yellow", color: .yellow),
        DemoColorSwatch(id: "green", color: .green),
        DemoColorSwatch(id: "mint", color: .mint),
        DemoColorSwatch(id: "blue", color: .blue),
        DemoColorSwatch(id: "indigo", color: .indigo),
        DemoColorSwatch(id: "purple", color: .purple),
        DemoColorSwatch(id: "pink", color: .pink)
    ]

    var body: some View {
        let sourceColors = sourceSwatches.map(\.color)
        let clusteredColors = kMeansCluster(colors: sourceColors, clusters: 3)
        let clusteredSwatches = clusteredColors.enumerated().map { index, color in
            DemoColorSwatch(id: "cluster-\(index)", color: color)
        }

        DemoPanel("K-Means color clustering", systemImage: "circle.hexagongrid.fill") {
            ColorRow(swatches: sourceSwatches, label: "Source palette")
            ColorRow(swatches: clusteredSwatches, label: "Three centroids")
        }
    }
}

@available(macOS 14, *)
struct ColorRow: View {
    let swatches: [DemoColorSwatch]
    let label: LocalizedStringResource

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.headline)
            HStack(spacing: 5) {
                ForEach(swatches) { swatch in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(swatch.color)
                        .frame(height: 52)
                        .accessibilityLabel(swatch.id)
                }
            }
        }
    }
}

@available(macOS 14, *)
struct ImageExtensionsDemo: View {
    @State private var backgroundRemovedImage: Image?

    var body: some View {
        DemoPanel("Image extensions", systemImage: "photo") {
            HStack(spacing: 24) {
                Image(systemName: "mountain.2.fill")
                    .centerCropped()
                    .foregroundStyle(.teal)
                    .frame(width: 180, height: 110)
                    .background(.teal.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityLabel("Center-cropped mountain symbol")

                Image(systemName: "photo.fill")
                    .square()
                    .foregroundStyle(.blue)
                    .frame(width: 110)
                    .accessibilityLabel("Square image")

                if let backgroundRemovedImage {
                    backgroundRemovedImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .accessibilityLabel("Image with background removed")
                }
            }

            Button("Run background removal") {
                backgroundRemovedImage = Image(systemName: "person.crop.square.fill").removeBackground()
            }
            .accessibilityHint("Uses Vision to isolate the foreground of a symbol image")
        }
    }
}

@available(macOS 14, *)
struct ImageRenderingDemo: View {
    @Environment(\.displayScale) private var displayScale
    @State private var renderedImage: PlatformImage?
    @State private var snapshotImage: PlatformImage?

    var body: some View {
        DemoPanel("Render, snapshot, and PNG conversion", systemImage: "camera.viewfinder") {
            let source = Label("Rendered source", systemImage: "sparkles")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .padding()
                .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 14))

            source

            HStack {
                Button("Render") {
                    if let image = source.render(scale: displayScale) {
                        renderedImage = image
                    }
                }
                Button("Snapshot") {
                    let image = source.snapshot(size: CGSize(width: 240, height: 70))
                    snapshotImage = image
                }
            }

            HStack(spacing: 16) {
                if let renderedImage {
                    Image(platformImage: renderedImage)
                        .accessibilityLabel("Rendered SwiftUI view")
                }
                if let snapshotImage {
                    Image(platformImage: snapshotImage)
                        .accessibilityLabel("Snapshotted SwiftUI view")
                }
            }
        }
    }
}

@available(macOS 14, *)
#Preview("Colors and Images") {
    ColorsAndImagesDemo()
        .frame(width: 900, height: 700)
}
