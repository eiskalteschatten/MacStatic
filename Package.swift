// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MacStatic",
    platforms: [
        .macOS(.v15),
        .iOS(.v18)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "MacStaticCore", targets: ["MacStaticCore"]),
        .executable(name: "MacStaticCLI", targets: ["MacStaticCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(name: "MacStaticCore"),
        .executableTarget(
            name: "MacStaticCLI",
            dependencies: [
                "MacStaticCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        ),
        .testTarget(
            name: "MacStaticCoreTests",
            dependencies: ["MacStaticCore"]
        ),
    ]
)
