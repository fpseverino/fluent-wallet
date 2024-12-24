// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "fluent-wallet",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "FluentPasses", targets: ["FluentPasses"]),
        .library(name: "FluentOrders", targets: ["FluentOrders"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.49.0"),
        .package(url: "https://github.com/fpseverino/swift-wallet.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "FluentWallet",
            dependencies: [
                .product(name: "FluentKit", package: "fluent-kit")
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FluentWalletTests",
            dependencies: [
                .target(name: "FluentWallet"),
                .product(name: "XCTFluent", package: "fluent-kit"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FluentPasses",
            dependencies: [
                .target(name: "FluentWallet"),
                .product(name: "Passes", package: "swift-wallet"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FluentPassesTests",
            dependencies: [
                .target(name: "FluentPasses"),
                .product(name: "XCTFluent", package: "fluent-kit"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FluentOrders",
            dependencies: [
                .target(name: "FluentWallet"),
                .product(name: "Orders", package: "swift-wallet"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FluentOrdersTests",
            dependencies: [
                .target(name: "FluentOrders"),
                .product(name: "XCTFluent", package: "fluent-kit"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)

var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("ExistentialAny")
    ]
}
