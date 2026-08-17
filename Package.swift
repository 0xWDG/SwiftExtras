// swift-tools-version: 5.8.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

var products: [Product] = [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
        name: "SwiftExtras",
        targets: ["SwiftExtras"]
    ),
    .library(
        name: "SwiftExtrasScreenshotTesting",
        targets: ["SwiftExtrasScreenshotTesting"]
    ),
    .executable(
        name: "SwiftExtrasScreenshots",
        targets: ["SwiftExtrasScreenshots"]
    )
]

var targets: [Target] = [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
        name: "SwiftExtras",
        dependencies: [
            .product(name: "OSLogViewer", package: "OSLogViewer")
        ],
        resources: [
            .process("Assets.xcassets"),
            .process("Localizable.xcstrings")
        ]
    ),
    .testTarget(
        name: "SwiftExtrasTests",
        dependencies: ["SwiftExtras", "SwiftExtrasScreenshotTesting"]
    ),
    .target(
        name: "SwiftExtrasScreenshotTesting",
        dependencies: ["SwiftExtras"]
    ),
    .executableTarget(
        name: "SwiftExtrasScreenshots",
        dependencies: ["SwiftExtras"],
        path: "Tools/SwiftExtrasScreenshots"
    )
]

#if os(macOS)
products.append(
    .executable(
        name: "SwiftExtrasDemo",
        targets: ["SwiftExtrasDemo"]
    )
)

targets.append(
    .executableTarget(
        name: "SwiftExtrasDemo",
        dependencies: ["SwiftExtras"],
        path: "Tools/SwiftExtrasDemo"
    )
)
#endif

let package = Package(
    name: "SwiftExtras",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: products,
    dependencies: [
        .package(url: "https://github.com/0xWDG/OSLogViewer.git", branch: "main")
    ],
    targets: targets
)
