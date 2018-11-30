(function($){

  $(document).ready(function(){

    /* 数字の制御 */
    $('input.numeric').attr( { title:'半角数字で入力してください' } );
    $('input.numeric').css( 'ime-mode','disabled');
    $('input.numeric').keyup( function () {
      var Sanma = function (srcValue) {
        var num = new String(srcValue).replace(/,/g, "");
        while( num != ( num = num.replace( /^(-?\d+)(\d{3})/, "$1,$2" ) ) );
        return num;
      }

      var val_before = this.value ;
      var val_after = val_before.replace( /[^0-9]/g, '' ) ;
      val_after = Sanma(val_after) ;
      if ( val_before != val_after ) this.value = val_after;

    });

    /* 数字のみ可 */
    $('input.numOnly').attr( { title:'半角数字で入力してください' } );
    $('input.numOnly').css( 'ime-mode','disabled');
    $('input.numOnly').keyup( function () {
      var val_before = this.value ;
      var val_after = val_before.replace( /[^0-9]/g, '' ) ;
      if ( val_before != val_after ) this.value = val_after;
    });

    /* 日付のみ可 */
    $('input.dateOnly').attr( { title:'YYYY-MM-DD形式で入力してください' } );
    $('input.dateOnly').css( 'ime-mode','disabled');
    $('input.dateOnly').keyup( function () {
      var val_before = this.value ;
      var val_after = val_before.replace( /[^0-9-]/g, '' ) ;
      if ( val_before != val_after ) this.value = val_after;
    });

    $('input.dateOnly').each( function () {
      var opt = read_option( $(this).attr('cal_option'), '0,2,2' );

      $(this).datepicker({
        dateFormat  :'yy-mm-dd',
        monthNames  : ['1&#26376;', '2&#26376;', '3&#26376;', '4&#26376;', '5&#26376;', '6&#26376;', '7&#26376;', '8&#26376;', '9&#26376;', '10&#26376;', '11&#26376;', '12&#26376;' ],
        dayNamesMin : ['&#26085;', '&#26376;', '&#28779;', '&#27700;', '&#26408;', '&#37329;', '&#22303;' ],
        nextText    : '&#27425;&#26376;&#x3e;',
        prevText    : '&#x3c;&#21069;&#26376;',
        currentText : '&#20170;&#26085;',
        defaultDate : 30*parseInt(opt[0]),
        numberOfMonths   : parseInt(opt[1]),
        stepMonths       : parseInt(opt[2])
      });

    });

    $('input.dateOnly').change( function () {
      var val = this.value.match(/^(\d+)\-(\d+)\-(\d+)$/);
      if ( !val ){ this.value = ''; return ; }
      var yy = val[1];
      var mm = val[2];
      var dd = val[3];
      mm = mm.replace( /^0/, '' );
      dd = dd.replace( /^0/, '' );
      yy = parseInt(yy);
      mm = parseInt(mm);
      dd = parseInt(dd);
      var error = 0;
      if ( yy < 1000 || yy > 2037 ) error=1;
      if ( !( mm >= 1 && mm <= 12) ) error=2;
      if ( !error ) {
        var dd_max ;
        if ( mm != 2 ) {
          dd_max = new Array( 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 )[mm];
        }
        else{
          dd_max = ( ( yy % 4 == 0 && yy % 100 != 0 ) || yy % 400 == 0 ) ? 29 : 28;
        }

        if ( !( dd >= 1 && dd <= dd_max) ) error=3 ;
      }
      if (error) this.value = '' ;
    });

    $('input.birthday').focus( function () {
      $(this).datepicker({
        dateFormat  :'yy-mm-dd',
        monthNamesShort : ['1&#26376;', '2&#26376;', '3&#26376;', '4&#26376;', '5&#26376;', '6&#26376;', '7&#26376;', '8&#26376;', '9&#26376;', '10&#26376;', '11&#26376;', '12&#26376;' ],
        dayNamesMin : ['&#26085;', '&#26376;', '&#28779;', '&#27700;', '&#26408;', '&#37329;', '&#22303;' ],
        currentText : '&#20170;&#26085;',
        changeYear  : true,
        changeMonth : true,
        yearRange   : '-80:+10'
      });
    });

  });//ready

})(jQuery);

var is_mail_addr = function (str) {
  return str.match( /^[a-zA-Z0-9_\/\-.\+\?\[\]]+\@[a-zA-Z0-9_\.\-]+\.\w+$/)
}
