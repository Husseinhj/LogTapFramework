//
//  LogTap.swift (Noop)
//
//  API-compatible no-op variant of LogTap for release builds.
//  Keep symbol parity with Sources/LogTapFramework/LogTap.swift.
//

import Foundation

public final class LogTap {
    public struct Config {
        public var port: Int = 8790
        public var capacity: Int = 5000
        public var maxBodyBytes: Int = 64_000
        public var redactHeaders: Set<String> = ["Authorization", "Cookie", "Set-Cookie"]
        public var enableOnRelease: Bool = false

        public init() {}
    }

    public static let shared = LogTap()
    private init() {}

    public private(set) var config = Config()

    public func start(_ cfg: Config = Config()) {
        self.config = cfg
    }

    public func stop() {}

    func emit(_ ev: LogEvent) {}

    static func makeBodyPreview(data: Data?, contentType: String?) -> String? { nil }

    static func readStream(_ stream: InputStream, maxBytes: Int) -> Data { Data() }

    public func urls() -> [String] { [] }
}
