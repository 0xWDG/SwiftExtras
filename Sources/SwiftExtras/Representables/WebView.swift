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
#if canImport(OSLog)
import OSLog
#endif
/// A SwiftUI wrapper around `WKWebView`.
///
/// Use this view to display a remote URL or an HTML string.
///
/// Usage:
/// Open a URL in Safari:
/// ```swift
/// WebView(url: URL(string: "https://wesleydegroot.nl")!)
/// ```
///
/// Open a HTML string in Safari:
/// ```swift
/// WebView(html: "<html><body><h1>Hello World!</h1></body></html>")
/// ```
///
public struct WebView: PlatformViewRepresentable {
    #if canImport(OSLog)
    let logger = Logger(default: true)
    #endif
    var url: URL
    let onLoad: ((WKWebView, WKNavigation) -> Void)?
    let onError: ((WKWebView, WKNavigation, Error) -> Void)?
    let html: String?
    let webView = WKWebView()

    /// Creates a web view that loads a URL.
    ///
    /// Usage:
    /// Open a URL in Safari:
    /// ```swift
    /// WebView(url: URL(string: "https://wesleydegroot.nl")!)
    /// ```
    ///
    /// - Parameters:
    ///   - url: The URL to load.
    ///   - onLoad: Invoked when a main-frame navigation completes.
    ///   - onError: Invoked when a committed main-frame navigation fails.
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

    /// Creates a web view that loads an HTML string.
    ///
    /// Usage:
    /// Open a URL in Safari:
    /// ```swift
    /// WebView(html: "<html><body><h1>Hello World!</h1></body></html>")
    /// ```
    ///
    /// - Parameters:
    ///   - html: The HTML string to load.
    ///   - onLoad: Invoked when a main-frame navigation completes.
    ///   - onError: Invoked when a committed main-frame navigation fails.
    @available(iOS 16.0, macOS 13.0, *)
    public init(
        html: String,
        onLoad: ((WKWebView, WKNavigation) -> Void)? = nil,
        onError: ((WKWebView, WKNavigation, Error) -> Void)? = nil
    ) {
        let tempURL: URL = .cachesDirectory
            .appendingPathComponent("SE_TEMP_HTML.html")
        self.url = tempURL
        self.html = html

        do {
            try html.data(using: .utf8)?.write(to: url)
        } catch {
            #if canImport(OSLog)
            logger.error(
                "Error writing HTML to \(tempURL, privacy: .public): \(error.localizedDescription, privacy: .public)"
            )
            #else
            print("Error writing HTML to \(url): \(error.localizedDescription)")
            #endif
        }

        self.onLoad = onLoad
        self.onError = onError
    }

    /// Creates and configures the underlying web view.
    ///
    /// - Parameter context: Context supplied by SwiftUI.
    /// - Returns: The configured web view.
    public func makePlatformView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        #if os(iOS)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        #else
        webView.setValue(false, forKey: "drawsBackground")
        #endif
        return webView
    }

    /// Loads the requested URL when it differs from the current page.
    ///
    /// - Parameters:
    ///   - platformView: The web view managed by SwiftUI.
    ///   - context: Context supplied by SwiftUI.
    public func updatePlatformView(_ platformView: WKWebView, context: Context) {
        guard platformView.url != url else { return }

        if url.isFileURL {
            platformView.loadFileURL(url, allowingReadAccessTo: url)
        } else {
            platformView.load(URLRequest(url: url))
        }
    }

    /// Creates the navigation delegate coordinator.
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Forwards web navigation events to the view's callbacks.
    public final class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        /// Forwards a failed committed navigation to the error callback.
        ///
        /// - Parameters:
        ///   - webView: The web view whose navigation failed.
        ///   - navigation: The navigation that failed.
        ///   - error: The navigation error.
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.onError?(webView, navigation, error)
        }

        /// Forwards a completed navigation to the load callback.
        ///
        /// - Parameters:
        ///   - webView: The web view that finished navigating.
        ///   - navigation: The navigation that completed.
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
