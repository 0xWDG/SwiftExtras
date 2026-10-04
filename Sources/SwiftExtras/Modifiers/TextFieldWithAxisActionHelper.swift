//
//  TextFieldWithAxisActionHelper.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-10-01.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(UIKit) && os(iOS)
import SwiftUI
import UIKit

@available(iOS 16, *)
public struct TextFieldWithAxisActionHelper: UIViewRepresentable {
    @Binding var showSuggestions: Bool
    let actions: [TextFieldWithAxisAction]

    /// Creates the value required by `makeCoordinator`.
    ///
    /// The implementation configures the returned value from current state and context.
    public func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    /// Creates the value required by `makeUIView`.
    ///
    /// The implementation configures the returned value from current state and context.
    public func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        context.coordinator.scheduleAttachment(from: view)
        return view
    }

    /// Updates the existing value handled by `updateUIView`.
    ///
    /// The implementation applies the enclosing type’s latest state.
    public func updateUIView(_ view: UIView, context: Context) {
        context.coordinator.parent = self
        context.coordinator.scheduleAttachment(from: view)
    }

    /// Performs the `dismantleUIView` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    public static func dismantleUIView(_ view: UIView, coordinator: Coordinator) {
        coordinator.detach()
    }

    public final class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextFieldWithAxisActionHelper
        private weak var textView: UITextView?
        private weak var originalDelegate: UITextViewDelegate?

        init(parent: TextFieldWithAxisActionHelper) {
            self.parent = parent
        }

        /// Performs the `scheduleAttachment` operation for the enclosing type.
        ///
        /// This implementation supports the enclosing declaration’s behavior.
        func scheduleAttachment(from view: UIView) {
            DispatchQueue.main.async { [weak self, weak view] in
                guard let self, let view else { return }
                attach(to: view.firstSuperviewDescendant(of: UITextView.self))
            }
        }

        /// Performs the `detach` operation for the enclosing type.
        ///
        /// This implementation supports the enclosing declaration’s behavior.
        func detach() {
            if textView?.delegate === self {
                textView?.delegate = originalDelegate
            }
            textView = nil
            originalDelegate = nil
        }

        /// Performs the `textViewDidChangeSelection` operation for the enclosing type.
        ///
        /// This implementation supports the enclosing declaration’s behavior.
        public func textViewDidChangeSelection(_ textView: UITextView) {
            originalDelegate?.textViewDidChangeSelection?(textView)
        }

        /// Performs the `textViewDidChange` operation for the enclosing type.
        ///
        /// This implementation supports the enclosing declaration’s behavior.
        public func textViewDidChange(_ textView: UITextView) {
            originalDelegate?.textViewDidChange?(textView)
        }

        /// Performs the `textView` operation for the enclosing type.
        ///
        /// This implementation supports the enclosing declaration’s behavior.
        public func textView(
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

        /// Performs the `attach` operation for the enclosing type.
        ///
        /// This implementation supports the enclosing declaration’s behavior.
        private func attach(to newTextView: UITextView?) {
            guard let newTextView, newTextView !== textView else { return }
            detach()
            originalDelegate = newTextView.delegate
            textView = newTextView
            newTextView.delegate = self
        }

        override public func responds(to selector: Selector!) -> Bool {
            super.responds(to: selector) || originalDelegate?.responds(to: selector) == true
        }

        override public func forwardingTarget(for selector: Selector!) -> Any? {
            if originalDelegate?.responds(to: selector) == true {
                return originalDelegate
            }
            return super.forwardingTarget(for: selector)
        }
    }
}

/// Adds `TextFieldActions` functionality to `UIView`.
///
/// The declarations in this scope provide focused utilities while preserving the type’s standard behavior.
extension UIView {
    /// Performs the `firstSuperviewDescendant` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    public func firstSuperviewDescendant<ViewType: UIView>(of type: ViewType.Type) -> ViewType? {
        var ancestor = superview
        while let currentAncestor = ancestor {
            if let match = currentAncestor.firstDescendant(of: type) {
                return match
            }
            ancestor = currentAncestor.superview
        }
        return nil
    }

    /// Performs the `firstDescendant` operation for the enclosing type.
    ///
    /// This implementation supports the enclosing declaration’s behavior.
    public func firstDescendant<ViewType: UIView>(of type: ViewType.Type) -> ViewType? {
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

#endif
