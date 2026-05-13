//
//  LogTapSinkAdapter.swift (Noop)
//

import Foundation

public final class LogTapSinkAdapter: LogTapLogSink {
    public init() {}
    public func emitLog(level: LogLevel, tag: String?, message: String) {}
}
