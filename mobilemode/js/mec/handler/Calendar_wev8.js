if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Calendar = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = this.getDefaultMecJson();
	}
	this.mecJson = mecJson;
};

/*获取id。 必需的方法*/
MEC_NS.Calendar.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Calendar.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var htm = getPluginContentTemplateById(this.type);
	htm = htm.replace(/\${theId}/g, theId);
	
	return htm;
}

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Calendar.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	if(typeof(_m_upDownCalendar) != "undefined"){
		_m_upDownCalendar = true;
	}
	M_Calendar.initCalendar("NMEC_" + theId, _userLanguage);
	if(this.mecJson["isShowLunar"] == 1){
		$("table",$("._m_cdar_loadCalendarDay_Container")).removeClass("_m_cdar_noneLunar");
	}else{
		$("table",$("._m_cdar_loadCalendarDay_Container")).addClass("_m_cdar_noneLunar");
	}
	if(this.mecJson["isShowNew"] == 1){
		$("#addDataByCalendarDate").show(); 
	}
	if(this.mecJson["isDefaultShrink"] == "1"){
		$("#upDownCalendar").triggerHandler("click");
	}
	if(this.mecJson["isShowGoBack"] == 1){
		$("#_m_cdar_calendarYearMonth").removeClass("_m_cdar_calendarYearMonth_noBack").addClass("_m_cdar_calendarYearMonth");
	}
};


/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Calendar.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "<div id=\"MADCdar_"+theId+"\">"
	htm += "<div class=\"MADCdar_Title\">"+SystemEnv.getHtmlNoteName(4409)+"</div>";  //日历信息
	htm += "<div class=\"MADCdar_Content\">"
				+ "<div class=\"MADCdar_BaseInfo_Entry\">"
					+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4410)+"</span>"  //显示农历：
					+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
						+ "<span class=\"cbboxEntry\" style=\"width: 50px;\">"
							+ "<input type=\"checkbox\" id=\"isShowLunar_"+theId+"\" value=\"\" onclick=\"MADCdar_isShowLunar('"+theId+"');\"/>"
						+ "</span>"
					+ "</span>"
				+ "</div>"
				+ "<div class=\"MADCdar_BaseInfo_Entry\">"
					+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4411)+"</span>"  //显示返回：
					+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
						+ "<span class=\"cbboxEntry\" style=\"width: 50px;\">"
							+ "<input type=\"checkbox\" id=\"isShowGoBack_"+theId+"\" value=\"\" onclick=\"MADCdar_isShowGoBack('"+theId+"');\"/>"
						+ "</span>"
					+ "</span>"
				+ "</div>"
				+ "<div class=\"MADCdar_BaseInfo_Entry\">"
					+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4985)+"</span>"  //默认收起：
					+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
						+ "<span class=\"cbboxEntry\">"
							+ "<input type=\"checkbox\" id=\"isDefaultShrink_"+theId+"\" value=\"\"/>"
						+ "</span>"
					+ "</span>"
				+ "</div>"
				+ "<div class=\"MADCdar_BaseInfo_Entry\">"
					+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4412)+"</span>"  //显示新建：
					+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
						+ "<span class=\"cbboxEntry\" style=\"width: 50px;\">"
							+ "<input type=\"checkbox\" id=\"isShowNew_"+theId+"\" value=\"\" onclick=\"MADCdar_isShowNew('"+theId+"');\"/>"
						+ "</span>"
						+ "<span id=\"span_parsedWay_"+theId+"\" class=\"span_parsedWay\" style=\"display:none;margin-left:10px;\">"
							+"<select class=\"MADCdar_Select\" style=\"width:125px;\" id=\"parseWayChoose_"+theId+"\" onchange=\"MADCdar_parseWayChoose('"+theId+"');\">"
							+"  <option value=\"\"></option>"
							+"  <option value=\"1\">"+SystemEnv.getHtmlNoteName(4413)+"</option>"  //自动解析新建地址
							+"  <option value=\"2\">"+SystemEnv.getHtmlNoteName(4414)+"</option>"  //手动输入脚本
							+"</select>"
						+ "</span>"
						+ "<span id=\"span_parsedWay_"+theId+"_2\" class=\"span_parsedWay\" style=\"display:none;margin-left:10px;\">"
							+ "<span class=\"cbboxEntry\" style=\"position: relative;width:120px;\">"
								+ "<span style=\"position: absolute;top:-5px;left:0px;\">" 
									+ "<div id=\"clickScriptWrap_"+theId+"\" class=\"btn_click_desc btn_click_describe\" onclick=\"MADCdar_addClickScript(this,'"+theId+"')\">"
										+ "<input id=\"clickScript_"+theId+"\" type=\"hidden\" value=\"\">"
									+ "</div>"
								+"</span>"
							+ "</span>"
						+ "</span>"
					+ "</span>"
				+ "</div>"
	htm += "</div>";
	
	htm += "<div class=\"MADCdar_Title\">"+SystemEnv.getHtmlNoteName(4415)+"</div>";
	htm += "<div class=\"MADCdar_Content\">"
				+ "<div class=\"MADCdar_BaseInfo_Entry\">"
					+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4416)+"</span>"  //点击日期：
					+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
						+"<select class=\"MADCdar_Select\" id=\"dataShowWay_"+theId+"\" onchange=\"MADCdar_dataShowWay('"+theId+"');\">"
						+"  <option value=\"\"></option>"
						+"  <option value=\"1\">"+SystemEnv.getHtmlNoteName(4417)+"</option>"  //刷新列表
						+"  <option value=\"2\">"+SystemEnv.getHtmlNoteName(4418)+"</option>"  //刷新Url列表
						+"  <option value=\"4\">"+SystemEnv.getHtmlNoteName(4419)+"</option>"  //刷新时间轴
						+"  <option value=\"5\">"+SystemEnv.getHtmlNoteName(3916)+"</option>"  //自定义
						+"</select>"
					+ "</span>"
				+ "</div>"
	
				+ "<div id=\"div_dataShowWay_"+theId+"_1\" class=\"div_dataShowWay\" style=\"display:none;\">"
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4420)+"</span>"  //选择列表：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+"<select class=\"MADCdar_Select\" id=\"listChoose_"+theId+"\" onchange=\"MADCdar_listChoose('"+theId+"');\">"
							+"  <option value=\"\"></option>"
							+"</select>"
						+ "</span>"
					+ "</div>" 
					
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4421)+"</span>"  //字段区间设置：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+"<select class=\"MADCdar_Select\" id=\"listBetweenFieldSet_"+theId+"\" onchange=\"MADCdar_BetweenFieldChoose(1,'"+theId+"');\" style=\"width:50px;\">"
							+"  <option value=\"1\">"+SystemEnv.getHtmlNoteName(3632)+"</option>"  //等于
							+"  <option value=\"2\">"+SystemEnv.getHtmlNoteName(4422)+"</option>"  //区间
							+"</select>"
						+ "</span>"
						+ "&nbsp;&nbsp;"
						
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\" id=\"listEqFieldSpan_"+theId+"\">"
							+"<select class=\"MADCdar_Select\" id=\"listFieldSet_"+theId+"\">"
							+"  <option value=\"\"></option>"
							+"</select>"
						+ "</span>"
						
						+ "<div id=\"listLtGtFieldSpan_"+theId+"\" style=\"display:none;margin-top:5px;\">"
							+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\" >"+SystemEnv.getHtmlNoteName(4423)+"</span>"  //开始日期：
							+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
								+"<select class=\"MADCdar_Select\" id=\"listBetweenStartFieldSet_"+theId+"\" style=\"width:80px;\">"
								+"  <option value=\"\"></option>"
								+"</select>"
							+ "</span>"
							+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\" >"+SystemEnv.getHtmlNoteName(4424)+"</span>"  //结束日期：
							+ "<span class=\"MADCdar_BaseInfo_Entry_Content\" >"
								+"<select class=\"MADCdar_Select\" id=\"listBetweenEndFieldSet_"+theId+"\" style=\"width:80px;\">"
								+"  <option value=\"\"></option>"
								+"</select>"
							+ "</span>"
						+ "</div>"
					+ "</div>" 
				+ "</div>"
	
				+ "<div id=\"div_dataShowWay_"+theId+"_2\" class=\"div_dataShowWay\" style=\"display:none;\">"
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4425)+"</span>"  //选择Url列表：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+"<select class=\"MADCdar_Select\" id=\"urlListChoose_"+theId+"\" onchange=\"MADCdar_urlListChoose('"+theId+"');\">"
							+"  <option value=\"\"></option>"
							+"</select>"
						+ "</span>"
					+ "</div>" 
					
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4426)+"</span>"  //字段设置：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+"<input type=\"text\" id=\"urlListFieldSet_"+theId+"\" class=\"MADCdar_Text\" value=\"\">"
						+ "</span>"
					+ "</div>" 
				+ "</div>"
				
				+ "<div id=\"div_dataShowWay_"+theId+"_3\" class=\"div_dataShowWay\" style=\"display:none;\">"
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4427)+"</span>"  //选择WS列表：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+"<select class=\"MADCdar_Select\" id=\"wsListChoose_"+theId+"\" onchange=\"MADCdar_wsListChoose('"+theId+"');\">"
							+"  <option value=\"\"></option>"
							+"</select>"
						+ "</span>"
					+ "</div>" 
					
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4426)+"</span>"  //字段设置：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+"<input type=\"text\" id=\"wsListFieldSet_"+theId+"\" class=\"MADCdar_Text\" value=\"\">"
						+ "</span>"
					+ "</div>" 
				+ "</div>"
	
				+ "<div id=\"div_dataShowWay_"+theId+"_4\" class=\"div_dataShowWay\" style=\"display:none;\">"
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4428)+"</span>"  //选择时间轴：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+"<select class=\"MADCdar_Select\" id=\"timeLineChoose_"+theId+"\" onchange=\"MADCdar_timeLineChoose('"+theId+"');\">"
							+"  <option value=\"\"></option>"
							+"</select>"
						+ "</span>"
					+ "</div>" 
					
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4421)+"</span>"  //字段区间设置：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+"<select class=\"MADCdar_Select\" id=\"timeLineBetweenFieldSet_"+theId+"\" onchange=\"MADCdar_BetweenFieldChoose(2,'"+theId+"');\" style=\"width:50px;\">"
							+"  <option value=\"1\">"+SystemEnv.getHtmlNoteName(3632)+"</option>"  //等于
							+"  <option value=\"2\">"+SystemEnv.getHtmlNoteName(4422)+"</option>"  //区间
							+"</select>"
						+ "</span>"
						+ "&nbsp;&nbsp;"
						
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\" id=\"timeLineEqFieldSpan_"+theId+"\">"
							+"<select class=\"MADCdar_Select\" id=\"timeLineFieldSet_"+theId+"\">"
							+"  <option value=\"\"></option>"
							+"</select>"
						+ "</span>"
						
						+ "<div id=\"timeLineLtGtFieldSpan_"+theId+"\" style=\"display:none;margin-top:5px;\">"
							+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\" >"+SystemEnv.getHtmlNoteName(4423)+"</span>"  //开始日期：
							+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
								+"<select class=\"MADCdar_Select\" id=\"timeLineBetweenStartFieldSet_"+theId+"\" style=\"width:80px;\">"
								+"  <option value=\"\"></option>"
								+"</select>"
							+ "</span>"
							+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\" >"+SystemEnv.getHtmlNoteName(4424)+"</span>"  //结束日期：
							+ "<span class=\"MADCdar_BaseInfo_Entry_Content\" >"
								+"<select class=\"MADCdar_Select\" id=\"timeLineBetweenEndFieldSet_"+theId+"\" style=\"width:80px;\">"
								+"  <option value=\"\"></option>"
								+"</select>"
							+ "</span>"
						+ "</div>"
					+ "</div>" 
					
				+ "</div>"
				
				+ "<div id=\"div_dataShowWay_"+theId+"_5\" class=\"div_dataShowWay\" style=\"display:none;\">"
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4349)+"</span>"  //单击事件：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+ "<span class=\"cbboxEntry\" style=\"position: relative;width:120px;\">"
								+ "<span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4372)+"</span>"  //自定义脚本
								+ "<span style=\"position: absolute;top:-5px;left: 30px;\">" 
									+ "<div id=\"clickScriptWrap_"+theId+"\" class=\"btn_click_desc\" style=\"width: 16px;height: 22px;\" onclick=\"MADCdar_addClickScript(this,'"+theId+"')\">"
										+ "<input id=\"customClickScript_"+theId+"\" type=\"hidden\" value=\"\">"
									+ "</div>"
								+"</span>"
							+ "</span>"
						+ "</span>"
					+ "</div>" 
				+ "</div>"
				
				+ "<div class=\"MADCdar_BaseInfo_Entry\">"
					+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4429)+"</span>"  //数据初始范围：
					+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
						+"<select class=\"MADCdar_Select\" id=\"dataInitScope_"+theId+"\" onchange=\"MADCdar_dataInitScope('"+theId+"');\" style=\"width:50px;\">"
						+"  <option value=\"1\">"+SystemEnv.getHtmlNoteName(4430)+"</option>"  //当天
						+"  <option value=\"2\">"+SystemEnv.getHtmlNoteName(3409)+"</option>"  //本周
						+"  <option value=\"3\">"+SystemEnv.getHtmlNoteName(3410)+"</option>"  //本月
						+"  <option value=\"4\">"+SystemEnv.getHtmlNoteName(3407)+"</option>"  //全部
						+"</select>"
					+ "</span>"
					+ "&nbsp;&nbsp;("+SystemEnv.getHtmlNoteName(4431)+")"  //首次初始化生效
				+ "</div>"
				
				+ "<div class=\"MADCdar_BaseInfo_Entry\">"
					+ "<span class=\"MADCdar_BaseInfo_Entry_Label MADCdar_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4432)+"</span>"  //重新加载数据：
					+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
						+ "<span class=\"cbboxEntry\" style=\"width: 50px;\">"
							+ "<input type=\"checkbox\" id=\"isReloadSwitch_"+theId+"\" value=\"\"/>"
						+ "</span>"
						+ "&nbsp;&nbsp;("+SystemEnv.getHtmlNoteName(4433)+")"  //切换周月的时候重新加载数据
					+ "</span>"
				+ "</div>";
				
	htm += "</div>";
	
	htm += "<div class=\"MADCdar_Title\">"
				+ "<span>"+SystemEnv.getHtmlNoteName(4434)+"</span>"  //日期标记
				+ "<span class=\"MADCdar_Title_Content\">"
					+ "<span class=\"cbboxEntry\" style=\"width: 50px;\">"
						+ "<input type=\"checkbox\" name=\"sourceType_"+theId+"\" value=\"1\" onclick=\"MADCdar_ChangeSourceType(this, '"+theId+"');\"/><span class=\"cbboxLabel\">SQL</span>"
					+ "</span>"
					+ "<span class=\"cbboxEntry\">"
						+ "<input type=\"checkbox\" name=\"sourceType_"+theId+"\" value=\"2\" onclick=\"MADCdar_ChangeSourceType(this, '"+theId+"');\"/><span class=\"cbboxLabel\">Url</span>"
					+ "</span>"
				+ "</span>"
	htm	+= "</div>";
	htm += "<div class=\"MADCdar_Content\">"
				+ "<div id=\"div_sourceType_"+theId+"_1\" class=\"div_sourceType\" style=\"display:none;\">"
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<span class=\"MADCdar_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
						+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
							+"<select class=\"MADCdar_Select\" id=\"datasource_"+theId+"\">"
							+"  <option value=\"\">(local)</option>"
							+"</select>"
						+ "</span>"
					+ "</div>" 
				
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<textarea id=\"sql_"+theId+"\" class=\"MADCdar_Textarea\" placeholder=\""+SystemEnv.getHtmlNoteName(4435)+"select rcdate from uf_schedule\"></textarea>"  //请在此处键入查询出需要标记的日期SQL，例如：
					+ "</div>" 
				+ "</div>"
				
				+ "<div id=\"div_sourceType_"+theId+"_2\" class=\"div_sourceType\" style=\"display:none;\">"
					+ "<div class=\"MADCdar_BaseInfo_Entry\">"
						+ "<textarea id=\"url_"+theId+"\" class=\"MADCdar_Textarea\" placeholder=\""+SystemEnv.getHtmlNoteName(4436)+"\"></textarea>"  //请在此处键入查询出需要标记的日期Url
					+ "</div>" 
				+ "</div>";
	htm += "</div>";
	
	htm += "<div class=\"MADCdar_Bottom\"><div class=\"MADCdar_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";

	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Calendar.prototype.afterAttrDlgBuild = function(){
	
	var theId = this.id;
	
	var sourceTypeV = this.mecJson["sourceType"];
	var $sourceType = $("input[type='checkbox'][name='sourceType_"+theId+"'][value='"+sourceTypeV+"']");
	if($sourceType.length > 0){
		$sourceType.attr("checked", "checked");
		$sourceType.triggerHandler("click");
	}
	
	var datasource = Mec_FiexdUndefinedVal(this.mecJson["datasource"]);
	$("#datasource_"+theId).val(datasource);
	MADCdar_setDataSourceHTML(theId, datasource);
	
	$("#sql_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["sql"]));
	$("#url_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["url"]));
	
	var dataShowWay = Mec_FiexdUndefinedVal(this.mecJson["dataShowWay"]);
	$("#dataShowWay_"+theId).val(dataShowWay);
	if(dataShowWay != ""){
		MADCdar_dataShowWay(theId);
	}
	var listChoose = Mec_FiexdUndefinedVal(this.mecJson["listChoose"]);
	$("#listChoose_"+theId).val(listChoose);
	if(listChoose != ""){
		MADCdar_listChoose(theId);
	}
	var listBetweenFieldSet = Mec_FiexdUndefinedVal(this.mecJson["listBetweenFieldSet"]);
	$("#listBetweenFieldSet_"+theId).val(listBetweenFieldSet);
	if(listBetweenFieldSet != ""){
		MADCdar_BetweenFieldChoose(1,theId);
	}
	$("#listFieldSet_"+theId).val(this.mecJson["listFieldSet"]);
	$("#listBetweenStartFieldSet_"+theId).val(this.mecJson["listBetweenStartFieldSet"]);
	$("#listBetweenEndFieldSet_"+theId).val(this.mecJson["listBetweenEndFieldSet"]);
	
	$("#urlListChoose_"+theId).val(this.mecJson["urlListChoose"]);
	$("#urlListFieldSet_"+theId).val(this.mecJson["urlListFieldSet"]);
	$("#wsListChoose_"+theId).val(this.mecJson["wsListChoose"]);
	$("#wsListFieldSet_"+theId).val(this.mecJson["wsListFieldSet"]);
	
	var timeLineChoose = Mec_FiexdUndefinedVal(this.mecJson["timeLineChoose"]);
	$("#timeLineChoose_"+theId).val(timeLineChoose);
	if(timeLineChoose != ""){
		MADCdar_timeLineChoose(theId);
	}
	var timeLineBetweenFieldSet = Mec_FiexdUndefinedVal(this.mecJson["timeLineBetweenFieldSet"]);
	$("#timeLineBetweenFieldSet_"+theId).val(timeLineBetweenFieldSet);
	if(timeLineBetweenFieldSet != ""){
		MADCdar_BetweenFieldChoose(2,theId);
	}
	$("#timeLineFieldSet_"+theId).val(this.mecJson["timeLineFieldSet"]);
	$("#timeLineBetweenStartFieldSet_"+theId).val(this.mecJson["timeLineBetweenStartFieldSet"]);
	$("#timeLineBetweenEndFieldSet_"+theId).val(this.mecJson["timeLineBetweenEndFieldSet"]);
	
	$("#dataInitScope_"+theId).val(this.mecJson["dataInitScope"]);
	var isReloadSwitch = this.mecJson["isReloadSwitch"];
	$("#isReloadSwitch_"+theId).val(isReloadSwitch);
	if(isReloadSwitch == 1){
		 $("#isReloadSwitch_"+theId).attr("checked", true);
	}
	$("#customClickScript_"+theId).val(this.mecJson["customClickScript"]);
	
	var isShowLunar = this.mecJson["isShowLunar"];
	$("#isShowLunar_"+theId).val(isShowLunar);
	if(isShowLunar == 1){
		 $("#isShowLunar_"+theId).attr("checked", true);
	}
	var isShowGoBack = this.mecJson["isShowGoBack"];
	$("#isShowGoBack_"+theId).val(isShowGoBack);
	if(isShowGoBack == 1){
		$("#isShowGoBack_"+theId).attr("checked", true);
		MADCdar_isShowGoBack(theId);
	}
	
	var isDefaultShrink = this.mecJson["isDefaultShrink"];
	if(isDefaultShrink == "1"){
		$("#isDefaultShrink_"+theId).attr("checked", "checked");
	}
	
	var isShowNew = Mec_FiexdUndefinedVal(this.mecJson["isShowNew"]);
	$("#isShowNew_"+theId).val(isShowNew);
	$("#parseWayChoose_"+theId).val(this.mecJson["parseWayChoose"]);
	if(isShowNew == 1){
		 $("#isShowNew_"+theId).attr("checked", true);
		 MADCdar_isShowNew(theId);		
	}
	$("#clickScript_"+theId).val(this.mecJson["clickScript"]);
	$("#MADCdar_"+theId).jNice();
	
};

/*获取JSON*/
MEC_NS.Calendar.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MAD_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["sourceType"] = $("input[type='checkbox'][name='sourceType_"+theId+"']:checked").val();
		this.mecJson["datasource"] = $("#datasource_"+theId).val();
		this.mecJson["sql"] = $("#sql_"+theId).val();
		this.mecJson["url"] = $("#url_"+theId).val();
		this.mecJson["dataShowWay"] = $("#dataShowWay_"+theId).val();
		this.mecJson["listChoose"] = $("#listChoose_"+theId).val();
		this.mecJson["listBetweenFieldSet"] = $("#listBetweenFieldSet_"+theId).val();
		this.mecJson["listFieldSet"] = $("#listFieldSet_"+theId).val();
		this.mecJson["listFieldidSet"] = Mec_FiexdUndefinedVal($("#listFieldSet_"+theId+" option:selected").attr("fieldid"));
		this.mecJson["listBetweenStartFieldSet"] = $("#listBetweenStartFieldSet_"+theId).val();
		this.mecJson["listBetweenStartFieldidSet"] = Mec_FiexdUndefinedVal($("#listBetweenStartFieldSet_"+theId+" option:selected").attr("fieldid"));
		this.mecJson["listBetweenEndFieldSet"] = $("#listBetweenEndFieldSet_"+theId).val();
		this.mecJson["listBetweenEndFieldidSet"] = Mec_FiexdUndefinedVal($("#listBetweenEndFieldSet_"+theId+" option:selected").attr("fieldid"));
		this.mecJson["urlListChoose"] = $("#urlListChoose_"+theId).val();
		this.mecJson["urlListFieldSet"] = $("#urlListFieldSet_"+theId).val();
		this.mecJson["wsListChoose"] = $("#wsListChoose_"+theId).val();
		this.mecJson["wsListFieldSet"] = $("#wsListFieldSet_"+theId).val();
		this.mecJson["timeLineChoose"] = $("#timeLineChoose_"+theId).val();
		this.mecJson["timeLineBetweenFieldSet"] = $("#timeLineBetweenFieldSet_"+theId).val();
		this.mecJson["timeLineFieldSet"] = $("#timeLineFieldSet_"+theId).val();
		this.mecJson["timeLineFieldidSet"] = Mec_FiexdUndefinedVal($("#timeLineFieldSet_"+theId+" option:selected").attr("fieldid"));
		this.mecJson["timeLineBetweenStartFieldSet"] = $("#timeLineBetweenStartFieldSet_"+theId).val();
		this.mecJson["timeLineBetweenStartFieldidSet"] = Mec_FiexdUndefinedVal($("#timeLineBetweenStartFieldSet_"+theId+" option:selected").attr("fieldid"));
		this.mecJson["timeLineBetweenEndFieldSet"] = $("#timeLineBetweenEndFieldSet_"+theId).val();
		this.mecJson["timeLineBetweenEndFieldidSet"] = Mec_FiexdUndefinedVal($("#timeLineBetweenEndFieldSet"+theId+" option:selected").attr("fieldid"));
		this.mecJson["dataInitScope"] = $("#dataInitScope_"+theId).val();
		this.mecJson["isReloadSwitch"] = $("#isReloadSwitch_"+theId).is(":checked") ? "1" : "0";
		this.mecJson["customClickScript"] = $("#customClickScript_"+theId).val();
		this.mecJson["isShowLunar"] = $("#isShowLunar_"+theId).is(":checked") ? "1" : "0";
		this.mecJson["isShowGoBack"] = $("#isShowGoBack_"+theId).is(":checked") ? "1" : "0";
		this.mecJson["isDefaultShrink"] = $("#isDefaultShrink_"+theId).is(":checked") ? "1" : "0";
		this.mecJson["isShowNew"] = $("#isShowNew_"+theId).is(":checked") ? "1" : "0";
		this.mecJson["parseWayChoose"] = $("#parseWayChoose_"+theId).val();
		this.mecJson["clickScript"] = $("#clickScript_"+theId).val();
	}
	return this.mecJson;
};

MEC_NS.Calendar.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["sourceType"] = "1";	//SQL
	defMecJson["datasource"] = "";	//单击类型
	defMecJson["sql"] = "";	//sql
	defMecJson["url"] = "";	//url
	
	defMecJson["dataShowWay"] = ""; //数据展现方式
	defMecJson["listChoose"] = ""; 
	defMecJson["listBetweenFieldSet"] = "1"; //字段区间设置默认按"等于"
	defMecJson["listFieldSet"] = ""; 
	defMecJson["listBetweenStartFieldSet"] = "";
	defMecJson["listBetweenEndFieldSet"] = "";
	
	defMecJson["urlListChoose"] = ""; 
	defMecJson["urlListFieldSet"] = ""; 
	
	defMecJson["wsListChoose"] = "";
	defMecJson["wsListFieldSet"] = "";
	
	defMecJson["timeLineChoose"] = "";
	defMecJson["timeLineBetweenFieldSet"] = "1"; //字段区间设置默认按"等于"
	defMecJson["timeLineFieldSet"] = "";
	defMecJson["timeLineBetweenStartFieldSet"] = "";
	defMecJson["timeLineBetweenEndFieldSet"] = "";
	
	defMecJson["dataInitScope"] = "1"; //当天
	defMecJson["isReloadSwitch"] = "0"; //切换周、月是否重新加载数据，默认不加载
	
	defMecJson["customClickScript"] = "var _date = $cal_date;  /*"+SystemEnv.getHtmlNoteName(4437)+"*/";  //$cal_date为日历控件单击事件触发时的日期
	defMecJson["isShowLunar"] = "1"; //默认显示农历
	defMecJson["isShowGoBack"] = ""; //显示返回
	defMecJson["isShowNew"] = "1"; //默认显示新建
	defMecJson["parseWayChoose"] = "1"; //解析方式(默认自动新建地址)
	defMecJson["clickScript"] = "var _date = $cal_date;  /*"+SystemEnv.getHtmlNoteName(4438)+"*/";  //$cal_date为日历控件当前选中的日期
	
	return defMecJson;
};

function MADCdar_ChangeSourceType(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='sourceType_"+mec_id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		$(".div_sourceType", "#MADCdar_"+mec_id).hide();
		$("#div_sourceType_"+mec_id+"_" + objV).show();
	},100);
}

function MADCdar_setDataSourceHTML(mec_id,val){
	var $MADCdar_DataSource = $("#datasource_" + mec_id);
	var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=getDataSource");
	FormmodeUtil.doAjaxDataLoad(url, function(datas){
		for(var i = 0; i < datas.length; i++){
			var data = datas[i];
			var pointid = data;
			var selected = "";
			if (pointid=="" || typeof(pointid)=="undefined") continue;
			if (pointid == val) selected = "selected";
			var dataSourceSelectHtml = "<option value=\""+pointid+"\" "+selected+">";
			dataSourceSelectHtml += pointid;
			dataSourceSelectHtml += "</option>";
			$MADCdar_DataSource.append(dataSourceSelectHtml);
		}
	});
}

function MADCdar_dataShowWay(theId){
	var showWayV = $("#dataShowWay_"+theId).val();
	if(showWayV == "1"){ //List
		MADCdar_set_List_UList_timeLinrOption(theId, $("#listChoose_"+theId), "List");
	}else if(showWayV == "2"){ //UrlList
		MADCdar_set_List_UList_timeLinrOption(theId, $("#urlListChoose_"+theId), "UrlList");
	}else if(showWayV == "3"){ //WSList
		MADCdar_set_List_UList_timeLinrOption(theId, $("#wsListChoose_"+theId), "WSList");
	}else if(showWayV == "4"){ //Timelinr
		MADCdar_set_List_UList_timeLinrOption(theId, $("#timeLineChoose_"+theId), "Timelinr");
	}
	$(".div_dataShowWay", "#MADCdar_"+theId).hide();
	$("#div_dataShowWay_"+theId+"_" + showWayV).show();
}

function MADCdar_set_List_UList_timeLinrOption(theId, urlListLinrObj, type){
	urlListLinrObj.html("");
	urlListLinrObj.append("<option value=\"\"></option>");
	var mecHandlerList = MECHandlerPool.getHandlerByType(type);
	for(var i = 0; i < mecHandlerList.length; i++){
		var mecHandlerObj = mecHandlerList[i];
		var mecHandlerid = mecHandlerObj.getID();
		var optionStr = "<option value=\""+mecHandlerid+"\">";
		optionStr += mecHandlerObj.getName();
		optionStr += "</option>";
		urlListLinrObj.append(optionStr);
	}
}

function MADCdar_listChoose(theId){
	var mec_idV = $("#listChoose_"+theId).val();
	$("#listFieldSet_"+theId).html("").append("<option value=\"\"></option>");
	$("#listBetweenStartFieldSet_"+theId).html("").append("<option value=\"\"></option>");
	$("#listBetweenEndFieldSet_"+theId).html("").append("<option value=\"\"></option>");
	try{
		if(mec_idV != ""){
			var mecHandler = MECHandlerPool.getHandler(mec_idV);
			var fileldList = mecHandler.getFieldInfo();
			for(var i = 0; i < fileldList.length; i++){
				var optionStr = "<option value=\""+fileldList[i].fieldName+"\" fieldid=\""+fileldList[i].fieldid+"\">";
				optionStr += fileldList[i].fieldDesc;
				optionStr += "</option>";
				$("#listFieldSet_"+theId).append(optionStr);
				$("#listBetweenStartFieldSet_"+theId).append(optionStr);
				$("#listBetweenEndFieldSet_"+theId).append(optionStr);
			}
			Mec_SetLazyLoad(mec_idV); //设置延迟加载
		}
	}catch(e){
	
	}
}

function MADCdar_urlListChoose(theId){
	var mec_idV = $("#urlListChoose_"+theId).val();
	try{
		if(mec_idV != ""){
			Mec_SetLazyLoad(mec_idV); //设置延迟加载
		}
	}catch(e){
	
	}
}

function MADCdar_wsListChoose(theId){
	var mec_idV = $("#wsListChoose_"+theId).val();
	try{
		if(mec_idV != ""){
			Mec_SetLazyLoad(mec_idV); //设置延迟加载
		}
	}catch(e){
	
	}
}

function MADCdar_timeLineChoose(theId){
	var mec_idV = $("#timeLineChoose_"+theId).val();
	$("#timeLineFieldSet_"+theId).html("").append("<option value=\"\"></option>");
	$("#timeLineBetweenStartFieldSet_"+theId).html("").append("<option value=\"\"></option>");
	$("#timeLineBetweenEndFieldSet_"+theId).html("").append("<option value=\"\"></option>");
	try{
		if(mec_idV != ""){
			var mecHandler = MECHandlerPool.getHandler(mec_idV);
			var fileldList = mecHandler.getFieldInfo();
			for(var i = 0; i < fileldList.length; i++){
				var optionStr = "<option value=\""+fileldList[i].fieldName+"\" fieldid=\""+fileldList[i].fieldid+"\">";
				optionStr += fileldList[i].fieldDesc;
				optionStr += "</option>";
				$("#timeLineFieldSet_"+theId).append(optionStr);
				$("#timeLineBetweenStartFieldSet_"+theId).append(optionStr);
				$("#timeLineBetweenEndFieldSet_"+theId).append(optionStr);
			}
			Mec_SetLazyLoad(mec_idV); //设置延迟加载
		}
	}catch(e){
		
	}
}

function MADCdar_BetweenFieldChoose(type,theId){
	if("1" == type){
		var mec_idV = $("#listBetweenFieldSet_"+theId).val();
		if(mec_idV == "1"){
			$("#listEqFieldSpan_"+theId).show();
			$("#listLtGtFieldSpan_"+theId).hide();
		}else{
			$("#listEqFieldSpan_"+theId).hide();
			$("#listLtGtFieldSpan_"+theId).show();
		}
	}else if("2" == type){
		var mec_idV = $("#timeLineBetweenFieldSet_"+theId).val();
		if(mec_idV == "1"){
			$("#timeLineEqFieldSpan_"+theId).show();
			$("#timeLineLtGtFieldSpan_"+theId).hide();
		}else{
			$("#timeLineEqFieldSpan_"+theId).hide();
			$("#timeLineLtGtFieldSpan_"+theId).show();
		}
	}
}

function MADCdar_isShowLunar(theId){
	var isShowLunarV = $("#isShowLunar_"+theId);
	if(isShowLunarV[0].checked){
		$("table",$("._m_cdar_loadCalendarDay_Container")).removeClass("_m_cdar_noneLunar");
	}else{
		$("table",$("._m_cdar_loadCalendarDay_Container")).addClass("_m_cdar_noneLunar");
	}
}

function MADCdar_isShowGoBack(theId){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var isShowGoBackV = $("#isShowGoBack_"+theId);
		if(isShowGoBackV[0].checked){
			$("#_m_cdar_calendarYearMonth").removeClass("_m_cdar_calendarYearMonth_noBack").addClass("_m_cdar_calendarYearMonth");
		}else{
			$("#_m_cdar_calendarYearMonth").removeClass("_m_cdar_calendarYearMonth").addClass("_m_cdar_calendarYearMonth_noBack");
		}
	},100);
}

function MADCdar_isShowNew(theId){
	var isShowNewV = $("#isShowNew_"+theId);
	if(isShowNewV[0].checked){
		$("#span_parsedWay_"+theId).show();
		$("#addDataByCalendarDate",$("#NMEC_"+theId)).show(); 
		if($("#parseWayChoose_"+theId+" option:selected").val() == 2){
			$("#span_parsedWay_"+theId+"_2").show();
		}
	}else{
		$(".span_parsedWay").hide();
		$("#addDataByCalendarDate",$("#NMEC_"+theId)).hide(); 
	}
}

function MADCdar_parseWayChoose(theId){
	var parseWayChoose = $("#parseWayChoose_"+theId);
	if(parseWayChoose.val() == 2){
		$("#span_parsedWay_"+theId+"_2").show();
	}else{
		$("#span_parsedWay_"+theId+"_2").hide();
	}
}

function MADCdar_addClickScript(obj,mec_id){
	var $btnScript = $(obj).find("input");
	SL_AddScriptToField($btnScript);
}
