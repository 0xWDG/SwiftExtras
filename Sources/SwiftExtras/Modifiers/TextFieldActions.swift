//
//  TextFieldActions.swift
//  SwiftExtras
//
//  Created by Balaji Venkatesh on 2024-11-04.
//  https://github.com/0xWDG/SwiftExtras
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(UIKit) && os(iOS)
import SwiftUI
import UIKit

/// A custom edit-menu action for a single-line SwiftUI text field.
public struct TextFieldAction {
    /// The title displayed in the edit menu.
    public let title: String
    /// The operation performed with the selected range and underlying text field.
    public let action: (NSRange, UITextField) -> Void

    /// Creates a text-field edit-menu action.
    ///
    /// - Parameters:
    ///   - title: The title displayed in the edit menu.
    ///   - action: The operation performed when someone chooses the action.
    public init(title: String, action: @escaping (NSRange, UITextField) -> Void) {
        self.title = title
        self.action = action
    }
}

/// Builds an array of ``TextFieldAction`` values.
@resultBuilder
public enum TextFieldActionBuilder {
    /// Combines action expressions into an array.
    public static func buildBlock(_ components: TextFieldAction...) -> [TextFieldAction] {
        components
    }

    /// Supports conditional action expressions without an `else` branch.
    public static func buildOptional(_ component: [TextFieldAction]?) -> [TextFieldAction] {
        component ?? []
    }

    /// Supports the first branch of a conditional action expression.
    public static func buildEither(first component: [TextFieldAction]) -> [TextFieldAction] {
        component
    }

    /// Supports the second branch of a conditional action expression.
    public static func buildEither(second component: [TextFieldAction]) -> [TextFieldAction] {
        component
    }

    /// Flattens actions produced by a loop.
    public static func buildArray(_ components: [[TextFieldAction]]) -> [TextFieldAction] {
        components.flatMap { $0 }
    }
}

/// A custom edit-menu action for an axis-based, multiline SwiftUI text field.
public struct TextFieldWithAxisAction {
    /// The title displayed in the edit menu.
    public let title: String
    /// The operation performed with the selected range and underlying text view.
    public let action: (NSRange, UITextView) -> Void

    /// Creates an axis-based text-field edit-menu action.
    ///
    /// - Parameters:
    ///   - title: The title displayed in the edit menu.
    ///   - action: The operation performed when someone chooses the action.
    public init(title: String, action: @escaping (NSRange, UITextView) -> Void) {
        self.title = title
        self.action = action
    }
}

/// Builds an array of ``TextFieldWithAxisAction`` values.
@resultBuilder
public enum TextFieldWithAxisActionBuilder {
    /// Combines action expressions into an array.
    public static func buildBlock(
        _ components: TextFieldWithAxisAction...
    ) -> [TextFieldWithAxisAction] {
        components
    }

    /// Supports conditional action expressions without an `else` branch.
    public static func buildOptional(
        _ component: [TextFieldWithAxisAction]?
    ) -> [TextFieldWithAxisAction] {
        component ?? []
    }

    /// Supports the first branch of a conditional action expression.
    public static func buildEither(
        first component: [TextFieldWithAxisAction]
    ) -> [TextFieldWithAxisAction] {
        component
    }

    /// Supports the second branch of a conditional action expression.
    public static func buildEither(
        second component: [TextFieldWithAxisAction]
    ) -> [TextFieldWithAxisAction] {
        component
    }

    /// Flattens actions produced by a loop.
    public static func buildArray(
        _ components: [[TextFieldWithAxisAction]]
    ) -> [TextFieldWithAxisAction] {
        components.flatMap { $0 }
    }
}

public extension TextField {
    /// Adds custom actions to the edit menu of a single-line text field.
    ///
    /// - Parameters:
    ///   - showSuggestions: Whether to append the system's suggested actions.
    ///   - actions: The custom actions to display.
    @available(iOS 16, *)
    func menu(
        showSuggestions: Binding<Bool>,
        @TextFieldActionBuilder actions: @escaping () -> [TextFieldAction]
    ) -> some View {
        background(TextFieldActionHelper(
            showSuggestions: showSuggestions,
            actions: actions()
        ))
        .compositingGroup()
    }

    /// Adds custom actions to the edit menu of an axis-based text field.
    ///
    /// Use this overload for a `TextField` created with an `axis` argument.
    /// - Parameters:
    ///   - showSuggestions: Whether to append the system's suggested actions.
    ///   - actions: The custom actions to display.
    @available(iOS 16, *)
    func menuForTextFieldAxis(
        showSuggestions: Binding<Bool>,
        @TextFieldWithAxisActionBuilder actions: @escaping () -> [TextFieldWithAxisAction]
    ) -> some View {
        background(TextFieldWithAxisActionHelper(
            showSuggestions: showSuggestions,
            actions: actions()
        ))
        .compositingGroup()
    }
}

@available(iOS 16, *)
private struct TextFieldActionHelper: UIViewRepresentable {
    @Binding var showSuggestions: Bool
    let actions: [TextFieldAction]

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        context.coordinator.scheduleAttachment(from: view)
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.scheduleAttachment(from: view)
    }

    static func dismantleUIView(_ view: UIView, coordinator: Coordinator) {
        coordinator.detach()
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: TextFieldActionHelper
        private weak var textField: UITextField?
        private weak var originalDelegate: UITextFieldDelegate?

        init(parent: TextFieldActionHelper) {
            self.parent = parent
        }

        func scheduleAttachment(from view: UIView) {
            DispatchQueue.main.async { [weak self, weak view] in
                guard let self, let view else { return }
                attach(to: view.firstSuperviewDescendant(of: UITextField.self))
            }
        }

        func detach() {
            if textField?.delegate === self {
                textField?.delegate = originalDelegate
            }
            textField = nil
            originalDelegate = nil
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            originalDelegate?.textFieldDidChangeSelection?(textField)
        }

        func textField(
            _ textField: UITextField,
            editMenuForCharactersIn range: NSRange,
            suggestedActions: [UIMenuElement]
        ) -> UIMenu? {
            let customActions = parent.actions.map { item in
                UIAction(title: item.title) { _ in
                    item.action(range, textField)
                }
            }
            return UIMenu(children: parent.showSuggestions
                ? customActions + suggestedActions
                : customActions)
        }

        private func attach(to newTextField: UITextField?) {
            guard let newTextField, newTextField !== textField else { return }
            detach()
            originalDelegate = newTextField.delegate
            textField = newTextField
            newTextField.delegate = self
        }

        override func responds(to selector: Selector!) -> Bool {
            super.responds(to: selector) || originalDelegate?.responds(to: selector) == true
        }

        override func forwardingTarget(for selector: Selector!) -> Any? {
            if originalDelegate?.responds(to: selector) == true {
                return originalDelegate
            }
            return super.forwardingTarget(for: selector)
        }
    }
}

@available(iOS 16, *)
private struct TextFieldWithAxisActionHelper: UIViewRepresentable {
    @Binding var showSuggestions: Bool
    let actions: [TextFieldWithAxisAction]

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        context.coordinator.scheduleAttachment(from: view)
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.scheduleAttachment(from: view)
    }

    static func dismantleUIView(_ view: UIView, coordinator: Coordinator) {
        coordinator.detach()
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextFieldWithAxisActionHelper
        private weak var textView: UITextView?
        private weak var originalDelegate: UITextViewDelegate?

        init(parent: TextFieldWithAxisActionHelper) {
            self.parent = parent
        }

        func scheduleAttachment(from view: UIView) {
            DispatchQueue.main.async { [weak self, weak view] in
                guard let self, let view else { return }
                attach(to: view.firstSuperviewDescendant(of: UITextView.self))
            }
        }

        func detach() {
            if textView?.delegate === self {
                textView?.delegate = originalDelegate
            }
            textView = nil
            originalDelegate = nil
        }

        func textViewDidChangeSelection(_ textView: UITextView) {
            originalDelegate?.textViewDidChangeSelection?(textView)
        }

        func textViewDidChange(_ textView: UITextView) {
            originalDelegate?.textViewDidChange?(textView)
        }

        func textView(
            _ textView: UITextView,
            editMenuForTextIn range: NSRange,
            suggestedActions: [UIMenuElement]
        ) -> UIMenu? {
            let customActions = parent.actions.map { item in
                UIAction(title: item.title) { _ in
                    item.action(range, textView)
                }
            }
            return UIMenu(children: parent.showSuggestions
                ? customActions + suggestedActions
                : customActions)
        }

        private func attach(to newTextView: UITextView?) {
            guard let newTextView, newTextView !== textView else { return }
            detach()
            originalDelegate = newTextView.delegate
            textView = newTextView
            newTextView.delegate = self
        }

        override func responds(to selector: Selector!) -> Bool {
            super.responds(to: selector) || originalDelegate?.responds(to: selector) == true
        }

        override func forwardingTarget(for selector: Selector!) -> Any? {
            if originalDelegate?.responds(to: selector) == true {
                return originalDelegate
            }
            return super.forwardingTarget(for: selector)
        }
    }
}

private extension UIView {
    func firstSuperviewDescendant<ViewType: UIView>(of type: ViewType.Type) -> ViewType? {
        var ancestor = superview
        while let currentAncestor = ancestor {
            if let match = currentAncestor.firstDescendant(of: type) {
                return match
            }
            ancestor = currentAncestor.superview
        }
        return nil
    }

    func firstDescendant<ViewType: UIView>(of type: ViewType.Type) -> ViewType? {
        if let match = self as? ViewType {
            return match
        }
        for subview in subviews {
            if let match = subview.firstDescendant(of: type) {
                return match
            }
        }
        return nil
    }
}

#if DEBUG
@available(iOS 17, *)
private struct TextFieldActionsPreview: View {
    @State private var text = "Select this text"
    @State private var includesSystemActions = true

    var body: some View {
        Form {
            Toggle("Include system actions", isOn: $includesSystemActions)
            TextField("Message", text: $text)
                .menu(showSuggestions: $includesSystemActions) {
                    TextFieldAction(title: "Uppercase") { range, textField in
                        guard let swiftRange = Range(range, in: textField.text ?? "") else { return }
                        let currentText = textField.text ?? ""
                        textField.text = currentText.replacingCharacters(
                            in: swiftRange,
                            with: currentText[swiftRange].uppercased()
                        )
                        text = textField.text ?? ""
                    }
                }
                .accessibilityHint("Select text to open the custom edit menu")
        }
    }
}

@available(iOS 17, *)
#Preview {
    TextFieldActionsPreview()
}
#endif
#endif
