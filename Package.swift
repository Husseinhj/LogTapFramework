// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LogTapFramework",
    platforms: [
        .iOS(.v15),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "LogTapFramework",
            targets: ["LogTapFramework"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.63.0"),
        .package(url: "https://github.com/apple/swift-nio-transport-services.git", from: "1.20.0"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.13.0")
    ],
    targets: [
        .target(
            name: "LogTapFramework",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOTransportServices", package: "swift-nio-transport-services"),
                .product(name: "WebSocketKit", package: "websocket-kit")
            ],
            path: "LogTapFramework/Sources/LogTapFramework"
        )
    ]
)
