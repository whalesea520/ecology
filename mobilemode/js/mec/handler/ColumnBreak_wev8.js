if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.ColumnBreak = function(typeTmp, idTmp, mecJsonTmp){
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
MEC_NS.ColumnBreak.prototype.getID = function(){
	return this.id;
};

MEC_NS.ColumnBreak.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.ColumnBreak.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	htmTemplate = htmTemplate.replace(/\${theId}/g, theId);
	
	var fontColor = this.mecJson["fontColor"];
	var fontSize = this.mecJson["fontSize"];
	var inBold = Mec_FiexdUndefinedVal(this.mecJson["inBold"]) == "1";
	var numDatasource = this.mecJson["numDatasource"];
	var content = this.mecJson["content"];
	
	htmTemplate = htmTemplate.replace("${fontColor}", fontColor);
	
	var regWholeNumber = new RegExp("^\\d+$");
	var regDecimal = new RegExp("^\\d+(\\.\\d+)?$");
	if(regWholeNumber.test(fontSize) || regDecimal.test(fontSize)){
		fontSize = fontSize + "px";
	}
	
	htmTemplate = htmTemplate.replace("${fontSize}", fontSize);
	var fontweight = inBold ? "bold" : "normal";
	htmTemplate = htmTemplate.replace("${fontweight}", fontweight);
	
	if($.trim(content) == ""){
		content = SystemEnv.getHtmlNoteName(4465);  //标题文字
	}else{
		if($.trim(content).toLowerCase().indexOf("select ") == 0){
			
			var regexp = /\{(.*)\}/;
			if(regexp.test(content)){
				var htm = "<div class=\"Design_ColumnBreak_Tip\">"+SystemEnv.getHtmlNoteName(4275)+"</div>";  //SQL中包含自定义变量，预览时显示
				return htm;
			}
			
			content = $m_encrypt(content);// 系统安全编码
			if(content == ""){// 系统安全关键字验证不通过
				var htm = "<div class=\"Design_ColumnBreak_Tip\">"+SystemEnv.getHtmlNoteName(4207)+"</div>";  //数据来源SQL未通过系统安全测试，请检查关键字
				return htm;
			}
			
			var flag;
			MADCB_DataGet(theId, numDatasource, content, function(status,num){
				if(status == "0"){
					flag = 0;
				}else if(status == "-1"){
					flag = -1;
				}else if(status == "2"){
					flag = 2;
				}else if(status == "1"){
					content = num;
				}
				
			});
			
			if(flag==0){
				var htm = "<div class=\"Design_ColumnBreak_Tip\">"+SystemEnv.getHtmlNoteName(4208)+"</div>";  //查询数据来源SQL时出现错误，请检查SQL是否拼写正确
				return htm;
			}else if(flag==-1) {
				var htm = "<div class=\"Design_ColumnBreak_Tip\">"+SystemEnv.getHtmlNoteName(4276)+"</div>";  //查询数据来源SQL时出现异常
				return htm;
			}else if(flag==2) {
				var htm = "<div class=\"Design_ColumnBreak_Tip\">"+SystemEnv.getHtmlNoteName(4466)+"</div>";  //查询到的数据为空或者没有数据记录
				return htm;
			}
			
		}
	}
	htmTemplate = htmTemplate.replace("${content}", content);
	
	var htm = htmTemplate;
	return htm;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.ColumnBreak.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	var $column_break = $("#NMEC_" + theId);
	var $left_line = $(".left_line", $column_break);
	var $middle_content = $(".middle_content", $column_break);
	var $right_line = $(".right_line", $column_break);
	
	var scrollWidth = $("#homepageContainer").width();
	var displayStyle = this.mecJson["displayStyle"];
	if(displayStyle == "1"){
		$column_break.removeClass("column_break_midStyle");
		var leftLineWidth = $left_line.width();
		var middleContentWidth = $middle_content.width();
		var conPaddingLeft = $middle_content.css('padding-left');
		var conPaddingRight = $middle_content.css('padding-right');
		var rightLineWidth = scrollWidth - leftLineWidth - middleContentWidth - conPaddingLeft.substring(0, conPaddingLeft.length-2) - conPaddingRight.substring(0, conPaddingRight.length-2);
		$right_line.width(rightLineWidth + "px");
	}else if(displayStyle == "2"){
		$column_break.addClass("column_break_midStyle");
		var middleContentWidth = $middle_content.width();
		var conPaddingLeft = $middle_content.css('padding-left');
		var conPaddingRight = $middle_content.css('padding-right');
		var lineWidth = (scrollWidth - middleContentWidth - conPaddingLeft.substring(0, conPaddingLeft.length-2) - conPaddingRight.substring(0, conPaddingRight.length-2))/2;
		$left_line.width(lineWidth + "px");
		$right_line.width(lineWidth + "px");
		$middle_content.css("left", lineWidth + "px");
	}
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.ColumnBreak.prototype.getAttrDlgHtml = function(){
	
	var styleL = "_style" + _userLanguage;
	var tip = "";
	if(_userLanguage=="8"){
		tip = "Please enter the title text or SQL statement here, such as: name from table where id={id} select, where you can use the page Jump to pass the parameters, namely: {parameter name}";
	}else if(_userLanguage=="9"){
		tip = "請在此處輸入 标題文字 或者 SQL語句 ，如：select name from table where id={id}，此處可以使用頁面跳轉時傳遞過來的參數，即：{參數名稱}";
	}else{
		tip = "请在此处输入 标题文字 或者 SQL语句 ，如：select name from table where id={id}，此处可以使用页面跳转时传递过来的参数，即：{参数名称}";
	}

	var theId = this.id;
	
	var htm = "<div id=\"MADCB_"+theId+"\">"
				
				+ "<div class=\"MADCB_BaseInfomation\">"+SystemEnv.getHtmlNoteName(4467)+"</div>"  //分栏信息
				
				+ "<div class=\"MADCB_BaseInfo\">"
					
					+ "<div class=\"MADCB_CommonContent\">"
						+"<div class=\"MADCB_DataSource\">"
							+"<span class=\"MADCB_DataSource_Label\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"   //数据源：
							+"<select class=\"MADCB_Select\" id=\"NumDatasource_"+theId+"\">"
								+"  <option value=\"\">(local)</option>"
							+"</select>"
						+"</div>"
						+ "<textarea id=\"Content_"+theId+"\" class=\"MADCB_Textarea\" placeholder=\""+tip+"\"></textarea>"  //请在此处输入 标题文字 或者 SQL语句 ，如：select name from table where id={id}，此处可以使用页面跳转时传递过来的参数，即：{参数名称}
					+ "</div>"
					+"<div class=\"MADCB_BGColorContent\">"
						+ "<span class=\"MADCB_BaseInfo_Label MADCB_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4468)+"</span>"  //字体颜色：
						+ "<input class=\"MADCB_Text\" id=\"FontColor_"+theId+"\" type=\"text\"/>"
						+ "<button class=\"FontColorBox\" type=\"button\" title=\""+SystemEnv.getHtmlNoteName(4236)+"\"/>"  //取色器
					+"</div>"
					+"<div class=\"MADCB_CommonContent\">"
						+ "<span class=\"MADCB_BaseInfo_Label MADCB_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4469)+"</span>"  //字体大小：
						+ "<input class=\"MADCB_Text\" id=\"FontSize_"+theId+"\" type=\"text\"/>"
						+ "<span class=\"MADCB_Tip\">"+SystemEnv.getHtmlNoteName(4470)+"</span>"  //提示：字体大小默认为14px
					+"</div>"
					+"<div class=\"MADCB_CommonContent\">"
						+ "<span class=\"MADCB_BaseInfo_Label MADCB_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4637)+"</span>"  //是否加粗：
						+ "<input type=\"checkbox\" id=\"inBold_"+theId+"\"/>"
					+"</div>"
					+"<div class=\"MADCB_CommonContent\"  style=\"height: 80px;\">"
						+ "<span class=\"MADCB_BaseInfo_Label MADCB_BaseInfo_Label"+styleL+"\" style=\"float: left;\">"+SystemEnv.getHtmlNoteName(4472)+"</span>"  //选择样式：
						+ "<span class=\"MADCB_ImgContainer\">"
							+ "<img class=\"MADCB_DisplayStyle\" id=\"leftStyle_"+theId+"\" value=\"1\" onclick=\"MADCB_ChangeStyle('1', '"+theId+"');\" src=\"/mobilemode/images/columnbreak_leftstyle_wev8.png\">"
							+ "<img class=\"MADCB_DisplayStyle\" id=\"midStyle_"+theId+"\" value=\"2\" onclick=\"MADCB_ChangeStyle('2', '"+theId+"');\" src=\"/mobilemode/images/columnbreak_midstyle_wev8.png\" style=\"margin-top:5px;\">"
						+ "</span>"
					+"</div>"
						
				+ "</div>"
				+ "<div class=\"MADCB_Bottom\"><div class=\"MADCB_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.ColumnBreak.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var $attrContainer = $("#MADCB_" + theId);
	
	$("#FontColor_" + theId).val(this.mecJson["fontColor"]);
	$(".FontColorBox", $attrContainer).css('background-color', this.mecJson["fontColor"]);
	$("#FontColor_" + theId).keyup(function(){
		$(".FontColorBox", $attrContainer).css('background-color', $(this).val().trim());
	});
	$(".FontColorBox", $attrContainer).colpick({
		colorScheme:'dark',
		layout:'rgbhex',
		color:'007aff',
		onSubmit:function(hsb,hex,rgb,el) {
			var colorValue = "#" + hex;
			$("#FontColor_"+theId).val(colorValue);
			$(el).css('background-color', colorValue);
			$(el).colpickHide();
		}
	});
	
	$("#FontSize_" + theId).val(this.mecJson["fontSize"]);
	
	var inBold = Mec_FiexdUndefinedVal(this.mecJson["inBold"]);
	if(inBold == "1"){
		$("#inBold_"+theId).attr("checked","checked");
	}

	//动态获取数据源的值，并给数据源添加HTML
	$("#NumDatasource_" + theId).val(this.mecJson["numDatasource"]);
	MADCB_setDataSourceHTML("NumDatasource_" + theId,this.mecJson["numDatasource"]);
	
	$("#Content_" + theId).val(this.mecJson["content"]);
	
	MADCB_ChangeStyle(this.mecJson["displayStyle"], theId)
	
	$("#MADCB_"+theId).jNice();
};

/*获取JSON*/
MEC_NS.ColumnBreak.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADCB_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["fontColor"] = $("#FontColor_" + theId).val();
		this.mecJson["fontSize"] = $("#FontSize_" + theId).val();
		this.mecJson["inBold"] = $("#inBold_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["numDatasource"] = $("#NumDatasource_" + theId).val();
		this.mecJson["content"] = $("#Content_" + theId).val();
		this.mecJson["displayStyle"] = $(".img_sel", $attrContainer).attr("value");
	}
	return this.mecJson;
};

MEC_NS.ColumnBreak.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["fontColor"] = "#333";
	defMecJson["fontSize"] = "14px";
	defMecJson["inBold"] = "0";
	defMecJson["numDatasource"] = "";
	defMecJson["content"] = "";
	defMecJson["displayStyle"] = "1";
	
	return defMecJson;
};

function MADCB_setDataSourceHTML(datasourceid,val){
	var $MADCB_DataSource = $("#" + datasourceid);
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
			$MADCB_DataSource.append(dataSourceSelectHtml);
		}
	});
}

function MADCB_DataGet(theId, datasource, sql, fn){
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "&sql="+encodeURIComponent(sql));
	$.ajax({
		type:"POST",
		async:false,
		url:url,
		data:{action:"getDataBySQLWithColumnBreak",datasource:datasource},
		success : function (responseText){
			var jObj = $.parseJSON(responseText);
			var status = jObj["status"];
			var num = jObj["num"];
			fn.call(this, status, num);
		}
	});
}

function MADCB_ChangeStyle(objV, mec_id){
	if(objV == "1"){
		if(!$("#leftStyle_" + mec_id).hasClass("img_sel")){
			$("#leftStyle_" + mec_id).addClass("img_sel");
			$("#midStyle_" + mec_id).removeClass("img_sel");
		}
	}else if(objV == "2"){
		if(!$("#midStyle_" + mec_id).hasClass("img_sel")){
			$("#midStyle_" + mec_id).addClass("img_sel");
			$("#leftStyle_" + mec_id).removeClass("img_sel");
		}
	}
}