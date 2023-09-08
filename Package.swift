// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QREncode",
    products: [
        .library(
            name: "QREncode",
            targets: ["QREncode"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.13.1"),
    ],
    targets: [       
        .target(
            name: "QREncode",
            dependencies: [
                .product(name: "NIO", package: "swift-nio")
            ]),
        .testTarget(
            name: "QREncodeTests",
            dependencies: ["QREncode"]),
    ]
)
