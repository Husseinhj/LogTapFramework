//
//  LogTapServerTests.swift
//  LogTapFrameworkTests
//
//  Regression coverage for "this site can't be reached" — the embedded server
//  silently failing to open when its port is already taken (e.g. a second
//  simulator, or a previous launch still releasing the socket). The server now
//  scans forward from the requested port and binds the first free one.
//

import XCTest
import NIO
import NIOHTTP1
@testable import LogTapFramework

final class LogTapServerTests: XCTestCase {

    /// Router that answers every request with `status` + a tiny body, so we can
    /// assert the socket is actually listening (and *who* is listening on it)
    /// without depending on the full UI router.
    private func okRouter(status: HTTPResponseStatus = .ok) -> LogTapRouter {
        return { _, _ in
            var bb = ByteBufferAllocator().buffer(capacity: 2)
            bb.writeString("ok")
            return (status, HTTPHeaders(), bb, false)
        }
    }

    /// Performs a GET against `127.0.0.1:port/` and returns the HTTP status code,
    /// or nil if the connection could not be made. Uses a throwaway session so a
    /// kept-alive connection to an old listener's child can't answer for a dead
    /// (or not-yet-rebound) listener.
    private func getStatus(port: Int) -> Int? {
        let session = URLSession(configuration: .ephemeral)
        defer { session.invalidateAndCancel() }
        let exp = expectation(description: "GET / on \(port)")
        var status: Int?
        session.dataTask(with: URL(string: "http://127.0.0.1:\(port)/")!) { _, resp, _ in
            status = (resp as? HTTPURLResponse)?.statusCode
            exp.fulfill()
        }.resume()
        wait(for: [exp], timeout: 5)
        return status
    }

    func testServerOpensOnRequestedPortAndServes() throws {
        let port = 8810
        let server = LogTapServer()
        let bound = try server.start(port: port, router: okRouter())
        defer { server.stop() }

        XCTAssertEqual(bound, port, "with the port free, it binds exactly what was asked")
        XCTAssertEqual(getStatus(port: port), 200, "the embedded server must actually be listening")
    }

    func testFallsBackToNextPortWhenRequestedIsInUse() throws {
        let port = 8820

        // Something already holds the requested port (e.g. another simulator).
        let holder = LogTapServer()
        _ = try holder.start(port: port, router: okRouter())
        defer { holder.stop() }

        let server = LogTapServer()
        let bound = try server.start(port: port, router: okRouter())
        defer { server.stop() }

        XCTAssertEqual(bound, port + 1, "should advance to the next port instead of failing")
        XCTAssertEqual(getStatus(port: port + 1), 200, "and actually listen on the fallback port")
    }

    func testScansForwardAcrossMultipleOccupiedPorts() throws {
        let port = 8830

        let holder0 = LogTapServer()
        _ = try holder0.start(port: port, router: okRouter())
        defer { holder0.stop() }
        let holder1 = LogTapServer()
        _ = try holder1.start(port: port + 1, router: okRouter())
        defer { holder1.stop() }

        let server = LogTapServer()
        let bound = try server.start(port: port, router: okRouter())
        defer { server.stop() }

        XCTAssertEqual(bound, port + 2, "skips both occupied ports and binds the first free one")
    }

    func testThrowsAfterExhaustingThePortRange() throws {
        let port = 8840

        let holder0 = LogTapServer()
        _ = try holder0.start(port: port, router: okRouter())
        defer { holder0.stop() }
        let holder1 = LogTapServer()
        _ = try holder1.start(port: port + 1, router: okRouter())
        defer { holder1.stop() }

        let server = LogTapServer()
        server.maxPortAttempts = 2  // only try `port` and `port + 1`, both taken

        XCTAssertThrowsError(
            try server.start(port: port, router: okRouter()),
            "when every candidate port is taken, the failure is surfaced, not swallowed"
        )
    }

    // MARK: Self-healing after the OS reclaims the listener

    /// Polls `GET /` until it answers `status` or `timeout` elapses.
    private func waitUntilServing(port: Int, status: Int = 200, timeout: TimeInterval) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if getStatus(port: port) == status { return true }
            Thread.sleep(forTimeInterval: 0.05)
        }
        return false
    }

    /// Polls `condition` until true or `timeout` elapses.
    private func eventually(timeout: TimeInterval = 5, _ condition: () -> Bool) -> Bool {
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            if condition() { return true }
            Thread.sleep(forTimeInterval: 0.02)
        }
        return condition()
    }

    /// Starts a server that holds exactly `port` (no scanning), retrying while a
    /// just-closed listener may still be releasing it.
    private func holdPort(_ port: Int, status: HTTPResponseStatus = .imATeapot) throws -> LogTapServer {
        let holder = LogTapServer()
        holder.maxPortAttempts = 1
        let deadline = Date().addingTimeInterval(3)
        while true {
            do {
                try holder.start(port: port, router: okRouter(status: status))
                return holder
            } catch where Date() < deadline {
                Thread.sleep(forTimeInterval: 0.01)
            }
        }
    }

    /// Simulates iOS defuncting the listening socket of a suspended app.
    private func killListener(of server: LogTapServer) throws {
        try XCTUnwrap(server.listenerChannelForTesting).close().wait()
    }

    func testRebindsOnSamePortWhenListenerClosesUnexpectedly() throws {
        let server = LogTapServer()
        server.rebindBaseDelay = 0.1
        let port = try server.start(port: 8850, router: okRouter())
        defer { server.stop() }

        try killListener(of: server)
        XCTAssertNil(getStatus(port: port), "precondition: the listener is really gone")

        XCTAssertTrue(waitUntilServing(port: port, timeout: 5),
                      "the listener must come back on its own after the OS closes it")
    }

    func testEnsureListeningRebindsImmediately() throws {
        let server = LogTapServer()
        server.rebindBaseDelay = 60  // the automatic re-bind won't fire within the test
        let port = try server.start(port: 8860, router: okRouter())
        defer { server.stop() }

        try killListener(of: server)
        server.ensureListening()  // what the foreground notification triggers

        XCTAssertTrue(waitUntilServing(port: port, timeout: 5),
                      "returning to the foreground restores a dead listener without waiting for back-off")
    }

    func testEnsureListeningKeepsHealthyListener() throws {
        let server = LogTapServer()
        let port = try server.start(port: 8870, router: okRouter())
        defer { server.stop() }
        let before = try XCTUnwrap(server.listenerChannelForTesting)

        server.ensureListening()
        XCTAssertTrue(waitUntilServing(port: port, timeout: 5))

        XCTAssertTrue(server.listenerChannelForTesting === before,
                      "a reachable listener is left alone")
    }

    func testEnsureListeningToleratesASingleFailedProbe() throws {
        let server = LogTapServer()
        server.probeRetryDelay = 0.05
        let probed = expectation(description: "probed twice")
        probed.expectedFulfillmentCount = 2
        var results = [false, true]  // a slow accept right after resume, then fine
        server.probeOverride = { _, completion in
            completion(results.removeFirst())
            probed.fulfill()
        }
        let port = try server.start(port: 8890, router: okRouter())
        defer { server.stop() }
        let before = try XCTUnwrap(server.listenerChannelForTesting)

        server.ensureListening()
        wait(for: [probed], timeout: 5)
        Thread.sleep(forTimeInterval: 0.1)

        XCTAssertTrue(server.listenerChannelForTesting === before,
                      "one failed probe must not tear down a live listener (and its viewers)")
        XCTAssertEqual(getStatus(port: port), 200)
    }

    func testEnsureListeningRebindsAfterConsecutiveFailedProbes() throws {
        let server = LogTapServer()
        server.probeRetryDelay = 0.05
        server.probeOverride = { _, completion in completion(false) }  // accepts are wedged
        let port = try server.start(port: 8900, router: okRouter())
        defer { server.stop() }
        let before = try XCTUnwrap(server.listenerChannelForTesting)

        server.ensureListening()

        XCTAssertTrue(eventually { server.listenerChannelForTesting.map { $0 !== before } ?? false },
                      "a listener that keeps failing the probe is replaced")
        XCTAssertTrue(waitUntilServing(port: port, timeout: 5), "on the same port")
    }

    func testCurrentPortTracksTheBoundPortAndClearsOnStop() throws {
        let holder = try holdPort(8990)
        defer { holder.stop() }
        let server = LogTapServer()
        XCTAssertNil(server.currentPort, "not started")

        let port = try server.start(port: 8990, router: okRouter())
        XCTAssertEqual(port, 8991)
        XCTAssertEqual(server.currentPort, 8991, "reports the scanned port, not the requested one")

        server.stop()
        XCTAssertNil(server.currentPort, "a stopped server reports no port")
    }

    func testRebindMovesToNextPortWhenPreviousIsTakenAndReportsIt() throws {
        let server = LogTapServer()
        server.rebindBaseDelay = 0.3  // leave time for the holder to grab the port
        server.samePortRetries = 1
        server.samePortRetryInterval = 0.05
        let port = try server.start(port: 8910, router: okRouter())
        defer { server.stop() }
        XCTAssertEqual(server.currentPort, port)

        try killListener(of: server)
        let holder = try holdPort(port)
        defer { holder.stop() }

        XCTAssertTrue(eventually { server.currentPort == port + 1 },
                      "falls through the same-port retries to the range scan, and currentPort follows")
        XCTAssertTrue(waitUntilServing(port: port + 1, timeout: 5))
        XCTAssertEqual(getStatus(port: port), 418, "the holder still owns the original port")
    }

    func testBacksOffAndRecoversOnceThePortFrees() throws {
        let server = LogTapServer()
        server.maxPortAttempts = 1  // nowhere to move: must wait for the port
        server.samePortRetries = 0
        server.rebindBaseDelay = 0.05
        server.rebindMaxDelay = 0.1
        server.maxRebindAttempts = 100
        let port = try server.start(port: 8920, router: okRouter())
        defer { server.stop() }

        try killListener(of: server)
        let holder = try holdPort(port)
        Thread.sleep(forTimeInterval: 0.4)  // several failed attempts
        XCTAssertEqual(getStatus(port: port), 418, "the server can't take the port while it's held")

        holder.stop()
        XCTAssertTrue(waitUntilServing(port: port, timeout: 5),
                      "a later back-off attempt binds once the port is released")
    }

    func testGivesUpAfterMaxAttemptsUntilEnsureListening() throws {
        let server = LogTapServer()
        server.maxPortAttempts = 1
        server.samePortRetries = 0
        server.rebindBaseDelay = 0.02
        server.rebindMaxDelay = 0.02
        server.maxRebindAttempts = 2
        let port = try server.start(port: 8930, router: okRouter())
        defer { server.stop() }

        try killListener(of: server)
        let holder = try holdPort(port)
        Thread.sleep(forTimeInterval: 0.3)  // exhaust the attempts
        holder.stop()
        Thread.sleep(forTimeInterval: 0.3)
        XCTAssertNil(getStatus(port: port), "after giving up the server stops retrying on its own")

        server.ensureListening()
        XCTAssertTrue(waitUntilServing(port: port, timeout: 5),
                      "returning to the foreground re-arms recovery")
    }

    func testStopDoesNotRebind() throws {
        let server = LogTapServer()
        server.rebindBaseDelay = 0.1
        let port = try server.start(port: 8880, router: okRouter())

        server.stop()
        Thread.sleep(forTimeInterval: 0.5)

        XCTAssertNil(server.listenerChannelForTesting, "an intentional stop must stay stopped")
        XCTAssertNil(getStatus(port: port))
    }

    func testStopCancelsAPendingRebind() throws {
        let server = LogTapServer()
        server.rebindBaseDelay = 0.2
        let port = try server.start(port: 8940, router: okRouter())

        try killListener(of: server)
        server.stop()  // while the back-off timer is pending
        Thread.sleep(forTimeInterval: 0.5)

        XCTAssertNil(server.listenerChannelForTesting)
        XCTAssertNil(getStatus(port: port), "a re-bind scheduled before stop() must not resurrect the server")
    }

    func testRestartDuringPendingRebindWins() throws {
        let server = LogTapServer()
        server.rebindBaseDelay = 0.2
        let oldPort = try server.start(port: 8950, router: okRouter())
        defer { server.stop() }

        try killListener(of: server)
        let newPort = try server.start(port: 8960, router: okRouter())
        Thread.sleep(forTimeInterval: 0.5)

        XCTAssertEqual(getStatus(port: newPort), 200)
        XCTAssertNil(getStatus(port: oldPort), "the stale re-bind for the old start must not fire")
    }

    func testConnectedViewerSurvivesARebindWhileEventsStream() throws {
        let server = LogTapServer()
        server.probeRetryDelay = 0.01
        server.probeOverride = { _, completion in completion(false) }
        let port = try server.start(port: 8970, router: okRouter())
        defer { server.stop() }
        let before = try XCTUnwrap(server.listenerChannelForTesting)

        let session = URLSession(configuration: .ephemeral)
        defer { session.invalidateAndCancel() }
        let ws = session.webSocketTask(with: URL(string: "ws://127.0.0.1:\(port)/ws")!)
        ws.resume()

        /// Waits for a frame whose text contains `marker`, re-broadcasting it until
        /// it shows up (the upgrade completes asynchronously).
        func expectFrame(_ marker: String) {
            let got = expectation(description: "frame \(marker)")
            let lock = NSLock()
            var done = false
            func isDone() -> Bool { lock.lock(); defer { lock.unlock() }; return done }
            func receive() {
                ws.receive { result in
                    if case .success(.string(let text)) = result, text.contains(marker) {
                        lock.lock(); done = true; lock.unlock()
                        got.fulfill()
                    } else if case .failure = result {
                        return
                    } else {
                        receive()
                    }
                }
            }
            receive()
            let deadline = Date().addingTimeInterval(5)
            while !isDone() && Date() < deadline {
                server.broadcast(event: LogEvent(kind: .log, direction: .state, summary: marker))
                Thread.sleep(forTimeInterval: 0.05)
            }
            wait(for: [got], timeout: 1)
        }

        expectFrame("hello")  // the viewer is connected

        // Stream events from several threads while the listener is replaced, so
        // `broadcast` races the upgrade/close callbacks on the event loop.
        let streaming = DispatchGroup()
        for _ in 0..<4 {
            DispatchQueue.global().async(group: streaming) {
                for n in 0..<200 {
                    server.broadcast(event: LogEvent(kind: .log, direction: .state, summary: "e\(n)"))
                }
            }
        }
        server.ensureListening()
        streaming.wait()

        XCTAssertTrue(eventually { server.listenerChannelForTesting.map { $0 !== before } ?? false },
                      "the wedged listener is replaced")
        XCTAssertTrue(waitUntilServing(port: port, timeout: 5))
        expectFrame("after")  // replacing the listener keeps existing viewers connected
    }

    /// Connected viewers must survive a re-bind even when the first attempt fails
    /// and the server backs off: their channels live on the event-loop group.
    func testConnectedViewerSurvivesAFailedRebindAttempt() throws {
        let server = LogTapServer()
        server.maxPortAttempts = 1      // the scan can only try the original port
        server.samePortRetries = 0      // go straight to the scan, which will fail
        server.rebindBaseDelay = 0.3    // leave time for the holder to grab the port
        server.rebindMaxDelay = 0.3
        server.maxRebindAttempts = 100
        let port = try server.start(port: 8980, router: okRouter())
        defer { server.stop() }

        let session = URLSession(configuration: .ephemeral)
        defer { session.invalidateAndCancel() }
        let ws = session.webSocketTask(with: URL(string: "ws://127.0.0.1:\(port)/ws")!)
        ws.resume()

        /// Re-broadcasts `marker` until a frame containing it arrives. Returns
        /// false if the socket fails (viewer dropped) or nothing arrives in time.
        func receivesFrame(_ marker: String) -> Bool {
            let lock = NSLock()
            var outcome: Bool?
            func finish(_ value: Bool) { lock.lock(); if outcome == nil { outcome = value }; lock.unlock() }
            func current() -> Bool? { lock.lock(); defer { lock.unlock() }; return outcome }
            func receive() {
                ws.receive { result in
                    switch result {
                    case .success(.string(let text)) where text.contains(marker): finish(true)
                    case .failure: finish(false)
                    default: receive()
                    }
                }
            }
            receive()
            let deadline = Date().addingTimeInterval(5)
            while current() == nil && Date() < deadline {
                server.broadcast(event: LogEvent(kind: .log, direction: .state, summary: marker))
                Thread.sleep(forTimeInterval: 0.05)
            }
            return current() ?? false
        }

        XCTAssertTrue(receivesFrame("hello"), "precondition: the viewer is connected")

        try killListener(of: server)
        let holder = try holdPort(port)
        Thread.sleep(forTimeInterval: 0.5)  // long enough for the first attempt to fail
        XCTAssertEqual(getStatus(port: port), 418, "precondition: the re-bind scan failed")
        holder.stop()

        XCTAssertTrue(waitUntilServing(port: port, timeout: 5), "the server recovers on back-off")
        XCTAssertTrue(receivesFrame("after"),
                      "a viewer connected before the failure must still receive events after recovery")
    }
}
