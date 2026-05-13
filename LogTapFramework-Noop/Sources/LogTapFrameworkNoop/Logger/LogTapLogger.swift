//
//  LogTapLogger.swift (Noop)
//

import Foundation

public enum BuildMode {
    case debug, release
}

public final class LogTapLogger {
    public static let shared = LogTapLogger()
    private init() {}

    public var debugMode: Bool = false
    public var allowReleaseLogging: Bool = false
    public var minLevel: LogLevel = .debug

    public func log(_ level: LogLevel,
                    _ message: @autoclosure () -> String,
                    tag: String? = nil,
                    file: StaticString = #fileID,
                    function: StaticString = #function,
                    line: UInt = #line) {}
}

public func logV(_ msg: @autoclosure () -> String, file: String = #file, line: UInt = #line) {}
public func logD(_ msg: @autoclosure () -> String, file: String = #file, line: UInt = #line) {}
public func logI(_ msg: @autoclosure () -> String, file: String = #file, line: UInt = #line) {}
public func logW(_ msg: @autoclosure () -> String, file: String = #file, line: UInt = #line) {}
public func logE(_ msg: @autoclosure () -> String, file: String = #file, line: UInt = #line) {}
public func logA(_ msg: @autoclosure () -> String, file: String = #file, line: UInt = #line) {}
