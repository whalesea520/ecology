if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Chart = function(typeTmp, idTmp, mecJsonTmp){
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
MEC_NS.Chart.prototype.getID = function(){
	return this.id;
};

MEC_NS.Chart.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Chart.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htm = "<div id=\"ChartContainer_"+theId+"\" style=\"width:100%;overflow-x:auto;overflow-y:hidden;-webkit-overflow-scrolling:touch;\"></div>";
	return htm;
};


/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Chart.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	_MEC_ChartWidth = $("#content_editor").width()-4;
		
	chart_run_mode = 0;
	
	var p = this.mecJson;
	p["id"] = theId;
	p["title"] = MLanguage.parse(p["title"]);
	var charttype = p["charttype"];
	
	var chartMLJson = {};
	chartMLJson['4205'] = SystemEnv.getHtmlNoteName(4205);//图表信息设置不完整，未配置数据来源SQL
	chartMLJson['4206'] = SystemEnv.getHtmlNoteName(4206);//SQL中可能包含待解析的参数变量，需运行时显示
	chartMLJson['4207'] = SystemEnv.getHtmlNoteName(4207);//数据来源SQL未通过系统安全测试，请检查关键字
	chartMLJson['4208'] = SystemEnv.getHtmlNoteName(4208);//查询数据来源SQL时出现错误，请检查SQL是否拼写正确
	chartMLJson['4209'] = SystemEnv.getHtmlNoteName(4209);//加载图表时出现错误
	
	p["multiLJson"] = chartMLJson;
	
	eval("BuildChart_"+charttype+"(p)");
	$("#ChartContainer_"+theId).css("overflow-x","hidden");
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Chart.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	var htm = "<div id=\"MADC_"+theId+"\" class=\"MADC_Container\">"
				+"<div class=\"MADC_Title\">"
					+SystemEnv.getHtmlNoteName(4184)  //图表基本信息
				+"</div>"
				+"<div class=\"MADC_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4185)+"</span>"  //类型：
						+"<select class=\"MADC_Select\" id=\"charttype_"+theId+"\" onchange=\"MADC_ChangeType(this);\">"
							+"<option value=\"Column2D\">2D"+SystemEnv.getHtmlNoteName(4186)+"</option>"  //柱形图
							+"<option value=\"Column3D\">3D"+SystemEnv.getHtmlNoteName(4186)+"</option>"  //柱形图
							+"<option value=\"Pie2D\">2D"+SystemEnv.getHtmlNoteName(4187)+"</option>"  //饼图
							+"<option value=\"Pie3D\">3D"+SystemEnv.getHtmlNoteName(4187)+"</option>"  //饼图
							+"<option value=\"Donut2D\">2D"+SystemEnv.getHtmlNoteName(4188)+"</option>"  //环形图
							+"<option value=\"Line2D\">2D"+SystemEnv.getHtmlNoteName(4189)+"</option>"  //折线图
							+"<option value=\"Area2D\">2D"+SystemEnv.getHtmlNoteName(4190)+"</option>"  //面积图
						+"</select>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4128)+"</span>"  //高度：
						+"<input class=\"MADC_Text\" id=\"height_"+theId+"\" type=\"text\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4191)+"</span>"  //宽度：
						+"<input class=\"MADC_Text\" id=\"width_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4192)+"\"/>"  //如：600，此处缺省则为页面宽度
					+"</div>"
					+"<div id=\"onlyline\">"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label3"+styleL+"\">"+SystemEnv.getHtmlNoteName(4193)+"</span>"  //折线颜色：
						+"<input class=\"MADC_Text\" id=\"linecolor_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4194)+"\" />"  //默认为蓝色
					+"</div>"
					+"<div>"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4129)+"</span>"  //延迟加载：
						+"<input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADC_Title\">"
					+SystemEnv.getHtmlNoteName(4195)  //标题信息
				+"</div>"
				+"<div class=\"MADC_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(3978)+"</span>"  //标题：
						+"<input class=\"MADC_Text\" id=\"title_"+theId+"\" type=\"text\" data-multi=false />"
					+"</div>"
					+"<div>"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4196)+"</span>"  //字体：
						+"<input class=\"MADC_Text\" id=\"title_font_"+theId+"\" type=\"text\" style=\"width: 65px;\"/>"
						
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label"+styleL+"\" style=\"width: 40px;\">"+SystemEnv.getHtmlNoteName(4197)+"</span>"  //颜色：
						+"<input class=\"MADC_Text\" id=\"title_color_"+theId+"\" type=\"text\" style=\"width: 65px;\"/>"
						
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label"+styleL+"\" style=\"width: 40px;\">"+SystemEnv.getHtmlNoteName(4198)+"</span>"  //大小：
						+"<input class=\"MADC_Text\" id=\"title_fontsize_"+theId+"\" type=\"text\" style=\"width: 36px;\"/>&nbsp;PX"
					+"</div>"
					+"<div>"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label2"+styleL+"\">"+SystemEnv.getHtmlNoteName(4199)+"</span>"  //是否粗体：
						+"<input id=\"title_fontweight_"+theId+"\" type=\"checkbox\" value=\"bold\"/>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADC_Title\">"
					+SystemEnv.getHtmlNoteName(4200)  //图表数据来源
				+"</div>"
				+"<div class=\"MADC_DataSource\">"
					+"<div style=\"position: relative;padding-left: 72px;\">"
						+"<span class=\"MADC_DataSource_Label MADC_DataSource_Label"+styleL+"\" style=\"position: absolute;top: 3px;left: 0px;\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
						+"<select class=\"MADC_Select\" id=\"datasource_"+theId+"\">"
						+"  <option value=\"\">(local)</option>"
						+"</select>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADC_BaseInfo\">"
					+"<div style=\"position: relative;padding-left: 60px;\">"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label"+styleL+"\" style=\"position: absolute;top: 3px;left: 0px;\">SQL：</span>"
						+"<textarea class=\"MADC_Textarea\" id=\"sql_"+theId+"\"></textarea>"
						+"<div style=\"padding-top: 3px;\"><a href=\"javascript:void(0);\" onclick=\"MADC_OpenSQLHelp();\">"+SystemEnv.getHtmlNoteName(4202)+"</a></div>"  //如何书写SQL？
					+"</div>"
					+"<div>"
						+"<span class=\"MADC_BaseInfo_Label MADC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4949)+"</span>"  //标签格式：
						+ "<span style=\"display: inline-block;\">"
						+"<input class=\"MADC_Text\" id=\"labelFormat_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4950)+"\"/>" //如：[前缀]#,##0.00[后缀]
						+ "</span>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADC_Bottom\"><div class=\"MADC_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Chart.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	if(this.mecJson["charttype"]=="Area2D" || this.mecJson["charttype"]=="Line2D"){
		$("#onlyline").css("display","block");
	}else{
		$("#onlyline").css("display","none");
	}
	
	$("#charttype_" + theId).val(this.mecJson["charttype"]);
	$("#height_" + theId).val(this.mecJson["height"]);
	$("#width_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["width"]));
	$("#linecolor_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["linecolor"]));
	
	var lazyLoad = Mec_FiexdUndefinedVal(this.mecJson["lazyLoad"]);
	if(lazyLoad == "1"){
		$("#lazyLoad_"+theId).attr("checked","checked");
	}
	$("#title_" + theId).val(this.mecJson["title"]);
	$("#title_font_" + theId).val(this.mecJson["title_font"]);
	$("#title_color_" + theId).val(this.mecJson["title_color"]);
	$("#title_fontsize_" + theId).val(this.mecJson["title_fontsize"]);
	
	var title_fontweight = this.mecJson["title_fontweight"];
	if(title_fontweight == "bold"){
		$("#title_fontweight_" + theId).attr("checked","checked");
	}
	
	//动态获取数据源的值，并给数据源添加HTML
	$("#datasource_" + theId).val(this.mecJson["datasource"]);
	MADC_setDataSourceHTML(theId,this.mecJson["datasource"]);

	$("#labelFormat_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["labelFormat"]));
	
	var $sql = $("#sql_" + theId);
	$sql[0].value = this.mecJson["sql"];
	
	$sql.focus(function(){
		$(this).addClass("MADC_Textarea_Focus");
	});
	$sql.blur(function(){
		$(this).removeClass("MADC_Textarea_Focus");
	});
	
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
	
	$("#MADC_"+theId).jNice();
	
	MLanguage({
		container: $("#MADC_"+theId)
    });
};

/*获取JSON*/
MEC_NS.Chart.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADC_"+theId);
	if($attrContainer.length > 0){
		var charttype = $("#charttype_" + theId).val();
		var height = $("#height_" + theId).val();
		var width = $("#width_" + theId).val();
		var linecolor = $("#linecolor_" + theId).val();
		var lazyLoad = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";
		var title = $("#title_" + theId).val();
		var titleML = MLanguage.getValue($("#title_" + theId));
		var title_font = $("#title_font_" + theId).val();
		var title_color = $("#title_color_" + theId).val();
		var title_fontsize = $("#title_fontsize_" + theId).val();
		var title_fontweight = $("#title_fontweight_" + theId).is(':checked') ? "bold" : "normal";
		var datasource = $("#datasource_" + theId).val();
		var sql = $("#sql_" + theId).val();
		
		this.mecJson["charttype"] = charttype;
		this.mecJson["height"] = height;
		this.mecJson["width"] = width;
		this.mecJson["linecolor"] = linecolor;
		this.mecJson["lazyLoad"] = lazyLoad;
		this.mecJson["title"] = titleML == undefined ? title : titleML;
		this.mecJson["title_font"] = title_font;
		this.mecJson["title_color"] = title_color;
		this.mecJson["title_fontsize"] = title_fontsize;
		this.mecJson["title_fontweight"] = title_fontweight;
		this.mecJson["datasource"] = datasource;
		this.mecJson["sql"] = sql;
		this.mecJson["labelFormat"] = $("#labelFormat_" + theId).val();
	}
	return this.mecJson;
};

MEC_NS.Chart.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["charttype"] = "Column2D";
	defMecJson["height"] = "400";
	defMecJson["linecolor"] = "blue";
	
	defMecJson["title"] = "";
	defMecJson["title_font"] = "Verdana";
	defMecJson["title_color"] = "black";
	defMecJson["title_fontsize"] = "18";
	defMecJson["title_fontweight"] = "bold";
	
	defMecJson["datasource"] = "";
	defMecJson["sql"] = "";
	
	return defMecJson;
};

function MADC_OpenSQLHelp(){
	var url = "/mobilemode/chartSQLHelp.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 540;//定义长度
	dlg.Height = 555;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4204);  //SQL帮助
	dlg.show();
}

function MADC_setDataSourceHTML(mec_id,val){
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

function MADC_ChangeType(o){
	var val = $(o).val();
	if(val=="Area2D" || val=="Line2D"){
		$("#onlyline").css("display","block");
	}else{
		$("#onlyline").css("display","none");
	}
}