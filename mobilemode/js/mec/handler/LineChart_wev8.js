if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.LineChart = function(typeTmp, idTmp, mecJsonTmp){
	this.type = typeTmp;
	if(!idTmp){
		idTmp = new UUID().toString();
	}
	this.id = idTmp;
	if(!mecJsonTmp){
		mecJsonTmp = this.getDefaultMecJson();
	}
	this.mecJson = mecJsonTmp;
}

/*获取id。 必需的方法*/
MEC_NS.LineChart.prototype.getID = function(){
	return this.id;
};

MEC_NS.LineChart.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.LineChart.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	htmTemplate = htmTemplate.replace(/\${theId}/g, theId);
	htmTemplate = htmTemplate.replace(/\${height}/g, this.mecJson["height"]);
	var width = Mec_FiexdUndefinedVal(this.mecJson["width"]);
	var widthStyle = "";
	if($.trim(width) != ""){
		widthStyle = "width:" + width;
		if(width.indexOf("px") == -1 || width.indexOf("%") == -1){
			widthStyle += "px;";
		}else{
			widthStyle += ";";
		}
	}
	htmTemplate = htmTemplate.replace(/\${widthStyle}/g, widthStyle);
	var htm = htmTemplate;
	return htm;
};


/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.LineChart.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	var p = this.mecJson;
	p["id"] = theId;
	p["title"] = MLanguage.parse(p["title"]);
	p["subTitle"] = MLanguage.parse(p["subTitle"]);
	
	var newP = JSON.parse(JSON.stringify(p));
	newP["_mode"] = "0";
	var chartMLJson = {};
	chartMLJson['4205'] = SystemEnv.getHtmlNoteName(4205);//图表信息设置不完整，未配置数据来源SQL
	chartMLJson['4206'] = SystemEnv.getHtmlNoteName(4206);//SQL中可能包含待解析的参数变量，需运行时显示
	chartMLJson['4207'] = SystemEnv.getHtmlNoteName(4207);//数据来源SQL未通过系统安全测试，请检查关键字
	chartMLJson['4208'] = SystemEnv.getHtmlNoteName(4208);//查询数据来源SQL时出现错误，请检查SQL是否拼写正确
	chartMLJson['4209'] = SystemEnv.getHtmlNoteName(4209);//加载图表时出现错误
	chartMLJson['5200'] = SystemEnv.getHtmlNoteName(5200);//平均值
	
	newP["multiLJson"] = chartMLJson;
	
	Mobile_NS.LineChart.build(newP);
	/*
	return;
	_MEC_ChartWidth = $("#content_editor").width()-4;
		
	chart_run_mode = 0;
	
	var p = this.mecJson;
	p["id"] = theId;
	var charttype = p["charttype"];
	eval("BuildChart_"+charttype+"(p)");
	$("#ChartContainer_"+theId).css("overflow-x","hidden");
	*/
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.LineChart.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	var htm = "<div id=\"MADLineChart_"+theId+"\" class=\"MADLineChart_Container\">"
				+"<div class=\"MADLineChart_Title\">"
				+SystemEnv.getHtmlNoteName(4650) //基本信息
				+"</div>"
				+"<div class=\"MADLineChart_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(3978)+"</span>"  //标题：
						+"<input class=\"MADLineChart_Text\" id=\"title_"+theId+"\" type=\"text\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4788)+"：上海地区未来一周气温变化\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4651)+"</span>"  //副标题：
						+"<input class=\"MADLineChart_Text\" id=\"subTitle_"+theId+"\" type=\"text\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4788)+"：此数据来源于网络\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4128)+"</span>"  //高度：
						+"<input class=\"MADLineChart_Text\" id=\"height_"+theId+"\" type=\"text\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4191)+"</span>"  //宽度：
						+"<input class=\"MADLineChart_Text\" id=\"width_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4192)+"\"/>"  //如：600，此处缺省则为页面宽度
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4683)+"</span>"  //左边距：
						+"<input class=\"MADLineChart_Text\" id=\"gridleft_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4684)+"\"/>"  //如：20或20%,此处可填数字或百分比
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4766)+"</span>"  //右边距：
						+"<input class=\"MADLineChart_Text\" id=\"gridright_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4684)+"\"/>"  //如：20或20%,此处可填数字或百分比
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4197)+"</span>"  //颜色：
						+"<input class=\"MADLineChart_Text\" id=\"color_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4789)+"\"/>"
					+"</div>"
				+"</div>"
				/*
				+"<div class=\"MADLineChart_Title\">"
					+SystemEnv.getHtmlNoteName(4195)  //标题信息
				+"</div>"
				+"<div class=\"MADLineChart_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4196)+"</span>"  //字体：
						+"<input class=\"MADLineChart_Text\" id=\"title_font_"+theId+"\" type=\"text\" style=\"width: 65px;\"/>"
						
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\" style=\"width: 40px;\">"+SystemEnv.getHtmlNoteName(4197)+"</span>"  //颜色：
						+"<input class=\"MADLineChart_Text\" id=\"title_color_"+theId+"\" type=\"text\" style=\"width: 65px;\"/>"
						
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\" style=\"width: 40px;\">"+SystemEnv.getHtmlNoteName(4198)+"</span>"  //大小：
						+"<input class=\"MADLineChart_Text\" id=\"title_fontsize_"+theId+"\" type=\"text\" style=\"width: 36px;\"/>&nbsp;PX"
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label2"+styleL+"\">"+SystemEnv.getHtmlNoteName(4199)+"</span>"  //是否粗体：
						+"<input id=\"title_fontweight_"+theId+"\" type=\"checkbox\" value=\"bold\"/>"
					+"</div>"
				+"</div>"
				*/
				+"<div class=\"MADLineChart_Title\">"
				+SystemEnv.getHtmlNoteName(4652) //数据来源
				+"</div>"
				+"<div class=\"MADLineChart_DataSource\">"
					
				+"</div>"
				+"<div class=\"MADLineChart_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
						+"<select class=\"MADLineChart_Select\" id=\"datasource_"+theId+"\">"
						+"  <option value=\"\">(local)</option>"
						+"</select>"
					+"</div>"
					+"<div style=\"position: relative;padding-left: 60px;\">"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\" style=\"position: absolute;top: 3px;left: 0px;\">SQL：</span>"
						+"<textarea class=\"MADLineChart_Textarea\" id=\"sql_"+theId+"\"></textarea>"
						+"<div style=\"padding-top: 3px;\"><a href=\"javascript:void(0);\" onclick=\"MADLineChart_OpenSQLHelp();\">"+SystemEnv.getHtmlNoteName(4202)+"</a><a href=\"javascript:void(0);\" style=\"margin-right:15px;float:right;\" onclick=\"MADLineChart_fillSQL('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4653)+"</a></div>"  //填充示例SQL
					+"</div>"
					/*
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label3"+styleL+"\">"+SystemEnv.getHtmlNoteName(4203)+"</span>"  //数据后缀：
						+"<input class=\"MADLineChart_Text\" id=\"valuesuffix_"+theId+"\" type=\"text\"/>"
					+"</div>"
					*/
				+"</div>"
				+"<div class=\"MADLineChart_Title\">"
				+SystemEnv.getHtmlNoteName(4654) //其他设置
				+"</div>"
				+"<div class=\"MADLineChart_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4655)+"：</span>" //显示图例
						+"<input type=\"checkbox\" id=\"isShowLegend_"+theId+"\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4668)+"：</span>" //显示数值
						+"<input type=\"checkbox\" id=\"isShowLabel_"+theId+"\"/>"
						+"<span style=\"margin-left: 10px;\">"+SystemEnv.getHtmlNoteName(4669)+"</span>" //(注：在折线点上显示具体的数值)
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4657)+"：</span>" //显示标线
						+"<input type=\"checkbox\" id=\"isShowMarkLine_"+theId+"\"/>"
						+"<span style=\"margin-left: 10px;\">"+SystemEnv.getHtmlNoteName(4662)+"</span>" //(注：在图表上显示一根平均值的标线)
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4670)+"：</span>" //显示阴影
						+"<input type=\"checkbox\" id=\"isShowArea_"+theId+"\"/>"
						+"<span style=\"margin-left: 10px;\">"+SystemEnv.getHtmlNoteName(4671)+"</span>" //(注：在图表上显示每条折线的阴影面积)
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4782)+"：</span>" //坐标标签
						+"<input type=\"checkbox\" id=\"axisLabelInterval_"+theId+"\"/>"
						+"<span style=\"margin-left: 10px;\">("+SystemEnv.getHtmlNoteName(4783)+")</span>" //(注：勾选强制显示所有标签)
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4784)+"：</span>"  //标签旋转：
						+"<input class=\"MADLineChart_Text\" id=\"axisLabelRotate_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4785)+"\"/>"  //坐标轴标签旋转角度，如:30
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4786)+"：</span>"  //标签字体：
						+"<input class=\"MADLineChart_Text\" id=\"axisLabelFontSize_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4787)+"\"/>"  //坐标轴标签字体大小，如:12
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4949)+"：</span>"  //标签格式：
						+ "<span style=\"display: inline-block;\">"
						+"<input class=\"MADLineChart_Text\" id=\"labelFormat_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4950)+"\"/>"//如：[前缀]#,##0.00[后缀]
						+ "</span>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4129)+"</span>"  //延迟加载：
						+"<input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADLineChart_Title\">"
				+SystemEnv.getHtmlNoteName(4415) //交互设置
				+"</div>"
				+"<div class=\"MADLineChart_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADLineChart_BaseInfo_Label MADLineChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(3977)+"</span>"  //链接地址：
						+ "<span style=\"display: inline-block;\">"
						+"<input class=\"MADLineChart_Text\" id=\"clickUrl_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4790)+"\"/>"
						+ "</span>"
					+"</div>"
					+"<div>"
						+"<div class=\"col\">"+SystemEnv.getHtmlNoteName(4791)+"："
						+"<div style=\"margin: 5px 0px;\">_chart_name："+SystemEnv.getHtmlNoteName(4792)+"。"+SystemEnv.getHtmlNoteName(4788)+" \"周一\"</div>"
						+"<div style=\"margin: 5px 0px;\">_chart_seriesName："+SystemEnv.getHtmlNoteName(4793)+"。"+SystemEnv.getHtmlNoteName(4788)+" \"最高气温\"</div>"
						+"<div style=\"margin: 5px 0px;\">_chart_value："+SystemEnv.getHtmlNoteName(4794)+"。"+SystemEnv.getHtmlNoteName(4788)+" \"11\"</div>"
						+"<div style=\"margin: 5px 0px;line-height: 20px;\">"+SystemEnv.getHtmlNoteName(4795)+"</div>"
						+"</div>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADLineChart_Bottom\"><div class=\"MADLineChart_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.LineChart.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	
	$("#title_" + theId).val(this.mecJson["title"]);
	$("#subTitle_" + theId).val(this.mecJson["subTitle"]);
	$("#height_" + theId).val(this.mecJson["height"]);
	$("#width_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["width"]));
	$("#gridleft_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["gridleft"]));//左边距
	$("#gridright_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["gridright"]));//右边距
	$("#color_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["color"]));//颜色
	$("#clickUrl_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["clickUrl"]));
	$("#labelFormat_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["labelFormat"]));
	
	//动态获取数据源的值，并给数据源添加HTML
	$("#datasource_" + theId).val(this.mecJson["datasource"]);
	MADLineChart_setDataSourceHTML(theId,this.mecJson["datasource"]);

	var $sql = $("#sql_" + theId);
	$sql[0].value = this.mecJson["sql"];
	$sql.focus(function(){
		$(this).addClass("MADLineChart_Textarea_Focus");
	});
	$sql.blur(function(){
		$(this).removeClass("MADLineChart_Textarea_Focus");
	});
	
	var isShowLegend = Mec_FiexdUndefinedVal(this.mecJson["isShowLegend"]);
	if(isShowLegend == "1"){
		$("#isShowLegend_"+theId).attr("checked","checked");
	}
	
	var isShowLabel = Mec_FiexdUndefinedVal(this.mecJson["isShowLabel"]);
	if(isShowLabel == "1"){
		$("#isShowLabel_"+theId).attr("checked","checked");
	}
	
	var isShowMarkLine = Mec_FiexdUndefinedVal(this.mecJson["isShowMarkLine"]);
	if(isShowMarkLine == "1"){
		$("#isShowMarkLine_"+theId).attr("checked","checked");
	}
	
	var isShowArea = this.mecJson["isShowArea"];
	if(isShowArea == "1"){
		$("#isShowArea_"+theId).attr("checked","checked");
	}
	
	var axisLabelInterval = Mec_FiexdUndefinedVal(this.mecJson["axisLabelInterval"]);
	if(axisLabelInterval == "1"){
		$("#axisLabelInterval_"+theId).attr("checked","checked");
	}
	$("#axisLabelRotate_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["axisLabelRotate"]));
	$("#axisLabelFontSize_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["axisLabelFontSize"]));
	
	var lazyLoad = Mec_FiexdUndefinedVal(this.mecJson["lazyLoad"]);
	if(lazyLoad == "1"){
		$("#lazyLoad_"+theId).attr("checked","checked");
	}
	
	new URLSelector("clickUrl_"+theId).init();
	
	var lableFormatData = [
		{"pattern":"[℃]", "name":SystemEnv.getHtmlNoteName(4951)},//温度
		{"pattern":"#,##", "name":SystemEnv.getHtmlNoteName(4952)},//千分位
		{"pattern":"0.00", "name":SystemEnv.getHtmlNoteName(4953)},//保留两位小数
		{"pattern":"[￥]#,##0.00", "name":SystemEnv.getHtmlNoteName(3916)}//自定义
		];
	new URLSelector("labelFormat_"+theId).init();
	
	var $panel = $("<div id=\"labelFormat_"+theId+"_url_selector\" class=\"url-selector-panel\"></div>");
	$panel.append("<div style=\"display:none\" class=\"url-selector-panel-search\"><input type=\"text\" placeholder=\"\"/></div>");
	var html = "<div class=\"url-selector-panel-content\">";
	html += "<ul>";
	for(var i = 0; i < lableFormatData.length; i++){
		var name = lableFormatData[i]["name"];
		var pattern = lableFormatData[i]["pattern"];
		html += "<li data-pattern=\""+pattern+"\">"+name+"</li>";
	}
	html += "</ul>";
	html += "</div>";
	$panel.append(html);
	$(document.body).append($panel);
	
	$("li", $panel).click(function(){
		var pattern = $(this).attr("data-pattern");
		$("#labelFormat_"+theId).val(pattern).focus();
	}).mouseover(function(){
		$(this).removeClass("selected");
	});
	
	$("#MADLineChart_"+theId).jNice();
	
	MLanguage({
		container: $("#MADLineChart_"+theId)
    });
};

/*获取JSON*/
MEC_NS.LineChart.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADLineChart_"+theId);
	if($attrContainer.length > 0){
		
		var title = $("#title_" + theId).val();
		var titleML = MLanguage.getValue($("#title_" + theId));
		this.mecJson["title"] = titleML == undefined ? title : titleML;
		
		var subTitle = $("#subTitle_" + theId).val()
		var subTitleML = MLanguage.getValue($("#subTitle_" + theId));
		this.mecJson["subTitle"] = subTitleML == undefined ? subTitle : subTitleML;
		
		this.mecJson["height"] = $("#height_" + theId).val();
		this.mecJson["width"] = $("#width_" + theId).val();
		this.mecJson["gridleft"] = $("#gridleft_" + theId).val();
		this.mecJson["gridright"] = $("#gridright_" + theId).val();
		this.mecJson["color"] = $("#color_" + theId).val();
		this.mecJson["clickUrl"] = $("#clickUrl_" + theId).val();
		
		this.mecJson["datasource"] = $("#datasource_" + theId).val();
		this.mecJson["sql"] = $("#sql_" + theId).val();
		
		this.mecJson["isShowLegend"] = $("#isShowLegend_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["isShowLabel"] = $("#isShowLabel_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["isShowMarkLine"] = $("#isShowMarkLine_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["isShowArea"] = $("#isShowArea_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["axisLabelInterval"] = $("#axisLabelInterval_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["axisLabelRotate"] = $("#axisLabelRotate_" + theId).val();
		this.mecJson["axisLabelFontSize"] = $("#axisLabelFontSize_" + theId).val();
		this.mecJson["labelFormat"] = $("#labelFormat_" + theId).val();
		
		this.mecJson["lazyLoad"] = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";
	}
	return this.mecJson;
};

MEC_NS.LineChart.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["title"] = "";
	defMecJson["subTitle"] = "";
	defMecJson["height"] = "400";
	
	defMecJson["datasource"] = "";
	defMecJson["sql"] = "";
	
	defMecJson["isShowLegend"] = "1";
	defMecJson["isShowLabel"] = "0";
	defMecJson["isShowMarkLine"] = "1";
	defMecJson["isShowArea"] = "0";
	
	
	return defMecJson;
};

function MADLineChart_OpenSQLHelp(){
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 540;//定义长度
	dlg.Height = 555;
	dlg.URL = "/mobilemode/lineChartHelp.jsp";
	dlg.Title = SystemEnv.getHtmlNoteName(4204);  //SQL帮助
	dlg.show();
}

function MADLineChart_fillSQL(mec_id){
	var $sql = $("#sql_" + mec_id);
	if($.trim($sql.val()) != ""){
		if(!confirm(SystemEnv.getHtmlNoteName(4856))){//示例SQL会覆盖现有的SQL，确认继续吗？
			return;
		}
	}
	var datasource = $("#datasource_" + mec_id).val();
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getDbType&datasource="+datasource);
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		var sqlfrom = "";
		if(result['dbtype'] == 'oracle'){
			sqlfrom = " from dual ";
		}
		$sql.val("select '周一' as name, 11 as \"最高温度\", 1 as \"最低温度\" "+sqlfrom+" union all select '周二' as name, 7 as \"最高温度\", 6 as \"最低温度\" "+sqlfrom+" union all select '周三' as name, 15 as \"最高温度\", 2 as \"最低温度\" "+sqlfrom+" union all select '周四' as name, 13 as \"最高温度\", 5 as \"最低温度\" "+sqlfrom+" union all select '周五' as name, 12 as \"最高温度\", 3 as \"最低温度\" "+sqlfrom+" union all select '周六' as name, 13 as \"最高温度\", 2 as \"最低温度\" "+sqlfrom+" union all select '周日' as name, 10 as \"最高温度\", 4 as \"最低温度\" "+sqlfrom);
	});
}

function MADLineChart_setDataSourceHTML(mec_id,val){
	var $MADL_DataSource = $("#datasource_" + mec_id);
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
			$MADL_DataSource.append(dataSourceSelectHtml);
		}
	});
}
