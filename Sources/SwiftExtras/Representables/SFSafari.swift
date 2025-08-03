//
//  SFSafari.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-21.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(SafariServices) && canImport(UIKit)
    import SafariServices
    import SwiftUI
    import UIKit

    /// Make a Safari View for SwiftUI
    @available(iOS 14.0, *)
    public struct SafariView: UIViewControllerRepresentable {
        public typealias UIViewControllerType = SFSafariViewController

        @Binding public var urlString: String

        public init(url: Binding<URL>) {
            _urlString = Binding(get: {
                url.wrappedValue.absoluteString
            }, set: { _ in
                // Ignore
            })
        }

        public init(url: Binding<String>) {
            _urlString = url
        }

        public func makeUIViewController(
            context _: UIViewControllerRepresentableContext<SafariView>
        ) -> SFSafariViewController {
            guard let safeURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: safeURL)
            else {
                fatalError("Invalid urlString: \(urlString)")
            }

            let safariViewController = SFSafariViewController(url: url)
            #if !os(visionOS)
                safariViewController.preferredControlTintColor = UIColor(Color.accentColor)
                safariViewController.dismissButtonStyle = .close
            #endif

            return safariViewController
        }

        public func updateUIViewController(
            _: SFSafariViewController,
            context _: UIViewControllerRepresentableContext<SafariView>
        ) {}
    }

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            SafariView(url: .constant(.init(stringLiteral: "https://wesleydegroot.nl")))
        }
    #endif
#endif
