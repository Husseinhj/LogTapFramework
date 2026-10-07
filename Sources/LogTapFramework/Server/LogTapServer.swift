//
//  LogTapServer.swift
//  LogTapFramework
//
//  Created by Hussein Habibi Juybari on 06.09.25.
//

import Foundation
import Network
import NIO
import NIOHTTP1
import NIOTransportServices
import NIOWebSocket

final class WeakChannel {
    weak var value: Channel?
    init(_ value: Channel) { self.value = value }
}

typealias LogTapRouter = (HTTPRequestHead, ByteBuffer?) -> (status: HTTPResponseStatus, headers: HTTPHeaders, body: ByteBuffer?, upgradeToWebSocket: Bool)

final class LogTapServer {
    private var group: NIOTSEventLoopGroup?
    private var bootstrap: NIOTSListenerBootstrap?
    private var channel: Channel?
    /// Guards `wsClients`: it is touched from event-loop threads (upgrade / close
    /// callbacks) and from whichever thread emits a log event (`broadcast`).
    private let clientsLock = NSLock()
    private var wsClients: [WeakChannel] = []
    private let jsonEncoder = JSONEncoder()

    // MARK: Bind resiliency (overridable in tests)
    /// How many ports to try before giving up. The requested port can be taken by
    /// another instance (e.g. a second simulator sharing the host network) or by a
    /// previous launch still releasing the socket; rather than staying silently
    /// down, the server scans forward `port, port + 1, … port + maxPortAttempts - 1`
    /// and binds the first one that's free.
    var maxPortAttempts = 10

    // MARK: Self-healing (overridable in tests)
    /// iOS reclaims ("defuncts") the listening socket of a suspended app: after a
    /// long stretch in the background the `NWListener` fails and the listener
    /// channel closes, leaving the server down until the next cold launch. The
    /// server watches its listener and re-binds whenever it closes without
    /// `stop()` being called, backing off between failed attempts.
    var rebindBaseDelay: TimeInterval = 1
    var rebindMaxDelay: TimeInterval = 30
    /// Failed back-off attempts before giving up. Recovery is re-armed by the next
    /// `ensureListening()` (i.e. when the app returns to the foreground), so a
    /// permanently blocked port range doesn't retry and log forever.
    var maxRebindAttempts = 10
    /// A just-closed `NWListener` can hold its port for a moment, so a re-bind
    /// retries the same port this often (`samePortRetryInterval` apart) before
    /// scanning the range — the viewer's open tab keeps working. Retries are
    /// scheduled, not slept, so `start()` / `stop()` are never stuck behind them.
    var samePortRetries = 5
    var samePortRetryInterval: TimeInterval = 0.2
    /// `ensureListening()` probes the port over loopback. A device that just
    /// resumed can be slow to accept, so a listener is only declared dead after
    /// `probeAttempts` consecutive failures (`probeRetryDelay` apart).
    var probeTimeout: TimeInterval = 2
    var probeAttempts = 2
    var probeRetryDelay: TimeInterval = 0.5
    /// Test seam replacing the loopback probe: `(port, completion(reachable))`.
    var probeOverride: ((Int, @escaping (Bool) -> Void) -> Void)?

    /// Serializes start/stop/re-bind. Never an event-loop thread, so blocking
    /// `wait()`s and `syncShutdownGracefully()` are safe here. Only short binds and
    /// closes run on it; every wait (back-off, same-port retry, probe) is scheduled.
    private let lifecycleQueue = DispatchQueue(label: "logtap.server.lifecycle")
    private let probeQueue = DispatchQueue(label: "logtap.server.probe")
    private var router: LogTapRouter?
    private var requestedPort: Int?
    /// Guards `_boundPort`. A plain lock rather than `lifecycleQueue`, so
    /// `currentPort` can be read from any thread, including while the lifecycle
    /// queue is busy with a bind, without blocking or deadlocking.
    private let boundPortLock = NSLock()
    private var _boundPort: Int?
    /// Written only on `lifecycleQueue`. It keeps the last bound port while a
    /// recovery is in progress, since that is the port the re-bind tries first.
    private var boundPort: Int? {
        get { boundPortLock.lock(); defer { boundPortLock.unlock() }; return _boundPort }
        set { boundPortLock.lock(); _boundPort = newValue; boundPortLock.unlock() }
    }

    /// The port the server is bound to, or nil when stopped or after a failed
    /// start. While a re-bind is pending it is the previous port, which the re-bind
    /// tries first. Follows a re-bind that had to move. Safe from any thread.
    var currentPort: Int? { boundPort }
    /// Bumped by start/stop and whenever a fresh recovery begins. Every scheduled
    /// step captures it and bails if it changed, so at most one recovery is live.
    private var epoch = 0
    private var rebindAttempt = 0

    /// Binds the listener, scanning forward from `port` until one is free.
    /// - Returns: the port that was actually bound (may be greater than `port`).
    @discardableResult
    func start(port: Int, router: @escaping LogTapRouter) throws -> Int {
        try lifecycleQueue.sync {
            epoch += 1
            rebindAttempt = 0
            teardownLocked()
            requestedPort = port
            boundPort = nil
            self.router = router
            prepareBootstrapLocked(router: router)
            do {
                return try bindLocked(ports: portRange(from: port))
            } catch {
                // Don't leave a half-started server (live event-loop group, a router
                // that would arm recovery) behind a failed start.
                teardownLocked()
                self.router = nil
                requestedPort = nil
                throw error
            }
        }
    }

    func stop() {
        lifecycleQueue.sync {
            epoch += 1
            router = nil
            requestedPort = nil
            boundPort = nil
            teardownLocked()
        }
    }

    /// Verifies the listener still accepts connections and re-binds if it doesn't.
    /// Call when the app returns to the foreground: a reclaimed socket isn't always
    /// reported as a listener failure, so this also probes the port over loopback.
    /// Returns immediately; the probe and any re-bind run asynchronously.
    func ensureListening() {
        lifecycleQueue.async { [self] in
            guard router != nil else { return }
            guard let listener = channel, listener.isActive, let port = boundPort else {
                LogTapLogger.shared.d("LogTap listener is down; re-binding")
                recoverNowLocked()
                return
            }
            probeLocked(listener: listener, port: port, attemptsLeft: max(1, probeAttempts))
        }
    }

    /// Test seam: the current listener channel, to simulate the OS closing it.
    var listenerChannelForTesting: Channel? {
        lifecycleQueue.sync { channel }
    }

    // MARK: Private (call on `lifecycleQueue`)

    private func portRange(from port: Int) -> Range<Int> {
        port..<(port + max(1, maxPortAttempts))
    }

    /// Creates the event-loop group and bootstrap. They outlive individual
    /// listeners, so a re-bind reuses them (and keeps connected viewers alive).
    private func prepareBootstrapLocked(router: @escaping LogTapRouter) {
        jsonEncoder.outputFormatting = []

        let group = NIOTSEventLoopGroup()
        self.group = group

        // WebSocket upgrader configured once at bootstrap
        let upgrader = NIOWebSocketServerUpgrader(
            shouldUpgrade: { channel, _ in channel.eventLoop.makeSucceededFuture([:]) },
            upgradePipelineHandler: { [weak self] channel, _ in
                guard let self else { return channel.eventLoop.makeSucceededFuture(()) }
                self.addClient(channel)
                // Send backlog from same store the live stream feeds from
                let backlog = LogTap.shared.store.snapshot(sinceId: nil, limit: 200)
                let enc = JSONEncoder()
                for ev in backlog {
                    if let data = try? enc.encode(ev) {
                        var buf = channel.allocator.buffer(capacity: data.count)
                        buf.writeBytes(data)
                        let frame = WebSocketFrame(fin: true, opcode: .text, data: buf)
                        channel.writeAndFlush(NIOAny(frame), promise: nil)
                    }
                }
                channel.closeFuture.whenComplete { [weak self, weak channel] _ in
                    self?.removeClient(channel)
                }
                return channel.pipeline.addHandler(WebSocketIgnoreHandler())
            }
        )

        bootstrap = NIOTSListenerBootstrap(group: group)
            .childChannelInitializer { channel in
                let upgradeConfig: NIOHTTPServerUpgradeConfiguration = (
                    upgraders: [upgrader],
                    completionHandler: { _ in }
                )
                return channel.pipeline.configureHTTPServerPipeline(
                    withPipeliningAssistance: true,
                    withServerUpgrade: upgradeConfig, withErrorHandling: true
                ).flatMap {
                    channel.pipeline.addHandler(HTTPHandler(router: router))
                }
            }
    }

    /// Binds the first free port in `ports`. The requested port may be held by
    /// another instance (a second simulator) or a not-yet-released previous
    /// listener, which throws `EADDRINUSE`. Surfaces the last error if every
    /// candidate is taken.
    private func bindLocked(ports: Range<Int>) throws -> Int {
        guard let bootstrap else { throw ChannelError.ioOnClosedChannel }
        var lastError: Error?
        for candidate in ports {
            do {
                let listener = try bootstrap.bind(host: "0.0.0.0", port: candidate).wait()
                channel = listener
                boundPort = candidate
                watch(listener)
                return candidate
            } catch {
                lastError = error
            }
        }
        throw lastError ?? ChannelError.unknownLocalAddress
    }

    private func closeListenerLocked() {
        // Clear `channel` first so its close callback sees an intentional close.
        let closing = channel
        channel = nil
        try? closing?.close().wait()
    }

    private func teardownLocked() {
        closeListenerLocked()
        bootstrap = nil
        try? group?.syncShutdownGracefully()
        group = nil
    }

    private func watch(_ listener: Channel) {
        listener.closeFuture.whenComplete { [weak self] _ in
            guard let self else { return }
            self.lifecycleQueue.async {
                // Ignore closes caused by stop() / a re-bind replacing this listener.
                guard self.router != nil, self.channel === listener else { return }
                self.channel = nil
                LogTapLogger.shared.d("LogTap listener on port \(self.boundPort ?? -1) closed unexpectedly; re-binding")
                self.epoch += 1
                self.rebindAttempt = 0
                self.scheduleRebindLocked()
            }
        }
    }

    /// Probes `listener`; re-binds only after `attemptsLeft` consecutive failures.
    private func probeLocked(listener: Channel, port: Int, attemptsLeft: Int) {
        let epoch = self.epoch
        // Still the same live listener we set out to check?
        let isCurrent = { [unowned self] in self.epoch == epoch && self.channel === listener }
        probe(port: port) { [weak self] reachable in
            guard let self else { return }
            self.lifecycleQueue.async {
                guard isCurrent(), !reachable else { return }
                guard attemptsLeft <= 1 else {
                    self.lifecycleQueue.asyncAfter(deadline: .now() + self.probeRetryDelay) {
                        guard isCurrent() else { return }
                        self.probeLocked(listener: listener, port: port, attemptsLeft: attemptsLeft - 1)
                    }
                    return
                }
                LogTapLogger.shared.d("LogTap listener on port \(port) is not reachable; re-binding")
                self.recoverNowLocked()
            }
        }
    }

    /// Starts a fresh recovery right away, cancelling any pending back-off.
    private func recoverNowLocked() {
        epoch += 1
        rebindAttempt = 0
        attemptRebindLocked(samePortRetriesLeft: samePortRetries)
    }

    private func scheduleRebindLocked() {
        guard rebindAttempt < maxRebindAttempts else {
            LogTapLogger.shared.d("LogTap gave up re-binding after \(rebindAttempt) attempts; will retry when the app returns to the foreground")
            teardownLocked()
            return
        }
        let delay = min(rebindBaseDelay * pow(2, Double(rebindAttempt)), rebindMaxDelay)
        rebindAttempt += 1
        let epoch = self.epoch
        lifecycleQueue.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self, self.epoch == epoch else { return }
            self.attemptRebindLocked(samePortRetriesLeft: self.samePortRetries)
        }
    }

    /// One recovery step: retry the previous port while it is still being
    /// released, then scan the configured range, then back off.
    private func attemptRebindLocked(samePortRetriesLeft: Int) {
        guard let router, let requestedPort else { return }
        let previousPort = boundPort
        let epoch = self.epoch
        // Only missing after recovery gave up and tore the group down.
        if bootstrap == nil { prepareBootstrapLocked(router: router) }
        // A listener can still be "active" here when the probe found it unreachable.
        closeListenerLocked()

        func succeeded(_ port: Int) {
            rebindAttempt = 0
            // `bindLocked` set `boundPort`, so `currentPort` already reflects a move.
            LogTapLogger.shared.d("LogTap server re-bound on port \(port)")
        }

        if samePortRetriesLeft > 0, let previousPort {
            do {
                succeeded(try bindLocked(ports: previousPort..<(previousPort + 1)))
                return
            } catch where Self.isAddressInUse(error) {
                lifecycleQueue.asyncAfter(deadline: .now() + samePortRetryInterval) { [weak self] in
                    guard let self, self.epoch == epoch else { return }
                    self.attemptRebindLocked(samePortRetriesLeft: samePortRetriesLeft - 1)
                }
                return
            } catch {
                // Not "port still held" — waiting won't help; go straight to the scan.
            }
        }

        do {
            succeeded(try bindLocked(ports: portRange(from: requestedPort)))
        } catch {
            LogTapLogger.shared.d("LogTap re-bind failed: \(error)")
            // Keep the event-loop group while backing off: connected viewers' channels
            // live on it. It is only shut down when recovery gives up, or on stop().
            scheduleRebindLocked()
        }
    }

    private static func isAddressInUse(_ error: Error) -> Bool {
        if case .posix(.EADDRINUSE)? = error as? NWError { return true }
        if let io = error as? IOError { return io.errnoCode == EADDRINUSE }
        return false
    }

    /// Opens a loopback TCP connection to `port` and reports whether it became
    /// ready within `probeTimeout`. Never blocks the calling queue.
    private func probe(port: Int, completion: @escaping (Bool) -> Void) {
        if let probeOverride { probeOverride(port, completion); return }
        guard let raw = UInt16(exactly: port), let nwPort = NWEndpoint.Port(rawValue: raw) else {
            completion(false)
            return
        }
        let connection = NWConnection(host: "127.0.0.1", port: nwPort, using: .tcp)
        var finished = false  // only touched on `probeQueue`
        let finish: (Bool) -> Void = { reachable in
            guard !finished else { return }
            finished = true
            connection.stateUpdateHandler = nil
            connection.cancel()
            completion(reachable)
        }
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready: finish(true)
            case .failed, .waiting, .cancelled: finish(false)
            default: break
            }
        }
        connection.start(queue: probeQueue)
        probeQueue.asyncAfter(deadline: .now() + probeTimeout) { finish(false) }
    }

    // MARK: WebSocket clients

    private func addClient(_ channel: Channel) {
        clientsLock.lock()
        defer { clientsLock.unlock() }
        wsClients.append(WeakChannel(channel))
    }

    private func removeClient(_ channel: Channel?) {
        clientsLock.lock()
        defer { clientsLock.unlock() }
        wsClients.removeAll { $0.value == nil || $0.value === channel }
    }

    func broadcast(event: LogEvent) {
        guard let data = try? JSONEncoder().encode(event) else { return }
        // Prune dead channels and snapshot the live ones under the lock; write outside it.
        clientsLock.lock()
        wsClients.removeAll { $0.value == nil }
        let live = wsClients.compactMap(\.value)
        clientsLock.unlock()
        for ch in live {
            var buffer = ch.allocator.buffer(capacity: data.count)
            buffer.writeBytes(data)
            let frame = WebSocketFrame(fin: true, opcode: .text, data: buffer)
            ch.writeAndFlush(NIOAny(frame), promise: nil)
        }
    }
    
    // MARK: - HTTP Handler
    
    private final class HTTPHandler: ChannelInboundHandler {
        typealias InboundIn = HTTPServerRequestPart
        typealias OutboundOut = HTTPServerResponsePart

        private var bodyBuffer: ByteBuffer?
        private var head: HTTPRequestHead?
        private let router: LogTapRouter

        init(router: @escaping LogTapRouter) {
            self.router = router
        }

        func channelRead(context: ChannelHandlerContext, data: NIOAny) {
            if (data is ByteBuffer) {
                return
            }
            
            if (data.description.starts(with: "ByteBuffer:")) {
                // Temporary fix: when the server is already running, reloading the webpage raises an exception
                return
            }
            
            switch self.unwrapInboundIn(data) {
            case .head(let reqHead):
                head = reqHead
                bodyBuffer = context.channel.allocator.buffer(capacity: 0)
            case .body(var buf):
                bodyBuffer?.writeBuffer(&buf)
            case .end:
                guard let reqHead = head else { return }
                let result = router(reqHead, bodyBuffer)
                // If not upgrading to WS, write normal HTTP response now
                if !result.upgradeToWebSocket {
                    var headers = result.headers
                    if let body = result.body, headers.first(name: "Content-Length") == nil {
                        headers.add(name: "Content-Length", value: String(body.readableBytes))
                    }
                    let resHead = HTTPResponseHead(version: reqHead.version, status: result.status, headers: headers)
                    context.write(wrapOutboundOut(.head(resHead)), promise: nil)
                    if let body = result.body {
                        context.write(wrapOutboundOut(.body(.byteBuffer(body))), promise: nil)
                    }
                    context.writeAndFlush(wrapOutboundOut(.end(nil)), promise: nil)
                }
                head = nil
                bodyBuffer = nil
            }
        }
    }
}

private final class WebSocketIgnoreHandler: ChannelInboundHandler {
    typealias InboundIn = WebSocketFrame
    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        // Optionally handle pings/pongs/text from clients; we ignore for now
    }
}
