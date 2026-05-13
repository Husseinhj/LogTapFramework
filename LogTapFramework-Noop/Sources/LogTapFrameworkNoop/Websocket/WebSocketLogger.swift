//
//  WebSocketLogger.swift (Noop)
//

import Foundation

public final class LogTapWebSocket {
    private let task: URLSessionWebSocketTask

    public init(task: URLSessionWebSocketTask) {
        self.task = task
    }

    public func resume() { task.resume() }
    public func send(_ text: String) { task.send(.string(text)) { _ in } }
    public func send(_ data: Data) { task.send(.data(data)) { _ in } }
    public func cancel(with closeCode: URLSessionWebSocketTask.CloseCode = .normalClosure, reason: Data? = nil) {
        task.cancel(with: closeCode, reason: reason)
    }
}

public func makeLoggedWebSocket(session: URLSession = .shared, url: URL) -> LogTapWebSocket {
    LogTapWebSocket(task: session.webSocketTask(with: url))
}
