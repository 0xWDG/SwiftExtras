//
//  DemoCatalog.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import SwiftUI

enum DemoCategory: String, CaseIterable, Identifiable {
    case overview
    case controls
    case containers
    case layouts
    case modifiers
    case styles
    case colorsAndImages
    case utilities
    case platform

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .overview: "Overview"
        case .controls: "Controls"
        case .containers: "Containers"
        case .layouts: "Layouts & Shapes"
        case .modifiers: "Modifiers & Effects"
        case .styles: "Styles"
        case .colorsAndImages: "Colors & Images"
        case .utilities: "Utilities & Data"
        case .platform: "Platform APIs"
        }
    }

    var systemImage: String {
        switch self {
        case .overview: "square.grid.2x2"
        case .controls: "switch.2"
        case .containers: "rectangle.3.group"
        case .layouts: "square.grid.3x3"
        case .modifiers: "wand.and.stars"
        case .styles: "paintbrush"
        case .colorsAndImages: "photo.on.rectangle.angled"
        case .utilities: "curlybraces"
        case .platform: "macbook.and.iphone"
        }
    }
}

@available(macOS 14, *)
struct DemoRootView: View {
    @State private var selection: DemoCategory? = .overview

    var body: some View {
        NavigationSplitView {
            List(DemoCategory.allCases, selection: $selection) { category in
                Label {
                    Text(category.title)
                } icon: {
                    Image(systemName: category.systemImage)
                }
                    .tag(category)
                    .accessibilityHint("Opens this SwiftExtras demo category")
            }
            .navigationTitle("SwiftExtras")
        } detail: {
            DemoDestination(category: selection ?? .overview)
        }
        .navigationSplitViewStyle(.balanced)
    }
}

@available(macOS 14, *)
struct DemoDestination: View {
    let category: DemoCategory

    @ViewBuilder
    var body: some View {
        switch category {
        case .overview:
            OverviewDemo()
        case .controls:
            ControlsDemo()
        case .containers:
            ContainersDemo()
        case .layouts:
            LayoutsDemo()
        case .modifiers:
            ModifiersDemo()
        case .styles:
            StylesDemo()
        case .colorsAndImages:
            ColorsAndImagesDemo()
        case .utilities:
            UtilitiesDemo()
        case .platform:
            PlatformDemo()
        }
    }
}
