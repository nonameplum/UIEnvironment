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
    ],
    targets: [
        .target(
            name: "UIEnvironment",
            dependencies: []),
    ]
)