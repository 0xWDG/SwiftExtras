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
//  Blog: https://wesleydegroot.nl/blog/Remove-the-background-from-images-using-Swift

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
        /// Failed to unwrap the image.
        case failedToUnwrapImage

        /// Failed to create a CIImage from the input image.
        case failedToCreateCIImage

        /// Failed to render the CGImage.
        case failedToRenderCGImage

        /// Failed to apply the mask to the image.
        case failedToApplyMask

        /// Failed to create the mask.
        case failedToCreateMask

        /// Invalid image data.
        case invalidImageData
    }

    /// Removes the background from the image.
    ///
    /// - Parameter inputImage: The image from which to remove the background.
    /// - Returns: The image with the background removed.
    private func removeBackground(from inputImage: CIImage) throws -> PlatformImage {
        // Create a CIContext to render the output image
        let context = CIContext(options: nil)

        // Create a mask image, see createMask(from:)
        guard let maskImage = createMask(from: inputImage) else {
            throw Errors.failedToCreateMask
        }
        // Apply the mask to the input image, see applyMask(mask:to:)
        guard let outputImage = applyMask(mask: maskImage, to: inputImage) else {
            throw Errors.failedToApplyMask
        }

        // Render the output image
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            // Failed to render CGImage
            throw Errors.failedToRenderCGImage
        }

        // Create the final output image
        return PlatformImage(cgImage: cgImage)
    }

    /// Creates a mask from the input image.
    ///
    /// - Parameter inputImage: The image from which to create the mask.
    /// - Returns: The mask image, or nil if creation failed.
    private func createMask(from inputImage: CIImage) -> CIImage? {
        // Create a request to generate the foreground instance mask
        let request = VNGenerateForegroundInstanceMaskRequest()
        // Create a handler for the image request
        let handler = VNImageRequestHandler(ciImage: inputImage)

        do {
            // Perform the request
            try handler.perform([request])
            // Get the first result
            if let result = request.results?.first {
                // Generate the mask for the image
                let mask = try result.generateScaledMaskForImage(
                    forInstances: result.allInstances,
                    from: handler
                )

                // Create the final mask image
                return CIImage(cvPixelBuffer: mask)
            }
        } catch {
            // Failed to generate mask
            print(error)
        }

        // Failed to generate mask
        return nil
    }

    /// Applies the mask to the image.
    ///
    /// - Parameters:
    ///   - mask: The mask image to apply.
    ///   - image: The image to which the mask will be applied.
    /// - Returns: The image with the mask applied, or nil if the operation failed.
    private func applyMask(mask: CIImage, to image: CIImage) -> CIImage? {
        // Create a blend filter
        let filter = CIFilter.blendWithMask()
        // Set the input image
        filter.inputImage = image
        // Set the mask image
        filter.maskImage = mask
        // Set the background image to be empty
        filter.backgroundImage = CIImage.empty()
        // Return the output image
        return filter.outputImage
    }

    /// Removes the background from the image.
    ///
    /// - Parameter image: The image from which to remove the background.
    /// - Returns: The image with the background removed.
    public func parse(image: PlatformImage) throws -> PlatformImage {
#if os(iOS)
        // iOS: Create a CIImage from the UIImage
        guard let ciImage = CIImage(image: image) else {
            throw Errors.failedToCreateCIImage
        }
#else
        // macOS: Create a CIImage from the NSImage
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            throw Errors.failedToCreateCIImage
        }
        let ciImage = CIImage(cgImage: cgImage)
#endif

        // Remove the background from the image
        return try removeBackground(from: ciImage)
    }
}

#if canImport(SwiftUI)
import SwiftUI
@available(iOS 17.0, macOS 14.0, *)
extension Image {
    /// Removes the background from the image.
    @available(iOS 17.0, macOS 14.0, *)
    @MainActor
    public func removeBackground() -> Image? {
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
