// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
#if canImport(UIKit)
import UIKit
#endif
import NIO
import NIOHTTP1
import NIOTransportServices

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
    
    /// The active configuration. `port` is the port the server is actually bound
    /// to, which can differ from the requested one when it was taken, and can
    /// change later when a re-bind after backgrounding has to move.
    public var config: Config {
        var cfg = activeConfig
        if let port = server.currentPort { cfg.port = port }
        return cfg
    }
    /// The configuration passed to `start(_:)`, and only written there. Its `port`
    /// is the requested one; `config` overlays the server's bound port.
    private var activeConfig = Config()
    private let server = LogTapServer()
    internal var store = LogTapStore(capacity: 5000)
    private var foregroundObserver: NSObjectProtocol?
    
    // MARK: Lifecycle
    
    public func start(_ cfg: Config = Config()) {
        self.activeConfig = cfg
        self.store = LogTapStore(capacity: cfg.capacity)
        
        // Router closure: serve UI, API, and WS
        let router: LogTapRouter = { head, body in
            let path = URLComponents(string: head.uri)?.path ?? head.uri
            switch (head.method, path) {
            case (.GET, "/"):
                var bb = ByteBufferAllocator().buffer(capacity: Resources.indexHtml.utf8.count)
                bb.writeString(Resources.indexHtml)
                var h = HTTPHeaders()
                h.add(name: "Content-Type", value: "text/html; charset=utf-8")
                h.add(name: "Content-Length", value: String(bb.readableBytes))
                return (.ok, h, bb, false)
                
            case (.GET, "/app.css"):
                var bb = ByteBufferAllocator().buffer(capacity: Resources.appCss.utf8.count)
                bb.writeString(Resources.appCss)
                var h = HTTPHeaders()
                h.add(name: "Content-Type", value: "text/css; charset=utf-8")
                h.add(name: "Content-Length", value: String(bb.readableBytes))
                return (.ok, h, bb, false)
                
            case (.GET, "/app.js"):
                var bb = ByteBufferAllocator().buffer(capacity: Resources.appJs.utf8.count)
                bb.writeString(Resources.appJs)
                var h = HTTPHeaders()
                h.add(name: "Content-Type", value: "application/javascript; charset=utf-8")
                h.add(name: "Content-Length", value: String(bb.readableBytes))
                return (.ok, h, bb, false)
                
            case (.GET, "/api/logs"):
                let comps = URLComponents(string: head.uri)
                let sinceId = comps?.queryItems?.first(where: {$0.name == "sinceId"})?.value.flatMap(Int64.init)
                let limit = comps?.queryItems?.first(where: {$0.name == "limit"})?.value.flatMap(Int.init) ?? 500
                let list = self.store.snapshot(sinceId: sinceId, limit: limit)
                let data = try! JSONEncoder().encode(list)
                var bb = ByteBufferAllocator().buffer(capacity: data.count)
                bb.writeBytes(data)
                var h = HTTPHeaders()
                h.add(name: "Content-Type", value: "application/json; charset=utf-8")
                h.add(name: "Content-Length", value: String(bb.readableBytes))
                return (.ok, h, bb, false)
                
            case (.GET, "/api/info"):
                let info = DeviceAppInfo.current()
                let data = try! JSONEncoder().encode(info)
                var bb = ByteBufferAllocator().buffer(capacity: data.count)
                bb.writeBytes(data)
                var h = HTTPHeaders()
                h.add(name: "Content-Type", value: "application/json; charset=utf-8")
                h.add(name: "Content-Length", value: String(bb.readableBytes))
                return (.ok, h, bb, false)
                
            case (.POST, "/api/clear"):
                self.store.clear()
                var bb = ByteBufferAllocator().buffer(capacity: 2)
                bb.writeString("ok")
                var h = HTTPHeaders()
                h.add(name: "Content-Type", value: "text/plain; charset=utf-8")
                h.add(name: "Content-Length", value: String(bb.readableBytes))
                return (.ok, h, bb, false)

            case (.GET, "/about"):
                var bb = ByteBufferAllocator().buffer(capacity: Resources.aboutHtml.utf8.count)
                bb.writeString(Resources.aboutHtml)
                var h = HTTPHeaders()
                h.add(name: "Content-Type", value: "text/html; charset=utf-8")
                h.add(name: "Content-Length", value: String(bb.readableBytes))
                return (.ok, h, bb, false)

            case (.GET, "/ws"):
                // upgrade handled by pipeline; nothing to write here
                return (.switchingProtocols, .init(), nil, true)
                
            default:
                var h = HTTPHeaders()
                var bb = ByteBufferAllocator().buffer(capacity: 9)
                bb.writeString("Not Found")
                h.add(name: "Content-Type", value: "text/plain")
                h.add(name: "Content-Length", value: String(bb.readableBytes))
                return (.notFound, h, bb, false)
            }
        }
        
        do {
            // The server scans forward for a free port. `config.port` and `urls()`
            // read the bound port back from the server, so they stay right after a
            // scan here and after any later re-bind that has to move.
            try server.start(port: cfg.port, router: router)
        } catch {
            // Don't swallow the bind failure — that left the server silently down
            // ("this site can't be reached") while still logging "ready" below.
            LogTapLogger.shared.d("LogTap server failed to start on port \(cfg.port): \(error)")
            return
        }

        // iOS reclaims the listener while the app is suspended; re-check it every
        // time the app comes back so the viewer URL works again without a relaunch.
        observeForeground()

        // Broadcast on new events
        _ = store.subscribe { [weak self] ev in
            self?.server.broadcast(event: ev)
        }

        // NOTE: Automatic interceptor installation disabled to avoid fragile swizzling.
        // Use the explicit `makeLoggedWebSocket(session:url:)` wrapper or
        // `URLSessionWebSocketTask.attach(task:)` to enable WebSocket logging.


        // helpful boot log — only reached when the bind actually succeeded
        let urls = self.urls()
        LogTapLogger.shared.d("LogTap server ready at \(urls.joined(separator: ", "))")
    }
    
    public func stop() {
        server.stop()
    }

    /// Registered once for the life of the process (`LogTap` is a singleton), and
    /// intentionally never removed: after `stop()` the server ignores the call.
    private func observeForeground() {
#if canImport(UIKit)
        guard foregroundObserver == nil else { return }
        foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.server.ensureListening()
        }
#endif
    }
    
    // MARK: Emit
    
    public func emit(_ ev: LogEvent) {
        store.add(ev)
    }
    
    // MARK: Helpers
    
    static func makeBodyPreview(data: Data?, contentType: String?) -> String? {
        guard let data, !data.isEmpty else { return nil }
        if let ct = contentType?.lowercased(), ct.contains("application/json") {
            if let obj = try? JSONSerialization.jsonObject(with: data),
               let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.sortedKeys, .prettyPrinted]),
               let str = String(data: pretty, encoding: .utf8) {
                return str
            }
        }
        let max = LogTap.shared.config.maxBodyBytes
        return String(data: data.prefix(max), encoding: .utf8) ??
        "(\(data.count) bytes binary)"
    }
    
    static func readStream(_ stream: InputStream, maxBytes: Int) -> Data {
        stream.open()
        defer { stream.close() }
        let bufSize = 16 * 1024
        var data = Data()
        let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: bufSize)
        defer { buf.deallocate() }
        while stream.hasBytesAvailable && data.count < maxBytes {
            let read = stream.read(buf, maxLength: min(bufSize, maxBytes - data.count))
            if read <= 0 { break }
            data.append(buf, count: read)
        }
        return data
    }
    
    public func urls() -> [String] {
        let port = config.port  // read once: it is resolved from the server
        // best-effort LAN IPv4 list
        var addrs: [(iface: String, ip: String)] = []
         var ifaddrPtr: UnsafeMutablePointer<ifaddrs>?
         if getifaddrs(&ifaddrPtr) == 0, let first = ifaddrPtr {
             var ptr: UnsafeMutablePointer<ifaddrs>? = first
             while ptr != nil {
                 let ifa = ptr!.pointee
                 // Skip interfaces that are down or loopback
                 let name = String(cString: ifa.ifa_name)
                 let flags = Int32(ifa.ifa_flags)
                 let isUp = (flags & IFF_UP) == IFF_UP
                 let isLoopback = (flags & IFF_LOOPBACK) == IFF_LOOPBACK
                 if !isUp || isLoopback {
                     ptr = ifa.ifa_next
                     continue
                 }

                 if let sa = ifa.ifa_addr, sa.pointee.sa_family == UInt8(AF_INET) {
                     var addr = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                     if getnameinfo(ifa.ifa_addr, socklen_t(ifa.ifa_addr.pointee.sa_len), &addr, socklen_t(addr.count), nil, 0, NI_NUMERICHOST) == 0 {
                         let ip = String(cString: addr)
                         if ip != "127.0.0.1" {
                             addrs.append((iface: name, ip: ip))
                         }
                     }
                 }
                 ptr = ifa.ifa_next
             }
             freeifaddrs(first)
         }
        // Prefer en0 (typical Wi‑Fi interface on iOS/macOS) if present
        if let en0 = addrs.first(where: { $0.iface == "en0" }) {
            return ["http://\(en0.ip):\(port)/"]
        }
        // Otherwise return all discovered addresses
        return addrs.map { "http://\($0.ip):\(port)/" }
     }
 }
