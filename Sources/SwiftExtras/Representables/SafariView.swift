//
//  SafariView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(WebKit) && canImport(UIKit) || canImport(AppKit)
import SwiftUI
@preconcurrency import WebKit

public struct WebView: ViewRepresentable {
    let url: URL
    let onLoad: ((WKWebView) -> Void)?
    let html: String?
    let webView = WKWebView()

    public init(url: URL, onLoad: ((WKWebView) -> Void)?) {
        self.url = url
        self.onLoad = onLoad
        self.html = nil
    }

    @available(iOS 16.0, macOS 13.0, *)
    public init(html: String) {
        self.url = .cachesDirectory
            .appendingPathComponent("\(UUID().uuidString).html")

        self.html = html

        do {
            try html.data(using: .utf8)?.write(to: url)
        } catch {
            print("Error writing HTML to \(url): \(error.localizedDescription)")
        }

        self.onLoad = nil
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
        Coordinator(onLoad: onLoad)
    }

    public class Coordinator: NSObject, WKNavigationDelegate {
        let onLoad: ((WKWebView) -> Void)?

        init(onLoad: ((WKWebView) -> Void)?) {
            self.onLoad = onLoad
        }

        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Error loading URL: \(error)")
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            onLoad?(webView)
        }
    }
}

#endif
