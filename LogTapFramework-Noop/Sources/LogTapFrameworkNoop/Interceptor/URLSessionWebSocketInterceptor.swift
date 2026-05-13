//
//  URLSessionWebSocketInterceptor.swift (Noop)
//

import Foundation

extension URLSessionWebSocketTask {
    public static func attach(task: URLSessionWebSocketTask) {}
    public static func detach(task: URLSessionWebSocketTask) {}
}

public final class URLSessionWebSocketInterceptor {
    public static func install() {}
}
