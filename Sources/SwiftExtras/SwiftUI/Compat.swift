//
//  Compat.swift
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

@available(iOS, deprecated: 27.1, message: "Use ArrangementView instead")
/// A compatibility implementation of ``ArrangementView`` for older OSes.
///
/// On iOS 27.1 and later, this view uses `ArrangementView`. On earlier
/// supported releases, it places the primary and secondary views side by side
/// in a regular horizontal size class and shows only the primary view in a
/// compact size class.
///
/// - Important: This type is deprecated in iOS 27.1. Use `ArrangementView`
///   directly when the deployment target permits it.
public struct CompatableArrangementview<Primary: View, Secondary: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSize
    @ViewBuilder var primary: Primary
    @ViewBuilder var secondary: Secondary

    public var body: some View {
#if canImport(SwiftUI, _version: 8.0.85)
        if #available(iOS 27.1, *) {
            ArrangementView {
                primary
            } secondary: {
                secondary
            }
        } else {
            if horizontalSize == .regular {
                HStack {
                    primary
                    secondary
                }
            } else {
                primary
            }
        }
#else
        if horizontalSize == .regular {
            HStack {
                primary
                secondary
            }
        } else {
            primary
        }
#endif
    }
}

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, watchOS 10, *)
#Preview {
    CompatableArrangementview {
        Text("Primary")
    } secondary: {
        Text("Secondary")
    }

}
#endif
#endif
