//
//
//  CGSize+device.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(Foundation) && (canImport(UIKit) || canImport(AppKit))
import Foundation
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

extension CGSize {
    /// The size of the current device's screen.
    /// - Note: On macOS, this returns the size of the main screen or `.zero` if no screen is available.
    public static var device: CGSize {
        #if os(iOS) || os(tvOS) || os(visionOS)
        return UIScreen.main.bounds.size
        #elseif os(macOS)
        return NSScreen.main?.frame.size ?? .zero
        #endif
    }
}
#endif
