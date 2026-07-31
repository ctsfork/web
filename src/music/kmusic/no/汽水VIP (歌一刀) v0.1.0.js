// ==UserScript==
// @name        汽水VIP (歌一刀)
// @description 基于第三方接口的汽水音乐音源适配，用于 歌一刀 (LX-style).
// @version     0.1.0
// @author      歌一刀
// ==/UserScript==

(function () {
  const SOURCE_ID = 'qsvip';
  const SOURCE_NAME = '汽水VIP';

  const API_BASE = 'http://api.vsaa.cn/api/music.qishui.vip';
  const PROXY_SERVER = 'https://proxy.qishui.vsaa.cn/qishui/proxy';

  function buildQuery(params) {
    // JSCore on iOS may not have URLSearchParams; build query manually.
    const p = params || {};
    const keys = Object.keys(p);
    if (!keys.length) return '';
    const parts = [];
    for (let i = 0; i < keys.length; i++) {
      const k = keys[i];
      const v = p[k];
      if (v === undefined || v === null) continue;
      parts.push(encodeURIComponent(String(k)) + '=' + encodeURIComponent(String(v)));
    }
    return parts.length ? ('?' + parts.join('&')) : '';
  }

  function requestValues(url, options) {
    return new Promise((resolve, reject) => {
      try {
        lx.request(url, options || { method: 'GET' }, (err, resp) => {
          if (err) reject(err);
          else resolve(resp || {});
        });
      } catch (e) {
        reject(e && e.message ? e.message : String(e));
      }
    });
  }

  async function getJSON(url, params, timeoutMs) {
    const full = `${url}${buildQuery(params)}`;
    const resp = await requestValues(full, { method: 'GET', timeout: timeoutMs || 15000 });
    return resp && resp.body ? resp.body : null;
  }

  async function postJSON(url, body, timeoutMs) {
    const resp = await requestValues(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: body || {},
      timeout: timeoutMs || 60000,
    });
    return resp && resp.body ? resp.body : null;
  }

  function pickId(musicInfo) {
    if (!musicInfo) return '';
    return (
      musicInfo.id ||
      musicInfo.songmid ||
      musicInfo.songId ||
      musicInfo.hash ||
      musicInfo.rid ||
      musicInfo.mid ||
      musicInfo.strMediaMid ||
      musicInfo.mediaId ||
      ''
    ).toString();
  }

  function mapQuality(type) {
    // KMusic quality types -> api.vsaa.cn expected levels (best-effort)
    switch ((type || '').toLowerCase()) {
      case '128k':
        return 'low';
      case '320k':
        return 'standard';
      case 'flac':
        return 'lossless';
      case 'flac24bit':
        return 'hi_res';
      default:
        return 'standard';
    }
  }

  function normalizeSongItem(item) {
    // Fields consumed by KMusic JSEngine.searchSongs mapping:
    // name/singer/albumName + id-like fields.
    const id = (item && (item.id || item.vid)) ? String(item.id || item.vid) : '';
    return {
      id,
      songmid: id,
      hash: id,
      name: (item && item.name) ? String(item.name) : '未知歌曲',
      singer: (item && item.artists) ? String(item.artists) : '未知歌手',
      albumName: (item && item.album) ? String(item.album) : '',
      // duration in seconds (KMusic expects seconds)
      duration: item && item.duration ? Math.floor(Number(item.duration) / 1000) : 0,
      // Keep raw fields for potential future UI.
      pic: item && (item.cover || item.pic) ? String(item.cover || item.pic) : '',
      _raw: item || {},
    };
  }

  // Register as an LX-style source
  lx.send('inited', {
    sources: {
      [SOURCE_ID]: {
        name: SOURCE_NAME,
        type: 'music',
        actions: ['musicSearch', 'musicUrl', 'lyric'],
        qualitys: [
          { type: '128k', desc: '标准' },
          { type: '320k', desc: '高音质' },
          { type: 'flac', desc: '无损' },
          { type: 'flac24bit', desc: 'Hi-Res' },
        ],
      },
    },
  });

  lx.on('request', async ({ action, source, info }) => {
    if (source !== SOURCE_ID) return;

    if (action === 'musicSearch' || action === 'search') {
      const keyword = (info && info.keyword) ? String(info.keyword) : '';
      const page = (info && info.page) ? Number(info.page) : 1;
      const limit = (info && info.limit) ? Number(info.limit) : 30;
      if (!keyword) return { isEnd: true, list: [] };

      const res = await getJSON(API_BASE, {
        act: 'search',
        keywords: keyword,
        page,
        pagesize: limit,
        type: 'music',
      }, 15000);

      const lists = (res && res.data && Array.isArray(res.data.lists)) ? res.data.lists : [];
      const total = (res && res.data && res.data.total) ? Number(res.data.total) : lists.length;
      const isEnd = lists.length < limit;
      return { isEnd, list: lists.map(normalizeSongItem), total };
    }

    if (action === 'musicUrl') {
      const q = mapQuality(info && info.type);
      const musicInfo = (info && info.musicInfo) || {};
      const id = pickId(musicInfo);
      if (!id) return '';

      const res = await getJSON(API_BASE, { act: 'song', id, quality: q }, 20000);
      const song = (res && Array.isArray(res.data)) ? res.data[0] : (res && res.data && res.data[0]) ? res.data[0] : null;
      if (!song || !song.url) return '';

      // Some responses require decryption via proxy server.
      if (song.ekey) {
        const ext = song.codec_type ? String(song.codec_type) : 'aac';
        const proxy = await postJSON(PROXY_SERVER, {
          url: song.url,
          key: song.ekey,
          filename: song.name || 'KMusic',
          ext,
        }, 60000);
        if (proxy && Number(proxy.code) === 200 && proxy.url) {
          return String(proxy.url);
        }
        // If proxy fails, surface an empty result so the app can auto-switch sources.
        return '';
      }

      return String(song.url);
    }

    if (action === 'lyric') {
      const musicInfo = (info && info.musicInfo) || {};
      const id = pickId(musicInfo);
      if (!id) return { lyric: '' };
      const res = await getJSON(API_BASE, { act: 'song', id }, 15000);
      const song = (res && Array.isArray(res.data)) ? res.data[0] : (res && res.data && res.data[0]) ? res.data[0] : null;
      const lyric = song && song.lyric ? String(song.lyric) : '';
      return { lyric };
    }
  });
})();
