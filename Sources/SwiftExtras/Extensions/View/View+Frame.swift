//
//  View+Frame.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

extension View {
    /// Set a frame size (HxB)
    ///
    /// - Parameter size: The size to set for both width and height.
    /// - Returns: self
    public func frame(size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }

    /// Set a max frame size (HxB)
    ///
    /// - Parameter maxSize: The max size to set for both width and height.
    /// - Returns: self
    public func frame(maxSize: CGFloat) -> some View {
        self.frame(maxWidth: maxSize, maxHeight: maxSize)
    }
}
#endif
