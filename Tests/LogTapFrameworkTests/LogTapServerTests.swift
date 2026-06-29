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

    /// Router that answers every request with 200 + a tiny body, so we can assert
    /// the socket is actually listening without depending on the full UI router.
    private func okRouter(
    ) -> (HTTPRequestHead, ByteBuffer?) -> (status: HTTPResponseStatus, headers: HTTPHeaders, body: ByteBuffer?, upgradeToWebSocket: Bool) {
        return { _, _ in
            var bb = ByteBufferAllocator().buffer(capacity: 2)
            bb.writeString("ok")
            return (.ok, HTTPHeaders(), bb, false)
        }
    }

    /// Performs a GET against `127.0.0.1:port/` and returns the HTTP status code,
    /// or nil if the connection could not be made.
    private func getStatus(port: Int) -> Int? {
        let exp = expectation(description: "GET / on \(port)")
        var status: Int?
        URLSession.shared.dataTask(with: URL(string: "http://127.0.0.1:\(port)/")!) { _, resp, _ in
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
}
