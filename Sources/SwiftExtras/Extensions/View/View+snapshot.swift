//
//  View+snapshot.swift
//  SwiftExtras
//
//  Created by Wesley de Groot on 2025-09-11.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/SwiftExtras
//  MIT License
//

#if canImport(SwiftUI)
import SwiftUI


extension View {
    /// Captures a snapshot of the current view and returns it as a `PlatformImage`.
    /// - Parameter size: The desired size of the snapshot. Defaults to the device's screen size.
    /// - Returns: A `PlatformImage` representing the snapshot of the view.
    /// - Note: This function is only available on iOS, tvOS, visionOS, and macOS.
    @available(iOS 13.0, tvOS 13.0, visionOS 1.0, macOS 10.15, *)
    public func snapshot(size: CGSize = .device) -> PlatformImage {
        #if os(iOS) || os(tvOS) || os(visionOS)
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }

        #elseif os(macOS)
        let hostingView = NSHostingView(rootView: self)
        hostingView.frame = CGRect(origin: .zero, size: size)

        let bitmapRep = hostingView.bitmapImageRepForCachingDisplay(in: hostingView.bounds)!
        hostingView.cacheDisplay(in: hostingView.bounds, to: bitmapRep)

        let image = NSImage(size: size)
        image.addRepresentation(bitmapRep)
        return image

        #else
        fatalError("snapshot() is not implemented for this platform.")
        #endif
    }

    /// Captures a snapshot of the current view and save it to the desktiop.
    /// - Parameter name: Image name
    /// - Parameter size: The desired size of the snapshot. Defaults to the device's screen size.
    /// - Returns: A `PlatformImage` representing the snapshot of the view.
    /// - Note: This function is only available on iOS, tvOS, visionOS, and macOS.
    @available(iOS 13.0, tvOS 13.0, visionOS 1.0, macOS 10.15, *)
    @discardableResult
    public func snapshot(name: String, size: CGSize = .device) -> some View {
#if targetEnvironment(simulator)
        // We will write the snapshot to the desktop directory in the simulator for easy access.
        let image = self.snapshot(size: size)
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let fileURL = desktopURL.appendingPathComponent("\(AppInfo.appName)_\(name)_\(size.width)x\(size.height).png")

        try? image.pngData()?.write(to: fileURL)
#endif
        return self
    }
}
#endif
