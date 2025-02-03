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

#if canImport(SwiftUI) && canImport(MessageUI)
import SwiftUI
import MessageUI

/// A view that represents a mail composer
///
/// This view is used to present a mail composer to the user.
/// The view will be dismissed when the user finishes with the mail composer.
///
/// Usage:
/// ```swift
/// struct ContentView: View {
///     @State var result: Result<MFMailComposeResult, Error>?
///     @State private var isShowingMailView = false
///
///     var body: some View {
///         if MFMailComposeViewController.canSendMail() {
///             Button("Send Email") {
///                 isShowingMailView.toggle()
///             }
///         }
///         .sheet(isPresented: $isShowingMailView) {
///             MailView(result: $result) { composer in
///                 composer.setSubject("Email feedback")
///                 composer.setToRecipients(["email@wesleydegroot.nl"])
///                 composer.setMessageBody("Hello :)", isHTML: false)
///             }
///         }
///     }
/// }
/// ```
public struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode)
    var presentation

    @Binding
    var result: Result<MFMailComposeResult, Error>?

    public var configure: ((MFMailComposeViewController) -> Void)?

    /// Create a new Mail Composer view
    /// This view is used to present a mail composer to the user.
    /// The view will be dismissed when the user finishes with the mail composer.
    ///
    /// Usage:
    /// ```swift
    /// struct ContentView: View {
    ///     @State var result: Result<MFMailComposeResult, Error>?
    ///     @State private var isShowingMailView = false
    ///
    ///     var body: some View {
    ///         if MFMailComposeViewController.canSendMail() {
    ///             Button("Send Email") {
    ///                 isShowingMailView.toggle()
    ///             }
    ///         }
    ///         .sheet(isPresented: $isShowingMailView) {
    ///             MailView(result: $result) { composer in
    ///                 composer.setSubject("Email feedback")
    ///                 composer.setToRecipients(["email@wesleydegroot.nl"])
    ///                 composer.setMessageBody("Hello :)", isHTML: false)
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter result: The result of the mail composer
    /// - Parameter configure: Configuration of the mail composer
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
