// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIEnvironment",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "UIEnvironment",
            targets: ["UIEnvironment"]),
    ],
    dependencies: [
        .package(url: "https://github.com/623637646/SwiftHook", from: "3.5.2")
    ],
    targets: [
        .target(
            name: "UIEnvironment",
            dependencies: [
                .product(name: "SwiftHook", package: "SwiftHook")
            ]),
    ]
)
