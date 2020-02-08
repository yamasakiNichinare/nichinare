// 自URLクエリーセットのリンク付加又はリダイレクト処理
function setQueryRedirect(inputString) {
	// クエリー文字列を取得
	var queryString = window.location.search.substring(0);
	// 現在のリンク先URL編集用
	var srcURL;
	// リダイレクト先URL編集用
	var redirectURL = inputString;
	// カウンタ
	var i;
	// スマートフォンかエージェント判定
	if((navigator.userAgent.indexOf('iPhone') > 0 &&
		navigator.userAgent.indexOf('iPad') == -1) ||
		navigator.userAgent.indexOf('iPod') > 0 ||
		navigator.userAgent.indexOf('Android') > 0) {
		redirectURL += queryString;
		// リダイレクトURLを編集
		window.document.location.href = redirectURL;
	} else {
		// リンク配列分繰り返し
		for(i = 0; i < window.document.links.length; i ++) {
			// 現在のリンク先URLを一旦格納
			srcURL = window.document.links[i].href;
			// クエリ文字列を編集用文字列に追加
			srcURL += queryString;
			// リンク先に再設定
			window.document.links[i].href = srcURL;
		}
	}
}
