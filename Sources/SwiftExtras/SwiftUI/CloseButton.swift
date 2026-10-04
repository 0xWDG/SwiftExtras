//
//  CloseButton.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-10-04.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A platform-adaptive control that dismisses the current presentation.
///
/// On Apple platforms that support it, this control uses SwiftUI's semantic
/// close button role. Earlier supported releases use a standard button with a
/// localized Close label, preserving an equivalent action and VoiceOver label.
///
/// Create the button with the dismiss action supplied by the surrounding
/// presentation:
///
/// ```swift
/// @Environment(\.dismiss) private var dismiss
///
/// CloseButton(dismiss: dismiss)
/// ```
public struct CloseButton: View {
    private let dismiss: DismissAction

    /// Creates a button that invokes a presentation's dismiss action.
    ///
    /// - Parameter dismiss: The action obtained from SwiftUI's `dismiss`
    ///   environment value for the presentation to close.
    public init(dismiss: DismissAction) {
        self.dismiss = dismiss
    }

    /// Builds the version-appropriate close control.
    @ViewBuilder
    public var body: some View {
#if compiler(>=6.2)
        if #available(iOS 26, macOS 26, tvOS 26, watchOS 26, visionOS 26, *) {
            Button(role: .close) {
                dismiss()
            }
        } else {
            fallbackButton
        }
#else
        fallbackButton
#endif
    }

    /// Provides the semantic close control on systems before the close role is available.
    private var fallbackButton: some View {
        Button("Close") {
            dismiss()
        }
    }
}

public extension View {
    /// Adds a close control to the view's cancellation toolbar location.
    ///
    /// Use this overload when the dismiss action is already available in the
    /// surrounding view. The control uses the system close role on 26+ and
    /// falls back to a labeled Close button on earlier supported releases.
    ///
    /// ```swift
    /// @Environment(\.dismiss) private var dismiss
    ///
    /// var body: some View {
    ///     BirdDescription()
    ///         .dismissButton(dismiss: dismiss)
    /// }
    /// ```
    ///
    /// - Parameter dismiss: The action that closes the current presentation.
    /// - Returns: The view with a close button in its toolbar.
    func dismissButton(dismiss: DismissAction) -> some View {
        toolbar {
            ToolbarItem(placement: .cancellationAction) {
                CloseButton(dismiss: dismiss)
            }
        }
    }

    /// Adds a close control to the view's cancellation toolbar location.
    ///
    /// This convenience overload reads the dismiss action from the current
    /// environment, so it can be applied directly to presented content.
    ///
    /// - Returns: The view with a close button in its toolbar.
    func dismissButton() -> some View {
        modifier(DismissButtonModifier())
    }
}

/// Reads a presentation's dismiss action before adding its close control.
private struct DismissButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss

    /// Adds the close control to the cancellation toolbar location.
    ///
    /// - Parameter content: The content whose toolbar receives the control.
    /// - Returns: The content with a close button in its toolbar.
    func body(content: Content) -> some View {
        content.dismissButton(dismiss: dismiss)
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
private struct CloseButtonPreview: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Presentation content")
                .dismissButton(dismiss: dismiss)
        }
    }
}

@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview("Close Button") {
    CloseButtonPreview()
}
#endif
#endif
