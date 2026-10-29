//
//  LogTapStoreTests.swift
//  LogTapFrameworkTests
//
//  `LogTapStore.add` is called from many threads at once (URLProtocol callbacks,
//  the print bridge, the server's lifecycle queue). Ids must stay unique and
//  increase in store order, or the viewer's `sinceId` paging skips or repeats
//  events.
//

import XCTest
@testable import LogTapFramework

final class LogTapStoreTests: XCTestCase {

    func testConcurrentAddsGetUniqueIdsInStoreOrder() {
        let threads = 8
        let perThread = 1_000
        let store = LogTapStore(capacity: threads * perThread)

        DispatchQueue.concurrentPerform(iterations: threads) { _ in
            for n in 0..<perThread {
                store.add(LogEvent(kind: .log, direction: .state, summary: "e\(n)"))
            }
        }

        let ids = store.snapshot(limit: .max).map(\.id)
        XCTAssertEqual(ids.count, threads * perThread, "no event is lost")
        XCTAssertEqual(ids, Array(1...Int64(threads * perThread)),
                       "ids are unique, gap-free, and increase in the order events are stored")
    }

    func testSubscribersSeeTheAssignedId() {
        let store = LogTapStore(capacity: 100)
        var seen: [Int64] = []
        store.subscribe { seen.append($0.id) }

        store.add(LogEvent(kind: .log, direction: .state, summary: "a"))
        store.add(LogEvent(kind: .log, direction: .state, summary: "b"))

        XCTAssertEqual(seen, [1, 2])
        XCTAssertEqual(store.snapshot(sinceId: 1).map(\.id), [2], "sinceId paging uses the same ids")
    }
}
