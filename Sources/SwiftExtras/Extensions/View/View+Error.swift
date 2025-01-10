//
//  View+showError.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import SwiftUI

extension View {
    /// Show an error if there is any
    /// - Parameters:
    ///   - error: <#error description#>
    ///   - buttonTitle: <#buttonTitle description#>
    /// - Returns: <#description#>
    @available(iOS 15.0, *)
    public func showError(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        alert(
            error.wrappedValue?.localizedDescription ?? "Unknown error",
            isPresented: .constant(error.wrappedValue != nil)
        ) {
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        }
    }
}

public struct CustomError: Error {
    let message: String

    public init(message: String) {
        self.message = message
    }
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        NSLocalizedString(message, comment: "")
    }
}
