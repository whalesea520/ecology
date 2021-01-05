function openBrowser(fieldid, browserid,browsername){
	if(browserid==256||browserid==257){
		var isMuti = browserid == 257 ? true : false;
		if(_top && typeof(_top.openTreeBrowser) == "function"){
			_top.openTreeBrowser(window, "field"+fieldid,fieldid, browserid, browsername, "",isMuti);
		}
		return;
	}
	var params = {}; //{"_nj":"23","_bj":"24"};
	$("input[fieldname]", $("#frmmain")).each(function(){
		var _fieldname = "_" + $(this).attr("fieldname"); // nj
		var fieldvalue = $(this).val(); //23
		params[_fieldname] = fieldvalue;
	});
	$("select[fieldname]", $("#frmmain")).each(function(){
		var _fieldname = "_" + $(this).attr("fieldname"); // nj
		var fieldvalue = $(this).val(); //23
		params[_fieldname] = fieldvalue;
	});
	$("textarea[fieldname]", $("#frmmain")).each(function(){
		var _fieldname = "_" + $(this).attr("fieldname"); // nj
		var fieldvalue = $(this).val(); //23
		params[_fieldname] = fieldvalue;
	});
	//params["_name"] = $(".field_inputText").val();
	
	var $browserContainer = $("#browserContainer");
	
	if($browserContainer.length == 0){
		$browserContainer = $("<div id=\"browserContainer\"></div>");
					
		$browserContainer.html("<div class=\"browserMask\"></div>"
							 + "<div class=\"browserContent\">"
								  + "<div class=\"title\">请选择<div id=\"browserClose\" onclick=\"javascript:onBrowserClose();\"></div></div>"
								  + "<div class=\"frameWrap\">"
										
									  + "<div class=\"frameMask\"></div>"
									  + "<iframe class=\"frame\" frameborder=\"0\" scrolling=\"auto\" src=\"\">"
							
									  + "</iframe>"
								  + "</div>"
									
							  + "</div>");

		$(document.body).append($browserContainer);
		
		var $browserContent = $(".browserContent", $browserContainer);
		$browserContent.css("left", (($(document.body).width() - $browserContent.outerWidth(true))/2) + "px");
	}
	
	if(parent && typeof(parent.getPageScrollTop) == "function"){
		var $browserContent = $(".browserContent", $browserContainer);
		$browserContent.css("top", (parent.getPageScrollTop() + 10) + "px");
	}
	
	var $frameMask = $(".browserContent .frameMask", $browserContainer);
	$frameMask.show();
	
	$browserContainer.show();
	
	var $frame = $(".browserContent iframe.frame", $browserContainer);
	$frame[0].src = "/mobilemode/browser.jsp?showField="+fieldid+"&browserId="+browserid+"&params="+encodeURIComponent(JSON.stringify(params));
	$frame[0].onload = function(){
		$frameMask.hide();
	};
}	

//树形浏览框选中确定回调
function onBrowserOk(result){
	if(result){
		var fieldId = result["fieldId"];
		var fieldSpanId = result["fieldSpanId"];
		var idValue = result["idValue"];
		var nameValue = result["nameValue"];
		
		$("#"+fieldId).val(idValue);
		var c = "<label>"+nameValue + "</label><span class=\"delBrowser\" onclick=\"javascript:onBrowserCancel('"+fieldSpanId+"');\"></span>"
		$("#"+fieldId+"span").html(c);
		
		//字段联动-浏览按钮
		var rtt = {"name" : nameValue, "value" : idValue};
		readyToTrigger(fieldSpanId, rtt);
	}
	if(_top && typeof(_top.doHistoryBack) == "function"){
		_top.doHistoryBack()
	}
}

function onBrowserOK(fieldid, result){
	if(result){
		$("#field"+fieldid).val(result["value"]);
		var c = "<label>"+result["name"] + "</label><span class=\"delBrowser\" onclick=\"javascript:onBrowserCancel('"+fieldid+"');\"></span>"
		$("#field"+fieldid+"span").html(c);
		
		//字段联动-浏览按钮
		readyToTrigger(fieldid, result);
	}
	onBrowserClose();
}

function onBrowserClose(){
	var $browserContainer = $("#browserContainer");
	$browserContainer.hide();
}

function onBrowserCancel(fieldid){
	$("#field"+fieldid).val("");
	$("#field"+fieldid+"span").html("<label></label>");
}