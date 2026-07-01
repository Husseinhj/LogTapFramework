//
//  LogTapServer.swift
//  LogTapFramework
//
//  Created by Hussein Habibi Juybari on 06.09.25.
//

import Foundation
import NIO
import NIOHTTP1
import NIOTransportServices
import NIOWebSocket

final class WeakChannel {
    weak var value: Channel?
    init(_ value: Channel) { self.value = value }
}

final class LogTapServer {
    private var group: NIOTSEventLoopGroup?
    private var channel: Channel?
    private var wsClients: [WeakChannel] = []
    private let jsonEncoder = JSONEncoder()

    // MARK: Bind resiliency (overridable in tests)
    /// How many ports to try before giving up. The requested port can be taken by
    /// another instance (e.g. a second simulator sharing the host network) or by a
    /// previous launch still releasing the socket; rather than staying silently
    /// down, the server scans forward `port, port + 1, … port + maxPortAttempts - 1`
    /// and binds the first one that's free.
    var maxPortAttempts = 10

    /// Binds the listener, scanning forward from `port` until one is free.
    /// - Returns: the port that was actually bound (may be greater than `port`).
    @discardableResult
    func start(port: Int, router: @escaping (HTTPRequestHead, ByteBuffer?) -> (status: HTTPResponseStatus, headers: HTTPHeaders, body: ByteBuffer?, upgradeToWebSocket: Bool)) throws -> Int {
        stop()
        jsonEncoder.outputFormatting = []

        let group = NIOTSEventLoopGroup()
        self.group = group

        // WebSocket upgrader configured once at bootstrap
        let upgrader = NIOWebSocketServerUpgrader(
            shouldUpgrade: { channel, _ in channel.eventLoop.makeSucceededFuture([:]) },
            upgradePipelineHandler: { [weak self] channel, _ in
                guard let self else { return channel.eventLoop.makeSucceededFuture(()) }
                self.wsClients.append(WeakChannel(channel))
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
                    guard let self else { return }
                    self.wsClients.removeAll { $0.value == nil || $0.value === channel }
                }
                return channel.pipeline.addHandler(WebSocketIgnoreHandler())
            }
        )

        let bootstrap = NIOTSListenerBootstrap(group: group)
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

        // Scan forward for a free port: the requested one may be held by another
        // instance (a second simulator) or a not-yet-released previous listener,
        // which throws `EADDRINUSE`. Without this the server would stay down for the
        // whole session. Surface the last error if every candidate is taken.
        var lastError: Error?
        for candidate in port..<(port + max(1, maxPortAttempts)) {
            do {
                self.channel = try bootstrap.bind(host: "0.0.0.0", port: candidate).wait()
                return candidate
            } catch {
                lastError = error
            }
        }
        throw lastError ?? ChannelError.unknownLocalAddress
    }
    
    func stop() {
        try? channel?.close().wait()
        channel = nil
        try? group?.syncShutdownGracefully()
        group = nil
    }
    
    func broadcast(event: LogEvent) {
        guard let data = try? JSONEncoder().encode(event) else { return }
        // prune dead channels and broadcast
        wsClients = wsClients.filter { $0.value != nil }
        for weakRef in wsClients {
            if let ch = weakRef.value {
                var buffer = ch.allocator.buffer(capacity: data.count)
                buffer.writeBytes(data)
                let frame = WebSocketFrame(fin: true, opcode: .text, data: buffer)
                ch.writeAndFlush(NIOAny(frame), promise: nil)
            }
        }
    }
    
    // MARK: - HTTP Handler
    
    private final class HTTPHandler: ChannelInboundHandler {
        typealias InboundIn = HTTPServerRequestPart
        typealias OutboundOut = HTTPServerResponsePart

        private var bodyBuffer: ByteBuffer?
        private var head: HTTPRequestHead?
        private let router: (HTTPRequestHead, ByteBuffer?) -> (status: HTTPResponseStatus, headers: HTTPHeaders, body: ByteBuffer?, upgradeToWebSocket: Bool)

        init(router: @escaping (HTTPRequestHead, ByteBuffer?) -> (HTTPResponseStatus, HTTPHeaders, ByteBuffer?, Bool)) {
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
