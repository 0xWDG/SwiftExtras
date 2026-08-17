//
//  SwiftExtrasDemo.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-16.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

import SwiftExtras
import SwiftUI

@main
@available(macOS 14, *)
struct SwiftExtrasDemoApp: App {
    var body: some Scene {
        WindowGroup {
            DemoRootView()
        }
        .defaultSize(width: 1_180, height: 780)
    }
}

@available(macOS 14, *)
#Preview("Demo App") {
    DemoRootView()
        .frame(width: 1_180, height: 780)
}
