//
//  highlight.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//
// Based on https://www.youtube.com/watch?v=5faifHbar2g
// Improvements:
// Sort on identifiers, and skip missing identifiers.
// added public/private declarations for docc rendering

import SwiftUI

/// Highlight represents a view that should be highlighted with a mask and additional information.
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public struct Highlight: Identifiable {
    /// The unique identifier for the highlight.
    public var id: Int

    /// The title of the highlight.
    public var title: LocalizedStringKey

    /// The description of the highlight.
    public var description: LocalizedStringKey?

    /// The shape used for masking the highlight.
    public var maskShape: AnyShape

    /// The inset for the highlight mask.
    public var inset: CGFloat

    /// The highlighted view's frame in global coordinates, converted relative to the overlay container when drawn.
    public var frame: CGRect
}

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
extension View {
    /// Highlight a view with a mask and add it to the specified group.
    /// Highlights the view with the specified parameters and adds it to the given group.
    ///
    /// - Parameters:
    ///   - order: The order of the highlight.
    ///   - title: The title of the highlight.
    ///   - description: The description of the highlight.
    ///   - maskShape: The shape used for masking the highlight.
    ///   - inset: The inset for the highlight mask.
    ///   - group: The binding to the group of highlights.
    @ContentBuilder
    public func highlight(
        order: Int,
        title: LocalizedStringKey,
        description: LocalizedStringKey?,
        maskShape: some Shape,
        inset: CGFloat = 15,
        group: Binding<[Int: Highlight]>
    ) -> some View {
        self
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .global)
            } action: { newValue in
                let highlight = Highlight(
                    id: order,
                    title: title,
                    description: description,
                    maskShape: AnyShape(maskShape),
                    inset: inset,
                    frame: newValue
                )
                group.wrappedValue[order] = highlight
            }
            .onDisappear {
                group.wrappedValue[order] = nil
            }
    }

    /// Overlay the highlights on top of the current view.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to whether the highlight overlay is presented.
    ///   - group: The binding to the group of highlights.
    /// - Returns: A view with the highlight overlay applied.
    @ContentBuilder
    public func highlightOverlay(
        isPresented: Binding<Bool>,
        group: Binding<[Int: Highlight]>
    ) -> some View {
#if os(macOS)
        self.overlay {
            if isPresented.wrappedValue {
                HighlightView(isPresented: isPresented, group: group)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity)
            }
        }
#else
        if #available(iOS 27, *) {
            self
                .fullScreenCover(isPresented: isPresented) {
                    HighlightView(isPresented: isPresented, group: group)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .presentationBackground(.clear)
#if os(iOS)
                        .navigationTransition(.crossFade)
#endif
                }
        } else {
            self
                .fullScreenCover(isPresented: isPresented) {
                    HighlightView(isPresented: isPresented, group: group)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                        .presentationBackground(.clear)
                }
        }
#endif
    }
}

private extension View {
    /// Applies an inverse mask using the supplied content.
    ///
    /// - Parameters:
    ///   - alignment: Alignment to use for the masking overlay.
    ///   - content: The masking shape to subtract from the view.
    /// - Returns: A view masked by subtracting `content` from a full-rect mask.
    @ContentBuilder
    func inverseMask<Content: View>(
        alignment: Alignment = .center,
        @ContentBuilder content: () -> Content
    ) -> some View {
        self
            .mask {
                Rectangle()
                    .overlay(alignment: alignment) {
                        content()
                            .blendMode(.destinationOut)
                    }
            }
    }
}

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
/// A view that displays the highlight overlay with an inverse mask and popover for the current highlight.
///
/// - Parameters:
///   - isPresented: A binding indicating whether the highlight overlay is presented.
///   - group: A binding to the dictionary of highlights keyed by their identifiers.
///   - currentHighlight: The currently active highlight, if any.
///   - containerFrame: The container's global frame, used to place highlights in its local coordinate space.
private struct HighlightView: View {
    @Binding var isPresented: Bool
    @Binding var group: [Int: Highlight]
    /// View Properties
    @State private var currentHighlight: Highlight?
    @State private var containerFrame: CGRect = .zero

    var body: some View {
        Rectangle()
            .fill(.black.opacity(0.7))
            .inverseMask(alignment: .topLeading) {
                if let currentHighlight {
                    let frame = currentHighlight.frame.offsetBy(
                        dx: -containerFrame.minX,
                        dy: -containerFrame.minY
                    )
                    let origin = frame.origin
                    let inset = currentHighlight.inset

                    currentHighlight
                        .maskShape
                        .frame(width: frame.width + inset, height: frame.height + inset)
                        .offset(x: origin.x - inset / 2, y: origin.y - inset / 2)
                }
            }
#if os(macOS)
            .overlay(alignment: .topLeading) {
                if let currentHighlight {
                    let frame = currentHighlight.frame.offsetBy(
                        dx: -containerFrame.minX,
                        dy: -containerFrame.minY
                    )
                    let inset = currentHighlight.inset
                    let cardWidth: CGFloat = 330
                    let horizontalPadding: CGFloat = 16
                    let xPosition = min(
                        max(frame.midX, cardWidth / 2 + horizontalPadding),
                        containerFrame.width - cardWidth / 2 - horizontalPadding
                    )
                    let yPosition = frame.midY < containerFrame.height / 2
                        ? frame.maxY + inset / 2 + 24
                        : frame.minY - inset / 2 - 24

                    popoverView(highlight: currentHighlight)
                        .frame(width: cardWidth)
                        .fixedSize(horizontal: false, vertical: true)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.separator.opacity(0.5))
                                .accessibilityHidden(true)
                        }
                        .shadow(color: .black.opacity(0.2), radius: 14, y: 6)
                        .position(x: xPosition, y: yPosition)
                }
            }
#elseif os(watchOS) || os(tvOS)
            .overlay {
                if let currentHighlight {
                    popoverView(highlight: currentHighlight)
                        .padding()
                        .background(Color.black.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
#else
            .overlay(alignment: .topLeading) {
                let frame = currentHighlight?.frame.offsetBy(
                    dx: -containerFrame.minX,
                    dy: -containerFrame.minY
                ) ?? .zero
                let origin = frame.origin
                let inset = currentHighlight?.inset ?? 0
                /// Using Only either top or bottom edge!
                let edge: Edge = origin.y > (containerFrame.height / 2) ? .bottom : .top

                Rectangle()
                    .foregroundStyle(.clear)
                    .frame(width: frame.width + inset, height: frame.height + inset)
                    /// Using Native SwiftUI Popover!
                    .popover(
                        item: $currentHighlight,
                        arrowEdge: edge
                    ) { highlight in
                        popoverView(highlight: highlight)
                            .frame(width: 330)
                            .presentationCompactAdaptation(.popover)
                            .interactiveDismissDisabled()
                    }
                    .offset(x: origin.x - inset / 2, y: origin.y - inset / 2)
            }
#endif
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .global)
            } action: { newValue in
                containerFrame = newValue
            }
            .task {
                try? await Task.sleep(for: .seconds(0.25))
                if let highlight = getNextItemInGroup(0) {
                    withAnimation(animation) {
                        currentHighlight = highlight
                    }
                } else {
                    withAnimation(animation) {
                        isPresented = false
                    }
                }
            }
    }

    /// Returns a styled button with the appropriate button style for the current platform.
    /// - Parameter button: The button view to style.
    /// - Returns: A view representing the styled button.
    @ViewBuilder
    private func styledButton<Content: View>(_ button: Content) -> some View {
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            button.buttonStyle(.glassProminent)
        } else {
            button.buttonStyle(.borderedProminent)
        }
    }

    /// Applies a capsule border shape on platform versions that support it.
    /// - Parameter button: The button view to shape.
    /// - Returns: The button with a capsule shape when available.
    @ViewBuilder
    private func capsuleButton<Content: View>(_ button: Content) -> some View {
#if os(tvOS)
        if #available(tvOS 17, *) {
            button.buttonBorderShape(.capsule)
        } else {
            button
        }
#elseif os(macOS)
        if #available(macOS 14, *) {
            button.buttonBorderShape(.capsule)
        } else {
            button
        }
#else
        button.buttonBorderShape(.capsule)
#endif
    }

    /// Returns the view for the popover corresponding to the given highlight.
    /// - Parameter highlight: The highlight to display in the popover.
    /// - Returns: A view representing the popover content.
    @ContentBuilder
    private func popoverView(highlight: Highlight) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("\(getHumanIndex(highlight: highlight)) of \(group.count)", bundle: .module)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(highlight.title)
                    .font(.title3.bold())
                    .lineLimit(1)

                if let description = highlight.description {
                    Text(description)
                        .lineLimit(4)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.bottom, 4)

            HStack {
                Button {
                    isPresented = false
                } label: {
                    Text("Skip", bundle: .module)
                }
                .tint(.secondary)

                Spacer(minLength: 0)

                let nextItem = nextHighlight(after: highlight)
                let isLast = nextItem == nil

                let button = Button {
                    if isLast {
                        isPresented = false
                    } else {
                        withAnimation(animation) {
                            currentHighlight = nextItem
                        }
                    }
                } label: {
                    Text(isLast ? "Finish" : "Next", bundle: .module)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 4)
                }

                capsuleButton(styledButton(button))
            }
        }
        .padding(20)
    }

    /// Returns the 1-based index of the given highlight within the sorted group.
    ///
    /// Do not use positional dictionary lookups for the public counter.
    /// Highlights can be keyed by any Int value (including sparse ranges).
    ///
    /// - Parameter highlight: The highlight to find the index for.
    /// - Returns: The 1-based index, or the total count if not found.
    private func getHumanIndex(highlight: Highlight) -> Int {
        sortedHighlightKeys.firstIndex(of: highlight.id).map { $0 + 1 } ?? group.count
    }

    /// Returns highlight identifiers in the order they should be presented.
    ///
    /// The key is the user-provided ordering identifier and may be sparse.
    private var sortedHighlightKeys: [Int] {
        group.keys.sorted()
    }

    /// Returns the first highlight whose identifier is greater than or equal to `identifier`.
    ///
    /// - Parameter identifier: The starting identifier to search from.
    /// - Returns: The next available highlight, or `nil` when none exists.
    private func getNextItemInGroup(_ identifier: Int) -> Highlight? {
        guard let nextKey = sortedHighlightKeys.first(
            where: { $0 >= identifier }
        ) else {
            return nil
        }

        return group[nextKey]
    }

    /// Returns the highlight that follows `highlight` in presentation order.
    ///
    /// - Parameter highlight: The current highlight being shown.
    /// - Returns: The next highlight, or `nil` when `highlight` is the last one.
    private func nextHighlight(after highlight: Highlight) -> Highlight? {
        let keys = sortedHighlightKeys
        guard let currentIndex = keys.firstIndex(of: highlight.id) else {
            return getNextItemInGroup(highlight.id + 1)
        }

        let nextIndex = keys.index(after: currentIndex)
        guard nextIndex < keys.endIndex else {
            return nil
        }

        return group[keys[nextIndex]]
    }

    /// Initial Delay
    private var initialDelay: Double {
        0.25
    }

    /// Animation Value
    private var animation: Animation {
        .interpolatingSpring(duration: 0.25, bounce: 0, initialVelocity: 0)
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
#Preview {
    @Previewable @State var showHighlightView: Bool = false
    @Previewable @State var group: [Int: Highlight] = [:]
    NavigationStack {
        List {
            Text("First")
                .highlight(
                    order: 20,
                    title: "This is the first row",
                    description: "And the latest highlight, it is number 20 :)",
                    maskShape: .rect(cornerRadius: 14),
                    /// Use inset to enlarge the masking shape!
                    inset: 30,
                    group: $group
                )
            ForEach(0...20, id: \.self) {
                Text("\($0)")
            }
        }
        .navigationTitle("Highlight view demo")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {

                } label: {
                    Image(systemName: "chart.pie.fill")
                }
                .highlight(
                    order: 0,
                    title: "Switch to pie chart",
                    description: "Switch to a pie chart :)",
                    maskShape: .circle,
                    group: $group
                )
            }

            ToolbarItem(placement: .automatic) {
                Button {
                    showHighlightView = true
                } label: {
                    Image(systemName: "plus")
                }
                .highlight(
                    order: 3,
                    title: "Add item",
                    description: "Add a new row to this demo",
                    maskShape: .circle,
                    /// Use inset to enlarge the masking shape!
                    inset: 30,
                    group: $group
                )
            }
        }
        .task {
            showHighlightView = true
        }
        .highlightOverlay(isPresented: $showHighlightView, group: $group)
    }
}
// swiftlint:disable:this file_length
