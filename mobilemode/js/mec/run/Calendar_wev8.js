Mobile_NS.Calendar = {};

Mobile_NS.Calendar.contextObj = {};

Mobile_NS.Calendar.onload = function(mec_id, mecJson){
	
	this.contextObj[mec_id] = mecJson;
	
	M_Calendar.initCalendar("NMEC_"+mec_id, mecJson._userlang);
	if(mecJson.isShowLunar == 0){
		$("table",$("._m_cdar_loadCalendarDay_Container")).addClass("_m_cdar_noneLunar");
	}
	if(mecJson.isShowNew == 1){
		$("#addDataByCalendarDate").show();	//显示新建
	}
	if(mecJson.isShowGoBack == 1){
		$("#_m_cdar_calendarYearMonth").removeClass("_m_cdar_calendarYearMonth_noBack").addClass("_m_cdar_calendarYearMonth").bind("click",function(){
			Mobile_NS.backPage();
		});
	}
	
	var dataShowWay = mecJson.dataShowWay;
	var dataInitScope = mecJson.dataInitScope;
	var isShowLunar = mecJson.isShowLunar;
	var currentDateObj = new Date();
	var currentYear = currentDateObj.getFullYear();
	var currentMonth = currentDateObj.getMonth()+1 > 9 ? currentDateObj.getMonth()+1 : "0"+(currentDateObj.getMonth()+1);
	var currentDate = currentDateObj.getDate();
	var startDate = "";
	var endDate = "";
	
	if(dataInitScope == "1"){ //当天
		startDate = currentYear + "-" + currentMonth + "-" + (currentDate > 9 ? currentDate : "0"+currentDate);
		endDate = startDate;
	}else if(dataInitScope == "2"){ //本周
		currentDateObj.setDate(currentDate - currentDateObj.getDay());
		currentMonth = currentDateObj.getMonth()+1 > 9 ? currentDateObj.getMonth()+1 : "0"+(currentDateObj.getMonth()+1);
		currentDate = currentDateObj.getDate() > 9 ? currentDateObj.getDate() : "0"+currentDateObj.getDate();
		startDate = currentDateObj.getFullYear() + "-" + currentMonth+ "-" +currentDate;
		currentDateObj.setDate(currentDateObj.getDate() + 6);
		currentMonth = currentDateObj.getMonth()+1 > 9 ? currentDateObj.getMonth()+1 : "0"+(currentDateObj.getMonth()+1);
		currentDate = currentDateObj.getDate() > 9 ? currentDateObj.getDate() : "0"+currentDateObj.getDate();
		endDate =  currentDateObj.getFullYear() + "-" + currentMonth+ "-" +currentDate;
	}else if(dataInitScope == "3"){ //本月
		startDate = currentYear + "-" + currentMonth + "-01";
		endDate =  currentYear + "-" + currentMonth + "-" + new Date(currentYear,currentDateObj.getMonth()+1,0).getDate();
	}else if(dataInitScope == "4"){ //全部
	
	}
	
	var callbackFn = function(){
		Mobile_NS.Calendar.resetListHeight("NMEC_" + mec_id, false);
	};
	
	//延迟加载
	if(dataShowWay == 1){	//列表
		var listChoose = mecJson.listChoose;
		var listBetweenFieldSet = mecJson.listBetweenFieldSet;
		var listFieldSet = mecJson.listFieldSet;
		var listBetweenStartFieldSet = mecJson.listBetweenStartFieldSet;
		var listBetweenEndFieldSet = mecJson.listBetweenEndFieldSet;
		var columns = [];
		if(startDate != "" && endDate != ""){
			if(listBetweenFieldSet == "1" && listFieldSet != ""){ //字段区间设置 "等于"
				columns.push({"name":listFieldSet, "value":startDate, "opt":"greaterThanEqualTo"});
				columns.push({"name":listFieldSet, "value":endDate, "opt":"lessThanEqualTo"});
			}else if(listBetweenFieldSet == "2" && listBetweenStartFieldSet != "" && listBetweenEndFieldSet != ""){
				columns.push({"name":listBetweenStartFieldSet, "value":startDate, "opt":"greaterThanEqualTo"});
				columns.push({"name":listBetweenEndFieldSet, "value":endDate, "opt":"lessThanEqualTo"});
			}
		}
		var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getCaledarCondition&columns="+encodeURIComponent(JSON.stringify(columns)));
		Mobile_NS.ajax(url, function(responseText){
			var rData = JSON.parse(responseText);
			if(rData["status"] == "1"){
				var params = {"sqlwhere" : rData["data"]};
				Mobile_NS.triggerLazyLoad(listChoose, params, callbackFn);
			}else{
				alert("errorMsg: " + rData["errorMsg"]);
			}
		});
	}else if(dataShowWay == 2){ //url列表
		var urlListChoose = mecJson.urlListChoose;
		var urlListFieldSet = mecJson.urlListFieldSet;
		var params = {};
		var pValue = "";
		if(startDate == endDate){
			pValue = startDate;
		}else{
			pValue = startDate + "," + endDate;
		}
		params[urlListFieldSet] = pValue;
		Mobile_NS.triggerLazyLoad(urlListChoose, params, callbackFn);
	}else if(dataShowWay == 3){ //ws列表
	}else if(dataShowWay == 4){ //时间轴
		var timeLineChoose = mecJson.timeLineChoose;
		var timeLineBetweenFieldSet = mecJson.timeLineBetweenFieldSet;
		var timeLineFieldSet = mecJson.timeLineFieldSet;
		var timeLineBetweenStartFieldSet = mecJson.timeLineBetweenStartFieldSet;
		var timeLineBetweenEndFieldSet = mecJson.timeLineBetweenEndFieldSet;
		var columns = [];
		if(startDate != "" && endDate != ""){
			if(timeLineBetweenFieldSet == "1" && timeLineFieldSet != ""){ //字段区间设置 "等于"
				columns.push({"name":timeLineFieldSet, "value":startDate, "opt":"greaterThanEqualTo"});
				columns.push({"name":timeLineFieldSet, "value":endDate, "opt":"lessThanEqualTo"});
			}else if(timeLineBetweenFieldSet == "2" && timeLineBetweenStartFieldSet != "" && timeLineBetweenEndFieldSet != ""){
				columns.push({"name":timeLineBetweenStartFieldSet, "value":startDate, "opt":"greaterThanEqualTo"});
				columns.push({"name":timeLineBetweenEndFieldSet, "value":endDate, "opt":"lessThanEqualTo"});
			}
		}
		var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getCaledarCondition&columns="+encodeURIComponent(JSON.stringify(columns)));
		Mobile_NS.ajax(url, function(responseText){
			var rData = JSON.parse(responseText);
			if(rData["status"] == "1"){
				var params = {"sqlwhere" : rData["data"]};
				Mobile_NS.triggerLazyLoad(timeLineChoose, params, callbackFn);
			}else{
				alert("errorMsg: " + rData["errorMsg"]);
			}
		});
	}
	if(dataInitScope == "4"){ //初始化范围为全部
		startDate = currentYear + "-" + currentMonth + "-01";
		currentDateObj.setDate(0);
		endDate =  currentYear + "-" + currentMonth + "-" + currentDateObj.getDate();
	}
	Mobile_NS.Calendar.drawingDate(mec_id,startDate,endDate); //渲染日期
	
	if(mecJson.isDefaultShrink == "1"){	//默认收缩
		$("#upDownCalendar").triggerHandler("click");
	}
};

Mobile_NS.Calendar.drawingDate = function(mec_id, startDate, endDate){

	var mecJson = this.contextObj[mec_id];
	var sourceType = mecJson.sourceType;
	var drawingSql = mecJson.sql;
	var columnNameArr = new Array();
	if(drawingSql != "" && sourceType == "1"){
		drawingSql = drawingSql.toLowerCase();
		var fromIdx = drawingSql.indexOf("from");
		if(drawingSql.indexOf("select") > -1 && fromIdx > -1){
			var columnName = drawingSql.substring(6,fromIdx);
			if(columnName.indexOf(",") > -1){
				columnNameArr = columnName.split(",");
			}else{
				columnNameArr[0] = columnName;
			}
		}
	}
	Mobile_NS.pageParams["startDate"] = startDate;
	Mobile_NS.pageParams["endDate"] = endDate;
	
	var url = "/mobilemode/MECAction.jsp?action=getMecData&mec_id="+mec_id;
	Mobile_NS.ajax(url, Mobile_NS.pageParams, function(responseText){
		var dataObj = $.parseJSON($.trim(responseText).toLowerCase());
		var firstDataObj = dataObj;
		if($.isArray(firstDataObj)){
			firstDataObj = firstDataObj[0];
		}
		if(sourceType == "2"){
			for(var dataKey in firstDataObj){
				columnNameArr.push(dataKey); 
			}
		}
		if($.isPlainObject(firstDataObj) && columnNameArr != ""){
			var startDateKey = columnNameArr[0].trim();
			if(columnNameArr.length >= 2){
				var endDateKey = columnNameArr[1].trim();
				if($.isArray(dataObj)){
					$.each(dataObj,function(i){
						var startDateData = dataObj[i][startDateKey];
						var endDateData = dataObj[i][endDateKey];
						Mobile_NS.Calendar.RealDrawingDate(mec_id,startDateData,endDateData);
					});
				}else{
					Mobile_NS.Calendar.RealDrawingDate(mec_id,dataObj[startDateKey],dataObj[endDateKey]);
				}
			}else{
				if($.isArray(dataObj)){
					$.each(dataObj,function(i){
						$("td[id='"+dataObj[i][startDateKey]+"']",$("#NMEC_"+mec_id)).addClass("_m_cdar_calendarPlanDiv");
					});
				}else{
					$("td[id='"+dataObj[startDateKey]+"']",$("#NMEC_"+mec_id)).addClass("_m_cdar_calendarPlanDiv");
				}
			}
		}		
	});
};

Mobile_NS.Calendar.RealDrawingDate = function(mec_id,startDateData,endDateData){
	if(startDateData != "" ){
		$("td[id='"+startDateData+"']",$("#NMEC_"+mec_id)).addClass("_m_cdar_calendarPlanDiv");
	}
	if(endDateData != ""){
		$("td[id='"+endDateData+"']",$("#NMEC_"+mec_id)).addClass("_m_cdar_calendarPlanDiv");
	}
	if(startDateData != "" && endDateData != ""){
		var startDateObj = new Date(startDateData);
		var endDateObj = new Date(endDateData);
		var dayNums = parseInt(Math.abs(startDateObj-endDateObj)/1000/60/60/24);
		for(var dayNumi = 1; dayNumi < dayNums; dayNumi++){
			var betweenDateObj = new Date(startDateObj.getFullYear(),startDateObj.getMonth(),startDateObj.getDate()+dayNumi);
			var betweenYearDate = betweenDateObj.getFullYear();
			var betweenMonthDate = betweenDateObj.getMonth()+1;
			betweenMonthDate = betweenMonthDate > 9 ? betweenMonthDate : "0"+betweenMonthDate;
			var betweenDayDate = betweenDateObj.getDate()>9 ? betweenDateObj.getDate() : "0"+betweenDateObj.getDate();
			$("td[id='"+betweenYearDate+"-"+betweenMonthDate+"-"+betweenDayDate+"']",$("#NMEC_"+mec_id)).addClass("_m_cdar_calendarPlanDiv");
		}
	}
};

Mobile_NS.Calendar.monthChange = function(containerId,startDate,endDate){
	var mec_id = containerId.split("_")[1];
	var mecJson = this.contextObj[mec_id];
	if(startDate != "" && endDate != ""){
		Mobile_NS.Calendar.drawingDate(mec_id,startDate,endDate); //渲染日期
	}
	Mobile_NS.Calendar.resetListHeight(containerId,true); //重置列表高度
};

Mobile_NS.Calendar.dayChange = function(containerId, dateV1, dateV2){
	
	var mec_id = containerId.split("_")[1];
	var mecJson = this.contextObj[mec_id];
	var dataShowWay = mecJson.dataShowWay;
	var isReloadSwitch = mecJson.isReloadSwitch;
	if(dataShowWay == 1){ //列表
		var listChoose = mecJson.listChoose;
		var listBetweenFieldSet = mecJson.listBetweenFieldSet;
		var listFieldSet = mecJson.listFieldSet;
		var listBetweenStartFieldSet = mecJson.listBetweenStartFieldSet;
		var listBetweenEndFieldSet = mecJson.listBetweenEndFieldSet;
		var columns = [];
		if(listBetweenFieldSet == "1" && listFieldSet != ""){ //字段区间设置 "等于"
			if(dateV1 == dateV2){ //点击日期操作
				columns.push({"name":listFieldSet, "value":dateV1, "opt":"equalTo"});
			}else{
				if(isReloadSwitch == "1"){ //切换周、月重新加载数据(列表、ws列表、时间轴等)
					columns.push({"name":listFieldSet, "value":dateV1, "opt":"greaterThanEqualTo"});
					columns.push({"name":listFieldSet, "value":dateV2, "opt":"lessThanEqualTo"});
				}
			}
		}else if(listBetweenFieldSet == 2  && listBetweenStartFieldSet != "" && listBetweenEndFieldSet != ""){ //区间
			if(dateV1 == dateV2){ //点击日期操作
				columns.push({"name":listBetweenStartFieldSet, "value":dateV1, "opt":"lessThanEqualTo"});
				columns.push({"name":listBetweenEndFieldSet, "value":dateV1, "opt":"greaterThanEqualTo"});
			}else{
				if(isReloadSwitch == "1"){ //切换周、月重新加载数据(列表、ws列表、时间轴等)
					columns.push({"name":listBetweenStartFieldSet, "value":dateV1, "opt":"greaterThanEqualTo"});
					columns.push({"name":listBetweenEndFieldSet, "value":dateV2, "opt":"lessThanEqualTo"});
				}
			}
		}
		if(columns.length > 0){
			var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getCaledarCondition&columns="+encodeURIComponent(JSON.stringify(columns)));
			Mobile_NS.ajax(url, function(responseText){
				var rData = JSON.parse(responseText);
				if(rData["status"] == "1"){
					var sqlwhere = "sqlwhere=" +rData["data"];
					Mobile_NS.refreshList(listChoose, sqlwhere);
				}else{
					alert("errorMsg: " + rData["errorMsg"]);
				}
			});
		}
	}else if(dataShowWay == 2){ //url列表
		var urlListChoose = mecJson.urlListChoose;
		var urlListFieldSet = mecJson.urlListFieldSet;
		var params = urlListFieldSet + "=" + dateV1 +"";
		Mobile_NS.refreshList(listChoose, params);
	}else if(dataShowWay == 3){ //ws列表
	}else if(dataShowWay == 4){ //时间轴
		var timeLineChoose = mecJson.timeLineChoose;
		var timeLineBetweenFieldSet = mecJson.timeLineBetweenFieldSet;
		var timeLineFieldSet = mecJson.timeLineFieldSet;
		var timeLineBetweenStartFieldSet = mecJson.timeLineBetweenStartFieldSet;
		var timeLineBetweenEndFieldSet = mecJson.timeLineBetweenEndFieldSet;
		var columns = [];
		if(timeLineBetweenFieldSet == "1" && timeLineFieldSet != ""){ //字段区间设置 "等于"
			if(dateV1 == dateV2){ //点击日期操作
				columns.push({"name":timeLineFieldSet, "value":dateV1, "opt":"equalTo"});
			}else{
				if(isReloadSwitch == "1"){ //切换周、月重新加载数据(列表、ws列表、时间轴等)
					columns.push({"name":timeLineFieldSet, "value":dateV1, "opt":"greaterThanEqualTo"});
					columns.push({"name":timeLineFieldSet, "value":dateV2, "opt":"lessThanEqualTo"});
				}
			}
		}else if(timeLineBetweenFieldSet == 2  && listBetweenStartFieldSet != "" && listBetweenEndFieldSet != ""){ //区间
			if(dateV1 == dateV2){ //点击日期操作
				columns.push({"name":timeLineBetweenStartFieldSet, "value":dateV1, "opt":"lessThanEqualTo"});
				columns.push({"name":timeLineBetweenEndFieldSet, "value":dateV1, "opt":"greaterThanEqualTo"});
			}else{
				if(isReloadSwitch == "1"){ //切换周、月重新加载数据(列表、ws列表、时间轴等)
					columns.push({"name":timeLineBetweenStartFieldSet, "value":dateV1, "opt":"greaterThanEqualTo"});
					columns.push({"name":timeLineBetweenEndFieldSet, "value":dateV2, "opt":"lessThanEqualTo"});
				}
			}
		}
		if(columns.length > 0){
			var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getCaledarCondition&columns="+encodeURIComponent(JSON.stringify(columns)));
			Mobile_NS.ajax(url, function(responseText){
				var rData = JSON.parse(responseText);
				if(rData["status"] == "1"){
					var sqlwhere = "sqlwhere=" +rData["data"];
					Mobile_NS.refreshTimelinr(timeLineChoose,sqlwhere);
				}else{
					alert("errorMsg: " + rData["errorMsg"]);
				}
			});
		}
	}else if(dataShowWay == 5){ //自定义脚本
		var $cal_date_script = "var $cal_date = \""+dateV1+"\";";
		var script = mecJson.customClickScript;
		if(script && script != ""){
			script = $cal_date_script + script;
			script = decodeURIComponent(script);
			eval(script);
		}
	}
};

Mobile_NS.Calendar.addData = function(containerId, dateVal){
	
	var mec_id = containerId.split("_")[1];
	var mecJson = this.contextObj[mec_id];
	var parseWayChoose = mecJson.parseWayChoose;
	if(parseWayChoose == 1){ //自动解析
		var addLink = mecJson.addLink;
		if(addLink && addLink != ""){
			addLink = addLink.replace(/\${calendarDateVal}/g, dateVal);
			$u(addLink);
		}
	}else if(parseWayChoose == 2){ //输入脚本
		var $cal_date_script = "var $cal_date = \""+dateVal+"\";";
		var script = mecJson.clickScript;
		if(script && script != ""){
			script = $cal_date_script + script;
			script = decodeURIComponent(script);
			eval(script);
		}
	}
};

Mobile_NS.Calendar.resetListHeight = function(containerId, monthChange){

	var mec_id = containerId.split("_")[1];
	if(monthChange){
		setTimeout(function(){
			Mobile_NS.Calendar.setListHeight(mec_id);
		}, 100);
	}else{
		Mobile_NS.Calendar.setListHeight(mec_id);
	}
};

Mobile_NS.Calendar.setListHeight = function(mec_id){
	
	var mecJson = this.contextObj[mec_id];
	var dataShowWay = mecJson.dataShowWay;
	
	var windowHeight = $(window).height();
	var calendarContainer = $("#NMEC_"+mec_id);
	//var calendarContainerHeight = calendarContainer.height();
	//var calendarContainerTopHeight = calendarContainer.offset().top;
	//var listContainerHeight = windowHeight - calendarContainerHeight-calendarContainerTopHeight;
	var listChoose = "";
	var listContainerHeight = "";
	if(dataShowWay == 1){ //列表
		listChoose = mecJson.listChoose;
	}else if(dataShowWay == 2){ //url列表
		listChoose = mecJson.urlListChoose;
	}else if(dataShowWay == 3){ //ws列表
		listChoose = mecJson.wsListChoose;
	}else if(dataShowWay == 4){ //时间轴
		listChoose = mecJson.timeLineChoose;
	}
	if(listChoose != ""){
		var listChooseTopHeight = $("#NMEC_"+listChoose).offset().top;
		var listContainerHeight = windowHeight - listChooseTopHeight;
		if(listContainerHeight > 50 ){
			$("#NMEC_"+listChoose).height(listContainerHeight);
		}
	}
};


