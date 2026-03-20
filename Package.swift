// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]
        )
    ],
    targets: [
        .target(
            name: "UIComponents",
            path: "Sources/UIComponents"
        ),
        .testTarget(
            name: "UIComponentsTests",
            dependencies: ["UIComponents"],
            path: "Tests/UIComponentsTests"
        )
    ]
)