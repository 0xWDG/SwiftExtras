//
//  PlatformViewRepresentable.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: - UIKit Types

#if canImport(UIKit)

import UIKit

/// `UIImage/NSImage` alias for platform-agnostic code.
public typealias PlatformImage = UIImage

/// `UIColor/NSColor` alias for platform-agnostic code.
public typealias PlatformColor = UIColor

#if !os(watchOS)
    /// `UIView/NSView` alias for platform-agnostic code.
    public typealias PlatformView = UIView

    /// `UIViewController/NSViewController` alias for platform-agnostic code.
    public typealias PlatformViewController = UIViewController

    /// `UIViewControllerRepresentable/NSViewControllerRepresentable` alias for platform-agnostic code.
    public typealias PlatformViewControllerRepresentable = UIViewControllerRepresentable

    /// `UIViewRepresentable/NSViewRepresentable` alias for platform-agnostic code.
    public typealias PlatformViewRepresentableType = UIViewRepresentable

    /// `UIWindowScene` alias for platform-agnostic code.
    /// - note: Since AppKit doesn't have the concept of window scenes, \
    /// this is aliased to `NSScreen` when building a native macOS target.
    public typealias PlatformWindowScene = UIWindowScene

    #if !os(visionOS)
        /// `UIScreen/NSScreen` alias for platform-agnostic code.
        /// - note: `UIScreen` is not available on visionOS.
        public typealias PlatformScreen = UIScreen
    #endif
#endif

public extension PlatformImage {
    /// Create a `PlatformImage` from contents of url/file.
    ///
    /// - Parameter url: The URL to create the image from.
    convenience init?(contentsOf url: URL) {
        self.init(contentsOfFile: url.path)
    }
}

#endif // canImport(UIKit)

// MARK: - AppKit Types

#if os(macOS)

import AppKit

/// `UIImage/NSImage` alias for platform-agnostic code.
public typealias PlatformImage = NSImage

/// `UIColor/NSColor` alias for platform-agnostic code.
public typealias PlatformColor = NSColor

/// `UIView/NSView` alias for platform-agnostic code.
public typealias PlatformView = NSView

/// `UIViewController/NSViewController` alias for platform-agnostic code.
public typealias PlatformViewController = NSViewController

/// `UIViewControllerRepresentable/NSViewControllerRepresentable` alias for platform-agnostic code.
public typealias PlatformViewControllerRepresentable = NSViewControllerRepresentable

/// `UIViewRepresentable/NSViewRepresentable` alias for platform-agnostic code.
/// - note: You may adopt the ``PlatformViewRepresentable`` protocol \
/// in order to use a single implementation for both UIKit and AppKit platforms.
public typealias PlatformViewRepresentableType = NSViewRepresentable

/// `UIScreen/NSScreen` alias for platform-agnostic code.
/// - note: `UIScreen` is not available on visionOS.
public typealias PlatformScreen = NSScreen

/// `UIWindowScene` alias for platform-agnostic code.
/// - note: Since AppKit doesn't have the concept of window scenes, \
/// this is aliased to `NSScreen` when building a native macOS target.
public typealias PlatformWindowScene = NSScreen

public extension NSImage {
    /// Create a `NSImage` from a CGImage.
    ///
    /// - Parameter cgImage: The CGImage to create the NSImage from.
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
    }

    /// Get the PNG data representation of the image.
    ///
    /// - Returns: The PNG data representation of the image.
    func pngData() -> Data? {
        guard let tiffRepresentation else { return nil }
        return NSBitmapImageRep(data: tiffRepresentation)?.representation(using: .png, properties: [:])
    }

    /// Get the CGImage representation of the image.
    var cgImage: CGImage? { self.cgImage(forProposedRect: nil, context: nil, hints: nil) }
}

#endif // os(macOS)

#if swift(>=6.0)
extension PlatformImage: @unchecked @retroactive Sendable { }
#else
extension PlatformImage: @unchecked Sendable { }
#endif
#endif
