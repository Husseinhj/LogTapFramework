# LogTapIOS — Known Issues & Improvements

Severity tags: **[BUG]** correctness defect, **[SEC]** security/privacy, **[PERF]** efficiency, **[QA]** test/quality, **[DOC]** documentation, **[NIT]** style. Each item cites exact file:line.

## Status (2026-05-13)

Ported the Android v0.14.0 correctness pass to LogTapFramework. **Fixed in working tree**:
- `LogEvent` gained `pid` / `tid` fields (parity with Android).
- `LogTapStore.add` now auto-assigns own PID when event has none.
- `LogTapURLProtocol` now redacts request + response headers using `LogTap.shared.config.redactHeaders` (previously NOT redacted — bug parity with Android #1).
- `LogTap.makeBodyPreview` honors `LogTap.shared.config.maxBodyBytes` instead of hard-coded 64 KB.
- `LogTapURLProtocol` response now reports `bodyIsTruncated` accurately.
- `LogTapServer` sends 200-event backlog from `LogTapStore` to each new WS client (previously: clients got no backlog).
- `POST /api/clear` actually clears the store (previously: just returned "ok").
- `GET /about` route added, serving `Resources.aboutHtml`.
- Web UI rewritten to the v0.14.0 modern viewer: command-search syntax, autocomplete, saved filters, 4 themes × dark/light, Logcat + Table views, JSON export, PID/TID column. Source: three split files in `Sources/LogTapFramework/Utils/Resources+{HTML,CSS,JS}.swift`.
- `LogTapFrameworkNoop` standalone SPM package added at `LogTapFramework-Noop/`; surfaces as a workspace scheme.

Items below are still open.

---

## Critical bugs (correctness)

### 1. [BUG] `LogTap.start` does not gate on debug build
**File**: `Sources/LogTapFramework/LogTap.swift:31`

`Config.enableOnRelease` exists but `start(_:)` doesn't check it against the build configuration. The Android counterpart short-circuits unless `isDebuggable(context) || enableOnRelease`. iOS will happily bind the server in a release archive submitted to TestFlight.

**Fix**: wrap the body of `start()` in `#if DEBUG` or check `_isDebugAssertConfiguration()`; allow override via `cfg.enableOnRelease`.

---

### 2. [BUG] No port-collision fallback
**File**: `Sources/LogTapFramework/Server/LogTapServer.swift:60`

`bootstrap.bind(host: "0.0.0.0", port: port).wait()` throws if the port is taken. Two iOS apps on the same simulator/host using LogTapFramework at default port 8790 will collide; only the first starts. Android version walks 8790 → 8810 → OS-assigned.

**Fix**: catch bind failure and retry on `port+1` up to a small range, fall back to `port: 0` (OS-assigned) so `urls()` advertises the actual bound port.

---

### 3. [BUG] `urls()` reports `config.port` even when bind succeeded on a different port
**File**: `Sources/LogTapFramework/LogTap.swift:198, 201`

Tied to #2 — once port fallback is added, the advertised URL must use the actually-bound port (read from `channel.localAddress?.port`), not the requested `config.port`.

---

### 4. [BUG] `LogTapPrintBridge` hijacks stdout globally; re-running `start` without `stop` leaks fds
**File**: `Sources/LogTapFramework/Logger/LogTapPrintBridge.swift`

`start(sink:)` calls `dup2` to replace `STDOUT_FILENO`. If consumer calls `start` twice without `stop` in between, the second `outOrig = dup(STDOUT_FILENO)` captures the pipe fd (not the real terminal), and the original stdout is permanently lost for that process.

**Fix**: ensure `stop()` runs on `deinit` of an owner object, or add an `assertionFailure` if `start` is called while `isRunning`.

---

### 5. [BUG] `LogTapServer.HTTPHandler.channelRead` has a stringly-typed early-return guard
**File**: `Sources/LogTapFramework/Server/LogTapServer.swift:102-106`

```swift
if (data.description.starts(with: "ByteBuffer:")) {
    // Temporary fix: when the server is already running, reloading the webpage raises an exception
    return
}
```

Workaround for an upstream NIO pipeline issue but the guard is brittle (depends on `NIOAny.description`) and silently drops legitimate request bodies that happen to be parsed as ByteBuffers in the wrong path. Root-cause the pipeline configuration instead.

---

### 6. [BUG] `URLSessionWebSocketInterceptor.install()` is a no-op
**File**: `Sources/LogTapFramework/Interceptor/URLSessionWebSocketInterceptor.swift:238-249`

`install()` documented as "safe to call multiple times" but the body is intentionally empty due to swizzling fragility on URLSession class clusters. Consumers reading the README may believe install enables auto-interception. Either rename to `install() // no-op` with a deprecation note, or implement attach/detach as the only path and remove `install`.

---

## Security / privacy

### 7. [SEC] Plain-text HTTP server, binds 0.0.0.0, no auth
**File**: `Sources/LogTapFramework/Server/LogTapServer.swift:60`

Same as Android #6. Any device on the same Wi-Fi can read every request body, response body, header (post-redaction), and log line. Mitigations:
1. Default-bind to `127.0.0.1` and require a port-forward (`localhost:8790` via Xcode / `iproxy` for physical devices).
2. Add a per-session token shown in the Xcode console once; clients pass it as a query param or header.
3. Extend redaction to common body keys (`password`, `token`, `secret`).

---

### 8. [SEC] No body redaction
**File**: `Sources/LogTapFramework/Interceptor/URLProtocol+Interceptor.swift:38-43`

Headers redacted post-fix, but bodies stream verbatim — JWTs in JSON, OAuth refresh tokens, PII all visible in the UI and any `/api/logs` snapshot.

**Fix**: add `Config.redactBodyKeys: Set<String>` and walk JSON bodies replacing matching keys with `"(redacted)"`.

---

### 9. [SEC] `enableOnRelease=true` ships server in App Store builds
Combined with bug #1 (no debug gate), this is currently a *silent* foot-gun — the flag isn't enforced. After fixing #1, document the risk explicitly in README.

---

## Robustness

### 10. [BUG] Subscribers run inside the store's serial queue — deadlock risk
**File**: `Sources/LogTapFramework/Log/LogTapStore.swift:26`

```swift
q.sync {
    if deque.count == capacity { deque.removeFirst() }
    deque.append(e)
    subscribers.values.forEach { $0(e) }   // <-- runs on logtap.store queue
}
```

If a subscriber synchronously calls back into the store (e.g. `LogTapServer.broadcast` → JSON encode → a log statement on the same queue), this deadlocks.

**Fix**: capture subscribers, call them *after* releasing the lock, or dispatch async to a separate queue.

---

### 11. [BUG] `LogTapServer.broadcast` allocates a `JSONEncoder` per call
**File**: `Sources/LogTapFramework/Server/LogTapServer.swift:71`

Stored `jsonEncoder` property exists but `broadcast` creates a fresh `JSONEncoder()` each invocation. Minor allocation churn under heavy traffic.

**Fix**: use `self.jsonEncoder`.

---

### 12. [BUG] `wsClients` mutated from non-event-loop threads
**File**: `Sources/LogTapFramework/Server/LogTapServer.swift:37, 40, 73`

`wsClients` is a plain `Array` mutated from the NIO event loop (upgrade) and from `broadcast()` (called from `LogTapStore` subscriber, which runs on `logtap.store` queue). Concurrent reads/writes are a data race.

**Fix**: serialize all `wsClients` access on a single queue or hop onto each channel's `eventLoop`.

---

## Performance

### 13. [PERF] Resources held in memory as Swift string literals
**Files**: `Sources/LogTapFramework/Utils/Resources+{HTML,CSS,JS}.swift`

Ported design from Android. For SPM-distributed library, consider shipping as Bundle resources so they can be memory-mapped.

---

### 14. [PERF] `LogTapURLProtocol.startLoading` builds a fresh `URLSession` per request
**File**: `Sources/LogTapFramework/Interceptor/URLProtocol+Interceptor.swift:67-72`

Each intercepted request constructs `URLSession(configuration:, delegate:, delegateQueue:)`. Sessions are expensive — keep one shared relay session per protocol instance class (or a small pool).

---

## Testing & quality

### 15. [QA] Zero tests
No `Tests/` directory. Add unit tests for at minimum:
- `LogTapStore`: capacity wrap, `sinceId > id` filter, subscriber ordering, PID auto-assign.
- `LogTapURLProtocol`: redact set application, body truncation at exact `maxBodyBytes` boundary, error path emits `Direction.error`.
- `LogTapPrintBridge`: level-token parser, stdout restoration on `stop`.

---

### 16. [DOC] Public API lacks docc comments
Most of the public surface (`LogTap.start`, `LogTapLogger.log`, `LogTapURLProtocol`, `Config` fields) lacks ///-style documentation. Add before publishing the next minor version.

---

## Suggested order of work

1. Bug **#1** (release-build gate) — security implication, tiny diff.
2. Bug **#2 + #3** (port fallback + accurate URL advertise) — affects every multi-app dev environment.
3. Address **#10, #11, #12** (server concurrency hardening) — bundle as one PR.
4. Tighten security: bind 127.0.0.1 by default + token (#7), body redaction (#8).
5. Add tests (#15) covering the fixes already landed.
6. docc comments (#16) before next tag.
