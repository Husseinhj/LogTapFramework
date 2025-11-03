// Auto-extracted CSS resource from Resources.swift
// Created to split large resource into a dedicated file for easier debugging.

import Foundation

enum ResourceCSS {
  static let appCss: String = #"""
/* DeviceAppInfo icon */
.app-icon{
  width:40px;
  height:40px;
  border-radius:12px;
  background:var(--surface);
  border:1px solid var(--line);
  background-size:cover;
  background-position:center;
  flex-shrink:0;
}

/* ========================= Material 3 (tokens + components) ========================= */
/* Color roles */
:root[data-theme="light"]{
  --md-sys-color-primary:#6750A4;         /* Indigo 500-ish */
  --md-sys-color-on-primary:#FFFFFF;
  --md-sys-color-primary-container:#EADDFF;
  --md-sys-color-on-primary-container:#21005E;
  --md-sys-color-secondary:#625B71;
  --md-sys-color-on-secondary:#FFFFFF;
  --md-sys-color-secondary-container:#E8DEF8;
  --md-sys-color-on-secondary-container:#1D192B;
  --md-sys-color-surface:#FFFBFE;
  --md-sys-color-surface-dim:#E6E0E9;
  --md-sys-color-surface-bright:#FEF7FF;
  --md-sys-color-surface-container:#F3EDF7;
  --md-sys-color-surface-container-high:#ECE6F0;
  --md-sys-color-surface-container-highest:#E6E0E9;
  --md-sys-color-on-surface:#1D1B20;
  --md-sys-color-on-surface-variant:#49454F;
  --md-sys-color-outline:#79747E;
  --md-sys-color-outline-variant:#CAC4D0;
  --md-sys-color-error:#B3261E;
  --md-sys-color-on-error:#FFFFFF;
  --md-sys-color-inverse-surface:#313033;
  --md-sys-color-inverse-on-surface:#F4EFF4;
  --md-sys-color-scrim:#000000;
}
:root[data-theme="dark"]{
  --md-sys-color-primary:#D0BCFF;
  --md-sys-color-on-primary:#371E73;
  --md-sys-color-primary-container:#4F378B;
  --md-sys-color-on-primary-container:#EADDFF;
  --md-sys-color-secondary:#CCC2DC;
  --md-sys-color-on-secondary:#332D41;
  --md-sys-color-secondary-container:#4A4458;
  --md-sys-color-on-secondary-container:#E8DEF8;
  --md-sys-color-surface:#141218;
  --md-sys-color-surface-dim:#141218;
  --md-sys-color-surface-bright:#3B383E;
  --md-sys-color-surface-container:#1D1B20;
  --md-sys-color-surface-container-high:#2B2930;
  --md-sys-color-surface-container-highest:#36343B;
  --md-sys-color-on-surface:#E6E0E9;
  --md-sys-color-on-surface-variant:#CAC4D0;
  --md-sys-color-outline:#938F99;
  --md-sys-color-outline-variant:#49454F;
  --md-sys-color-error:#F2B8B5;
  --md-sys-color-on-error:#601410;
  --md-sys-color-inverse-surface:#E6E0E9;
  --md-sys-color-inverse-on-surface:#313033;
  --md-sys-color-scrim:#000000;
}

/* Semantic aliases used by existing markup (mapped to M3 roles) */
:root{
  --bg:var(--md-sys-color-surface);
  --bg2:var(--md-sys-color-surface-bright);
  --surface:var(--md-sys-color-surface-container);
  --surface-2:var(--md-sys-color-surface-container-high);
  --text:var(--md-sys-color-on-surface);
  --muted:var(--md-sys-color-on-surface-variant);
  --line:var(--md-sys-color-outline-variant);
  --chip:var(--md-sys-color-surface-container-highest);
  --code:var(--md-sys-color-on-surface);
  --codebg:var(--md-sys-color-surface-dim);
  --primary:var(--md-sys-color-primary);
  --on-primary:var(--md-sys-color-on-primary);
  --accent:var(--md-sys-color-primary);
  --accent2:#22c55e; /* success (not in core M3 set) */
  --warn:#f59e0b;    /* warning (custom) */
  --err:var(--md-sys-color-error);

  /* Elevation levels (M3 uses surface tonal overlays; we approximate with shadow) */
  --elev-1:0 1px 2px rgba(0,0,0,.14), 0 1px 3px 1px rgba(0,0,0,.12);
  --elev-2:0 2px 6px rgba(0,0,0,.18), 0 1px 2px rgba(0,0,0,.08);
  --elev-3:0 6px 10px rgba(0,0,0,.20), 0 1px 3px rgba(0,0,0,.10);

  /* State layer opacities */
  --state-hover: .08;
  --state-focus: .12;
  --state-pressed: .12;
  --drawer-w:560px;
}

*{box-sizing:border-box}
html,body{height:100%}
body.ui{margin:0;background:var(--bg);color:var(--text);font:14px ui-sans-serif,system-ui,-apple-system,"Segoe UI",Roboto,Helvetica,Arial}

/* ========================= Top App Bar (M3) ========================= */
.hdr{position:sticky;top:0;z-index:40;display:flex;align-items:center;justify-content:space-between;padding:12px 16px;background:var(--md-sys-color-surface);border-bottom:1px solid var(--line)}
.brand{display:flex;gap:12px;align-items:center}
.logo{width:40px;height:40px;border-radius:12px;display:grid;place-items:center;border:1px solid var(--line);background:var(--md-sys-color-surface-container);color:var(--accent)}
.logo svg{width:22px;height:22px;fill:currentColor}
.titles .title{font-weight:700;letter-spacing:.2px}
.titles .sub{color:var(--muted);font-size:12px}

/* ========================= Inputs & Buttons (M3) ========================= */
.field{position:relative;display:flex;align-items:center}
.field .ico{position:absolute;left:10px;top:50%;transform:translateY(-50%);width:18px;height:18px;opacity:.7;fill:var(--muted)}
.input{background:var(--surface);color:var(--text);border:1px solid var(--line);border-radius:12px;padding:10px 36px 10px 34px}
.select{background:var(--surface);color:var(--text);border:1px solid var(--line);border-radius:12px;padding:10px 12px}

/* ========================= Buttons & Icons ========================= */
.btn{--bgc:var(--md-sys-color-primary);--fgc:var(--md-sys-color-on-primary);background:var(--bgc);color:var(--fgc);border:0;border-radius:20px;padding:8px 16px;cursor:pointer;position:relative;overflow:hidden}
.btn.ghost{--bgc:transparent;--fgc:var(--text);border:1px solid var(--line)}
.btn.block{display:block;width:100%;text-align:left}
.btn.xs{padding:6px 10px;border-radius:16px}
.btn::after,.icon::after{content:"";position:absolute;inset:0;background:currentColor;opacity:0;transition:opacity .15s}
.btn:hover::after,.icon:hover::after{opacity:var(--state-hover)}
.btn:active::after,.icon:active::after{opacity:var(--state-pressed)}
#filtersBtn{display:flex;align-items:center;gap:4px}
#filtersBtn .material-symbols-outlined.dropdown,
#settingsBtn .material-symbols-outlined.dropdown{font-size:20px;opacity:.7}
#filtersBtn .label, #settingsBtn .label{font-size:14px}

.icon{width:36px;height:36px;border-radius:12px;background:transparent;border:1px solid var(--line);color:var(--text);font-size:18px;line-height:1;display:grid;place-items:center;position:relative;overflow:hidden}
.icon.solid{background:var(--surface)}
.icon .material-symbols-outlined{font-size:20px}

.bar{display:flex;gap:8px;align-items:center;flex-wrap:wrap;position:relative}
.menu{position:relative}

.popover{position:absolute;top:100%;margin-top:8px;right:0;background:var(--md-sys-color-surface);border:1px solid var(--line);border-radius:12px;box-shadow:var(--elev-3);padding:10px;z-index:50;min-width:220px}
.popover.hidden{display:none}
.popover.hidden{ display:none !important; }
.hidden{ display:none !important; }
.fp.hidden{ display:none !important; }

.fp{ padding:0; min-width: 360px; max-width: 520px; }
#exportMenu{ position:absolute; top:100%; right:0; margin-top:8px; background:var(--md-sys-color-surface); border:1px solid var(--line); border-radius:12px; box-shadow:var(--elev-3); z-index:60; min-width:220px; }
.fp-head{ padding:14px 16px 8px; border-bottom:1px solid var(--line); }
.fp-title{ font-weight:700; }
.fp-sub{ color:var(--muted); font-size:12px; margin-top:2px; }
.fp-grid{ display:grid; grid-template-columns:1fr 1fr; gap:12px 12px; padding:12px 12px 4px; }
.fp-field .input, .fp-field .select{ width:100%; }
.fp-switch{ display:flex; align-items:center; gap:10px; padding:6px 4px; }
.fp-actions{ display:flex; justify-content:flex-end; gap:8px; padding:10px 12px; border-top:1px solid var(--line); }
.fp-actions .btn{ display:inline-flex; align-items:center; gap:6px; }
@media (max-width:520px){ .fp{ min-width: 280px; } .fp-grid{ grid-template-columns:1fr; } }

/* Export menu buttons styled as Material 3 list items */
/* === Export menu compact & fixed layout overrides === */
#exportMenu.fp.popover{
  position: absolute;
  top: 100%;
  right: 0;
  margin-top: 8px;
  min-width: 260px;
  max-width: 320px;
  padding: 0; /* container gets no padding; inner sections handle it */
  background: var(--md-sys-color-surface);
  border: 1px solid var(--line);
  border-radius: 12px;
  box-shadow: var(--elev-3);
  z-index: 60;
}
#exportMenu.hidden { display: none !important; }

#exportMenu .fp-head{
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 8px;
  padding: 10px 12px;
  border-bottom: 1px solid var(--line);
}
#exportMenu .fp-icon{
  width: 22px;
  height: 22px;
  display: grid;
  place-items: center;
  color: var(--muted);
}
#exportMenu .fp-title{
  font-weight: 700;
  font-size: 14px;
  flex: 1;
  min-width: 0;
}
#exportMenu .icon{
  width: 28px;
  height: 28px;
  border-radius: 8px;
}

#exportMenu .fp-body{ padding: 6px; }
#exportMenu .fp-section{ padding: 0; margin: 0; }

/* Buttons look like list items */
#exportMenu .btn.block{
  background: transparent;
  border: 0;
  border-radius: 10px;
  padding: 10px 12px;
  font-size: 14px;
  color: var(--text);
  justify-content: flex-start;
  width: 100%;
  text-align: left;
}
#exportMenu .btn.block:hover::after { opacity: var(--state-hover); }
#exportMenu .btn.block:active::after { opacity: var(--state-pressed); }

/* Footer hint and close */
#exportMenu .fp-foot{
  padding: 8px 12px;
  border-top: 1px solid var(--line);
  display: flex;
  align-items: center;
  justify-content: space-between;
}
#exportMenu .fp-foot .hint{
  color: var(--muted);
  font-size: 12px;
}

/* Material 3 checkboxes inside filter panel */
/* === Material 3 Inspired Checkboxes & Radios === */
.fp-checkbox,
.fp-radio {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 6px;
  cursor: pointer;
  user-select: none;
  font-size: 14px;
  border-radius: 8px;
  transition: background 0.2s ease;
}
.fp-checkbox:hover,
.fp-radio:hover {
  background: color-mix(in srgb, var(--md-sys-color-primary) 8%, transparent);
}
.fp-checkbox input,
.fp-radio input {
  appearance: none;
  -webkit-appearance: none;
  width: 20px;
  height: 20px;
  margin: 0;
  border: 2px solid var(--line);
  border-radius: 6px; /* default square for checkbox */
  background: var(--surface);
  display: grid;
  place-items: center;
  transition: border-color 0.2s, background 0.2s;
}
.fp-radio input {
  border-radius: 50%; /* radios are round */
}
.fp-checkbox input:checked,
.fp-radio input:checked {
  background: var(--md-sys-color-primary);
  border-color: var(--md-sys-color-primary);
}
.fp-checkbox input:checked::before {
  content: "✓";
  color: var(--md-sys-color-on-primary);
  font-size: 14px;
}
.fp-radio input:checked::before {
  content: "";
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: var(--md-sys-color-on-primary);
}

/* Filters: Columns grid */
.fp-cols{ grid-column:1 / -1; display:grid; grid-template-columns:repeat(2, minmax(0,1fr)); gap:6px 12px; padding-top:4px; }
.fp-cols-title{ grid-column:1 / -1; font-weight:600; color:var(--muted); margin:4px 0; }
@media (max-width:520px){ .fp-cols{ grid-template-columns:1fr; } }

/* Column visibility (body classes) */
body.hide-col-id      #logtbl .col-id{display:none}
body.hide-col-time    #logtbl .col-time{display:none}
body.hide-col-kind    #logtbl .col-kind{display:none}
body.hide-col-tag     #logtbl .col-tag{display:none}
body.hide-col-method  #logtbl .col-method{display:none}
body.hide-col-status  #logtbl .col-status{display:none}
body.hide-col-url     #logtbl .col-url{display:none}
body.hide-col-actions #logtbl .col-actions{display:none}

/* ========================= Assist/Stat Chips (M3) ========================= */
.stats {
  position: sticky;
  top: 64px; /* height of your header */
  z-index: 30; /* slightly below header’s z-index (40) */
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  padding: 10px 16px;
  background: var(--md-sys-color-surface); /* match header bg */
}
.chip{background:var(--md-sys-color-surface-container-high);border:1px solid var(--line);padding:6px 12px;border-radius:999px;transition:background .15s,border-color .15s,color .15s,box-shadow .15s}

.chip.stat{font:12px ui-monospace,Menlo,monospace}

/* Clickable stats */
.stats .chip{cursor:default; user-select:none}
.stats .chip.clickable{cursor:pointer; position:relative}
.stats .chip.clickable:hover{background:var(--md-sys-color-surface-container-highest); box-shadow:0 0 0 3px color-mix(in srgb,var(--accent) 22%, transparent) inset}
.stats .chip.clickable:active{box-shadow:0 0 0 4px color-mix(in srgb,var(--accent) 32%, transparent) inset}
/* Selected (visible even in dark): allow aria-pressed or .active */
.stats .chip.active,
.stats .chip[aria-pressed="true"]{
  background:var(--md-sys-color-primary);
  color:var(--md-sys-color-on-primary);
  border-color:transparent;
  box-shadow:0 0 0 2px color-mix(in srgb,var(--md-sys-color-primary) 60%, transparent), 0 1px 2px rgba(0,0,0,.25);
  font-weight:700;
  transform:translateY(-1px);
}
/* Add an obvious check dot on the left for selected state */
.stats .chip.active::before,
.stats .chip[aria-pressed="true"]::before{
  content:"";
  display:inline-block;
  width:10px; height:10px; border-radius:50%;
  background:var(--md-sys-color-on-primary);
  margin-right:8px;
  box-shadow:0 0 0 3px color-mix(in srgb,var(--md-sys-color-on-primary) 35%, transparent);
  vertical-align:middle;
}
/* Keyboard focus ring for accessibility */
.stats .chip.clickable:focus-visible{
  outline:none;
  box-shadow:0 0 0 3px color-mix(in srgb,var(--md-sys-color-primary) 70%, transparent);
}

/* WS colorful status (kept) */
#wsStatus{transition:background-color .2s ease,color .2s ease,border-color .2s ease}
#wsStatus.status-on{background:rgba(34,197,94,.15);color:#16a34a;border-color:#16a34a33}
#wsStatus.status-off{background:rgba(244,63,94,.15);color:#ef4444;border-color:#ef444433}
#wsStatus.status-connecting{background:rgba(245,158,11,.18);color:#d97706;border-color:#d9770633}

/* ========================= Layout ========================= */
.shell{display:flex;gap:12px;padding-left:12px;padding-right:12px;align-items:stretch}
.stats{ overflow-x:auto; -webkit-overflow-scrolling:touch; scrollbar-width:thin; }
.panel{flex:1 1 auto;border:1px solid var(--line);border-radius:16px;background:var(--md-sys-color-surface);box-shadow:var(--elev-1);overflow:auto;overflow-x:auto;max-height:calc(100vh - 180px)}
.repo{
  position:sticky;
  bottom:0;
  z-index:20;
  padding:12px 16px;
  text-align:center;
  color:var(--muted);
  font-size:13px;
  display:flex;
  flex-direction:column;
  align-items:center;
  gap:4px;
  background:var(--md-sys-color-surface);
  box-shadow:var(--elev-1);
}
.repo a{color:inherit;text-decoration:none;border-bottom:1px dashed var(--line)}
.repo a:hover{color:var(--accent);border-bottom-color:var(--accent)}
.repo .gh-ico{width:16px;height:16px;vertical-align:middle;margin-right:4px;fill:currentColor}

/* ========================= Data Table (M3) ========================= */
.tbl{width:100%;border-collapse:separate;border-spacing:0;table-layout:fixed}
/* Table header sticky row */
.tbl thead th {
  position: sticky;
  top: 0;
  background: var(--md-sys-color-surface-container-high);
  color: var(--md-sys-color-on-surface);
  font-weight: 700;
  font-size: 13px;
  letter-spacing: .5px;
  padding: 14px 12px;
  text-align: left;
  border-bottom: 2px solid var(--md-sys-color-outline-variant);
  z-index: 2;
  text-transform: uppercase;
}
/* Column resize handle */
.tbl thead th{ position: sticky; /* keep existing */ }
/* make header cell itself relatively positioned for handle */
.tbl thead th{ position: sticky; }
/* actual handle UI */
.tbl thead th{ position: sticky; }
  .th-resizer{
    position:absolute;
    top:0; right:-5px; bottom:0;
    width:10px; /* wider hit area */
    cursor:col-resize;
    z-index:5;
  }
  /* always-visible divider line */
    .th-resizer::after{
      content:"";
      position:absolute;
      top:8px;
      bottom:8px;
      left:4px;
      width:2px;
      background: color-mix(in srgb, var(--md-sys-color-outline-variant) 50%, transparent);
      transition: background .15s, left .15s, width .15s;
    }
  /* subtle grabber dots */
  .th-resizer::before{
    content:"";
    position:absolute; top:50%; left:3px; width:4px; height:14px;
    transform: translateY(-50%);
    background:
      radial-gradient(currentColor 2px, transparent 3px) 0 2px/4px 6px repeat-y;
    color: color-mix(in srgb, var(--md-sys-color-outline-variant) 65%, transparent);
    opacity:.7;
    pointer-events:none;
  }
  /* hover/active emphasis */
  .tbl thead th:hover .th-resizer::after,
  .th-resizer:hover::after,
  body.th-resizing .th-resizer::after{
    background: color-mix(in srgb, var(--md-sys-color-primary) 55%, transparent);
    left:4px; width:2px;
  }
  .th-resizing{ user-select:none !important; cursor:col-resize !important; }
/* Keep first header cells readable when table scrolls */
.tbl thead th:first-child{
  position: sticky;
  left: 0;
  z-index: 3;
  background: var(--md-sys-color-surface-container-high);
}
.tbl tbody tr{background:var(--md-sys-color-surface);border-bottom:1px solid var(--line)}
.tbl tbody tr:hover{background:var(--md-sys-color-surface-container-high)}
.tbl tbody td{padding:14px 12px;vertical-align:top}
.col-id{width:var(--col-id-w,72px)}.col-time{width:var(--col-time-w,150px)}.col-kind{width:var(--col-kind-w,120px)}.col-tag{width:var(--col-tag-w,140px)}.col-method{width:var(--col-method-w,92px)}.col-status{width:var(--col-status-w,92px)}.col-actions{width:var(--col-actions-w,170px)}

/* Status & kind colors */

.fp-radio {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 6px 4px;
  cursor: pointer;
  user-select: none;
}
.fp-radio input {
  appearance: none;
  -webkit-appearance: none;
  width: 16px;
  height: 16px;
  border: 2px solid var(--line);
  border-radius: 50%;
  background: var(--surface);
  margin: 0;
}
.fp-radio input:checked {
  background: var(--md-sys-color-primary);
  border-color: var(--md-sys-color-primary);
}
.fp-radio input:checked::before {
  content: "";
  display: block;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: var(--md-sys-color-on-primary);
  margin: auto;
}
.fp-radio .lbl {
  font-size: 14px;
}

/* Fallback WS palette (overridden per scheme below) */
:root{
  --ws-send:#06b6d4;
  --ws-recv:#22c55e;
  --ws-ping:#a3e635;
  --ws-pong:#f59e0b;
  --ws-close:#ef4444;
}
/* Table tinting for WebSocket rows */
.tbl tbody tr.ws-send  td.col-url .url{ color: color-mix(in srgb, var(--ws-send) 85%, currentColor); }
.tbl tbody tr.ws-recv  td.col-url .url{ color: color-mix(in srgb, var(--ws-recv) 85%, currentColor); }
.tbl tbody tr.ws-send  td.col-method{ color: var(--ws-send); }
.tbl tbody tr.ws-recv  td.col-method{ color: var(--ws-recv); }
/* Mini body preview tint */
.tbl tbody tr.ws-send  pre.code.mini{ border-left:4px solid var(--ws-send); }
.tbl tbody tr.ws-recv  pre.code.mini{ border-left:4px solid var(--ws-recv); }
/* Drawer tinting for WS frames */
#tab-request pre.code.ws-send,  #tab-response pre.code.ws-send{  border-left:4px solid var(--ws-send); }
#tab-request pre.code.ws-recv,  #tab-response pre.code.ws-recv{  border-left:4px solid var(--ws-recv); }
#tab-request pre.code.ws-ping,  #tab-response pre.code.ws-ping{  border-left:4px solid var(--ws-ping); }
#tab-request pre.code.ws-pong,  #tab-response pre.code.ws-pong{  border-left:4px solid var(--ws-pong); }
#tab-request pre.code.ws-close, #tab-response pre.code.ws-close{ border-left:4px solid var(--ws-close); }
/* WS icon colors */
.ws-send{ color: var(--ws-send); }
.ws-recv{ color: var(--ws-recv); }

/* Fallback HTTP method palette (overridden per scheme below) */
:root{
  --m-get:#3b82f6;   /* blue  */
  --m-post:#22c55e;  /* green */
  --m-put:#f59e0b;   /* amber */
  --m-patch:#a855f7; /* violet*/
  --m-delete:#ef4444;/* red   */
  --m-ws:#06b6d4;    /* cyan  */
}
/* === Scheme overrides for HTTP/WS palettes === */

:root[data-scheme="android"]{
  /* Android Studio style */
  --m-get:#3b82f6; --m-post:#22c55e; --m-put:#f59e0b; --m-patch:#a855f7; --m-delete:#ef4444; --m-ws:#06b6d4;
  --ws-send:#06b6d4; --ws-recv:#22c55e; --ws-ping:#a3e635; --ws-pong:#f59e0b; --ws-close:#ef4444;
}
:root[data-scheme="xcode"]{
  /* Xcode / Apple palette */
  --m-get:#0A84FF; --m-post:#34C759; --m-put:#FF9F0A; --m-patch:#AF52DE; --m-delete:#FF453A; --m-ws:#64D2FF;
  --ws-send:#64D2FF; --ws-recv:#30D158; --ws-ping:#A3E635; --ws-pong:#FF9F0A; --ws-close:#FF453A;
}
:root[data-scheme="vscode"]{
  /* VS Code palette */
  --m-get:#4FC1FF; --m-post:#89D185; --m-put:#CCA700; --m-patch:#C586C0; --m-delete:#F14C4C; --m-ws:#2EC8DB;
  --ws-send:#2EC8DB; --ws-recv:#89D185; --ws-ping:#A3E635; --ws-pong:#CCA700; --ws-close:#F14C4C;
}
:root[data-scheme="grafana"]{
  /* Grafana palette */
  --m-get:#60a5fa; --m-post:#22c55e; --m-put:#f59e0b; --m-patch:#d946ef; --m-delete:#ef4444; --m-ws:#06b6d4;
  --ws-send:#06b6d4; --ws-recv:#22c55e; --ws-ping:#a3e635; --ws-pong:#f59e0b; --ws-close:#ef4444;
}

/* === Scheme-driven UI theming (fonts, density, radii) === */
:root{
  /* defaults */
  --font-ui: ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial;
  --font-mono: ui-monospace, Menlo, Consolas, "Cascadia Code", monospace;
  --font-size: 14px;
  --radius: 12px;           /* component corner radius */
  --radius-lg: 16px;        /* large containers */
  --row-pad: 14px;          /* table row vertical padding */
  --chip-radius: 999px;     /* pills */
}
:root[data-scheme="android"]{
  --font-ui: Roboto, ui-sans-serif, system-ui, -apple-system, "Segoe UI", Helvetica, Arial;
  --font-mono: Roboto Mono, ui-monospace, Menlo, Consolas, monospace;
  --font-size: 14px;
  --radius: 12px; --radius-lg: 16px; --row-pad: 14px;
}
:root[data-scheme="xcode"]{
  --font-ui: -apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display", system-ui;
  --font-mono: "SF Mono", ui-monospace, Menlo, Consolas, monospace;
  --font-size: 13px;
  --radius: 10px; --radius-lg: 14px; --row-pad: 12px;
}
:root[data-scheme="vscode"]{
  --font-ui: "Segoe UI", system-ui, Roboto, Helvetica, Arial;
  --font-mono: "Cascadia Code", Consolas, ui-monospace, Menlo, monospace;
  --font-size: 13.5px;
  --radius: 8px; --radius-lg: 12px; --row-pad: 10px;
}
:root[data-scheme="grafana"]{
  --font-ui: Inter, ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica, Arial;
  --font-mono: "JetBrains Mono", ui-monospace, Menlo, Consolas, monospace;
  --font-size: 14px;
  --radius: 6px; --radius-lg: 10px; --row-pad: 12px;
}

/* === THEME-DRIVEN COLOR OVERRIDES (Light/Dark) ===
   These override scheme colors so hues follow theme. */
:root[data-theme="light"]{
  /* HTTP methods */
  --m-get: var(--md-sys-color-primary);
  --m-post: var(--md-sys-color-secondary);
  --m-put: color-mix(in srgb, var(--md-sys-color-primary) 55%, var(--md-sys-color-surface));
  --m-patch: color-mix(in srgb, var(--md-sys-color-secondary) 55%, var(--md-sys-color-surface));
  --m-delete: var(--md-sys-color-error);
  --m-ws: color-mix(in srgb, var(--md-sys-color-primary) 40%, var(--md-sys-color-secondary) 60%);
  /* WebSocket */
  --ws-send: var(--m-ws);
  --ws-recv: var(--m-post);
  --ws-ping: color-mix(in srgb, var(--md-sys-color-secondary) 65%, var(--md-sys-color-surface));
  --ws-pong: color-mix(in srgb, var(--md-sys-color-primary) 65%, var(--md-sys-color-surface));
  --ws-close: var(--md-sys-color-error);
  /* HTTP status classes */
  --st-2xx: var(--m-post);
  --st-3xx: color-mix(in srgb, var(--md-sys-color-primary) 55%, #fbbf24);
  --st-4xx: color-mix(in srgb, var(--md-sys-color-error) 85%, var(--md-sys-color-surface));
  --st-5xx: color-mix(in srgb, var(--md-sys-color-error) 95%, black);
}
:root[data-theme="dark"]{
  /* HTTP methods */
  --m-get: var(--md-sys-color-primary);
  --m-post: var(--md-sys-color-secondary);
  --m-put: color-mix(in srgb, var(--md-sys-color-primary) 65%, var(--md-sys-color-surface));
  --m-patch: color-mix(in srgb, var(--md-sys-color-secondary) 65%, var(--md-sys-color-surface));
  --m-delete: var(--md-sys-color-error);
  --m-ws: color-mix(in srgb, var(--md-sys-color-primary) 50%, var(--md-sys-color-secondary) 50%);
  /* WebSocket */
  --ws-send: var(--m-ws);
  --ws-recv: var(--m-post);
  --ws-ping: color-mix(in srgb, var(--md-sys-color-secondary) 75%, var(--md-sys-color-surface));
  --ws-pong: color-mix(in srgb, var(--md-sys-color-primary) 75%, var(--md-sys-color-surface));
  --ws-close: var(--md-sys-color-error);
  /* HTTP status classes */
  --st-2xx: var(--m-post);
  --st-3xx: color-mix(in srgb, var(--md-sys-color-primary) 70%, #f59e0b);
  --st-4xx: color-mix(in srgb, var(--md-sys-color-error) 85%, var(--md-sys-color-surface));
  --st-5xx: color-mix(in srgb, var(--md-sys-color-error) 92%, black);
}
/* Method tints in table */
.tbl tbody tr .col-method.method-GET   { color: var(--m-get); }
.tbl tbody tr .col-method.method-POST  { color: var(--m-post); }
.tbl tbody tr .col-method.method-PUT   { color: var(--m-put); }
.tbl tbody tr .col-method.method-PATCH { color: var(--m-patch); }
.tbl tbody tr .col-method.method-DELETE{ color: var(--m-delete); }
.tbl tbody tr .col-method.method-WS    { color: var(--m-ws); }
/* URL primary line inherits method color slightly for quick scan */
.tbl tbody tr .col-url .url.method-GET   { color: color-mix(in srgb, var(--m-get) 85%, currentColor); }
.tbl tbody tr .col-url .url.method-POST  { color: color-mix(in srgb, var(--m-post) 85%, currentColor); }
.tbl tbody tr .col-url .url.method-PUT   { color: color-mix(in srgb, var(--m-put) 85%, currentColor); }
.tbl tbody tr .col-url .url.method-PATCH { color: color-mix(in srgb, var(--m-patch) 85%, currentColor); }
.tbl tbody tr .col-url .url.method-DELETE{ color: color-mix(in srgb, var(--m-delete) 85%, currentColor); }
.tbl tbody tr .col-url .url.method-WS    { color: color-mix(in srgb, var(--m-ws) 85%, currentColor); }
/* Drawer: method/status colored borders for code blocks */
#tab-request pre.code.method-GET,   #tab-response pre.code.method-GET   { border-left:4px solid var(--m-get); }
#tab-request pre.code.method-POST,  #tab-response pre.code.method-POST  { border-left:4px solid var(--m-post); }
#tab-request pre.code.method-PUT,   #tab-response pre.code.method-PUT   { border-left:4px solid var(--m-put); }
#tab-request pre.code.method-PATCH, #tab-response pre.code.method-PATCH { border-left:4px solid var(--m-patch); }
#tab-request pre.code.method-DELETE,#tab-response pre.code.method-DELETE{ border-left:4px solid var(--m-delete); }
#tab-request pre.code.method-WS,    #tab-response pre.code.method-WS    { border-left:4px solid var(--m-ws); }
/* Drawer: headers highlighted with method hue */
#tab-headers .code.headers.method-GET   .hk{ color: var(--m-get); }
#tab-headers .code.headers.method-POST  .hk{ color: var(--m-post); }
#tab-headers .code.headers.method-PUT   .hk{ color: var(--m-put); }
#tab-headers .code.headers.method-PATCH .hk{ color: var(--m-patch); }
#tab-headers .code.headers.method-DELETE .hk{ color: var(--m-delete); }
#tab-headers .code.headers.method-WS    .hk{ color: var(--m-ws); }

.kind-HTTP{color:#8ab4ff}.kind-WEBSOCKET{color:#7af59b}.kind-LOG{color:#eab308}
.status-2xx{color:#22c55e}.status-3xx{color:#fbbf24}.status-4xx{color:#fca5a5}.status-5xx{color:#fb7185}


:root{
  /* default scheme = android */
  --lv-v:#9E9E9E; /* VERBOSE */
  --lv-d:#2196F3; /* DEBUG   */
  --lv-i:#4CAF50; /* INFO    */
  --lv-w:#FFC107; /* WARN    */
  --lv-e:#F44336; /* ERROR   */
  --lv-a:#9C27B0; /* ASSERT  */
}
:root[data-scheme="android"]{ /* Android Studio */
  --lv-v:#9E9E9E; --lv-d:#2196F3; --lv-i:#4CAF50; --lv-w:#FFC107; --lv-e:#F44336; --lv-a:#9C27B0;
}
:root[data-scheme="xcode"]{ /* Xcode inspired */
  --lv-v:#8E8E93; --lv-d:#0A84FF; --lv-i:#34C759; --lv-w:#FF9F0A; --lv-e:#FF453A; --lv-a:#BF5AF2;
}
:root[data-scheme="vscode"]{ /* VS Code */
  --lv-v:#808080; --lv-d:#4FC1FF; --lv-i:#89D185; --lv-w:#CCA700; --lv-e:#F14C4C; --lv-a:#C586C0;
}
:root[data-scheme="grafana"]{ /* Grafana */
  --lv-v:#6b7280; --lv-d:#60a5fa; --lv-i:#22c55e; --lv-w:#f59e0b; --lv-e:#ef4444; --lv-a:#d946ef;
}
/* Text color for the Kind column when row has a level */
.tbl tbody tr.level-VERBOSE .col-kind{ color: var(--lv-v) }
.tbl tbody tr.level-DEBUG   .col-kind{ color: var(--lv-d) }
.tbl tbody tr.level-INFO    .col-kind{ color: var(--lv-i) }
.tbl tbody tr.level-WARN    .col-kind{ color: var(--lv-w) }
.tbl tbody tr.level-ERROR   .col-kind{ color: var(--lv-e) }
.tbl tbody tr.level-ASSERT  .col-kind{ color: var(--lv-a) }
/* Left accent bar tint using current scheme vars */
.tbl tbody tr.level-VERBOSE{ box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-v) 55%, transparent) }
.tbl tbody tr.level-DEBUG  { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-d) 55%, transparent) }
.tbl tbody tr.level-INFO   { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-i) 55%, transparent) }
.tbl tbody tr.level-WARN   { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-w) 55%, transparent) }
.tbl tbody tr.level-ERROR  { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-e) 55%, transparent) }
.tbl tbody tr.level-ASSERT { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-a) 55%, transparent) }
/* Preserve accent on hover */
.tbl tbody tr.level-VERBOSE:hover{ box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-v) 70%, transparent) }
.tbl tbody tr.level-DEBUG:hover  { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-d) 70%, transparent) }
.tbl tbody tr.level-INFO:hover   { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-i) 70%, transparent) }
.tbl tbody tr.level-WARN:hover   { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-w) 70%, transparent) }
.tbl tbody tr.level-ERROR:hover  { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-e) 70%, transparent) }
.tbl tbody tr.level-ASSERT:hover { box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-a) 70%, transparent) }
/* ===== Color URL/Summary & Time columns ===== */
/* Color by LOG level (for logger rows) */
.tbl tbody tr.level-VERBOSE .col-time,
.tbl tbody tr.level-VERBOSE .col-url { color: var(--lv-v); }
.tbl tbody tr.level-DEBUG   .col-time,
.tbl tbody tr.level-DEBUG   .col-url { color: var(--lv-d); }
.tbl tbody tr.level-INFO    .col-time,
.tbl tbody tr.level-INFO    .col-url { color: var(--lv-i); }
.tbl tbody tr.level-WARN    .col-time,
.tbl tbody tr.level-WARN    .col-url { color: var(--lv-w); }
.tbl tbody tr.level-ERROR   .col-time,
.tbl tbody tr.level-ERROR   .col-url { color: var(--lv-e); }
.tbl tbody tr.level-ASSERT  .col-time,
.tbl tbody tr.level-ASSERT  .col-url { color: var(--lv-a); }

/* Color by HTTP status class (for network rows) */
.tbl tbody tr.status-2xx .col-time, .tbl tbody tr.status-2xx .col-url .url { color: var(--st-2xx); }
.tbl tbody tr.status-3xx .col-time, .tbl tbody tr.status-3xx .col-url .url { color: var(--st-3xx); }
.tbl tbody tr.status-4xx .col-time, .tbl tbody tr.status-4xx .col-url .url { color: var(--st-4xx); }
.tbl tbody tr.status-5xx .col-time, .tbl tbody tr.status-5xx .col-url .url { color: var(--st-5xx); }

/* ===== Make all table column values colorful by row context ===== */
/* Logger rows: color all cells by level */
.tbl tbody tr.level-VERBOSE td:not(.col-actions){ color: var(--lv-v); }
.tbl tbody tr.level-DEBUG   td:not(.col-actions){ color: var(--lv-d); }
.tbl tbody tr.level-INFO    td:not(.col-actions){ color: var(--lv-i); }
.tbl tbody tr.level-WARN    td:not(.col-actions){ color: var(--lv-w); }
.tbl tbody tr.level-ERROR   td:not(.col-actions){ color: var(--lv-e); }
.tbl tbody tr.level-ASSERT  td:not(.col-actions){ color: var(--lv-a); }

/* HTTP rows: color all cells by status class */
:root{ --st-2xx:#22c55e; --st-3xx:#fbbf24; --st-4xx:#fca5a5; --st-5xx:#fb7185; }
.tbl tbody tr.status-2xx td:not(.col-actions){ color: var(--st-2xx); }
.tbl tbody tr.status-3xx td:not(.col-actions){ color: var(--st-3xx); }
.tbl tbody tr.status-4xx td:not(.col-actions){ color: var(--st-4xx); }
.tbl tbody tr.status-5xx td:not(.col-actions){ color: var(--st-5xx); }

/* Keep chips, icons and code readable (don’t inherit the tint) */
.tbl tbody tr td .muted,
.tbl tbody tr td .badge,
.tbl tbody tr td .material-symbols-outlined,
.tbl tbody tr td pre.code{ color: inherit; opacity: 0.95; }

/* Drawer styles (hidden by default) */
.drawer{
  position:relative;
  border:1px solid var(--line);
  border-radius:16px;
  height:calc(100vh - 180px);
  overflow:auto;
  flex:0 0 0;
  width:0;
  opacity:0;
  pointer-events:none;
  transition:flex-basis .2s ease,width .2s ease,opacity .2s ease,border-color .2s ease;
  background:var(--md-sys-color-surface);
  box-shadow:var(--elev-2);
}
body.drawer-open .drawer{ flex-basis:var(--drawer-w); width:var(--drawer-w); opacity:1; pointer-events:auto }

/* Drawer resizer */
.d-resize{ position:absolute; left:-6px; top:0; bottom:0; width:12px; cursor:col-resize; z-index:2; }
.d-resize::after{ content:""; position:absolute; inset:0; background:transparent; }
.d-resize:hover::after{ background:color-mix(in srgb, var(--md-sys-color-primary) 12%, transparent); }
body.resizing{ cursor:col-resize !important; }
body.resizing *{ user-select:none !important; }
.d-head{display:flex;justify-content:space-between;align-items:center;padding:16px 16px;border-bottom:1px solid var(--line)}
.d-title{font-weight:700}.d-sub{color:var(--muted);font-size:12px;margin-top:4px}
.tabs{display:flex;gap:8px;padding:10px 12px;border-bottom:1px solid var(--line)}
.tab{background:transparent;color:var(--text);border:1px solid var(--line);border-radius:999px;padding:6px 12px}
.tab.active{background:var(--surface)}
.panes{padding:12px}
.pane{display:none}
.pane.active{display:block}
.kv{display:grid;grid-template-columns:160px 1fr;gap:12px 16px}
.kv dt{color:var(--muted)} .kv dd{margin:0}
.kv .full{grid-column:1 / -1}

.cols{display:grid;grid-template-columns:1fr 1fr;gap:12px}

/* Colorful drawer content */
#drawer .d-title{ color: var(--md-sys-color-primary); }
#drawer .d-sub{ color: var(--md-sys-color-secondary); }
#drawer .kv dt{ color: var(--md-sys-color-on-surface-variant); font-weight:600; }
#drawer .kv dd{ color: var(--md-sys-color-on-surface); }
#drawer .badge{ background: var(--md-sys-color-primary-container); color: var(--md-sys-color-on-primary-container); border:none; }
#drawer pre.code{ background: var(--md-sys-color-surface-container-high); color: var(--md-sys-color-on-surface); }

/* Colorful panes */
.panes h4{ color: var(--md-sys-color-primary); margin: 6px 0 8px; }
.panes h5{ color: var(--md-sys-color-secondary); margin: 4px 0 6px; }
#tab-request pre.code,
#tab-response pre.code,
#tab-headers pre.code{ background: var(--md-sys-color-surface-container-high); border-color: var(--md-sys-color-outline-variant); }

/* Extra color accents inside panes */
.panes a{ color: var(--md-sys-color-primary); text-decoration: none; }
.panes a:hover{ text-decoration: underline; }
.panes .badge{ background: var(--md-sys-color-primary-container); color: var(--md-sys-color-on-primary-container); border: none; }
.panes pre.code{ border-left: 3px solid var(--md-sys-color-primary); }
.panes .muted{ color: var(--md-sys-color-on-surface-variant); }
.panes .callout{ border:1px solid var(--md-sys-color-outline-variant); background: var(--md-sys-color-surface-container); border-radius: 12px; padding: 10px 12px; }

/* Headers highlighting inside code blocks */
.code.headers { background: var(--md-sys-color-surface-container-high); }
.code.headers .hk{ color: var(--md-sys-color-primary); font-weight:600; }
.code.headers .hv{ color: var(--md-sys-color-on-surface); }

/* Colorful JSON syntax highlighting (applies in drawer + table) */
.json .k { color:#d19a66; }   /* keys - orange */
.json .s { color:#98c379; }   /* strings - green */
.json .n { color:#61afef; }   /* numbers - blue */
.json .b { color:#c678dd; }   /* booleans - purple */
.json .null { color:#e06c75; } /* null - red */

/* Colorful summary block container */
#drawer .sum {
  padding: 8px;
}
#drawer .sum pre.code {
  background: transparent;
  font-family: ui-monospace, Menlo, monospace;
  font-size: 13px;
  line-height: 1.4;
  color: var(--md-sys-color-on-surface);
}

/* Code blocks */
.code{background:var(--codebg);color:var(--code);border:1px solid var(--line);border-radius:12px;padding:12px;overflow:auto;max-height:22vh;white-space:pre-wrap;word-break:break-word}
#ov-summary{
  white-space:pre-wrap;
  word-break:break-word;
  width:100%;
  max-height:50vh;
  overflow:auto;
  padding:10px 12px;
  border:1px solid var(--line);
  border-radius:12px;
  background:var(--md-sys-color-surface-container-high);
}
/* JSON syntax colors already provided via .json .k/.s/.n/.b/.null */

/* ===== Thematic colorization for <pre> blocks ===== */
pre {
  color: var(--md-sys-color-on-surface);
}
/* HTTP method context for pre blocks */
pre.method-GET    { color: var(--m-get); }
pre.method-POST   { color: var(--m-post); }
pre.method-PUT    { color: var(--m-put); }
pre.method-PATCH  { color: var(--m-patch); }
pre.method-DELETE { color: var(--m-delete); }
pre.method-WS     { color: var(--m-ws); }
/* Log level context for pre blocks */
pre.level-VERBOSE { color: var(--lv-v); }
pre.level-DEBUG   { color: var(--lv-d); }
pre.level-INFO    { color: var(--lv-i); }
pre.level-WARN    { color: var(--lv-w); }
pre.level-ERROR   { color: var(--lv-e); }
pre.level-ASSERT  { color: var(--lv-a); }
/* Pre blocks with .json class still get .json .k/.s/.n/.b/.null coloring for inner spans */

/* Contextual tint for Summary (HTTP method) */
#ov-summary.method-GET{ border-left:4px solid var(--m-get); }
#ov-summary.method-POST{ border-left:4px solid var(--m-post); }
#ov-summary.method-PUT{ border-left:4px solid var(--m-put); }
#ov-summary.method-PATCH{ border-left:4px solid var(--m-patch); }
#ov-summary.method-DELETE{ border-left:4px solid var(--m-delete); }
#ov-summary.method-WS{ border-left:4px solid var(--m-ws); }
/* WebSocket direction/opcode tints */
#ov-summary.ws-send{ border-left:4px solid var(--ws-send); }
#ov-summary.ws-recv{ border-left:4px solid var(--ws-recv); }
#ov-summary.ws-ping{ border-left:4px solid var(--ws-ping); }
#ov-summary.ws-pong{ border-left:4px solid var(--ws-pong); }
#ov-summary.ws-close{ border-left:4px solid var(--ws-close); }
/* Logger level tints */
#ov-summary.level-VERBOSE{ box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-v) 55%, transparent); }
#ov-summary.level-DEBUG{   box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-d) 55%, transparent); }
#ov-summary.level-INFO{    box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-i) 55%, transparent); }
#ov-summary.level-WARN{    box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-w) 55%, transparent); }
#ov-summary.level-ERROR{   box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-e) 55%, transparent); }
#ov-summary.level-ASSERT{  box-shadow: inset 4px 0 0 color-mix(in srgb, var(--lv-a) 55%, transparent); }
/* Summary text colorization by context */
#ov-summary.method-GET    { color: var(--m-get); }
#ov-summary.method-POST   { color: var(--m-post); }
#ov-summary.method-PUT    { color: var(--m-put); }
#ov-summary.method-PATCH  { color: var(--m-patch); }
#ov-summary.method-DELETE { color: var(--m-delete); }
#ov-summary.method-WS     { color: var(--m-ws); }
#ov-summary.ws-send       { color: var(--ws-send); }
#ov-summary.ws-recv       { color: var(--ws-recv); }
#ov-summary.ws-ping       { color: var(--ws-ping); }
#ov-summary.ws-pong       { color: var(--ws-pong); }
#ov-summary.ws-close      { color: var(--ws-close); }
#ov-summary.level-VERBOSE { color: var(--lv-v); }
#ov-summary.level-DEBUG   { color: var(--lv-d); }
#ov-summary.level-INFO    { color: var(--lv-i); }
#ov-summary.level-WARN    { color: var(--lv-w); }
#ov-summary.level-ERROR   { color: var(--lv-e); }
#ov-summary.level-ASSERT  { color: var(--lv-a); }
/* When JSON pretty-print is active, inner span highlights take precedence */
#ov-summary.json { color: inherit; }
.curl{display:flex;gap:8px;align-items:flex-start;width:100%}
.curl .code{flex:1;min-height:160px}
#ov-curl{white-space:pre-wrap;word-break:break-all;overflow:auto;max-height:70vh;width:100%}

/* WebSocket direction glyphs */
.ws-ico{margin-left:6px;font:12px ui-monospace,Menlo,monospace;vertical-align:middle}
.ws-send{ color: var(--ws-send); }
.ws-recv{ color: var(--ws-recv); }

/* Logcat line styling */
.lc{font:12px ui-monospace,Menlo,monospace; white-space:pre-wrap; word-break:break-word}
.lc-ts{color:var(--muted)}
.lc-prio{font-weight:700}
.lc-tag{color:#00bcd4}

/* Modes */
body.mode-network .col-tag{display:none}
body.mode-log .col-method,body.mode-log .col-status,body.mode-log .col-actions{display:none}
/* In log mode, hide network URL line but keep logger message */
body.mode-log tr:not(.level-VERBOSE):not(.level-DEBUG):not(.level-INFO):not(.level-WARN):not(.level-ERROR):not(.level-ASSERT) .col-url .url{display:none}
/* Ensure logger message (lc) remains visible */
body.mode-log .col-url .lc{display:block}

/* Helpers */
.muted{color:var(--muted)} .badge{border:1px solid var(--line);border-radius:6px;padding:2px 6px;background:transparent;font:12px ui-monospace,Menlo,monospace}
.hidden{display:none !important}


/* Material Symbols font setup */
.material-symbols-outlined{font-family:'Material Symbols Outlined';font-weight:normal;font-style:normal;font-size:20px;line-height:1;letter-spacing:normal;text-transform:none;display:inline-block;white-space:nowrap;word-wrap:normal;direction:ltr;-webkit-font-feature-settings:'liga';-webkit-font-smoothing:antialiased;font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24}

/* Align Settings button icon + text nicely */
#settingsBtn{
  display:inline-flex;
  align-items:center;
  gap:8px;
  line-height:1;
}

/* Keep icon centered to the text baseline */
#settingsBtn .material-symbols-outlined{
  display:inline-block;
  line-height:1;
  font-size:20px;       /* match table icon size */
  transform: translateY(1px); /* tiny optical nudge */
}

/* Make all .btn & .icon controls align contents consistently */
.btn,
.icon{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  gap:6px;
  line-height:1;
}

/* Theme toggle icon visibility (default: hide both, then show correct for theme) */
#themeToggle .ico-sun,
#themeToggle .ico-moon { display:none }
:root[data-theme="light"] #themeToggle .ico-sun{ display:block }
:root[data-theme="light"] #themeToggle .ico-moon{ display:none }
:root[data-theme="dark"] #themeToggle .ico-sun{ display:none }
:root[data-theme="dark"] #themeToggle .ico-moon{ display:block }

/* === Apply scheme UI variables globally === */
body.ui{ font-size: var(--font-size); font-family: var(--font-ui); }
.code, pre, kbd, samp, .lc{ font-family: var(--font-mono); }

/* Corners follow scheme */
.input, .select, .btn, .icon, .panel, .popover, .tbl thead th, .drawer, .badge, .chip{  }
.drawer{ border-radius: var(--radius-lg); }

/* Density: table paddings by scheme */
.tbl thead th{ padding: calc(var(--row-pad) - 4px) 8px; }
.tbl tbody td{ padding: calc(var(--row-pad) - 6px) 6px; }

.btn{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  gap:6px;
  padding: calc(var(--row-pad) - 6px) 16px;
  line-height:1;
}
.btn.xs{ padding: calc(var(--row-pad) - 8px) 10px; }

/* Chips reflect scheme corners */
.chip{ border-radius: var(--chip-radius); }

/* ===== Panels (Settings & Filters) — unified visual ===== */
#settingsPanel, #filtersPanel{
  position: fixed;
  z-index: 70;
  right: 12px;
  top: 64px; /* default; JS may reposition under each button */
  width: min(520px, calc(100vw - 24px));
  background: var(--md-sys-color-surface);
  color: var(--md-sys-color-on-surface);
  border: 1px solid var(--line);
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0,0,0,.35), 0 2px 8px rgba(0,0,0,.2);
  overflow: hidden;
  backdrop-filter: saturate(120%) blur(6px);
}
#settingsPanel.hidden, #filtersPanel.hidden{ display:none !important; }

/* Heads */
#settingsPanel .sp-head, #filtersPanel .fp-head{
  display:flex; align-items:center; gap:10px;
  padding:12px 14px; border-bottom:1px solid var(--line);
  background: color-mix(in srgb, var(--md-sys-color-surface) 85%, transparent);
  justify-content: space-between;
}
#settingsPanel .sp-head .sp-icon, #filtersPanel .fp-head .fp-icon{
  width:28px; height:28px; border-radius:8px;
  display:inline-flex; align-items:center; justify-content:center;
  background: var(--md-sys-color-primary-container);
  color: var(--md-sys-color-on-primary-container);
  flex:0 0 auto;
}
#settingsPanel .sp-head .sp-title, #filtersPanel .fp-head .fp-title{
  font-weight:700; font-size:14px; letter-spacing:.2px;
}
/* Close button pinned to the far right */
#settingsPanel .sp-head #settingsClose{ margin-left:auto; }
#filtersPanel .fp-head #filtersClose{ margin-left:auto; }

/* Bodies */
#settingsPanel .sp-body, #filtersPanel .fp-body{
  padding:12px 14px;
  display:grid; gap:14px;
}
#settingsPanel .sp-section, #filtersPanel .fp-section{
  border:1px solid var(--line);
  border-radius:12px;
  background: var(--md-sys-color-surface-container);
  padding:12px;
}
#settingsPanel .sp-section h4, #filtersPanel .fp-section h4{
  margin:0 0 8px; font-size:13px; color: var(--md-sys-color-primary);
}

/* Columns section as responsive grid */
#settingsPanel .sp-section.cols-grid, #filtersPanel .fp-section.cols-grid{
  display:grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap:10px 12px;
  align-items:center;
}
#settingsPanel .sp-section.cols-grid h4, #filtersPanel .fp-section.cols-grid h4{
  grid-column: 1 / -1;
  margin-bottom: 6px;
}
#settingsPanel .sp-section.cols-grid .fp-checkbox,
#filtersPanel .fp-section.cols-grid .fp-checkbox{
  display:flex;
  align-items:center;
  gap:8px;
  padding:8px 10px;
  border:1px solid var(--line);
  border-radius:10px;
  background: var(--md-sys-color-surface);
  cursor:pointer;
  user-select:none;
  transition: background .15s ease, border-color .15s ease, box-shadow .15s ease;
}
#settingsPanel .sp-section.cols-grid .fp-checkbox:hover,
#filtersPanel .fp-section.cols-grid .fp-checkbox:hover{
  border-color: color-mix(in srgb, var(--md-sys-color-primary) 35%, var(--line));
  box-shadow: 0 1px 6px rgba(0,0,0,.15);
}
#settingsPanel .sp-section.cols-grid .fp-checkbox input,
#filtersPanel .fp-section.cols-grid .fp-checkbox input{ margin:0; }
#settingsPanel .sp-section.cols-grid .fp-checkbox .lbl,
#filtersPanel .fp-section.cols-grid .fp-checkbox .lbl{ line-height:1.2; }

/* Row helper (label + control) */
#settingsPanel .sp-row, #filtersPanel .fp-row{
  display:grid; grid-template-columns: 1fr auto; align-items:center;
  gap:8px; padding:8px 0;
}
#settingsPanel .sp-row + .sp-row{ border-top:1px dashed var(--line); }
#filtersPanel  .fp-row + .fp-row{ border-top:1px dashed var(--line); }

/* Segmented controls */
#settingsPanel .seg, #filtersPanel .seg{
  display:inline-flex; border:1px solid var(--line); border-radius:10px; overflow:hidden;
}
#settingsPanel .seg button, #filtersPanel .seg button{
  background:transparent; border:0; padding:8px 10px; font-size:12px; cursor:pointer;
  color: var(--md-sys-color-on-surface);
}
#settingsPanel .seg button[aria-pressed="true"],
#filtersPanel .seg button[aria-pressed="true"]{
  background: var(--md-sys-color-primary-container);
  color: var(--md-sys-color-on-primary-container);
}
#settingsPanel .seg button + button, #filtersPanel .seg button + button{ border-left:1px solid var(--line); }

/* Switches */
#settingsPanel .switch, #filtersPanel .switch{
  --sw-w:46px; --sw-h:26px;
  position:relative; width:var(--sw-w); height:var(--sw-h);
}
#settingsPanel .switch input, #filtersPanel .switch input{ position:absolute; inset:0; opacity:0; }
#settingsPanel .switch .track, #filtersPanel .switch .track{
  position:absolute; inset:0; border-radius:999px;
  background: color-mix(in srgb, var(--md-sys-color-outline-variant) 60%, transparent);
  transition: background .15s ease;
}
#settingsPanel .switch .thumb, #filtersPanel .switch .thumb{
  position:absolute; top:3px; left:3px; width:20px; height:20px; border-radius:50%;
  background: var(--md-sys-color-surface);
  box-shadow: 0 1px 2px rgba(0,0,0,.35);
  transition: transform .15s ease;
}
#settingsPanel .switch input:checked + .track, #filtersPanel .switch input:checked + .track{ background: var(--md-sys-color-primary); }
#settingsPanel .switch input:checked + .track + .thumb,
#filtersPanel .switch input:checked + .track + .thumb{ transform: translateX(20px); }

/* Footers */
#settingsPanel .sp-foot, #filtersPanel .fp-foot{
  display:flex; justify-content:space-between; align-items:center;
  gap:10px; padding:10px 14px; border-top:1px solid var(--line);
  background: color-mix(in srgb, var(--md-sys-color-surface) 90%, transparent);
}
#settingsPanel .sp-foot .hint, #filtersPanel .fp-foot .hint{
  color: var(--muted); font-size:12px;
}
#settingsPanel .sp-foot .btn-reset, #filtersPanel .fp-foot .btn-reset{
  background: transparent; color: var(--md-sys-color-primary);
  border:1px dashed var(--md-sys-color-primary);
  padding:6px 10px; border-radius:8px; cursor:pointer;
}
#settingsPanel .sp-foot .btn-close, #filtersPanel .fp-foot .btn-close{
  background: var(--md-sys-color-primary);
  color: var(--md-sys-color-on-primary);
  border:0; padding:8px 12px; border-radius:10px; cursor:pointer;
}

/* Responsive */
@media (max-width:1024px){ .tbl thead th,.tbl tbody td{padding:10px} .col-actions{width:140px} }
@media (max-width:900px){ #logtbl thead .col-id,#logtbl tbody .col-id{display:none} #logtbl thead .col-kind,#logtbl tbody .col-kind{display:none} .col-time{width:96px}.col-method{width:80px}.col-status{width:80px}.col-actions{width:120px} .panel{max-height:calc(100vh - 220px)} .kv{grid-template-columns:140px 1fr} }
@media (max-width:700px){
  .shell{ flex-direction:column; }
  /* Hide less critical columns by default on narrow viewports */
  #logtbl thead .col-method, #logtbl tbody .col-method{ display:none }
  #logtbl thead .col-status, #logtbl tbody .col-status{ display:none }
  /* Make URL/Summary breathe */
  .col-url{ width:auto }
  #settingsPanel, #filtersPanel{
    right: 12px; left: 12px; width:auto; top: 88px;
  }
  #settingsPanel .sp-section.cols-grid,
  #filtersPanel  .fp-section.cols-grid{
    grid-template-columns: repeat(2, 1fr);
  }
}
@media (max-width:768px){
  .tbl{ font-size:13px }
  /* Stack header on mobile: show .brand above .bar */
  .hdr{ padding:10px; flex-direction:column; align-items:stretch; gap:10px }
  .brand{ width:100%; display:flex; align-items:center; justify-content:flex-start; gap:12px }
  .brand .titles{ display:flex; flex-direction:column; }

  /* On narrow screens keep nav items compact: let the search field grow, but don't force every item to full width */
  .bar{ align-items:center; width:100% }
  .bar > .field { flex: 1 1 auto; min-width: 120px; }
  .bar > *:not(.field){ flex: 0 0 auto; }
  /* Make buttons rectangular (smaller radius) and slightly tighter padding for mobile */
  .btn, .icon, .tab { border-radius:8px; }
  .btn{ padding:8px 12px; }
  .field{ width:auto }
  .input,.select{width:100%}
  .stats{padding:8px 10px}
  .shell{padding:8px}
  .kv{grid-template-columns:1fr}
  .kv .full{grid-column:1 / -1}
  .cols{grid-template-columns:1fr}
  #ov-curl{max-height:50vh}
  #ov-summary{max-height:40vh}
}
@media (max-width:600px){
  /* hide the table header to free vertical space */
  #logtbl thead{ display:none !important; }
  /* make table elements behave like blocks */
  #logtbl, #logtbl tbody, #logtbl tr, #logtbl td{ display:block; width:100%; }
  /* card-like rows */
  #logtbl tr{ margin:10px 0; padding:10px; border-radius:12px; border:1px solid var(--line); background:var(--md-sys-color-surface-container-high); box-shadow:var(--elev-1); }
  /* align cell label + value side-by-side */
  #logtbl td{ padding:8px 10px; display:flex; align-items:flex-start; justify-content:space-between; gap:8px; }
  /* label before each cell (uses data-label populated by JS) */
  #logtbl td::before{
    content: attr(data-label);
    flex: 0 0 110px;
    color:var(--muted);
    font-weight:600;
    white-space:nowrap;
    overflow:hidden;
    text-overflow:ellipsis;
    margin-right:8px;
  }
  /* Allow the URL / summary to wrap and take remaining width */
  #logtbl td.col-url{ flex-direction:column; align-items:flex-start; }
  #logtbl td.col-url::before{ flex:0 0 auto; margin-bottom:6px; }
  #logtbl td .url, #logtbl td .muted, #logtbl td .lc{ max-width: calc(100% - 120px); overflow-wrap:anywhere; }
  /* Actions should be visible and aligned right in a compact row */
  #logtbl td.col-actions{ display:flex; gap:8px; justify-content:flex-end; }
  /* Keep panel overflowing nicely on small screens */
  .panel{ max-height:none; }
  /* Make popovers/panels easier to interact with on phones */
  .fp, .popover, #settingsPanel, #filtersPanel{ left:12px; right:12px; width:auto; }

  /* Respect user column visibility toggles & view modes on mobile */
  body.hide-col-id      #logtbl td.col-id,
  body.hide-col-time    #logtbl td.col-time,
  body.hide-col-kind    #logtbl td.col-kind,
  body.hide-col-tag     #logtbl td.col-tag,
  body.hide-col-method  #logtbl td.col-method,
  body.hide-col-status  #logtbl td.col-status,
  body.hide-col-url     #logtbl td.col-url,
  body.hide-col-actions #logtbl td.col-actions { display: none !important; }

  /* Respect mode toggles */
  body.mode-network #logtbl td.col-tag { display: none !important; }
  body.mode-log #logtbl td.col-method,
  body.mode-log #logtbl td.col-status,
  body.mode-log #logtbl td.col-actions { display: none !important; }
}
"""#
}

