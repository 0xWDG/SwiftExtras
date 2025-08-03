//
//  SEAcknowledgementView.swift
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

    /// SwiftExtras Acknowledgement View
    ///
    /// SwiftExtras Acknowledgement View is a SwiftUI View that can be used to show acknowledgements.
    public struct SEAcknowledgementView: View {
        /// The change log entries to display.
        public var entries: Set<SEAcknowledgement>

        /// The body of the view.
        public var body: some View {
            List {
                ForEach(entries.sorted(by: { $0.name < $1.name })) { entry in
                    if let string = entry.url,
                       let url = URL(string: string) {
                        #if canImport(WebKit)
                            NavigationLink {
                                WebView(url: url)
                                    .navigationTitle(entry.name)
                                    .toolbar {
                                        Button {
                                            openURL(url)
                                        } label: {
                                            Image(systemName: "safari")
                                                .accessibilityLabel(Text("Open in web browser"))
                                        }
                                    }
                            } label: {
                                label(for: entry)
                            }
                            .id(UUID())
                        #else
                            label(for: entry)
                        #endif
                    } else {
                        label(for: entry)
                    }
                }
            }
            .navigationTitle(Text("Acknowledgements", bundle: Bundle.module))
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
        }

        /// Create a label for a given change log entry.
        ///
        /// - Parameter entry: The change log entry to create a label for.
        /// - Returns: A label for the given change log entry.
        func label(for entry: SEAcknowledgement) -> some View {
            VStack(alignment: .leading) {
                Text("\(entry.name)")

                Text("Created by \(entry.copyright)", bundle: Bundle.module)
                    .font(.callout)

                Text("Licensed under \(entry.licence)", bundle: Bundle.module)
                    .font(.caption)
            }
        }

        /// Initialize a new change log view.
        ///
        /// - Parameters:
        ///   - changeLog: The change log entries to display.
        public init(entries: [SEAcknowledgement]) {
            self.entries = Set(entries)

            if entries.contains(where: { $0.name == "SwiftExtras" }) == false {
                self.entries.insert(
                    .init(
                        name: "SwiftExtras",
                        copyright: "Wesley de Groot",
                        licence: "MIT",
                        url: "https://github.com/0xWDG/SwiftExtras"
                    )
                )
            }

            if entries.contains(where: { $0.name == "OSLogViewer" }) == false {
                self.entries.insert(
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

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            NavigationStack {
                SEAcknowledgementView(entries: [
                    .init(name: "Test", copyright: "Creator", licence: "MIT")
                ])
            }
        }
    #endif
#endif
