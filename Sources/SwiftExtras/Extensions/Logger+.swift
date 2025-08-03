//
//  Logger+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-04-26.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(OSLog)
    import OSLog

    public extension Logger {
        /// Start a logger with default values
        /// subsystem: Bundle.main.bundleIdentifier
        /// catefory: #function (or class when called from a class)
        ///
        /// - Parameter default: Set this to whatever you want
        /// - Parameter category: #function
        init(default _: Any = true, category: StaticString = #function) {
            self.init(
                subsystem: Bundle.main.bundleIdentifier ?? "nl.wesleydegroot",
                category: String(describing: category)
            )
        }
    }
#endif
