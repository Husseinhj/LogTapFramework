//
//  LogTapPrintBridge.swift (Noop)
//

import Foundation

public final class LogTapPrintBridge {
    public static let shared = LogTapPrintBridge()
    public init() {}

    public var parseLevelTokens: Bool = true
    public var useCallerAsDefaultTag: Bool = true

    public func start(sink: LogTapLogSink, captureStdout: Bool = true, captureStderr: Bool = true) {}
    public func stop() {}
    public func emitDirect(message: String, level: LogLevel = .debug, tag: String? = nil) {}
}

public func logtapPrint(_ items: Any...,
                        separator: String = " ",
                        terminator: String = "\n",
                        level: LogLevel = .debug,
                        fileID: String = #fileID) {
    let msg = items.map { String(describing: $0) }.joined(separator: separator)
    fputs((msg + terminator), stdout)
}
