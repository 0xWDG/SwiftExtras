//
//  WebView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(WebKit) && (canImport(UIKit) || canImport(AppKit))
import SwiftUI
@preconcurrency import WebKit

/// Create a Web View
///
/// This view is a wrapper around `SFSafariViewController`.
///
/// Usage:
/// Open a URL in Safari:
/// ```swift
/// WebView(url: URL(string: "https://wesleydegroot.nl")!)
/// ```
///
/// Open a HTML string in Safari:
/// ```swift
/// WebView(html: "<html><body><h1>Hello, World!</h1></body></html>")
/// ```
///
public struct WebView: PlatformViewRepresentableType {
    let url: URL
    let onLoad: ((WKWebView, WKNavigation) -> Void)?
    let onError: ((WKWebView, WKNavigation, Error) -> Void)?
    let html: String?
    let webView = WKWebView()

    /// Create a Safari View
    ///
    /// This view is a wrapper around `SFSafariViewController`.
    ///
    /// Usage:
    /// Open a URL in Safari:
    /// ```swift
    /// WebView(url: URL(string: "https://wesleydegroot.nl")!)
    /// ```
    ///
    /// - Parameter url: The URL specifying which to navigate.
    /// - Parameter onLoad: Invoked when a main frame navigation completes.
    /// - Parameter onError: Invoked when an error occurs during a committed main frame navigation.
    public init(
        url: URL,
        onLoad: ((WKWebView, WKNavigation) -> Void)? = nil,
        onError: ((WKWebView, WKNavigation, Error) -> Void)? = nil
    ) {
        self.url = url
        self.onLoad = onLoad
        self.onError = onError
        self.html = nil
    }

    /// Create a Safari View
    ///
    /// This view is a wrapper around `SFSafariViewController`.
    ///
    /// Usage:
    /// Open a URL in Safari:
    /// ```swift
    /// WebView(html: "<html><body><h1>Hello, World!</h1></body></html>")
    /// ```
    ///
    /// - Parameter html: The HTML String to load.
    /// - Parameter onLoad: Invoked when a main frame navigation completes.
    /// - Parameter onError: Invoked when an error occurs during a committed main frame navigation.
    @available(iOS 16.0, macOS 13.0, *)
    public init(
        html: String,
        onLoad: ((WKWebView, WKNavigation) -> Void)? = nil,
        onError: ((WKWebView, WKNavigation, Error) -> Void)? = nil
    ) {
        self.url = .cachesDirectory
            .appendingPathComponent("\(UUID().uuidString).html")

        self.html = html

        do {
            try html.data(using: .utf8)?.write(to: url)
        } catch {
            print("Error writing HTML to \(url): \(error.localizedDescription)")
        }

        self.onLoad = onLoad
        self.onError = onError
    }

#if canImport(UIKit)
    public func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        if url.isFileURL {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            webView.load(URLRequest(url: url))
        }
    }
#endif

#if canImport(AppKit)
    public func makeNSView(context: Context) -> some NSView {
        webView.navigationDelegate = context.coordinator
        return webView
    }

    public func updateNSView(_ nsView: NSViewType, context: Context) {
        if url.isFileURL {
            webView.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            webView.load(URLRequest(url: url))
        }
    }
#endif

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.onError?(webView, navigation, error)
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.onLoad?(webView, navigation)
        }
    }
}
#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    if let url = URL(string: "https://wesleydegroot.nl") {
        WebView(url: url)
    }
}
#endif
#endif
