$(function(){
    $('.js-modal-open').each(function(){
        $(this).on('click',function(){
            var target = $(this).data('target');
            var modal = document.getElementById(target);
            $(modal).fadeIn();
            return false;
        });
    });
    $('.js-modal-close').on('click',function(){
        $('.modal').fadeOut();
        return false;
    });
});

$(function () {
 var headerHight = 50; //ヘッダの高さ
 $('nav ul li a').click(function(){
     var href= $(this).attr("href");
       var target = $(href == "#" || href == "" ? 'html' : href);
        var position = target.offset().top-headerHight; //ヘッダの高さ分位置をずらす
     $("html, body").animate({scrollTop:position}, 550, "swing");
        return false;
   });
});
