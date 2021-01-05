if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Chart2 = function(typeTmp, idTmp, mecJsonTmp){
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
MEC_NS.Chart2.prototype.getID = function(){
	return this.id;
};

MEC_NS.Chart2.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Chart2.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htm = "<div class=\"chart2Container\" id=\"NMEC_"+theId+"\"></div>";
	return htm;
};


/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Chart2.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	_MEC_ChartWidth = $("#content_editor").width()-4;
		
	var p = this.mecJson;
	p["id"] = theId;
	var charttype = p["charttype"];
	var chartMLJson = {};
	chartMLJson['4205'] = SystemEnv.getHtmlNoteName(4205);//图表信息设置不完整，未配置数据来源SQL
	chartMLJson['4206'] = SystemEnv.getHtmlNoteName(4206);//SQL中可能包含待解析的参数变量，需运行时显示
	chartMLJson['4207'] = SystemEnv.getHtmlNoteName(4207);//数据来源SQL未通过系统安全测试，请检查关键字
	chartMLJson['4208'] = SystemEnv.getHtmlNoteName(4208);//查询数据来源SQL时出现错误，请检查SQL是否拼写正确
	chartMLJson['4209'] = SystemEnv.getHtmlNoteName(4209);//加载图表时出现错误
	chartMLJson['5201'] = SystemEnv.getHtmlNoteName(5201);//此插件不支持IE浏览器，请换其他浏览器预览(chrome, safari)

	p["multiLJson"] = chartMLJson;
	
	$("#NMEC_" + theId).html("");
	eval("BuildChart2_"+charttype+"(p, false)");
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Chart2.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;

	var tip = ""
	if(_userLanguage=="8"){
		tip = "SQL format description, please click on the SQL help, where you can use the page Jump to pass over the parameters, namely: {parameter name}";
	}else if(_userLanguage=="9"){
		tip = "SQL格式說明請點擊SQL幫助，此處可以使用頁面跳轉時傳遞過來的參數，即：{參數名稱}";
	}else{
		tip = "SQL格式说明请点击SQL帮助，此处可以使用页面跳转时传递过来的参数，即：{参数名称}";
	}
	var theId = this.id;
	var htm = "<div id=\"MADChart2_"+theId+"\" class=\"MADChart2_Container\">"
				+"<div class=\"MADChart2_Title\">"
					+SystemEnv.getHtmlNoteName(4184)  //图表基本信息
				+"</div>"
				+"<div class=\"MADChart2_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4185)+"</span>"  //类型：
						+"<select class=\"MADChart2_Select\" id=\"charttype_"+theId+"\" onchange=\"MADChart2_ChangeType('" + theId + "', this);\">"
							+"<option value=\"LineGraph\">"+SystemEnv.getHtmlNoteName(4189)+"</option>"  //折线图
							+"<option value=\"Circle\">"+SystemEnv.getHtmlNoteName(4227)+"</option>"  //圆形图
						+"</select>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4128)+"</span>"  //高度：
						+"<input class=\"MADChart2_Text\" id=\"height_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4586)+"\"/>"  //如：175，此处缺省为插件高度
					+"</div>"
					+"<div>"
						+"<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4191)+"</span>"  //宽度：
						+"<input class=\"MADChart2_Text\" id=\"width_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4229)+"\"/>"  //如：320，此处缺省则为页面宽度
					+"</div>"
					+"<div id=\"MADChart2_Tip\" class=\"MADChart2_Tip MADChart2_Tip"+styleL+"\">"+SystemEnv.getHtmlNoteName(4230)+"</div>"  //提示：高度和宽度默认为1:2时显示最佳
					+"<div>"
						+"<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4129)+"</span>"  //延迟加载：
						+"<input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/>"
					+"</div>"
				+"</div>"
				+"<div id=\"MADChart2_PercentViewTitle\" class=\"MADChart2_Title\">"
					+SystemEnv.getHtmlNoteName(4231)  //百分比显示信息
				+"</div>"
				+"<div id=\"MADChart2_PercentViewContent\" class=\"MADChart2_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4196)+"</span>"  //字体：
						+"<input class=\"MADChart2_Text\" id=\"title_font_"+theId+"\" type=\"text\" style=\"width: 65px;\"/>"
					
						+"<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label"+styleL+"\" style=\"width: 40px;\">"+SystemEnv.getHtmlNoteName(4197)+"</span>"  //颜色：
						+"<input class=\"MADChart2_Text\" id=\"title_color_"+theId+"\" type=\"text\" style=\"width: 65px;\"/>"
					
						+"<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label"+styleL+"\" style=\"width: 40px;\">"+SystemEnv.getHtmlNoteName(4198)+"</span>"  //大小：
						+"<input class=\"MADChart2_Text\" id=\"title_fontsize_"+theId+"\" type=\"text\" style=\"width: 36px;\"/>&nbsp;PX"
					+"</div>"
					+"<div>"
						+"<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4199)+"</span>"  //是否粗体：
						+"<input id=\"title_fontweight_"+theId+"\" type=\"checkbox\" value=\"bold\"/>"
					+"</div>"
				+"</div>"
				+ "<div id=\"MADChart2_LineInfoTitle\" class=\"MADChart2_Title\" style=\"position: relative;\">"
					+ SystemEnv.getHtmlNoteName(4232)  //线条信息
				+ "</div>"
				+"<div id=\"MADChart2_LineInfoContent\" class=\"MADChart2_BaseInfo\">"
					+"<div id=\"MADChart2_LineSizeContent\">"
						+ "<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label"+styleL+"\" style=\"width:72px;\">"+SystemEnv.getHtmlNoteName(4233)+"</span>"  //线条大小：
						+ "<input class=\"MADChart2_lineBG\" id=\"line_size_"+theId+"\" type=\"text\" style=\"width: 65px;border: 1px solid #ccc;height:20px;padding-left:3px;\"/>"
						+ "<span id=\"MADChart2_Line_Size_Tip\" style=\"margin-left:5px;\">"+SystemEnv.getHtmlNoteName(4234)+"</span>"  //提示:线条大小默认为5
					+"</div>"
					
					+"<div id=\"MADChart2_LineBGColorContent\" style=\"display:none;\">"
						+ "<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label"+styleL+"\" style=\"width:72px;\">"+SystemEnv.getHtmlNoteName(4638)+"</span>"  //线条背景色：
						+ "<input class=\"MADChart2_lineBG\" id=\"lineBG_color_"+theId+"\" type=\"text\" style=\"width: 65px;border: 1px solid #ccc;height:20px;padding-left:3px;\"/>"
						+ "<button name=\"lineColorpick\" class=\"lineColorBox\" type=\"button\" title=\""+SystemEnv.getHtmlNoteName(4236)+"\" style=\"position:absolute;\"/>"  //取色器
					+"</div>"
				+"</div>"
				+ "<div class=\"MADChart2_Title\" style=\"position: relative;\">"
					+ SystemEnv.getHtmlNoteName(4237)  //线条渐变色
					+ "<div class=\"line_gradientColor_add\" onclick=\"MADChart2_AddColorItem('line','"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
				+ "</div>"
			
				+ "<div id=\"MADChart2_lineColorView\" class=\"MADChart2_ColorView\">"
					+ "<div class=\"chart2_linecolor_empty_Tip\">"+SystemEnv.getHtmlNoteName(4238)+"</div>"  //单击右上角的添加按钮以添加渐变色
					+ "<ul></ul>"
				+ "</div>"
				
				+ "<div id=\"MADChart2_shadowColorTitle\" class=\"MADChart2_Title\" style=\"position: relative;\">"
					+ SystemEnv.getHtmlNoteName(4239)  //阴影渐变色
					+ "<div class=\"shadow_gradientColor_add\" onclick=\"MADChart2_AddColorItem('shadow','"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
				+ "</div>"
		
				+ "<div id=\"MADChart2_shadowColorView\" class=\"MADChart2_ColorView\">"
					+ "<div class=\"chart2_shadowcolor_empty_Tip\">"+SystemEnv.getHtmlNoteName(4238)+"</div>"  //单击右上角的添加按钮以添加渐变色
					+ "<ul></ul>"
				+ "</div>"
				+"<div class=\"MADChart2_Title\">"
					+ SystemEnv.getHtmlNoteName(4200)  //图表数据来源
				+"</div>"
				+"<div class=\"MADChart2_DataSource\">"
					+"<div style=\"position: relative;padding-left: 72px;\">"
						+"<span class=\"MADChart2_DataSource_Label MADChart2_DataSource_Label"+styleL+"\" style=\"position: absolute;top: 3px;left: 0px;\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源： 
						+"<select class=\"MADChart2_Select\" id=\"datasource_"+theId+"\">"
						+"  <option value=\"\">(local)</option>"
						+"</select>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADChart2_BaseInfo\">"
					+"<div style=\"position: relative;padding-left: 60px;\">"
						+"<span class=\"MADChart2_BaseInfo_Label MADChart2_BaseInfo_Label"+styleL+"\" style=\"position: absolute;top: 3px;left: 0px;\">SQL：</span>"
						+"<textarea class=\"MADChart2_Textarea\" id=\"sql_"+theId+"\" placeholder=\""+tip+"\"></textarea>"  //SQL格式说明请点击SQL帮助，此处可以使用页面跳转时传递过来的参数，即：{参数名称}
						+"<div style=\"padding-top: 3px;\"><a href=\"javascript:void(0);\" onclick=\"MADChart2_OpenSQLHelp();\">"+SystemEnv.getHtmlNoteName(4202)+"</a></div>"  //如何书写SQL？
					+"</div>"
				+"</div>"
				+"<div class=\"MADChart2_Bottom\"><div class=\"MADChart2_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Chart2.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	$("#charttype_" + theId).val(this.mecJson["charttype"]);
	$("#charttype_" + theId).change();
	
	$("#height_" + theId).val(this.mecJson["height"]);
	$("#width_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["width"]));
	$("#lineBG_color_" + theId).val(this.mecJson["linebgcolor"]);
	$("#line_size_" + theId).val(this.mecJson["linesize"]);
	
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
	MADChart2_setDataSourceHTML(theId,this.mecJson["datasource"]);

	var $sql = $("#sql_" + theId);
	$sql[0].value = this.mecJson["sql"];
	$("#valuesuffix_" + theId).val(this.mecJson["valuesuffix"]);
	
	$sql.focus(function(){
		$(this).addClass("MADChart2_Textarea_Focus");
	});
	$sql.blur(function(){
		$(this).removeClass("MADChart2_Textarea_Focus");
	});
	
	var $attrContainer = $("#MADChart2_" + theId);
	$(".lineColorBox", $attrContainer).css('background-color', this.mecJson["linebgcolor"]);
	$("#lineBG_color_" + theId).keyup(function(){
		$(".lineColorBox", $attrContainer).css('background-color', $(this).val().trim());
	});
	$(".lineColorBox", $attrContainer).colpick({
		colorScheme:'dark',
		layout:'rgbhex',
		color:'007aff',
		onSubmit:function(hsb,hex,rgb,el) {
			var colorValue = "#" + hex;
			$("#lineBG_color_"+theId).val(colorValue);
			$(el).css('background-color', colorValue);
			$(el).colpickHide();
		}
	});
	
	var line_gradient = this.mecJson["line_gradient"];
	var shadow_gradient = this.mecJson["shadow_gradient"];
	if(!line_gradient){
		line_gradient = [];
	}
	if(line_gradient.length == 0){
		$(".chart2_linecolor_empty_Tip", $attrContainer).show();
	}
	if(!shadow_gradient){
		shadow_gradient = [];
	}
	if(shadow_gradient.length == 0){
		$(".chart2_shadowcolor_empty_Tip", $attrContainer).show();
	}
	var lg_length = line_gradient.length;
	var sd_length = shadow_gradient.length;
	for(var i = 0; i < lg_length; i++){
		MADChart2_AddColorItem("line", theId, line_gradient[i]);
	}
	for(var i = 0; i < sd_length; i++){
		MADChart2_AddColorItem("shadow", theId, shadow_gradient[i]);
	}
	
	var $c_li = $(".MADChart2_ColorView > ul > li", $attrContainer);
	$c_li.each(function(){
		MADChart2_bindEventOnCLi(this);
	});
	
	$("#MADChart2_"+theId).jNice();
	$("#MADChart2_"+theId + " .MADChart2_ColorView > ul").sortable({
		revert: false,
		axis: "y",
		items: "li",
		handle: ".bemove"
	});
};

/*获取JSON*/
MEC_NS.Chart2.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADChart2_"+theId);
	if($attrContainer.length > 0){
		var charttype = $("#charttype_" + theId).val();
		var height = $("#height_" + theId).val().trim();
		var width = $("#width_" + theId).val().trim();
		var linebgcolor = $("#lineBG_color_" + theId).val().trim();
		var linesize = $("#line_size_" + theId).val().trim();
		var lazyLoad = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";
		
		var title = $("#title_" + theId).val();
		var title_font = $("#title_font_" + theId).val();
		var title_color = $("#title_color_" + theId).val();
		var title_fontsize = $("#title_fontsize_" + theId).val();
		var title_fontweight = $("#title_fontweight_" + theId).is(':checked') ? "bold" : "normal";
		var datasource = $("#datasource_" + theId).val();
		var sql = $("#sql_" + theId).val();
		var valuesuffix = $("#valuesuffix_" + theId).val();
		
		var line_gradient = [];
		var shadow_gradient = [];
		var $line_li = $("#MADChart2_lineColorView > ul > li", $attrContainer);
		$line_li.each(function(){
			var offset = $("input[name=offset]", $(this)).val().trim();
			var stopColor = $("input[name=stopColor]", $(this)).val().trim();
			line_gradient.push({
				"offset"     : offset, 
				"stop-color" : stopColor
			});
		});
		$shadow_li = $("#MADChart2_shadowColorView > ul > li", $attrContainer);
		$shadow_li.each(function(){
			var offset = $("input[name=offset]", $(this)).val().trim();
			var stopColor = $("input[name=stopColor]", $(this)).val().trim();
			var stopOpacity = $("input[name=stopOpacity]", $(this)).val().trim();
			shadow_gradient.push({
				"offset"       : offset, 
				"stop-color"   : stopColor,
				"stop-opacity" : stopOpacity
			});
		});
		this.mecJson["line_gradient"] = line_gradient;
		this.mecJson["shadow_gradient"] = shadow_gradient;
		
		this.mecJson["charttype"] = charttype;
		this.mecJson["height"] = height;
		this.mecJson["width"] = width;
		this.mecJson["linebgcolor"] = linebgcolor;
		this.mecJson["linesize"] = linesize;
		this.mecJson["lazyLoad"] = lazyLoad;
		this.mecJson["title"] = title;
		this.mecJson["title_font"] = title_font;
		this.mecJson["title_color"] = title_color;
		this.mecJson["title_fontsize"] = title_fontsize;
		this.mecJson["title_fontweight"] = title_fontweight;
		this.mecJson["datasource"] = datasource;
		this.mecJson["sql"] = sql;
	}
	return this.mecJson;
};

MEC_NS.Chart2.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["charttype"] = "LineGraph";
	defMecJson["height"] = "";
	defMecJson["linebgcolor"] = "#24303a";
	defMecJson["linesize"] = "";
	
	line_gradient = [];
	line_gradient.push({"offset":"0", "stop-color":"#954ce9"});
	line_gradient.push({"offset":"1", "stop-color":"#24c1ed"});
	defMecJson["line_gradient"] = line_gradient;
	
	shadow_gradient = [];
	shadow_gradient.push({"offset":"0", "stop-color":"rgba(149, 76, 233, 1)", "stop-opacity":"0.07"});
	shadow_gradient.push({"offset":"0.5", "stop-color":"rgba(149, 76, 233, 1)", "stop-opacity":"0.13"});
	shadow_gradient.push({"offset":"1", "stop-color":"rgba(149, 76, 233, 1)", "stop-opacity":"0"});
	defMecJson["shadow_gradient"] = shadow_gradient;
	
	defMecJson["title"] = "";
	defMecJson["title_font"] = "Verdana";
	defMecJson["title_color"] = "black";
	defMecJson["title_fontsize"] = "30";
	defMecJson["title_fontweight"] = "bold";
	
	defMecJson["datasource"] = "";
	defMecJson["sql"] = "";
	defMecJson["valuesuffix"] = "";
	
	return defMecJson;
};

function MADChart2_OpenSQLHelp(){
	var url = "/mobilemode/chart2SQLHelp.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 570;//定义长度
	dlg.Height = 555;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4204);  //SQL帮助
	dlg.show();
}

function MADChart2_setDataSourceHTML(mec_id,val){
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

function MADChart2_ChangeType(mec_id, o){
	var $attrContainer = $("#MADChart2_" + mec_id);
	var val = $(o).val();
	if(val == "LineGraph"){
		$("#height_" + mec_id).keyup(function(){
			var height = parseInt($(this).val());
			$("#width_" + mec_id).val(height * 2);
		});
		$("#MADChart2_Line_Size_Tip", $attrContainer).html(SystemEnv.getHtmlNoteName(4240)).show();  //提示:线条大小默认为1.5
		$("#MADChart2_Tip", $attrContainer).show();
		$("#MADChart2_PercentViewTitle", $attrContainer).hide();
		$("#MADChart2_PercentViewContent", $attrContainer).hide();
		$("#MADChart2_shadowColorView", $attrContainer).show();
		$("#MADChart2_shadowColorTitle", $attrContainer).show();
		
	}else{
		$("#MADChart2_Line_Size_Tip", $attrContainer).html(SystemEnv.getHtmlNoteName(4234)).show();  //提示:线条大小默认为5
		$("#MADChart2_LineSizeContent", $attrContainer).show();
		$("#MADChart2_Tip", $attrContainer).hide();
		$("#MADChart2_PercentViewTitle", $attrContainer).show();
		$("#MADChart2_PercentViewContent", $attrContainer).show();
		$("#MADChart2_shadowColorView", $attrContainer).hide();
		$("#MADChart2_shadowColorTitle", $attrContainer).hide();
		$("#MADChart2_LineBGColorContent", $attrContainer).show();
	}
}

function MADChart2_AddColorItem(type, mec_id, data){
	var $attrContainer = $("#MADChart2_" + mec_id);
	$(".chart2_" + type + "color_empty_Tip", $attrContainer).hide();
	
	var offset = "";
	var stopColor = "";
	var stopOpacity = "";
	if(data){
		offset = Mec_FiexdUndefinedVal(data["offset"]);
		stopColor = Mec_FiexdUndefinedVal(data["stop-color"]);
		stopOpacity = Mec_FiexdUndefinedVal(data["stop-opacity"]);
	}
	
	var $ul = $("#MADChart2_"+type+"ColorView > ul", $attrContainer);
	var $li = $("<li class=\"c_li\"></li>");
	var htm = "<table>";
	htm += "<tbody>";
	htm += "<tr>";
		htm += "<td class=\"bemove\" width=\"20px\"></td>";
	    htm += "<td width=\"105px\" valign=\"middle\">";
	    	htm += "<input name=\"offset\" type=\"text\" title=\""+SystemEnv.getHtmlNoteName(4241)+"\" style=\"width: 95px;\" value=\"" + offset + "\" placeholder=\""+SystemEnv.getHtmlNoteName(4241)+"\"/>";  //偏移值(0-1)
	    htm += "</td>";
		
		htm += "<td width=\"80px\">";
			htm += "<input name=\"stopColor\" type=\"text\" title=\""+SystemEnv.getHtmlNoteName(4587)+"\"  value=\"" + stopColor + "\" placeholder=\""+SystemEnv.getHtmlNoteName(4587)+"\"/>";  //渐变色
		htm += "</td>";
		
		htm += "<td width=\"30px\">";
			htm += "<button name=\"colorpick\" class=\"colorBox\" type=\"button\" title=\""+SystemEnv.getHtmlNoteName(4236)+"\" style=\"background-color:" + stopColor + ";\"/>";  //取色器
		htm += "</td>";
		
		if(type == "shadow"){
			htm += "<td width=\"75px\">";
				htm += "<input name=\"stopOpacity\" type=\"text\" value=\"" + stopOpacity + "\" style=\"margin-left:5px;\" title=\""+SystemEnv.getHtmlNoteName(4243)+"(0-1)\" placeholder=\""+SystemEnv.getHtmlNoteName(4243)+"\"/>";  //透明度
			htm += "</td>";
		}
		
		htm += "<td align=\"right\">";
			htm += "<span class=\"inparam_btn_del\" title=\""+SystemEnv.getHtmlNoteName(3519)+"\" onclick=\"MADChart2_deleteOneItemOnPage('" + mec_id + "',this, '" + type + "')\"></span>";  //删除
		htm += "</td>";
		
	htm += "</tr>";
	htm += "</tbody>";
	htm += "</table>";
	$($li.html(htm));
	$ul.append($li);
	MADChart2_bindEventOnCLi($li);
}

function MADChart2_bindEventOnCLi(obj){
	var $li = $(obj);
	
	$(".colorBox", $li).colpick({
		colorScheme:'dark',
		layout:'rgbhex',
		color:'007aff',
		onSubmit:function(hsb,hex,rgb,el) {
			var eleId = $(el).attr("id");
			var colorValue = "#" + hex;
			$("input[name=stopColor]", $li).val(colorValue);
			$(el).css('background-color', colorValue);
			$(el).colpickHide();
		}
	});
	
	var $stopColor = $("input[name=stopColor]", $li);
	$stopColor.on("keyup", function(){
		var stopColor = $("input[name=stopColor]", $li).val().trim();
		$("button[name=colorpick]", $li).css("background-color", stopColor);
	});
}

function MADChart2_deleteOneItemOnPage(mec_id, obj, type){
	var msg = SystemEnv.getHtmlNoteName(4244);  //确定删除?
	if(!confirm(msg)){
		return;
	}
	$(obj).closest(".c_li").remove();
	var $attrContainer = $("#MADChart2_" + mec_id);
	if($("#MADChart2_"+type+"ColorView > ul > li", $attrContainer).length == 0){
		$(".chart2_" + type + "color_empty_Tip").show();
	}
}