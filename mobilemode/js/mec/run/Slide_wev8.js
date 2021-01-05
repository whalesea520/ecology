Mobile_NS.Slide = {};

Mobile_NS.Slide.onload = function(p){
	var theId = p["id"];
	var slideId = "silde" + theId;
	
	var picItems = p["pic_items"];
	
	var sildeCount = picItems.length;
	if(sildeCount <= 1){	/*只有一张图片，不作为幻灯片显示*/
		$("#"+slideId+"").css("visibility", "visible");
		$("#"+slideId+" .slide-point").hide();
		$("#"+slideId+" .slide-overlay").hide();
	}else{
		var auto = p["auto"] || 0;
		auto = auto * 1000;
		
		var params = {
			continuous: true,
			disableScroll: true,
			stopPropagation: true,
			callback: function(index, element) {
				/*插件在元素数量为2的时候会将前后克隆一个元素，即4个。这将导致index不准*/
				if(sildeCount == 2){
					index = index % 2;
				}
				$("#"+slideId+" .slide-point b").removeClass("currPoint");
				$("#"+slideId+" .slide-point b").eq(index).addClass("currPoint");
			},
			transitionEnd: function(index, element) {
				var that = $(element);
				var $img = $("img", that);
				Mobile_NS.Slide.loadImg($img);
			}
		};
		if(auto > 0){
			params["auto"] = auto;
		}
		Swipe(document.getElementById(slideId), params);
		Mobile_NS.Slide.loadImg($("#" + slideId + " .swipe-wrap img").eq(0));
	}
}

Mobile_NS.Slide.loadImg = function($img){
	if($img.length > 0 && $img.attr("lazy-src")){
		var lazysrc = $img.attr("lazy-src");
		var $overlay = $img.siblings(".slide-overlay");
		$img.removeAttr("lazy-src").attr("src", lazysrc);
		$img.bind("load", function(){
			$overlay.hide();
        });
        $img.bind("error", function(){
        	$overlay.hide();
        });
	}
}
