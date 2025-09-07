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
        GeometryReader { proxy in
            let size = proxy.size
            let square = max(0, min(size.width, size.height == 0 ? size.width : size.height))

            TabView(selection: $currentTabIndex) {
                if let items {
                    ForEach(items.indices, id: \.self) { index in
                        items[index]
                            .resizable()
                            .scaledToFill()
                            .frame(width: square, height: square)
                            .clipped()
                            .tag(index)
                    }
                } else if let urls {
                    ForEach(urls.indices, id: \.self) { index in
                        AsyncImage(url: urls[index]) {
                            $0.resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                                .controlSize(.large)
                        }
                        .frame(width: square, height: square)
                        .clipped()
                        .tag(index)
                    }
                } else {
                    Color.clear
                        .frame(width: square, height: square)
                        .tag(0)
                }
            }
#if !os(macOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
#else
            .toolbar(.hidden, for: .automatic)
#endif
            .overlay {
                VStack(spacing: 0) {
                    if itemCount > 1 {
                        stepper
                            .padding(.all, 8)
                    }

                    HStack(spacing: 0) {
                        VStack { Color.clear }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .contentShape(Rectangle())
                            .background(.clear.opacity(0.4))
                            .onTapGesture {
                                guard itemCount > 0 else { return }
                                currentTabIndex -= 1
                            }
                            .accessibilityAddTraits(.isButton)

                        VStack { Color.clear }
                            .contentShape(Rectangle())
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.clear.opacity(0.4))
                            .onTapGesture {
                                guard itemCount > 0 else { return }
                                currentTabIndex += 1
                            }
                            .accessibilityAddTraits(.isButton)
                    }
                }
            }
            .frame(width: square, height: square, alignment: .center)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .accessibilityIdentifier("CarouselView")
            .onChange(of: currentTabIndex, perform: { _ in
                guard itemCount > 0 else {
                    currentTabIndex = 0
                    return
                }
                if currentTabIndex >= itemCount {
                    currentTabIndex = 0
                } else if currentTabIndex < 0 {
                    currentTabIndex = itemCount - 1
                }
            })
        }
        .aspectRatio(1, contentMode: .fit)
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
