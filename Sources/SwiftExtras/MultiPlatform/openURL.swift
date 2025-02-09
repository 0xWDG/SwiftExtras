//
//  openURL.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif

/// Opens the location at the specified URL.
///
/// - Parameter url: A URL specifying the location to open.
/// - Returns: `true` if the location was successfully opened; otherwise, `false`.
@discardableResult
public func openURL(_ url: URL) -> Bool {
#if canImport(AppKit)
    return NSWorkspace.shared.open(url)
#endif
#if canImport(UIKit)
    return UIApplication.shared.open(url)
#endif
}
