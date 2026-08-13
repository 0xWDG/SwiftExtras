//
//  PictureInPictureLayerView.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(AVKit) && !os(watchOS)
import AVKit
import SwiftUI

#if canImport(UIKit)
import UIKit

struct PictureInPictureLayerView: UIViewRepresentable {
    let displayLayer: AVSampleBufferDisplayLayer
    let preferredSize: CGSize?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isAccessibilityElement = false
        view.layer.addSublayer(displayLayer)
        updateDisplayLayer(in: view)
        return view
    }

    func updateUIView(_ view: UIView, context: Context) {
        updateDisplayLayer(in: view)
    }

    private func updateDisplayLayer(in view: UIView) {
        displayLayer.frame = CGRect(
            origin: .zero,
            size: preferredSize ?? view.bounds.size
        )
    }
}
#elseif canImport(AppKit)
import AppKit

struct PictureInPictureLayerView: NSViewRepresentable {
    let displayLayer: AVSampleBufferDisplayLayer
    let preferredSize: CGSize?

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.wantsLayer = true
        view.setAccessibilityElement(false)
        view.layer?.addSublayer(displayLayer)
        updateDisplayLayer(in: view)
        return view
    }

    func updateNSView(_ view: NSView, context: Context) {
        updateDisplayLayer(in: view)
    }

    private func updateDisplayLayer(in view: NSView) {
        displayLayer.frame = CGRect(
            origin: .zero,
            size: preferredSize ?? view.bounds.size
        )
    }
}
#endif

#if DEBUG
@available(iOS 17, macOS 14, tvOS 17, visionOS 1, *)
#Preview("Picture in Picture Layer") {
    ZStack {
        Color.black
            .accessibilityHidden(true)

        PictureInPictureLayerView(
            displayLayer: AVSampleBufferDisplayLayer(),
            preferredSize: CGSize(width: 320, height: 180)
        )
        .accessibilityHidden(true)

        Label("Rendering layer", systemImage: "pip.fill")
            .foregroundStyle(.white)
    }
    .frame(width: 320, height: 180)
}
#endif
#endif
