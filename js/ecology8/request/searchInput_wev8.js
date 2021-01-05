/**
* Author bpf
*/
(function ($) {
	$.fn.searchInput = function (options) {
		var searchInput=$(this);
		searchInput.css("vertical-align","top");
		searchInput.addClass("searchInput");
		searchInput.wrap("<span id='searchblockspan'><span class='searchInputSpan' style='position:relative;'></span></span>");
		var searchImg=$("<span class='middle searchImg'><img class='middle' style='vertical-align:top;margin-top:2px;' src='/images/ecology8/request/search-input_wev8.png'/></span>");
		if(options!=null){
			var searchFn=options.searchFn;
			if(searchFn!=null && searchFn!=undefined){
				searchInput.keyup(function(e){
					if(e.keyCode==13){
						searchFn(searchInput.val(),options.params);
					};
				});
				searchImg.click(function(){
					searchFn(searchInput.val(),options.params);
					return false;
				});
			}
		}
		searchInput.after(searchImg);
		if(searchImg.closest("span.leftSearchSpan").length>0){
			searchImg.css({
				"position":"absolute",
				"right":"0px"
			});
		}
		var key = 0;
		var _width = 0;
		searchInput.parent().hover(function(){
			_width = jQuery(this).width();
			searchInput.addClass("inputing");
			searchInput.focus();
			jQuery(this).addClass("searchImg_hover");
		},function(e){
				searchInput.removeClass("inputing");
				//searchInput.blur();
				jQuery(this).removeClass("searchImg_hover");
				var $this = this;
		});
		jQuery(document).bind("click",function(e){
			var event = e;
			var srcElement = null;
			if(window.event){
				event = window.event;
				srcElement = event.srcElement
			}else{
				srcElement = event.target;
			}
			if(jQuery(srcElement).closest("span.searchInputSpan").length==0){
				searchInput.removeClass("inputing");
				searchInput.blur();
				jQuery("span.searchInputSpan").removeClass("searchImg_hover");
			}
		});
	};
})(jQuery);

