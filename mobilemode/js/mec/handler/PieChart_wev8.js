if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.PieChart = function(typeTmp, idTmp, mecJsonTmp){
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
MEC_NS.PieChart.prototype.getID = function(){
	return this.id;
};

MEC_NS.PieChart.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.PieChart.prototype.getDesignHtml = function(){
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
MEC_NS.PieChart.prototype.afterDesignHtmlBuild = function(){
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
	
	newP["multiLJson"] = chartMLJson;
	Mobile_NS.PieChart.build(newP);
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
MEC_NS.PieChart.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	var htm = "<div id=\"MADPieChart_"+theId+"\" class=\"MADPieChart_Container\">"
				+"<div class=\"MADPieChart_Title\">"
				+SystemEnv.getHtmlNoteName(4650) //基本信息
				+"</div>"
				+"<div class=\"MADPieChart_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(3978)+"</span>"  //标题：
						+"<input class=\"MADPieChart_Text\" id=\"title_"+theId+"\" type=\"text\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4788)+"：某站点用户访问来源\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4651)+"</span>"  //副标题：
						+"<input class=\"MADPieChart_Text\" id=\"subTitle_"+theId+"\" type=\"text\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4788)+"：此数据来源于网络\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4128)+"</span>"  //高度：
						+"<input class=\"MADPieChart_Text\" id=\"height_"+theId+"\" type=\"text\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4191)+"</span>"  //宽度：
						+"<input class=\"MADPieChart_Text\" id=\"width_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4192)+"\"/>"  //如：600，此处缺省则为页面宽度
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4197)+"</span>"  //颜色：
						+"<input class=\"MADPieChart_Text\" id=\"color_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4789)+"\"/>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADPieChart_Title\">"
				+SystemEnv.getHtmlNoteName(4652) //数据来源
				+"</div>"
				+"<div class=\"MADPieChart_DataSource\">"
					
				+"</div>"
				+"<div class=\"MADPieChart_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
						+"<select class=\"MADPieChart_Select\" id=\"datasource_"+theId+"\">"
						+"  <option value=\"\">(local)</option>"
						+"</select>"
					+"</div>"
					+"<div style=\"position: relative;padding-left: 60px;\">"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label"+styleL+"\" style=\"position: absolute;top: 3px;left: 0px;\">SQL：</span>"
						+"<textarea class=\"MADPieChart_Textarea\" id=\"sql_"+theId+"\"></textarea>"
						+"<div style=\"padding-top: 3px;\"><a href=\"javascript:void(0);\" onclick=\"MADPieChart_OpenSQLHelp();\">"+SystemEnv.getHtmlNoteName(4202)+"</a><a href=\"javascript:void(0);\" style=\"margin-right:15px;float:right;\" onclick=\"MADPieChart_fillSQL('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4653)+"</a></div>"  //填充示例SQL
					+"</div>"
				+"</div>"
				+"<div class=\"MADPieChart_Title\">"
				+SystemEnv.getHtmlNoteName(4654) //其他设置
				+"</div>"
				+"<div class=\"MADPieChart_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4655)+"：</span>" //显示图例
						+"<input type=\"checkbox\" id=\"isShowLegend_"+theId+"\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4663)+"：</span>" //显示标签
						+"<input type=\"checkbox\" id=\"isShowLabel_"+theId+"\"/>"
						+"<span style=\"margin-left: 10px;\">"+SystemEnv.getHtmlNoteName(4664)+"</span>" //(注：在饼图图形上的文本标签)
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4796)+"：</span>" //标签位置
						+"<input type=\"checkbox\" name=\"labelPosition_"+theId+"\" value=\"1\"/ onclick=\"MADPieChart_ChangeChartType(this, 'labelPosition_"+theId+"');\"/><span style=\"margin-right:10px;\">"+SystemEnv.getHtmlNoteName(4797)+"</span>" //图表外部
						+"<input type=\"checkbox\" name=\"labelPosition_"+theId+"\" value=\"2\" onclick=\"MADPieChart_ChangeChartType(this, 'labelPosition_"+theId+"');\"/>"+SystemEnv.getHtmlNoteName(4798) //图表里部
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4786)+"：</span>"  //标签字体：
						+"<input class=\"MADPieChart_Text\" id=\"labelFontSize_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4802)+"\"/>"  //坐标轴标签字体大小，如:12
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4949)+"：</span>"  //标签格式：
						+ "<span style=\"display: inline-block;\">"
						+"<input class=\"MADPieChart_Text\" id=\"labelFormat_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4950)+"\"/>"//如：[前缀]#,##0.00[后缀]
						+ "</span>"
					+"</div>"
					+"<div id=\"labelLineContainer"+theId+"\">"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4799)+"：</span>" //引线长度
						+"<input class=\"MADPieChart_Text\" id=\"labelLineLength1_"+theId+"\" type=\"text\" style=\"width:120px;\" placeholder=\""+SystemEnv.getHtmlNoteName(4788)+":5,"+SystemEnv.getHtmlNoteName(4800)+"\"/> - "
						+"<input class=\"MADPieChart_Text\" id=\"labelLineLength2_"+theId+"\" type=\"text\" style=\"width:120px;\" placeholder=\""+SystemEnv.getHtmlNoteName(4788)+":10,"+SystemEnv.getHtmlNoteName(4801)+"\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4666)+"：</span>" //图表直径
						+"<input class=\"MADPieChart_Text\" id=\"radius_"+theId+"\" type=\"text\" style=\"width:38px;\"/>%"
						+"<span style=\"margin-left: 10px;\">"+SystemEnv.getHtmlNoteName(4667)+"</span>" //(注：取值0-100，控制饼图大小)
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4658)+"：</span>" //图表类型
						+"<input type=\"checkbox\" name=\"chartType_"+theId+"\" value=\"1\"/ onclick=\"MADPieChart_ChangeChartType(this, 'chartType_"+theId+"');\"/><span style=\"margin-right:10px;\">"+SystemEnv.getHtmlNoteName(4665)+"</span>" //饼状图
						+"<input type=\"checkbox\" name=\"chartType_"+theId+"\" value=\"2\" onclick=\"MADPieChart_ChangeChartType(this, 'chartType_"+theId+"');\"/>"+SystemEnv.getHtmlNoteName(4188) //环形图
					+"</div>"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4129)+"</span>"  //延迟加载：
						+"<input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADPieChart_Title\">"
				+SystemEnv.getHtmlNoteName(4415) //交互设置
				+"</div>"
				+"<div class=\"MADPieChart_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADPieChart_BaseInfo_Label MADPieChart_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(3977)+"</span>"  //链接地址：
						+ "<span style=\"display: inline-block;\">"
						+"<input class=\"MADPieChart_Text\" id=\"clickUrl_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4790)+"址\"/>"
						+ "</span>"
					+"</div>"
					+"<div>"
						+"<div class=\"col\">"+SystemEnv.getHtmlNoteName(4791)+"："
						+"<div style=\"margin: 5px 0px;\">_chart_name："+SystemEnv.getHtmlNoteName(4792)+"。"+SystemEnv.getHtmlNoteName(4788)+" \"搜索引擎\"</div>"
						+"<div style=\"margin: 5px 0px;\">_chart_value："+SystemEnv.getHtmlNoteName(4794)+"。"+SystemEnv.getHtmlNoteName(4788)+" \"35.75\"</div>"
						+"<div style=\"margin: 5px 0px;line-height: 20px;\">"+SystemEnv.getHtmlNoteName(4795)+"</div>"
						+"</div>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADPieChart_Bottom\"><div class=\"MADPieChart_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.PieChart.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	
	$("#title_" + theId).val(this.mecJson["title"]);
	$("#subTitle_" + theId).val(this.mecJson["subTitle"]);
	$("#height_" + theId).val(this.mecJson["height"]);
	$("#width_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["width"]));
	$("#color_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["color"]));//颜色
	$("#clickUrl_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["clickUrl"]));
	$("#labelFormat_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["labelFormat"]));

	
	//动态获取数据源的值，并给数据源添加HTML
	$("#datasource_" + theId).val(this.mecJson["datasource"]);
	MADPieChart_setDataSourceHTML(theId,this.mecJson["datasource"]);

	var $sql = $("#sql_" + theId);
	$sql[0].value = this.mecJson["sql"];
	$sql.focus(function(){
		$(this).addClass("MADPieChart_Textarea_Focus");
	});
	$sql.blur(function(){
		$(this).removeClass("MADPieChart_Textarea_Focus");
	});
	
	var isShowLegend = Mec_FiexdUndefinedVal(this.mecJson["isShowLegend"]);
	if(isShowLegend == "1"){
		$("#isShowLegend_"+theId).attr("checked","checked");
	}
	
	var isShowLabel = Mec_FiexdUndefinedVal(this.mecJson["isShowLabel"]);
	if(isShowLabel == "1"){
		$("#isShowLabel_"+theId).attr("checked","checked");
	}
	
	var labelPosition = Mec_FiexdUndefinedVal(this.mecJson["labelPosition"], "1");
	var $labelPosition = $("input[type='checkbox'][name='labelPosition_"+theId+"'][value='"+labelPosition+"']");
	if($labelPosition.length > 0){
		$labelPosition.attr("checked", "checked");
	}
	if(labelPosition == "1"){
		$("#labelLineContainer"+theId).show();
	}else{
		$("#labelLineContainer"+theId).hide();
	}
	$("#labelFontSize_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["labelFontSize"]));
	$("#labelLineLength1_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["labelLineLength1"]));
	$("#labelLineLength2_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["labelLineLength2"]));
	
	$("#radius_" + theId).val(this.mecJson["radius"]);
	
	var chartType = this.mecJson["chartType"];
	var $chartType = $("input[type='checkbox'][name='chartType_"+theId+"'][value='"+chartType+"']");
	if($chartType.length > 0){
		$chartType.attr("checked", "checked");
	}
	
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
	
	
	$("#MADPieChart_"+theId).jNice();
	
	MLanguage({
		container: $("#MADPieChart_"+theId)
    });
};
/*获取JSON*/
MEC_NS.PieChart.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADPieChart_"+theId);
	if($attrContainer.length > 0){
		
		var title = $("#title_" + theId).val();
		var titleML = MLanguage.getValue($("#title_" + theId));
		this.mecJson["title"] = titleML == undefined ? title : titleML;
		
		var subTitle = $("#subTitle_" + theId).val()
		var subTitleML = MLanguage.getValue($("#subTitle_" + theId));
		this.mecJson["subTitle"] = subTitleML == undefined ? subTitle : subTitleML;
		
		this.mecJson["height"] = $("#height_" + theId).val();
		this.mecJson["width"] = $("#width_" + theId).val();
		this.mecJson["color"] = $("#color_" + theId).val();
		this.mecJson["clickUrl"] = $("#clickUrl_" + theId).val();
		
		this.mecJson["datasource"] = $("#datasource_" + theId).val();
		this.mecJson["sql"] = $("#sql_" + theId).val();
		
		this.mecJson["isShowLegend"] = $("#isShowLegend_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["isShowLabel"] = $("#isShowLabel_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["labelPosition"] = $("input[type='checkbox'][name='labelPosition_"+theId+"']:checked").val();
		this.mecJson["labelFontSize"] = $("#labelFontSize_" + theId).val();
		this.mecJson["labelLineLength1"] = $("#labelLineLength1_" + theId).val();
		this.mecJson["labelLineLength2"] = $("#labelLineLength2_" + theId).val();
		this.mecJson["labelFormat"] = $("#labelFormat_" + theId).val();
		
		this.mecJson["radius"] = $("#radius_" + theId).val();
		this.mecJson["chartType"] = $("input[type='checkbox'][name='chartType_"+theId+"']:checked").val();
		this.mecJson["lazyLoad"] = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";
	}
	return this.mecJson;
};

MEC_NS.PieChart.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["title"] = "";
	defMecJson["subTitle"] = "";
	defMecJson["height"] = "300";
	
	defMecJson["datasource"] = "";
	defMecJson["sql"] = "";
	
	defMecJson["isShowLegend"] = "1";
	defMecJson["isShowLabel"] = "1";
	defMecJson["radius"] = "55";
	defMecJson["chartType"] = "1";
	
	
	return defMecJson;
};

function MADPieChart_OpenSQLHelp(){
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 540;//定义长度
	dlg.Height = 555;
	dlg.URL = "/mobilemode/pieChartHelp.jsp";
	dlg.Title = SystemEnv.getHtmlNoteName(4204);  //SQL帮助
	dlg.show();
}

function MADPieChart_fillSQL(mec_id){
	var $sql = $("#sql_" + mec_id);
	if($.trim($sql.val()) != ""){
		if(!confirm(SystemEnv.getHtmlNoteName(4856))){//示例SQL会覆盖现有的SQL，确认继续吗？
			return;
		}
	}
	$sql.val("select pagename,(select COUNT(1) from MobileExtendComponent where objid = a.id) as value from AppHomepage a where appid = " + _appid);
}

function MADPieChart_setDataSourceHTML(mec_id,val){
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

function MADPieChart_ChangeChartType(cbObj, id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='"+id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		if(id && id.indexOf('labelPosition') != -1){
			var labelPosition = $("input[type='checkbox'][name='"+id+"']:checked").val();
			var mecid = id.replace("labelPosition_", "");
			if(labelPosition == "1"){
				$("#labelLineContainer"+mecid).show();
			}else{
				$("#labelLineContainer"+mecid).hide();
			}
		}
	},100);
}
