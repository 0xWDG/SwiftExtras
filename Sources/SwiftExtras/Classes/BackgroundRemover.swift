//
//  BackgroundRemover.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-01-10.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(Vision) && canImport(CoreImage.CIFilterBuiltins)
import Vision
import CoreImage.CIFilterBuiltins
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

@available(iOS 17.0, macOS 14.0, *)
class BackgroundRemoverHelper {
    enum Errors: Error {
        case failedToUnwrapImage
        case failedToCreateCIImage
        case failedToRenderCGImage
        case failedToApplyMask
        case failedToCreateMask
        case invalidImageData
    }

#if os(macOS)
    typealias PlatformNativeImage = NSImage
#else
    typealias PlatformNativeImage = UIImage
#endif

    private func removeBackground(from inputImage: CIImage) throws -> PlatformNativeImage {
        let context = CIContext(options: nil)

        guard let maskImage = createMask(from: inputImage) else {
            throw Errors.failedToCreateMask
        }
        guard let outputImage = applyMask(mask: maskImage, to: inputImage) else {
            throw Errors.failedToApplyMask
        }

        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            throw Errors.failedToRenderCGImage
        }

        return PlatformNativeImage(cgImage: cgImage)
    }

    private func createMask(from inputImage: CIImage) -> CIImage? {
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(ciImage: inputImage)

        do {
            try handler.perform([request])
            if let result = request.results?.first {
                let mask = try result.generateScaledMaskForImage(
                    forInstances: result.allInstances,
                    from: handler
                )

                return CIImage(cvPixelBuffer: mask)
            }
        } catch {
            print(error)
        }

        return nil
    }

    private func applyMask(mask: CIImage, to image: CIImage) -> CIImage? {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage
    }

    /// Removes the background from the image.
    ///
    /// - Parameter image: The image from which to remove the background.
    /// - Returns: The image with the background removed.
    public func parse(image: PlatformNativeImage) throws -> PlatformNativeImage {
#if os(iOS)
        guard let ciImage = CIImage(image: image) else {
            throw Errors.failedToCreateCIImage
        }
#else
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw Errors.failedToCreateCIImage
        }
        let ciImage = CIImage(cgImage: cgImage)
#endif

        return try removeBackground(from: ciImage)
    }
}

#if canImport(SwiftUI)
import SwiftUI
@available(iOS 17.0, macOS 14.0, *)
extension Image {
    /// Removes the background from the image.
    @MainActor
    func removeBackground() -> Image? {
        guard let nativeImage = self.asNativeImage else {
            return nil
        }

        return try? Image(
            platformImage: BackgroundRemoverHelper().parse(image: nativeImage)
        )
    }
}
#endif

#if canImport(UIKit) || canImport(AppKit)
extension PlatformImage {
    /// Removes the background from the image.
    @available(iOS 17.0, macOS 14.0, *)
    public func removeBackground() -> PlatformImage? {
        return try? BackgroundRemoverHelper().parse(image: self)
    }
}
#endif
#endif
