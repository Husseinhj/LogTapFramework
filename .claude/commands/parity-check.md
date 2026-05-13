---
description: Verify public API parity between LogTapFramework and LogTapFrameworkNoop targets
---

LogTapIOS ships two SPM products that MUST have identical public API surfaces: `LogTapFramework` (real implementation, root `Package.swift`) and `LogTapFrameworkNoop` (empty stubs at `LogTapFramework-Noop/Package.swift`). Any drift breaks consumer release builds.

Do these checks:

1. List all public Swift declarations (classes, structs, enums, protocols, top-level functions, public methods/properties, public static extensions) under `Sources/LogTapFramework/**`.
2. List the same under `LogTapFramework-Noop/Sources/LogTapFrameworkNoop/**`.
3. Diff the two sets:
   - Symbols present in LogTapFramework but missing in LogTapFrameworkNoop → **PARITY GAP** (release builds will fail to compile).
   - Symbols present in LogTapFrameworkNoop but missing in LogTapFramework → dead stub.
   - Same symbol, different signature → ABI mismatch.
4. Pay special attention to: `LogTap` class + `LogTap.Config` struct fields, `LogTapURLProtocol`, `URLSessionWebSocketInterceptor` + the `URLSessionWebSocketTask.attach/detach` extension methods, `LogTapLogger` (all public methods + `LogLevel` enum + `BuildMode` enum), `LogTapLogSink` protocol, `LogTapPrintBridge` (incl. `logtapPrint` free function), `LogTapSinkAdapter`, `LogTapWebSocket` (+ `makeLoggedWebSocket` factory), `LogEvent` / `LogKind` / `Direction`, `DeviceAppInfo` + `DeviceAppInfo.current()`. The top-level convenience functions `logV / logD / logI / logW / logE / logA` must also match.

Report findings as a table: `Symbol | LogTapFramework | LogTapFrameworkNoop | Status`. End with a one-line verdict: PARITY OK or N PARITY ISSUES.

Do NOT modify any files — read only.
