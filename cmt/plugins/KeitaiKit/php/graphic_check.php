<html>
   <head>
      <title>ケータイキット for Movable Type グラフィックWebサービスチェックツール</title>
      <script type="text/javascript">
      <!--
         function onSubmit(theForm) {
            if(theForm.wallpaper_on.checked) {
               var style = theForm.wallpaper_style.options[theForm.wallpaper_style.selectedIndex].value;
               var fill = theForm.wallpaper_fill.value;
               var serialized = 'a:2:{s:5:"style";s:' + style.length + ':"' + style + '";'
                  + 's:4:"fill";s:' + fill.length + ':"' + fill + '";}';
               theForm.wallpaper.value = serialized;
            } else {
               theForm.wallpaper.value = null;
            }
            return true;
         }
      -->
      </script>
   </head>
   <body>
      <form action="graphic.php" method="GET" onsubmit="onSubmit(this);">
         <dl>
            <dt>URL</dt>
            <dd><input type="text" size="40" name="url" value="" /></dd>

            <dt>スクリーン幅</dt>
            <dd><input type="text" size="10" name="sw" value="240" /> ピクセル</dd>

            <dt>スクリーン高さ</dt>
            <dd><input type="text" size="10" name="sh" value="320" /> ピクセル</dd>

            <dt>カラー</dt>
            <dd>
               <select name="c">
                  <option value="1">モノクロ</option>
                  <option value="2">4色</option>
                  <option value="3">256色</option>
                  <option value="4">4k色</option>
                  <option value="5">64k色</option>
                  <option value="6" selected>256K色</option>
                  <option value="7">16M色</option>
               </select>
            </dd>

            <dt>イメージフォーマット</dt>
            <dd>
               <select name="img">
                  <option value="3">iモード(GIF/Jpeg)</option>
                  <option value="2">旧型iモード(GIF)</option>
                  <option value="3">EZweb(GIF/Jpeg)</option>
                  <option value="8">ソフトバンク(PNG/Jpeg)</option>
                  <option value="9">旧型ソフトバンク(PNG)</option>
               </select>
            </dd>

            <dt>フィット</dt>
            <dd>
               <select name="fit">
                  <option value="">なし</option>
                  <option value="left">左</option>
                  <option value="center">中央</option>
                  <option value="right">右</option>
               </select>
            </dd>

            <dt>サムネイルモード</dt>
            <dd><input type="text" size="10" name="thumbnail" value="" /> ピクセル</dd>

            <dt>キャッシュサイズ</dt>
            <dd><input type="text" size="10" name="kg_cache_size" value="102400" /> バイト</dd>

            <dt>形式ごとのキャッシュサイズ</dt>
            <dd>
               <select name="kg_cache_size_by_format">
                  <option value="">なし</option>
                  <option value="<?php echo serialize(array('GIF' => 25600)); ?>">EZweb(GIFは25Kまで)</option>
               </select>
            </dd>

            <dt>Jpegクオリティ</dt>
            <dd><input type="text" size="10" name="kg_jpeg_quality" value="75" /> %</dd>

            <dt>著作権保護</dt>
            <dd>
               <select name="copyright">
                  <option value="">なし</option>
                  <option value="iモード">iモード</option>
                  <option value="EZweb">EZweb</option>
                  <option value="ソフトバンク">ソフトバンク</option>
               </select>
            </dd>
            
            <dt><input type="checkbox" name="wallpaper_on" /> 待ち受け画像</dt>
            <dd>
               <input type="hidden" name="wallpaper" />
               <select name="wallpaper_style">
                  <option value="chop">切り抜き</option>
                  <option value="fill">余白</option>
                </select>
                余白色: <input type="text" name="wallpaper_fill" vlaue="ffffff" />
            </dd>

            <dd><input type="submit" /></dd>
         </dl>
      </form>
   </body>
</html>