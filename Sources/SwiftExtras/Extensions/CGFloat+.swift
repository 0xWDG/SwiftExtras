//
//  CGFloat+.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-02-03.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(Foundation)
import Foundation

extension CGFloat {
   /// Returns the default spacing value based on the current platform.
   ///
   /// - Returns: A `CGFloat` value representing the default spacing:
   ///   - `30` for `tvOS`
   ///   - `8` for `macOS` and `watchOS`
   ///   - `16` for other platforms (e.g., `iOS`)
   ///
   /// ## Usage Example:
   /// ```swift
   /// SomeView("...")
   ///   .padding(.defaultSpacing)
   /// ```
   public static var defaultSpacing: Self {
      #if os(tvOS)
      return 30
      #elseif os(macOS) || os(watchOS)
      return 8
      #else
      return 16
      #endif
   }

   /// Returns the default text height value based on the current platform.
   ///
   /// - Returns: A `CGFloat` value representing the default text height:
   ///   - `45.5` for `tvOS`
   ///   - `18` for `macOS`
   ///   - `20.5` for other platforms (e.g., `iOS`)
   ///
   /// ## Usage Example:
   /// ```swift
   /// Text("...")
   ///   .frame(height: .defaultTextHeight)
   /// ```
   public static var defaultTextHeight: Self {
      #if os(tvOS)
      return 45.5
      #elseif os(macOS)
      return 18
      #else
      return 20.5
      #endif
   }
}
#endif
