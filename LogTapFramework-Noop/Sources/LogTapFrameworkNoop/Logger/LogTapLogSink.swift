//
//  LogTapLogSink.swift (Noop)
//

import Foundation

public protocol LogTapLogSink {
    func emitLog(level: LogLevel, tag: String?, message: String)
}
