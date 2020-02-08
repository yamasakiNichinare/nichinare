jQuery.noConflict();  
jQuery(document).ready(function($){


	// スライド画像プリロード
	$('<img src="common/images/slider/p1.jpg">');
	$('<img src="common/images/slider/p2.jpg">');
	$('<img src="common/images/slider/p3.jpg">');
	$('<img src="common/images/slider/p4.jpg">');
	$('<img src="common/images/slider/p5.jpg">');
	$('<img src="common/images/slider/p6.jpg">');
	$('<img src="common/images/slider/p7.jpg">');
	
	// 右下サムネプリロード
	$('<img src="common/images/slider/thumbs/s01.jpg">');
	$('<img src="common/images/slider/thumbs/s02.jpg">');
	$('<img src="common/images/slider/thumbs/s03.jpg">');
	$('<img src="common/images/slider/thumbs/s04.jpg">');
	$('<img src="common/images/slider/thumbs/s05.jpg">');
	$('<img src="common/images/slider/thumbs/s06.jpg">');
	$('<img src="common/images/slider/thumbs/s07.jpg">');		
});





// bxPlugin

jQuery(document).ready(function($){
   

   
   var obj = $("#slider").bxSlider({
        pagerCustom: "#new_pager", // Slider右下箇所のサムネ
		mode:        "fade", // スライドの切り替えをフェードで行う
		pause: 		 6500,
        speed:       1000, // スライドの変わる速度
		controls: false, // next等を非表示に
		auto: true, // 自動でスライドが動くように
		autoHover:true, // マウスポインターをスライド上に乗せると自動スライド停止
		onSlideAfter: function () { obj.startAuto(); }
    });
});
