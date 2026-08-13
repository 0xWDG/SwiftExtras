//
//  ScreenshotRendering.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(AppKit) || (os(iOS) && canImport(UIKit))
#if canImport(AppKit)
import AppKit
#elseif os(iOS)
import UIKit
#endif
import SwiftUI

let screenshotBackgroundColor: Color = {
    #if canImport(AppKit)
    Color(nsColor: .windowBackgroundColor)
    #elseif os(iOS)
    Color(uiColor: .systemBackground)
    #endif
}()

var screenshotOutputDirectory: URL {
    if let configuredPath = ProcessInfo.processInfo.environment["SWIFT_EXTRAS_SCREENSHOT_OUTPUT"] {
        return URL(fileURLWithPath: configuredPath, isDirectory: true)
    }

    #if canImport(AppKit)
    return URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        .appendingPathComponent("Sources/SwiftExtras/SwiftExtras.docc/Resources")
    #elseif os(iOS)
    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    return documents.appendingPathComponent("SwiftExtrasScreenshots", isDirectory: true)
    #endif
}

func screenshotSize(_ size: CGSize) -> CGSize {
    #if os(iOS)
    CGSize(width: min(size.width, 393), height: size.height)
    #else
    size
    #endif
}

@MainActor
func render(_ spec: ScreenshotSpec, output: URL) throws {
    #if canImport(AppKit)
    try renderWithAppKit(spec, output: output)
    #elseif os(iOS)
    try renderWithUIKit(spec, output: output)
    #endif
}

@MainActor
private func screenshotContent(for spec: ScreenshotSpec) -> some View {
    spec.content()
        .frame(width: spec.size.width, height: spec.size.height)
        .environment(\.colorScheme, .light)
        .environment(\.horizontalSizeClass, .compact)
        .environment(\.locale, Locale(identifier: "en_US"))
        .tint(.blue)
}

#if canImport(AppKit)
@MainActor
private func renderWithAppKit(_ spec: ScreenshotSpec, output: URL) throws {
    let view = NSHostingView(rootView: screenshotContent(for: spec))
    view.frame = CGRect(origin: .zero, size: spec.size)
    view.setFrameSize(spec.size)

    let window = NSWindow(
        contentRect: CGRect(origin: .zero, size: spec.size),
        styleMask: [.borderless],
        backing: .buffered,
        defer: false
    )
    window.contentView = view
    window.makeKeyAndOrderFront(nil)
    view.layoutSubtreeIfNeeded()
    runScreenshotLifecycle(for: spec)
    view.layoutSubtreeIfNeeded()

    guard let bitmap = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
        throw ScreenshotError.renderFailed(spec.name)
    }
    view.cacheDisplay(in: view.bounds, to: bitmap)
    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw ScreenshotError.renderFailed(spec.name)
    }
    window.orderOut(nil)
    try write(data, for: spec, to: output)
}
#elseif os(iOS)
@MainActor
private func renderWithUIKit(_ spec: ScreenshotSpec, output: URL) throws {
    let hostingController = UIHostingController(rootView: screenshotContent(for: spec))
    let window = UIWindow(frame: CGRect(origin: .zero, size: spec.size))
    window.rootViewController = hostingController
    window.makeKeyAndVisible()

    hostingController.view.frame = window.bounds
    hostingController.view.setNeedsLayout()
    hostingController.view.layoutIfNeeded()
    runScreenshotLifecycle(for: spec)
    hostingController.view.layoutIfNeeded()

    let renderer = UIGraphicsImageRenderer(bounds: hostingController.view.bounds)
    let image = renderer.image { context in
        hostingController.view.layer.render(in: context.cgContext)
    }
    guard let data = image.pngData() else {
        throw ScreenshotError.renderFailed(spec.name)
    }
    window.isHidden = true
    try write(data, for: spec, to: output)
}
#endif

private func runScreenshotLifecycle(for spec: ScreenshotSpec) {
    let duration = spec.name == "notification-view" ? 1.6 : 0.5
    RunLoop.main.run(until: Date().addingTimeInterval(duration))
}

private func write(_ data: Data, for spec: ScreenshotSpec, to output: URL) throws {
    #if os(iOS)
    let filename = "\(spec.name)-ios.png"
    #else
    let filename = "\(spec.name).png"
    #endif

    try data.write(to: output.appendingPathComponent(filename))
}

enum ScreenshotError: Error {
    case renderFailed(String)
}
#endif
