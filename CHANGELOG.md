# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),  
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

### 0.10.1 - 2026-05-13

- Fix auto-scroll flicker: the log list briefly jumped to the top every time a new event arrived. `refreshLiveAreas` now captures the active scroller's position before replacing `.main` and restores it (or pins to bottom when auto-scroll is on or the user was already at bottom) synchronously, so the browser never paints an intermediate `scrollTop = 0` state.

### 0.10.0 - 2026-05-13

Modern viewer redesign + correctness fixes — ports Android LogTap v0.14.0.

**Web UI rewrite (`Sources/LogTapFramework/Utils/Resources+{HTML,CSS,JS}.swift`)**
- Command-search syntax with autocomplete (`level:`, `method:`, `status:`, `exclude:tag:`, `exclude:message:`)
- Saved filters with star-toggle
- 4 themes × dark/light (Android Studio, Xcode, Grafana, Modern)
- Logcat View + Table View toggle, context menu, JSON export
- PID/TID column matching `adb logcat -v threadtime`
- Status shorthand: `2xx` / `4xx` / `5xx`
- New `GET /about` route serving `Resources.aboutHtml`

**Correctness / security fixes**
- `LogTapURLProtocol` now redacts request + response headers per `Config.redactHeaders` (previously NOT redacted — secrets visible).
- `LogTap.makeBodyPreview` honors `Config.maxBodyBytes` (previously hard-coded 64 KB regardless of config).
- Response events now report `bodyIsTruncated` accurately.
- `POST /api/clear` now actually empties `LogTapStore` (previously a no-op).
- New WS clients receive last 200 events as backlog on connect (previously empty until first new event).
- `LogEvent` gained `pid` / `tid` fields; `LogTapStore.add` auto-assigns own PID when event has none.

**Tooling**
- New `LogTapFrameworkNoop` standalone SPM package at `LogTapFramework-Noop/` — API-compatible empty bodies for release builds.
- Workspace `LogTapIOS.xcworkspace` now exposes three schemes: `LogTapFramework`, `LogTapFrameworkNoop`, `LogTapSample`.
- Added `CLAUDE.md`, `ISSUES.md`, `.claude/commands/parity-check.md`, `.claude/commands/release-prep.md`.

No Swift source-compat breaks — new `LogEvent` init parameters are defaulted; new fields are optional Codable members.

### 0.9.0 - 2025-11-03
- Add timestamp option to LogTapLogger;
- Format log messages with optional timestamps
- Update Html UI for Mobile size

### 0.8.0 - 2025-10-28
- Providing one URL for accessing the LogTap server
- Move code from print to os_log to be able to see the logs in the  Console app too.

### 0.7.0 - 2025-10-22
- Fix issue to adding LogTapFramework via SPM
- Fix issue showing logs in webpage

### 0.6.0 - 2025-10-21
- Fix loading the library

### 0.5.0 - 2025-10-5
- Change library from LogTapIOS to LogTapFramework

### 0.4.0 - 2025-09-09

Enhance UI with DeviceAppInfo, settings popover, and improved accessibility

- Add DeviceAppInfo to dynamically display app details in the UI.
- Introduce a settings popover for UI customization, including theme selection, JSON formatting, auto-scroll, and column visibility.
- Refactor filters and settings popovers for better UI consistency and accessibility.
- Update the stats bar to be sticky and visually consistent with the header.
- Improve the export menu UI with better accessibility and dynamic behavior.
- Update README.md with the new version.
- Add new dependencies and update existing ones in Package.swift.

### 0.3.0 - 2025-09-07

- Fix WebSocket URL and improve data handling in LogTapServer

### 0.2.0 - 2025-09-07
Refactor UI and functionality

- Update repository URL from LogTap to LogTapIOS.
- Implement resizable and persistable table columns.
- Change default for "Pretty JSON" to enabled.
- Default "Actions" column to hidden.
- Improve log message display and parsing.
- Minor style adjustments for table padding and layout.

## 0.1.0 - 2025-09-07
### Added
- Initial release of **LogTap** for iOS/macOS/iPadOS.
- Core **LogTapServer** implementation with embedded SwiftNIO server.
- **Logger**:
  - Capture standard logs with levels: VERBOSE, DEBUG, INFO, WARN, ERROR, ASSERT.
  - `LogTapPrintBridge` for redirecting `print` output into LogTap.
- **Interceptor**:
  - `LogTapURLProtocol` for capturing HTTP(S) requests and responses automatically.
- **WebSocket Logger**:
  - Real-time capture of WebSocket messages (send/receive, ping/pong/close).
- **Web UI Viewer**:
  - Material 3–inspired design with selectable themes (Android Studio, Xcode, VS Code, Grafana).
  - Persistent theme and layout preferences.
  - Filter panel with column toggles, status filters, and level filters.
  - Stats chips for quick filtering (Total, HTTP, WS, Log, GET, POST).
  - Drawer panel with detailed request/response/headers and JSON syntax highlighting.
  - Export logs as JSON or HTML reports.
- **Multi-platform support**:
  - iOS, macOS, and iPadOS targets via Swift Package Manager (SPM).

---

## Notes
- This is the **first public version**. Expect API and UI refinements in upcoming releases.
- Feedback and contributions are welcome!
