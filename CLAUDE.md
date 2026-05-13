# LogTapIOS — Project Guide for Claude

## What this is

**LogTapFramework** — Swift port of LogTap. Realtime HTTP/WebSocket/logger inspector for iOS. Embedded Swift-NIO HTTP server (default port 8790) + WebSocket upgrader serving the same Material-style web UI as the Android library. URLProtocol-based traffic intercept, stdout/stderr hijack via pipe+dup2 for logger capture.

Maintainer: Hussein Habibi Juybari (`husseinhj`). License: MIT. Sister project of [LogTap (Android)](https://github.com/Husseinhj/LogTap) — web UI is kept in lockstep.

## Repo layout

```
.
├── Sources/LogTapFramework/        # main library (full impl, debug-only intended)
├── LogTapFramework-Noop/           # standalone SPM package — API-compatible no-op variant for release builds
│   ├── Package.swift
│   └── Sources/LogTapFrameworkNoop/
├── LogTapSample/                   # sample app (own Package.swift, own .xcodeproj)
├── LogTapFramework.xcodeproj       # XcodeGen-generated (project.yml at root)
├── LogTapIOS.xcworkspace           # workspace bundling Framework + Sample + Noop
├── Package.swift                   # SPM manifest for LogTapFramework
├── project.yml                     # XcodeGen spec
├── CHANGELOG.md
└── README.md
```

Workspace contains three Xcode entries:
1. `LogTapFramework.xcodeproj` (main framework, generated via XcodeGen from `project.yml`)
2. `LogTapSample/LogTapSample.xcodeproj` (sample app)
3. `LogTapFramework-Noop` (local Swift Package, surfaces `LogTapFrameworkNoop` scheme)

## Build

- Swift 5.7+, iOS 15+, macOS 12+ (Noop also builds on macOS host for `swift build`)
- Swift-NIO ≥ 2.63, swift-nio-transport-services ≥ 1.20, vapor/websocket-kit ≥ 2.13
- XcodeGen for `LogTapFramework.xcodeproj` regeneration: `xcodegen generate`

Common commands:
```bash
swift build                                                # build framework via SPM (iOS-only code may fail on mac host)
cd LogTapFramework-Noop && swift build                     # build noop (clean on macOS)
xcodebuild -workspace LogTapIOS.xcworkspace -scheme LogTapFramework -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace LogTapIOS.xcworkspace -scheme LogTapFrameworkNoop -destination 'generic/platform=iOS Simulator' build
xcodebuild -workspace LogTapIOS.xcworkspace -scheme LogTapSample -destination 'generic/platform=iOS Simulator' build
```

No automated tests yet (parity with Android — both projects lack a test suite).

## Architecture

```
LogTapFramework (Sources/LogTapFramework)
├── LogTap.swift                  (singleton — start/stop, router closure, urls() prefers en0, config holder)
├── Dto/
│   └── DeviceAppInfo.swift       (Codable struct; bundle/version/OS/device/icon-base64)
├── Log/
│   ├── LogEvent.swift            (Codable; kind=HTTP|WEBSOCKET|LOG, direction, level, pid, tid)
│   └── LogTapStore.swift         (capacity-bounded array + DispatchQueue mutex + subscribers; assigns id+pid)
├── Server/LogTapServer.swift     (Swift-NIO HTTP server + NIOWebSocketServerUpgrader; broadcasts to wsClients; sends backlog on connect)
├── Interceptor/
│   ├── URLProtocol+Interceptor.swift          (LogTapURLProtocol; redacts headers, honors maxBodyBytes)
│   └── URLSessionWebSocketInterceptor.swift   (attach/detach helpers on URLSessionWebSocketTask; install() is intentionally no-op)
├── Logger/
│   ├── LogTapLogger.swift        (Level/tag/file gates; emits via LogTap.shared.emit)
│   ├── LogTapLogSink.swift       (sink protocol)
│   ├── LogTapPrintBridge.swift   (stdout/stderr hijack via pipe+dup2; threadtime-style level parser)
│   └── LogTapSinkAdapter.swift   (Sink → LogTapStore.add bridge)
├── Websocket/WebSocketLogger.swift            (LogTapWebSocket wrapper + makeLoggedWebSocket factory)
└── Utils/
    ├── Resources.swift           (entry surface — exposes indexHtml/appCss/appJs/aboutHtml)
    ├── Resources+HTML.swift      (indexHtml + aboutHtml raw strings — ported from Android Resources.kt)
    ├── Resources+CSS.swift       (appCss raw string)
    └── Resources+JS.swift        (appJs raw string)
```

Data flow: URLProtocol + LogTapLogger + PrintBridge → `LogTapStore.add` → subscriber callback → `LogTapServer.broadcast` → all live WS clients. Reconnecting WS clients receive last 200 events as backlog before live stream resumes.

## Public API (stable surface)

- `LogTap.shared.start(_:)` / `LogTap.shared.stop()` / `LogTap.shared.urls() -> [String]`
- `LogTap.Config(port=8790, capacity=5000, maxBodyBytes=64_000, redactHeaders={Authorization,Cookie,Set-Cookie}, enableOnRelease=false)`
- `LogTapURLProtocol` — drop-in URLProtocol subclass; register in URLSessionConfiguration.protocolClasses
- `URLSessionWebSocketInterceptor.install()` (no-op shim), `URLSessionWebSocketTask.attach(task:)` / `.detach(task:)`
- `LogTapLogger.shared.{v,d,i,w,e,a}(...)` plus top-level `logV/logD/logI/logW/logE/logA`
- `LogTapPrintBridge.shared.start(sink:)` / `.stop()` / `.emitDirect(...)`, `logtapPrint(...)`
- `LogTapLogSink` protocol, `LogTapSinkAdapter` adapter
- `LogTapWebSocket(task:)`, `makeLoggedWebSocket(session:url:)`
- `DeviceAppInfo` + `DeviceAppInfo.current()`
- `LogEvent`, `LogKind`, `Direction`, `LogLevel`, `BuildMode`

`LogTapFrameworkNoop` target mirrors all above as empty bodies / pass-throughs. Keep parity when adding/changing public symbols (run `/parity-check`).

## Conventions

- Swift only. Core library uses `UIKit.UIDevice`/`UIImage` (DeviceAppInfo) under `#if canImport(UIKit)`. PrintBridge uses Darwin C APIs.
- `internal` modifier guards everything not part of the public surface.
- Concurrency: `DispatchQueue` (`logtap.store`) for store mutex; NIO event loop for server; URLSession callbacks for interceptor.
- Web UI is HTML/CSS/JS split across three Swift files (`Resources+HTML.swift`, `Resources+CSS.swift`, `Resources+JS.swift`) as `#"""raw triple-quoted"""#` strings — auto-ported from Android `Resources.kt`. Edit Android first, regenerate with the same transformation (replace `${'$'}` → `$`).
- Body capture bounded by `Config.maxBodyBytes` (default 64 KB). Header redaction set is `Config.redactHeaders`.
- `LogTap.shared.config` is the active config — read from this, NOT `Config()` (parity with Android `LogTap.activeConfig` fix).
- Pid auto-assigned by `LogTapStore.add` if not pre-set on the event.

## Working in this repo

- `LogTapFramework` and `LogTapFrameworkNoop` MUST keep API parity. If you change signatures in one, update the other.
- Web UI changes go to Android `Resources.kt` first (richer JS dev loop), then re-port to the three iOS files. `$` is literal in Swift raw strings, so no escape conversion is needed copying snippets out of the iOS file.
- Use `LogTapStore` for new event-emitting code. There is no legacy event queue.
- When adding a public symbol: add it in both targets, update README, bump version in CHANGELOG.
- Regenerate `LogTapFramework.xcodeproj` from `project.yml` with `xcodegen generate` after sources change.

## Known issues

See `ISSUES.md` at repo root.

## References

- README.md — user-facing install/usage
- CHANGELOG.md — version history
- Android counterpart: https://github.com/Husseinhj/LogTap
