//
//  SEAcknowledgementView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 09/02/2025.
//

#if canImport(SwiftUI)
import SwiftUI

/// SwiftExtras Acknowledgement View
///
/// SwiftExtras Acknowledgement View is a SwiftUI View that can be used to show acknowledgements.
public struct SEAcknowledgementView: View {
    /// The change log entries to display.
    public var entries: [SEAcknowledgement]

    /// The body of the view.
    public var body: some View {
        List {
            ForEach(entries) { entry in
                if let string = entry.url,
                   let url = URL(string: string) {
                    NavigationLink {
                        WebView(url: url)
                            .toolbar {
                                Button {
                                    openURL(url)
                                } label: {
                                    Image(systemName: "safari")
                                }
                            }
                    } label: {
                        label(for: entry)
                    }
                } else {
                    label(for: entry)
                }
            }
            .navigationTitle("Acknowledgements")
        }
    }

    /// Create a label for a given change log entry.
    ///
    /// - Parameter entry: The change log entry to create a label for.
    /// - Returns: A label for the given change log entry.
    func label(for entry: SEAcknowledgement) -> some View {
        VStack(alignment: .leading) {
            Text("\(entry.name)")

            Text("by \(entry.copyright)")
                .font(.callout)

            Text("Licensed under \(entry.licence)")
                .font(.caption)
        }
    }

    /// Initialize a new change log view.
    ///
    /// - Parameters:
    ///   - changeLog: The change log entries to display.
    public init(entries: [SEAcknowledgement]) {
        self.entries = entries

        if entries.first(where: { $0.name == "SwiftExtras" }) == nil {
            self.entries.append(
                .init(
                    name: "SwiftExtras",
                    copyright: "Wesley de Groot",
                    licence: "MIT",
                    url: "https://github.com/0xWDG/SwiftExtras"
                )
            )
        }

        if entries.first(where: { $0.name == "OSLogViewer" }) == nil {
            self.entries.append(
                .init(
                    name: "OSLogViewer",
                    copyright: "Wesley de Groot",
                    licence: "MIT",
                    url: "https://github.com/0xWDG/OSLogViewer"
                )
            )
        }
    }
}
#endif
