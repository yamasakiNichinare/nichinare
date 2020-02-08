// 自URLクエリー配列取得
function getQueryArray() {
  var queryArray = new Array();
  var query = window.location.search.substring(1);
  var parms = query.split('&');
  for(var i = 0; i < parms.length; i ++) {
    var pos = parms[i].indexOf('=');
    if(pos > 0) {
      var key = parms[i].substring(0, pos);
      var val = parms[i].substring(pos + 1);
      queryArray[key] = val;
    }
  }
  return queryArray;
}
// 自URLクエリー文字列取得
function getQueryString(queryName) {
  var queryArray = getQueryArray();
  var queryString = '';
  if(queryArray[queryName]) {
    queryString = queryArray[queryName];
  }
  return queryString;
}
// 自URLクエリーセットのリンク付加
function addLinkURL(queryName) {
  // 自URLクエリー文字列取得
  var queryString = getQueryString(queryName);
  if(queryString.length > 0) {
    // <a>タグ処理
    $("a").each(function() {
      // 変換前URL取得
      var sourceLinkURL = $(this).attr('href');
      // クエリ文字と分離
      var workArray = sourceLinkURL.split("?");
      var distLinkURL = "";
      if(workArray[0].length == sourceLinkURL.length) {
        distLinkURL = sourceLinkURL + '?' + queryName + '=' + queryString;
      } else {
        distLinkURL = sourceLinkURL + '&' + queryName + '=' + queryString;
      }
      // URL変更
      $(this).attr('href', distLinkURL);
    });
  }
}
