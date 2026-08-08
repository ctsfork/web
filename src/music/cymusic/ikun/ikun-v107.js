/*!
 * ikun大佬分享的源，感谢大佬无私分享。仅供学习交流使用，请勿用于商业用途。
 * @name ikun公益音源
 * @description 交流群组：https://t.me/ikunshare，690309707；未经作者授权禁止于国内公开平台传播（此处点名奇妙应用）
 * @version v107
 * @author ikun0014
 */

const API_URL = 'http://110.42.38.239:1314';
const API_KEY = ``
//getMusicUrl 函数用于获取音乐 URL。必须接受以下四个参数：songname: 歌曲名称，artist: 艺术家名称，songid: 企鹅平台的歌曲songmid，quality: 音质 '128k'|'320k'|'flac'。
async function getMusicUrl(songname,artist, songmid, quality) {

  const targetUrl = `${API_URL}/url/tx/${songmid}/${quality}`;
   try {
  const response = await fetch(targetUrl, {
    method: 'GET',
    headers: {
      'Content-Type': 'application/json',
      'User-Agent': `cy-music-request`,
      'X-Request-Key': API_KEY,
    },
  });
  const responseJson = await response.json();
  //直接返回歌曲url。请勿返回其他信息
  return responseJson.data
   } catch (e) {
       console.error(e);
       // 如果获取失败，返回null
       return null;
  }
}

module.exports = {
// 音源唯一编号
id: "ikun",
// 作者
author: "ikun0014",
// 音源显示的名称
name: "ikun公益音源",
//版本
version: "v107",
//更新地址
srcUrl: "",
//getMusicUrl方法必须导出
getMusicUrl

};