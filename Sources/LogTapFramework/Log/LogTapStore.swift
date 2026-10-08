//
//  LogTapStore.swift
//  LogTapFramework
//
//  Created by Hussein Habibi Juybari on 06.09.25.
//

import Foundation
import Darwin

final class LogTapStore {
  private let capacity: Int
  private var deque: [LogEvent] = []
  private var nextId: Int64 = 1
  private let q = DispatchQueue(label: "logtap.store", qos: .utility)
  private var subscribers: [UUID: (LogEvent) -> Void] = [:]
  private let ownPid: Int = Int(getpid())

  init(capacity: Int) { self.capacity = max(100, capacity) }

  func add(_ ev: LogEvent) {
    var e = ev
    if e.pid == nil { e.pid = ownPid }
    q.sync {
      // Assign the id under the same lock as the append: `add` runs on many
      // threads at once, and ids must be unique and increase in store order
      // for `snapshot(sinceId:)` paging to neither skip nor repeat events.
      e.id = nextId
      nextId += 1
      if deque.count == capacity { deque.removeFirst() }
      deque.append(e)
      subscribers.values.forEach { $0(e) }
    }
  }

  func clear() {
    q.sync { deque.removeAll(keepingCapacity: true) }
  }

  func snapshot(sinceId: Int64? = nil, limit: Int = 500) -> [LogEvent] {
    q.sync {
      let src = deque
      let filtered = sinceId != nil ? src.filter { $0.id > sinceId! } : src
      return Array(filtered.suffix(limit))
    }
  }

  @discardableResult
  func subscribe(_ block: @escaping (LogEvent) -> Void) -> UUID {
    let id = UUID()
    q.sync { subscribers[id] = block }
    return id
  }

  func unsubscribe(_ id: UUID) {
    q.sync { subscribers.removeValue(forKey: id) }
  }
}
