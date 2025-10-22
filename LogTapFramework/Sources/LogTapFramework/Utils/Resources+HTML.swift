// filepath: /Users/husseinhj/Documents/LogTapIOS/LogTapFramework/Sources/LogTapFramework/Utils/Resources+HTML.swift
// Auto-extracted HTML resource from Resources.swift
// Created to split large resource into a dedicated file for easier debugging.

import Foundation

enum ResourceHTML {
  static let indexHtml: String = #"""
  <!doctype html>
  <html>
    <head>
      <meta charset="utf-8"/>
      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <title>LogTap</title>
      <link rel="stylesheet" href="/app.css"/>
      <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght@400&display=swap" rel="stylesheet"/>
    </head>
    <body class="ui">
      <!-- Header -->
      <header class="hdr blur elev">
        <!-- Replaced static brand with dynamic DeviceAppInfo -->
        <div class="brand" id="deviceBrand">
          <div class="app-icon" id="appIcon" aria-hidden="true" title="App icon"></div>
          <div class="titles">
            <div class="title" id="appName">Loading…</div>
            <div class="sub" id="appMeta">Fetching device info…</div>
          </div>
        </div>
        <nav class="bar">
          <div id="wsStatus" class="chip stat">● Disconnected</div>
          <div class="search field">
            <svg class="ico" viewBox="0 0 24 24"><path d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5Zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14Z"/></svg>
            <input id="search" class="input" type="search" placeholder="Search url, method, headers, body…  ⌘/Ctrl + K"/>
          </div>
          <button id="filtersBtn" class="btn ghost" title="Filters" aria-haspopup="true" aria-expanded="false">
            <span class="material-symbols-outlined" aria-hidden="true">filter_list</span>
            <span class="label">Filters</span>
            <span class="material-symbols-outlined dropdown" aria-hidden="true">arrow_drop_down</span>
          </button>
          <button id="settingsBtn" class="btn ghost" title="Settings" aria-haspopup="true" aria-expanded="false">
            <span class="material-symbols-outlined" aria-hidden="true">settings</span>
            <span class="label">Settings</span>
            <span class="material-symbols-outlined dropdown" aria-hidden="true">arrow_drop_down</span>
          </button>
          <!-- Settings popover (separate from Filters) -->
          <div id="settingsPanel" class="hidden">
            <div class="sp-head">
              <div class="sp-icon"><span class="material-symbols-outlined">tune</span></div>
              <div class="sp-title">Settings</div>
              <button id="settingsClose" class="icon" aria-label="Close"><span class="material-symbols-outlined">close</span></button>
            </div>
          
            <div class="sp-body">
              <div class="sp-section">
                <h4>Theme</h4>
                <div class="sp-row">
                  <div>Logs Style</div>
                  <select id="colorScheme" class="select">
                      <option value="android">Android Studio</option>
                      <option value="xcode">Xcode</option>
                      <option value="vscode">Visual Studio Code</option>
                      <option value="grafana">Grafana</option>
                    </select>
                </div>
              </div>
          
              <div class="sp-section">
                <h4>Behavior</h4>
                <div class="sp-row">
                  <div>Pretty JSON</div>
                  <label class="switch">
                    <input type="checkbox" id="jsonPretty">
                    <span class="track"></span><span class="thumb"></span>
                  </label>
                </div>
                <div class="sp-row">
                  <div>Auto scroll</div>
                  <label class="switch">
                    <input type="checkbox" id="autoScroll">
                    <span class="track"></span><span class="thumb"></span>
                  </label>
                </div>
              </div>
          
              <div class="sp-section">
                <h4>Columns</h4>
                <label class="fp-checkbox"><input type="checkbox" id="colId" checked/><span class="box"></span><span class="lbl">ID</span></label>
                <label class="fp-checkbox"><input type="checkbox" id="colTime" checked/><span class="box"></span><span class="lbl">Time</span></label>
                <label class="fp-checkbox"><input type="checkbox" id="colKind" checked/><span class="box"></span><span class="lbl">Kind</span></label>
                <label class="fp-checkbox"><input type="checkbox" id="colTag" checked/><span class="box"></span><span class="lbl">Tag</span></label>
                <label class="fp-checkbox"><input type="checkbox" id="colMethod" checked/><span class="box"></span><span class="lbl">Method</span></label>
                <label class="fp-checkbox"><input type="checkbox" id="colStatus" checked/><span class="box"></span><span class="lbl">Status</span></label>
                <label class="fp-checkbox"><input type="checkbox" id="colUrl" checked/><span class="box"></span><span class="lbl">URL / Summary</span></label>
                <label class="fp-checkbox"><input type="checkbox" id="colActions" checked/><span class="box"></span><span class="lbl">Actions</span></label>
              </div>
            </div>
            <div class="sp-foot">
              <span class="hint">Preferences are saved locally</span>
              <div>
                <button id="settingsReset" class="btn-reset">Reset</button>
                <button id="settingsClose2" class="btn-close">Close</button>
              </div>
            </div>
          </div>
          <div class="menu">
            <button id="exportBtn" class="icon" title="Export" aria-label="Export">
              <span class="material-symbols-outlined" aria-hidden="true">ios_share</span>
            </button>
            <div id="exportMenu" class="fp hidden popover" role="dialog" aria-modal="true" aria-labelledby="exportTitle">
              <div class="fp-head">
                <div class="fp-icon material-symbols-outlined" aria-hidden="true">ios_share</div>
                <div class="fp-title" id="exportTitle">Export</div>
                <button id="exportClose" class="icon" title="Close export" aria-label="Close export">
                  <span class="material-symbols-outlined" aria-hidden="true">close</span>
                </button>
              </div>
              <div class="fp-body">
                <div class="fp-section">
                  <button id="exportJson" class="btn block" type="button">Export JSON</button>
                  <button id="exportHtml" class="btn block" type="button">Export Report</button>
                </div>
              </div>
              <div class="fp-foot">
                <span class="hint">Export your logs in different formats</span>
              </div>
            </div>
          </div>
          <button id="clearBtn" class="icon" title="Clear all logs" aria-label="Clear all logs">
            <span class="material-symbols-outlined" aria-hidden="true">delete_sweep</span>
          </button>
            <button id="themeToggle" class="icon" title="Toggle theme" aria-label="Toggle theme">
            <span class="material-symbols-outlined ico-sun" aria-hidden="true">light_mode</span>
            <span class="material-symbols-outlined ico-moon" aria-hidden="true">dark_mode</span>
          </button>

          <!-- Filters popover (Material 3 sheet) -->
          <div id="filtersPanel" class="fp hidden" role="dialog" aria-modal="true" aria-labelledby="filtersTitle">
            <div class="fp-head">
              <div class="fp-icon material-symbols-outlined" aria-hidden="true">filter_list</div>
              <div class="fp-title" id="filtersTitle">Filters</div>
              <button id="filtersClose" class="icon" title="Close filters" aria-label="Close filters">
                <span class="material-symbols-outlined" aria-hidden="true">close</span>
              </button>
            </div>
          
            <div class="fp-body">
                <!-- Quick Filter Mode -->
                <div class="fp-section">
                  <h4>Mode</h4>
                  <div class="fp-row">
                    <label class="fp-radio">
                      <input type="radio" name="filterMode" value="" checked>
                      <span class="lbl">All (Mix)</span>
                    </label>
                    <label class="fp-radio">
                      <input type="radio" name="filterMode" value="network">
                      <span class="lbl">Network</span>
                    </label>
                    <label class="fp-radio">
                      <input type="radio" name="filterMode" value="log">
                      <span class="lbl">Log</span>
                    </label>
                  </div>
                </div>
            
              <!-- HTTP / WS -->
              <div class="fp-section">
                <h4>HTTP &amp; WebSocket</h4>
          
                <div class="fp-row">
                  <label class="lbl" for="methodFilter">Method</label>
                  <select id="methodFilter" class="select">
                    <option value="">Any</option>
                    <option value="GET">GET</option>
                    <option value="POST">POST</option>
                    <option value="PUT">PUT</option>
                    <option value="PATCH">PATCH</option>
                    <option value="DELETE">DELETE</option>
                    <option value="WS">WS</option>
                  </select>
                </div>
          
                <div class="fp-row">
                  <label class="lbl" for="statusFilter">Status class</label>
                  <select id="statusFilter" class="select">
                    <option value="">Any</option>
                    <option value="2xx">2xx (Success)</option>
                    <option value="3xx">3xx (Redirect)</option>
                    <option value="4xx">4xx (Client error)</option>
                    <option value="5xx">5xx (Server error)</option>
                  </select>
                </div>
          
                <div class="fp-row">
                  <label class="lbl" for="statusCodeFilter">Status code(s)</label>
                  <input id="statusCodeFilter" class="input" placeholder="e.g. 200,404, 500-599">
                </div>
              </div>
          
              <!-- Logger -->
              <div class="fp-section">
                <h4>Logger</h4>
                <div class="fp-row">
                  <label class="lbl" for="levelFilter">Level</label>
                  <select id="levelFilter" class="select">
                    <option value="">Any</option>
                    <option value="VERBOSE">VERBOSE</option>
                    <option value="DEBUG">DEBUG</option>
                    <option value="INFO">INFO</option>
                    <option value="WARN">WARN</option>
                    <option value="ERROR">ERROR</option>
                    <option value="ASSERT">ASSERT</option>
                  </select>
                </div>
              </div>
            </div>
          
            <div class="fp-foot">
              <span class="hint">Tip: click a stat chip to quick-filter; click it again to reset.</span>
              <div>
                <button id="filtersReset" class="btn-reset" type="button">Reset</button>
                <button id="filtersCloseBottom" class="btn-close" type="button">Close</button>
              </div>
            </div>
          </div>
        </nav>
      </header>

      <!-- Stat pills -->
      <section class="stats">
        <div class="chip" id="chipTotal">Total: 0</div>
        <div class="chip" id="chipHttp">HTTP: 0</div>
        <div class="chip" id="chipWs">WS: 0</div>
        <div class="chip" id="chipLog">LOG: 0</div>
        <div class="chip" id="chipGet">GET: 0</div>
        <div class="chip" id="chipPost">POST: 0</div>
      </section>

      <main class="shell">
        <div class="panel elev">
          <table id="logtbl" class="tbl">
            <thead>
              <tr>
                <th class="col-id">ID</th>
                <th class="col-time">Time</th>
                <th class="col-kind">Kind</th>
                <th class="col-tag">Tag</th>
                <th class="col-method">Method</th>
                <th class="col-status">Status</th>
                <th class="col-url">URL / Summary</th>
                <th class="col-actions">Actions</th>
              </tr>
            </thead>
            <tbody></tbody>
          </table>
        </div>

        <aside id="drawer" class="drawer elev">
          <div class="d-resize" id="drawerResizer" aria-hidden="true" title="Drag to resize"></div>
          <header class="d-head">
            <div>
              <div id="drawerTitle" class="d-title">Details</div>
              <div id="drawerSub" class="d-sub"></div>
            </div>
            <button id="drawerClose" class="icon" title="Close (Esc)">×</button>
          </header>
          <nav class="tabs">
            <button class="tab active" data-tab="overview" id="tabBtn-overview">Overview</button>
            <button class="tab" data-tab="request" id="tabBtn-request">Request</button>
            <button class="tab" data-tab="response" id="tabBtn-response">Response</button>
            <button class="tab" data-tab="headers" id="tabBtn-headers">Headers</button>
          </nav>
          <section class="panes">
            <div class="pane active" id="tab-overview">
              <dl class="kv">
                <div><dt>ID</dt><dd id="ov-id"></dd></div>
                <div><dt>Time</dt><dd id="ov-time"></dd></div>
                <div><dt>Kind</dt><dd id="ov-kind"></dd></div>
                <div><dt>Direction</dt><dd id="ov-dir"></dd></div>
                <div id="row-method"><dt>Method</dt><dd id="ov-method"></dd></div>
                <div id="row-status"><dt>Status</dt><dd id="ov-status"></dd></div>
                <div id="row-url"><dt>URL</dt><dd id="ov-url"></dd></div>
                <div id="row-level" class="hidden"><dt>Level</dt><dd id="ov-level"></dd></div>
                <div id="row-tag" class="hidden"><dt>Tag</dt><dd id="ov-tag"></dd></div>
                <div class="full"><dt>Summary</dt><dd><div class="sum"><button id="ov-summary-copy" class="icon" title="Copy Summary" aria-label="Copy Summary"><span class="material-symbols-outlined" aria-hidden="true">content_copy</span></button><pre class="code" id="ov-summary"></pre></div></dd></div>
                <div id="row-took"><dt>Took</dt><dd id="ov-took"></dd></div>
                <div><dt>Thread</dt><dd id="ov-thread"></dd></div>
                <div class="full" id="row-curl"><dt>cURL</dt><dd><div class="curl"><button id="ov-curl-copy" class="icon" title="Copy cURL" aria-label="Copy cURL"><span class="material-symbols-outlined" aria-hidden="true">content_copy</span></button><pre class="code" id="ov-curl"></pre></div></dd></div>
              </dl>
            </div>
            <div class="pane" id="tab-request">
              <h4>Request Body</h4>
              <pre class="code json" id="req-body"></pre>
            </div>
            <div class="pane" id="tab-response">
              <h4>Response Body</h4>
              <pre class="code json" id="resp-body"></pre>
            </div>
            <div class="pane" id="tab-headers">
              <h4>Headers</h4>
              <div class="cols">
                <div>
                  <h5>Request</h5>
                  <pre class="code" id="req-headers"></pre>
                </div>
                <div>
                  <h5>Response</h5>
                  <pre class="code" id="resp-headers"></pre>
                </div>
              </div>
            </div>
          </section>
        </aside>
      </main>

      <script src="/app.js"></script>
      <script>
  (function(){
    const settingsPanel = document.getElementById('settingsPanel');
    const filtersPanel  = document.getElementById('filtersPanel');
    const settingsBtn   = document.getElementById('settingsBtn');
    const filtersBtn    = document.getElementById('filtersBtn');
    const settingsCloseTop = document.getElementById('settingsClose');
    const settingsCloseBottom = document.getElementById('settingsClose2');
    const filtersCloseTop = document.getElementById('filtersClose');
    const filtersCloseBottom = document.getElementById('filtersCloseBottom');

    const exportBtn = document.getElementById('exportBtn');
    const exportMenu = document.getElementById('exportMenu');
    const exportClose = document.getElementById('exportClose');
    const exportCloseBottom = document.getElementById('exportCloseBottom');

    // --- Robust helpers -------------------------------------------------------
    function isInPath(target, ev){
      const path = ev.composedPath ? ev.composedPath() : [];
      return target && (target === ev.target || target.contains(ev.target) || path.includes(target));
    }
    function closePanel(panelEl, toggleBtn){
      if (!panelEl) return;
      panelEl.classList.add('hidden');
      if (toggleBtn) toggleBtn.setAttribute('aria-expanded','false');
    }
    function closeExport(){
      if (!exportMenu) return;
      exportMenu.classList.add('hidden');
      exportMenu.setAttribute('aria-hidden','true');
    }
    let justOpened = false;
    function openExport(){
      closePanel(settingsPanel, settingsBtn);
      closePanel(filtersPanel,  filtersBtn);
      if (!exportMenu) return;
      justOpened = true;
      exportMenu.classList.remove('hidden');
      exportMenu.removeAttribute('style');
      exportMenu.setAttribute('aria-hidden','false');
      // ensure it can receive focus (for Esc key)
      if (!exportMenu.hasAttribute('tabindex')) exportMenu.setAttribute('tabindex','-1');
      exportMenu.focus({preventScroll:true});
      // flip the guard on next tick so outside-click won't instantly close
      requestAnimationFrame(()=>{ justOpened = false; });
    }
    function toggleExport(ev){
      ev.stopPropagation();
      if (ev.stopImmediatePropagation) ev.stopImmediatePropagation();
      if (exportMenu.classList.contains('hidden')) openExport(); else closeExport();
    }

    // --- Wire up buttons ------------------------------------------------------
    settingsCloseTop?.addEventListener('click', () => closePanel(settingsPanel, settingsBtn));
    settingsCloseBottom?.addEventListener('click', () => closePanel(settingsPanel, settingsBtn));
    filtersCloseTop?.addEventListener('click', () => closePanel(filtersPanel, filtersBtn));
    filtersCloseBottom?.addEventListener('click', () => closePanel(filtersPanel, filtersBtn));

    // Use pointer events so it works with mouse & touch, and prevent bubbling
    ['pointerdown','click'].forEach(type=>{
      exportBtn?.addEventListener(type, toggleExport);
    });
    exportClose?.addEventListener('click', closeExport);
    exportCloseBottom?.addEventListener('click', closeExport);

    // Clicking anywhere else — but not the export button or menu — closes it
    window.addEventListener('click', (ev)=>{
      if (justOpened) return; // skip first bubble after opening
      if (!isInPath(exportMenu, ev) && !isInPath(exportBtn, ev)) {
        closeExport();
      }
    }, true); // capture phase for reliability

    // ESC closes any open panel/menu
    window.addEventListener('keydown', (ev)=>{
      if (ev.key === 'Escape') {
        closeExport();
        closePanel(settingsPanel, settingsBtn);
        closePanel(filtersPanel,  filtersBtn);
      }
    });

    // When opening settings or filters, ensure export menu is closed
    settingsBtn?.addEventListener('click', ()=> closeExport());
    filtersBtn?.addEventListener('click',  ()=> closeExport());
  })();
  </script>
  <script>
  (function(){
    // --- Filter Mode (All / Network / Log) ------------------------------------
    const tbody = document.querySelector('#logtbl tbody');
    const modeRadios = document.querySelectorAll('input[name="filterMode"]');

    // Persist / restore mode (fallback to empty which means 'all')
    let filterMode = localStorage.getItem('filterMode') || '';
    modeRadios.forEach(r => { r.checked = (r.value === filterMode); });

    // Helpers to classify a row
    function hasLevelClass(tr){
      return Array.from(tr.classList).some(c => c.startsWith('level-'));
    }
    function textOf(sel, root){
      const el = (root || document).querySelector(sel);
      return (el ? (el.textContent || '') : '').trim();
    }
    function rowKind(tr){
      if (tr.dataset.kind) return tr.dataset.kind;
      if (hasLevelClass(tr)) return tr.dataset.kind = 'LOG';
      const kindText = textOf('.col-kind', tr).toUpperCase();
      if (kindText.includes('LOG')) return tr.dataset.kind = 'LOG';
      if (kindText.includes('HTTP') || kindText.includes('WEBSOCKET')) return tr.dataset.kind = 'NETWORK';
      const m = textOf('.col-method', tr).toUpperCase();
      if (/(GET|POST|PUT|PATCH|DELETE|WS)/.test(m)) return tr.dataset.kind = 'NETWORK';
      return tr.dataset.kind = 'LOG';
    }

    // Ensure we don't end up with an empty table due to a stale persisted filter
    function ensureNotEmpty(){
      if (!tbody) return;
      if (!filterMode) return; // already showing all
      const rows = Array.from(tbody.querySelectorAll('tr'));
      if (!rows.length) return;
      const anyVisible = rows.some(tr => tr.style.display !== 'none');
      if (!anyVisible) {
        // Reset to ALL
        filterMode = '';
        localStorage.removeItem('filterMode');
        modeRadios.forEach(r => { r.checked = (r.value === '' || r.value === 'all'); });
        document.body.dataset.mode = 'all';
        rows.forEach(tr => { tr.style.display = ''; });
      }
    }

    // Apply current filter mode to all current rows
    function applyMode(){
      document.body.dataset.mode = filterMode || 'all';
      if (!tbody) return;
      const rows = tbody.querySelectorAll('tr');
      let visibleCount = 0;
      rows.forEach(tr => {
        const kind = rowKind(tr);
        const show =
          (filterMode === '') ||
          (filterMode === 'network' && kind === 'NETWORK') ||
          (filterMode === 'log' && kind === 'LOG');
        tr.style.display = show ? '' : 'none';
        if (show) visibleCount++;
      });
      // If nothing visible due to persisted filter, auto-reset to 'all'
      if (filterMode && visibleCount === 0) {
        ensureNotEmpty();
      }
    }

    // MutationObserver: classify and filter newly added rows
    const mo = new MutationObserver((mutations) => {
      for (const m of mutations) {
        m.addedNodes.forEach(node => {
          if (!(node instanceof HTMLElement)) return;
          if (node.tagName !== 'TR') return;
          rowKind(node);
          if (filterMode) {
            const show =
              (filterMode === 'network' && node.dataset.kind === 'NETWORK') ||
              (filterMode === 'log' && node.dataset.kind === 'LOG');
            node.style.display = show ? '' : 'none';
          }
        });
      }
      // After batch of inserts, if filter hides everything, reset.
      ensureNotEmpty();
    });
    if (tbody) mo.observe(tbody, { childList: true });

    // Wire radios
    modeRadios.forEach(r => {
      r.addEventListener('change', (e) => {
        filterMode = e.target.value;
        if (filterMode) {
          localStorage.setItem('filterMode', filterMode);
        } else {
          localStorage.removeItem('filterMode');
        }
        applyMode();
      });
    });

    // Initial pass
    applyMode();
  })();
  </script>
     <div class="repo">
       <a href="https://github.com/Husseinhj/LogTapFramework" target="_blank" rel="noopener">
         <svg class="gh-ico" viewBox="0 0 16 16" aria-hidden="true"><path d="M8 0C3.58 0 0 3.58 0 8a8 8 0 0 0 5.47 7.59c.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.62-.17 1.29-.27 2-.27s1.38.09 2 .27c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.01 8.01 0 0 0 16 8c0-4.42-3.58-8-8-8Z"/></svg>
         GitHub — Husseinhj/LogTapFramework
       </a>
       <div class="made">Made with ❤️ from Germany</div>
     </div>

    </body>
  </html>
  """#
}
