// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CodeWhisper",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/9t29zhmwdh-coder/SwiftAgent.git", from: "1.1.0")
    ],
    targets: [
        .executableTarget(
            name: "CodeWhisper",
            dependencies: [
                .product(name: "SwiftAgent", package: "SwiftAgent")
            ],
            path: "Sources/CodeWhisper",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "CodeWhisperTests",
            dependencies: [
                "CodeWhisper",
                .product(name: "SwiftAgent", package: "SwiftAgent")
            ],
            path: "Tests/CodeWhisperTests",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
    ]
)
