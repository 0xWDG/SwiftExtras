//
//  SEChangeLogView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-09.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI

/// SwiftExtras Change Log View
///
/// SwiftExtras Change Log View is a SwiftUI View that can be used to show a change log.
public struct SEChangeLogView: View {
    /// The change log entries to display.
    public var changeLog: [SEChangeLogEntry]

    public var body: some View {
        List {
            ForEach(changeLog) { changeLogEntry in
                Section(.init("**Version \(changeLogEntry.version)**")) {
                    Text(.init(changeLogEntry.text))
                }
            }
        }
        .navigationTitle("Changelog")
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }

    /// Initialize a new change log view.
    ///
    /// - Parameters:
    ///   - changeLog: The change log entries to display.
    public init(changeLog: [SEChangeLogEntry]) {
        self.changeLog = changeLog
    }
}
#endif
