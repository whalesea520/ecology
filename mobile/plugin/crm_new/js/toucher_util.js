
var ToucherUtil = {
	
	swipeList : function(selector, btnSelector){
		
		var $list;
		if(typeof selector === "string"){
			$list = $(selector);
		}else if(selector instanceof $){
			$list = selector;
		}else{
			$list = $(selector);
		}
		
		var type = $list.attr("swipeType");
		if(!type || type == ""){
			type = "1";
		}
		$list.children("li").each(function(){
			var $li = $(this);
			if($li.attr('swipe_event') != "true"){
				
				var liTouch = util.toucher($li[0]);
				
				liTouch.on('swipeLeft',function(e){
					
					var $theLi = $(this);
					
					var pdFn = function(e){
						e.preventDefault();
					};
					
					$theLi[0].addEventListener('touchmove', pdFn, false);
					setTimeout(function(){
						$theLi[0].removeEventListener("touchmove", pdFn, false);
					}, 300);
					
					
					//向左滑动时先复原其他已被划出的LI
					$theLi.siblings("[is_swiped='true']").trigger("swipeRight");
					
					var $slideBtnContainer = $(btnSelector, $theLi);
					var w = $slideBtnContainer.width();
					
					var $liContent = $theLi.children().eq(0);
					if(type == "1"){
						$liContent.css({
							"-webkit-transform" : "translate3d(-"+w+"px, 0, 0)",
							"transform" : "translate3d(-"+w+"px, 0, 0)"
						});
						$slideBtnContainer.addClass("show");
					}else if(type == "2"){
						$slideBtnContainer.addClass("show");
					}
					$theLi.attr("is_swiped", "true");
				});
				
				var rightFn = function(e){
					var $theLi = $(this);
					
					var pdFn = function(e){
						e.preventDefault();
					};
					
					$theLi[0].addEventListener('touchmove', pdFn, false);
					setTimeout(function(){
						$theLi[0].removeEventListener("touchmove", pdFn, false);
					}, 300);
					
					var $slideBtnContainer = $(btnSelector, $theLi);
					var $liContent = $theLi.children().eq(0);
					var w = $slideBtnContainer.width();
					
					if(type == "1"){
						$slideBtnContainer.removeClass("show");
						$liContent.css({
							"-webkit-transform" : "translate3d(0, 0, 0)",
							"transform" : "translate3d(0, 0, 0)"
						});
					}else if(type == "2"){
						$slideBtnContainer.removeClass("show");
					}
					$theLi.removeAttr("is_swiped");
				};
				
				liTouch.on('swipeRight', rightFn);
				$li.live('swipeRight', rightFn)
			}
		});
		
		$list.children("li").attr("swipe_event", "true");

	}
};