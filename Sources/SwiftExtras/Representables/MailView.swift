//
//  MailView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(MessageUI) && canImport(SwiftUI)

import SwiftUI
import MessageUI

public struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode)
    var presentation

    @Binding
    var result: Result<MFMailComposeResult, Error>?

    public var configure: ((MFMailComposeViewController) -> Void)?

    public init(
        result: Binding<Result<MFMailComposeResult, Error>?>,
        configure: ((MFMailComposeViewController) -> Void)? = nil
    ) {
        self._result = result
        self.configure = configure
    }

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding
        var presentation: PresentationMode

        @Binding
        var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        public func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                $presentation.wrappedValue.dismiss()
            }

            if let error {
                self.result = .failure(error)
                return
            }

            self.result = .success(result)
        }
    }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation, result: $result)
    }

    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    ) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        configure?(viewController)
        return viewController
    }

    public func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>) {
    }
}
#endif
