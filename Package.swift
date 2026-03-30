// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "UIComponents",
    defaultLocalization: "pt-BR",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
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
            path: "UIComponents/Sources/UIComponents",
            resources: [.process("Resources")]
        ),
        .target(
            name: "UICatalog",
            dependencies: ["UIComponents"],
            path: "UIComponents/Sources/UICatalog"
        ),
        .testTarget(
            name: "UIComponentsTests",
            dependencies: ["UIComponents"],
            path: "UIComponents/Tests/UIComponentsTests"
        )
    ]
)
