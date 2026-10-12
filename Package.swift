// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "myatlas",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "MyAtlasCore", targets: ["MyAtlasCore"])
    ],
    targets: [
        .target(name: "MyAtlasCore"),
        .testTarget(name: "MyAtlasCoreTests", dependencies: ["MyAtlasCore"])
    ]
)