if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

var _top = null;var _win = window;try{while((_win.parent) != _win){_win = _win.parent;if(_win._mobilemode_root_page == true){_top = _win;break;}}}catch(e){}if(_top == null){_top = _win;}

function refreshIScroll(){}

function $p(name){
	var v = Mobile_NS.pageParams[name];
	if(v == null || typeof(v) == "undefined"){
		v = "";
	}
	return v;
}

function openDetail(url, ele, oParam){
	$u(url, ele, oParam);
}

function openUrlFindBeforeCreate(url, ele, oParam){
	Mobile_NS.openUrlFindBeforeCreate(url, ele, oParam);
}

Mobile_NS.addCustomParamToUrl = function(url){
	 var index = url.indexOf("?");
	 var ownParam = {};
	 if(index > 0){
		 var pStr = url.substring(index+1);
		 var pArr = pStr.split("&");
		 for(var i = 0; i < pArr.length; i++){
			 var index2 = pArr[i].indexOf("="); 
			 if(index2 > 0){
				 var name = pArr[i].substring(0, index2);
			     var value = pArr[i].substr(index2 + 1);
			     ownParam[name] = value;
			 }
		 }
	 }
	 for(var pKey in Mobile_NS.customParams){
		 if(pKey == "isOpenedOnTopfloor") continue;
		 if(!ownParam.hasOwnProperty(pKey)){
			 url += (url.indexOf("?") == -1 ? "?" : "&") + pKey + "=" + Mobile_NS.customParams[pKey];
		 }
	 }
	 return url;
};

function $u(url, ele, oParam){
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + "_t=" + timestamp;
	url = Mobile_NS.addCustomParamToUrl(url);
	Mobile_NS.openUrl(url, ele, oParam);
}

function $u_l_replace(url, ele){
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + "_t=" + timestamp;
	url = Mobile_NS.addCustomParamToUrl(url);
	
	if(ele){
		$(ele).addClass("link_active");
		setTimeout(function(){$(ele).removeClass("link_active");},300);
	}
	
	if(_top && typeof(_top.openUrlOnLeftAndReplace) == "function"){
		_top.openUrlOnLeftAndReplace(url);
	}else{
		location.href = url;
	}
}

function $u_r_replace(url, ele){
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + "_t=" + timestamp;
	url = Mobile_NS.addCustomParamToUrl(url);
	
	if(ele){
		$(ele).addClass("link_active");
		setTimeout(function(){$(ele).removeClass("link_active");},300);
	}
	
	if(_top && typeof(_top.openUrlOnLeftAndReplace) == "function"){
		_top.openUrlOnRightAndReplace(url);
	}else{
		location.href = url;
	}
}

function fixIFrameIOSHistoryBug(preLength){
	if(_top && typeof(_top.fixIOSHistoryBug) == "function"){
		_top.fixIOSHistoryBug(preLength, window);
	}
}

function jionActionUrl(invoker, queryStr){
	if(!queryStr){
		queryStr = "";
	}
	if(queryStr.indexOf("&") != 0){
		queryStr = "&" + queryStr;
	}
	var url = "/mobilemode/Action.jsp?invoker=" + invoker + queryStr;
	if(_top && typeof(_top.changeUrl) == "function"){
		url = _top.changeUrl(url);
	}
	return url;
}

Mobile_NS.isRunInMobile = function(){
	var _m = true;
	if(_top && typeof(_top.mobilecheck) == "function"){
		_m = _top.mobilecheck();
	}
	return _m;
};

Mobile_NS.windowOnload = function(fn){
	if(Mobile_NS.isRunInMobile()){
		$(document).ready(fn);
	}else{
		if(window.addEventListener){
			window.addEventListener('load', fn, false);
		}else if(window.attachEvent){
			window.attachEvent("onload", fn);
		}
	}
};

Mobile_NS.log = function(str){
	console.error("移动建模 >> " + str);
};

Mobile_NS.openUrl = function(url, ele, oParam){
	if(ele){
		$(ele).addClass("link_active");
		setTimeout(function(){$(ele).removeClass("link_active");},300);
	}
	
	if(isOpenedOnTopfloor){
		if(_top && typeof(_top.openUrlWithTopfloor) == "function"){
			_top.openUrlWithTopfloor(url, oParam);
		}else{
			location.href = url;
		}
	}else{
		if(_top && typeof(_top.openUrl) == "function"){
			_top.openUrl(url, oParam);
		}else{
			location.href = url;
		}
	}
};

Mobile_NS.openUrlFindBeforeCreate = function(url, ele, oParam){
	if(ele){
		$(ele).addClass("link_active");
		setTimeout(function(){$(ele).removeClass("link_active");},300);
	}
	
	if(_top && typeof(_top.openUrlFindBeforeCreate) == "function"){
		_top.openUrlFindBeforeCreate(url, oParam);
	}else{
		location.href = url;
	}
};

//执行SQL
Mobile_NS.SQL = function(sqlstr, datasource, callbackFn){
	if (arguments.length == 2 && typeof(datasource) == "function") {
		callbackFn = datasource;
		datasource = "";
	}
	var requestParam = {};
	if(sqlstr){
		var sqlparamArr = sqlstr.split(";");
		sqlstr = sqlparamArr[0];
		for(var i = 1; i < sqlparamArr.length; i++){
			var oneParam = sqlparamArr[i];
			var pIndex = oneParam.indexOf("=");
			if(pIndex != -1){
				var paramName = oneParam.substring(0, pIndex);
				var paramValue = oneParam.substring(pIndex + 1);
				requestParam[paramName] = paramValue;
			}
		}
	}
	
	if(!datasource){
		datasource = "";
	}
	var asyncFlag = false;
	if(typeof(callbackFn) == "function"){
		asyncFlag = true;
	}
	
	var result = "";
	$.ajax({
	 	type: "GET",
	 	url: jionActionUrl("com.weaver.formmodel.mobile.security.EDAction", "action=runSQL&content="+sqlstr+"&datasource="+datasource),
	 	data: requestParam,
	 	async: asyncFlag,
	 	success: function(responseText, textStatus) 
	 	{
	 		var data = $.parseJSON(responseText);
	 		var status = data["status"];
	 		if(status != "-1"){	//server端没有出现未知异常
	 			result = data["result"];
	 		}
	 		if(typeof(callbackFn) == "function"){
	 			callbackFn.call(this, result);
	 		}
	 	},
	    error: function(){
	    	//alert("error");
	    }
	});
	return result;
};

Mobile_NS.toMapPage = function(appHomepageId, addressKey, addressValue){
	console.error("函数 Mobile_NS.toMapPage 已被废弃，后面的版本可能会删除这个函数，请慎用。");
	openDetail("/mobilemode/appHomepageView.jsp?appHomepageId="+appHomepageId+"&"+addressKey+"="+encodeURI(addressValue));
};

Mobile_NS.openMap = function(destination, coordinateType){
	var url = "/mobilemode/map.jsp?destination=" + encodeURI(destination);
	if(typeof(coordinateType) != "undefined"){
		url += "&coordinateType=" + coordinateType;
	}
	$u(url);
};

Mobile_NS.progressBar = function(id, config){
	var $obj = $("#" + id);
	if($obj.length == 0){
		return;
	}
	var v = $obj.html();
	v = $.trim(v);
	
	if(v == ""){
		v = 0;
	}else if(isNaN(v)){
		return;
	}
	
	var $csProgressBar = $("<div class=\"csProgressBar\"></div>");
	$csProgressBar.html("<div style=\"width:"+v+"%;\"><span>"+v+"%</span></div>");
	
	var color = "";
	
	var defaultConfig = {"0-40":"#da532c", "41-70":"#e3a21a", "71-100":"#99b433"};
	if(config){
		defaultConfig = config;
	}
	
	v = parseInt(v);
	for(var key in defaultConfig){
		var keyArr = key.split("-");
		if(keyArr.length == 2 && !isNaN(keyArr[0]) && !isNaN(keyArr[1])){
			if(v >= keyArr[0] && v <= keyArr[1]){
				color = defaultConfig[key];
				break;
			}
		}
	}
	
	if(color != ""){
		$csProgressBar.children("div").css("background-color", color);	
	}
	
	$obj.html("");
	$obj.append($csProgressBar);
};

Mobile_NS.createTopfloorPage = function(pageIdOrUrl, param){
	_top.createTopfloorPage(pageIdOrUrl, param);
};

Mobile_NS.closeTopfloorPage = function(callbackFn){
	_top.closeTopfloorPage(callbackFn);
};

Mobile_NS.backTopfloorPage = function(){
	_top.backTopfloorPage();
};

Mobile_NS.refresh = function(pageId){
	if(typeof(pageId) == "undefined"){
		if(_top && typeof(_top.refreshCurrPage) == "function"){
			_top.refreshCurrPage();
		}else{
			location.reload();
		}
	}else{
		var $frame = _top.$("#mobileFrameContainer iframe.mobileFrame[id='appHomepageFrame_"+pageId+"']");
		if($frame.length > 0){
			var f = $frame[0];
			f.src = f.src;
		}else{
			Mobile_NS.log("未找到指定id的页面：" + pageId);
		}
	}
};

Mobile_NS.backToHomepage = function(){
	if(_top && typeof(_top.backToHomepage) == "function"){
		_top.backToHomepage();
	}
};

//web头部点击左边按钮返回前一页
Mobile_NS.backPage = function(){
	if(_top && typeof(_top.doHistoryBack) == "function"){
		_top.doHistoryBack();
	}
};

/*首页内置JS函数，方便在首页进行代码编写和规避一些复杂的代码处理*/
//显示加载器  
Mobile_NS.showLoader = function() {  
	_top.showLoading();
  /*$.mobile.loading('show', {  
      text: '加载中...', //加载器中显示的文字  
      textVisible: true, //是否显示文字  
      theme: 'a',        //加载器主题样式a-e  
      textonly: false,   //是否只显示文字  
      html: ""           //要显示的html内容，如图片等  
  });  */
};

//隐藏加载器
Mobile_NS.hideLoader = function()  
{  
	_top.hideLoading();
  /*$.mobile.loading('hide');*/  
};

Mobile_NS.dynamicRunFn = function(fnName){
	try{
		var beCallCode = fnName + "()";
		eval(beCallCode);
	}catch(e){
		
	}
};

Mobile_NS.dynamicRunCode = function(code){
	try{
		eval(code);
	}catch(e){
		console.log(e);
	}
};

Mobile_NS.dynamicRunCode2 = function(code){
	if(code && code != ""){
		code = decodeURIComponent(code);
		Mobile_NS.dynamicRunCode(code);
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

Mobile_NS.triggerLazyLoad = function(mec_id, params, callbackFn){
	var $lazyLoadContainer = $("#abbr_" + mec_id);
	if($lazyLoadContainer.length == 0){
		return;
	}
	var loaded = $lazyLoadContainer.attr("loaded");
	if(loaded == "true"){
		return;
	}
	$lazyLoadContainer.attr("loaded", "true");
	
	Mobile_NS.triggerRefresh(mec_id, params, callbackFn);
};

Mobile_NS.triggerRefresh = function(mec_id, params, callbackFn){
	var $mecContainer = $("#abbr_" + mec_id);
	if($mecContainer.length == 0){
		return;
	}
	
	if(typeof(params) == "function" && typeof(callbackFn) == "undefined"){
		callbackFn = params;
	}else{
		if(params){
			for(var key in params){
				Mobile_NS.pageParams[key] = params[key];
			}
		}
	}
	
	$mecContainer.find("*").remove();
	
	//动态创建一个loading的div
	var $refreshLoading = $(
			"<div class=\"mec_refresh_loading\"><div class=\"spinner\">" +
				"<div class=\"bounce1\"></div>" +
				"<div class=\"bounce2\"></div>" +
				"<div class=\"bounce3\"></div>" +
			"</div></div>"
	);
	$mecContainer.append($refreshLoading);
	var url = "/mobilemode/MECAction.jsp?action=getMecHtml&mec_id="+mec_id;
	Mobile_NS.ajax(url, Mobile_NS.pageParams, function(data){
		$refreshLoading.hide();
		$refreshLoading.remove();
		
		//还原页数(如果有)，针对列表或者时间轴，以及其它后面会增加的插件，但是要求名称必须是pageNo + mec_id
		eval("if(typeof(pageNo" + mec_id + ") != 'undefined'){pageNo" + mec_id + " = 1}");
		
		$mecContainer.html(data);
		
		$mecContainer.trigger("create"); //触发jqm渲染
		
		Mobile_NS.imgLazyload($mecContainer);
		
		refreshIScroll();
		
		if(_top && typeof(_top.resetActiveFrame) == "function"){
			_top.resetActiveFrame();
		}
		
		if(typeof(callbackFn) == "function"){
			try{
				callbackFn.call(this, mec_id);
			}catch(e){}
		}
	});
};

Mobile_NS.initTapEvent = function($Wrap, stopPropagation){
	if(!$Wrap){
		$Wrap = $(document.body);
	}
	var $tapEle = $("*[ontap]", $Wrap);
	$tapEle.each(function(){
		var tapCode = $(this).attr("ontap");
		$(this).on("click", function(e){
			eval(tapCode);
			if(stopPropagation){
				e.stopPropagation();
			}
		});
	});
	$tapEle.removeAttr("ontap");
};

Mobile_NS.onTap = function(selector, fn){
	
	var $target = null;
	if(typeof selector === "string"){
		$target = $(selector);
	}else if(selector instanceof $){
		$target = selector;
	}else{
		$target = $(selector);
	}
	
	$target.on("click", fn);
	
};

Mobile_NS.getCurrUser = function(){
	return E3005CF26D9F9AC78773E16572827297;
};

var scanQRCodeCallbackFn = null;
Mobile_NS.scanQRCode = function(fn){
	if(_top && typeof(_top.registMPCWindow) == "function"){
		_top.registMPCWindow(window);
	}
	scanQRCodeCallbackFn = fn;
	if(_top && _top.eb_Scan){
		_top.eb_Scan("_p_scanQRCode");
	}else if(typeof(eb_Scan) == "function"){
		eb_Scan("_p_scanQRCode");
	}else{
		location = "emobile:QRCode:_p_scanQRCode";
	}
};

function _p_scanQRCode(result){
	if(scanQRCodeCallbackFn && typeof(scanQRCodeCallbackFn) == "function"){
		scanQRCodeCallbackFn.call(this, result);
	}
}

Mobile_NS.callWebService = function(wsParam){
	var url = jionActionUrl("com.weaver.formmodel.mobile.ws.WSAction", "action=callWS");
	Mobile_NS.ajax(url,{
		"endpoint" : wsParam["endpoint"] || "",
		"namespace" : wsParam["namespace"] || "",
		"operationName" : wsParam["operationName"] || "",
		"parameters" : JSON.stringify(wsParam["parameters"]) || "[]",
	},wsParam["callbackFn"]);
};

Mobile_NS.addJs = function(jsPath, fn){
	var headEle = document.getElementsByTagName("head")[0]; 
	var scriptEle = document.createElement("script");
	scriptEle.setAttribute("type", "text/javascript"); 
	scriptEle.setAttribute("src", jsPath); 
	if(typeof(fn) == "function"){
		scriptEle.onload = fn;
	}
	headEle.appendChild(scriptEle);
}


Mobile_NS.getCurrentPosition = function(fn){

	function innerFn(){
		
		if(_top && typeof(_top.registMPCWindow) == "function"){
			_top.registMPCWindow(window);
		}
		lbsCallbackFn = fn;
		
		if(_top && typeof(_top.isRunInEmobile) == "function" && _top.isRunInEmobile()){
			location = "emobile:gps:_p_getLBSResult";
		}else if(_top && _top.eb_GetLocation){
			_top.eb_GetLocation("_p_wx_getLBSResult");
		}else if(typeof(eb_GetLocation) == "function"){
			eb_GetLocation("_p_wx_getLBSResult");
		}else{
			navigator.geolocation.getCurrentPosition(function(position){
				var timestamp = (new Date()).valueOf();  
				var gpsstr = timestamp+","+position.coords.latitude+","+position.coords.longitude;
				_p_getLBSResult(gpsstr, "gps");
			},function(error){
				var errMsg = "";
				switch(error.code){
				    case error.PERMISSION_DENIED:
				      errMsg = _multiLViewJson['383802'];//用户拒绝对获取地理位置的请求。
				      break;
				    case error.POSITION_UNAVAILABLE:
				      errMsg = _multiLViewJson['383803'];//位置信息是不可用的。
				      break;
				    case error.TIMEOUT:
				      errMsg = _multiLViewJson['383804'];//请求用户地理位置超时。
				      break;
				    case error.UNKNOWN_ERROR:
				      errMsg = _multiLViewJson['129710'];//未知错误
				      break;
			    }
				
				var result = {};
				result["status"] = "0";
				result["errMsg"] = errMsg;	//错误信息
				result["lng"] = "";	//精度
				result["lat"] = "";	//纬度
				result["addr"] = "";	//中文地址
				result["province"] = "";	//省份
				result["city"] = "";	//城市
				result["district"] = "";	//区
				result["street"] = "";	//街道
				result["streetNumber"] = "";	//街道号码
				
				fn.call(this, result);
				
			},{
				enableHighAcuracy: true,
				maximumAge: 3000
			});
		}
	}
	
	
	if(typeof(BMap) == "undefined"){
		Mobile_NS.addJs("/mobilemode/js/baidu/api_https_wev8.js", function(){
			innerFn();
		});
	}else{
		innerFn();
	}
};

function _p_wx_getLBSResult(longitude, latitude){
	var timestamp = (new Date()).valueOf();  
	var gpsstr = timestamp+","+latitude+","+longitude;
	_p_getLBSResult(gpsstr, "google");
}

function _p_getLBSResult_error(result){
	var index = result.lastIndexOf(","); 
	var status = result.substring(index+1);
	var errmsg = "";
	var errnum = "2,3,4,5,6,11,13,14";
	if(errnum.indexOf(status)){
		errmsg = result.substring(0,index);
	}
	alert(_multiLViewJson['383751']+", "+errmsg+", "+_multiLViewJson['383805']+"："+status);//定位失败 响应码
}

var lbsCallbackFn = null;
function _p_getLBSResult(result, gpsType){
	
	function parseLongLat(longitude, latitude, type){
		
		function parseAddress(point){
			
			var geoc = new BMap.Geocoder();
			geoc.getLocation(point, function(rs){
				var addComp = rs.addressComponents;
				var addr = addComp.province + addComp.city + addComp.district + addComp.street + addComp.streetNumber;
				var result = {};
				result["status"] = "1";
				result["errMsg"] = "";	//错误信息
				result["lng"] = point.lng;	//精度
				result["lat"] = point.lat;	//纬度
				result["addr"] = addr;	//中文地址
				result["province"] = addComp.province;	//省份
				result["city"] = addComp.city;	//城市
				result["district"] = addComp.district;	//区
				result["street"] = addComp.street;	//街道
				result["streetNumber"] = addComp.streetNumber;	//街道号码
				if(lbsCallbackFn && typeof(lbsCallbackFn) == "function"){
					lbsCallbackFn.call(this, result);
				}
			});
		}
		
		var convertor = new BMap.Convertor();
		if(type == "google"){	//谷歌坐标
			
			var googlePoint = new BMap.Point(longitude, latitude);
			convertor.translate([googlePoint], 3, 5, function(data){
				var point = data.points[0];
				parseAddress(point);
			});	
			/*
			var googlePoint = new BMap.Point(longitude, latitude);
			BMap.Convertor.translate(googlePoint, 2, parseAddress);
			*/
		}else if(type == "baidu"){	//百度坐标
			var baiduPoint = new BMap.Point(longitude, latitude);
			parseAddress(baiduPoint);
		}else if(type == "gps"){	//原始坐标
			
			var gpsPoint = new BMap.Point(longitude, latitude);
			convertor.translate([gpsPoint], 1, 5, function(data){
				var point = data.points[0];
				parseAddress(point);
			});
			/*
			var gpsPoint = new BMap.Point(longitude, latitude);
			BMap.Convertor.translate(gpsPoint, 0, parseAddress);
			*/
		}
	}
	
	
	if(result){
		var resultArr = result.split(",");
		if(resultArr.length >= 3){
			if(!gpsType){
				gpsType = "google";	//emobile使用的是google坐标
			}
			parseLongLat(resultArr[2], resultArr[1], gpsType);
		}
	}
}

Mobile_NS.openHrmBrowser = function(fieldId, fieldSpanId, isMuti){
	if(_top && typeof(_top.openHrmBrowser) == "function"){
		_top.openHrmBrowser(window, fieldId, fieldSpanId, isMuti);
	}
};

Mobile_NS.openTreeBrowser = function(fieldId, fieldSpanId, browserId, browserName, browserText,isMuti){
	if(_top && typeof(_top.openTreeBrowser) == "function"){
		_top.openTreeBrowser(window, fieldId, fieldSpanId, browserId, browserName, browserText,isMuti);
	}
};

Mobile_NS.openCommonBrowser = function(fieldId, fieldSpanId, browserId, browserName, browserText, params){
	if(_top && typeof(_top.openCommonBrowser) == "function"){
		_top.openCommonBrowser(window, fieldId, fieldSpanId, browserId, browserName, browserText, params);
	}
};

Mobile_NS.openBrowser = function(fieldId, fieldSpanId, browserId, browserName, browserText){
	if(browserId == "1"){	//人力资源
		Mobile_NS.openHrmBrowser(fieldId, fieldSpanId, false);
	}else if(browserId == "17"){	//多人力资源
		Mobile_NS.openHrmBrowser(fieldId, fieldSpanId, true);
	}else if(browserId == "256"){	//多人力资源
		Mobile_NS.openTreeBrowser(fieldId, fieldSpanId, browserId, browserName, browserText, false);
	}else if(browserId == "257"){	//多人力资源
		Mobile_NS.openTreeBrowser(fieldId, fieldSpanId, browserId, browserName, browserText, true);
	}else{
		var params = {}; //浏览框联动参数 如：{"_nj":"23","_bj":"24"};
		if(fieldId.indexOf("_as_field") != -1){//列表高级搜索
			var $advancedSearch = $("#"+fieldId).parents(".as-container");
			$("[search='true']", $advancedSearch).each(function(){
				var $that = $(this);
				var fieldname = "fieldname_"+$that.attr("fieldname").toLowerCase();
				var fieldtype = $that.attr("fieldtype");
				if($that.attr("fieldtype") == "date" || $that.attr("fieldtype") == "time" || $that.attr("fieldtype") == "numb" || $that.attr("fieldtype") == "thousandnumb"){//单独处理日期或者时间，数字
					params[fieldname] = "";
				}else{
					var v = $.trim($that.val());
					if(fieldtype != "browser" && v.length > 30){
						v = "";
					}
					params[fieldname] = v;
				}
			});
		}else{
			var $mainform = $(".mobileform");
			var getFieldParams = function($form, _params, detailtablename){
				$("[name^='fieldname_']", $form).each(function(){
					var _fieldname = $(this).attr("name").toLowerCase(); // nj
					var fieldvalue = $(this).val(); //23
					if(detailtablename){
						_fieldname = "fieldname_"+detailtablename + "_" + _fieldname.replace("fieldname_", "");
					}
					var fieldhtmltype = $(this).attr("fieldhtmltype");
					if(fieldhtmltype != "3" && fieldvalue.length > 30){
						fieldvalue = "";
					}
					_params[_fieldname] = fieldvalue;
				});
				return _params;
			};
			//主表字段
			params = getFieldParams($mainform, params);
			//明细表字段
			$(".detailtableform").each(function(){
				var $detailform = $(this);
				var detailformmecid = $detailform.attr("name");
				var detailtablename = $("input[name='detailtablename_"+detailformmecid+"']").val();
				params = getFieldParams($detailform, params, detailtablename);
			});
		}
		Mobile_NS.openCommonBrowser(fieldId, fieldSpanId, browserId, browserName, browserText, params);
	}
};

Mobile_NS.clearBrowser = function(fieldId, fieldSpanId){
	$("#" + fieldId).val("");
	$("#" + fieldSpanId).html("");
	$("#" + fieldSpanId).parent().removeClass("hasValue");
	$("#" + fieldId).trigger("change");
	$("#" + fieldId).trigger("input");
};

var _viewOpenCount = 0;
var _viewCloseFnArr = new Array();
Mobile_NS.isViewOpen = function(){
	return _viewOpenCount > 0;
};

Mobile_NS.setViewOpen = function(viewCloseFn){
	_viewOpenCount ++;
	_viewCloseFnArr.push(viewCloseFn);
	if(_top && typeof(_top.refreshWebHead) == "function"){
		setTimeout(_top.refreshWebHead, 300);
	}
	if(_top && typeof(_top.pushHistoryState) == "function"){
		_top.pushHistoryState({viewOpen:1});
	}
};

Mobile_NS.setViewClose = function(){
	_viewOpenCount --;
	var viewCloseFn = _viewCloseFnArr[_viewOpenCount];
	_viewCloseFnArr.splice(_viewOpenCount, 1);
	viewCloseFn.call(this);
	if(_top && typeof(_top.refreshWebHead) == "function"){
		setTimeout(_top.refreshWebHead, 300);
	}
};

Mobile_NS.isHidden = function($obj){
	return $obj.css("display") == "none" || $obj.css("visibility") == "hidden";
};

Mobile_NS.getCurrentWindow = function(){
	return window;
};

/**
 * 打开定位页面
 * {
 * 	posType : "1",		//定位类型, 默认"1"。 1.只显示当前位置，不显示周围热点     2.显示当前位置同时显示周围热点     3.显示当前位置和周围热点，并允许改变当前位置及更新周围热点
 * 	btnText : "确定",	//按钮文字, 默认"确定"。
 * 	poiRadius : 500,	//poi半径，单位米，默认500。
 * 	numPois : 12,		//列举poi的数量，默认12。
 * 	success : callbackFn	//回调函数 无默认。function(gpsstr, address){	//gpsstr: "31.173211,121.475134"	//address: "上海市浦东新区耀华支路39弄9号"	}
 * }
 */
Mobile_NS.openLBSWin = function(paramObj){
	if(_top && typeof(_top.registLBSBackWindow) == "function"){
		
		_top.registLBSBackWindow(window);
		
		var queryStr = "";
		var callbackFn = null;
		if(typeof(paramObj) == "function"){
			callbackFn = paramObj;
		}else{
			callbackFn = paramObj.success;
			if(paramObj.posType){
				queryStr += "&posType=" + paramObj.posType;
			}
			if(paramObj.btnText){
				queryStr += "&btnText=" + paramObj.btnText;
			}
			if(paramObj.poiRadius){
				queryStr += "&poiRadius=" + paramObj.poiRadius;
			}
			if(paramObj.numPois){
				queryStr += "&numPois=" + paramObj.numPois;
			}
		}
		
		window._LBSLoaded = function(result){
			var r_arr = result.split(";;");
			callbackFn.call(this, r_arr[0], r_arr[1]);
		};
		
		if(queryStr != ""){
			queryStr = "?" + queryStr.substring(1);
		}
		
		$u("/mobilemode/lbs.jsp" + queryStr);
	}else{
		Mobile_NS.log("无法定位顶部页面 或者 顶部页面无registLBSBackWindow方法。");
	}
};

Mobile_NS.refreshPrevPageList = function(listId){
	var $activeFrame = _top.$("#mobileFrameContainer iframe.activeFrame");
	var $prevFrame = $activeFrame.prev("iframe.mobileFrame");
	if($prevFrame.length > 0){
		try{
			var frameWin = $prevFrame[0].contentWindow;
			var _M_NS = frameWin.Mobile_NS;
			if(typeof(_M_NS.refreshList) == "function"){
				_M_NS.refreshList(listId);
			}
			if(typeof(_M_NS.refreshTimelinr) == "function"){
				_M_NS.refreshTimelinr(listId);
			}
			if(_M_NS.GridTable && typeof(_M_NS.GridTable.refresh) == "function"){
				_M_NS.GridTable.refresh(listId);
			}
		}catch(e){
			Mobile_NS.log(e);
		}
	}
};

Mobile_NS.refreshSpecifiedList = function(appHomepageId, listId, listparams){
	
	function refreshSpecifiedListInner(id, listId, theWin, listparams){
		
		if(id.indexOf(".") != -1){
			var _id = id.substring(0, id.indexOf("."));
			var _id2 = id.substring(id.indexOf(".") + 1);
			
			var $frame = theWin.$("#appHomepageFrame_" + _id);
			if($frame.length == 0){
				$frame = theWin.$("iframe[pageid='appHomepageFrame_"+_id+"']");
			}
			if($frame.length > 0){
				var frameWin = $frame[0].contentWindow;
				refreshSpecifiedListInner(_id2, listId, frameWin, listparams);
			}
		}else{
			var $frame = theWin.$("#appHomepageFrame_" + id);
			if($frame.length == 0){
				$frame = theWin.$("iframe[pageid='appHomepageFrame_"+id+"']");
			}
			if($frame.length > 0){
				try{
					var frameWin = $frame[0].contentWindow;
					var _M_NS = frameWin.Mobile_NS;
					if(typeof(_M_NS.refreshList) == "function"){
						_M_NS.refreshList(listId, listparams);
					}
					if(typeof(_M_NS.refreshTimelinr) == "function"){
						_M_NS.refreshTimelinr(listId, listparams);
					}
					if(_M_NS.GridTable && typeof(_M_NS.GridTable.refresh) == "function"){
						_M_NS.GridTable.refresh(listId, listparams);
					}
				}catch(e){
					Mobile_NS.log(e);
				}
			}
		}
	}
	
	refreshSpecifiedListInner(appHomepageId, listId, _top, listparams);
};

var listenPgChangeFn = new Array();
Mobile_NS.listenPageChange = function(fn){
	listenPgChangeFn.push(fn);
}

Mobile_NS.triggerPageChange = function(source){
	for(var i = 0; i < listenPgChangeFn.length; i++){
		var fn = listenPgChangeFn[i];
		if(typeof(fn) == "function"){
			fn.call(this, source);
		}
	}
}

Mobile_NS.groupViewImg = function(source){
	$("img[data-groupid]").each(function(){
		var that = this;
		var hasEvent = $(that).attr("data-groupev") == "true";
		if(!hasEvent){
			$(that).attr("data-groupev", "true");
			$(that).click(function(e){
				var groupid = $(this).attr("data-groupid");
				var currSrc = $(this).attr("src");
				
				var imgSrcs = "";
				$("img[data-groupid='"+groupid+"']").each(function(){
					var src = $(this).attr("src");
					//编辑布局点击图片时会进入空白页面问题处理
					if(src == "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAANSURBVBhXY3j37t1/AAliA8r60tGjAAAAAElFTkSuQmCC") return;
					imgSrcs += src + "|";
				});
				if(imgSrcs != ""){
					imgSrcs = imgSrcs.substring(0, imgSrcs.length - 1);
				}
				
				imgSrcs = encodeURIComponent(imgSrcs);
				currSrc = encodeURIComponent(currSrc);
				var url = "/mobilemode/displayPicOnMobile.jsp?imgSrc="+imgSrcs+"&imgSrcActive="+currSrc+"&1=1";
				$u(url);
				
				e.stopPropagation();
			});
		}
	});
};

Mobile_NS.pressImgForSave = function(){
	if(!(typeof(_top.isRunInEmobile) == "function" && _top.isRunInEmobile())){
		return;
	}
	$("img").each(function(){
		var $imgEle = $(this);
		var flag = $imgEle.attr("data-press-save-event");
		if(flag == "1"){
			return;
		}
		$imgEle.attr("data-press-save-event", "1");
		var mc = new Hammer($imgEle[0], {
			recognizers: [
	      		[Hammer.Press,{ time : 500 }]
	      	]
		});
	    
		mc.on('press', function(ev) {
			var imgSrc = $(ev.target).attr("src");
			if(imgSrc == null || imgSrc == ""){
				return;
			}
			_top.addDialogCover([
	      		{id : "a", menuText : "<div style='text-align: center;margin-left: -18px;font-size: 18px;color: #017afd;'>"+_multiLViewJson['383806']+"</div>", callback : function(){//保存图片
					location = "emobile:saveImage:"+imgSrc+":111";
	      		}},
	      		{id : "b", menuText : "<div style='text-align: center;margin-left: -18px;font-size: 18px;color: #017afd;'>"+_multiLViewJson['130277']+"</div>", callback : function(){//查看
	      			var url = "/mobilemode/displayPicOnMobile.jsp?imgSrc="+imgSrc+"&imgSrcActive="+imgSrc+"&1=1";
					$u(url);
	      		}}
	      	]);
		});	
	});
};

Mobile_NS.encrypt = function(content, unEncodeWhenFirewallDisabled){
	if(typeof(unEncodeWhenFirewallDisabled) == "undefined"){
		unEncodeWhenFirewallDisabled = false;
	}
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.security.EDAction", "action=encrypt&content="+encodeURIComponent(content));
	$.ajax({
	    url: url,
	    data: {"unEncodeWhenFirewallDisabled":unEncodeWhenFirewallDisabled},
	    async: false,
	    dataType: 'json',
	    type: 'get',
	    success: function (res) {
	    	content = res["content"];
	    	if(!content){
	    		content = "";
	    		var msg = res["msg"];
	    		if(msg && msg != ""){
	    			alert(msg);
	    		}
	    	}
	    },
	    error: function(res){
	    	//alert("error");
	    }
	});
	return content;
}
	
function downloadattach(fileid,filename){
	top.location.href = "/download.do?fileid="+fileid+"&module=3&scope=11&filename="+encodeURI(filename)+"";
	_top.hideLoading();
}

Mobile_NS.addFormmodeDataShare = function(modelid, billid, callbackFn){
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=addFormmodeDataShare");
	Mobile_NS.ajax(url, {"modelid":modelid, "billid":billid}, callbackFn);
};

Mobile_NS.doNavgationJs = function(code){
	try{
		code = decodeURIComponent(code);
		if(code.indexOf("javascript:") == 0){
			var script = code.substring("javascript:".length);
			eval(script);
		}
	}catch(e){
		console.log(e);
	}
};

Mobile_NS.Alert = function(msg, autoHide, callbackFn){
	if(_top && typeof(_top.Dialog) == "function"){
		var params = {msg:msg};
		if(typeof(autoHide) == "boolean" && !autoHide){
			params["autoHide"] = false;
			params["global"] = false;
			params["theme"] = "light";
			params["model"] = true;
			if(callbackFn instanceof Array){
				buttons = {};
				var buttonName = (callbackFn[0] == undefined ? _multiLViewJson['83446'] : callbackFn[0]);//确定
				buttons[buttonName] = function(){
					if(typeof(callbackFn[1]) == "function"){
						callbackFn[1].call(this);
					}
					$(this).parents("#dialog").hide();
				};
				params["buttons"] = buttons;
			}else{
				var buttonsName =  _multiLViewJson['83446'];//确定
				params["buttons"] = {buttonsName: function(){
					if(typeof(callbackFn) == "function"){
						callbackFn.call(this);
					}
					$(this).parents("#dialog").hide();
				}};
			}
		}
		if(autoHide == true && typeof(callbackFn) == "function"){
			params["autoHideCallBack"] = callbackFn;
		}
		_top.Dialog(params);
	}else{
		alert(msg);
	}
};

Mobile_NS.Confirm = function(msg, title, fn1, fn2){
	if(_top && typeof(_top.Dialog) == "function"){
		var confirmbtn = _multiLViewJson['16631'];//确认
		var cancelbtn = _multiLViewJson['31129'];//取消
		var params = {
				autoHide:false, 
				width: "", 
				height:"", 
				msg: msg, 
				buttons:{
					confirmbtn:function(){
						if(typeof(fn1) == "function"){
							fn1.call(this);
						}
						$(this).parents("#dialog").hide();
					},
					cancelbtn:function(){
						if(typeof(fn2) == "function"){
							fn2.call(this);
						}
						$(this).parents("#dialog").hide();
					}
				}, 
				title:title, 
				model:true,
				bgColor: "",
				_top:"40%",
				autoHideCallBack:function(){},
				theme:"light",
				global:false
			};
		var buttons = {};
		if(fn1 instanceof Array && fn2 instanceof Array){
			if(fn1.length == 2 && typeof(fn1[1]) == "function"){
				buttons[fn1[0]] = function(){
					fn1[1].call(this);
					$(this).parents("#dialog").hide();
				};
			}
			if(fn2.length == 2 && typeof(fn2[1]) == "function"){
				buttons[fn2[0]] = function(){
					fn2[1].call(this);
					$(this).parents("#dialog").hide();
				};
			}
			params.buttons = buttons;
		}else if(fn1 instanceof Array){
			if(fn1.length == 2 && typeof(fn1[1]) == "function"){
				buttons[fn1[0]] = function(){
					fn1[1].call(this);
					$(this).parents("#dialog").hide();
				};
			}
			buttons[cancelbtn] = function(){
				$(this).parents("#dialog").hide();
			};
			params.buttons = buttons;
		}else if(fn1 instanceof Array){
			buttons[confirmbtn] = function(){
				$(this).parents("#dialog").hide();
			};
			if(fn2.length == 2 && typeof(fn2[1]) == "function"){
				buttons[fn2[0]] = function(){
					fn2[1].call(this);
					$(this).parents("#dialog").hide();
				};
			}
			params.buttons = buttons;
		}
		_top.Dialog(params);
	}else{
		if(!confirm(msg)){
			if(typeof(fn1) == "function"){
				fn1.call(this);
			}else if(fn1 instanceof Array && typeof(fn1[1]) == "function"){
				fn1[1].call(this);
			}
		}else{
			if(typeof(fn2) == "function"){
				fn2.call(this);
			}else if(fn2 instanceof Array && typeof(fn2[1]) == "function"){
				fn2[1].call(this);
			}
		}
	}
};

Mobile_NS.imgLazyload = function($wrap, imgExpr, containerExpr){
	if(!imgExpr){
		imgExpr = "img.lazy";
	}
	if(!containerExpr){
		containerExpr = "#scroll_wrapper";
	}
	var $img;
	if($wrap){
		$img = $(imgExpr, $wrap);
	}else{
		$img = $(imgExpr);
	}
	$img.lazyload({
		container : containerExpr
	});
};

Mobile_NS.isOnline = function(callbackFn){
	if(typeof(callbackFn) == "function"){
		if(!window.onlinejs){
			Mobile_NS.addJs("/mobilemode/js/online/online.js", function(){
				callbackFn.call(this, window.onLine);
			});
		}else{
			callbackFn.call(this, window.onLine);
		}
		
	}
};

Mobile_NS.getLayoutUrl = function(modelid, uitype, billid){
	if(typeof(uitype) == "undefined") uitype = "0";
	var url = "/mobilemode/layout.jsp?appid=" + appid + "&modelid=" + modelid + "&uitype=" + uitype;
	if(typeof(billid) != "undefined") url += "&billid=" + billid;
	return url;
};

Mobile_NS.callMobile = function(tel){
	if(_top && typeof(_top.addDialogCover) == "function"){
		var telFace = tel;
		if(tel.length == 11 && tel.indexOf("-") == -1){ //手机号
			telFace = tel.substring(0, 3) + "-" + tel.substring(3, 7) + "-" + tel.substring(7);
		}
		_top.addDialogCover([
      		{id : "a", menuText : "<div style='text-align: center;margin-left: -18px;font-size: 20px;color: #017afd;'>"+_multiLViewJson['383807']+"&nbsp;"+telFace+"</div>", callback : function(){//呼叫
				location.href = "tel:" + tel;
      		}},
      		{id : "b", menuText : "<div style='text-align: center;margin-left: -18px;font-size: 20px;color: #017afd;'>"+_multiLViewJson['125977']+"</div>", callback : function(){//发送短信
      			location.href = "sms:" + tel;
      		}}
      	]);
	}else{
		location.href = "tel:" + tel;
	}
};

Mobile_NS.doRefreshRemind = function(mecid){
	var mecidArr = [];
	if(mecid){
		mecidArr.push(mecid);
	}else{
		$(".MEC_NumberRemind").each(function(){
			var $abbr = $(this).closest("abbr");
			var id = $abbr.attr("id").substring("abbr_".length);
			if(mecidArr.toString().indexOf(id) == -1){
				mecidArr.push(id);
			}
		});
	}

	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getRemindNums&ids="+mecidArr.toString());
	Mobile_NS.ajax(url, Mobile_NS.pageParams, function(responseText){
		console.log(responseText);
		var result = $.parseJSON(responseText);
 		var status = result["status"];
 		if(status == "1"){	
 			var data = result["data"];
 			for(var id in data){
 				var valueArr = data[id];
 				var $abbr = $("#abbr_" + id);
 				$(".MEC_NumberRemind", $abbr).each(function(i){
 					var value = valueArr[i];
 					if(!isNaN(value) && Number(value) > 0){
 						var remindclass = "MEC_NumberRemind" + value.length;
 						$(this)[0].className = "MEC_NumberRemind";
 						$(this).addClass(remindclass).html(value).show();
 					}else{
 						$(this).hide();
 					}
 					
 				});
 			}
 		}else{
 			console.error("Mobile_NS.refreshRemind Error:" + result["errorMsg"]);
 		}
	});
	
};

Mobile_NS.refreshRemind = function(id, mecid){
	
	function refreshRemindInner(id, mecid, theWin){
		
		if(id.indexOf(".") != -1){
			var _id = id.substring(0, id.indexOf("."));
			var _id2 = id.substring(id.indexOf(".") + 1);
			
			var $frame = theWin.$("#appHomepageFrame_" + _id);
			if($frame.length == 0){
				$frame = theWin.$("iframe[pageid='appHomepageFrame_"+_id+"']");
			}
			if($frame.length > 0){
				var frameWin = $frame[0].contentWindow;
				refreshRemindInner(_id2, mecid, frameWin);
			}
		}else{
			var $frame = theWin.$("#appHomepageFrame_" + id);
			if($frame.length == 0){
				$frame = theWin.$("iframe[pageid='appHomepageFrame_"+id+"']");
			}
			if($frame.length > 0){
				try{
					var frameWin = $frame[0].contentWindow;
					frameWin.Mobile_NS.doRefreshRemind(mecid);
				}catch(e){
					Mobile_NS.log(e);
				}
			}
		}
	}
	
	if(typeof(id) == "undefined"){
		Mobile_NS.doRefreshRemind();
	}else if(id.length == 32){
		Mobile_NS.doRefreshRemind(id);
	}else{
		refreshRemindInner(id, mecid, _top);
	}
	
};

Mobile_NS.refreshList = function(mec_id, listparams, callbackFn){
	if(!mec_id || mec_id == ""){	//没有列表组件id，取页面第一个列表组件的id
		$("abbr[m_type]").each(function(){
			var t = $(this).attr("m_type");
			if(t == "List" || t == "UrlList" || t == "Timelinr" || t == "GridTable" || t == "UrlGridTable"){
				mec_id = $(this).attr("id").substring("abbr_".length);
				return false;
			}
		});
	}
	
	if(!mec_id || mec_id == ""){
		return;
	}
	var $abbr = $("#abbr_" + mec_id);
	var type = $abbr.attr("m_type");
	if(!(type == "List" || type == "UrlList" || type == "Timelinr" || type == "GridTable" || type == "UrlGridTable")){
		console.error("不支持的插件类型调用refreshList脚本：" + type);
		return;
	}
	
	if(type == "List" || type == "UrlList"){
		Mobile_NS.List.refreshList(mec_id, listparams, callbackFn);
		return;
	}
	if(type == "Timelinr"){
		Mobile_NS.refreshTimelinr(mec_id, listparams, callbackFn);
		return;
	}
	if(type == "GridTable"){
		Mobile_NS.GridTable.refresh(mec_id, listparams, callbackFn);
		return;
	}
	if(type == "UrlGridTable"){
		Mobile_NS.UrlGridTable.refresh(mec_id, listparams, callbackFn);
		return;
	}
};

Mobile_NS.dateDiff = function(startDate, endDate){
	var startTime = new Date(Date.parse(startDate.replace(/-/g,   "/"))).getTime();     
    var endTime = new Date(Date.parse(endDate.replace(/-/g,   "/"))).getTime();     
    var dates = (endTime - startTime)/(1000*60*60*24);     
    return dates;  
};

Mobile_NS.sendEmobileMsg = function(receivers, content, msgurl, msgtype, callbackFn){
	if(typeof(msgtype) == "function"){
		callbackFn = msgtype;
		msgtype = "";
	}
	Mobile_NS.sendMsg(1, receivers, content, msgurl, msgtype, "", callbackFn);
};

Mobile_NS.sendWechatMsg = function(receivers, content, msgurl, pushkey, callbackFn){
	Mobile_NS.sendMsg(2, receivers, content, msgurl, "", pushkey, callbackFn);
};

Mobile_NS.sendMsg = function(pushtype, receivers, content, msgurl, msgtype, pushkey, callbackFn){
	var url = jionActionUrl("com.weaver.formmodel.mobile.pushmsg.servlet.PushMsgAction", "action=pushmsg");
	var params = {pushtype:pushtype,receivers:receivers,content:content,msgurl:msgurl,wechatpushkey:pushkey};
	if(msgtype) params.msgtype = msgtype;
	Mobile_NS.ajax(url, params, function(responseText){
		var result = $.parseJSON(responseText);
 		var status = result["status"];
 		if(status == "1"){
 			if(typeof(callbackFn) == "function"){
 				callbackFn.call(this);
 			}else{
 				Mobile_NS.Alert(_multiLViewJson['383808']);//发送提醒成功
 			}
 			
 		}else{
 			Mobile_NS.Alert("Mobile_NS.sendWechatMsg Error:" + result["errorMsg"], false);
 			console.error("Mobile_NS.sendWechatMsg Error:" + result["errorMsg"]);
 		}
	});
};

Mobile_NS.formatNumber = function(num, pattern) {
	var vprefix = "";
	var vsuffix = "";
	var m = /^\[(.*?)\]/.exec(pattern);//获取开头[]
	if(m) {
		vprefix = m[1];
	}				
	m = /.*\[([^\]]*)\]$/.exec(pattern);
	if(m) {
		vsuffix = m[1];
	}
	if(vprefix.length > 0 && vprefix == vsuffix){
		var pstr = pattern.substring(1,pattern.length - 1);
		if(vsuffix == pstr) vprefix = "";
	}
	pattern = pattern.replace(/\[.*?\]/g,'');//去除所有中括号及内容
    if (!isNaN(parseFloat(num)) && isFinite(num) && pattern.length > 0) {
		var comma = false;  
		if(pattern.indexOf("#,##") != -1) comma = true;  				
		var fmtarr = pattern ? pattern.split('.') : [''];
		var precision = -1;
		if(fmtarr.length > 1){
			if(fmtarr[1].length > 0 && fmtarr[1].match(/0/g)){
				precision = fmtarr[1].match(/0/g).length;
			}else{
				precision = 0;
			}
		}
		var parts;
        num = Number(num);
	    num = (precision !== -1 ? num.toFixed(precision) : num).toString(); 
        parts = num.split('.');
        if(comma){
	        parts[0] = parts[0].toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1' + (','));
        }
        num = parts.join('.');
    }
    return vprefix + num + vsuffix;
}  
