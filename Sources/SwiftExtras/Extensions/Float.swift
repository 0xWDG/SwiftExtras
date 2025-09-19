//
//  Error+errorCode.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-07-19.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import Foundation

extension Float {
    /// Remove any decimals
    public var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
