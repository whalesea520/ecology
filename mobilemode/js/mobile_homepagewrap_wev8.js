var scrollTopArr = new Array();
var pageSlideHold = 400;
var isNeedBackPage = true;

$(document).ready(function(){
	FastClick.attach(document.body);
	
	var $loadText = $("#loading .loadText");
	var l_w = parseInt($loadText.css("width").replace("px", ""));
	var l_h = parseInt($loadText.css("height").replace("px", ""));
	$loadText.css("right", (($(document.body).width() - l_w)/2) + "px");
	$loadText.css("top", ((document.body.clientHeight - l_h)/2) + "px");
	
	
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=getAppInfo&timestamp=" + timestamp);
	$.get(url, {"appid" : _appid, "appHomepageId" : _appHomepageId}, function(responseText){
		var data = $.parseJSON(responseText);
		_appname = data["appname"];
		_appid = data["appid"];
		_appHomepageId = data["appHomepageId"];
		_hasHeader = data["hasHeader"];
		if(_hasHeader == true){
			$("#page-view").addClass("has-header");
		}
		
		var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
		var url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + _appHomepageId + _queryString;
		
		url = changeUrl(url);
		$activeFrame[0].src = url;
		$activeFrame[0].onload = whenFrameLoaded;
	});
	
	setTimeout(function(){
		if (history.pushState) {
			history.replaceState({}, "", location.href);
			window.addEventListener("popstate", function(event) {
				if(_fixIOS11Bug) return;//解决ios11 返回bug
				if(event && !event.state){
					doHistoryBack();
				}else{
					if(event && event.state && event.state.isOpenedOnTopfloor && !isTopfloorPageDisplay()){
			    		doHistoryBack();
			    	}else{
			    		if(isNeedBackPage){
			    			doBackPage();
			    		}else{
			    			isNeedBackPage = true;
			    		}
			    	}
				}
		    });
		}
	}, 100);
	
});

window.onload = function(){
	$("iframe.lazy-frame").each(function(){
		var $iframe = $(this);
		var lazySrc = $iframe.attr("lazy-src");
	    if(lazySrc && lazySrc != ""){
	    	$iframe[0].onload = function(){
	    		this.style.opacity = "1";
	    	};
	    	$iframe[0].src = lazySrc;
	    	$iframe.removeAttr("lazy-src");
	    }
	});
};

function jionActionUrl(invoker, queryStr){
	if(!queryStr){
		queryStr = "";
	}
	if(queryStr.indexOf("&") != 0){
		queryStr = "&" + queryStr;
	}
	var url = "/mobilemode/Action.jsp?invoker=" + invoker + queryStr;
	url = changeUrl(url);
	return url;
}

function changeUrl(url){
	if(_noLogin == "1"){
		url += (url.indexOf("?") == -1 ? "?" : "&") + "noLogin=" + _noLogin;
	}
	return url;
}

function doRefreshButton(){
	refreshCurrPage();
	return "1";	
}

function scrollPageToTop(){
	$(document.body).scrollTop(0);
}

function getPageScrollTop(){
	return $(document.body).scrollTop();
}

function getBodyClientHeight(){
	return document.body.clientHeight;
}

function getClientType(){
	return _clienttype;
}

function isIOS11(){
	return /iPhone\sOS\s11/i.test(navigator.userAgent);
}

function isIOS(){
	return getClientType().toLowerCase() == "iphone" || getClientType().toLowerCase() == "ipad";
}

function isAndroidOS(){
	return getClientType().toLowerCase() == "android";
}

function isWebClient(){
	return getClientType().toLowerCase() == "webclient";
}

function isRunInEmobile(){
	var ua = navigator.userAgent.toLowerCase();
	if(ua.match(/e-mobile/i) == "e-mobile"){
		return true;
    }else{
        return false;
    }
}

function isRunInWeiXin(){
	var ua = navigator.userAgent.toLowerCase();
	if(ua.match(/MicroMessenger/i) == "micromessenger" && ua.match(/wxwork/i) != "wxwork"){
		return true;
    }else{
        return false;
    }
}

function resetActiveFrame(){
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		if(activeFrame.src.indexOf("/mobile/plugin/1/view.jsp") != -1){
			try{	// 捕获可能存在的js跨域访问出现的异常
				var frameDoc = activeFrame.contentWindow.document;
				activeFrame.style.height = frameDoc.body.scrollHeight + "px";
				$("#mobileFrameContainer").addClass("workFlow");
			}catch(e){}
		}
	}
}

function resetActiveFrameHeight(h){
	return;
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		activeFrame.style.height = h + "px";
	}
}

var _fixIOS11Bug = false;
var firstIntoHistoryLength = window.history.length;
function fixIOS11Bug(){
	if(isRunInWeiXin() && isIOS11()){
		if(firstIntoHistoryLength > 1){
			//通过location.href的形式跳转到appHomepageViewWrap，则第一次不进行返回处理，否则会出现闪退
			firstIntoHistoryLength = 1;
			return;
		}
		_fixIOS11Bug = true;
		history.go(-1);
		setTimeout(function(){
			_fixIOS11Bug = false;
		}, 10);
	}
}

function whenFrameLoaded(){
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	$activeFrame.removeClass("blankFrame");
	if(isIOS()){
		scrollPageToTop();
	}
	fixIOS11Bug();
	
	resetActiveFrame();
	
	giveCurrFrameAId($activeFrame[0]);
	
	refreshWebHead();
	
	$activeFrame.attr("isload", "1");
}

function giveCurrFrameAId(frameObj){
	if(frameObj){
		var _id = frameObj.getAttribute("id");
		if(!_id || _id == ""){	//没有id
			var pageIdentifier = null;
			try{ // 捕获可能存在的js跨域访问出现的异常
				pageIdentifier = frameObj.contentWindow.pageIdentifier;
			}catch(e){
				
			}
			if(pageIdentifier){
				var type = pageIdentifier["type"];
				var id = pageIdentifier["id"];
				if(type == 1){
					_id = "appHomepageFrame_" + id;
				}
				frameObj.setAttribute("id", _id);
			}
		}
	}
}

function refreshWebHead(){
	//具体实现在mobile_webhead_wev8.js中，如果是在web中运行，次方法会被mobile_webhead_wev8.js中的同名方法顶掉
}

function isOuternetUrl(url){	//是否是外网地址
	if(url.indexOf("http://") == 0 || url.indexOf("https://") == 0){
		if(url.indexOf(_basepath) == 0){
			return false;
		}else{
			return true;
		}
	}
	return false;
}

function pushHistoryState(state, title, url){
	if(!url){
		url = location.href;
		var timestampReg = /(\?|#)timestamp=\d{13}/;
		var timestampMatches = timestampReg.exec(url);
		if(timestampMatches){
			url = url.replace(timestampMatches[0], "");
		}
		if(url.indexOf("?") != -1){
			url += "#timestamp=" + new Date().getTime();
		}else{
			url += "?timestamp=" + new Date().getTime();
		}
	}
	if(!title){
		title = document.title;
	}
	if(!state || typeof(state) != "object"){
		state = {title:title,url:url};
	}
	
	if(history.pushState){
		history.pushState(state, title, url);
		isNeedBackPage = true;
    }
}

function openUrl(url, oParam){
	if(url.indexOf("mobilemode:refreshList:") == 0){
		//功能性url: 刷新已有列表,格式：mobilemode:refreshList:自定义页面id:列表插件id(如该自定义页面只有一个列表插件，此项可至空):sql查询限制条件
		var urlParamStr = url.substring("mobilemode:refreshList:".length);
		var pArr = urlParamStr.split(":");
		if(pArr.length < 3){
			alert(_multiLJson['383740']);//参数设置不正确,请检查
			return;
		}
		var pageid = pArr[0];
		var frameId = "appHomepageFrame_" + pageid;
		var $frame = $("#" + frameId);
		if($frame.length == 0){
			alert(_multiLJson['383742'] + pageid + _multiLJson['383743']);//未找到id为" + pageid + "的页面，请检查参数设置是否正确
			return;
		}
		var frameWin = $frame[0].contentWindow;
		if(!frameWin.Mobile_NS || typeof(frameWin.Mobile_NS.refreshList) != "function"){
			alert(_multiLJson['383744']);//未在目标页面上找到刷新方法，请确认目标页面是否包含列表组件
			return;
		}
		var mec_id = pArr[1];
		var listparams = pArr[2];
		
		var refreshedCallbackFn;
		if(pArr.length > 3){
			var refreshedCallbackFnName = pArr[3];
			if(refreshedCallbackFnName && refreshedCallbackFnName != ""){
				refreshedCallbackFn = function(){
					var targetFn = eval("this." + refreshedCallbackFnName);
					if(typeof(targetFn) == "function"){
						var pData;
						if(oParam){
							pData = oParam.refreshedCallbackParamData;
						}
						targetFn.call(this, pData);
					}
				};
			}
		}

		var mecidArr = mec_id.split(",");
		for(var i=0; i<mecidArr.length; i++){
			frameWin.Mobile_NS.refreshList(mecidArr[i], listparams, refreshedCallbackFn);
		}

		return;
	}else if(url.indexOf("mobilemode:createTopfloorPage:") == 0){
		//功能性url: 从顶层页面打开指定url的界面,格式：mobilemode:createTopfloorPage:页面url:滑出顶层页面时的一些配置(JSON串)
		var urlParamStr = url.substring("mobilemode:createTopfloorPage:".length);
		var splitIndex = urlParamStr.lastIndexOf(":{");
		
		var tp_url, tp_param;
		if(splitIndex != -1){
			tp_url = urlParamStr.substring(0, splitIndex);
			var tp_param_str = urlParamStr.substring(splitIndex + 1);
			try{
				tp_param = eval("("+tp_param_str+")");
			}catch(e){
				tp_param = null;
			}
		}else{
			tp_url = urlParamStr;
			tp_param = null;
		}
		
		createTopfloorPage(tp_url, tp_param);
		return;
	}else if(url.indexOf("mobilemode:callJSCode:") == 0){
		var jsCodeId = url.substring("mobilemode:callJSCode:".length);
		var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
		var frameWin = $activeFrame[0].contentWindow;
		try{
			eval("frameWin.Mobile_NS." + jsCodeId + "();");
		}catch(e){
		}
		return;
	}else{
		if(url.indexOf("/mobile/plugin") == 0){// 访问系统文档或web端流程
			top.location.href = url;
			return;
		}
	}
	scrollTopArr.push(getPageScrollTop());

	var styleStr = "";
	if(isIOS()){
		//iphone 上iframe会被同类更高的iframe撑大的问题
		styleStr = "height:" + $(document.body).height() + "px;"
	}
	
	var $mobileFrameContainer = $("#mobileFrameContainer");
	if(isOuternetUrl(url)){	//外网
		if(!$mobileFrameContainer.hasClass("outer-net")){
			$mobileFrameContainer.addClass("outer-net");
		}
	}else{
		url = changeUrl(url);
	}
	
	var $beShowFrame = $("<iframe class=\"mobileFrame beShowFrame blankFrame\" frameborder=\"0\" isload=\"0\" scrolling=\"auto\" style=\""+styleStr+"\"></iframe>");
	$mobileFrameContainer.append($beShowFrame);
	setBeshowFrameLoad($beShowFrame, url);
}

function openUrlOnLeftAndReplace(url){
	$("#loading").show();
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	var $beShowFrame = $("<iframe class=\"mobileFrame beShowFrameOnLeft\" frameborder=\"0\" isload=\"0\" scrolling=\"auto\"></iframe>");
	$("#mobileFrameContainer").append($beShowFrame);
	
	var beShowFrame = $beShowFrame[0];
	var historyLength = window.history.length;
	beShowFrame.onload = function(){
		fixIOSHistoryBug(historyLength, window);
		$("#loading").hide();
		$activeFrame.addClass("beBackFrameOnRight");
		$beShowFrame.removeClass("beShowFrameOnLeft");
		setTimeout(function(){
			
			$activeFrame.removeClass("activeFrame");
			$activeFrame.remove();
			
			$beShowFrame.addClass("activeFrame");
			
			resetActiveFrame();
			giveCurrFrameAId(beShowFrame);
			refreshWebHead();
			
			$beShowFrame.attr("isload", "1");
		}, pageSlideHold);
	}
	url = changeUrl(url);
	beShowFrame.src = url;
}

function openUrlOnRightAndReplace(url){
	$("#loading").show();
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	var $beShowFrame = $("<iframe class=\"mobileFrame beShowFrame\" frameborder=\"0\" isload=\"0\" scrolling=\"auto\"></iframe>");
	$("#mobileFrameContainer").append($beShowFrame);
	var historyLength = window.history.length;
	var beShowFrame = $beShowFrame[0];
	beShowFrame.onload = function(){
		fixIOSHistoryBug(historyLength, window);
		$("#loading").hide();
		$activeFrame.addClass("beBackFrame");
		$beShowFrame.removeClass("beShowFrame");
		setTimeout(function(){
			
			$activeFrame.removeClass("activeFrame");
			$activeFrame.remove();
			
			$beShowFrame.addClass("activeFrame");
			
			resetActiveFrame();
			giveCurrFrameAId(beShowFrame);
			refreshWebHead();
			
			$beShowFrame.attr("isload", "1");
		}, pageSlideHold);
	}

	url = changeUrl(url);
	beShowFrame.src = url;
}

function openUrlFindBeforeCreate(url, oParam){
	var $mobileFrameContainer = $("#mobileFrameContainer");
	var $mobileFrame = $("iframe.mobileFrame[src='"+url+"']", $mobileFrameContainer);
	if($mobileFrame.length > 0){
		if($mobileFrame.hasClass("activeFrame")){
			return;
		}
		
		var $activeFrame = $("iframe.activeFrame", $mobileFrameContainer);
		$activeFrame.addClass("beShowFrame");
		$mobileFrame.removeClass("beBackFrame");
		
		setTimeout(function(){
			$mobileFrame.addClass("activeFrame");
			var $nextFrame;
			while(($nextFrame = $mobileFrame.next("iframe.mobileFrame")).length > 0){
				$nextFrame.remove();
			}
			refreshWebHead();
		}, pageSlideHold);
		
	}else{
		openUrl(url, oParam);
	}
}

function cloneCurrFrameToRefresh(beCloneWindow){
	lockPage();
	
	var $activeFrame;
	var url;
	var $cloneFrame;
	if(isTopfloorPageDisplay()){
		var st_effect = "st-effect-" + last_effect;
		var $stMenu = $("#st-menu_" + st_effect);
		
		var stFrameClass = "st-frame" + stFrameLevel;
		
		$activeFrame = $("iframe."+stFrameClass+"[lastOpend='true']", $stMenu);
		url = $activeFrame.attr("src");
		
		$cloneFrame = $("<iframe class=\"st-frame "+stFrameClass+" beShowFrame\" lastOpend=\"true\" frameborder=\"0\" scrolling=\"auto\" style=\"border:none;width:100%;height:100%;background-color:transparent;opacity: 0;\" src=\"\"></iframe>");
		$stMenu.append($cloneFrame);
	}else{
		$activeFrame = $("#mobileFrameContainer iframe.activeFrame");
		url = $activeFrame.attr("src");
		
		$cloneFrame = $("<iframe class=\"mobileFrame  refreshFrame\" frameborder=\"0\" isload=\"0\" scrolling=\"auto\"></iframe>");
		$("#mobileFrameContainer").append($cloneFrame);
	}
	

	var cloneFrame = $cloneFrame[0];
	cloneFrame.onload = function(){
		beCloneWindow.pullDownEl.querySelector('.pullDownLabel').innerHTML = _multiLJson['383731'];//刷新成功
		beCloneWindow.pullDownEl.className = 'refresh_success';
		setTimeout(function () {
			beCloneWindow.myScroll.refresh();
			setTimeout(function () {
				releasePage();
				
				if(isTopfloorPageDisplay()){
					$activeFrame.remove();
					$cloneFrame.removeClass("beShowFrame");
					cloneFrame.style.opacity = "1";
				}else{
					$cloneFrame.removeClass("refreshFrame");
					$cloneFrame.addClass("activeFrame");
					
					$activeFrame.removeClass("activeFrame");
					$activeFrame.remove();
					
					$cloneFrame.attr("isload", "1");
				}
				
				giveCurrFrameAId($cloneFrame[0]);
			}, 800);
		}, 800);
	}

	cloneFrame.src = url;
		
}

function backPage(){
	var $mobileFrameContainer = $("#mobileFrameContainer");
	if($mobileFrameContainer.hasClass("outer-net")){
		$mobileFrameContainer.removeClass("outer-net");
	}
	if($mobileFrameContainer.hasClass("workFlow")){
		$mobileFrameContainer.removeClass("workFlow");
	}
	
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	var $nextFrame;
	while(($nextFrame = $activeFrame.next("iframe.mobileFrame")).length > 0){
		if($nextFrame.attr("isload") == "0"){
			return true;
		}else{
			$nextFrame.remove();
		}
	}
	//$activeFrame.nextAll("iframe.mobileFrame").remove();
	
	if($("#mobileFrameContainer iframe.mobileFrame").length <= 1){
		return "BACK";	
	}
	
	var $prevFrame = $activeFrame.prev("iframe.mobileFrame");
	
	//$prevFrame.addClass("beBackFrame");
	
	var w = 100;
	function doBack(n){
		n = n - 100;
		
		var l = n;
		var r = w - l;
		$activeFrame.addClass("beShowFrame");
		$prevFrame.removeClass("beBackFrame");
		setTimeout(function(){
			
			$activeFrame.removeClass("activeFrame");
			$activeFrame.remove();
			
			$prevFrame.addClass("activeFrame");
			
			try{
				var frameWin = $prevFrame[0].contentWindow;
				if(frameWin && typeof(frameWin._PageShow) == "function"){
					frameWin._PageShow();
				}
			}catch(e){}
			
			if(scrollTopArr.length > 0){
				var prevST = scrollTopArr.pop();
				$(document.body).scrollTop(prevST);
			}
			
			refreshWebHead();
		}, pageSlideHold);
	}
	
	doBack(w);
	return "1";	
}

function backToHomepage(){
	if($("#mobileFrameContainer iframe.mobileFrame").length <= 1){
		return;	
	}
	
	var $firstFrame = $("#mobileFrameContainer iframe.mobileFrame").first();
	var $noFirstFrame = $("#mobileFrameContainer iframe.mobileFrame").not($firstFrame);
	
	$noFirstFrame.addClass("beShowFrame");
	$noFirstFrame.removeClass("activeFrame");
	
	$firstFrame.removeClass("beBackFrame");
	$firstFrame.addClass("activeFrame");
	
	setTimeout(function(){
		$noFirstFrame.remove();
		refreshWebHead();
	}, 500);

}

function doLeftButton(){
	return "BACK";
}

function doHistoryBack(){
	history.go(-1);
}
var _fixiosbug = false;
function fixIOSHistoryBug(preLength, _window){
	var ua = navigator.userAgent.toLowerCase();
	if((preLength != _window.history.length || _fixiosbug) && (ua.match(/iphone/i) == "iphone" && !(ua.match(/dingtalk/i) == "dingtalk"))){
		_fixiosbug = true;
		_window.history.replaceState({}, "", _window.location.href);
		var step = (preLength - _window.history.length) == 0 ? -1 : preLength - _window.history.length;
		_window.history.go(step);
	}
}

function blurThePageElement(){
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		try{
			var frameDoc = activeFrame.contentWindow.document;
			var inEles = frameDoc.getElementsByTagName("input");
			$.each(inEles, function(i, ele){
				ele.blur();
			});
			var textareaEles = frameDoc.getElementsByTagName("textarea");
			$.each(textareaEles, function(i, ele){
				ele.blur();
			});
		}catch(e){
			console.log(e);
		}
	}
}

function doBackPage(){
	blurThePageElement();
	
	if(isDialogCoverDisplay()){
		hideDialogCover();
		return "1";
	}else if(isRightFrameDisplay()){
		closeRightFrame();
		return "1";
	}else if(isTopfloorPageDisplay()){
		backTopfloorPage();
		return "1";
	}else if(isCurrFrameViewOpen()){
		closeCurrFrameOpenView();
		return "1";
	}else{
		removeMobileDialog();
		return backPage();
	}
}

function getRightButton(){
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		var frameWin = activeFrame.contentWindow;
		if(typeof(frameWin.getRightButton) == "function"){
			return frameWin.getRightButton();
		}
	}
	return "0";
}

function doRightButton(){
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		var frameWin = activeFrame.contentWindow;
		if(typeof(frameWin.doRightButton) == "function"){
			frameWin.doRightButton();
		}
	}
	return "1";
}

function showLoading(){
	$("#loading").show();
}

function hideLoading(){
	$("#loading").hide();
}

function lockPage(){
	$("#loading").addClass("lock_loading");	
	$("#loading").show();
}

function releasePage(){
	$("#loading").hide();
	$("#loading").removeClass("lock_loading");
}

function lazyReleasePage(){
	setTimeout(releasePage, 200);
}

function lockFramePage(){
	$("#mobileFrameLocker").show();
}

function releaseFramePage(){
	$("#mobileFrameLocker").hide();
}

function refreshCurrPage(){
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		showLoading();
		activeFrame.onload = function(){
			resetActiveFrame();
			hideLoading();
		}
		activeFrame.src = activeFrame.src;
	}
}

var uploadWin;
function registUploadWindow(w){
	uploadWin = w;
}

function callbackUpload(name,data,fieldid) {
	if(uploadWin && typeof(uploadWin.callbackUpload) == "function"){
		uploadWin.callbackUpload(name,data,fieldid);
	}
}

function clearUpload(fieldid) {
	if(uploadWin && typeof(uploadWin.clearUpload) == "function"){
		uploadWin.clearUpload(fieldid);
	}
}

var mpcWin;
function registMPCWindow(w){
	mpcWin = w;
}

function _p_addPhoto_uploaded(name,data,fieldid){
	if(mpcWin && typeof(mpcWin._p_addPhoto_uploaded) == "function"){
		mpcWin._p_addPhoto_uploaded(name,data,fieldid);
	}
}

function _p_addPhoto_clear(fieldid){
	if(mpcWin && typeof(mpcWin._p_addPhoto_clear) == "function"){
		mpcWin._p_addPhoto_clear(fieldid);
	}
}

var lbsBackWin;
function registLBSBackWindow(w){
	lbsBackWin = w;
}

function backPageAndCallLBSLoaded(result){
	if(lbsBackWin && typeof(lbsBackWin._LBSLoaded) == "function"){
		lbsBackWin._LBSLoaded(result, lbsBackWin.lbs_fieldid);
		backPage();
	}
}

function _p_getLBSResult(result){
	if(mpcWin && typeof(mpcWin._p_getLBSResult) == "function"){
		mpcWin._p_getLBSResult(result, mpcWin.lbs_fieldid, mpcWin.beModifyAddr);
	}
}

function _p_getLBSResult_error(result){
	if(mpcWin && typeof(mpcWin._p_getLBSResult_error) == "function"){
		mpcWin._p_getLBSResult_error(result, mpcWin.lbs_fieldid, mpcWin.beModifyAddr);
	}
}

function _p_wx_getLBSResult(longitude, latitude){
	if(mpcWin && typeof(mpcWin._p_wx_getLBSResult) == "function"){
		mpcWin._p_wx_getLBSResult(longitude, latitude);
	}
}

function _p_addSound_uploaded(result){
	if(mpcWin && typeof(mpcWin._p_addSound_uploaded) == "function"){
		mpcWin._p_addSound_uploaded(result, mpcWin.sound_fieldid);
	}
}

function _p_scanQRCode(result){
	if(mpcWin && typeof(mpcWin._p_scanQRCode) == "function"){
		mpcWin._p_scanQRCode(result);
	}
}

function setBeshowFrameLoad($beShowFrame, url){
	setTimeout(function(){
		var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
		$activeFrame.addClass("beBackFrame");
		$beShowFrame.removeClass("beShowFrame");
		
		setTimeout(function(){
			$activeFrame.removeClass("activeFrame");
			$beShowFrame.addClass("activeFrame");
			
			$beShowFrame[0].src = url;
			pushHistoryState({url: url});
			$beShowFrame[0].onload = whenFrameLoaded;
		}, 300);
		
	}, 10);
}

function openUrlWithTopfloor(url, oParam){
	if(url.indexOf("mobilemode:createTopfloorPage:") == 0){
		openUrl(url, oParam);
		return;
	}
	
	closeTopfloorPage(function(){
		if(url.indexOf("mobilemode:") == 0){
			openUrl(url, oParam);
			return;
		}
		
		url = changeUrl(url);
		var $mobileFrameContainer = $("#mobileFrameContainer");
		var $tfFrame = $("iframe.tfFrame", $mobileFrameContainer);
		if($tfFrame.length == 0){
			var $beShowFrame = $("<iframe class=\"mobileFrame beShowFrame tfFrame blankFrame\" frameborder=\"0\" isload=\"0\" scrolling=\"auto\"></iframe>");
			$mobileFrameContainer.append($beShowFrame);
			setBeshowFrameLoad($beShowFrame, url);
		}else{
			showLoading();
			$tfFrame[0].onload = function(){
				resetActiveFrame();
				hideLoading();
			};
		
			if($tfFrame.hasClass("activeFrame")){
				$tfFrame[0].src = url;
			}else{
				$tfFrame.nextAll("iframe").remove();
				$tfFrame.addClass("activeFrame");
				$tfFrame[0].src = url;
			}
			
			refreshWebHead();
		}
	});
}

function mobilecheck() {
	var check = false;
	(function(a){if(/(android|ipad|playbook|silk|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a)||/1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0,4)))check = true})(navigator.userAgent||navigator.vendor||window.opera);
	return check;
}
	
function hasParentClass( e, classname ) {
	if(e === document) return false;
	if($(e).hasClass(classname)) {
		return true;
	}
	return e.parentNode && hasParentClass( e.parentNode, classname );
}

function resetSTMenu(){
	$("#st-container").removeClass("st-menu-open");
	$("#st-container iframe.st-frame").removeAttr("lastOpend");
}

function clearSTFrame(){
	while(stFrameLevel > 1){
		var stFrameClass = "st-frame" + stFrameLevel;
		$("#st-container .st-menu iframe." + stFrameClass).remove();
		stFrameLevel--;
	}
}

function writeCssToPage(cssCode){
	var headEle = document.getElementsByTagName("head")[0]; 
	var styleEle = document.createElement("style");
	styleEle.setAttribute("type","text/css"); 
	styleEle.appendChild(document.createTextNode(cssCode)) 
	headEle.appendChild(styleEle);
}

function isHidden($obj){
	return $obj.css("display") == "none" || $obj.css("visibility") == "hidden";
}

var last_pageIdOrUrl;
var last_param;
var last_effect;
var stFrameLevel = 1;
var last_speedTime;
function createTopfloorPage(pageIdOrUrl, param){
	lockFramePage();
	
	var url;
	if(isNaN(pageIdOrUrl)){
		url = pageIdOrUrl + (pageIdOrUrl.indexOf("?") == -1 ? "?" : "&") + "isOpenedOnTopfloor=1";
	}else{
		url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + pageIdOrUrl + "&isOpenedOnTopfloor=1";
	}

	if(url.indexOf("/mobilemode/browser/") == -1){	//免登录暂时排除browser
		url = changeUrl(url);
	}
	
	var topFloorDisplay = isTopfloorPageDisplay();
	
	if(!topFloorDisplay){
		
		last_pageIdOrUrl = pageIdOrUrl;
		last_param = param;
	
		var defParam = {
			bgcolor : "#fff",
			width : "70%",
			effect : "1",
			maskBgColor : "rgba(0,0,0,0.2)",
			speed : "0.5s"
		};
	
		if(typeof(param) != "undefined" && typeof(param)=='string' && param.constructor==String){	//兼容以前的代码，之前第二个参数是个颜色值
			param = {bgcolor : param};
		}
	
		$.extend(defParam, param); 
	
		var effect = defParam.effect;
		last_effect = effect;
		var st_effect = "st-effect-" + effect;
		
		var $stMenu = $("#st-menu_" + st_effect);
		$stMenu.css({
			"background-color" : defParam.bgcolor,
			"width" : defParam.width
		});
		if(effect == "1"){
			writeCssToPage(".st-effect-1.st-menu {-webkit-transition: all "+defParam.speed+";transition: all "+defParam.speed+";}");
		}else if(effect == "2"){
			writeCssToPage(".st-pusher {-webkit-transition: -webkit-transform "+defParam.speed+";transition: transform "+defParam.speed+";}");
			writeCssToPage(".st-effect-2.st-menu {-webkit-transition: all "+defParam.speed+";transition: all "+defParam.speed+";}");
			
			writeCssToPage(".st-effect-2.st-menu-open .st-pusher {-webkit-transform: translate3d("+defParam.width+", 0, 0);transform: translate3d("+defParam.width+", 0, 0);}");
		}else if(effect == "3"){
			writeCssToPage(".st-pusher {-webkit-transition: -webkit-transform "+defParam.speed+";transition: transform "+defParam.speed+";}");
			writeCssToPage(".st-effect-3.st-menu {-webkit-transition: all "+defParam.speed+";transition: all "+defParam.speed+";}");
			
			writeCssToPage(".st-effect-3.st-menu-open .st-pusher {-webkit-transform: translate3d(-"+defParam.width+", 0, 0);transform: translate3d(-"+defParam.width+", 0, 0);}");
		}
		
		writeCssToPage(".st-pusher::after {background:"+defParam.maskBgColor+";}");
	
		var speedTime = parseInt(parseFloat(defParam.speed) * 1000 + 25);
		last_speedTime = speedTime;
		
		var $stFrame = $("iframe.st-frame1[src='"+url+"']", $stMenu);
		if($stFrame.length > 0){	//已经存在
			if(isHidden($stFrame)){	//但被隐藏
				$("iframe.st-frame1", $stMenu).removeAttr("lastOpend").hide();
				$stFrame.show();
			}
			$stFrame.attr("lastOpend", "true");
			pushHistoryState({url:url,isOpenedOnTopfloor:1});
			setTimeout(refreshWebHead, speedTime);
		}else{	//added
			var $stLoading = $(".st-loading", $stMenu);
			var $spinner = $(".spinner", $stLoading);
			if($spinner.length == 0){
				$spinner = $("<div class=\"spinner\"><div class=\"bounce1\"></div><div class=\"bounce2\"></div><div class=\"bounce3\"></div></div>");
				$stLoading.append($spinner);
			}
			$stLoading.show();
				
			$("iframe.st-frame", $stMenu).removeAttr("lastOpend").hide();
			setTimeout(function() {
				$stFrame = $("<iframe class=\"st-frame st-frame1\" lastOpend=\"true\" frameborder=\"0\" scrolling=\"auto\" style=\"border:none;width:100%;height:100%;background-color:transparent;opacity: 0;\" src=\"\"></iframe>");
				$stMenu.append($stFrame);
				
				$stFrame[0].onload = function(){
					$stLoading.hide();
					this.style.opacity = "1";
					giveCurrFrameAId(this);
					refreshWebHead();
					pushHistoryState({url:url,isOpenedOnTopfloor:1});
				};
				$stFrame[0].src = url;
				
			}, speedTime);
		}
		var container = document.getElementById("st-container");
		container.className = "st-container"; // clear
		$(container).addClass(st_effect);
		setTimeout( function() {
			$(container).addClass("st-menu-open");
		}, 25 );
		var eventtype = "click";

		setTimeout(function(){
			
			$(container).on(eventtype, function(evt){
				if(!hasParentClass(evt.target, "st-menu")) {
					resetSTMenu();
					$(this).off(eventtype);
					setTimeout(function(){
						clearSTFrame();
						releaseFramePage();
						isNeedBackPage = false;
						doHistoryBack();
					}, 500);
					
					setTimeout(refreshWebHead, speedTime);
				}
			});
			
		}, speedTime);
	}else{
		var st_effect = "st-effect-" + last_effect;
		var $stMenu = $("#st-menu_" + st_effect);
		
		var $stFrame = $("iframe.st-frame1[src='"+url+"']", $stMenu);
		if(url.indexOf("/mobilemode/browser/") != -1 && $stFrame.length > 0){
			if(isHidden($stFrame)){
				$("iframe.st-frame1", $stMenu).hide();
				$stFrame.show();
			}
			pushHistoryState({url:url,isOpenedOnTopfloor:1});
			$stFrame.removeAttr("lastOpend");
			$stFrame.attr("lastOpend", "true");
			
			stFrameLevel++;
			var stFrameClass = "st-frame" + stFrameLevel;
			$stFrame.addClass(stFrameClass);
			
			setTimeout(refreshWebHead, speedTime);
		}else{
			var $stLoading = $(".st-loading", $stMenu);
			$stLoading.show();
					
			$("iframe.st-frame", $stMenu).hide();
			
			stFrameLevel++;
			var stFrameClass = "st-frame" + stFrameLevel;
			
			$("iframe."+stFrameClass, $stMenu).removeAttr("lastOpend");
			
			var $stFrame = $("<iframe class=\"st-frame "+stFrameClass+"\" lastOpend=\"true\" frameborder=\"0\" scrolling=\"auto\" style=\"border:none;width:100%;height:100%;background-color:transparent;\" src=\"\"></iframe>");
			$stMenu.append($stFrame);
			
			$stFrame[0].onload = function(){
				$stLoading.hide();
				giveCurrFrameAId(this);
				refreshWebHead();
				pushHistoryState({url:url,isOpenedOnTopfloor:1});
			};
			$stFrame[0].src = url;
			
		}
	}
}

function closeTopfloorPage(callbackFn){
	resetSTMenu();
	var eventtype = "click";
	$("#st-container").off(eventtype);
	setTimeout(function() {
		if(callbackFn && typeof(callbackFn) == "function"){
			callbackFn();
		}
		clearSTFrame();
		releaseFramePage();
		isNeedBackPage = false;
		doHistoryBack();
	}, 500);
	
	var speedTime = last_speedTime || 500;
	setTimeout(refreshWebHead, speedTime);
}

function backTopfloorPage(){
	if(!isTopfloorPageDisplay()){return;}
	
	var st_effect = "st-effect-" + last_effect;
	var $stMenu = $("#st-menu_" + st_effect);
	
	if(stFrameLevel > 1){
		var stFrameClass = "st-frame" + stFrameLevel;
		var $beHideFrame = $("iframe." + stFrameClass, $stMenu);
		if($beHideFrame.attr("src").indexOf("/mobilemode/browser/") != -1){
			$beHideFrame.hide();
			$beHideFrame.removeAttr("lastOpend");
			$beHideFrame.removeClass(stFrameClass);
		}else{
			$beHideFrame.hide().remove();
		}
		
		stFrameLevel--;
		stFrameClass = "st-frame" + stFrameLevel;
		$("iframe."+stFrameClass+"[lastOpend='true']", $stMenu).show();
		refreshWebHead();
	}else{
		closeTopfloorPage();
	}
}

function isTopfloorPageDisplay(){
	return $("#st-container").hasClass("st-menu-open");
}

function showTopfloorPage(){
	if(last_pageIdOrUrl){
		createTopfloorPage(last_pageIdOrUrl, last_param);
	}
}

function getCurrActiveFrame(){
	if(isRightFrameDisplay()){
		return $("#right-frame-container iframe.activeFrame");
	}else if(isTopfloorPageDisplay()){
		var st_effect = "st-effect-" + last_effect;
		var $stMenu = $("#st-menu_" + st_effect);
		var stFrameClass = "st-frame" + stFrameLevel;
		return $("iframe." + stFrameClass + "[lastOpend='true']", $stMenu);
	}else{
		return $("#mobileFrameContainer iframe.activeFrame");
	}
}

var touchButtonPos = null;
function getTouchButtonPos(){
	return touchButtonPos;
}
function setTouchButtonPos(x, y){
	if(touchButtonPos == null){
		touchButtonPos = {};
	}
	touchButtonPos["x"] = x;
	touchButtonPos["y"] = y;
	
	$("#mobileFrameContainer iframe.mobileFrame").not(".activeFrame").each(function(){
		var frameWin = this.contentWindow;
		if(frameWin && typeof(frameWin.Mobile_NS.changeTouchButtonPos) == "function"){
			frameWin.Mobile_NS.changeTouchButtonPos();
		}
	});
}

function isCurrFrameViewOpen(){
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		try{	// 捕获可能存在的js跨域访问出现的异常
			return activeFrame.contentWindow.Mobile_NS.getCurrentWindow().Mobile_NS.isViewOpen();
		}catch(e){
			return false;
		}
	}
	return false;
}

function closeCurrFrameOpenView(){
	var $activeFrame = $("#mobileFrameContainer iframe.activeFrame");
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		try{	// 捕获可能存在的js跨域访问出现的异常
			activeFrame.contentWindow.Mobile_NS.getCurrentWindow().Mobile_NS.setViewClose(); 
		}catch(e){
		}
	}
}

function isRightFrameDisplay(){
	return $("#page-view").hasClass("right-frame-open");
}

function openRightFrame(){
	$("#page-view").addClass("right-frame-open");
	setTimeout(refreshWebHead, 300);
}

function closeRightFrame(){
	$("#page-view").removeClass("right-frame-open");
	setTimeout(refreshWebHead, 300);
}

function setActiveRightFrame(frameObj){
	if(!$(frameObj).hasClass("activeFrame")){
		$(frameObj).parent().children(".activeFrame").removeClass("activeFrame");
		$(frameObj).addClass("activeFrame");
	}
}

var _BrowserWindow;
function openHrmBrowser(theWindow, fieldId, fieldSpanId, isMuti){
	var browserType = (isMuti == true || isMuti == "1") ? "1" : "2";
	var paramstr = "fieldId="+(fieldId || "")+"&fieldSpanId="+(fieldSpanId || "")+"&browserType="+browserType;
	openHrmBrowser2(theWindow, paramstr);
}

function openHrmBrowser2(theWindow, paramstr){
	_BrowserWindow = theWindow;
	
	var defaultParamCfg = {
		"fieldId" : "",			//字段id
		"fieldSpanId" : "",		//字段显示区域id
		"browserType" : "1",	//类型：1.多选  2.单选
		"selectedIds" : ""		//选中的id，逗号分隔，如：1,2,3
	};
	
	var containSelectedId = false;
	var paramArr = paramstr.split("&");
	for(var i = 0; i < paramArr.length; i++){
		var oneParam = paramArr[i];
		var oneParamArr = oneParam.split("=");
		var	p_name = oneParamArr[0];
		var p_value = oneParamArr[1];
		defaultParamCfg[p_name] = p_value;
		if(p_name == "selectedIds"){
			containSelectedId = true;
		}
	}
	
	if(!containSelectedId){
		var fieldId = defaultParamCfg["fieldId"];
		var theDocument = theWindow.document;
		var fieldEle = theDocument.getElementById(fieldId);
		if(fieldEle){
			defaultParamCfg["selectedIds"] = fieldEle.value;
		}
	}
	
	var hrmBrowserFrame = document.getElementById("hrmBrowserFrame");
	
	//如果页面未定义返回回调，则给一个默认的返回回调
	if(!(typeof(theWindow.onBrowserBack) == "function")){
		theWindow.onBrowserBack = function(){
			doHistoryBack();
		};
	}
	
	//如果页面未定义确定回调，则给一个默认的确定回调
	if(!(typeof(theWindow.onBrowserOk) == "function")){
		theWindow.onBrowserOk = function(result){
			var fieldId = result["fieldId"];
			var fieldSpanId = result["fieldSpanId"];
			var idValue = result["idValue"];
			var nameValue = result["nameValue"];
			
			var theDocument = theWindow.document;
			
			var fieldEle = theDocument.getElementById(fieldId);
			if(fieldEle){
				fieldEle.value = idValue;
				$(fieldEle).change();
				$(fieldEle).trigger("input");
			}
			
			var fieldSpanIdEle = theDocument.getElementById(fieldSpanId);
			if(fieldSpanIdEle){
				fieldSpanIdEle.innerHTML = nameValue;
				if(idValue && idValue != ""){
					$(fieldSpanIdEle).parent().addClass("hasValue");
				}else{
					$(fieldSpanIdEle).parent().removeClass("hasValue");
				}
			}
			
			var browserChoosedFn = eval("theWindow.onBrowserChoosed" + "_" +  fieldId);
			if(typeof(browserChoosedFn) == "function"){
				browserChoosedFn.call(theWindow, idValue, nameValue);
			}
			
			doHistoryBack();
		};
	}
	
	var url = "/mobilemode/browser/hrmBrowser.jsp?noHeader=1&fieldId="+defaultParamCfg.fieldId+"&fieldSpanId="+defaultParamCfg.fieldSpanId+"&selectedIds="+defaultParamCfg.selectedIds+"&browserType="+defaultParamCfg.browserType;
	if(typeof(theWindow.isOpenedOnTopfloor) != "undefined" && theWindow.isOpenedOnTopfloor == true){
		createTopfloorPage(url);
	}else{
		openUrl(url);
	}
}

function openCommonBrowser(theWindow, fieldId, fieldSpanId, browserId, browserName, browserText, params){
	_BrowserWindow = theWindow;
	
	var defaultParamCfg = {
		"fieldId" : fieldId || "",			//字段id
		"fieldSpanId" : fieldSpanId || "",	//字段显示区域id
		"browserId" :  browserId || "",		//浏览框类型
		"browserName" : browserName || "",	//浏览框名称
		"browserText" : browserText || "",
		"params" : params || {}
	};
	
	try{
		var theDocument = theWindow.document;
		var fieldEle = theDocument.getElementById(fieldId);
		if(fieldEle){
			defaultParamCfg["selectedIds"] = fieldEle.value;
		}
	}catch(ex){}
	
	//如果页面未定义返回回调，则给一个默认的返回回调
	if(!(typeof(theWindow.onBrowserBack) == "function")){
		theWindow.onBrowserBack = function(){
			doHistoryBack();
		};
	}
	
	//如果页面未定义确定回调，则给一个默认的确定回调
	if(!(typeof(theWindow.onBrowserOk) == "function")){
		theWindow.onBrowserOk = function(result){
			var _fieldId = result["fieldId"];
			var _fieldSpanId = result["fieldSpanId"];
			var idValue = result["idValue"];
			var nameValue = result["nameValue"];
			
			var theDocument = theWindow.document;
			
			var fieldEle = theDocument.getElementById(_fieldId);
			if(fieldEle){
				fieldEle.value = idValue;
				$(fieldEle).change();
				$(fieldEle).trigger("input");
			}
			
			var fieldSpanIdEle = theDocument.getElementById(_fieldSpanId);
			if(fieldSpanIdEle){
				fieldSpanIdEle.innerHTML = nameValue;
				if(idValue && idValue != ""){
					$(fieldSpanIdEle).parent().addClass("hasValue");
				}else{
					$(fieldSpanIdEle).parent().removeClass("hasValue");
				}
			}
			
			var browserChoosedFn = eval("theWindow.onBrowserChoosed" + "_" +  _fieldId);
			if(typeof(browserChoosedFn) == "function"){
				browserChoosedFn.call(theWindow, idValue, nameValue);
			}
			
			doHistoryBack();
		};
	}
	
	var url = "/mobilemode/browser/commonBrowser.jsp?noHeader=1&fieldId="+defaultParamCfg.fieldId+"&fieldSpanId="+defaultParamCfg.fieldSpanId+"&selectedIds="+defaultParamCfg.selectedIds+"&browserId="+defaultParamCfg.browserId+"&browserName="+defaultParamCfg.browserName+"&browserText="+encodeURIComponent(defaultParamCfg.browserText)+"&params="+encodeURIComponent(JSON.stringify(defaultParamCfg.params));
	if(typeof(theWindow.isOpenedOnTopfloor) != "undefined" && theWindow.isOpenedOnTopfloor == true){
		createTopfloorPage(url);
	}else{
		openUrl(url);
	}
}

function openTreeBrowser(theWindow, fieldId, fieldSpanId, browserId, browserName, browserText,isMuti){
	_BrowserWindow = theWindow;
	var browserType = (isMuti == true || isMuti == "1") ? "1" : "2";
	var defaultParamCfg = {
		"fieldId" : fieldId || "",			//字段id
		"fieldSpanId" : fieldSpanId || "",	//字段显示区域id
		"browserId" :  browserId || "",		//浏览框类型
		"browserName" : browserName || "",	//浏览框名称
		"browserText" : browserText || "",
		"browserType" : browserType || ""
	};
	
	try{
		var theDocument = theWindow.document;
		var fieldEle = theDocument.getElementById(fieldId);
		if(fieldEle){
			defaultParamCfg["selectedIds"] = fieldEle.value;
		}
	}catch(ex){}
	
	//如果页面未定义返回回调，则给一个默认的返回回调
	if(!(typeof(theWindow.onBrowserBack) == "function")){
		theWindow.onBrowserBack = function(){
			doHistoryBack();
		};
	}
	//如果页面未定义确定回调，则给一个默认的确定回调
	if(!(typeof(theWindow.onBrowserOk) == "function")){
		theWindow.onBrowserOk = function(result){
			var fieldId = result["fieldId"];
			var fieldSpanId = result["fieldSpanId"];
			var idValue = result["idValue"];
			var nameValue = result["nameValue"];
			
			var theDocument = theWindow.document;
			
			var fieldEle = theDocument.getElementById(fieldId);
			if(fieldEle){
				fieldEle.value = idValue;
				$(fieldEle).change();
				$(fieldEle).trigger("input");
			}
			var fieldSpanIdEle = theDocument.getElementById(fieldSpanId);
			if(fieldSpanIdEle){
				fieldSpanIdEle.innerHTML = nameValue;
				if(idValue && idValue != ""){
					$(fieldSpanIdEle).parent().addClass("hasValue");
				}else{
					$(fieldSpanIdEle).parent().removeClass("hasValue");
				}
			}
			var browserChoosedFn = eval("theWindow.onBrowserChoosed" + "_" +  fieldId);
			if(typeof(browserChoosedFn) == "function"){
				browserChoosedFn.call(theWindow, idValue, nameValue);
			}
			doHistoryBack();
		};
	}
	
	var url = "/mobilemode/browser/commonTreeBrowser.jsp?noHeader=1&fieldId="+defaultParamCfg.fieldId+"&fieldSpanId="+defaultParamCfg.fieldSpanId+"&selectedIds="+defaultParamCfg.selectedIds+"&browserId="+defaultParamCfg.browserId+"&browserName="+defaultParamCfg.browserName+"&browserText="+encodeURIComponent(defaultParamCfg.browserText)+"&browserType="+defaultParamCfg.browserType;
	if(typeof(theWindow.isOpenedOnTopfloor) != "undefined" && theWindow.isOpenedOnTopfloor == true){
		createTopfloorPage(url);
	}else{
		openUrl(url);
	}	
}

function isDialogCoverDisplay(){
	return !isHidden($("#dialogCoverContainer"));
}

function removeMobileDialog(){
	var $dialog = $("#dialog");
	if($dialog.length > 0){
		var isGlobal = $dialog.attr("global");
		if(isGlobal == "0"){
			$dialog.hide();
		}
	}
}

function hideDialogCover(fn){
	var $dialogCoverContainer = $("#dialogCoverContainer");
	var $dialogCoverMark = $(".dialogCoverMark", $dialogCoverContainer);
	var $dialogCoverWrap = $(".dialogCoverWrap", $dialogCoverContainer);
	var $dialogUl = $(".dialogCover", $dialogCoverContainer);
	
	$dialogCoverContainer.off("click");
	$dialogCoverMark.removeClass("show");
	$dialogCoverWrap.addClass("hide");
	setTimeout(function(){
		$dialogCoverContainer.hide();
		if(typeof(fn) == "function"){
			try{
				fn.call(this);
			}catch(e){
				console.log(e);
			}
		}
		$dialogUl.empty();
	}, 300);
}

function addDialogCover(menu_datas, callbackFn){
	var $dialogCoverContainer = $("#dialogCoverContainer");
	var $dialogCoverMark = $(".dialogCoverMark", $dialogCoverContainer);
	var $dialogCoverWrap = $(".dialogCoverWrap", $dialogCoverContainer);
	var $dialogUl = $(".dialogCover", $dialogCoverContainer);
	$dialogUl.empty();
	
	for(var i = 0; i < menu_datas.length; i++){
		if($("#menu_"+menu_datas[i]["id"]).length==0){
			var id = menu_datas[i]["id"] || "";
			var value = menu_datas[i]["menuValue"] || "";
			var icon = menu_datas[i]["icon"] || "";
			var iconStyle = menu_datas[i]["iconStyle"] || "";
			var iconHtml = "";
			if(icon != ""){
				var styleHtml = (iconStyle != "") ? "style=\""+iconStyle+"\"" : "";
				iconHtml = "<img src=\""+icon+"\" class=\"menuIcon\" "+styleHtml+"/>";
			}
			var htm = "<li id=\"menu_"+id+"\" class=\"menuLi\" data-id=\""+id+"\" data-value=\""+value+"\"><div class=\"menuText\">"+menu_datas[i]["menuText"]+"</div>"+iconHtml+"</li>";
			var $menu = $(htm);
			$menu[0].callback = menu_datas[i]["callback"];
			$dialogUl.append($menu);
			
			$menu.on("click", function(ev){
				var that = this;
				var $that = $(this);
				$that.addClass("active");
				setTimeout(function(){
					$that.removeClass("active");
					
					hideDialogCover(function(){
						var menuCallback =  that.callback;
						if(typeof(menuCallback) == "function"){
							menuCallback.call(that);
						}
						
						if(typeof(callbackFn) == "function"){
							var result = {
									"id" : $that.attr("data-id"),
									"menuValue" : $that.attr("data-value"),
									"menuText" : $that.html()
							};
							callbackFn.call(that,  result);
						}
					});
				},100);
				ev.stopPropagation();
			});
		}
	}
	
	if($(".dialogCover_cancel", $dialogCoverContainer).length == 0){
		
		$dialogCoverWrap.append("<ul class=\"dialogCover_cancel\"><li class=\"cancel\">"+_multiLJson['31129']+"</li></ul>");//取消
		$(".cancel", $dialogCoverContainer).on("click", function(ev){
			var $that = $(this);
			$that.addClass("active");
			setTimeout(function(){
				$that.removeClass("active");
				hideDialogCover();
			},100);
			ev.stopPropagation();
		});
	}
	
	$dialogCoverContainer.off("click");
	setTimeout(function(){
		$dialogCoverContainer.on("click", function(ev){
			hideDialogCover();
			ev.stopPropagation();
		});
	}, 300);
	
	$dialogCoverContainer.show();
	setTimeout(function(){
		$dialogCoverMark.addClass("show");
		$dialogCoverWrap.removeClass("hide");
	}, 10);
}

function Dialog(_params){
	var params = {
			autoHide:true, 
			width: "", 
			height:"", 
			expire: 1500, 
			msg: "", 
			buttons:{}, 
			title:"", 
			model:false,
			bgColor: "",
			autoHideCallBack:function(){},
			theme:"dark",
			global:true
		};
	if(typeof(_params) == "string"){
		params.msg = _params;
	}else if(typeof(_params) == "object"){
		$.extend(params, _params);
	}
	var title = params.title;
	var msg = params.msg;
	var buttons = params.buttons;
	var buttonHtml = "";
	if(typeof(buttons) == "object"){
		for(var key in buttons){
			buttonHtml += "<div>"+key+"</div>";
		}
	}
	
	var dialogHtml = "";
	dialogHtml += "<div class=\""+params.theme + " overlay\"></div>";
	dialogHtml += "<div class=\""+params.theme + " contentWindow\">";
	if(title != ""){
		dialogHtml += "<div class=\"title\">"+title+"</div>";
	}
		dialogHtml += "<div class=\"content\">"+msg+"</div>";
	if(buttonHtml != ""){
		dialogHtml += "<div class=\"buttons\">"+buttonHtml+"</div>";
	}
		dialogHtml += "<div class=\"close\"></div>";
	dialogHtml += "</div>";
		
	$("#dialog").html(dialogHtml).attr("global", (params.global == true ? "1" : "0")).show();
	var documentHeight = $("#page-view").height();
	var contentHeight = $("#dialog .contentWindow").height();
	var msgHeight = $("#dialog .contentWindow").height();
	var maxHeight = documentHeight - 200;
	var topHeight = (documentHeight * 0.9 - contentHeight)/2;
	if(contentHeight > maxHeight){
		topHeight = (documentHeight * 0.9 - maxHeight)/2;
	}
	$("#dialog .buttons div").each(function(){
		var $button = $(this);
		var key = $button.text();
		var buttonCallBackFn = buttons[key];
		if(typeof(buttonCallBackFn) == "function"){
			$button.bind("click", function(){
				buttonCallBackFn.call(this);
			});
		}
	});
	$("#dialog .contentWindow").css({
		"height" : params.height, 
		"width" : params.width, 
		"background-color" : params.bgColor, 
		"top":topHeight
	});
	$("#dialog .contentWindow .content").css("max-height", maxHeight-50);
	if(params.model){
		$("#dialog .overlay").show();
	}
	if(params.autoHide){
		setTimeout(function(){
			closeDialog();
			if(typeof(params.autoHideCallBack) == "function"){
				params.autoHideCallBack.call(this);
			}
		}, params.expire);
	}else{
		$("#dialog .close").bind("click", function(){
			closeDialog();
		}).show();
	}
	
}

function closeDialog(){
	$("#dialog .contentWindow").css({
		"-webkit-animation": "zoomOut 0.3s 1 ease-in-out",
  		"animation": "zoomOut 0.3s 1 ease-in-out"
	});
	setTimeout(function(){
		$("#dialog").hide();
	}, 300);
}

/*header*/
$(document).ready(function(){
	if(_clienttype=="Webclient"){
		var eventtype = "click";
		$(".leftTD_top").on(eventtype, function(ev){
			if($("#mobileFrameContainer iframe.mobileFrame").length == 1  && (!isTopfloorPageDisplay()) && (!isRightFrameDisplay()) && (!isCurrFrameViewOpen())){
				//slidePageViewLeft();
			}else{
				// For ie, doHistoryBack() can not can not trigger popstate event
				doBackPage();
			}
			ev.stopPropagation();
		});
			
	}
});

function refreshWebHead(){
	var configString = hasOperation();
	var configArr = configString.split(",");
	
	if($("#mobileFrameContainer iframe.mobileFrame").length == 1 && (!isTopfloorPageDisplay()) && (!isRightFrameDisplay()) && (!isCurrFrameViewOpen())){
		changeLeftImage("none");
	}else{
		changeLeftImage("");
	}
	
	changeMiddlePageName();
}

function changeLeftImage(imgUrl){
	if(imgUrl){
		if(imgUrl == "none"){
			$("#leftButtonName_top_change").hide();
			$("#leftButtonName_top").hide();
		}
	}else{
		$("#leftButtonName_top_change").hide();
		$("#leftButtonName_top").show();
	}
}

function changeMiddlePageName(){
	var $activeFrame = getCurrActiveFrame();
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		var frameWin = activeFrame.contentWindow;
		try{ // 捕获可能存在的js跨域访问出现的异常
			if(typeof(frameWin.toDoMiddlePageName) == "function"){
				var middlePageName_ = frameWin.toDoMiddlePageName();
				$("#middlePageName_top").html(middlePageName_);
			}else{
				$("#middlePageName_top").html(_appname);
			}
		}catch(e){
			$("#middlePageName_top").html(_appname);
		}
	}else{
		$("#middlePageName_top").html(_appname);
	}
}

function hasOperation(){
	var $activeFrame = getCurrActiveFrame();
	if($activeFrame.length > 0){
		var activeFrame = $activeFrame[0];
		var frameWin = activeFrame.contentWindow;
		try{ // 捕获可能存在的js跨域访问出现的异常
			if(typeof(frameWin.hasOperationConfig) == "function"){
				return frameWin.hasOperationConfig();
			}else{
				return "";
			}
		}catch(e){
			return "";
		}
	}else{
		return "";
	}
}