//
//  PictureInPicture.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(AVKit) && !os(watchOS)
import AVKit
#if DEBUG && canImport(SwiftUI)
import SwiftUI
#endif

/// Information about the system's Picture in Picture capabilities.
public enum PictureInPicture {
    /// Whether the current device supports Picture in Picture.
    public static var isSupported: Bool {
        AVPictureInPictureController.isPictureInPictureSupported()
    }
}

#if DEBUG && canImport(SwiftUI)
@available(iOS 17.0, macOS 14.0, tvOS 17.0, *)
#Preview("Picture in Picture Support") {
    Label(
        PictureInPicture.isSupported ? "Picture in Picture is supported" : "Picture in Picture is unavailable",
        systemImage: PictureInPicture.isSupported ? "pip.fill" : "pip.remove"
    )
    .padding()
}
#endif
#endif
