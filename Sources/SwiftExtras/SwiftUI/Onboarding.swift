//
//  Onboarding.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//
//  Heavily based on https://www.youtube.com/watch?v=mmiJhUGaR1Q
//  Improvement: Make this working on MacOS as well.

#if canImport(SwiftUI) && canImport(UIKit) && os(iOS)
import SwiftUI
import UIKit

/// Onboarding Item
private struct OnboardingItem: Identifiable {
    var id: Int
    var view: AnyView
    var maskLocation: CGRect
    var cornerRadius: CGFloat
}

/// Onboarding Coordinator
@available(iOS 17.0, *)
@Observable
private class OnboardingCoordinator {
    var items: [OnboardingItem] = []
    var overlayWindow: PlatformWindow?
    var isOnboardingFinished: Bool = false

    /// Ordered-Items
    var orderedItems: [OnboardingItem] {
        items.sorted { $0.id < $1.id }
    }
}

/// Onboarding View
///
/// Wrap your main view with this Onboarding View and mark the items you want to \
/// highlight with the `.OnboardingItem` modifier.
/// The Onboarding will automatically show up when the app is launched for the first time.
/// You can use the `appStorageID` to reset the Onboarding as well.
/// You can also pass a closure to do some work before the Onboarding starts with the `beginOnboarding` parameter.
/// You can also pass a closure to do some work after the Onboarding finishes with the `OnboardingFinished` parameter.
/// Example:
/// ```swift
/// Onboarding(appStorageID: "Onboarding") {
///     NavigationStack {
///         Form {
///             Text("Item 1")
///                 .onboardingItem(1) {
///                     Text("Test item 1")
///                 }
///             Text("Item 2")
///                 .onboardingItem(2) {
///                     Text("Test item 2")
///                 }
///             Text("Item 3")
///                 .onboardingItem(3) {
///                     Text("Test item 3")
///                 }
///         }
///     }
/// }
/// ```
@available(iOS 17, *)
public struct Onboarding<Content: View>: View {
    @AppStorage var isOnboarded: Bool
    var content: Content
    /// Allows you to do job before animating the Onboarding effect!
    var beginOnboarding: () async -> Void
    var finishedOnboarding: () -> Void

    /// Initializer
    /// 
    /// - Parameters:
    ///   - appStorageID: The ID to store the Onboarding state in UserDefaults.
    ///   - content: The main content view.
    ///   - beginOnboarding: A closure that is called before the Onboarding starts. (default is empty)
    ///   - finishedOnboarding: A closure that is called after the Onboarding finishes. (default is empty)
    public init(
        appStorageID: String,
        @ViewBuilder content: @escaping () -> Content,
        beginOnboarding: @escaping () async -> Void = { },
        finishedOnboarding: @escaping () -> Void = { }
    ) {
        /// Initializing User-Defaults!
        self._isOnboarded = .init(
            wrappedValue: false,
            appStorageID
        )
        self.content = content()
        self.beginOnboarding = beginOnboarding
        self.finishedOnboarding = finishedOnboarding
    }

    fileprivate var coordinator = OnboardingCoordinator()
    public var body: some View {
        content
            .environment(coordinator)
            .task {
                if !isOnboarded {
                    await beginOnboarding()
                }
                await createWindow()
            }
            .onChange(of: coordinator.isOnboardingFinished) { _, newValue in
                if newValue {
                    print("IS FINISHED!")
                    isOnboarded = true
                    finishedOnboarding()
                    hideWindow()
                }
            }
    }

    private func createWindow() async {
        if let scene = (UIApplication.shared.connectedScenes.first as? UIWindowScene),
           !isOnboarded, coordinator.overlayWindow == nil {
            if let window = scene.windows.first(where: { $0.tag == 1009 }) {
                window.rootViewController = nil
                window.isHidden = false
                window.isUserInteractionEnabled = true
                coordinator.overlayWindow = window
            } else {
                let window = UIWindow(windowScene: scene)
                window.backgroundColor = .clear
                window.isHidden = false
                window.isUserInteractionEnabled = true
                window.tag = 1009

                coordinator.overlayWindow = window
            }

            // A Little delay to load the items into the coordinator object using the onGeometryChange modifier!
            // 0.5 seems to work in all my test cases
            try? await Task.sleep(for: .seconds(0.5))
            if coordinator.items.isEmpty {
                hideWindow()
            } else {
                guard let snapshot = snapshotScreen() else {
                    hideWindow()
                    return
                }

                let hostController = UIHostingController(
                    rootView: OverlayWindowView(snapshot: snapshot).environment(coordinator)
                )
                hostController.view.backgroundColor = .clear
                coordinator.overlayWindow?.rootViewController = hostController
            }
        }
    }

    private func hideWindow() {
        coordinator.overlayWindow?.rootViewController = nil
        coordinator.overlayWindow?.isHidden = true
        coordinator.overlayWindow?.isUserInteractionEnabled = false
    }
}

extension View {
    /// Onboarding Item Modifier
    /// Mark the views you want to highlight with this modifier.
    /// - Parameters:
    ///   - position: The position of the item in the Onboarding sequence.
    ///   - cornerRadius: The corner radius of the highlighted item. (default is 35)
    ///   - content: The content view to display in the Onboarding overlay.
    /// - Returns: A view with the Onboarding item modifier applied.
    @available(iOS 17, *)
    @ViewBuilder public func onboardingItem<Content: View>(
        _ position: Int,
        cornerRadius: CGFloat = 35,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .modifier(
                OnboardingItemSetter(
                    position: position,
                    cornerRadius: cornerRadius,
                    onboardingContent: content
                )
            )
    }
}

/// Onboarding Item-Setter
@available(iOS 17.0, *)
private struct OnboardingItemSetter<ContentView: View>: ViewModifier {
    var position: Int
    var cornerRadius: CGFloat
    @ViewBuilder var onboardingContent: ContentView

    @Environment(OnboardingCoordinator.self) var coordinator

    func body(content: Content) -> some View {
        content
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .global)
            } action: { newValue in
                coordinator.items.removeAll(where: { $0.id == position })

                let newItem = OnboardingItem(
                    id: position,
                    view: .init(onboardingContent),
                    maskLocation: newValue,
                    cornerRadius: cornerRadius
                )
                coordinator.items.append(newItem)
            }
            .onDisappear {
                coordinator.items.removeAll(where: { $0.id == position })
            }
    }
}

/// Overlay Window View (Animation View)
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
private struct OverlayWindowView: View {
    var snapshot: UIImage
    @Environment(OnboardingCoordinator.self) var coordinator
    /// View Properties
    @State private var animate: Bool = false
    @State private var currentIndex: Int = 0
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let isHomeButtoniPhone = safeArea.bottom == 0
            let cornerRadius: CGFloat = isHomeButtoniPhone ? 15 : 35

            ZStack {
                Rectangle()
                    .fill(.black)

                Image(uiImage: snapshot)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .accessibilityHidden(true)
                    .overlay {
                        Rectangle()
                            .fill(.black.opacity(0.5))
                            .reverseMask(alignment: .topLeading) {
                                if !orderedItems.isEmpty {
                                    let maskLocation = orderedItems[currentIndex].maskLocation
                                    let cornerRadius = orderedItems[currentIndex].cornerRadius

                                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                                        .frame(width: maskLocation.width, height: maskLocation.height)
                                        .offset(
                                            x: maskLocation.minX,
                                            y: maskLocation.minY
                                        )
                                }
                            }
                            .opacity(animate ? 1 : 0)
                    }
                    .clipShape(.rect(cornerRadius: animate ? cornerRadius : 0, style: .circular))
                    .overlay {
                        iPhoneShape(safeArea)
                    }
                    .scaleEffect(animate ? 0.65 : 1, anchor: .top)
                    .offset(y: animate ? safeArea.top + 25 : 0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(alignment: .bottom) {
                        bottomView(safeArea)
                    }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            guard !animate else { return }
            withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                animate = true
            }
        }
    }

    @ViewBuilder
    private func iPhoneShape(_ safeArea: EdgeInsets) -> some View {
        let isHomeButtoniPhone = safeArea.bottom == 0
        let cornerRadius: CGFloat = isHomeButtoniPhone ? 20 : 45

        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: animate ? cornerRadius : 0, style: .continuous)
                .stroke(Color.accentColor, lineWidth: animate ? 5 : 0)

            if safeArea.bottom != 0 {
                Capsule()
                    .fill(.black)
                    .frame(width: 120, height: 40)
                    .offset(y: 20)
                    .opacity(animate ? 1 : 0)
            }
        }
    }

    @ViewBuilder
    private func bottomView(_ safeArea: EdgeInsets) -> some View {
        // swiftlint:disable:previous function_body_length
        VStack(spacing: 10) {
            ZStack {
                ForEach(orderedItems) { info in
                    if currentIndex == orderedItems.firstIndex(where: { $0.id == info.id }) {
                        info.view
                            .transition(.blurReplace)
                            .environment(\.colorScheme, .dark)
                    }
                }
            }
            .frame(height: 70)
            .frame(maxWidth: 280)

            HStack(spacing: 6) {
                if currentIndex > 0 {
                    Button {
                        withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                            currentIndex = max((currentIndex - 1), 0)
                        }
                    } label: {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 38))
                            .foregroundStyle(.white, .gray.opacity(0.4))
                            .accessibilityLabel("Previous")
                    }
                }

                Button {
                    if currentIndex == orderedItems.count - 1 {
                        closeWindow()
                    } else {
                        withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                            currentIndex += 1
                        }
                    }
                } label: {
                    Text(currentIndex == orderedItems.count - 1 ? "Finish" : "Next")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .contentTransition(.numericText())
                        .foregroundStyle(.white)
                        .padding(.vertical, 10)
                        .background(Color.accentColor.gradient, in: .capsule)
                }
            }
            .frame(maxWidth: 250)
            .frame(height: 50)
            .padding(.leading, currentIndex > 0 ? -45 : 0)

            Button(action: closeWindow) {
                Text("Skip Tutorial")
                    .font(.callout)
                    .underline()
            }
            .foregroundStyle(.gray)
        }
        .padding(.horizontal, 15)
        .padding(.bottom, safeArea.bottom + 10)
    }

    private func closeWindow() {
        withAnimation(.easeInOut(duration: 0.25), completionCriteria: .removed) {
            animate = false
        } completion: {
            print("Close window")
            coordinator.isOnboardingFinished = true
        }
    }

    var orderedItems: [OnboardingItem] {
        coordinator.orderedItems
    }
}

extension View {
    /// Snapshoting the screen
    fileprivate func snapshotScreen() -> UIImage? {
        if let snaposhotView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            let renderer: UIGraphicsImageRenderer = UIGraphicsImageRenderer(size: snaposhotView.bounds.size)
            let image: UIImage = renderer.image { _ in
                snaposhotView.drawHierarchy(in: snaposhotView.bounds, afterScreenUpdates: true)
            }

            return image
        }

        return nil
    }

    /// Reverse Mask
    @ViewBuilder
    fileprivate func reverseMask<Content: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
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

#if DEBUG
@available(iOS 17, *)
#Preview {
    Onboarding(appStorageID: UUID().uuidString) {
        NavigationStack {
            Form {
                Text("Item 1")
                    .onboardingItem(0) {
                        Text("Test item 1")
                    }
                Text("Item 2")
                    .onboardingItem(2) {
                        Text("Test item 2")
                    }
                Text("Item 3")
                    .onboardingItem(3) {
                        Text("Test item 3")
                    }
            }
        }
    }
}
#endif
#endif
// swiftlint:disable:this file_length
