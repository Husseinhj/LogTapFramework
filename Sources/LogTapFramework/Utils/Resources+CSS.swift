// Auto-extracted CSS resource — ported from Android Resources.kt (v0.14.0+).
// Keep in sync with the Android sibling.

import Foundation

enum ResourceCSS {
  static let appCss: String = #"""
* { margin: 0; padding: 0; box-sizing: border-box; }
html, body { height: 100%; }
body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'SF Pro Text', sans-serif;
    background: #0a0a0a;
    color: #e4e4e4;
    overflow: hidden;
}
#root { width: 100vw; height: 100vh; display: flex; flex-direction: column; background: var(--bg-primary); color: var(--text-primary); }

/* Text selection — force readable contrast across themes/modes */
::selection { background: var(--accent); color: #ffffff; text-shadow: none; }
::-moz-selection { background: var(--accent); color: #ffffff; text-shadow: none; }

/* THEMES (dark by default) */
.theme-android {
    --bg-primary: #1e1e1e; --bg-secondary: #252526; --bg-tertiary: #2d2d30;
    --text-primary: #cccccc; --text-secondary: #858585;
    --accent: #3794ff;
    --verbose: #bbbbbb; --debug: #569cd6; --info: #4ec9b0;
    --warn: #dcdcaa; --error: #f48771; --assert: #f48771;
    --border: #3f3f46; --hover: rgba(255,255,255,0.05);
}
.theme-android.light-mode {
    --bg-primary: #ffffff; --bg-secondary: #f5f5f5; --bg-tertiary: #eeeeee;
    --text-primary: #1e1e1e; --text-secondary: #666666;
    --accent: #0066cc;
    --verbose: #666666; --debug: #0066cc; --info: #00a67e;
    --warn: #cc8800; --error: #d32f2f; --assert: #d32f2f;
    --border: #d0d0d0; --hover: rgba(0,0,0,0.05);
}
.theme-xcode {
    --bg-primary: #292a30; --bg-secondary: #1f1f24; --bg-tertiary: #36373c;
    --text-primary: #ffffff; --text-secondary: #8b8b8b;
    --accent: #0a84ff;
    --verbose: #8b8b8b; --debug: #6699ff; --info: #00cca3;
    --warn: #ffcc00; --error: #ff453a; --assert: #ff453a;
    --border: #3a3a3f; --hover: rgba(255,255,255,0.07);
}
.theme-xcode.light-mode {
    --bg-primary: #ffffff; --bg-secondary: #f7f7f7; --bg-tertiary: #efefef;
    --text-primary: #000000; --text-secondary: #6e6e6e;
    --accent: #007aff;
    --verbose: #6e6e6e; --debug: #0066cc; --info: #00a896;
    --warn: #f5a623; --error: #d70015; --assert: #d70015;
    --border: #d1d1d6; --hover: rgba(0,0,0,0.06);
}
.theme-grafana {
    --bg-primary: #0b0c0e; --bg-secondary: #111217; --bg-tertiary: #181b1f;
    --text-primary: #d4d4d8; --text-secondary: #9ca0ab;
    --accent: #ff5722;
    --verbose: #9ca0ab; --debug: #33b5e5; --info: #52c41a;
    --warn: #faad14; --error: #ff4d4f; --assert: #ff4d4f;
    --border: #26282e; --hover: rgba(255,255,255,0.06);
}
.theme-grafana.light-mode {
    --bg-primary: #f7f8fa; --bg-secondary: #ffffff; --bg-tertiary: #e9ecef;
    --text-primary: #212529; --text-secondary: #6c757d;
    --accent: #e53935;
    --verbose: #6c757d; --debug: #1e88e5; --info: #43a047;
    --warn: #fb8c00; --error: #e53935; --assert: #e53935;
    --border: #dee2e6; --hover: rgba(0,0,0,0.05);
}
.theme-modern {
    --bg-primary: #0f0f0f; --bg-secondary: #1a1a1a; --bg-tertiary: #242424;
    --text-primary: #f0f0f0; --text-secondary: #a0a0a0;
    --accent: #00d9ff;
    --verbose: #808080; --debug: #6366f1; --info: #14b8a6;
    --warn: #f59e0b; --error: #ef4444; --assert: #ef4444;
    --border: #2a2a2a; --hover: rgba(255,255,255,0.08);
}
.theme-modern.light-mode {
    --bg-primary: #fafafa; --bg-secondary: #ffffff; --bg-tertiary: #f0f0f0;
    --text-primary: #0f0f0f; --text-secondary: #6b7280;
    --accent: #0891b2;
    --verbose: #9ca3af; --debug: #4f46e5; --info: #059669;
    --warn: #d97706; --error: #dc2626; --assert: #dc2626;
    --border: #e5e7eb; --hover: rgba(0,0,0,0.04);
}

/* TOOLBAR */
.tb { background: var(--bg-secondary); border-bottom: 1px solid var(--border); padding: 12px 16px; display: flex; gap: 12px; align-items: center; flex-wrap: wrap; position: relative; }
.brand { display: flex; align-items: center; gap: 12px; margin-right: 12px; min-width: 0; }
.brand-icon { width: 32px; height: 32px; border-radius: 8px; background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); display: flex; align-items: center; justify-content: center; font-size: 13px; color: white; font-weight: bold; overflow: hidden; flex-shrink: 0; }
.brand-icon img { width: 100%; height: 100%; object-fit: cover; }
.brand-text { min-width: 0; }
.brand-name { font-size: 14px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 200px; }
.brand-meta { font-size: 11px; color: var(--text-secondary); font-weight: 400; }

.search-wrap { position: relative; flex: 1 1 300px; min-width: 200px; }
.search-input { width: 100%; padding: 8px 36px 8px 12px; background: var(--bg-tertiary); border: 1px solid var(--border); border-radius: 6px; color: var(--text-primary); font-size: 14px; outline: none; }
.search-input:focus { border-color: var(--accent); }
.star-btn { position: absolute; right: 8px; top: 50%; transform: translateY(-50%); background: transparent; border: none; color: var(--accent); cursor: pointer; font-size: 16px; padding: 4px; opacity: 0.7; transition: opacity 0.15s; }
.star-btn:hover { opacity: 1; }

.suggest { position: absolute; top: calc(100% + 4px); left: 0; right: 0; background: var(--bg-tertiary); border: 1px solid var(--border); border-radius: 8px; box-shadow: 0 8px 24px rgba(0,0,0,0.3); z-index: 1000; max-height: 300px; overflow-y: auto; }
.suggest-hdr { padding: 6px 12px; font-size: 11px; color: var(--text-secondary); border-bottom: 1px solid var(--border); font-weight: 600; }
.suggest-item { padding: 10px 12px; cursor: pointer; border-bottom: 1px solid var(--border); transition: background 0.1s; }
.suggest-item:last-child { border-bottom: none; }
.suggest-item.sel { background: var(--hover); }
.suggest-cmd { font-family: monospace; font-size: 13px; color: var(--accent); margin-bottom: 2px; }
.suggest-cmd .ph { color: var(--text-secondary); font-style: italic; }
.suggest-desc { font-size: 12px; color: var(--text-secondary); }
.suggest-ex { font-size: 11px; color: var(--text-secondary); margin-top: 2px; opacity: 0.7; }

.icon-btn { padding: 8px; background: var(--bg-tertiary); border: 1px solid var(--border); border-radius: 6px; color: var(--text-primary); cursor: pointer; font-size: 18px; width: 36px; height: 36px; display: flex; align-items: center; justify-content: center; position: relative; transition: background 0.1s; line-height: 1; }
.icon-btn:hover { background: var(--hover); }
.icon-btn.active { background: var(--accent); color: #fff; border-color: var(--accent); }
.icon-btn.danger { color: var(--error); }
.icon-btn.accent { color: var(--accent); }
.toolbar-right { margin-left: auto; display: flex; gap: 8px; align-items: center; }

.badge { position: absolute; top: -4px; right: -4px; background: var(--error); color: white; border-radius: 10px; font-size: 10px; font-weight: bold; padding: 2px 5px; min-width: 16px; text-align: center; line-height: 1; }

.popover { position: absolute; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 8px; box-shadow: 0 8px 32px rgba(0,0,0,0.3); z-index: 1000; padding: 12px; }
.popover-section { padding: 8px 4px; font-size: 11px; color: var(--text-secondary); font-weight: 600; text-transform: uppercase; }
.popover select, .popover input[type=text] { width: 100%; padding: 8px 12px; background: var(--bg-tertiary); border: 1px solid var(--border); border-radius: 6px; color: var(--text-primary); font-size: 13px; cursor: pointer; outline: none; }
.popover select:focus, .popover input:focus { border-color: var(--accent); }

.saved-list { max-height: 300px; overflow: auto; }
.saved-empty { padding: 24px; text-align: center; color: var(--text-secondary); font-size: 13px; }
.saved-row { padding: 12px; background: var(--bg-tertiary); border-radius: 6px; margin-bottom: 8px; display: flex; justify-content: space-between; align-items: center; gap: 8px; }
.saved-row .body { flex: 1; min-width: 0; cursor: pointer; }
.saved-row .body:hover { color: var(--accent); }
.saved-q { font-size: 12px; font-family: monospace; color: var(--text-secondary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.saved-ts { font-size: 10px; color: var(--text-secondary); margin-top: 4px; }
.del-btn { padding: 6px 10px; background: transparent; border: 1px solid var(--border); border-radius: 4px; color: var(--error); cursor: pointer; font-size: 12px; }

/* FILTER PANEL */
.filter-panel { width: 100%; padding: 16px; background: var(--bg-tertiary); border-radius: 8px; border: 1px solid var(--border); display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; }
.filter-panel label { font-size: 12px; color: var(--text-secondary); display: block; margin-bottom: 4px; }
.filter-panel select, .filter-panel input { width: 100%; padding: 6px 8px; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 4px; color: var(--text-primary); font-size: 14px; outline: none; }
.exclude-row { display: flex; gap: 8px; margin-bottom: 8px; }
.exclude-row select { flex: 0 0 140px; }
.exclude-row input { flex: 1; }
.exclude-row button { padding: 6px 12px; background: var(--accent); border: none; border-radius: 4px; color: white; cursor: pointer; font-size: 14px; }
.chips { display: flex; flex-wrap: wrap; gap: 6px; }
.chip { padding: 4px 8px; background: var(--bg-secondary); border-radius: 12px; font-size: 12px; display: flex; align-items: center; gap: 4px; }
.chip button { background: none; border: none; color: var(--error); cursor: pointer; font-size: 14px; padding: 0 4px; line-height: 1; }

/* METRICS BAR */
.metrics { background: var(--bg-secondary); border-bottom: 1px solid var(--border); padding: 12px 16px; display: flex; gap: 24px; font-size: 13px; flex-wrap: wrap; }
.metric { display: flex; align-items: center; gap: 8px; }
.metric .l { font-size: 11px; color: var(--text-secondary); text-transform: uppercase; }
.metric .v { font-size: 16px; font-weight: 600; }

/* MAIN AREA */
.main { flex: 1; display: flex; overflow: hidden; min-height: 0; }

/* LOGCAT VIEW */
.logcat { flex: 1; overflow: auto; padding: 8px 0; font-family: 'JetBrains Mono', 'SF Mono', Menlo, Consolas, monospace; font-size: 12px; line-height: 1.5; background: var(--bg-primary); }
.logcat-row { padding: 1px 16px; white-space: pre-wrap; cursor: default; word-break: break-all; }
.logcat-row:hover { background: var(--hover); }
.logcat-time { color: var(--text-secondary); }
.logcat-tid { color: var(--text-secondary); }
.logcat-tag { font-weight: 600; }
.lvl-V { color: var(--verbose); }
.lvl-D { color: var(--debug); }
.lvl-I { color: var(--info); }
.lvl-W { color: var(--warn); }
.lvl-E { color: var(--error); }
.lvl-A { color: var(--assert); }
.logcat-net-line { color: var(--text-secondary); padding-left: 140px; white-space: pre-wrap; word-break: break-all; }
.logcat-net-line .k { color: var(--accent); }
.logcat-net-line .req { color: var(--warn); }
.logcat-net-line .res-ok { color: var(--info); }
.logcat-net-line .res-err { color: var(--error); }

/* TABLE VIEW */
.tbl-wrap { flex: 1; overflow: auto; min-height: 0; }
.tbl-head { display: grid; gap: 12px; padding: 10px 16px; background: var(--bg-secondary); border-bottom: 1px solid var(--border); font-size: 11px; font-weight: 600; color: var(--text-secondary); text-transform: uppercase; position: sticky; top: 0; z-index: 1; min-width: fit-content; }
.tbl-head .col { display: flex; align-items: center; position: relative; user-select: none; }
.col-resize { position: absolute; right: -6px; top: -10px; bottom: -10px; width: 12px; cursor: col-resize; z-index: 10; }
.col-resize::after { content: ''; display: block; width: 1px; height: 100%; margin: 0 auto; background: var(--border); }
.col-resize:hover::after, .col-resize.dragging::after { background: var(--accent); width: 2px; }
.tbl-body { min-width: fit-content; }
.tbl-row { display: grid; gap: 12px; padding: 10px 16px; border-bottom: 1px solid var(--border); font-size: 13px; cursor: pointer; transition: background 0.1s; align-items: start; }
.tbl-row:hover { background: var(--hover); }
.tbl-row.selected { background: var(--hover); border-left: 3px solid var(--accent); padding-left: 13px; }
.tbl-row.compact { padding: 4px 16px; }
.tbl-row.spacious { padding: 16px; }
.tbl-cell { overflow: hidden; word-break: break-word; }
.tbl-cell .tt-id { color: var(--text-secondary); font-family: monospace; font-size: 11px; }
.tbl-cell .tt-time { color: var(--text-secondary); font-family: monospace; font-size: 11px; white-space: nowrap; }
.type-pill { display: inline-block; padding: 1px 6px; border-radius: 4px; font-size: 10px; font-weight: 600; text-transform: uppercase; }
.type-http { background: rgba(20,184,166,0.15); color: var(--info); }
.type-log { background: rgba(86,156,214,0.15); color: var(--debug); }
.type-ws { background: rgba(168,85,247,0.15); color: #a855f7; }
.method-tag { font-family: monospace; font-weight: 600; font-size: 11px; }
.status-pill { display: inline-block; padding: 1px 6px; border-radius: 4px; font-size: 11px; font-weight: 600; }
.status-2 { background: rgba(20,184,166,0.15); color: var(--info); }
.status-3 { background: rgba(86,156,214,0.15); color: var(--debug); }
.status-4 { background: rgba(245,158,11,0.15); color: var(--warn); }
.status-5 { background: rgba(239,68,68,0.15); color: var(--error); }
.url-cell { word-break: break-all; }
.url-body { font-size: 11px; color: var(--text-secondary); margin-top: 4px; font-family: monospace; max-height: 5em; overflow: hidden; text-overflow: ellipsis; white-space: pre-wrap; word-break: break-word; }
.resp-cell { font-family: monospace; font-size: 11px; max-height: 5em; overflow: hidden; word-break: break-all; white-space: pre-wrap; }
.resp-ok { color: var(--info); }
.resp-err { color: var(--error); }
.tbl-row .expand-area { grid-column: 1/-1; padding: 12px; background: var(--bg-tertiary); border-radius: 6px; margin-top: 8px; }
.exp-section { margin-bottom: 12px; }
.exp-section:last-child { margin-bottom: 0; }
.exp-label { font-size: 11px; color: var(--text-secondary); font-weight: 600; text-transform: uppercase; margin-bottom: 4px; }
.exp-content { font-family: monospace; font-size: 12px; padding: 8px; background: var(--bg-secondary); border-radius: 4px; white-space: pre-wrap; word-break: break-all; max-height: 240px; overflow: auto; }
.headers-grid { display: grid; grid-template-columns: max-content 1fr; gap: 4px 12px; font-family: monospace; font-size: 12px; padding: 8px; background: var(--bg-secondary); border-radius: 4px; }
.headers-grid .hk { color: var(--accent); }
.headers-grid .hv { color: var(--text-primary); word-break: break-all; }

/* DETAIL PANEL */
.detail { flex: 0 0 40%; min-width: 320px; background: var(--bg-secondary); border-left: 1px solid var(--border); display: flex; flex-direction: column; overflow: hidden; }
.detail-hdr { padding: 12px 16px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center; }
.detail-title { font-size: 14px; font-weight: 600; }
.detail-tabs { display: flex; gap: 4px; padding: 8px 16px; border-bottom: 1px solid var(--border); }
.detail-tab { padding: 6px 12px; background: transparent; border: 1px solid var(--border); border-radius: 4px; color: var(--text-secondary); cursor: pointer; font-size: 12px; }
.detail-tab.active { background: var(--accent); color: white; border-color: var(--accent); }
.detail-body { flex: 1; overflow: auto; padding: 16px; }

/* CONTEXT MENU */
.ctx-menu { position: fixed; background: var(--bg-secondary); border: 1px solid var(--border); border-radius: 8px; box-shadow: 0 8px 32px rgba(0,0,0,0.5); z-index: 10000; padding: 6px; min-width: 200px; backdrop-filter: blur(8px); }
.ctx-item { padding: 8px 12px; font-size: 13px; cursor: pointer; border-radius: 4px; display: flex; align-items: center; gap: 8px; }
.ctx-item:hover { background: var(--hover); }
.ctx-sep { height: 1px; background: var(--border); margin: 4px 0; }

/* STATUS BAR */
.status-bar { background: var(--bg-secondary); border-top: 1px solid var(--border); padding: 6px 16px; display: flex; gap: 16px; align-items: center; font-size: 12px; color: var(--text-secondary); }
.status-bar .right { margin-left: auto; display: flex; gap: 12px; align-items: center; }
.conn-dot { width: 8px; height: 8px; border-radius: 50%; }
.conn-connecting { background: var(--warn); animation: pulse 1.2s ease-in-out infinite; }
.conn-connected { background: var(--info); }
.conn-disconnected { background: var(--error); }
@keyframes pulse { 0%,100% { opacity: 1; } 50% { opacity: 0.4; } }

/* AUTOSCROLL TOAST */
.toast { position: fixed; bottom: 50px; left: 50%; transform: translateX(-50%); background: var(--bg-tertiary); border: 1px solid var(--border); border-radius: 6px; padding: 8px 12px; font-size: 12px; cursor: pointer; box-shadow: 0 4px 12px rgba(0,0,0,0.3); z-index: 100; }
.toast:hover { background: var(--accent); color: white; }

/* MISC */
.hidden { display: none !important; }
.muted { color: var(--text-secondary); }
button { font-family: inherit; }
"""#
}
