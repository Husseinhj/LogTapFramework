// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LogTapFrameworkNoop",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "LogTapFrameworkNoop",
            targets: ["LogTapFrameworkNoop"]
        )
    ],
    targets: [
        .target(
            name: "LogTapFrameworkNoop",
            path: "Sources/LogTapFrameworkNoop"
        )
    ]
)
