//
//  WebView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-21.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(SafariServices) && canImport(UIKit)
import SwiftUI
import SafariServices
import UIKit

/// Make a Safari View for SwiftUI
@available(iOS 14.0, *)
public struct SafariView: UIViewControllerRepresentable {
    /// The UIKit view-controller type represented by this SwiftUI view.
    public typealias UIViewControllerType = SFSafariViewController

    /// The URL string displayed by the Safari view controller.
    @Binding public var urlString: String

    /// Creates a Safari view bound to a URL.
    ///
    /// - Parameter url: The URL to display.
    public init(url: Binding<URL>) {
        _urlString = Binding(get: {
            return url.wrappedValue.absoluteString
        }, set: { _ in
            // Ignore
        })
    }

    /// Creates a Safari view bound to a URL string.
    ///
    /// - Parameter url: The URL string to display.
    public init(url: Binding<String>) {
        _urlString = url
    }

    /// Creates the Safari view controller used by SwiftUI.
    ///
    /// - Parameter context: Context supplied by SwiftUI.
    /// - Returns: A Safari view controller configured for the bound URL.
    public func makeUIViewController(
        context: UIViewControllerRepresentableContext<SafariView>
    ) -> SFSafariViewController {
        guard let safeURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: safeURL) else {
            fatalError("Invalid urlString: \(urlString)")
        }

        let safariViewController = SFSafariViewController(url: url)
#if !os(visionOS)
        safariViewController.preferredControlTintColor = UIColor(Color.accentColor)
        safariViewController.dismissButtonStyle = .close
#endif

        return safariViewController
    }

    /// Updates the represented Safari view controller.
    ///
    /// - Parameters:
    ///   - safariViewController: The Safari view controller managed by SwiftUI.
    ///   - context: Context supplied by SwiftUI.
    public func updateUIViewController(
        _ safariViewController: SFSafariViewController,
        context: UIViewControllerRepresentableContext<SafariView>
    ) {
        return
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    SafariView(url: .constant(.init(stringLiteral: "https://wesleydegroot.nl")))
}
#endif
#endif
