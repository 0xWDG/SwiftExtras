//
//  NSPasteboard+string.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-14.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if os(macOS)
    import AppKit

    public extension NSPasteboard {
        /// get/set the string contents of the pasteboard.
        /// - Note: This is a wrapper around `setString(_:forType:)` and `string(forType:)`.
        var string: String? {
            get { string(forType: .string) }
            set {
                clearContents()
                guard let newValue else { return }
                setString(newValue, forType: .string)
            }
        }
    }
#endif
