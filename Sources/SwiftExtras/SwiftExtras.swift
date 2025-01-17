//
//  SwiftExtras.swift
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
#if canImport(UIKit)
import UIKit

typealias ViewRepresentable = UIViewRepresentable
#elseif canImport(AppKit)
import AppKit

typealias ViewRepresentable = NSViewRepresentable
#endif
#endif
