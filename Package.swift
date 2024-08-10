// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-doro-webdav-client",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "swift-doro-webdav-client",
            targets: ["swift-doro-webdav-client"]),
    ],
    targets: [
        .target(
            name: "swift-doro-webdav-client"),
        .testTarget(
            name: "swift-doro-webdav-clientTests",
            dependencies: ["swift-doro-webdav-client"]),
    ]
)
