// filepath: /Users/husseinhj/Documents/LogTapIOS/LogTapFramework/Sources/LogTapFramework/Utils/Resources+JS.swift
// Auto-extracted JS resource from Resources.swift
// Created to split large resource into a dedicated file for easier debugging.

import Foundation

enum ResourceJS {
  static let appJs: String = #"""
         // ========================= LogTap Viewer (fixed runtime JS) =========================
         // Changes:
         // - Fixed cURL builder (no nested template literal confusions)
         // - Removed fragile ${JSON.stringify(...)} nesting inside Kotlin
         // - Stronger error logging so JS errors don't silently stop rendering
         const colorScheme = document.querySelector('#colorScheme');

         function applyScheme(s){
           const scheme = (s||'').toLowerCase();
           const valid = ['android','xcode','vscode','grafana'];
           const pick = valid.includes(scheme) ? scheme : 'android';
           document.documentElement.setAttribute('data-scheme', pick);
           if(colorScheme) colorScheme.value = pick;
           try{ localStorage.setItem('logtap:scheme', pick); }catch{}
         }
         function initScheme(){
           let s = 'android';
           try{ s = localStorage.getItem('logtap:scheme') || 'android'; }catch{}
           applyScheme(s);
         }
         // ---- DOM ----
         const tbody = document.querySelector('#logtbl tbody');
         const search = document.querySelector('#search');
         const autoScroll = document.querySelector('#autoScroll');
         const clearBtn = document.querySelector('#clearBtn');
         const methodFilter = document.querySelector('#methodFilter');
         const viewMode = document.querySelector('#viewMode');
         const bodyEl = document.body;
         const statusFilter = document.querySelector('#statusFilter');
         const statusCodeFilter = document.querySelector('#statusCodeFilter');
         const wsStatus = document.querySelector('#wsStatus');
         const levelFilter = document.querySelector('#levelFilter');
         const exportJsonBtn = document.querySelector('#exportJson');
         const exportHtmlBtn = document.querySelector('#exportHtml');
         const filtersBtn = document.querySelector('#filtersBtn');
         const filtersPanel = document.querySelector('#filtersPanel');
         const exportBtn = document.querySelector('#exportBtn');
         const exportMenu = document.querySelector('#exportMenu');
         const themeToggle = document.querySelector('#themeToggle');
         const jsonPretty = document.querySelector('#jsonPretty');
         
         const chipTotal = document.querySelector('#chipTotal');
         const chipHttp  = document.querySelector('#chipHttp');
         const chipWs    = document.querySelector('#chipWs');
         const chipLog   = document.querySelector('#chipLog');
         const chipGet   = document.querySelector('#chipGet');
         const chipPost  = document.querySelector('#chipPost');

         // Column toggles
         const colId = document.querySelector('#colId');
         const colTime = document.querySelector('#colTime');
         const colKind = document.querySelector('#colKind');
         const colTag = document.querySelector('#colTag');
         const colMethod = document.querySelector('#colMethod');
         const colStatus = document.querySelector('#colStatus');
         const colUrl = document.querySelector('#colUrl');
         const colActions = document.querySelector('#colActions');
         
         const drawer = document.querySelector('#drawer');
         const drawerClose = document.querySelector('#drawerClose');
         const tabs = Array.from(document.querySelectorAll('.tab'));
         const drawerResizer = document.querySelector('#drawerResizer');
         const DRAWER_MIN = 360, DRAWER_MAX = 1000;
         // ---- Drawer width persistence & drag-resize ----
         function loadDrawerWidth(){
           try{
             const v = Number(localStorage.getItem('logtap:drawerW')||'');
             if(v && !Number.isNaN(v)) document.documentElement.style.setProperty('--drawer-w', v+'px');
           }catch{}
         }
         function saveDrawerWidth(px){ try{ localStorage.setItem('logtap:drawerW', String(px)); }catch{} }
         let dragStartX=0, dragStartW=0, dragging=false;
         function startResize(e){ if(!drawer) return; dragging=true; document.body.classList.add('resizing'); const r=drawer.getBoundingClientRect(); dragStartW=r.width; dragStartX=e.clientX; window.addEventListener('mousemove', onResizeMove); window.addEventListener('mouseup', endResize); }
         function onResizeMove(e){ if(!dragging) return; const dx = dragStartX - e.clientX; let nw = Math.round(dragStartW + dx); nw = Math.max(DRAWER_MIN, Math.min(DRAWER_MAX, nw)); document.documentElement.style.setProperty('--drawer-w', nw+'px'); }
         function endResize(){ if(!dragging) return; dragging=false; document.body.classList.remove('resizing'); const cur = getComputedStyle(document.documentElement).getPropertyValue('--drawer-w').trim(); const px = Number(cur.replace('px',''))||0; if(px>0) saveDrawerWidth(px); window.removeEventListener('mousemove', onResizeMove); window.removeEventListener('mouseup', endResize); }
         // wire tab clicks
         tabs.forEach(b => b.addEventListener('click', (e) => {
           e.preventDefault();
           e.stopPropagation();
           const name = b.dataset.tab;
           if (!name) return;
           activateTab(name);
         }));
         const curlCopyBtn = document.querySelector('#ov-curl-copy');
         const summaryCopyBtn = document.querySelector('#ov-summary-copy');
         
         // ---- State ----
         let rows = [];
         let filtered = [];
         let filterText = '';
         let selectedIdx = -1;
         let currentEv = null;
         
         // ---- Theme ----
         function applyTheme(t){
           const theme = (t === 'light' || t === 'dark') ? t : 'dark';
           document.documentElement.setAttribute('data-theme', theme);
           if (themeToggle) { const next = (theme==='dark'?'light':'dark'); themeToggle.setAttribute('title', 'Switch to '+next+' mode'); themeToggle.setAttribute('aria-label', 'Switch to '+next+' mode'); }
         }
         function initTheme(){
           let t = localStorage.getItem('logtap:theme');
           if (!t) t = (window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches) ? 'light' : 'dark';
           applyTheme(t);
         }

         // ---- Preferences ----
         function initPrefs(){
           try{
             // Pretty JSON
             const v = localStorage.getItem('logtap:jsonPretty');
             if(jsonPretty){
               if(v!==null){ jsonPretty.checked = (v === '1'); }
               else { jsonPretty.checked = true; } // default enabled
             }
             // Auto-scroll
             const av = localStorage.getItem('logtap:autoScroll');
             if (autoScroll){
               if(av!==null){ autoScroll.checked = (av === '1'); }
               else { autoScroll.checked = true; } // default ON
             }
           }catch{}
         }

         // ---- Column visibility persistence ----
         function loadCols(){
           try{ return JSON.parse(localStorage.getItem('logtap:cols')||'{}') }catch{ return {} }
         }
         function saveCols(cfg){ try{ localStorage.setItem('logtap:cols', JSON.stringify(cfg||{})) }catch{}
         }
         function applyCols(cfg){
           const m = Object.assign({
             id:true,time:true,kind:true,tag:true,method:true,status:true,url:true,actions:false
           }, cfg||{});
           // set checkbox states
           if(colId) colId.checked = !!m.id;
           if(colTime) colTime.checked = !!m.time;
           if(colKind) colKind.checked = !!m.kind;
           if(colTag) colTag.checked = !!m.tag;
           if(colMethod) colMethod.checked = !!m.method;
           if(colStatus) colStatus.checked = !!m.status;
           if(colUrl) colUrl.checked = !!m.url;
           if(colActions) colActions.checked = !!m.actions;
           // toggle body classes
           bodyEl.classList.toggle('hide-col-id',      !m.id);
           bodyEl.classList.toggle('hide-col-time',    !m.time);
           bodyEl.classList.toggle('hide-col-kind',    !m.kind);
           bodyEl.classList.toggle('hide-col-tag',     !m.tag);
           bodyEl.classList.toggle('hide-col-method',  !m.method);
           bodyEl.classList.toggle('hide-col-status',  !m.status);
           bodyEl.classList.toggle('hide-col-url',     !m.url);
           bodyEl.classList.toggle('hide-col-actions', !m.actions);
         }
         let colCfg = loadCols();
         if(Object.keys(colCfg).length===0){
           colCfg = {id:true,time:true,kind:true,tag:true,method:true,status:true,url:true,actions:false};
         }

         // ---- Utils ----
         function escapeHtml(s){ return String(s).replace(/[&<>"']/g, c=>({"&":"&amp;","<":"&lt;",">":"&gt;","\"":"&quot;","'":"&#39;"}[c])); }
         function fmtTime(ts){
           try{
             const d = new Date(ts);
             const hh = String(d.getHours()).padStart(2,'0');
             const mm = String(d.getMinutes()).padStart(2,'0');
             const ss = String(d.getSeconds()).padStart(2,'0');
             const ms = String(d.getMilliseconds()).padStart(3,'0');
             return `${hh}:${mm}:${ss}.${ms}`;
           } catch { return String(ts ?? ''); }
         }
         function fmtDateTime(ts){
           try{
             const d = new Date(ts);
             const yyyy = d.getFullYear();
             const mon = String(d.getMonth()+1).padStart(2,'0');
             const day = String(d.getDate()).padStart(2,'0');
             const hh = String(d.getHours()).padStart(2,'0');
             const mm = String(d.getMinutes()).padStart(2,'0');
             const ss = String(d.getSeconds()).padStart(2,'0');
             const ms = String(d.getMilliseconds()).padStart(3,'0');
             return `${yyyy}-${mon}-${day} ${hh}:${mm}:${ss}.${ms}`;
           } catch { return String(ts ?? ''); }
         }
         function classForStatus(code){ if(!code) return ''; const x=Math.floor(code/100); return x===2?'status-2xx':x===3?'status-3xx':x===4?'status-4xx':x===5?'status-5xx':''; }
         function hlJson(raw){
           try { const obj=typeof raw==='string'?JSON.parse(raw):raw; const json=JSON.stringify(obj,null,2);
             return json.replace(/"(\w+)":|"(.*?)"|\b(true|false)\b|\b(-?\d+(?:\.\d+)?)\b|null/g,(m,k,s,b,n)=>{
               if(k) return '<span class="k">"'+escapeHtml(k)+'"</span>:';
               if(s!==undefined) return '<span class="s">"'+escapeHtml(s)+'"</span>';
               if(b) return '<span class="b">'+b+'</span>';
               if(n) return '<span class="n">'+n+'</span>';
               return '<span class="null">null</span>'; });
           } catch { return escapeHtml(String(raw ?? '')); }
         }
         function toFile(name, mime, text){ const blob=new Blob([text],{type:mime}); const a=document.createElement('a'); a.href=URL.createObjectURL(blob); a.download=name; a.click(); URL.revokeObjectURL(a.href); }

         // ---- Normalization helpers ----
         function kindOf(ev){
          const k = ev?.kind;
          if (typeof k === 'string') return k.toUpperCase();
          if (k && typeof k === 'object' && 'name' in k) return String(k.name).toUpperCase();
          return String(k ?? '').toUpperCase();
        }
        function dirOf(ev){
          const d = ev?.direction;
          if (typeof d === 'string') return d.toUpperCase();
          if (d && typeof d === 'object' && 'name' in d) return String(d.name).toUpperCase();
          return String(d ?? '').toUpperCase();
        }
        function levelOf(ev){
           let l = (ev?.level || ev?.logLevel || ev?.priority || '').toString().toUpperCase();
           if(!l && typeof ev?.summary === 'string'){
             const m = ev.summary.match(/^\s*\[(VERBOSE|DEBUG|INFO|WARN|ERROR|ASSERT|LOG)\]/i);
             if(m) l = m[1].toUpperCase();
           }
           return l;
        }

        function logcatLine(ev){
           // Return only the message content for table summary; strip duplicates like ts/level/tag/pid
           let msg = (ev.summary!=null && ev.summary!=='') ? String(ev.summary) : (ev.message || '');
           if (!msg) return '';
           try{
             // Strip leading timestamp like "MM-DD HH:mm:ss.SSS" or "YYYY-MM-DD HH:mm:ss.SSS"
             msg = msg.replace(/^\s*(\d{2}|\d{4})-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}(?:\.\d{1,3})?\s*/,'');
             // Strip classic logcat prefix: "E/Tag(123): " or "D/Tag:" etc.
             msg = msg.replace(/^\s*[VDIWEA]\s*\/\s*[^:()]+(?:\([^)]*\))?\s*:\s*/,'');
             // If we know the level or tag, strip them if they appear at the start like "[INFO] Tag:"
             const lvl = (levelOf(ev)||'').toUpperCase();
             if(lvl) msg = msg.replace(new RegExp('^\\s*\\['+lvl+'\\]\\s*:?\\s*',''),'');
             const tag = (ev.tag||'');
             if(tag) msg = msg.replace(new RegExp('^\\s*'+tag.replace(/[.*+?^$}()|[\\]\\\\]/g,'\\$&')+'\\s*:?\\s*'),'');
           }catch{}
           return msg.trim();
        }
        function logMessage(ev){
          // Prefer a cleaned log line. Fallback to message/body/summary if present.
          const cleaned = logcatLine(ev);
          if (cleaned && cleaned.trim() !== '') return cleaned;
          const raw = ev && (ev.message || ev.bodyPreview || ev.summary);
          return raw ? String(raw) : '';
        }

        function applyMode(){
           const m = viewMode?.value || 'mix';
           bodyEl.classList.remove('mode-mix','mode-network','mode-log');
           bodyEl.classList.add('mode-'+m);
        }

         // ---- Stat chip filtering (toggleable) ----
         const allChips = [];
         let activeChip = null; // currently selected chip element or null
         function highlightChip(el){
           allChips.forEach(c=>c?.classList.remove('active'));
           if(el){ el.classList.add('active'); activeChip = el; } else { activeChip = null; }
         }
         function resetFilters(){
           // Text & selects
           if(search){ search.value=''; filterText=''; }
           if(methodFilter) methodFilter.value='';
           if(statusFilter) statusFilter.value='';
           if(statusCodeFilter) statusCodeFilter.value='';
           if(levelFilter) levelFilter.value='';
           if(viewMode){ viewMode.value='mix'; applyMode(); }
         }
         // ==== Column Resize (persisted) ====
         const COL_W_KEY = 'logtap:colW';
         const rootStyle = document.documentElement.style;
         const headerRow = document.querySelector('#logtbl thead tr');

         function loadColWidths(){
           try{ return JSON.parse(localStorage.getItem(COL_W_KEY)||'{}'); }catch{ return {}; }
         }
         function saveColWidths(map){
           try{ localStorage.setItem(COL_W_KEY, JSON.stringify(map||{})); }catch{}
         }
         function applyColWidths(map){
           if(!map) return;
           for(const [k,v] of Object.entries(map)){
             if(typeof v === 'number' || (typeof v === 'string' && v.endsWith('px'))){
               const px = typeof v === 'number' ? v+"px" : v;
               rootStyle.setProperty(`--col-${k}-w`, px);
             }
           }
         }

         let colWMap = loadColWidths();
         applyColWidths(colWMap);

         function installColumnResizers(){
           if(!headerRow) return;
           const ths = Array.from(headerRow.querySelectorAll('th'));
           ths.forEach(th => {
             const cls = Array.from(th.classList).find(c => c.startsWith('col-'));
             if(!cls) return; // skip if no recognizable column key
             const key = cls.replace('col-','');
             // ensure handle exists once
             if(th.querySelector('.th-resizer')) return;
             th.style.position = 'sticky'; // keep sticky; our handle is absolutely placed inside
             const handle = document.createElement('div');
             handle.className = 'th-resizer';
             // Accessibility and hint attributes
             handle.title = 'Drag to resize column';
             handle.setAttribute('role','separator');
             handle.setAttribute('aria-orientation','vertical');
             handle.tabIndex = 0; // allow keyboard focus
             th.appendChild(handle);

             let startX=0, startW=0, dragging=false;
             function onMove(e){
               if(!dragging) return;
               const dx = (e.clientX || (e.touches && e.touches[0]?.clientX) || 0) - startX;
               let w = Math.max(60, Math.min(600, startW + dx));
               rootStyle.setProperty(`--col-${key}-w`, w+'px');
             }
             function onUp(){
               if(!dragging) return;
               dragging=false;
               document.body.classList.remove('th-resizing');
               const cur = getComputedStyle(document.documentElement).getPropertyValue(`--col-${key}-w`).trim();
               if(cur){
                 const num = Number(cur.replace('px','')) || 0;
                 if(num>0){ colWMap[key] = num; saveColWidths(colWMap); }
               }
               window.removeEventListener('mousemove', onMove);
               window.removeEventListener('mouseup', onUp);
               window.removeEventListener('touchmove', onMove);
               window.removeEventListener('touchend', onUp);
             }
             function onDown(e){
               e.preventDefault(); e.stopPropagation();
               const rect = th.getBoundingClientRect();
               startX = (e.clientX || (e.touches && e.touches[0]?.clientX) || 0);
               const cur = getComputedStyle(document.documentElement).getPropertyValue(`--col-${key}-w`).trim();
               const fallback = rect.width;
               startW = cur ? Number(cur.replace('px','')) || fallback : fallback;
               dragging=true;
               document.body.classList.add('th-resizing');
               window.addEventListener('mousemove', onMove);
               window.addEventListener('mouseup', onUp);
               window.addEventListener('touchmove', onMove, {passive:false});
               window.addEventListener('touchend', onUp);
             }
             handle.addEventListener('mousedown', onDown);
             handle.addEventListener('touchstart', onDown, {passive:false});

             // Keyboard support for nudging width
             function nudge(delta){
               const cur = getComputedStyle(document.documentElement).getPropertyValue(`--col-${key}-w`).trim();
               const base = cur ? Number(cur.replace('px','')) : th.getBoundingClientRect().width;
               const w = Math.max(60, Math.min(600, base + delta));
               rootStyle.setProperty(`--col-${key}-w`, w+'px');
               colWMap[key] = w; saveColWidths(colWMap);
             }
             handle.addEventListener('keydown', (e)=>{
               if(e.key==='ArrowLeft'){ e.preventDefault(); nudge(-10); }
               else if(e.key==='ArrowRight'){ e.preventDefault(); nudge(+10); }
             });
           });
         }
         
         function resetColWidths(){
           colWMap = {}; saveColWidths(colWMap);
           // remove custom vars to fall back to defaults
           ['id','time','kind','tag','method','status','url','actions'].forEach(k=>{
             rootStyle.removeProperty(`--col-${k}-w`);
           });
         }
         function applyStatFilter(kind, toggledOff){
           if (toggledOff) {
             // clear any visual/aria selection on chips
             allChips.forEach(c=>{ c?.setAttribute('aria-pressed','false'); c?.classList.remove('active'); });
             highlightChip(null); // also sets activeChip = null
             // force view back to Mix and clear method/level/status filters
             if(viewMode) viewMode.value = 'mix';
             if(methodFilter) methodFilter.value = '';
             if(levelFilter) levelFilter.value = '';
             if(statusFilter) statusFilter.value = '';
             if(statusCodeFilter) statusCodeFilter.value = '';
             applyMode();
             // user clicked the active chip again -> clear selection and reset filters
             resetFilters();
             renderAll();
             return;
           }
           switch(kind){
             case 'TOTAL':
               resetFilters();
               if(viewMode) viewMode.value='mix';
               applyMode();
               break;
             case 'HTTP':
               resetFilters();
               if(viewMode) viewMode.value='network';
               if(methodFilter) methodFilter.value='';
               applyMode();
               break;
             case 'WS':
               resetFilters();
               if(viewMode) viewMode.value='network';
               if(methodFilter) methodFilter.value='WS';
               applyMode();
               break;
             case 'LOG':
               resetFilters();
               if(viewMode) viewMode.value='log';
               applyMode();
               break;
             case 'GET':
               resetFilters();
               if(viewMode) viewMode.value='network';
               if(methodFilter) methodFilter.value='GET';
               applyMode();
               break;
             case 'POST':
               resetFilters();
               if(viewMode) viewMode.value='network';
               if(methodFilter) methodFilter.value='POST';
               applyMode();
               break;
           }
           renderAll();
         }

         // ---- Status code filter helpers ----
         function statusMatches(code, query){
           if(!query) return true;
           if(!code) return false;
           const s = String(query).trim().replace(/\s+/g,'');
           if(!s) return true;
           const tokens = s.split(',').filter(Boolean);
           const c = Number(code);
           for(const t of tokens){
             // class like 2xx / 4XX
             if(/^[0-9][xX]{2}$/.test(t)){
               const k = Number(t[0]);
               if(Math.floor(c/100) === k) return true;
               continue;
             }
             // exact 3-digit
             if(/^\d{3}$/.test(t)){
               if(c === Number(t)) return true;
               continue;
             }
             // range 3xx-3xx or 000-999
             const m = t.match(/^(\d{3})-(\d{3})$/);
             if(m){
               const a = Number(m[1]), b = Number(m[2]);
               if(c >= Math.min(a,b) && c <= Math.max(a,b)) return true;
               continue;
             }
           }
           return false;
         }
         
         // ---- Copy helper with fallback for non-secure contexts ----
         async function copyText(text){
           try{
             if (navigator.clipboard && window.isSecureContext) {
               await navigator.clipboard.writeText(text);
               return true;
             }
           }catch(e){ /* fall back */ }
           try{
             const ta = document.createElement('textarea');
             ta.value = text;
             ta.style.position = 'fixed';
             ta.style.top = '-9999px';
             document.body.appendChild(ta);
             ta.focus(); ta.select();
             const ok = document.execCommand('copy');
             document.body.removeChild(ta);
             return ok;
           }catch(e){ console.warn('copy fallback failed', e); return false; }
         }
         
         // ---- Filters & Stats ----
         function matchesFilters(ev){
           if(filterText){ const hay = JSON.stringify(ev).toLowerCase(); if(!hay.includes(filterText)) return false; }
           const kind = kindOf(ev);
           const mode = viewMode?.value || 'mix';
           if (mode === 'network' && !(kind === 'HTTP' || kind === 'WEBSOCKET')) return false;
           if (mode === 'log' && kind !== 'LOG') return false;
           const m = methodFilter?.value || '';
           if(m){
             if(m==='WS') { if(kind !== 'WEBSOCKET') return false; }
             else { if(kind !== 'HTTP') return false; if((ev.method||'').toUpperCase() !== m) return false; }
           }
           const s = statusFilter?.value || '';
           if(s && ev.status){ const x = Math.floor(ev.status/100)+'xx'; if(x!==s) return false; }
           if (statusCodeFilter && statusCodeFilter.value && !statusMatches(ev.status, statusCodeFilter.value)) return false;
           const lf = (levelFilter?.value || '').toUpperCase();
           if(lf && kind==='LOG'){
             const evLevel = levelOf(ev);
             if(!evLevel || evLevel !== lf) return false;
           }
           return true;
         }
         function renderStats(){
           const total = rows.length; const http = rows.filter(r=>kindOf(r)==='HTTP').length; const ws = rows.filter(r=>kindOf(r)==='WEBSOCKET').length; const log = rows.filter(r=>kindOf(r)==='LOG').length; const get = rows.filter(r=>(r.method||'').toUpperCase()==='GET').length; const post = rows.filter(r=>(r.method||'').toUpperCase()=='POST').length;
           const set=(id,txt)=>{ const el=document.getElementById(id); if(el) el.textContent = txt; };
           set('chipTotal','Total: '+total); set('chipHttp','HTTP: '+http); set('chipWs','WS: '+ws); set('chipLog','LOG: '+log); set('chipGet','GET: '+get); set('chipPost','POST: '+post);
         }
         
         // ---- cURL builder (HTTP only) ----
         function curlFor(ev){
           try{
             if(ev.kind!=='HTTP') return '';
             const parts = ['curl', '-i', '-X', (ev.method||'GET')];
             const url = ev.url || '';
             const hdrs = ev.headers || {};
             for(const [k,v] of Object.entries(hdrs)){
               const vv = Array.isArray(v)? v.join(', '): String(v);
               parts.push('-H', JSON.stringify(k+': '+vv));
             }
             if(ev.bodyPreview!=null && ev.bodyPreview!=='' && ev.method && ev.method.toUpperCase()!=='GET'){
               parts.push('--data-binary', JSON.stringify(String(ev.bodyPreview)));
             }
             parts.push(JSON.stringify(url));
             return parts.join(' ');
           }catch(e){ console.warn('[LogTap] curlFor failed', e); return ''; }
         }
         
         // ---- Table ----
         function renderAll(){
           try{
             filtered = rows.filter(matchesFilters);
             tbody.innerHTML='';
             const fr = document.createDocumentFragment();
             for(const ev of filtered) fr.appendChild(renderRow(ev));
             tbody.appendChild(fr);
             if(autoScroll?.checked) tbody.lastElementChild?.scrollIntoView({block:'end'});
             renderStats();
           }catch(err){ console.error('[LogTap] renderAll error', err); }
         }
         function btn(label, on){
           const b=document.createElement('button');
           b.className='xs ghost';
           b.textContent=label;
           b.addEventListener('click', async (e)=>{
             e.preventDefault();
             e.stopPropagation();
             try { await on(b); } catch(err){ console.warn('button action failed', err); }
           });
           return b;
         }
         function renderRow(ev){
           const tr = document.createElement('tr');
           const kind = kindOf(ev); const dir = dirOf(ev);
           // Add WS direction classes to row
           const isSend = (dir === 'OUTBOUND' || dir === 'REQUEST');
           const isRecv = (dir === 'INBOUND'  || dir === 'RESPONSE');
           if (kind === 'WEBSOCKET'){
             if (isSend) tr.classList.add('ws-send');
             else if (isRecv) tr.classList.add('ws-recv');
           }
           // Build WS direction icon (send/receive)
           let wsIconHtml = '';
           const mU = (ev.method ? String(ev.method).toUpperCase() : (kind==='WEBSOCKET' ? 'WS' : ''));
           if (kind === 'WEBSOCKET') {
             wsIconHtml = isSend
               ? '<span class="ws-ico ws-send" title="WebSocket send">⇧</span>'
               : isRecv
                 ? '<span class="ws-ico ws-recv" title="WebSocket receive">⇩</span>'
                 : '<span class="ws-ico" title="WebSocket">∿</span>';
           }
           const lvl = (kind==='LOG') ? levelOf(ev) : '';
           if(lvl) tr.classList.add('level-'+lvl);
           const stCls = classForStatus(ev.status);
           if (stCls) tr.classList.add(stCls);
           const tagTxt = ev.tag ? String(ev.tag) : '';
           tr.dataset.id = String(ev.id ?? '');
           if (mU) tr.classList.add('method-'+mU);
           const actions = document.createElement('div'); actions.className='action-row';
           if(kind==='HTTP') {
             const copyBtn = document.createElement('button');
             copyBtn.className = 'icon';
             copyBtn.title = 'Copy cURL';
             copyBtn.innerHTML = '<span class="material-symbols-outlined" aria-hidden="true">content_copy</span>';
             copyBtn.addEventListener('click', async (e)=>{
               e.preventDefault(); e.stopPropagation();
               const ok = await copyText(curlFor(ev));
               if(ok){ copyBtn.classList.add('active'); setTimeout(()=> copyBtn.classList.remove('active'), 800); }
             });
             actions.appendChild(copyBtn);
           }
           const tdActions = document.createElement('td'); tdActions.className='col-actions'; tdActions.appendChild(actions);

           tr.innerHTML =
             `<td class="col-id">${ev.id ?? ''}</td>`+
             `<td class="col-time">${fmtTime(ev.ts)}</td>`+
             `<td class="col-kind kind-${kind}">${
         kind === 'LOG'
         ? escapeHtml(ev.level || levelOf(ev) || 'LOG')
         : (kind === 'WEBSOCKET' ? ('WS' + wsIconHtml) : kind)
     }</td>`+
             `<td class="col-tag">${escapeHtml(tagTxt)}</td>`+
             `<td class="col-method method-${mU}">${escapeHtml(ev.method || (kind === 'WEBSOCKET'?'WS':''))}</td>`+
             `<td class="col-status ${classForStatus(ev.status)}">${ev.status ?? ''}</td>`+
             (kind==='LOG'
               ? (`<td class="col-url"><div class="url"><div class="lc">${logcatLine(ev)}</div></div></td>`)
               : (`<td class="col-url">`
                    + `<div class="url method-${mU} ${kind === 'WEBSOCKET' ? (isSend?'ws ws-send': (isRecv?'ws ws-recv':'ws')) : ''}">${
         escapeHtml(
             ev.url || ''
         )
     }</div>`
                    + (ev.summary ? `<div class="muted">${escapeHtml(ev.summary)}</div>` : '')
                  + `</td>`)
             )
           // pretty body preview under URL cell (only for HTTP and WEBSOCKET, not LOG)
           if (ev.bodyPreview && (kind === 'HTTP' || kind === 'WEBSOCKET')) {
             const pre = document.createElement('pre');
             pre.className = 'code mini body' + (jsonPretty?.checked ? ' json' : '');
             if (kind === 'WEBSOCKET'){
               pre.classList.add(isSend ? 'ws-send' : (isRecv ? 'ws-recv' : ''));
             }
             pre.innerHTML = jsonPretty?.checked ? hlJson(ev.bodyPreview) : escapeHtml(String(ev.bodyPreview));
             const urlCell = tr.querySelector('.col-url');
             if (urlCell) urlCell.appendChild(pre);
           }
           tr.appendChild(tdActions);
           tr.addEventListener('click', ()=> openDrawer(ev));
           return tr;
         }
         // ---- Body helper ----
         function bodyFor(ev, which){
           // prefer full body fields if present
           if(which==='request'){
             return ev.requestBodyFull ?? ev.requestBody ?? ev.body ?? ev.bodyFull ?? ev.bodyPreview ?? '';
           } else {
             return ev.responseBodyFull ?? ev.responseBody ?? ev.body ?? ev.bodyFull ?? ev.bodyPreview ?? '';
           }
         }
         
         // ---- Drawer ----
         function setText(id,v){ const el=document.getElementById(id); if(el) el.textContent = v==null?'':String(v); }
         function setJson(id,raw){ const el=document.getElementById(id); if(!el) return; if(!raw){ el.textContent=''; return;} el.innerHTML = hlJson(raw); }
         function headersToLines(map){
           try{ return Object.entries(map||{}).map(([k,v])=> k+': '+(Array.isArray(v)?v.join(', '): String(v))).join('\n'); }catch{ return ''; }
         }
         function hlHeaders(text){
           return String(text||'').split('\n').map(line=>{
             const m = line.match(/^([^:]+):\s*(.*)$/);
             if(m){
               return '<span class="hk">'+escapeHtml(m[1])+'</span>: <span class="hv">'+escapeHtml(m[2])+'</span>';
             }
             return escapeHtml(line);
           }).join('\n');
         }
         function setHeaders(id, map){
           const el = document.getElementById(id); if(!el) return;
           const txt = headersToLines(map);
           el.innerHTML = hlHeaders(txt);
         }
         function activateTab(name){ tabs.forEach(b=>b.classList.toggle('active', b.dataset.tab===name)); document.querySelectorAll('.pane').forEach(p=>p.classList.toggle('active', p.id==='tab-'+name)); }
         function show(id, on){ const el=document.getElementById(id); if(!el) return; el.classList.toggle('hidden', !on); }
         function setActiveTabIfHidden(){
           // ensure the active tab button/pane are visible; if not, switch to overview
           const active = document.querySelector('.tab.active');
           if(active && active.classList.contains('hidden')) activateTab('overview');
         }
         function configureDrawerForKind(kind, ev){
           const isLog = (kind === 'LOG');
           // Toggle overview rows
           show('row-method', !isLog);
           show('row-status', !isLog);
           show('row-url', !isLog);
           show('row-took', !isLog);
           show('row-curl', !isLog && ev && kind==='HTTP');
           show('row-level', isLog);
           show('row-tag', isLog);
           // Tabs: hide request/response/headers for LOG
           const showNetTabs = !isLog;
           document.getElementById('tabBtn-request')?.classList.toggle('hidden', !showNetTabs);
           document.getElementById('tabBtn-response')?.classList.toggle('hidden', !showNetTabs);
           document.getElementById('tabBtn-headers')?.classList.toggle('hidden', !showNetTabs);
           document.getElementById('tab-request')?.classList.toggle('hidden', !showNetTabs);
           document.getElementById('tab-response')?.classList.toggle('hidden', !showNetTabs);
           document.getElementById('tab-headers')?.classList.toggle('hidden', !showNetTabs);
           if(!showNetTabs) activateTab('overview');
         }
         function openDrawer(ev){
           if(!drawer) return;
           currentEv = ev;
           const kind = kindOf(ev); const dir = dirOf(ev);
           bodyEl.classList.add('drawer-open');
           let title = '';
           if (kind === 'LOG') {
             // For logger entries: show the tag (fallback to summary or 'LOG')
             title = ev.tag || ev.summary || 'LOG';
           } else {
             // For interceptor entries (HTTP / WebSocket): show the URL only
             title = ev.url || ev.summary || '';
           }
           const tEl = document.getElementById('drawerTitle'); tEl && tEl.replaceChildren(document.createTextNode(title));
           let sub = `<span class="badge">id ${ev.id}</span> ` + (ev.status? `<span class="badge">status ${ev.status}</span> ` : '') + (ev.tookMs? `<span class="badge">${ev.tookMs} ms</span>` : '');
           if (kind === 'WEBSOCKET') {
             const d = dir;
             const label = (d === 'OUTBOUND' || d === 'REQUEST') ? 'send' : (d === 'INBOUND' || d === 'RESPONSE') ? 'recv' : String(d||'').toLowerCase();
             sub += ` <span class="badge">WS ${label}</span>`;
           }
           const sEl = document.getElementById('drawerSub'); if(sEl) sEl.innerHTML = sub;
           setText('ov-id', ev.id); setText('ov-time', fmtDateTime(ev.ts));
           // Set ov-kind: for LOG, use level or fallback; else kind.
           if(kind==='LOG'){
             setText('ov-kind', ev.level || levelOf(ev) || 'LOG');
           } else {
             setText('ov-kind', kind);
           }
           setText('ov-dir', dir);
           setText('ov-method', ev.method || (kind==='WEBSOCKET'?'WS':'')); setText('ov-status', ev.status ?? ''); setText('ov-url', ev.url ?? '');
           setText('ov-level', (ev.level || levelOf(ev) || ''));
           setText('ov-tag', (ev.tag || ''));
           // ---- Contextual summary block with classes ----
           const mU = (ev.method ? String(ev.method).toUpperCase() : (kind==='WEBSOCKET' ? 'WS' : ''));
           const lvl = (kind==='LOG') ? levelOf(ev) : '';
           const sumEl = document.getElementById('ov-summary');
           if (sumEl){
             sumEl.classList.remove('json','method-GET','method-POST','method-PUT','method-PATCH','method-DELETE','method-WS','ws-send','ws-recv','ws-ping','ws-pong','ws-close','level-VERBOSE','level-DEBUG','level-INFO','level-WARN','level-ERROR','level-ASSERT');
             // content
             let content;
             if (kind === 'LOG') {
               content = logMessage(ev); // make sure logs show their message
               sumEl.classList.remove('json');
               sumEl.textContent = content || '';
             } else {
               content = ev.summary ?? '';
               if (jsonPretty?.checked){
                 sumEl.classList.add('json');
                 sumEl.innerHTML = hlJson(content);
               } else {
                 sumEl.classList.remove('json');
                 sumEl.textContent = content;
               }
             }
             // method/WS tint
             if (kind==='HTTP'){
               if (mU) sumEl.classList.add('method-'+mU);
             } else if (kind==='WEBSOCKET'){
               const isSend = (dir === 'OUTBOUND' || dir === 'REQUEST');
               const isRecv = (dir === 'INBOUND'  || dir === 'RESPONSE');
               const op = (ev.op || ev.opcode || '').toString().toLowerCase();
               const wsClass = op==='ping'?'ws-ping': op==='pong'?'ws-pong': op==='close'?'ws-close': (isSend?'ws-send': isRecv?'ws-recv':'');
               if (wsClass) sumEl.classList.add(wsClass);
               sumEl.classList.add('method-WS');
             } else if (kind==='LOG'){
               if (lvl) sumEl.classList.add('level-'+lvl);
             }
           }
           setText('ov-took', ev.tookMs? ev.tookMs+' ms' : '');
           // Show tag in thread field if present
           if(ev.tag) setText('ov-thread', (ev.thread ?? '') + (ev.thread? ' • ' : '') + ev.tag);
           else setText('ov-thread', ev.thread ?? '');
           setJson('req-body', bodyFor(ev,'request'));
           setJson('resp-body', bodyFor(ev,'response'));
           // Colorize drawer content by method
           const reqPre = document.getElementById('req-body');
           const respPre = document.getElementById('resp-body');
           [reqPre, respPre].forEach(p=>{ if(!p) return; p.classList.remove('method-GET','method-POST','method-PUT','method-PATCH','method-DELETE','method-WS'); if(mU) p.classList.add('method-'+mU); });
           const reqH = document.getElementById('req-headers');
           const respH = document.getElementById('resp-headers');
           [reqH, respH].forEach(h=>{ if(!h) return; h.classList.add('headers'); h.classList.remove('method-GET','method-POST','method-PUT','method-PATCH','method-DELETE','method-WS'); if(mU) h.classList.add('method-'+mU); });
           setHeaders('req-headers', ev.headers || {});
           setHeaders('resp-headers', ev.responseHeaders || {});
           // --- WebSocket direction & opcode classes for drawer code/headers ---
           const isSend = (dir === 'OUTBOUND' || dir === 'REQUEST');
           const isRecv = (dir === 'INBOUND'  || dir === 'RESPONSE');
           const op = (ev.op || ev.opcode || '').toString().toLowerCase(); // 'text','binary','ping','pong','close'
           const wsClass = (kind==='WEBSOCKET') ? (op==='ping'?'ws-ping': op==='pong'?'ws-pong': op==='close'?'ws-close': (isSend?'ws-send': isRecv?'ws-recv':'')) : '';
           [reqPre, respPre].forEach(p=>{
             if(!p) return;
             p.classList.remove('ws-send','ws-recv','ws-ping','ws-pong','ws-close');
             if(wsClass) p.classList.add(wsClass);
           });
           [reqH, respH].forEach(h=>{
             if(!h) return;
             h.classList.remove('ws-send','ws-recv','ws-ping','ws-pong','ws-close');
             if(wsClass) h.classList.add(wsClass);
           });
           const oc = document.getElementById('ov-curl'); if(oc) oc.textContent = curlFor(ev);
           if(curlCopyBtn){ curlCopyBtn.onclick = async (e)=>{ e.preventDefault(); e.stopPropagation(); const ocEl = document.getElementById('ov-curl'); const ok = await copyText(ocEl?.textContent || ''); if(ok){ const old = curlCopyBtn.textContent; curlCopyBtn.textContent = 'Copied!'; setTimeout(()=> curlCopyBtn.textContent = old, 1200); } }; }
           const os = document.getElementById('ov-summary');
           if(summaryCopyBtn){ summaryCopyBtn.onclick = async (e)=>{ e.preventDefault(); e.stopPropagation(); const osEl = document.getElementById('ov-summary'); const ok = await copyText(osEl?.textContent || ''); if(ok){ const old = summaryCopyBtn.textContent; summaryCopyBtn.textContent = 'Copied!'; setTimeout(()=> summaryCopyBtn.textContent = old, 1200); } }; }
           configureDrawerForKind(kind, ev);
           activateTab('overview');
         }
         
         // ---- Exports ----
         function currentFiltered(){ return rows.filter(matchesFilters); }
         exportJsonBtn?.addEventListener('click', ()=>{
           try{ const data = JSON.stringify(currentFiltered(), null, 2); const name = 'logtap-'+new Date().toISOString().replace(/[:.]/g,'-')+'.json'; toFile(name, 'application/json', data);}catch(e){ console.error('export json failed', e); }
         });
         exportHtmlBtn?.addEventListener('click', ()=>{
           try{ const data = currentFiltered(); const pre = escapeHtml(JSON.stringify(data, null, 2));
             const html = `<!doctype html><html><head><meta charset=\"utf-8\"><title>LogTap Report</title><style>body{font-family:ui-monospace,Menlo,monospace;background:#0b0d10;color:#e6edf3}pre{white-space:pre-wrap}</style></head><body><h1>LogTap Report</h1><p>Generated ${new Date().toLocaleString()}</p><h2>Filtered events (${data.length})</h2><pre>${pre}</pre></body></html>`;
             const name = 'logtap-report-'+new Date().toISOString().replace(/[:.]/g,'-')+'.html'; toFile(name, 'text/html', html);
           }catch(e){ console.error('export html failed', e); }
         });
         
         // ---- Events ----
         function onColChange(){
           colCfg = {
             id: !!(colId?.checked), time: !!(colTime?.checked), kind: !!(colKind?.checked), tag: !!(colTag?.checked),
             method: !!(colMethod?.checked), status: !!(colStatus?.checked), url: !!(colUrl?.checked), actions: !!(colActions?.checked)
           };
           saveCols(colCfg); applyCols(colCfg);
         }
         [colId,colTime,colKind,colTag,colMethod,colStatus,colUrl,colActions].forEach(el=> el?.addEventListener('change', onColChange));
         // Apply saved column visibility on startup
         applyCols(colCfg);
         search?.addEventListener('input', ()=>{ filterText = search.value.trim().toLowerCase(); renderAll(); });
         // Make stat chips clickable (toggle selection on re-click)
         allChips.push(chipTotal, chipHttp, chipWs, chipLog, chipGet, chipPost);
         // Set default selection to "Total" chip on boot
         highlightChip(chipTotal);
         chipTotal.setAttribute('aria-pressed','true');
         chipTotal.classList.add('active');
         allChips.forEach(c=>{
           if(!c) return;
           c.classList.add('clickable');
           c.setAttribute('role','button');
           c.setAttribute('tabindex','0');
           // Set all chips aria-pressed to false except chipTotal
           if (c !== chipTotal) c.setAttribute('aria-pressed','false');
           c.addEventListener('click', ()=>{
             const isSame = (activeChip === c);
             // update aria and visual state
             if(isSame){
               c.setAttribute('aria-pressed','false');
               highlightChip(null);
             } else {
               allChips.forEach(ch=>{ ch?.setAttribute('aria-pressed','false'); ch?.classList.remove('active'); });
               c.setAttribute('aria-pressed','true');
               c.classList.add('active');
               activeChip = c;
             }
             const kind = (c===chipTotal)?'TOTAL':(c===chipHttp)?'HTTP':(c===chipWs)?'WS':(c===chipLog)?'LOG':(c===chipGet)?'GET':'POST';
             applyStatFilter(kind, isSame);
           });
           c.addEventListener('keydown', (e)=>{ if(e.key==='Enter' || e.key===' '){ e.preventDefault(); c.click(); } });
         });
         methodFilter?.addEventListener('change', renderAll);
         viewMode?.addEventListener('change', ()=>{ applyMode(); renderAll(); });
         statusFilter?.addEventListener('change', renderAll);
         statusCodeFilter?.addEventListener('input', renderAll);
         levelFilter?.addEventListener('change', renderAll);
         jsonPretty?.addEventListener('change', ()=>{
           try{ localStorage.setItem('logtap:jsonPretty', jsonPretty.checked ? '1' : '0'); }catch{}
           renderAll();
           if (currentEv) openDrawer(currentEv);
         });
         autoScroll?.addEventListener('change', ()=>{
           try{ localStorage.setItem('logtap:autoScroll', autoScroll.checked ? '1' : '0'); }catch{}
         });
         colorScheme?.addEventListener('change', ()=> applyScheme(colorScheme.value));
         clearBtn?.addEventListener('click', async ()=>{ try{ await fetch('/api/clear', {method:'POST'}); }catch{} rows=[]; renderAll(); });
         drawerClose?.addEventListener('click', ()=> bodyEl.classList.remove('drawer-open'));
         // Filters & Export popovers (don't close when clicking inside)
         function isInside(el, target){ return !!(el && target && el instanceof Node && el.contains(target)); }
         function closePopovers(e){
           if (e) {
             const t = e.target;
             // If click is inside either popover or on their trigger buttons, don't close
             if (isInside(filtersPanel, t) || isInside(exportMenu, t) || isInside(filtersBtn, t) || isInside(exportBtn, t)) return;
           }
           filtersPanel?.classList.add('hidden');
           exportMenu?.classList.add('hidden');
         }
         filtersBtn?.addEventListener('click', (e)=>{
           e.preventDefault(); e.stopPropagation();
           const wasOpen = !filtersPanel?.classList.contains('hidden');
           closePopovers();
           if(!wasOpen) filtersPanel?.classList.remove('hidden');
         });
         exportBtn?.addEventListener('click', (e)=>{
           e.preventDefault(); e.stopPropagation();
           const wasOpen = !exportMenu?.classList.contains('hidden');
           closePopovers();
           if(!wasOpen) exportMenu?.classList.remove('hidden');
         });
         // Filters actions (Reset / Apply)
         const filtersReset = document.querySelector('#filtersReset');
         const filtersClose = document.querySelector('#filtersClose');
         filtersReset?.addEventListener('click', (e)=>{ e.preventDefault(); e.stopPropagation(); resetFilters(); renderAll(); });
         filtersClose?.addEventListener('click', (e)=>{ e.preventDefault(); e.stopPropagation(); filtersPanel?.classList.add('hidden'); });

         // Prevent clicks inside popovers from bubbling to document
         filtersPanel?.addEventListener('click', (e)=> e.stopPropagation());
         exportMenu?.addEventListener('click', (e)=> e.stopPropagation());
         document.addEventListener('click', (e)=> closePopovers(e));
         document.addEventListener('keydown', (e)=>{ if(e.key==='Escape') closePopovers(); });
         themeToggle?.addEventListener('click', ()=>{ const cur = document.documentElement.getAttribute('data-theme') || 'dark'; const next = cur==='dark'?'light':'dark'; applyTheme(next); localStorage.setItem('logtap:theme', next); });
         
         // ---- Bootstrap + WS status ----
         async function loadDeviceInfo(){
           try{
             const res = await fetch('/api/info');
             if(!res.ok) return;
             const info = await res.json();
             const appNameEl = document.getElementById('appName');
             const appMetaEl = document.getElementById('appMeta');
             const appIconEl = document.getElementById('appIcon');
         
             if(appNameEl) appNameEl.textContent = info.appName || 'Unknown App';
         
             if(appMetaEl){
               const ver = [info.versionName ? 'v'+info.versionName : null,
                            (info.versionCode!=null) ? '('+info.versionCode+')' : null]
                           .filter(Boolean).join(' ');
               const device = [info.deviceManufacturer, info.deviceModel].filter(Boolean).join(' ');
               const os = [info.osType, info.osVersion, info.apiLevel!=null?('API '+info.apiLevel):null]
                          .filter(Boolean).join(' ');
               // Compose meta: bundle • version • device • os
               appMetaEl.textContent = [info.appBundle, ver, device, os].filter(Boolean).join(' • ');
             }
             if(appIconEl && info.appIconBase64){
               appIconEl.style.backgroundImage = 'url(data:image/png;base64,'+info.appIconBase64+')';
             }
           }catch(e){
             console.warn('[LogTap] Device info load failed', e);
           }
         }

         async function bootstrap(){
           initTheme();
           initPrefs();
           initScheme();
           // Load DeviceAppInfo into header
           loadDeviceInfo();
           try{ const res = await fetch('/api/logs?limit=1000'); if(!res.ok) throw new Error('HTTP '+res.status); rows = await res.json(); }
           catch(err){ console.error('[LogTap] failed to fetch /api/logs', err); rows=[]; }
           applyMode();
           renderAll();
           try{
             const setWs = (text, cls)=>{ if(wsStatus){ wsStatus.textContent = text; wsStatus.classList.remove('status-on','status-off','status-connecting'); if(cls) wsStatus.classList.add(cls); } };
             setWs('● Connecting…', 'status-connecting');
             const ws = new WebSocket((location.protocol==='https:'?'wss':'ws')+'://'+location.host+'/ws');
             const on = ()=> setWs('● Connected', 'status-on');
             const off = ()=> setWs('● Disconnected', 'status-off');
             ws.addEventListener('open', on);
             ws.addEventListener('close', off);
             ws.addEventListener('error', off);
             ws.onmessage = (e)=>{ try{ const ev = JSON.parse(e.data); rows.push(ev); if(matchesFilters(ev)){ tbody.appendChild(renderRow(ev)); if(autoScroll?.checked) tbody.lastElementChild?.scrollIntoView({block:'end'}); renderStats(); } }catch(parseErr){ console.warn('[LogTap] bad WS payload', parseErr); } };
           }catch(wsErr){ console.warn('[LogTap] WS setup failed', wsErr); if(wsStatus){ wsStatus.textContent='● Disconnected'; wsStatus.classList.remove('status-on','status-connecting'); wsStatus.classList.add('status-off'); } }
         }
         // === Settings popover wiring ===
         const settingsBtn   = document.getElementById('settingsBtn');
         const settingsPanel = document.getElementById('settingsPanel');
         const settingsClose = document.getElementById('settingsClose');
         const settingsReset = document.getElementById('settingsReset');

         function toggleSettings(open) {
           if (!settingsPanel || !settingsBtn) return;
           const willOpen = open ?? settingsPanel.classList.contains('hidden');
           if (willOpen) {
             // Position the panel just under the button, keeping it in-viewport
             const br = settingsBtn.getBoundingClientRect();
             const vw = window.innerWidth, vh = window.innerHeight;
             const panelW = Math.min(520, vw - 24);
             let left = Math.max(12, Math.min(br.left, vw - panelW - 12));
             let top  = Math.min(br.bottom + 8, vh - 100); // leave a little room at bottom
             settingsPanel.style.left = left + 'px';
             settingsPanel.style.right = 'auto';
             settingsPanel.style.top = top + 'px';
           }
           settingsPanel.classList.toggle('hidden', !willOpen);
           settingsBtn.setAttribute('aria-expanded', willOpen ? 'true' : 'false');
         }

         settingsBtn?.addEventListener('click', (e) => {
           e.stopPropagation();
           toggleSettings();
         });

         settingsClose?.addEventListener('click', () => toggleSettings(false));
         // Optional hook for your reset logic:
         settingsReset?.addEventListener('click', () => {
            // Pretty JSON defaults to ON
           if(jsonPretty){
             jsonPretty.checked = true;
             try{ localStorage.setItem('logtap:jsonPretty','1'); }catch{}
           }
           if (autoScroll){
             autoScroll.checked = true;
             try{ localStorage.setItem('logtap:autoScroll','1'); }catch{}
           }

           // Columns: show all
           const allTrue = {id:true,time:true,kind:true,tag:true,method:true,status:true,url:true,actions:false};
           try{ localStorage.setItem('logtap:cols', JSON.stringify(allTrue)); }catch{}
           applyCols(allTrue);

           // Clear active stat chip highlight
           highlightChip(null);
           // Reset column widths to defaults
           resetColWidths();
         });
         
         // Close when clicking outside
         window.addEventListener('click', (e) => {
           if (!settingsPanel || settingsPanel.classList.contains('hidden')) return;
           if (!settingsPanel.contains(e.target) && e.target !== settingsBtn && !settingsBtn.contains(e.target)) {
             toggleSettings(false);
           }
         });
         
         // Close on Escape
         window.addEventListener('keydown', (e) => {
           if (e.key === 'Escape') toggleSettings(false);
         });

         // Make the Columns section a grid without touching HTML
         (function(){
           try{
             const secs = document.querySelectorAll('#settingsPanel .sp-section');
             secs.forEach(sec => {
               const h = sec.querySelector('h4');
               if (h && /columns/i.test(h.textContent || '')) {
                 sec.classList.add('cols-grid');
               }
             });
           }catch(e){ console.warn('Columns grid setup failed', e); }
         })();
                              
     // --- WebSocket with auto-reconnect ---
          const setWs = (text, cls)=> { if(wsStatus){ wsStatus.textContent = text; wsStatus.classList.remove('status-on','status-off','status-connecting'); if(cls) wsStatus.classList.add(cls); } };
          let ws = null;
          let wsReconnectAttempts = 0;
          function fetchMissed(){
            try {
              const lastId = rows.length ? rows[rows.length - 1].id : 0;
              if(!lastId) return; // nothing yet
              fetch('/api/logs?sinceId='+lastId+'&limit=2000').then(r=> r.ok ? r.json() : []).then(arr => {
                if(Array.isArray(arr) && arr.length){
                  for(const ev of arr){ rows.push(ev); if(matchesFilters(ev)){ tbody.appendChild(renderRow(ev)); } }
                  if(autoScroll?.checked) tbody.lastElementChild?.scrollIntoView({block:'end'});
                  renderStats();
                }
              }).catch(()=>{});
            } catch(e) { /* ignore */ }
          }
          function connectWs(){
            setWs('● Connecting…','status-connecting');
            const url = (location.protocol==='https:'?'wss':'ws')+'://'+location.host+'/ws';
            try { if(ws){ try{ ws.close(); }catch{} } } catch {}
            try {
              ws = new WebSocket(url);
            } catch(err){
              console.warn('[LogTap] WS create failed', err);
              scheduleReconnect();
              return;
            }
            ws.addEventListener('open', () => {
              setWs('● Connected','status-on');
              const firstConnect = (wsReconnectAttempts === 0);
              wsReconnectAttempts = 0; // reset attempts after success
              if(!firstConnect){ fetchMissed(); }
            });
            
            function scheduleReconnect(){
              setWs('● Disconnected','status-off');
              const attempt = wsReconnectAttempts++;
              // Exponential-ish backoff: 0->1s,1->1.6s,2->2.5s,3->4s,... capped at 15s
              const delay = Math.min(15000, Math.round(1000 * Math.pow(1.6, attempt)));
              // Update status to show reconnection intent (optional)
              if(wsStatus){ wsStatus.textContent = '● Reconnecting in '+Math.ceil(delay/1000)+'s…'; }
              setTimeout(()=>{ connectWs(); }, delay);
            }
            ws.addEventListener('close', () => scheduleReconnect());
            ws.addEventListener('error', () => scheduleReconnect());
            ws.onmessage = (e)=>{
              try{ const ev = JSON.parse(e.data); rows.push(ev); if(matchesFilters(ev)){ tbody.appendChild(renderRow(ev)); if(autoScroll?.checked) tbody.lastElementChild?.scrollIntoView({block:'end'}); renderStats(); } }
              catch(parseErr){ console.warn('[LogTap] bad WS payload', parseErr); }
            };
          }
          function scheduleReconnect(){ /* fallback ref for early failures */ setTimeout(()=> connectWs(), 1500); }
          connectWs();

         // Load saved drawer width and enable drag to resize
         loadDrawerWidth();
         drawerResizer?.addEventListener('mousedown', (e)=>{ e.preventDefault(); startResize(e); });
         bootstrap();
         document.addEventListener('DOMContentLoaded', () => {
           try{ installColumnResizers(); }catch(e){ console.warn('column resizer init failed', e); }
         });
    """#
}

