//
//  SplitActionButton.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-06-20.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)

import SwiftUI

/// A reusable split-action button that performs a primary action when clicked
/// and presents a menu containing both the primary and secondary actions when
/// long-pressed or when the menu indicator is activated.
///
/// `SplitActionButton` is built on top of SwiftUI's `Menu` with
/// `primaryAction`, providing behavior similar to split buttons found in
/// desktop applications.
///
/// Example without a custom label:
///
/// ```swift
/// SplitActionButton(
///     primaryTitle: "Publish",
///     primarySystemImage: "paperplane",
///     secondaryTitle: "Save Draft",
///     secondarySystemImage: "doc",
///     primaryAction: publish,
///     secondaryAction: saveDraft
/// )
/// ```
///
/// Example with a custom label:
///
/// ```swift
/// SplitActionButton(
///     primaryAction: publish,
///     secondaryAction: saveDraft
/// ) {
///     Label("Publish", systemImage: "paperplane")
/// }
/// ```
///
/// - Note:
///   When a custom label is provided, the `primaryTitle` and
///   `primarySystemImage` are only used within the menu items and not for the
///   visible button label.
///
/// - Important:
///   The primary action is executed immediately when the button is clicked.
///   Opening the menu exposes both the primary and secondary actions.
@available(iOS 13.0, macOS 10.15, tvOS 17.0, *)
public struct SplitActionButton<CustomLabel: View>: View {
    let primaryTitle: LocalizedStringKey
    let primarySystemImage: String?
    let secondaryTitle: LocalizedStringKey
    let secondarySystemImage: String?
    let primaryAction: () -> Void
    let secondaryAction: () -> Void

    private let customLabel: CustomLabel?

    /// Creates a split-action button using an automatically generated label.
    ///
    /// - Parameters:
    ///   - primaryTitle: The title displayed for the primary action.
    ///   - primarySystemImage: An optional SF Symbol displayed alongside the
    ///     primary action.
    ///   - secondaryTitle: The title displayed for the secondary action.
    ///   - secondarySystemImage: An optional SF Symbol displayed alongside the
    ///     secondary action.
    ///   - primaryAction: The action performed when the button is clicked.
    ///   - secondaryAction: The action performed when the secondary menu item is
    ///     selected.
    public init(
        primaryTitle: LocalizedStringKey = "Primary activity",
        primarySystemImage: String? = nil,
        secondaryTitle: LocalizedStringKey = "Secondary activity",
        secondarySystemImage: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void
    ) where CustomLabel == EmptyView {
        self.primaryTitle = primaryTitle
        self.primarySystemImage = primarySystemImage
        self.secondaryTitle = secondaryTitle
        self.secondarySystemImage = secondarySystemImage
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.customLabel = nil
    }

    /// Creates a split-action button with a custom label view.
    ///
    /// - Parameters:
    ///   - primaryTitle: The title displayed for the primary action menu item.
    ///   - primarySystemImage: An optional SF Symbol displayed alongside the
    ///     primary action menu item.
    ///   - secondaryTitle: The title displayed for the secondary action menu item.
    ///   - secondarySystemImage: An optional SF Symbol displayed alongside the
    ///     secondary action menu item.
    ///   - primaryAction: The action performed when the button is clicked.
    ///   - secondaryAction: The action performed when the secondary menu item is
    ///     selected.
    ///   - label: A custom view used as the visible button label.
    public init(
        primaryTitle: LocalizedStringKey = "Primary activity",
        primarySystemImage: String? = nil,
        secondaryTitle: LocalizedStringKey = "Secondary activity",
        secondarySystemImage: String? = nil,
        primaryAction: @escaping () -> Void,
        secondaryAction: @escaping () -> Void,
        @ViewBuilder label: () -> CustomLabel
    ) {
        self.primaryTitle = primaryTitle
        self.primarySystemImage = primarySystemImage
        self.secondaryTitle = secondaryTitle
        self.secondarySystemImage = secondarySystemImage
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.customLabel = label()
    }

    /// The content and behavior of the split-action button.
    public var body: some View {
        Menu {
            menuBuilder(
                title: primaryTitle,
                systemImage: primarySystemImage,
                action: primaryAction
            )

            menuBuilder(
                title: secondaryTitle,
                systemImage: secondarySystemImage,
                action: secondaryAction
            )
        } label: {
            if let customLabel {
                customLabel
            } else if let primarySystemImage {
                Label(primaryTitle, systemImage: primarySystemImage)
            } else {
                Text(primaryTitle)
            }
        } primaryAction: {
            primaryAction()
        }
    }

    /// Creates a menu item for the split-action menu.
    ///
    /// - Parameters:
    ///   - title: The localized title of the menu item.
    ///   - systemImage: An optional SF Symbol displayed next to the title.
    ///   - action: The action executed when the menu item is selected.
    ///
    /// - Returns: A menu button configured with the provided title, icon, and
    ///   action.
    @ViewBuilder
    private func menuBuilder(
        title: LocalizedStringKey,
        systemImage: String?,
        action: @escaping () -> Void
    ) -> some View {
        if let systemImage {
            Button(title, systemImage: systemImage) {
                action()
            }
        } else {
            Button(action: action) {
                Text(title)
            }
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 17.0, *)
#Preview {
    let emptyFunction: () -> Void = { }

    VStack {
         SplitActionButton(
            primaryTitle: "Publish",
            primarySystemImage: "paperplane",
            secondaryTitle: "Save as Draft",
            secondarySystemImage: "doc",
            primaryAction: emptyFunction,
            secondaryAction: emptyFunction
        )

        Divider()

        SplitActionButton(
            primaryTitle: "Publish",
            primarySystemImage: "paperplane",
            secondaryTitle: "Save as Draft",
            secondarySystemImage: "doc",
            primaryAction: emptyFunction,
            secondaryAction: emptyFunction
        ) {
            Text("Custom Publish Label")
        }
    }
}

#endif
