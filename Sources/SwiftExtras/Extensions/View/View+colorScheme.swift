//
//
//  View+colorScheme.swift
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
        /// Sets the color scheme of the view.
        ///
        ///  ```swift
        ///  SomeSwiftUIView()
        ///     .colorScheme(.dark)
        ///  ```
        ///
        /// - Parameter colorScheme: The color scheme to set (light or dark).
        /// - Returns: self
        public func colorScheme(colorScheme: ColorScheme) -> some View {
            self.environment(\.colorScheme, colorScheme)
        }
    }

    #if DEBUG
        @available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
        #Preview {
            VStack {
                Spacer()

                Text("Light mode")
                    .colorScheme(.light)

                Spacer()

                Text("Light mode")
                    .colorScheme(.dark)

                Spacer()
            }
            .frame(maxSize: .infinity)
            .background(.gray)
        }
    #endif
#endif
