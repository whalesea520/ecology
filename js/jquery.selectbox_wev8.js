(function($){
		$.fn.selectbox = function(options){
			var options = jQuery.extend({
						pageSize:10,
						pageId:"",
						event:"keyup",
						callback:null
						},options);
						
			
			//用变量idm存储select的id或name
			var idm = jQuery(this).attr("id") || jQuery(this).attr("name");
			if(!idm){
				return jQuery(this);
			}
			if(jQuery("#" + idm + "div").length <= 0){//判断动态创建的div是否已经存在，如果不存在则创建
				var divHtml = "<div style='display:none;background:transparent;' id='" + idm + "div'><input maxLength=2 style='background:transparent;text-align:center;border:none;color:#fff' type='text' value='"+options.pageSize+"' name='" + idm + "inputText' id='" + idm + "inputText'/></div>";
				jQuery(this).attr("tabindex",-1).after(divHtml);
				resetDivPosition(idm,this);
				//select注册onchange事件
				jQuery(this).change(function(e){
						var inputtext = jQuery("#" + idm + "inputText");
						inputtext.val(jQuery(this).val());	
						savePageSize(e,inputtext,options.pageId,true);
				});				
			}
			if(!!options.callback){
				jQuery("#" + idm + "inputText").bind(options.event,function(e){
					options.callback(e,this,options.pageId);
				});
			}
			//解决ie6下select浮在div上面的bug
			jQuery("#" + idm + "div").bgIframe();
			jQuery(window).bind("resize",function(){
				resetDivPosition(idm,jQuery("#"+idm),true);
			});
			return jQuery(this);
		}
})(jQuery);

var resetDivPosition = function(idm,obj,resizable){
	try{
		if(!!resizable || jQuery.browser.msie){
			jQuery("#" + idm + "div").css({position:"absolute",top:Math.floor(jQuery(obj).position().top) ,left:jQuery(obj).position().left+5}).show();
		}else{
			if(jQuery.browser.mozilla){
				jQuery("#" + idm + "div").css({position:"absolute",top:Math.floor(jQuery(obj).position().top+1) ,left:jQuery(obj).position().left+5}).show();
			}else{
				jQuery("#" + idm + "div").css({position:"absolute",top:Math.ceil(jQuery(obj).position().top) ,left:jQuery(obj).position().left+5}).show();
			}
		}
		if(jQuery.browser.msie && jQuery.browser.version=="9.0"){
			jQuery("#" + idm + "inputText").css({width:jQuery(obj).width()-13,height:jQuery(obj).height() + 1});
		}else{
			jQuery("#" + idm + "inputText").css({width:jQuery(obj).width()-16,height:jQuery(obj).height() + 2});
		}
		if(!jQuery.browser.msie){
			jQuery("#" + idm + "inputText").css("line-height",(jQuery(obj).height() + 2)+"px");
		}
	}catch(e){}
}


