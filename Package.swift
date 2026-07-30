// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ServiceLLM",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/9t29zhmwdh-coder/EmissaryKit.git", from: "1.2.0")
    ],
    targets: [
        .executableTarget(
            name: "ServiceLLM",
            dependencies: [
                .product(name: "EmissaryKit", package: "EmissaryKit")
            ],
            path: "Sources/ServiceLLM",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "ServiceLLMTests",
            dependencies: [
                "ServiceLLM",
                .product(name: "EmissaryKit", package: "EmissaryKit")
            ],
            path: "Tests/ServiceLLMTests",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
    ]
)
