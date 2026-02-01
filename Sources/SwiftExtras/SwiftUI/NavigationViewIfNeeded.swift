//
//  NavigationViewIfNeeded.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

// Source: https://www.joshholtz.com/blog/2025/02/08/swiftui-navigation-view-if-needed.html
#if canImport(SwiftUI)
import SwiftUI

/// This minimal view does a check if the view is visible rendered
struct ZeroFrameDetectionView: View {
    @Environment(\.isPresented) private var isPresented
    let didDetect: (Bool) -> Void

    @State private var hasReported = false

    var body: some View {
        Rectangle()
            .frame(width: 0, height: 0)
            .onChange(of: isPresented) { newValue in
                if newValue {
                    self.report(true)
                }
            }
            .onAppear {
                // Dispatch once after SwiftUI lay out
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    self.report(false)
                }
            }
    }

    private func report(_ value: Bool) {
        guard !self.hasReported else { return }
        self.hasReported = true
        self.didDetect(value)
    }
}

/// NavigationViewIfNeeded
/// NavigationViewIfNeeded wraps content in a NavigationView
/// only if it is not already in a NavigationView.
/// This is useful for views that need a toolbar
/// but can be used both in and out of a NavigationView.
/// Example:
/// ```swift
/// NavigationViewIfNeeded {
///     MyView()
/// }
/// ```
public struct NavigationViewIfNeeded<Content: View>: View {
    enum Status {
        case unknown
        case inNav
        case notInNav
    }

    @State private var status: Status = .unknown

    let content: Content

    /// NavigationViewIfNeeded
    /// NavigationViewIfNeeded wraps content in a NavigationView
    /// only if it is not already in a NavigationView.
    /// This is useful for views that need a toolbar
    /// but can be used both in and out of a NavigationView.
    ///
    /// Example:
    /// ```swift
    /// NavigationViewIfNeeded {
    ///     MyView()
    /// }
    /// ```
    ///
    /// - Parameter content: Content to wrap
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    /// Body of NavigationViewIfNeeded
    public var body: some View {
        Group {
            switch status {
            case .unknown:
                let _ = print("[NVIN] Detect")
                // This is where we wait for a (hopefully quick) response
                // if the view is in a navigation view or not
                Rectangle()
                    .frame(width: 0, height: 0)
                    .toolbar {
                        // Zero-sized detection view:
                        ZeroFrameDetectionView { isInNav in
                            // The first time we know the answer, store it
                            if status == .unknown {
                                status = isInNav ? .inNav : .notInNav
                            }
                        }
                    }
                // If the view is in a navigation view, show the content directly
            case .inNav:
                content
                // If the view is not in a navigation view, wrap it in a navigation
            case .notInNav:
                if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
                    // Using NavigationStack is best generic solution if only need
                    // to show a toolbar
                    // NavigatonStack toolbars combine nicely in parent NavigationView
                    NavigationStack {
                        content
                    }
                } else {
                    NavigationView {
                        content
                    }
                }
            }
        }
    }
}
#endif
