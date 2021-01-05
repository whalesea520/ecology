/*顶部按钮划出页面相关代码*/
function createSildePage(items, p){
	var sildePageId = (p == "L") ? "leftSlidePage" : ((p == "R")? "rightSlidePage" : "");
	if(sildePageId == ""){
		return;
	}
	var $sildePage = $("#" + sildePageId);
	if($sildePage.length > 0){
		return;
	}
	
	$sildePage = $("<div id=\""+sildePageId+"\" class=\"slidePage\"></div>");
	for(var i = 0; i < items.length; i++){
		var iconpath = items[i]["iconpath"];
		var iconstyle = items[i]["iconstyle"];
		var uiname = items[i]["uiname"];
		var remindnum = items[i]["remindnum"];
		var action = items[i]["action"];
		
		var iHtm = "<div class=\"sildePageEntry\" onclick=\""+action+"\">";
		if(iconpath && $.trim(iconpath) != ""){
			iHtm += "<img src=\""+iconpath+"\" style=\""+iconstyle+"\"/>";
		}
		iHtm += uiname;
		if(remindnum && $.trim(remindnum) != ""){
			iHtm += "（"+remindnum+"）";
		}
		iHtm += "</div>";
		$sildePage.append(iHtm);
	}
	
	var swipeevent = (p == "L") ? "swipeleft" : ((p == "R")? "swiperight" : "");
	$sildePage.on(swipeevent,function(){
		doPageSilde(p);
	});
	
	$(document.body).prepend($sildePage);
	
	$sildePage.css("height", document.body.scrollHeight + "px");
}

function doPageSilde(p){
	if(p == "L"){
		sildeLeftPage();
	}else if(p == "R"){
		sildeRightPage();
	}	
}

var leftDisplayFlag = false;
function sildeLeftPage(){
	var w = 70;
	
	function doShow(n){
		n = n - 10;
		
		var l = n;
		var r = w - l;
		
		$("#leftSlidePage").animate({ left: "-"+l+"%"}, 5, function(){
			$("#homepageContainer").animate({right: "-"+r+"%"}, 0, function(){
				if(n != 0){
					doShow(n);
				}
			});
			
	 	});
	}
	
	function doHide(n){
		n = n - 10;
		
		var r = n;
		var l = w - r;
		
		
		$("#homepageContainer").animate({right: "-"+r+"%"}, 20, function(){
			$("#leftSlidePage").animate({ left: "-"+l+"%"}, 0, function(){
				if(n != 0){
					doHide(n);
				}else{
					$("#leftSlidePage").hide();
				}
			});
			
	 	});
	}
	
	if(!leftDisplayFlag){
		$("#leftSlidePage").show();
		doShow(w);
	}else{
		doHide(w);
	}
	
	leftDisplayFlag = !leftDisplayFlag;
}

var rightDisplayFlag = false;
function sildeRightPage(){
	var w = 70;
	
	function doShow(n){
		n = n - 10;
		
		var r = n;
		var l = w - r;
		
		$("#rightSlidePage").animate({ right: "-"+r+"%"}, 5, function(){
			$("#homepageContainer").animate({left: "-"+l+"%"}, 0, function(){
				if(n != 0){
					doShow(n);
				}
			});
			
	 	});
	}
	
	function doHide(n){
		n = n - 10;
		
		var l = n;
		var r = w - l;
		
		
		$("#homepageContainer").animate({left: "-"+l+"%"}, 20, function(){
			$("#rightSlidePage").animate({ right: "-"+r+"%"}, 0, function(){
				if(n != 0){
					doHide(n);
				}else{
					$("#rightSlidePage").hide();
				}
			});
			
	 	});
	}
	
	if(!rightDisplayFlag){
		$("#rightSlidePage").show();
		doShow(w);
	}else{
		doHide(w);
	}
	
	rightDisplayFlag = !rightDisplayFlag;
}

/*首页内置JS函数，方便在首页进行代码编写和规避一些复杂的代码处理*/
//显示加载器  
Mobile_NS.showLoader = function() {  
    $.mobile.loading('show', {  
        text: '加载中...', //加载器中显示的文字  
        textVisible: true, //是否显示文字  
        theme: 'a',        //加载器主题样式a-e  
        textonly: false,   //是否只显示文字  
        html: ""           //要显示的html内容，如图片等  
    });  
};
//隐藏加载器
Mobile_NS.hideLoader = function()  
{  
    $.mobile.loading('hide');  
};

Mobile_NS.loadTimelinrDataWithPage = function(mec_id, totalPageCount){
	if(typeof(top.lockPage) == "function"){
		top.lockPage();
	}
	
	eval("if(typeof(pageNo" + mec_id + ") == 'undefined'){pageNo" + mec_id + " = 1}");
	eval("pageNo" + mec_id + "++;");
	eval("var timelinrPageNo = pageNo" + mec_id + ";");
	Mobile_NS.showLoader(); 
	var url = "/weaver/com.weaver.formmodel.mobile.mec.servlet.MECAction?action=getTimelinrDataWithPage&mec_id="+mec_id+"&pageNo="+timelinrPageNo;
	$.post(url, null, function(data){
		var $timelinrContainer = $("#timelinr" + mec_id);
		$timelinrContainer.append(data.substring(data.indexOf("<tr"),data.lastIndexOf("</tr>")));
		
		if(timelinrPageNo == totalPageCount){
			$("#more" + mec_id).hide();
		}
		Mobile_NS.hideLoader();
		
		refreshIScroll();
		
		if(top && typeof(top.resetActiveFrame) == "function"){
			top.resetActiveFrame();
		}
		
		if(typeof(top.lazyReleasePage) == "function"){
    		top.lazyReleasePage();
    	}
	});
};
Mobile_NS.dynamicRunFn = function(fnName){
	try{
		var beCallCode = fnName + "()";
		eval(beCallCode);
	}catch(e){
		
	}
};

Mobile_NS.ajax = function(url, paramData, callbackFn, type){
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + timestamp;
	$.get(url, paramData, function(data){
		if(typeof(callbackFn) == "function"){
			callbackFn.call(this, data);
		}
	}, type);
};

Mobile_NS.triggerLazyLoad = function(mec_id, callbackFn){
	var $lazyLoadContainer = $("#abbr_" + mec_id);
	if($lazyLoadContainer.length == 0){
		return;
	}
	var loaded = $lazyLoadContainer.attr("loaded");
	if(loaded == "true"){
		return;
	}
	$lazyLoadContainer.attr("loaded", "true");
	
	Mobile_NS.triggerRefresh(mec_id, callbackFn);
};

Mobile_NS.triggerRefresh = function(mec_id, callbackFn){
	var $mecContainer = $("#abbr_" + mec_id);
	if($mecContainer.length == 0){
		return;
	}
	
	$mecContainer.find("*").remove();
	
	//动态创建一个loading的div
	var $refreshLoading = $("<div class=\"mec_refresh_loading\"></div>");
	$mecContainer.append($refreshLoading);
	var url = "/mobilemode/MECAction.jsp?action=getMecHtml&mec_id="+mec_id;
	Mobile_NS.ajax(url, Mobile_NS.pageParams, function(data){
		$refreshLoading.hide();
		$refreshLoading.remove();
		
		//还原页数(如果有)，针对列表或者时间轴，以及其它后面会增加的插件，但是要求名称必须是pageNo + mec_id
		eval("if(typeof(pageNo" + mec_id + ") != 'undefined'){pageNo" + mec_id + " = 1}");
		
		$mecContainer.html(data);
		
		$mecContainer.trigger("create"); //触发jqm渲染
		
		refreshIScroll();
		
		if(top && typeof(top.resetActiveFrame) == "function"){
			top.resetActiveFrame();
		}
		
		if(typeof(callbackFn) == "function"){
			try{
				callbackFn.call(this, mec_id);
			}catch(e){}
		}
	});
};

function $p(name){
	var v = Mobile_NS.pageParams[name];
	if(v == null || typeof(v) == "undefined"){
		v = "";
	}
	return v;
}

Mobile_NS.initTapEvent = function($Wrap, stopPropagation){
	if(!$Wrap){
		$Wrap = $(document.body);
	}
	var $tapEle = $("*[ontap]", $Wrap);
	$tapEle.each(function(){
		var tapCode = $(this).attr("ontap");
		$(this).on("tap", function(e){
			eval(tapCode);
			if(stopPropagation){
				e.stopPropagation();
			}
		});
	});
	$tapEle.removeAttr("ontap");
};

Mobile_NS.getCurrUser = function(){
	return E3005CF26D9F9AC78773E16572827297;
};