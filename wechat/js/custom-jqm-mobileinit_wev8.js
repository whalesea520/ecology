(function($) {
	  //自定义
	  $(document).bind('mobileinit', function(e) {
		  $.extend($.mobile,{
			  ajaxEnabled:false,
			  ajaxFormsEnabled:false,
			  ajaxLinksEnabled:false
		});
	  });
})(jQuery);

//读取cookies函数
function getCookie(name)
{
  var arr = document.cookie.match(new RegExp("(^| )"+name+"=([^;]*)(;|$)"));
  if(arr != null) return decodeURI(arr[2]); return null;
}