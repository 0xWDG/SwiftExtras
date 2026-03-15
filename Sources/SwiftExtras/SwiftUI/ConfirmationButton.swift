//
//  ConfirmationButton.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A button that shows a confirmation dialog before performing its action.
/// Use this to prevent accidental destructive actions.
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
public struct ConfirmationButton: View {
    @State var confirmationShown: Bool = false

    var action: () -> Void
    var label: LocalizedStringKey
    var role: ButtonRole
    var visibility: Visibility
    var confirmationText: LocalizedStringKey?
    var systemImage: String?

    /// Creates a new ConfirmationButton.
    /// - Parameters:
    ///   - label: The label of the button.
    ///   - role: The button's role.
    ///   - titleVisibility: The visibility of the dialog's title. The default value is visible.
    ///   - confirmationText: The confirmation text, defaults to label.
    ///   - systemImage: The systemImage for the button, default: disabled.
    ///   - action: The action to perform when the button is confirmed.
    public init(
        _ label: LocalizedStringKey,
        role: ButtonRole = .destructive,
        titleVisibility: Visibility = .visible,
        confirmationText: LocalizedStringKey? = nil,
        systemImage: String? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.action = action
        self.label = label
        self.role = role
        self.visibility = titleVisibility
        self.confirmationText = confirmationText
        self.systemImage = systemImage
    }

    public var body: some View {
        button
        .foregroundStyle(.red)
        .confirmationDialog(
            Text(confirmationText ?? label),
            isPresented: $confirmationShown,
            titleVisibility: visibility
        ) {
            Button("Yes", role: .destructive) {
                withAnimation {
                    action()
                }
            }

            Button("No", role: .cancel) {
                withAnimation {
                    confirmationShown.toggle()
                }
            }
        }
    }

    @ViewBuilder
    private var button: some View {
        if let systemImage {
            Button(label, systemImage: systemImage, role: role) {
                confirmationShown.toggle()
            }
        } else {
            Button(label, role: role) {
                confirmationShown.toggle()
            }
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Form {
        ConfirmationButton("Test") {
            print("YES")
        }
    }
}
#endif
#endif
