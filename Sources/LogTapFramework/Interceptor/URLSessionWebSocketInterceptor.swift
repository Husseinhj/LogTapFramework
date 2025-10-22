// New file: URLSessionWebSocketInterceptor.swift
// Adds optional interception of URLSessionWebSocketTask send/receive to emit LogTap events.

import Foundation

private var ltAssociatedKey = "lt.websocket.wrapper"

private final class WebSocketAssociated {
    weak var task: URLSessionWebSocketTask?
    var logger: LogTapWebSocket?
}

extension URLSessionWebSocketTask {
    // Our swizzled send implementation. Kept as a Swift-only method (not @objc) because the
    // Message type used by URLSessionWebSocketTask is not representable in Objective-C.
    fileprivate func lt_send(_ message: Any, completionHandler: @escaping (Error?) -> Void) {
        // Log outbound message if we can
        if let str = extractString(from: message) {
            LogTap.shared.emit(
                LogEvent(
                    kind: .websocket,
                    direction: .outbound,
                    summary: "WS → text \(str.prefix(80))\(str.count > 80 ? "…" : "")",
                    bodyPreview: str,
                    bodyIsTruncated: str.count > 10_000,
                    tag: "WebSocket"
                )
            )
        } else if let data = extractData(from: message) {
            LogTap.shared.emit(
                LogEvent(
                    kind: .websocket,
                    direction: .outbound,
                    summary: "WS → binary \(data.count) bytes",
                    bodyBytes: data.count,
                    tag: "WebSocket"
                )
            )
        } else {
            LogTap.shared.emit(
                LogEvent(
                    kind: .websocket,
                    direction: .outbound,
                    summary: "WS → (unknown message)",
                    tag: "WebSocket"
                )
            )
        }

        // Forward to the real API (avoid recursion). Attempt to map common shapes.
        if let s = extractString(from: message) {
            self.send(.string(s), completionHandler: completionHandler)
            return
        }
        if let d = extractData(from: message) {
            self.send(.data(d), completionHandler: completionHandler)
            return
        }
        if let m = message as? URLSessionWebSocketTask.Message {
            self.send(m, completionHandler: completionHandler)
            return
        }
        // Unknown shape: call completion with an error to avoid blocking caller forever.
        let err = NSError(domain: "LogTapWebSocket", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unsupported message type"])
        completionHandler(err)
    }

    // Our swizzled receive implementation - Swift-only for the same reason as send.
    fileprivate func lt_receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        // Wrap the completion to emit logs before forwarding
        let wrapped: (Result<URLSessionWebSocketTask.Message, Error>) -> Void = { res in
            switch res {
            case .success(let msg):
                switch msg {
                case .string(let s):
                    LogTap.shared.emit(
                        LogEvent(
                            kind: .websocket,
                            direction: .inbound,
                            summary: "WS ← text \(s.prefix(80))\(s.count > 80 ? "…" : "")",
                            bodyPreview: s,
                            bodyIsTruncated: s.count > 10_000,
                            tag: "WebSocket"
                        )
                    )
                case .data(let d):
                    LogTap.shared.emit(
                        LogEvent(
                            kind: .websocket,
                            direction: .inbound,
                            summary: "WS ← binary \(d.count) bytes",
                            bodyBytes: d.count,
                            tag: "WebSocket"
                        )
                    )
                @unknown default:
                    LogTap.shared.emit(
                        LogEvent(
                            kind: .websocket,
                            direction: .inbound,
                            summary: "WS ← (unknown message)",
                            tag: "WebSocket"
                        )
                    )
                }
                completionHandler(.success(msg))
            case .failure(let err):
                LogTap.shared.emit(
                    LogEvent(
                        kind: .websocket,
                        direction: .error,
                        summary: "WS ERROR \(err.localizedDescription)",
                        reason: err.localizedDescription,
                        tag: "WebSocket"
                    )
                )
                completionHandler(.failure(err))
            }
        }

        // Call the real receive API (avoid recursion).
        self.receive(completionHandler: wrapped)
    }

    // NOTE: We intentionally do NOT provide @objc swizzled implementations for resume/cancel
    // because swizzling Foundation task methods is fragile and can lead to unrecognized selector
    // exceptions on concrete task classes. Instead consumers should explicitly attach/detach
    // the LogTapWebSocket behavior using the safe APIs below.

    // Public API to attach LogTap's receive loop and logging to a websocket-capable task.
    // This is safe to call and performs runtime checks to ensure the task supports receive.
    public static func attach(task: URLSessionWebSocketTask) {
        let sel = Selector(("receiveMessageWithCompletionHandler:"))
        let u = task.originalRequest?.url?.absoluteString ?? "(unknown)"
        guard (task as AnyObject).responds(to: sel) else {
            LogTap.shared.emit(
                LogEvent(
                    kind: .websocket,
                    direction: .state,
                    summary: "WS OPEN \(u) (receive not supported)",
                    url: u,
                    status: nil,
                    tag: "WebSocket"
                )
            )
            return
        }

        // set up an associated LogTapWebSocket to run the receive loop
        let assoc = WebSocketAssociated()
        assoc.task = task
        assoc.logger = LogTapWebSocket(task: task)
        objc_setAssociatedObject(task, &ltAssociatedKey, assoc, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        // Emit open state
        LogTap.shared.emit(
            LogEvent(
                kind: .websocket,
                direction: .state,
                summary: "WS OPEN \(u)",
                url: u,
                status: nil,
                tag: "WebSocket"
            )
        )

        // start Long-lived receive loop
        assoc.logger?.receiveLoop()
    }

    // Public API to detach LogTap from a task and emit a close event.
    public static func detach(task: URLSessionWebSocketTask) {
        if let assoc = objc_getAssociatedObject(task, &ltAssociatedKey) as? WebSocketAssociated {
            assoc.logger?.cancel()
            objc_setAssociatedObject(task, &ltAssociatedKey, nil, .OBJC_ASSOCIATION_ASSIGN)
            LogTap.shared.emit(
                LogEvent(
                    kind: .websocket,
                    direction: .state,
                    summary: "WS CLOSE (detached)",
                    tag: "WebSocket"
                )
            )
        } else {
            // Fallback: call cancel on the underlying task to ensure closure
            task.cancel()
            LogTap.shared.emit(
                LogEvent(
                    kind: .websocket,
                    direction: .state,
                    summary: "WS CLOSE (task cancelled)",
                    tag: "WebSocket"
                )
            )
        }
    }
}

// Helpers to extract string/data from the opaque message parameter when swizzled
private func extractString(from any: Any) -> String? {
    // try direct cast
    if let s = any as? String { return s }
    // if it's the Message enum, handle
    if let msg = any as? URLSessionWebSocketTask.Message {
        switch msg {
        case .string(let s): return s
        default: break
        }
    }
    // fallback to description parsing
    let d = String(describing: any)
    if d.hasPrefix("string(") {
        // crude extraction
        if let start = d.firstIndex(of: "\"") {
            let trimmed = d[d.index(after: start)...]
            if let end = trimmed.firstIndex(of: "\"") {
                return String(trimmed[..<end])
            }
        }
    }
    return nil
}

private func extractData(from any: Any) -> Data? {
    if let d = any as? Data { return d }
    if let msg = any as? URLSessionWebSocketTask.Message {
        switch msg {
        case .data(let d): return d
        default: break
        }
    }
    // Description-based fallback - not reliable
    return nil
}

// Installer to perform method swizzling. Safe to call multiple times.
public final class URLSessionWebSocketInterceptor {
    public static func install() {
        // Swizzling resume/cancel across URLSessionTask subclasses is fragile and can
        // cause unrecognized selector crashes when concrete task classes do not
        // implement the swapped selectors (class clustering in Foundation).
        // To avoid crashing host apps, this installer is intentionally a no-op.
        //
        // If you need automatic interception for websocket tasks, prefer the
        // explicit `makeLoggedWebSocket(session:url:)` wrapper which is safe and
        // does not rely on swizzling.
        return
    }
}
