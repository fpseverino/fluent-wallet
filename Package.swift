// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "fluent-wallet",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "FluentWalletPasses", targets: ["FluentWalletPasses"]),
        .library(name: "FluentWalletOrders", targets: ["FluentWalletOrders"]),
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
        .target(
            name: "FluentWalletPasses",
            dependencies: [
                .target(name: "FluentWallet"),
                .product(name: "WalletPasses", package: "swift-wallet"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FluentWalletPassesTests",
            dependencies: [
                .target(name: "FluentWalletPasses"),
                .product(name: "XCTFluent", package: "fluent-kit"),
            ],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "FluentWalletOrders",
            dependencies: [
                .target(name: "FluentWallet"),
                .product(name: "WalletOrders", package: "swift-wallet"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "FluentWalletOrdersTests",
            dependencies: [
                .target(name: "FluentWalletOrders"),
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
