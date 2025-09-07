//
//  CarouselView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-09-06.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// Carousel View
///
/// This view displays a horizontal scrolling carousel of images.
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
public struct CarouselView: View {
    /// Current tab index
    @State private var currentTabIndex = 0

    /// Screen width & height
    @State private var width: CGFloat = .infinity

    /// Images to display
    private var items: [Image]?

    /// URLs to load
    private var urls: [URL]?

    /// Items
    private var itemCount: Int {
        items?.count ?? urls?.count ?? 0
    }

    /// Carousel View
    ///
    /// This view displays a horizontal scrolling carousel of images.
    ///
    /// - Parameter items: An array of images to display in the carousel.
    public init(items: [Image]) {
        self.items = items
    }

    /// Carousel View
    ///
    /// This view displays a horizontal scrolling carousel of images.
    ///
    /// - Parameter items: An array of images to display in the carousel.
    public init(urls: [URL]) {
        self.urls = urls
    }

    /// View body
    public var body: some View {
        TabView(selection: $currentTabIndex) {
            if let items {
                ForEach(items.indices, id: \.self) { index in
                    items[index]
                        .resizable()
                        .tag(index)
                }
            } else if let urls {
                ForEach(urls.indices, id: \.self) { index in
                    AsyncImage(url: urls[index]) {
                        $0.resizable()
                    } placeholder: {
                        ProgressView()
                            .controlSize(.large)
                    }
                    .tag(index)
                }
            }
        }
#if !os(macOS)
        .tabViewStyle(.page(indexDisplayMode: .never))
#else
        .toolbar(.hidden, for: .automatic)
#endif
        .overlay {
            VStack(spacing: 0) {
                if itemCount != 0 {
                    stepper
                        .padding(.all, 8)
                }

                HStack(spacing: 0) {
                    VStack { Color.clear }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .background(.clear.opacity(0.4))
                    .onTapGesture {
                        currentTabIndex -= 1
                    }
                    .accessibilityAddTraits(.isButton)

                    VStack { Color.clear }
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.clear.opacity(0.4))
                    .onTapGesture {
                        currentTabIndex += 1
                    }
                    .accessibilityAddTraits(.isButton)
                }
            }
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.width
            } action: { newValue in
                width = newValue
            }
        }
        .frame(
            width: width,
            height: width == .infinity ? 500 : width
        )
        .accessibilityIdentifier("CarouselView")
        .onChange(of: currentTabIndex, perform: { _ in
            if currentTabIndex == itemCount {
                currentTabIndex = 0
            } else if currentTabIndex == -1 {
                currentTabIndex = itemCount - 1
            }
        })
    }

    var stepper: some View {
        HStack(spacing: 8) {
            ForEach(0..<itemCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        currentTabIndex == index
                        ? Color.accentColor
                        : .gray.opacity(0.3)
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 6)
                    .onTapGesture {
                        currentTabIndex = index
                    }
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("Go to the \(index) image.")
            }
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    NavigationStack {
        VStack {
            Divider()

            CarouselView(items: [
                .init(systemName: "star"),
                .init(systemName: "rainbow")
            ])
            .background(Color.red)
            .frame(width: 300, height: 300)
            Spacer()
        }

        Form {
            Section {
                CarouselView(items: [
                    .init(systemName: "star"),
                    .init(systemName: "rainbow")
                ])
            }
        }
        .tint(Color.red)
    }
}
#endif
#endif
