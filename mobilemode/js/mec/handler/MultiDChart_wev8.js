if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.MultiDChart = function(type, id, mecJson){
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
MEC_NS.MultiDChart.prototype.getID = function(){
	return this.id;
};

MEC_NS.MultiDChart.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.MultiDChart.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	var width = $("#MADMDC_"+theId).width();
	if(parseFloat(this.mecJson["width"]) > 0){
		width = this.mecJson["width"];
	}
	var height = 400;
	if(parseFloat(this.mecJson["height"]) > 0){
		height = this.mecJson["height"];
	}
	htmTemplate = htmTemplate.replace("${theId}", theId).replace("${width}", width).replace("${height}", height);
	return htmTemplate;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.MultiDChart.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	_MEC_ChartWidth = $("#content_editor").width()-4;
	chart_run_mode = 0;
	
	//var p = this.mecJson;
	var p = {};
	this.mecJson["id"] = theId;
	$.extend(p,this.mecJson);
	p['title'] = MLanguage.parse(p['title']||'');
	for(var i in p.tabSourceMaps){
		p.tabSourceMaps[i]['tabName'] = MLanguage.parse(p.tabSourceMaps[i]['tabName']||'');
	}
	
	var chartMLJson = {};
	chartMLJson['4205'] = SystemEnv.getHtmlNoteName(4205);//图表信息设置不完整，未配置数据来源SQL
	chartMLJson['4206'] = SystemEnv.getHtmlNoteName(4206);//SQL中可能包含待解析的参数变量，需运行时显示
	chartMLJson['4207'] = SystemEnv.getHtmlNoteName(4207);//数据来源SQL未通过系统安全测试，请检查关键字
	chartMLJson['4208'] = SystemEnv.getHtmlNoteName(4208);//查询数据来源SQL时出现错误，请检查SQL是否拼写正确
	chartMLJson['4209'] = SystemEnv.getHtmlNoteName(4209);//加载图表时出现错误
	chartMLJson['5202'] = SystemEnv.getHtmlNoteName(5202);//数据来源(输入名称)不能为空
	
	p["multiLJson"] = chartMLJson;
	//p["id"] = theId;
	eval("BuildChart_ColumnMulti3D(p)");
	$("#multiDChartContainer_"+theId).css("overflow-x","hidden");
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.MultiDChart.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADMDC_"+theId+"\" class=\"MADMDC_Container\">"
				+"<div class=\"MADMDC_Title\">"
					+SystemEnv.getHtmlNoteName(4184) //图表基本信息
				+"</div>"
				+"<div class=\"MADMDC_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADMDC_BaseInfo_Label\">"+SystemEnv.getHtmlNoteName(4191)+"</span>"//宽度：
						+"<input class=\"MADMDC_Text\" id=\"width_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4192)+"\"/>"////如：600，此处缺省则为页面宽度
					+"</div>"
					+"<div>"
						+"<span class=\"MADMDC_BaseInfo_Label\">"+SystemEnv.getHtmlNoteName(4128)+"</span>"//高度：
						+"<input class=\"MADMDC_Text\" id=\"height_"+theId+"\" type=\"text\" placeholder=\"\"/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADMDC_BaseInfo_Label\">"+SystemEnv.getHtmlNoteName(4129)+"</span>"//延迟加载：
						+"<input type=\"checkbox\" id=\"lazyLoad_"+theId+"\"/>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADMDC_Title\">"
					+SystemEnv.getHtmlNoteName(4195)  //标题信息
				+"</div>"
				+"<div class=\"MADMDC_BaseInfo\">"
					+"<div>"
						+"<span class=\"MADMDC_BaseInfo_Label\">"+SystemEnv.getHtmlNoteName(3978)+"</span>"//标题：
						+"<input class=\"MADMDC_Text\" id=\"title_"+theId+"\" type=\"text\" data-multi=false/>"
					+"</div>"
					+"<div>"
						+"<span class=\"MADMDC_BaseInfo_Label\">"+SystemEnv.getHtmlNoteName(4196)+"</span>"  //字体：
						+"<input class=\"MADMDC_Text\" id=\"title_font_"+theId+"\" type=\"text\" style=\"width: 65px;\"/>"
						
						+"<span class=\"MADMDC_BaseInfo_Label\" style=\"width: 40px;\">"+SystemEnv.getHtmlNoteName(4197)+"</span>"  //颜色：
						+"<input class=\"MADMDC_Text\" id=\"title_color_"+theId+"\" type=\"text\" style=\"width: 65px;\"/>"
						
						+"<span class=\"MADMDC_BaseInfo_Label\" style=\"width: 40px;\">"+SystemEnv.getHtmlNoteName(4198)+"</span>"  //大小：
						+"<input class=\"MADMDC_Text\" id=\"title_fontsize_"+theId+"\" type=\"text\" style=\"width: 36px;\"/>&nbsp;PX"
					+"</div>"
					+"<div>"
						+"<span class=\"MADMDC_BaseInfo_Label\">"+SystemEnv.getHtmlNoteName(4199)+"</span>"  //是否粗体：
						+"<input id=\"title_fontweight_"+theId+"\" type=\"checkbox\" value=\"bold\"/>"
					+"</div>"
				+"</div>"
				+"<div class=\"MADMDC_Title\">"
					+SystemEnv.getHtmlNoteName(4200) //图表数据来源
					+ "<div class=\"tab_root_add\" onclick=\"MADMDC_CreateTabCustomdetail('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4943)+"</div>"//添加来源
				+"</div>"
				+ "<div class=\"MADMDC_Customdetail\">"
					+ "<ul class=\"MADMDC_Customdetail_Name\"></ul>"
				+ "</div>"
				+"<div class=\"MADMDC_Bottom\"><div class=\"MADMDC_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.MultiDChart.prototype.afterAttrDlgBuild = function(){

	var theId = this.id;
	$("#width_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["width"]));
	$("#height_" + theId).val(this.mecJson["height"]);
	
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
	
	var tabSourceMaps = this.mecJson["tabSourceMaps"];
	if(!tabSourceMaps){
		tabSourceMaps = [];
	}
	for(var i = 0; tabSourceMaps && i < tabSourceMaps.length; i++){
		var tabSourceMap = tabSourceMaps[i];
		var tabid = tabSourceMap["tabID"];
		MADMDC_addDatasourceToPage(theId, tabSourceMap);
		$("#datasql_"+tabid).val(tabSourceMap["datasql"]);
	}
	$("#MADMDC_"+theId).jNice();
	MLanguage({
		container: $("#MADMDC_"+theId + " .MADMDC_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.MultiDChart.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADMDC_"+theId);
	if($attrContainer.length > 0){
		var width = $("#width_" + theId).val();
		var height = $("#height_" + theId).val();
		var lazyLoad = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";
		var title = MLanguage.getValue($("#title_" + theId))|| $("#title_" + theId).val();
		var title_font = $("#title_font_" + theId).val();
		var title_color = $("#title_color_" + theId).val();
		var title_fontsize = $("#title_fontsize_" + theId).val();
		var title_fontweight = $("#title_fontweight_" + theId).is(':checked') ? "bold" : "normal";
		
		
		var tabSourceMaps = [];
		var $tabLi = $(".MADMDC_Customdetail_Name .tabLi", $attrContainer);
		$tabLi.each(function(){
			var tabID = $(this).attr("detailid");
			var tabName = MLanguage.getValue($("#tabName_"+tabID))|| Mec_FiexdUndefinedVal($("#tabName_"+tabID).val());
			var datasource = $("#datasource_"+tabID).val();
			var datasql = $("#datasql_" + tabID).val();
			
			var t = {};
			t["tabID"] = tabID;
			t["tabName"] = tabName;
			t["datasource"] = datasource;
			t["datasql"] = datasql;
			tabSourceMaps.push(t);
		});
		
		this.mecJson["width"] = width;
		this.mecJson["height"] = height;
		this.mecJson["lazyLoad"] = lazyLoad;
		this.mecJson["title"] = title;
		this.mecJson["title_font"] = title_font;
		this.mecJson["title_color"] = title_color;
		this.mecJson["title_fontsize"] = title_fontsize;
		this.mecJson["title_fontweight"] = title_fontweight;
		this.mecJson["tabSourceMaps"] = tabSourceMaps;
	}
	return this.mecJson;
};

MEC_NS.MultiDChart.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["width"] = "";
	defMecJson["height"] = "350";
	
	defMecJson["title"] = "";
	defMecJson["title_font"] = "Verdana";
	defMecJson["title_color"] = "black";
	defMecJson["title_fontsize"] = "18";
	defMecJson["title_fontweight"] = "bold";
	
	return defMecJson;
};

function MADMDC_OpenSQLHelp(){
	var url = "/mobilemode/MultiDchartSQLHelp.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 540;//定义长度
	dlg.Height = 555;
	dlg.URL = url;
	dlg.Title = "SQL帮助";
	dlg.show();
}

function MADMDC_setDataSourceHTML(mec_id,tabID,val){
	var $MADL_DataSource = $("#datasource_" + tabID);
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

function MADMDC_CreateTabCustomdetail(mec_id){
	var result = {};
	var id = new UUID().toString();
	result["tabID"] = id;
	result["tabName"] = "";
	MADMDC_addDatasourceToPage(mec_id,result);
}

function MADMDC_addDatasourceToPage(mec_id, result){
	var $attrContainer = $("#MADMDC_"+mec_id);
	var $MADMDC_Customdetail = $(".MADMDC_Customdetail", $attrContainer);
	var $MADMDC_Customdetail_Name = $(".MADMDC_Customdetail_Name", $MADMDC_Customdetail);
	var $MADMDC_Customdetail_Content = $(".MADMDC_Customdetail_Content", $MADMDC_Customdetail);
	if($MADMDC_Customdetail_Content.length==0){
		$MADMDC_Customdetail_Content = $("<div class=\"MADMDC_Customdetail_Content\"></div>");
		$MADMDC_Customdetail.append($MADMDC_Customdetail_Content);
	}
	
	$(".tabLi", $MADMDC_Customdetail_Name).removeClass("selected");
	$MADMDC_Customdetail_Name.append("<li class=\"tabLi selected\" detailid=\""+result["tabID"]+"\"><input id=\"tabName_"+result["tabID"]+"\" class=\"MADMDC_TabName_Text\" onfocus=\"this.select();\" placeholder=\""+SystemEnv.getHtmlNoteName(3978)+"\" value=\""+result["tabName"]+"\" data-multi=false /><div class=\"delFlag\" onclick=\"MADMDC_DelTab('"+result["tabID"]+"','"+mec_id+"');\"></div></li>");
	
	$(".MADMDC_Customdetail_Content_Entry", $MADMDC_Customdetail_Content).removeClass("selected");
	var $Entry = $("<div class=\"MADMDC_Customdetail_Content_Entry  selected\" detailid=\""+result["tabID"]+"\"></div>");
	$Entry.append("<input type=\"hidden\" name=\"detailid\" value=\""+result["tabID"]+"\" />");
	var dSourceConfig = "<div class=\"MADMDC_dSConfigContainer\">"
					 	 	+"<div class=\"MADMDC_DataSource\">"
								+"<span class=\"MADMDC_DataSource_Label\" style=\"width:80px;text-align: center;\">"+SystemEnv.getHtmlNoteName(4201)+"</span>" //数据源：
								+"<select style=\"margin-left: 20px;\"class=\"MADMDC_Select\" id=\"datasource_"+result["tabID"]+"\">"
								+"  <option value=\"local\">(local)</option>"
								+"</select>"
							+"</div>"
							+"<div class=\"MADMDC_DataSql\">"
								+"<span class=\"MADMDC_DataSql_Label\">SQL：</span>"
								+"<textarea class=\"MADMDC_Textarea\" id=\"datasql_"+result["tabID"]+"\"></textarea>"
								+"<div style=\"padding-top: 3px;\"><a href=\"javascript:void(0);\" onclick=\"MADMDC_OpenSQLHelp();\">"+SystemEnv.getHtmlNoteName(4202)+"</a></div>"// //如何书写SQL？
							+"</div>";
	dSourceConfig += "</div>";					
	$Entry.append(dSourceConfig);
	$MADMDC_Customdetail_Content.append($Entry);
	MADMDC_setDataSourceHTML(mec_id,result["tabID"],Mec_FiexdUndefinedVal(result["datasource"]));
	
	$("li",$MADMDC_Customdetail_Name).click(function(){
		if(!$(this).hasClass("selected")){
			$(this).siblings(".selected").removeClass("selected");
			$(this).addClass("selected");
			var detailid = $(this).attr("detailid");
			var $Content = $(this).parent().next(".MADMDC_Customdetail_Content");
			$(".MADMDC_Customdetail_Content_Entry", $Content).removeClass("selected");
			$(".MADMDC_Customdetail_Content_Entry[detailid='"+detailid+"']", $Content).addClass("selected");
			
			$("#" + mec_id + " .tabTitle li[detailid='"+detailid+"']").trigger("click");
		}
	});
	MLanguage({
		container: $MADMDC_Customdetail_Name.find('li')
    });
}

function MADMDC_DelTab(tabID, mec_id){
	var msg = "确定删除吗？";
	if(!confirm(msg)){
		return;
	}
	
	var $attrContainer = $("#MADMDC_"+mec_id);
	$(".tabLi[detailid='"+tabID+"']", $attrContainer).remove();
	$(".MADMDC_Customdetail_Content_Entry[detailid='"+tabID+"']", $attrContainer).remove();
	
	if($(".tabLi", $attrContainer).length>0){
		$(".tabLi", $attrContainer)[0].click();
	}
}




