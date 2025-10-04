// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LogTapSample",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(
            name: "LogTapSample",
            targets: ["LogTapSample"]
        )
    ],
    dependencies: [
        .package(path: "../LogTapFramework")
    ],
    targets: [
        .executableTarget(
            name: "LogTapSample",
            dependencies: [
                .product(name: "LogTapFramework", package: "LogTapFramework")
            ],
            path: "Sources/LogTapSample"
        )
    ]
)
