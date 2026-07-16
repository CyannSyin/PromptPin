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
            path: "Sources/PromptPin",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "PromptPinTests",
            dependencies: ["PromptPin"]
        )
    ]
)
