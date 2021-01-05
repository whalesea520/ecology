var timelinrDynamicParams = {};

Mobile_NS.Timelinr = {};

Mobile_NS.getTimelinrDynamicParam = function(mec_id){
	var timelinrDynamicParam = timelinrDynamicParams[mec_id];
	if(!timelinrDynamicParam){
		timelinrDynamicParam = {};
		timelinrDynamicParams[mec_id] = timelinrDynamicParam;
	}
	return timelinrDynamicParam;
};

Mobile_NS.loadTimelinrDataWithPage = function(mec_id, totalPageCount, sqlwhere){
	
	eval("if(typeof(pageNo" + mec_id + ") == 'undefined'){pageNo" + mec_id + " = 1}");
	eval("pageNo" + mec_id + "++;");
	eval("var timelinrPageNo = pageNo" + mec_id + ";");
	
	var $moreBtn = $("#more" + mec_id);
	$moreBtn.hide();
	
	var $loading = $("#more_loading" + mec_id);
	if($loading.length == 0){
		$loading = $(
				"<div id=\"more_loading"+mec_id+"\"><div class=\"spinner\">" +
					"<div class=\"bounce1\"></div>" +
					"<div class=\"bounce2\"></div>" +
					"<div class=\"bounce3\"></div>" +
				"</div></div>"
		);
		$moreBtn.before($loading);
	}
	
	var requestParam = {};
	for(var key in Mobile_NS.pageParams){
		requestParam[key] = Mobile_NS.pageParams[key];
	}
	
	var queryStr = "action=getTimelinrDataWithPage&mec_id="+mec_id+"&pageNo="+timelinrPageNo+"&sqlwhere="+decodeURIComponent(sqlwhere);
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", queryStr);
	Mobile_NS.ajax(url, requestParam, function(data){
		$loading.hide();
		$loading.remove();
		
		var $timelinrContainer = $("#timelinr" + mec_id);
		var $pageObj = $(data.substring(data.indexOf("<tr"),data.lastIndexOf("</tr>")));
		$timelinrContainer.append($pageObj);
		
		if(timelinrPageNo >= totalPageCount){
			$moreBtn.hide();
		}else{
			$moreBtn.show();
		}
		
		Mobile_NS.imgLazyload($pageObj);
		
		refreshIScroll();
		
		if(top && typeof(top.resetActiveFrame) == "function"){
			top.resetActiveFrame();
		}
		
	});
};

Mobile_NS.Timelinr.refreshTimestamp = {};

Mobile_NS.refreshTimelinr = function(mec_id, timelinrParams, callbackFn){

	if(!mec_id || mec_id == ""){	//没有时间轴组件id，取页面第一个时间轴组件的id
		var $timelinrContainer = $(".timelinrContainer");
		if($timelinrContainer.length > 0){
			var timelinrid = $timelinrContainer.attr("id");
			mec_id = timelinrid.substring("timelinr".length);
		}else{	//不存在时间轴插件
			return;
		}
	}else{
		var $timelinrContainer = $("#timelinr" + mec_id);
		if($timelinrContainer.length == 0){	//找不到指定id的时间轴
			return;
		}
	}
	
	var timestamp = (new Date()).valueOf();	//时间戳
	Mobile_NS.Timelinr.refreshTimestamp[mec_id] = timestamp;
	
	var timelinrDynamicParam = Mobile_NS.getTimelinrDynamicParam(mec_id);
	
	if(timelinrParams){
		var timelinrparamArr = timelinrParams.split(";");
		for(var i = 0; i < timelinrparamArr.length; i++){
			var oneParam = timelinrparamArr[i];
			var pIndex = oneParam.indexOf("=");
			if(pIndex != -1){
				var paramName = oneParam.substring(0, pIndex);
				var paramValue = oneParam.substring(pIndex + 1);
				timelinrDynamicParam[paramName] = paramValue;
			}
		}
	}
	
	var requestParam = {};
	for(var key in Mobile_NS.pageParams){
		requestParam[key] = Mobile_NS.pageParams[key];
	}
	for(var key in timelinrDynamicParam){
		requestParam[key] = timelinrDynamicParam[key];
	}
	
	eval("pageNo" + mec_id + " = 1;");
	
	var $timelinrContainer = $("#timelinr" + mec_id);
	$timelinrContainer.find("*").remove();
	
	var $timelinrMore = $("#more" + mec_id);
	$timelinrMore.remove();
	
	var $timelinrNodata = $("#nodata" + mec_id);
	$timelinrNodata.remove();
	
	var $timelinrWarn = $(".timelinrWarn" + mec_id);
	$timelinrWarn.remove();
	
	$("#more_loading" + mec_id).remove();
	
	var $mecContainer = $("#NMEC_" + mec_id);
	var $loading = $(".mec_refresh_loading", $mecContainer);
	if($loading.length == 0){
		$loading = $(
				"<div class=\"mec_refresh_loading\"><div class=\"spinner\">" +
					"<div class=\"bounce1\"></div>" +
					"<div class=\"bounce2\"></div>" +
					"<div class=\"bounce3\"></div>" +
				"</div></div>"
		);
		$mecContainer.append($loading);
	}
	
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=refreshTimelinrData&mec_id="+mec_id+"&pageNo=1");
	Mobile_NS.ajax(url, requestParam, function(data){
		
		if(timestamp != Mobile_NS.Timelinr.refreshTimestamp[mec_id]){
			return;
		}
		
		$loading.hide();
		$loading.remove();
		
		var resultObj = $.parseJSON(data);
		
		var timelinrDataHtml = resultObj["timelinrDataHtml"];
		var pageBtnHtml = resultObj["pageBtnHtml"];
		
		$timelinrContainer.append(timelinrDataHtml);
		
		if($.trim(pageBtnHtml) != ""){
			$timelinrContainer.after(pageBtnHtml);
			$timelinrContainer.parent().trigger("create");	//触发jqm渲染
		}
		
		Mobile_NS.imgLazyload($timelinrContainer);
		
		refreshIScroll();
		
		if(top && typeof(top.resetActiveFrame) == "function"){
			top.resetActiveFrame();
		}
		
		if(typeof(callbackFn) == "function"){
			callbackFn.call(window);
		}
		
		Mobile_NS.triggerPageChange({
			id : mec_id,
			type : "refreshTimelinr"
		});
		
	});
};
