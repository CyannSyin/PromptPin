// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "PromptPin",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "PromptPin", targets: ["PromptPin"])
    ],
    targets: [
        .executableTarget(
            name: "PromptPin",
            path: "Sources/PromptPin"
        ),
        .testTarget(
            name: "PromptPinTests",
            dependencies: ["PromptPin"]
        )
    ]
)
