/*!
 * @name 星海音乐源
 * @description 由GDAPI制作的洛雪音乐源
 
 * @version v2.2.8
 * @author 万去了了 问题反馈https://zrcdy.dpdns.org/lx/fk/index.php
 * @homepage https://zrcdy.dpdns.org/
 * @lastUpdate 2025-2-13
 */

// ============================ 核心配置 ============================
const UPDATE_CONFIG = {
  versionApiUrl: 'https://zrcdy.dpdns.org/lx/version.php',
  latestScriptUrl: 'https://zrcdy.dpdns.org/lx/index.html',
  currentVersion: 'v2.2.8'
};

// 动态稳定源接口
const STABLE_SOURCES_API_URL = 'https://zrcdy.dpdns.org/lx/stable_sources.php';

// 主API - GD Studio
const MAIN_API_BASE = 'https://music-api.gdstudio.xyz/api.php?use_xbridge3=true&loader_name=forest&need_sec_link=1&sec_link_scene=im&theme=light';

// ============================ 全局状态 ============================
let musicSourceEnabled = true;
let serverCheckCompleted = false;

let stableSourcesList = null;          // 服务器返回的稳定源，如 ['netease','kuwo','tencent']
let mainApiSourceMap = {};            // 动态主API映射 { wy: 'netease', tx: 'tencent', kw: 'kuwo', ... }
let availablePlatforms = [];          // 最终可用的平台代码（仅来自主API映射）

// ---------- 音质支持（各平台原生）----------
const MUSIC_QUALITY = {
  wy: ['128k', '192k', '320k', 'flac', 'flac24bit'],
  tx: ['128k', '192k', '320k', 'flac', 'flac24bit'],
  kw: ['128k', '192k', '320k', 'flac', 'flac24bit'],
  kg: ['128k', '192k', '320k', 'flac', 'flac24bit'],
  mg: ['128k', '192k', '320k', 'flac']
};

const PLATFORM_NAME_MAP = {
  wy: '网易云音乐',
  tx: 'QQ音乐',
  kw: '酷我音乐',
  kg: '酷狗音乐',
  mg: '咪咕音乐'
};

const { EVENT_NAMES, request, on, send } = globalThis.lx;

// ============================ 工具函数 ============================
function log(...args) { console.log(...args); }
function delay(ms) { return new Promise(resolve => setTimeout(resolve, ms)); }

function logSimple(action, source, musicInfo, status, extra = '') {
  const songName = musicInfo.name || '未知歌曲';
  log(`[${action}] 平台:${source} | 歌曲:${songName} | 状态:${status}${extra ? ' | ' + extra : ''}`);
}

/**
 * 音质降级映射
 */
function mapQuality(targetQuality, availableQualities) {
  const priorityMap = {
    '臻品母带': 'flac24bit', '臻品音质2.0': 'flac24bit', '臻品音质': 'flac24bit',
    'Hires 无损24-Bit': 'flac24bit', 'FLAC': 'flac', '320k': '320k', '192k': '192k', '128k': '128k'
  };
  if (availableQualities.includes(targetQuality)) return targetQuality;
  const mapped = priorityMap[targetQuality];
  if (mapped && availableQualities.includes(mapped)) return mapped;
  const order = ['flac24bit', 'flac', '320k', '192k', '128k'];
  for (const q of order) if (availableQualities.includes(q)) return q;
  return availableQualities[0] || '128k';
}

/**
 * 统一网络请求
 */
const httpFetch = (url, options = { method: 'GET' }) => {
  return new Promise((resolve, reject) => {
    const cancelRequest = request(url, options, (err, resp) => {
      if (err) return reject(new Error(`网络请求异常：${err.message}`));
      let body = resp.body;
      if (typeof body === 'string') {
        const trimmed = body.trim();
        if (trimmed.startsWith('{') || trimmed.startsWith('[') || trimmed.startsWith('"')) {
          try { body = JSON.parse(trimmed); } catch (e) {}
        }
      }
      resolve({ body, statusCode: resp.statusCode, headers: resp.headers || {} });
    });
  });
};

/**
 * 版本比较
 */
const compareVersions = (remoteVer, currentVer) => {
  const r = remoteVer.replace(/^v/, '').split('.').map(Number);
  const c = currentVer.replace(/^v/, '').split('.').map(Number);
  for (let i = 0; i < Math.max(r.length, c.length); i++) {
    if ((r[i] || 0) > (c[i] || 0)) return true;
    if ((r[i] || 0) < (c[i] || 0)) return false;
  }
  return false;
};

// ============================ 动态稳定源获取 ============================
const fetchStableSources = async () => {
  log('正在获取服务器稳定源列表...');
  try {
    const resp = await httpFetch(STABLE_SOURCES_API_URL, {
      method: 'GET', timeout: 5000,
      headers: { 'User-Agent': 'LX-Music-Mobile/星海音乐源' }
    });
    if (resp.statusCode !== 200) throw new Error(`HTTP ${resp.statusCode}`);
    let data = resp.body;
    if (typeof data === 'string') {
      try { data = JSON.parse(data); } catch (e) { throw new Error('JSON解析失败'); }
    }
    if (!Array.isArray(data) || data.length === 0) throw new Error('返回数据非数组或为空');
    stableSourcesList = data;
    log('✅ 获取稳定源成功:', stableSourcesList);
  } catch (err) {
    log('❌ 获取稳定源失败，使用默认值 [netease, kuwo]:', err.message);
    stableSourcesList = ['netease', 'kuwo'];
  }
};

/**
 * 根据稳定源列表构建主API映射和可用平台列表
 * 仅使用主API，忽略任何备用源
 */
const buildPlatformsFromStableSources = () => {
  // 可转换的映射（仅包含GD Studio API明确支持且实测可用的组合）
  const sourceToCode = {
    netease: 'wy',
    tencent: 'tx',
    kuwo: 'kw',
    kugou: 'kg',
    migu: 'mg'
  };

  // 1. 主API映射：只有稳定源中存在且能转换的才会加入
  mainApiSourceMap = {};
  stableSourcesList.forEach(src => {
    const code = sourceToCode[src];
    if (code) mainApiSourceMap[code] = src;
  });

  // 2. 可用平台仅来自主API映射（不再合并备用平台）
  availablePlatforms = Object.keys(mainApiSourceMap).filter(code => MUSIC_QUALITY[code]);

  // 3. 特殊降级：如果稳定源只有网易云+酷我（或获取失败），确保平台列表正确
  if (stableSourcesList.length === 2 &&
      stableSourcesList.includes('netease') &&
      stableSourcesList.includes('kuwo') &&
      !stableSourcesList.includes('tencent')) {
    // 此时映射应只包含 wy 和 kw（已在上面生成，但显式确保）
    availablePlatforms = ['wy', 'kw'];
    mainApiSourceMap = { wy: 'netease', kw: 'kuwo' };
  }

  log('主API映射:', mainApiSourceMap);
  log('可用平台:', availablePlatforms);
};

// ============================ 服务器状态检查 ============================
const checkServerStatus = async () => {
  log('正在检查服务器连接状态...');
  for (let attempt = 0; attempt <= 2; attempt++) {
    if (attempt > 0) await delay(1000);
    try {
      const resp = await httpFetch('https://zrcdy.dpdns.org/lx/status.php', {
        method: 'GET', timeout: 5000,
        headers: { 'User-Agent': 'LX-Music-Mobile/星海音乐源', 'Accept': 'application/json' }
      });
      if (resp.statusCode !== 200) throw new Error(`HTTP状态码异常: ${resp.statusCode}`);
      let data = resp.body;
      if (typeof data === 'string') {
        try { data = JSON.parse(data); } catch (e) { throw new Error('JSON解析失败'); }
      }
      if (!data || typeof data !== 'object') throw new Error('无效数据格式');
      const enabled = data.enabled !== false;
      log(`服务器连接状态: ${enabled ? '服务正常' : '服务受限'}`);
      return { enabled, message: data.message || (enabled ? '服务正常' : '服务暂时不可用'), error: null };
    } catch (err) {
      log(`服务器连接检查失败(第${attempt + 1}次):`, err.message);
      if (attempt === 2) {
        log('服务器连接检查多次失败，使用本地模式');
        return { enabled: true, message: `服务器连接失败，使用本地模式: ${err.message}`, error: err.message };
      }
    }
  }
  return { enabled: true, message: '未知错误，使用本地模式', error: '未知错误' };
};

// ============================ 自动更新 ============================
const checkAutoUpdate = async () => {
  if (!musicSourceEnabled) return;
  try {
    const resp = await httpFetch(UPDATE_CONFIG.versionApiUrl, {
      timeout: 10000,
      headers: { 'Content-Type': 'application/json', 'User-Agent': 'LX-Music-Mobile' }
    });
    if (resp.statusCode !== 200) return;
    let data = resp.body;
    if (typeof data === 'string') {
      try { data = JSON.parse(data.trim().replace(/^\uFEFF/, '')); } catch (e) { return; }
    }
    if (!data || typeof data !== 'object') return;
    const remoteVer = data.version || data.VERSION || data.ver;
    if (!remoteVer) return;
    const changelog = data.changelog || data.changelog || '暂无更新日志';
    const minReq = data.min_required || data.minRequired || 'v1.0.0';
    const updateUrl = data.update_url || data.updateUrl || UPDATE_CONFIG.latestScriptUrl;
    const needUpdate = compareVersions(remoteVer, UPDATE_CONFIG.currentVersion);
    if (needUpdate) {
      log('发现新版本:', remoteVer, '当前版本:', UPDATE_CONFIG.currentVersion);
      const force = compareVersions(remoteVer, minReq) && compareVersions(minReq, UPDATE_CONFIG.currentVersion);
      const msg = `【星海音乐源更新通知】\n当前版本：${UPDATE_CONFIG.currentVersion}\n最新版本：${remoteVer}\n\n更新内容：\n${changelog}${force ? '\n\n⚠️ 此版本需要强制更新，请立即更新以正常使用' : ''}`;
      send(EVENT_NAMES.updateAlert, {
        log: msg, updateUrl,
        confirmText: '立即更新',
        cancelText: force ? '退出应用' : '暂不更新'
      });
    }
  } catch (err) { log('更新检查失败:', err.message); }
};

// ============================ 音频地址解析（仅主API）============================
const getMusicUrlFromMainAPI = async (source, songId, apiQuality) => {
  const apiSource = mainApiSourceMap[source];
  if (!apiSource) throw new Error('当前平台不在主API稳定源中');
  const url = `${MAIN_API_BASE}&types=url&source=${apiSource}&id=${songId}&br=${apiQuality}`;
  const resp = await httpFetch(url, {
    method: 'GET',
    headers: { 'User-Agent': 'LX-Music-Mobile', 'Accept': 'application/json' }
  });
  const data = typeof resp.body === 'object' ? resp.body : JSON.parse(resp.body);
  if (!data.url) throw new Error('音频解析失败');
  return data.url;
};

const handleGetMusicUrl = async (source, musicInfo, quality) => {
  if (!musicSourceEnabled) throw new Error('服务暂时不可用');
  if (!serverCheckCompleted) throw new Error('服务初始化中，请稍后');
  if (!availablePlatforms.includes(source)) {
    throw new Error(`当前平台 "${source}" 不可用（未在服务器稳定源中）`);
  }

  logSimple('解析音频地址', source, musicInfo, '开始');
  const songId = musicInfo.hash ?? musicInfo.songmid ?? musicInfo.id;
  if (!songId) throw new Error('歌曲信息不完整');

  const avail = MUSIC_QUALITY[source] || ['128k', '192k', '320k', 'flac'];
  const actual = mapQuality(quality, avail);
  if (actual !== quality) log(`音质自动映射: ${quality} -> ${actual}`);

  let finalUrl = null;
  let lastErr = null;

  // 仅尝试主API
  try {
    const brMap = { '128k': '128', '192k': '192', '320k': '320', 'flac': '740', 'flac24bit': '999' };
    const apiBr = brMap[actual] || '320';
    finalUrl = await getMusicUrlFromMainAPI(source, songId, apiBr);
    logSimple('解析音频地址', source, musicInfo, '成功(主API)');
  } catch (err) {
    lastErr = err;
    logSimple('解析音频地址', source, musicInfo, '主API失败', err.message);
  }

  if (!finalUrl) {
    const msg = `无法获取音频地址：${lastErr ? lastErr.message : '未知错误'}`;
    logSimple('解析音频地址', source, musicInfo, '完全失败', msg);
    throw new Error(msg);
  }
  return finalUrl;
};

// ============================ 构建音乐源对象 ============================
const buildMusicSources = (platforms) => {
  const sources = {};
  platforms.forEach(code => {
    sources[code] = {
      name: PLATFORM_NAME_MAP[code] || code,
      type: 'music',
      actions: ['musicUrl'],
      qualitys: MUSIC_QUALITY[code]
    };
  });
  return sources;
};

// ============================ 事件监听 ============================
on(EVENT_NAMES.request, ({ action, source, info }) => {
  if (action !== 'musicUrl') return Promise.reject(new Error('不支持的操作类型'));
  if (!info?.musicInfo || !info.type) return Promise.reject(new Error('请求参数不完整'));
  return handleGetMusicUrl(source, info.musicInfo, info.type);
});

// ============================ 初始化 ============================
(async () => {
  log('========================================');
  log('星海音乐源 v2.2.8 初始化（仅主API模式）');
  log('========================================');

  try {
    const server = await checkServerStatus();
    musicSourceEnabled = server.enabled;
    if (!musicSourceEnabled) {
      log('⚠️ 服务器状态异常，服务受限:', server.message);
      throw new Error(server.message || '音乐服务已禁用');
    }

    await fetchStableSources();
    buildPlatformsFromStableSources();
    serverCheckCompleted = true;

    const sources = buildMusicSources(availablePlatforms);
    send(EVENT_NAMES.inited, { status: true, openDevTools: false, sources, initStatus: 'ready' });

    log('✅ 初始化完成，可用平台:', availablePlatforms.join(', '));
    setTimeout(checkAutoUpdate, 3000);
  } catch (err) {
    log('❌ 初始化异常，进入降级模式:', err.message);
    // 降级：仅启用网易云+酷我（稳定源固定为netease,kuwo）
    stableSourcesList = ['netease', 'kuwo'];
    buildPlatformsFromStableSources();
    musicSourceEnabled = true;
    serverCheckCompleted = true;
    const sources = buildMusicSources(availablePlatforms);
    send(EVENT_NAMES.inited, { status: true, openDevTools: false, sources, initStatus: 'degraded' });
    log('降级模式完成，仅支持网易云、酷我');
    setTimeout(checkAutoUpdate, 3000);
  }
})();