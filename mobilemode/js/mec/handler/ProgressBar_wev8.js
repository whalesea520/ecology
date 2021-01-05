if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.ProgressBar = function(typeTmp, idTmp, mecJsonTmp){
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
MEC_NS.ProgressBar.prototype.getID = function(){
	return this.id;
};

MEC_NS.ProgressBar.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.ProgressBar.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var numDatasource = this.mecJson["numDatasource"];
	var numParamer = this.mecJson["numParamer"];
	var lineHeight = this.mecJson["lineHeight"];
	var fontColor = this.mecJson["fontColor"];
	var fontSize = this.mecJson["fontSize"];
	var bgcolor = this.mecJson["bgcolor"];
	
	var htmTemplate = getPluginContentTemplateById(this.type);
	htmTemplate = htmTemplate.replace(/\${theId}/g, theId);
	htmTemplate = htmTemplate.replace(/\${lineHeight}/g, lineHeight);
	htmTemplate = htmTemplate.replace("${fontColor}", fontColor);
	htmTemplate = htmTemplate.replace("${fontSize}", fontSize);
	htmTemplate = htmTemplate.replace("${bgcolor}", bgcolor);
	
	if($.trim(numParamer) == ""){
		var htm = "<div class=\"Design_ProgressBar_Tip\">"+SystemEnv.getHtmlNoteName(4449)+"</div>";  //信息设置不完整，未配置进度条数值
		return htm;
	}else{
		if($.trim(numParamer).toLowerCase().indexOf("select ") == 0){
			
			var regexp = /\{(.*)\}/;
			if(regexp.test(numParamer)){
				var htm = "<div class=\"Design_ProgressBar_Tip\">"+SystemEnv.getHtmlNoteName(4275)+"</div>";  //SQL中包含自定义变量，预览时显示
				return htm;
			}
			
			numParamer = $m_encrypt(numParamer);// 系统安全编码
			if(numParamer == ""){// 系统安全关键字验证不通过
				var htm = "<div class=\"Design_ProgressBar_Tip\">"+SystemEnv.getHtmlNoteName(4450)+"</div>";  //进度条数值来源SQL未通过系统安全测试，请检查关键字
				return htm;
			}
			
			var flag;
			MADFB_DataGet(theId, numDatasource, numParamer, function(status,num){
				if(status == "0"){
					flag = 0;
				}else if(status == "-1"){
					flag = -1;
				}
				
			});
			
			if(flag==0){
				var htm = "<div class=\"Design_ProgressBar_Tip\">"+SystemEnv.getHtmlNoteName(4451)+"</div>";  //查询进度条数值来源SQL时出现错误，请检查SQL是否拼写正确
				return htm;
			}else if(flag==-1) {
				var htm = "<div class=\"Design_ProgressBar_Tip\">"+SystemEnv.getHtmlNoteName(4452)+"</div>";  //查询进度条数值来源SQL时出现异常
				return htm;
			}
			
		}
	}
	
	var htm = htmTemplate;
	return htm;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.ProgressBar.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	var numDatasource = this.mecJson["numDatasource"];
	var numParamer = this.mecJson["numParamer"];
	var showNum = this.mecJson["showNum"] == "1";
	var percentAreaColor = this.mecJson["percentAreaColor"];
	var percentNum = 0;
	var numWidthDisplay = 0;
	
	if($.trim(numParamer) != ""){
		if($.trim(numParamer).toLowerCase().indexOf("select ") == 0){
			numParamer = $m_encrypt(numParamer);// 系统安全编码
			if(numParamer == ""){// 系统安全关键字验证不通过
				numParamer = 0;
			}else{
				MADFB_DataGet(theId, numDatasource, numParamer, function(status,num){
					if(status == "1"){
						numParamer = num;
					}else {
						numParamer = 0;
					}
					
				});
			}
		}else{
			var percentSign = numParamer.indexOf("%");
			if(percentSign > 0){
				numParamer = numParamer.substring(0, percentSign);
			}
		}

		var decimalPointSign = numParamer.toString().indexOf(".");
		if(decimalPointSign > 0){
			percentNum = Number(numParamer).toFixed(2);
		}else{
			percentNum = Number(numParamer);
		}
		
		numWidthDisplay = percentNum;
		
		if(percentNum < 0){
			percentNum = 0;
			numWidthDisplay = percentNum;
		}else if(percentNum > 100){
			percentNum = 100;
		}
	}else return;
	
	
	var areaColor = "";
	
	if(!percentAreaColor){
		percentAreaColor = [];
	}
	
	for(var i = 0; i < percentAreaColor.length; i++){
		var b_data = percentAreaColor[i];
		var startPercent = Number(b_data["startPercent"]);
		var endPercent = Number(b_data["endPercent"]);
		if(percentNum >= startPercent && percentNum <= endPercent){
			areaColor = b_data["areaColor"];
			break;
		}
	}
	
	Mobile_NS.initProgressBar(theId, numWidthDisplay, percentNum, areaColor, showNum);
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.ProgressBar.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var tip = "";
	if(_userLanguage=="8"){
		tip = "Please enter here a fixed value or a SQL statement used to return a value, such as: 80; SQL statement example: select num from table where id={id}. {ID} here is page jump pass over the parameters, namely, the parameters for the {name}";
	}else if(_userLanguage=="9"){
		tip = "請在此處輸入一個固定數值 或者 一段SQL語句用來返回一個數值，如：  80  ；SQL語句示例： select num from table where id={id}，此處{id}是頁面跳轉時傳遞過來的參數，即：{參數名稱}";
	}else{
		tip = "请在此处输入一个固定数值 或者 一段SQL语句用来返回一个数值，如：  80  ；SQL语句示例： select num from table where id={id}，此处{id}是页面跳转时传递过来的参数，即：{参数名称}";
	}

	
	var theId = this.id;
	
	var htm = "<div id=\"MADPB_"+theId+"\">"
				+ "<div class=\"MADPB_Title\">"+SystemEnv.getHtmlNoteName(4453)+"</div>"  //进度条数值
				+ "<div class=\"MADPB_BaseInfo\">"
					
					+ "<div class=\"MADPB_CommonContent\">"
						+"<div class=\"MADPB_DataSource\">"
							+"<span class=\"MADPB_DataSource_Label\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
							+"<select class=\"MADPB_Select\" id=\"NumDatasource_"+theId+"\">"
								+"  <option value=\"\">(local)</option>"
							+"</select>"
						+"</div>"
						+ "<textarea id=\"NumParamer_"+theId+"\" class=\"MADPB_Textarea\" placeholder=\""+tip+"\"></textarea>"  //请在此处输入一个固定数值 或者 一段SQL语句用来返回一个数值，如：  80  ；SQL语句示例： select num from table where id={id}，此处{id}是页面跳转时传递过来的参数，即：{参数名称}
					+ "</div>"
					
					+ "<div>"
						+ "<div class=\"progressbar_btn_title\">"
							+ SystemEnv.getHtmlNoteName(4454)  //进度条基本信息
						+ "</div>"
						
						+"<div class=\"MADPB_CommonContent\">"
							+ "<span class=\"MADPB_BaseInfo_Label MADPB_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4600)+"</span>"  //进度条高度：
							+ "<input class=\"MADPB_Text\" id=\"line_Height_"+theId+"\" type=\"text\"/>"
							+ "<span class=\"MADPB_Tip MADPB_Tip"+styleL+"\">"+SystemEnv.getHtmlNoteName(4456)+"</span>"  //提示：进度条高度默认为22px
						+"</div>"
						
						+"<div class=\"MADPB_CommonContent\">"
							+ "<span class=\"MADPB_BaseInfo_Label MADPB_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4601)+"</span>"  //显示百分比：
							+ "<input type=\"checkbox\" id=\"showNum_"+theId+"\" onclick=\"MADPB_ChangeRAT(this, '"+theId+"');\"/>"
						+"</div>"
						
						+"<div class=\"MADPB_FontColorContent MADPB_FontColorContent"+styleL+"\" id=\"MADPB_FontColorContent_"+theId+"\">"
							+ "<span class=\"MADPB_BaseInfo_Label MADPB_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4602)+"</span>"  //百分比颜色：
							+ "<input class=\"MADPB_Text\" id=\"font_color_"+theId+"\" type=\"text\"/>"
							+ "<button name=\"FontColorpick\" class=\"FontColorBox\" type=\"button\" title=\""+SystemEnv.getHtmlNoteName(4236)+"\"/>"  //取色器
						+"</div>"
						
						+"<div class=\"MADPB_CommonContent\"  id=\"MADPB_FontSizeContent_"+theId+"\">"
							+ "<span class=\"MADPB_BaseInfo_Label MADPB_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4603)+"</span>"  //百分比大小：
							+ "<input class=\"MADPB_Text\" id=\"font_Size_"+theId+"\" type=\"text\"/>"
							+ "<span class=\"MADPB_Tip MADPB_Tip"+styleL+"\">"+SystemEnv.getHtmlNoteName(4460)+"</span>"  //提示：字体大小默认为12px
						+"</div>"
						
						+"<div class=\"MADPB_BGColorContent MADPB_BGColorContent"+styleL+"\">"
							+ "<span class=\"MADPB_BaseInfo_Label MADPB_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4636)+"</span>"  //进度条背景色：
							+ "<input class=\"MADPB_Text\" id=\"BG_color_"+theId+"\" type=\"text\"/>"
							+ "<button name=\"BGColorpick\" class=\"BGColorBox\" type=\"button\" title=\""+SystemEnv.getHtmlNoteName(4236)+"\"/>"  //取色器
						+"</div>"
						
					+ "</div>"
					
					+ "<div>"
						+ "<div class=\"progressbar_color_title\">"
							+ SystemEnv.getHtmlNoteName(4462)  //进度条颜色
							+ "<div class=\"progressbar_btn_add\" onclick=\"MADPB_AddColorItem('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
						+ "</div>"
						+ "<div class=\"progressbar_btn_content\">"
							+ "<div class=\"progressbar_btn_empty_tip\">"+SystemEnv.getHtmlNoteName(4463)+"</div>"  //单击右上角的添加按钮以添加百分比区域颜色
							+ "<ul></ul>"
						+ "</div>"
					+ "</div>"
						
				+ "</div>"
				+ "<div class=\"MADPB_Bottom\"><div class=\"MADPB_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.ProgressBar.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var $attrContainer = $("#MADPB_" + theId);
	
	//动态获取数据源的值，并给数据源添加HTML
	$("#NumDatasource_" + theId).val(this.mecJson["numDatasource"]);
	MADPB_setDataSourceHTML("NumDatasource_" + theId,this.mecJson["numDatasource"]);
	
	$("#NumParamer_" + theId).val(this.mecJson["numParamer"]);
	
	$("#line_Height_" + theId).val(this.mecJson["lineHeight"]);
	
	var showNum = Mec_FiexdUndefinedVal(this.mecJson["showNum"]);
	if(showNum == "1"){
		$("#showNum_"+theId).attr("checked","checked");
		$("#MADPB_FontColorContent_" + theId).show();
		$("#MADPB_FontSizeContent_" + theId).show();
	}else{
		$("#MADPB_FontColorContent_" + theId).hide();
		$("#MADPB_FontSizeContent_" + theId).hide();
	}
	
	$("#font_color_" + theId).val(this.mecJson["fontColor"]);
	$(".FontColorBox", $attrContainer).css('background-color', this.mecJson["fontColor"]);
	$("#font_color_" + theId).keyup(function(){
		$(".FontColorBox", $attrContainer).css('background-color', $(this).val().trim());
	});
	$(".FontColorBox", $attrContainer).colpick({
		colorScheme:'dark',
		layout:'rgbhex',
		color:'007aff',
		onSubmit:function(hsb,hex,rgb,el) {
			var colorValue = "#" + hex;
			$("#font_color_"+theId).val(colorValue);
			$(el).css('background-color', colorValue);
			$(el).colpickHide();
		}
	});
	
	$("#font_Size_" + theId).val(this.mecJson["fontSize"]);
	
	$("#BG_color_" + theId).val(this.mecJson["bgcolor"]);
	$(".BGColorBox", $attrContainer).css('background-color', this.mecJson["bgcolor"]);
	$("#BG_color_" + theId).keyup(function(){
		$(".BGColorBox", $attrContainer).css('background-color', $(this).val().trim());
	});
	$(".BGColorBox", $attrContainer).colpick({
		colorScheme:'dark',
		layout:'rgbhex',
		color:'007aff',
		onSubmit:function(hsb,hex,rgb,el) {
			var colorValue = "#" + hex;
			$("#BG_color_"+theId).val(colorValue);
			$(el).css('background-color', colorValue);
			$(el).colpickHide();
		}
	});
	
	var percentAreaColor = this.mecJson["percentAreaColor"];
	if(!percentAreaColor){
		percentAreaColor = [];
	}
	if(percentAreaColor.length == 0){
		$(".progressbar_btn_empty_tip", $attrContainer).show();
	}
	for(var i = 0; i < percentAreaColor.length; i++){
		MADPB_AddColorItem(theId, percentAreaColor[i]);
	}
	
	$("#MADPB_"+theId).jNice();
	$("#MADPB_"+theId + " .progressbar_btn_content > ul").sortable({
		revert: false,
		axis: "y",
		items: "li",
		handle: ".bemove"
	});
};

/*获取JSON*/
MEC_NS.ProgressBar.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADPB_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["numDatasource"] = $("#NumDatasource_" + theId).val();
		this.mecJson["numParamer"] = $("#NumParamer_" + theId).val();
		this.mecJson["bgcolor"] = $("#BG_color_" + theId).val();
		this.mecJson["lineHeight"] = $("#line_Height_" + theId).val();
		this.mecJson["showNum"] = $("#showNum_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["fontColor"] = $("#font_color_" + theId).val();
		this.mecJson["fontSize"] = $("#font_Size_" + theId).val();
		
		var percentAreaColor = [];
		var $line_li = $(".progressbar_btn_content > ul > li", $attrContainer);
		$line_li.each(function(){
			var startPercent = $("input[name=startPercent]", $(this)).val().trim();
			var endPercent = $("input[name=endPercent]", $(this)).val().trim();
			var areaColor = $("input[name=areaColor]", $(this)).val().trim();
			percentAreaColor.push({
				"startPercent"     : startPercent, 
				"endPercent" : endPercent,
				"areaColor" : areaColor
			});
		});
		this.mecJson["percentAreaColor"] = percentAreaColor;
	}
	return this.mecJson;
};

MEC_NS.ProgressBar.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["numDatasource"] = "";
	defMecJson["numParamer"] = "";
	defMecJson["lineHeight"] = "22px";
	defMecJson["showNum"] = "1";
	defMecJson["fontColor"] = "#FFFFFF";
	defMecJson["fontSize"] = "12px";
	defMecJson["bgcolor"] = "#DDD";
	defMecJson["percentAreaColor"] = [
	                                  {"startPercent" : 0,"endPercent" : 50,"areaColor" : "#F85333"},
	                                  {"startPercent" : 50,"endPercent" : 60,"areaColor" : "#4ED8F2"},
	                                  {"startPercent" : 60,"endPercent" : 100,"areaColor" : "#01D48F"},
	                                  ];
	
	return defMecJson;
};

function MADPB_setDataSourceHTML(datasourceid,val){
	var $MADPB_DataSource = $("#" + datasourceid);
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
			$MADPB_DataSource.append(dataSourceSelectHtml);
		}
	});
}

function MADPB_AddColorItem(mec_id, data){
	var $attrContainer = $("#MADPB_" + mec_id);
	$(".progressbar_btn_empty_tip", $attrContainer).hide();
	
	var startPercent = "";
	var endPercent = "";
	var areaColor = "";
	if(data){
		startPercent = Mec_FiexdUndefinedVal(data["startPercent"]);
		endPercent = Mec_FiexdUndefinedVal(data["endPercent"]);
		areaColor = Mec_FiexdUndefinedVal(data["areaColor"]);
	}
	
	var $ul = $(".progressbar_btn_content > ul", $attrContainer);
	var $li = $("<li class=\"c_li\"></li>");
	var htm = "<table>";
	htm += "<tbody>";
	htm += "<tr>";
		htm += "<td class=\"bemove\" width=\"20px\"></td>";
	    htm += "<td width=\"45px\" valign=\"middle\">";
	    	htm += "<input name=\"startPercent\" type=\"text\" title=\"\" style=\"width: 35px;\" value=\"" + startPercent + "\" placeholder=\"\"/>";
	    htm += "</td>";
	    
	    htm += "<td>-</td>";
	    
	    htm += "<td width=\"45px\" valign=\"middle\">";
	    	htm += "<input name=\"endPercent\" type=\"text\" title=\"\" style=\"width: 35px;\" value=\"" + endPercent + "\" placeholder=\"\"/>";
	    htm += "</td>";
	    
	    htm += "<td>%</td>";
		
		htm += "<td width=\"80px\">";
			htm += "<input name=\"areaColor\" type=\"text\" title=\"\"  value=\"" + areaColor + "\" placeholder=\""+SystemEnv.getHtmlNoteName(4464)+"\"/>";  //颜色
		htm += "</td>";
		
		htm += "<td width=\"30px\">";
			htm += "<button name=\"colorpick\" class=\"colorBox\" type=\"button\" title=\""+SystemEnv.getHtmlNoteName(4236)+"\" style=\"background-color:" + areaColor + ";\"/>";  //取色器
		htm += "</td>";
		
		htm += "<td align=\"right\">";
			htm += "<span class=\"pbparam_btn_del\" title=\""+SystemEnv.getHtmlNoteName(3519)+"\" onclick=\"MADPB_deleteOneItemOnPage('" + mec_id + "',this)\"></span>";  //删除
		htm += "</td>";
		
	htm += "</tr>";
	htm += "</tbody>";
	htm += "</table>";
	$($li.html(htm));
	$ul.append($li);
	MADPB_bindEventOnCLi($li);
}

function MADPB_bindEventOnCLi(obj){
	var $li = $(obj);
	
	$(".colorBox", $li).colpick({
		colorScheme:'dark',
		layout:'rgbhex',
		color:'007aff',
		onSubmit:function(hsb,hex,rgb,el) {
			var eleId = $(el).attr("id");
			var colorValue = "#" + hex;
			$("input[name=areaColor]", $li).val(colorValue);
			$(el).css('background-color', colorValue);
			$(el).colpickHide();
		}
	});
	
	var $areaColor = $("input[name=areaColor]", $li);
	$areaColor.on("keyup", function(){
		var areaColor = $("input[name=areaColor]", $li).val().trim();
		$("button[name=colorpick]", $li).css("background-color", areaColor);
	});
}

function MADPB_deleteOneItemOnPage(mec_id, obj){
	var msg = SystemEnv.getHtmlNoteName(4244);  //确定删除?
	if(!confirm(msg)){
		return;
	}
	$(obj).closest(".c_li").remove();
	var $attrContainer = $("#MADPB_" + mec_id);
	if($(".progressbar_btn_content > ul > li", $attrContainer).length == 0){
		$(".progressbar_btn_empty_tip").show();
	}
}

function MADFB_DataGet(theId, datasource, sql, fn){
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "&sql="+encodeURIComponent(sql));
	$.ajax({
		type:"POST",
		async:false,
		url:url,
		data:{action:"getDataBySQLWithProgressBar",datasource:datasource},
		success : function (responseText){
			var jObj = $.parseJSON(responseText);
			var status = jObj["status"];
			var num = jObj["num"];
			fn.call(this, status, num);
		}
	});
}

function MADPB_ChangeRAT(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(!cbObj.checked){
			$("#MADPB_FontColorContent_" + mec_id).hide();
			$("#MADPB_FontSizeContent_" + mec_id).hide();
		}else{
			$("#MADPB_FontColorContent_" + mec_id).show();
			$("#MADPB_FontSizeContent_" + mec_id).show();
		}
	},100);
}
