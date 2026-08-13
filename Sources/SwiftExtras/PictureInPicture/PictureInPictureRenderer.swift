//
//  PictureInPictureRenderer.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2026-08-13.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI) && canImport(AVFoundation) && !os(watchOS)
import AVFoundation
import SwiftUI

enum PictureInPictureRenderingError: Error {
    case emptyView
    case pixelBuffer(OSStatus)
    case graphicsContext
    case formatDescription(OSStatus)
}

@MainActor
struct PictureInPictureRenderer<Content: View> {
    let renderer: ImageRenderer<Content>

    init(content: Content) {
        renderer = ImageRenderer(content: content)
    }

    func makeSampleBuffer() throws -> CMSampleBuffer {
        var renderedPixelBuffer: Result<CVPixelBuffer, Error>?
        let scale = displayScale

        renderer.render { size, draw in
            renderedPixelBuffer = Result {
                try makePixelBuffer(size: size, scale: scale, draw: draw)
            }
        }

        guard let renderedPixelBuffer else {
            throw PictureInPictureRenderingError.pixelBuffer(kCVReturnError)
        }
        return try makeSampleBuffer(from: renderedPixelBuffer.get())
    }

    private func makePixelBuffer(
        size: CGSize,
        scale: CGFloat,
        draw: (CGContext) -> Void
    ) throws -> CVPixelBuffer {
        let pixelSize = CGSize(width: size.width * scale, height: size.height * scale)
        guard pixelSize.width >= 1, pixelSize.height >= 1 else {
            throw PictureInPictureRenderingError.emptyView
        }

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(pixelSize.width.rounded(.up)),
            Int(pixelSize.height.rounded(.up)),
            kCVPixelFormatType_32ARGB,
            pixelBufferAttributes,
            &pixelBuffer
        )
        guard let pixelBuffer, status == kCVReturnSuccess else {
            throw PictureInPictureRenderingError.pixelBuffer(status)
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }

        guard let context = graphicsContext(for: pixelBuffer) else {
            throw PictureInPictureRenderingError.graphicsContext
        }
        context.scaleBy(x: scale, y: scale)
        draw(context)
        return pixelBuffer
    }

    private func makeSampleBuffer(from pixelBuffer: CVPixelBuffer) throws -> CMSampleBuffer {
        var formatDescription: CMFormatDescription?
        let formatStatus = CMVideoFormatDescriptionCreateForImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: pixelBuffer,
            formatDescriptionOut: &formatDescription
        )

        guard let formatDescription, formatStatus == noErr else {
            throw PictureInPictureRenderingError.formatDescription(formatStatus)
        }

        let timestamp = CMTime(
            seconds: CACurrentMediaTime(),
            preferredTimescale: 600
        )
        let timing = CMSampleTimingInfo(
            duration: CMTime(value: 1, timescale: 30),
            presentationTimeStamp: timestamp,
            decodeTimeStamp: .invalid
        )

        return try CMSampleBuffer(
            imageBuffer: pixelBuffer,
            formatDescription: formatDescription,
            sampleTiming: timing
        )
    }

    private var pixelBufferAttributes: CFDictionary {
        [
            kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue as Any,
            kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue as Any,
            kCVPixelBufferIOSurfacePropertiesKey: [:] as CFDictionary
        ] as CFDictionary
    }

    private func graphicsContext(for pixelBuffer: CVPixelBuffer) -> CGContext? {
        CGContext(
            data: CVPixelBufferGetBaseAddress(pixelBuffer),
            width: CVPixelBufferGetWidth(pixelBuffer),
            height: CVPixelBufferGetHeight(pixelBuffer),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
    }

    private var displayScale: CGFloat {
        #if canImport(UIKit)
        UIScreen.main.scale
        #elseif canImport(AppKit)
        NSScreen.main?.backingScaleFactor ?? 1
        #else
        1
        #endif
    }
}
#endif
