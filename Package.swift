// swift-tools-version: 5.8.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftExtras",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftExtras",
            targets: ["SwiftExtras"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/0xWDG/OSLogViewer.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftExtras",
            dependencies: [
                .product(name: "OSLogViewer", package: "OSLogViewer")
            ]
        ),
        .testTarget(
            name: "SwiftExtrasTests",
            dependencies: ["SwiftExtras"]
        )
    ]
)
