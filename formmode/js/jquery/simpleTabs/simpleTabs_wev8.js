(function ($) {
    
    $.fn.simpleTabs = function (){
    	var p = window.location.pathname;
    	
    	$tabTitles = this.children("ul").children("li");
    	function contorlDisplay(){
    		$tabTitles.each(function(i){
	    		var $this = $(this);
	    		var h = $this.attr("href");
	    		if(!$this.hasClass("selected")){
	    			$(h).hide();
	    		}else{
	    			
	    			//记录到cookie当前点的是第几个tab
	    			if(typeof(FormmodeUtil) != "undefined"){
	    				FormmodeUtil.writeCookie(p, i);
	    			}
	    			
	    			$(h).show();
	    			var $iframe = $(h).children("iframe");
	    			var lazySrc = $iframe.attr("lazy-src");
	    			if(lazySrc && lazySrc != ""){
	    				if(typeof(beforeIframeLoad) == "function"){
	    					beforeIframeLoad($iframe[0]);
	    				}
	    				
	    				var onLoadedCallFn = function(){
	    					if(typeof(whenIframeOnLoad) == "function"){
	    						whenIframeOnLoad($iframe[0]);
	    					}
	    				};
	    				
	    				if(document.attachEvent){
							$iframe[0].attachEvent("onload", onLoadedCallFn);
						}else if(document.addEventListener){
							$iframe[0].addEventListener("load", onLoadedCallFn, false);
						}
	    				
	    				$iframe[0].src = lazySrc;
	    				$iframe.removeAttr("lazy-src");
	    			}else{
	    				if(typeof(chooseLoadedIframe) == "function"){
	    					chooseLoadedIframe($iframe[0]);
	    				}
	    			}
	    		}
	    	});
    	}
    	
    	//获取cookie中上次点的是第几个tab
    	var lastIndex = null;
    	if(typeof(FormmodeUtil) != "undefined"){
    		lastIndex = FormmodeUtil.readCookie(p);
    	}
    	if(lastIndex && lastIndex < $tabTitles.length){	//从cookie中设置选择
    		$tabTitles.eq(lastIndex).addClass("selected");
    	}else{	//从页面代码默认选中属性设置选中
    		$tabTitles.filter("[defaultSelected='true']").eq(0).addClass("selected");	//加个eq(0)是防止有多个defaultSelected为true的元素
    	}
    	
    	contorlDisplay();
    	
    	$tabTitles.click(function(){
    		$tabTitles.removeClass("selected");
    		$(this).addClass("selected");
    		contorlDisplay();
    	});
    	
    };
})(jQuery);