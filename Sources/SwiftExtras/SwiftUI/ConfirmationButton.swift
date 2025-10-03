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
    var label: LocalizedStringResource
    var role: ButtonRole
    var visibility: Visibility

    /// Creates a new ConfirmationButton.
    /// - Parameters:
    ///   - label: The label of the button.
    ///   - role: The button's role.
    ///   - titleVisibility: The visibility of the dialog's title. The default-
    ///   - action: The action to perform when the button is confirmed.
    public init(
        _ label: LocalizedStringResource,
        role: ButtonRole = .destructive,
        titleVisibility: Visibility = .automatic,
        action: @escaping @MainActor () -> Void
    ) {
        self.action = action
        self.label = label
        self.role = role
        self.visibility = titleVisibility
    }

    public var body: some View {
        Button(label, role: role) {
            confirmationShown.toggle()
        }
        .foregroundStyle(.red)
        .confirmationDialog(
            Text(LocalizedStringKey(stringLiteral: "Are you sure?")),
            isPresented: $confirmationShown,
            titleVisibility: visibility
        ) {
            Button("Yes", role: .destructive) {
                withAnimation {
                    action()
                }
            }
            Button("No") {
                withAnimation {
                    confirmationShown.toggle()
                }
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
