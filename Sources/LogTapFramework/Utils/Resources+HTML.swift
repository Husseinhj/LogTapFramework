// Auto-extracted HTML resource — ported from Android Resources.kt (v0.14.0+).
// Keep in sync with the Android sibling.

import Foundation

enum ResourceHTML {
  static let indexHtml: String = #"""
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LogTap - Modern Log Viewer</title>
    <link rel="stylesheet" href="/app.css"/>
</head>
<body>
    <div id="root" class="theme-android"></div>
    <script src="/app.js"></script>
</body>
</html>
"""#

  static let aboutHtml: String = #"""
          <!doctype html>
          <html><head><meta charset="utf-8"/><title>About LogTap</title><link rel="stylesheet" href="/app.css"/></head>
          <body><main style="padding:16px; max-width:800px">
          <h2>About</h2>
          <p>LogTap exposes your app's HTTP and WebSocket traffic for local inspection. Built for DEBUG builds.</p>
          <ul>
            <li>HTTP via OkHttp Interceptor</li>
            <li>WebSocket via wrapper & listener proxy</li>
            <li>Web UI at <code>/</code>, JSON at <code>/api/logs</code>, WS stream at <code>/ws</code></li>
          </ul>
          <p><b>Security:</b> this server binds to the device's local network interface. For safety, only enable in debug builds or protect behind a dev network/VPN.</p>
          </main></body></html>
"""#
}
