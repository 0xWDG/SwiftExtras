//
//  CopyableLabeledContent.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-11-07.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// A labeled value that provides a copy-to-clipboard context-menu action.
public struct CopyableLabeledContent: View {
    /// The label displayed for the value.
    public let title: String
    /// The displayed value and text copied to the clipboard.
    public let value: String

    /// Initializes a new instance of `CopyableLabeledContent`
    /// Custom LabeledContent view with copy-to-clipboard functionality
    ///
    /// - Parameters:
    ///   - title: The title of the labeled content
    ///   - value: The value to be displayed and copied
    public init(_ title: LocalizedStringKey, value: String) {
        self.title = title.stringValue
        self.value = value
    }

    /// Initializes a new instance of `CopyableLabeledContent`
    /// Custom LabeledContent view with copy-to-clipboard functionality
    ///
    /// - Parameters:
    ///   - title: The title of the labeled content
    ///   - value: The value to be displayed and copied
    public init(_ title: String, value: String) {
        self.title = title
        self.value = value
    }

    /// The labeled value and its copy action.
    public var body: some View {
        LabeledContent(title) {
            Text(value)
                .foregroundStyle(.secondary)
#if !os(watchOS) && !os(tvOS)
                .contextMenu {
                    Button("Copy", systemImage: "doc.on.clipboard") {
                        PlatformPasteboard.general.string = value
                    }
                }
#endif
        }
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    Form {
        CopyableLabeledContent("Test", value: "Copy me")
    }
    .formStyle(.grouped)
}
#endif
#endif
