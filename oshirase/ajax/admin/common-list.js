( function( $ ){

  $(document).ready(function(){
    /* 小窓を開く */
    $('a.ow, a[ow_option]').click( function (){
      var opt = read_option( $(this).attr('ow_option'), '350,350' );
      var t =  $(this).attr('target') || 'sw';
      window.open( this.href, t, 'resizable=yes,scrollbars=yes,width='+opt[0]+',height='+opt[1]).focus();
      return false;
    });

    /* 小窓を開く */
    $('form.ow, form[ow_option]').submit( function (){
      var opt = read_option( $(this).attr('ow_option'), '350,350' );
      var t =  $(this).attr('target') || 'sw';
      window.open( '', t, 'resizable=yes,scrollbars=yes,width='+opt[0]+',height='+opt[1]).focus();
      this.target = 'sw';
    });

    /* 画面遷移なしで送信処理 */
    $('form.hw').submit( function (){

      var check = $(this).attr('check');
      var conf = $(this).attr('confirm');
      var success = $(this).attr('success');

      if ( check && !eval(check) ) return false;
      if ( conf && !confirm(conf) ) return false;

      $.ajax({
        url : this.action,
        data: $(this).serialize(),
        type: 'post',
        success : function(){
          if ( success  ) { alert(success); }
          else { document.location.reload(true); }
        } // success
      }); // $.ajax

      return false;
    });

    /* koukai切り替え(ajax) */
    $('a.hw').click( function (){
      var $$ = $(this);
      var param = new String(this.href).match(/(.*?)\?(.*)/);

      $.ajax({
        url : param[1],
        data: param[2],
        type: 'post',
        success : function(text){
          if ( new String($$.html()).match(/公開/) ) {
            if ( text==0 ){
              $$.html('非公開');
              $$.removeClass('koukai-1');
              $$.addClass('koukai-0');
            }else {
              $$.html('公開');
              $$.removeClass('koukai-0');
              $$.addClass('koukai-1');
             }
          }else {
            document.location.reload(true) ;
          }
        }
      }); // $.ajax

      return false;
    });

    /* ストライプ */
    $("table.stripe tr:odd").addClass("odd");
    $("table.stripe tr").hover( function () { $(this).addClass("hover") }, function () { $(this).removeClass("hover") } );

  });//ready

})(jQuery);

var pageSeek = function (sk) {
  jQuery('#sk').val(sk);
  jQuery('#skForm').submit();
}

var pageSort = function (key) {
  jQuery('#SortN').val(key);
  jQuery('#skForm').submit();
}
