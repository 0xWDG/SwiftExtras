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
public struct CarouselView: View {
    /// Current tab index
    @State private var currentTabIndex = 0
    /// Images to display
    private var items: [Image]

    /// Carousel View
    ///
    /// This view displays a horizontal scrolling carousel of images.
    ///
    /// - Parameter items: An array of images to display in the carousel.
    public init(items: [Image]) {
        self.items = items
    }

    /// View body
    public var body: some View {
        TabView(selection: $currentTabIndex) {
            ForEach(items.indices, id: \.self) { index in
                items[index]
                    .resizable()
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay {
            VStack(spacing: 0) {
                stepper
                    .padding(.all, 8)

                HStack(spacing: 0) {
                    Button {
                        currentTabIndex -= 1
                    } label: {
                        Color.clear
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .background(.clear.opacity(0.4))

                    Button {
                        currentTabIndex += 1
                    } label: {
                        Color.clear
                    }
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity)
                    .background(.clear.opacity(0.4))
                }
            }
        }
        .accessibilityIdentifier("CarouselView")
        .onChange(of: currentTabIndex, perform: { _ in
            if currentTabIndex == items.count {
                currentTabIndex = 0
            } else if currentTabIndex == -1 {
                currentTabIndex = items.count - 1
            }
        })
    }

    var stepper: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< items.count, id: \.self) { index in
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
    }
}
#endif
#endif
