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

/// A SwiftUI wrapper around the system mail composer.
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

    /// A closure that configures the mail composer before it is presented.
    public var configure: ((MFMailComposeViewController) -> Void)?

    /// Creates a mail composer view.
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
    /// - Parameters:
    ///   - result: A binding updated with the result or error from the mail composer.
    ///   - configure: A closure that configures the mail composer before presentation.
    public init(
        result: Binding<Result<MFMailComposeResult, Error>?>,
        configure: ((MFMailComposeViewController) -> Void)? = nil
    ) {
        self._result = result
        self.configure = configure
    }

    /// Coordinates mail composer delegate callbacks and dismissal.
    public final class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding
        var presentation: PresentationMode

        @Binding
        var result: Result<MFMailComposeResult, Error>?

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }

        /// Records the result and dismisses the mail composer.
        ///
        /// - Parameters:
        ///   - controller: The mail composer that finished.
        ///   - result: The result of the mail composition flow.
        ///   - error: An error encountered while sending or saving the message.
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

    /// Creates the coordinator that handles mail composer delegate callbacks.
    public func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation, result: $result)
    }

    /// Creates and configures the underlying mail composer.
    ///
    /// - Parameter context: Context supplied by SwiftUI.
    /// - Returns: A configured mail composer view controller.
    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<MailView>
    ) -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        configure?(viewController)
        return viewController
    }

    /// Updates the mail composer when SwiftUI state changes.
    ///
    /// The composer is configured only when it is created, so this method does not
    /// perform any updates.
    ///
    /// - Parameters:
    ///   - uiViewController: The mail composer managed by SwiftUI.
    ///   - context: Context supplied by SwiftUI.
    public func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: UIViewControllerRepresentableContext<MailView>) {
        }
}
#endif
