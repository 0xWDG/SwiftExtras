//
//  ProcessInfo+isSwiftUIPreview.swift
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

extension ProcessInfo {
    /// Is the current process running in SwiftUI Previews?
    /// In debug builds, `true` if the current process is running in a SwiftUI preview.
    /// Always `false` in release builds.
    public var isSwiftUIPreview: Bool {
#if DEBUG
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
#else
        return false
#endif
    }
}
#endif
