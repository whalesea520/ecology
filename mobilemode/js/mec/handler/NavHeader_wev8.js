if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.NavHeader = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = this.getDefaultMecJson();
	}
	this.mecJson = mecJson;
}

/*获取id。 必需的方法*/
MEC_NS.NavHeader.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.NavHeader.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	htmTemplate = htmTemplate.replace("${theId}", theId);
	
	var title = $.trim(Mec_FiexdUndefinedVal(this.mecJson["title"]));
	var smallTitle = $.trim(Mec_FiexdUndefinedVal(this.mecJson["smallTitle"]));
	
	if(title == ""){
		title = SystemEnv.getHtmlNoteName(4251);  //标题未设置
	}else{
		if(title.toLowerCase().indexOf("select ") == 0){
			title = SystemEnv.getHtmlNoteName(4252);  //SQL取值(运行时显示)
		}
	}
	
	if(smallTitle.toLowerCase().indexOf("select ") == 0){
		smallTitle = SystemEnv.getHtmlNoteName(4252);  //SQL取值(运行时显示)
	}
	
	htmTemplate = htmTemplate.replace("${title}", title);
	htmTemplate = htmTemplate.replace("${smallTitle}", smallTitle);
	
	var btn_datas = this.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
	}
	var hasBtn = btn_datas.length > 0;
	var navHeaderBtnDisplay = hasBtn ? "block" : "none";
	htmTemplate = htmTemplate.replace("${navHeaderBtnDisplay}", navHeaderBtnDisplay);
	
	var forBtnStart;
	if((forBtnStart = htmTemplate.indexOf("$mec_navHeader_btn_forstart$")) != -1){
		var forBtnEnd = htmTemplate.indexOf("$mec_navHeader_btn_forend$", forBtnStart);
		var forTemplate = htmTemplate.substring(forBtnStart, forBtnEnd + "$mec_navHeader_btn_forend$".length);
		var forContentTemplate = htmTemplate.substring(forBtnStart + "$mec_navHeader_btn_forstart$".length, forBtnEnd);
		var forHtml = "";
		
		for(var i = 0; i < btn_datas.length; i++){
			var b_data = btn_datas[i];
			var btnId = b_data["id"];
			var btnType = b_data["btnType"];
			if(btnType == "1"){
				var btnText = b_data["btnText"];
				var btnScript = "";
				forHtml += forContentTemplate.replace("${btnId}", btnId)
												.replace("${btnClass}", "btn")
												.replace("${btnText}", btnText)
												.replace("${btnScript}", btnScript);
			}else if(btnType == "2"){
				var iconpath = b_data["nhimg_item"]["iconpath"];
				if(iconpath == null || iconpath.length == 0){
					iconpath = "/mobilemode/images/homepage/homepage_left_10_wev8.png";
				}
				var btnScript = "";
				forHtml += forContentTemplate.replace("${btnId}", btnId)
												.replace("${btnClass}", "imgBtn")
												.replace("${btnText}", "<img src=\""+iconpath+"\">")
												.replace("${btnScript}", btnScript);
			}
		}
		
		htmTemplate = htmTemplate.replace(forTemplate, forHtml);
	}
	
	var htm = htmTemplate;
	return htm;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.NavHeader.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.NavHeader.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var tip = "";
	if(_userLanguage=="8"){
		tip = "Here can be a common text or a query of the SQL statement, such as: name from table where id={id} select, where you can use the page Jump to pass over the parameters, namely: {parameter name}, You can configure the corresponding data source for the SQL at the bottom";
	}else if(_userLanguage=="9"){
		tip = "此處可以是普通的文本或一條查詢的SQL語句，如：select name from table where id={id}，此處可以使用頁面跳轉時傳遞過來的參數，即：{參數名稱}，同時可以在下方為此處的SQL配置對應的數據源";
	}else{
		tip = "此处可以是普通的文本或一条查询的SQL语句，如：select name from table where id={id}，此处可以使用页面跳转时传递过来的参数，即：{参数名称}，同时可以在下方为此处的SQL配置对应的数据源";
	}


	var theId = this.id;
	
	var htm = "<div id=\"MADNH_"+theId+"\">"
	htm += "<div class=\"MADNH_Title\">"+SystemEnv.getHtmlNoteName(4370)+"</div>";  //导航头
	htm += "<div class=\"MADNH_Content\">"
		 	   + "<div class=\"MADNH_BaseInfo_Entry\">"
					+ "<span class=\"MADNH_BaseInfo_Entry_Label\" style=\"display:block;margin-bottom: 3px;\">"+SystemEnv.getHtmlNoteName(3978)+"</span>"  //标题：
					+ "<span class=\"MADNH_BaseInfo_Entry_Content\">"
						+ "<textarea id=\"title_"+theId+"\" class=\"MADNH_Htm MADNH_Htm"+styleL+"\" placeholder=\""+tip+"\"></textarea>"  //此处可以是普通的文本或一条查询的SQL语句，如：select name from table where id={id}，此处可以使用页面跳转时传递过来的参数，即：{参数名称}
					+ "</span>"
				+ "</div>" 
				
				+ "<div class=\"MADNH_BaseInfo_Entry\">"
					+ "<span class=\"MADNH_BaseInfo_Entry_Label\" style=\"margin-bottom: 3px;\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
					+ "<span class=\"MADNH_BaseInfo_Entry_Content\">"
						+"<select class=\"MADNH_Select\" id=\"datasource_"+theId+"\">"
						+"  <option value=\"\">(local)</option>"
						+"</select>"
					+ "</span>"
				+ "</div>"
				
				+ "<div class=\"MADNH_BaseInfo_Entry\">"
					+ "<span class=\"MADNH_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4371)+"</span>"  //小标题：
					+ "<span class=\"MADNH_BaseInfo_Entry_Content\">"
						+ "<input type=\"text\" id=\"smallTitle_"+theId+"\" class=\"MADNH_Text\" data-multi=false />"
					+ "</span>"
				+ "</div>" 
				
				+ "<div class=\"MADNH_BaseInfo_Entry\">"
					+ "<span class=\"MADNH_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4946)+"</span>"  //固定顶部：
					+ "<span class=\"MADNH_BaseInfo_Entry_Content\">"
						+ "<span class=\"cbboxEntry\">"
							+ "<input type=\"checkbox\" id=\"isFixedTop_"+theId+"\" value=\"1\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4947)+"</span>"  //将导航头固定在页面顶部
						+ "</span>"
					+ "</span>"
				+ "</div>" 
			
				+ "<div class=\"MADNH_BaseInfo_Entry\">"
					+ "<span class=\"MADNH_BaseInfo_Entry_Label MADNH_BaseInfo_Entry_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4349)+"</span>"  //单击事件：
					+ "<span class=\"MADNH_BaseInfo_Entry_Content\">"
						+ "<span class=\"cbboxEntry\" style=\"width: 60px;\">"
							+ "<input type=\"checkbox\" name=\"clickType_"+theId+"\" value=\"1\" onclick=\"MADNH_ChangeClickType(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4343)+"</span>"  //返回
						+ "</span>"
						+ "<span class=\"cbboxEntry\" style=\"position: relative;width:120px;\">"
							+ "<input type=\"checkbox\" name=\"clickType_"+theId+"\" value=\"2\" onclick=\"MADNH_ChangeClickType(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4372)+"</span>"  //自定义脚本
							+ "<span style=\"position: absolute;top:-4px;\">" 
								+ "<div id=\"clickScriptWrap_"+theId+"\" class=\"nhbtn_click_desc\" style=\"width: 16px;height: 22px;display:none;\" onclick=\"MADNH_addClickScript('"+theId+"')\">"
									+ "<input  id=\"clickScript_"+theId+"\" type=\"hidden\" value=\"\">"
								+ "</div>"
							+"</span>"
						+ "</span>"
					+ "</span>"
				+ "</div>" 
				
				+ "<div style=\"margin-bottom:10px;margin-right:10px;\">"
					+ "<div class=\"navHeader_nhbtn_title\">"
						+ SystemEnv.getHtmlNoteName(4635)  //按钮
						+ "<div class=\"navHeader_nhbtn_add\" onclick=\"MADNH_AddBtn('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
					+ "</div>"
					+ "<div class=\"navHeader_nhbtn_content\">"
						+ "<div class=\"navHeader_nhbtn_empty_tip\">"+SystemEnv.getHtmlNoteName(4159)+"</div>"  //单击右上角的添加按钮以添加内容
						+ "<ul></ul>"
					+ "</div>"
				+ "</div>"
				
			+"</div>";
	htm += "<div class=\"MADNH_Bottom\"><div class=\"MADNH_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.NavHeader.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var $attrContainer = $("#MADNH_"+theId);
	
	$("#title_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["title"]));
	
	var datasource = Mec_FiexdUndefinedVal(this.mecJson["datasource"]);
	$("#datasource_"+theId).val(datasource);
	MADNH_setDataSourceHTML(theId, datasource);
	
	$("#smallTitle_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["smallTitle"]));
	
	var isFixedTop = Mec_FiexdUndefinedVal(this.mecJson["isFixedTop"]);
	if(isFixedTop == "1"){
		$("#isFixedTop_"+theId).attr("checked", "checked");
	}
	
	var clickTypeV = this.mecJson["clickType"];
	var $clickType = $("input[type='checkbox'][name='clickType_"+theId+"'][value='"+clickTypeV+"']");
	if($clickType.length > 0){
		$clickType.attr("checked", "checked");
		$clickType.triggerHandler("click");
	}
	
	$("#clickScript_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["clickScript"]));
	
	var btn_datas = this.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
	}
	if(btn_datas.length == 0){
		$(".navHeader_nhbtn_empty_tip", $attrContainer).show();
	}
	for(var i = 0; btn_datas && i < btn_datas.length; i++){
		MADNH_AddBtnToPage(theId, btn_datas[i]);
	}
	
	$("#MADNH_"+theId).jNice();
	
	MLanguage({
		container: $("#MADNH_"+theId)
    });
};

/*获取JSON*/
MEC_NS.NavHeader.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MAD_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["title"] = $("#title_"+theId).val();
		this.mecJson["datasource"] = $("#datasource_"+theId).val();
		
		this.mecJson["smallTitle"] = MLanguage.getValue($("#smallTitle_"+theId)) || $("#smallTitle_"+theId).val();
		this.mecJson["isFixedTop"] = $("#isFixedTop_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["clickType"] = $("input[type='checkbox'][name='clickType_"+theId+"']:checked").val();
		this.mecJson["clickScript"] = $("#clickScript_"+theId).val();
		
		var btn_datas = this.mecJson["btn_datas"];
		if(!btn_datas){
			btn_datas = [];
		}
		var $BtnLi = $(".navHeader_nhbtn_content > ul > li", $attrContainer);
		$BtnLi.each(function(){
			var liId = $(this).attr("id");
			if(liId && liId != ""){
				var btnType = $("select[name='btnType']", $(this)).val();
				var btnId = liId.substring("li_".length);
				
				var nhimg_item = {};
				nhimg_item["iconpath"] = $("#pic_path_"+btnId).val();
				nhimg_item["icontype"] = $("#pic_type_"+btnId).val();
				nhimg_item["iconstyle"] = $("#pic_style_"+btnId).val();
				nhimg_item["iconwidth"] = $("#pic_path_"+btnId).attr("iconwidth");
				nhimg_item["iconheight"] = $("#pic_path_"+btnId).attr("iconheight");
				var btnText = $("input[name='btnText']", $(this)).val();
				var btnTextML = MLanguage.getValue($("input[name='btnText']", $(this)));
				var btnScript = $("input[name='btnScript']", $(this)).val();
				for(var i = 0; i < btn_datas.length; i++){
					if(btn_datas[i]["id"] == btnId){
						btn_datas[i]["btnType"] = btnType;
						btn_datas[i]["btnText"] = btnTextML || btnText;
						btn_datas[i]["nhimg_item"] = nhimg_item;
						btn_datas[i]["btnScript"] = btnScript;
						break;
					}
				}
			}
		});
	}
	return this.mecJson;
};

MEC_NS.NavHeader.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["title"] = "";	//标题
	defMecJson["datasource"] = "";	//数据源
	defMecJson["smallTitle"] = "";	//小标题
	defMecJson["clickType"] = "1";	//单击类型
	defMecJson["clickScript"] = "";	//单击脚本
	defMecJson["btn_datas"] = [];
	
	return defMecJson;
};

function MADNH_ChangeClickType(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='clickType_"+mec_id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		if(objV == "2"){
			$("#clickScriptWrap_" + mec_id).show();
		}else{
			$("#clickScriptWrap_" + mec_id).hide();
		}
	},100);
}

function MADNH_addClickScript(mec_id){
	var $btnScript = $("#clickScript_"+mec_id);
	SL_AddScriptToField($btnScript);
}

function MADNH_AddBtn(mec_id){
	var result = {};
	result["id"] = new UUID().toString();
	result["btnType"] = "";
	result["btnText"] = "";
	result["nhimg_item"] = {};
	result["nhimg_item"]["iconpath"] = "";
	result["nhimg_item"]["icontype"] = "";
	result["nhimg_item"]["iconstyle"] = "";
	result["nhimg_item"]["iconwidth"] = "";
	result["nhimg_item"]["iconheight"] = "";
	result["btnScript"] = "";
	
	MADNH_AddBtnToPage(mec_id, result);
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var btn_datas = mecHandler.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
		mecHandler.mecJson["btn_datas"] = btn_datas;
	}
	btn_datas.push(result);
}

function MADNH_AddBtnToPage(mec_id, result){
	
	var $attrContainer = $("#MADNH_"+mec_id);
	
	$(".navHeader_nhbtn_empty_tip", $attrContainer).hide();
	
	var $ul = $(".navHeader_nhbtn_content > ul", $attrContainer);
	var $li = $("<li id=\"li_"+result["id"]+"\"></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    		htm += "<td width=\"80px\" style=\"padding-right: 28px;\">";
	    			htm += "<select name=\"btnType\" id=\"btnTypeSelect_"+result["id"]+"\" onchange=\"MADNH_BtntypeChange('"+mec_id+"', '"+result["id"]+"')\" style=\"padding-left: 10px;\">";
	    				htm += "<option value=\"1\">"+SystemEnv.getHtmlNoteName(4373)+"</option>";  //文字
	    				htm += "<option value=\"2\">"+SystemEnv.getHtmlNoteName(4167)+"</option>";  //图片
	    			htm += "</select>";
				htm += "</td>";
	    	
			    htm += "<td width=\"100px\" valign=\"middle\" id=\"textTD_"+result["id"]+"\">";
			    	htm += "<input name=\"btnText\" type=\"text\" class=\"MADNH_Text\" style=\"height:22px;line-height:10px;\" value=\""+result["btnText"]+"\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4177)+"\"/>";  //按钮名称
			    htm += "</td>";
			    
			    htm += "<td width=\"100px\" id=\"imgTD_"+result["id"]+"\" onclick=\"MADNH_PicSet('"+result["id"]+"','"+mec_id+"');\" style=\"display: none;\">";
			    	htm += "<img id=\"pic_img_"+result["id"]+"\" src=\"/mobilemode/images/mec/add-img-btn_wev8.png\">";
			    	htm += "<input type=\"hidden\" id=\"pic_type_"+result["id"]+"\"/>";
			    	htm += "<input type=\"hidden\" id=\"pic_style_"+result["id"]+"\"/>";
			    	htm += "<input type=\"hidden\" id=\"pic_path_"+result["id"]+"\" iconwidth=\"\" iconheight=\"\"/>";
			    htm += "</td>";
			    
			    htm += "<td width=\"120px\">";
					htm += "<div class=\"nhbtn_click_desc\">";
						htm += "<input name=\"btnScript\" type=\"hidden\" value=\"\"/>";
						htm += SystemEnv.getHtmlNoteName(4178);  //单击事件
					htm += "</div>";
				htm += "</td>";
				
				htm += "<td align=\"right\">";
					htm += "<span class=\"inparam_nhbtn_del\" onclick=\"MADNH_deleteOneBtnOnPage('"+mec_id+"','"+result["id"]+"')\"></span>";
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
	
	$("#btnTypeSelect_"+result["id"], $li).val(Mec_FiexdUndefinedVal(result["btnType"] , "1"));
	
	MADNH_BtntypeChange(mec_id, result["id"]);
	
	MADNH_SetPicPath(result["id"], result["nhimg_item"]["iconpath"]);
	
	$("#pic_type_"+result["id"], $li).val(result["nhimg_item"]["icontype"]);
	$("#pic_style_"+result["id"], $li).val(result["nhimg_item"]["iconstyle"]);
	$("#pic_path_"+result["id"], $li).val(result["nhimg_item"]["iconpath"]);
	$("#pic_path_"+result["id"], $li).attr("iconwidth", result["nhimg_item"]["iconwidth"]);
	$("#pic_path_"+result["id"], $li).attr("iconheight", result["nhimg_item"]["iconheight"]);
	
	$("input[name='btnScript']", $li)[0].value = result["btnScript"];
	
	$(".nhbtn_click_desc", $li).click(function(){
		var $this = $(this);
		var $btnScript = $("input[name='btnScript']", $this);
		SL_AddScriptToField($btnScript);
	});
	
	MLanguage({
		container: $li
    });
}

function MADNH_deleteOneBtnOnPage(mec_id, id){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var btn_datas = mecHandler.mecJson["btn_datas"];
	if(!btn_datas){
		btn_datas = [];
	}
	var index = -1;
	for(var i = 0; i < btn_datas.length; i++){
		var data = btn_datas[i];
		if(data["id"] == id){
			index = i;
			break;
		}
	}
	if(index != -1){
		btn_datas.splice(index, 1);
	}
	
	$("#li_" + id).remove();
	
	if(btn_datas.length == 0){
		var $attrContainer = $("#MADNH_"+mec_id);
		$(".navHeader_nhbtn_empty_tip", $attrContainer).show();
	}
}

function MADNH_BtntypeChange(mec_id, btnId){
	var $Entry = $("#MADNH_"+mec_id);
	
	var btntype = $("#btnTypeSelect_"+btnId, $Entry).val();
	if(btntype == "1"){
		$("#textTD_"+btnId, $Entry).show();
		$("#imgTD_"+btnId, $Entry).hide();
	}else if(btntype == "2"){
		$("#textTD_"+btnId, $Entry).hide();
		$("#imgTD_"+btnId, $Entry).show();
	}
}

function MADNH_PicSet(btnId, mec_id){
	var pic_typeV = MADNH_IsNvl($("#pic_type_"+btnId).val(),"0");
	var pic_styleV = MADNH_IsNvl($("#pic_style_"+btnId).val(),"1");
	var pic_pathV = $("#pic_path_"+btnId).val();
	var iconwidthV = $("#pic_path_"+btnId).attr("iconwidth");
	var iconheightV = $("#pic_path_"+btnId).attr("iconheight");
	pic_pathV = encodeURIComponent(pic_pathV);
	var url = "/mobilemode/picset.jsp?pic_type="+pic_typeV+"&pic_style="+pic_styleV+"&pic_path="+pic_pathV+"&iconwidth="+iconwidthV+"&iconheight="+iconheightV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4117);  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picType = result["pic_type"];
		var picPath = result["pic_path"];
		var iconwidth = result["iconwidth"];
		var iconheight = result["iconheight"];
		var picStyle = result["pic_style"];
		if (picStyle == "1") {
			iconwidth = "";
			iconheight = "";
		} 
		$("#pic_type_"+btnId).val(picType);
		$("#pic_style_"+btnId).val(picStyle);
		$("#pic_path_"+btnId).val(picPath);
		$("#pic_path_"+btnId).attr("iconwidth",iconwidth);
		$("#pic_path_"+btnId).attr("iconheight",iconheight);
		
		MADNH_SetPicPath(btnId, picPath);
	};
}

function MADNH_SetPicPath(btnId, picPath){
	var $picImg = $("#pic_img_"+btnId);
	if(picPath && picPath != ""){
		$picImg[0].src = picPath;
	}else{
		$picImg[0].src = "/mobilemode/images/mec/add-img-btn_wev8.png";
	}
}

function MADNH_IsNvl(str, dev){
	if (str == "") return dev;
	else return str;
}

function MADNH_setDataSourceHTML(mec_id,val){
	var $MADNH_DataSource = $("#datasource_" + mec_id);
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
			$MADNH_DataSource.append(dataSourceSelectHtml);
		}
	});
}