if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.TopButton = function(typeTmp, idTmp, mecJsonTmp){
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
MEC_NS.TopButton.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.TopButton.prototype.getDesignHtml = function(){
	var htmTemplate = getPluginContentTemplateById(this.type);
	var leftBtnName = this.mecJson["leftBtnName"];
	var leftBtnDisplay = this.mecJson["isHaveLeftBtn"] == "1" ? "block" : "none";
	var rightBtnName = this.mecJson["rightBtnName"];
	var rightBtnDisplay = this.mecJson["isHaveRightBtn"] == "1" ? "block" : "none";
	var htm = htmTemplate.replace("${leftBtnName}", leftBtnName)
						.replace("${leftBtnDisplay}", leftBtnDisplay)
						.replace("${appName}", appName)
						.replace("${rightBtnName}", rightBtnName)
						.replace("${rightBtnDisplay}", rightBtnDisplay);
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.TopButton.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var leftItemHtm = "";
	var leftItems = this.mecJson["leftItems"];
	for(var i = 0; i < leftItems.length; i++){
		leftItemHtm += MADTB_CreateRow(i, theId, "L");
	}
	
	var rightItemHtm = "";
	var rightItems = this.mecJson["rightItems"];
	for(var i = 0; i < rightItems.length; i++){
		rightItemHtm += MADTB_CreateRow(i, theId, "R");
	}
	
	var htm = "<div id=\"MADTB_"+theId+"\">"
				+ "<div class=\"MADTB_Title\">"
					+ "<span class=\"leftBtnFlag\" typeV=\"Left\">左侧按钮</span><span class=\"rightBrnFlag chosed\" typeV=\"Right\">右侧按钮</span>"
				+ "</div>"
				+ "<div class=\"MADTB_BaseInfo\">"
					+ "<div class=\"MADTB_BaseInfo_Left\" style=\"display: none;\">"
						+ "<div class=\"MADTB_BaseInfo_Entry\" style=\"display:none;\">"
							+ "<span class=\"MADTB_BaseInfo_Entry_Label\">是否显示：</span>"
							+ "<span class=\"MADTB_BaseInfo_Entry_Content\"><input type=\"checkbox\" id=\"isHaveLeftBtn_"+theId+"\" value=\"1\"/></span>"
						+ "</div>"
						+ "<div class=\"MADTB_BaseInfo_Entry\">"
							+ "<span class=\"MADTB_BaseInfo_Entry_Label\">按钮名称：</span>"
							+ "<span class=\"MADTB_BaseInfo_Entry_Content\"><input type=\"text\" class=\"MADTB_Text MADTB_ReadonlyText\" id=\"leftBtnName_"+theId+"\" readonly=\"readonly\"/></span>"
						+ "</div>"
						+ "<div class=\"MADTB_BaseInfo_Entry\">"
							+ "<span class=\"MADTB_BaseInfo_Entry_Label\">执行操作：</span>"
							+ "<span class=\"MADTB_BaseInfo_Entry_Content\">"
								+ "<span class=\"cbboxEntry\" style=\"width: 54px;\">"
									+ "<input type=\"checkbox\" name=\"leftActionType_"+theId+"\" value=\"1\" onclick=\"MADTB_ChangeLAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">返回</span>"
								+ "</span>"
								+ "<span class=\"cbboxEntry\" style=\"width: 83px;display:none;\">"
									+ "<input type=\"checkbox\" name=\"leftActionType_"+theId+"\" value=\"2\" onclick=\"MADTB_ChangeLAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">手动输入JS</span>"
								+ "</span>"
								+ "<span class=\"cbboxEntry\" style=\"width: 80px;display:none;\">"
									+ "<input type=\"checkbox\" name=\"leftActionType_"+theId+"\" value=\"3\" onclick=\"MADTB_ChangeLAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">滑出页面</span>"
								+ "</span>"
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"leftActionContent actionContent\" id=\"leftActionContent_"+theId+"_2\" style=\"display: none;\">"
							+ "<textarea id=\"leftAction_JS_"+theId+"\" class=\"MADTB_Textarea\" placeholder=\"请在此处输入JS, 此JS会在按钮点击时执行...\"></textarea>"
						+ "</div>"
						
						+ "<div class=\"leftActionContent actionContent\" id=\"leftActionContent_"+theId+"_3\" style=\"display: none;\">"
							+ "<table class=\"MADTB_Table\" id=\"MADTB_Table_L_"+theId+"\">"
								+ "<thead>"
									+ "<tr>"
										+ "<td width=\"7%\"></td>"
										+ "<td width=\"10%\">图标</td>"
										+ "<td width=\"28%\">显示名称</td>"
										+ "<td width=\"43%\">来源</td>"
										+ "<td width=\"10%\">提示</td>"
									+ "</tr>"
								+ "</thead>"
								+ "<tbody>"
								+ leftItemHtm
								+ "</tbody>"
							+ "</table>"
							
							+ "<div class=\"MADTB_AddItem_Wrap\">"
								+ "<span class=\"MADTB_AddItem\" onclick=\"MADTB_AddRow('"+theId+"', 'L');\">添加</span>"
							+ "</div>"
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADTB_BaseInfo_Right\">"
						+ "<div class=\"MADTB_BaseInfo_Entry\" style=\"display:none;\">"
							+ "<span class=\"MADTB_BaseInfo_Entry_Label\">是否显示：</span>"
							+ "<span class=\"MADTB_BaseInfo_Entry_Content\"><input type=\"checkbox\" id=\"isHaveRightBtn_"+theId+"\" value=\"1\"/></span>"
						+ "</div>"
						+ "<div class=\"MADTB_BaseInfo_Entry\">"
							+ "<span class=\"MADTB_BaseInfo_Entry_Label\">按钮名称：</span>"
							+ "<span class=\"MADTB_BaseInfo_Entry_Content\"><input type=\"text\" class=\"MADTB_Text MADTB_ReadonlyText\" id=\"rightBtnName_"+theId+"\" readonly=\"readonly\"/></span>"
						+ "</div>"
						+ "<div class=\"MADTB_BaseInfo_Entry\">"
							+ "<span class=\"MADTB_BaseInfo_Entry_Label\">执行操作：</span>"
							+ "<span class=\"MADTB_BaseInfo_Entry_Content\">"
								+ "<span class=\"cbboxEntry\" style=\"width: 54px;display:none;\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"1\" onclick=\"MADTB_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">返回</span>"
								+ "</span>"
								+ "<span class=\"cbboxEntry\" style=\"width: 83px;\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"2\" onclick=\"MADTB_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">手动输入JS</span>"
								+ "</span>"
								+ "<span class=\"cbboxEntry\" style=\"width: 80px;\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"3\" onclick=\"MADTB_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">滑出页面</span>"
								+ "</span>"
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"_2\" style=\"display: none;\">"
							+ "<textarea id=\"rightAction_JS_"+theId+"\" class=\"MADTB_Textarea\" placeholder=\"请在此处输入JS, 此JS会在按钮点击时执行...\"></textarea>"
						+ "</div>"
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"_3\" style=\"display: none;\">"
							+ "<table class=\"MADTB_Table\" id=\"MADTB_Table_R_"+theId+"\">"
								+ "<thead>"
									+ "<tr>"
										+ "<td width=\"7%\"></td>"
										+ "<td width=\"10%\">图标</td>"
										+ "<td width=\"28%\">显示名称</td>"
										+ "<td width=\"43%\">来源</td>"
										+ "<td width=\"10%\">提示</td>"
									+ "</tr>"
								+ "</thead>"
								+ "<tbody>"
								+ rightItemHtm
								+ "</tbody>"
							+ "</table>"
							
							+ "<div class=\"MADTB_AddItem_Wrap\">"
								+ "<span class=\"MADTB_AddItem\" onclick=\"MADTB_AddRow('"+theId+"', 'R');\">添加</span>"
							+ "</div>"
						+ "</div>"
					+ "</div>"
				+ "</div>"
				
				+ "<div class=\"MADTB_Bottom\"><div class=\"MADTB_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">确定</div></div>"
			+ "</div>";
	htm += "<div class=\"MAD_Alert\">已生成到布局</div>";
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.TopButton.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var isHaveLeftBtn = this.mecJson["isHaveLeftBtn"];
	if(isHaveLeftBtn == "1"){
		$("#isHaveLeftBtn_"+theId).attr("checked","checked");
	}
	var leftBtnName = this.mecJson["leftBtnName"];
	$("#leftBtnName_"+theId).val(leftBtnName);
	
	var leftActionTypeV = this.mecJson["leftActionType"];
	var $leftActionType = $("input[type='checkbox'][name='leftActionType_"+theId+"'][value='"+leftActionTypeV+"']");
	if($leftActionType.length > 0){
		//MADTB_ChangeLAT($leftActionType[0], theId);
		$leftActionType.click();
	}
	
	var leftAction_JS = this.mecJson["leftAction_JS"];
	$("#leftAction_JS_"+theId).val(leftAction_JS);
	
	var leftItems = this.mecJson["leftItems"];
	MADTB_SetItem(leftItems, theId, "L");
	
	var isHaveRightBtn = this.mecJson["isHaveRightBtn"];
	if(isHaveRightBtn == "1"){
		$("#isHaveRightBtn_"+theId).attr("checked","checked");
	}
	var rightBtnName = this.mecJson["rightBtnName"];
	$("#rightBtnName_"+theId).val(rightBtnName);
	
	var rightActionTypeV = this.mecJson["rightActionType"];
	var $rightActionType = $("input[type='checkbox'][name='rightActionType_"+theId+"'][value='"+rightActionTypeV+"']");
	if($rightActionType.length > 0){
		//MADTB_ChangeRAT($rightActionType[0], theId);
		$rightActionType.click();
	}
	
	var rightAction_JS = this.mecJson["rightAction_JS"];
	$("#rightAction_JS_"+theId).val(rightAction_JS);
	
	var rightItems = this.mecJson["rightItems"];
	MADTB_SetItem(rightItems, theId, "R");
	
	MADTB_TriggerTable(theId, "L");
	
	MADTB_TriggerTable(theId, "R");
	
	MADTB_BindEvent(theId);
	
	$("#MADTB_"+theId).jNice();
	
	MADTB_Sortable(theId, "L");
	
	MADTB_Sortable(theId, "R");
};

/*获取JSON*/
MEC_NS.TopButton.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADTB_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["isHaveLeftBtn"] = $("#isHaveLeftBtn_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["leftBtnName"] = $("#leftBtnName_"+theId).val();
		this.mecJson["leftActionType"] = $("input[type='checkbox'][name='leftActionType_"+theId+"']:checked").val();
		this.mecJson["leftAction_JS"] = $("#leftAction_JS_"+theId).val();
		this.mecJson["leftItems"] = MADTB_GetItem(theId, "L");
		
		this.mecJson["isHaveRightBtn"] = $("#isHaveRightBtn_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["rightBtnName"] = $("#rightBtnName_"+theId).val();
		this.mecJson["rightActionType"] = $("input[type='checkbox'][name='rightActionType_"+theId+"']:checked").val();
		this.mecJson["rightAction_JS"] = $("#rightAction_JS_"+theId).val();
		this.mecJson["rightItems"] = MADTB_GetItem(theId, "R");
	}
	
	return this.mecJson;
};

MEC_NS.TopButton.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["isHaveLeftBtn"] = "1";
	defMecJson["leftBtnName"] = "返回";
	defMecJson["leftActionType"] = "1";
	defMecJson["leftAction_JS"] = "";
	defMecJson["leftItems"] = [];
	
	defMecJson["isHaveRightBtn"] = "1";
	defMecJson["rightBtnName"] = "更多";
	defMecJson["rightActionType"] = "3";
	defMecJson["rightAction_JS"] = "";
	defMecJson["rightItems"] = [{
		"iconpath" : "",
		"icontype" : "0",
		"iconstyle" : "1",
		"iconwidth" : "",
		"iconheight" : "",
		"source" : "3",
		"uiid" : "",
		"custom" : "",
		"jscode" : "refresh",
		"uiname" : "刷新",
		"isremind" : "0",
		"remindtype" : "",
		"reminddatasource" : "",
		"remindsql" : "",
		"remindjavafilename" : ""
	}];
	
	
	return defMecJson;
};

function MADTB_TriggerTable(mec_id, p){
	$("#MADTB_Table_"+p+"_"+mec_id + " > tbody > tr").each(function(i){
		var rowIndex = $(this).attr("rowIndex");
		MADTB_TriggerTableRow(rowIndex, mec_id, p);
	});
}

function MADTB_TriggerTableRow(rowIndex, mec_id, p){
	MADTB_SourceChange(rowIndex, mec_id, p);
	MADTB_IsremindChange(rowIndex, mec_id, p);
}

function MADTB_SourceChange(rowIndex, mec_id, p){
	var sourceV = $("#source_"+p+"_"+rowIndex+"_"+mec_id).val();
	var $ui = $("#ui_"+p+"_"+rowIndex+"_"+mec_id);
	var $custom = $("#custom_"+p+"_"+rowIndex+"_"+mec_id);
	var $jscode = $("#jscode_"+p+"_"+rowIndex+"_"+mec_id);
	if(sourceV == "1"){
		$custom.hide();
		$jscode.hide();
		$ui.show();
	}else if(sourceV == "2"){
		$ui.hide();
		$jscode.hide();
		$custom.show();
	}else if(sourceV == "3"){
		$custom.hide();
		$ui.hide();
		$jscode.show();
	}
}

function MADTB_IsremindChange(rowIndex, mec_id, p){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var $numremindEditFlag = $("#numremindEditFlag_"+p+"_"+rowIndex+"_"+mec_id);
		$("#isremind_"+p+"_"+rowIndex+"_"+mec_id).is(':checked') ? $numremindEditFlag.show() : $numremindEditFlag.hide();
	},100);
}

function MADTB_NumremindEdit(rowIndex, mec_id, p){
	var remindtypeV = $("#remindtype_"+p+"_"+rowIndex+"_"+mec_id).val();
	
	var reminddatasourceV = $("#reminddatasource_"+p+"_"+rowIndex+"_"+mec_id).val();
	
	var remindsqlV = $("#remindsql_"+p+"_"+rowIndex+"_"+mec_id).val();
	remindsqlV = $m_encrypt(remindsqlV);
	
	var remindjavafilenameV = $("#remindjavafilename_"+p+"_"+rowIndex+"_"+mec_id).val();
	
	var url = "/mobilemode/numremind.jsp?remindtype="+remindtypeV+"&reminddatasource="+reminddatasourceV+"&remindsql="+remindsqlV+"&remindjavafilename="+remindjavafilenameV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 500;//定义长度
	dlg.Height = 255;
	dlg.URL = url;
	dlg.Title = "数字提醒";
	dlg.show();
	dlg.hookFn = function(result){
		$("#remindtype_"+p+"_"+rowIndex+"_"+mec_id).val(result["remindtype"]);
		$("#reminddatasource_"+p+"_"+rowIndex+"_"+mec_id).val(result["reminddatasource"]);
		$("#remindsql_"+p+"_"+rowIndex+"_"+mec_id).val(result["remindsql"]);
		$("#remindjavafilename_"+p+"_"+rowIndex+"_"+mec_id).val(result["remindjavafilename"]);
	};
};

function MADTB_DelRow(rowIndex, mec_id, p){
	$("#MADTB_Table_"+p+"_"+mec_id + " > tbody > tr[rowIndex='"+rowIndex+"']").remove();
}

function MADTB_AddRow(mec_id, p){
	var maxRowIndex = 0;
	$("#MADTB_Table_"+p+"_"+mec_id + " > tbody > tr").each(function(i){
		var rowIndex = $(this).attr("rowIndex");
		if(rowIndex > maxRowIndex){
			maxRowIndex = rowIndex;
		}
	});
	var currRowIndex = maxRowIndex + 1;
	
	var htm = MADTB_CreateRow(currRowIndex, mec_id, p);
	
	var $newRow = $(htm);
	
	$("#MADTB_Table_"+p+"_"+mec_id + " > tbody").append($newRow);
	
	$newRow.jNice();
	
	MADTB_TriggerTableRow(currRowIndex, mec_id, p);
	
	MADTB_SetPicPath(currRowIndex, mec_id, "", p);
}
			        						        			
function MADTB_CreateRow(currRowIndex, mec_id, p){
	var htm = 
		"<tr rowIndex=\""+currRowIndex+"\">"
			+ "<td class=\"bemove\" width=\"7%\"></td>"
			+ "<td width=\"10%\">"
			+ "<div class=\"MADTB_Toolbar_Item_Img\" onclick=\"MADTB_PicSet("+currRowIndex+",'"+mec_id+"','"+p+"');\">"
				+ "<img id=\"pic_img_"+p+"_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"pic_type_"+p+"_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"pic_style_"+p+"_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"pic_path_"+p+"_"+currRowIndex+"_"+mec_id+"\" iconwidth=\"\" iconheight=\"\"/>"
			+ "</div> "
			+ "</td>"
			+ "<td width=\"28%\"><input id=\"uiname_"+p+"_"+currRowIndex+"_"+mec_id+"\" type=\"text\" class=\"textStyle\"/></td>"
			+ "<td width=\"43%\">"
				+ "<select id=\"source_"+p+"_"+currRowIndex+"_"+mec_id+"\" class=\"selectStyle\" onchange=\"MADTB_SourceChange("+currRowIndex+",'"+mec_id+"','"+p+"');\">"
					+ "<option value=\"1\">系统组件</option>"
					+ "<option value=\"2\">自定义</option>"
					+ "<option value=\"3\">脚本</option>"
				+ "</select>"
				+ "<span style=\"margin-left: 2px;\">"
					+ "<select id=\"ui_"+p+"_"+currRowIndex+"_"+mec_id+"\" class=\"selectStyle\" style=\"display: none;\">"
						+ MADTB_getUISelectOptionHtml()
					+ "</select>" 
					
					+ "<input id=\"custom_"+p+"_"+currRowIndex+"_"+mec_id+"\" type=\"text\" class=\"textStyle\" style=\"width: 67px !important;display: none;\"/>"
					
					+ "<select id=\"jscode_"+p+"_"+currRowIndex+"_"+mec_id+"\" class=\"selectStyle\" style=\"display: none;\" isJSCodeSel=\"true\">"
						+ Mec_GetJSCodeOptionHtml()
					+ "</select>" 
				+ "</span>"
			+ "</td>"
			+ "<td width=\"10%\" style=\"position: relative;\"><input type=\"checkbox\" id=\"isremind_"+p+"_"+currRowIndex+"_"+mec_id+"\" value=\"1\" onclick=\"MADTB_IsremindChange("+currRowIndex+",'"+mec_id+"','"+p+"');\"/>"
				+ "<input type=\"hidden\" id=\"remindtype_"+p+"_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"reminddatasource_"+p+"_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"remindsql_"+p+"_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"remindjavafilename_"+p+"_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<div id=\"numremindEditFlag_"+p+"_"+currRowIndex+"_"+mec_id+"\" class=\"numremindEditFlag\" onclick=\"MADTB_NumremindEdit("+currRowIndex+",'"+mec_id+"','"+p+"');\"></div>"
				+ "<div class=\"delFlag\" onclick=\"MADTB_DelRow("+currRowIndex+",'"+mec_id+"', '"+p+"');\"></div>"
			+ "</td>"
		+ "</tr>";
	return htm;
}

function MADTB_SetItem(items, mec_id, p){
	for(var i = 0; i < items.length; i++){
		var iconpath = items[i]["iconpath"];
		var icontype = items[i]["icontype"];
		var iconstyle = items[i]["iconstyle"];
		var iconwidth = items[i]["iconwidth"];
		var iconheight = items[i]["iconheight"];
		var uiid = items[i]["uiid"];
		var uiname = items[i]["uiname"];
		var source = items[i]["source"];
		var custom = items[i]["custom"];
		var jscode = items[i]["jscode"];
		var isremind = items[i]["isremind"];
		
		var remindtype = items[i]["remindtype"];
		var reminddatasource = items[i]["reminddatasource"];
		var remindsql = items[i]["remindsql"];
		var remindjavafilename = items[i]["remindjavafilename"];
		
		$("#pic_path_"+p+"_"+i+"_"+mec_id).val(iconpath);
		$("#pic_type_"+p+"_"+i+"_"+mec_id).val(icontype);
		$("#pic_style_"+p+"_"+i+"_"+mec_id).val(iconstyle);
		$("#pic_path_"+p+"_"+i+"_"+mec_id).attr("iconwidth",iconwidth);
		$("#pic_path_"+p+"_"+i+"_"+mec_id).attr("iconheight",iconheight);
		
		MADTB_SetPicPath(i, mec_id, iconpath, p);
		
		$("#source_"+p+"_"+i+"_"+mec_id).val(source);
		$("#ui_"+p+"_"+i+"_"+mec_id).val(uiid);
		$("#custom_"+p+"_"+i+"_"+mec_id).val(custom);
		$("#jscode_"+p+"_"+i+"_"+mec_id).val(jscode);
		$("#uiname_"+p+"_"+i+"_"+mec_id).val(uiname);
		if(isremind == "1"){
			$("#isremind_"+p+"_"+i+"_"+mec_id).attr("checked","checked");
		}
		
		$("#remindtype_"+p+"_"+i+"_"+mec_id).val(remindtype);
		$("#reminddatasource_"+p+"_"+i+"_"+mec_id).val(reminddatasource);
		$("#remindsql_"+p+"_"+i+"_"+mec_id).val(remindsql);
		$("#remindjavafilename_"+p+"_"+i+"_"+mec_id).val(remindjavafilename);
		
	}
}

function MADTB_GetItem(mec_id, p){
	var items = [];
	$("#MADTB_Table_"+p+"_"+mec_id + " > tbody > tr").each(function(i){
		var rowIndex = $(this).attr("rowIndex");
		var item = {};
		item["iconpath"] = $("#pic_path_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["icontype"] = $("#pic_type_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["iconstyle"] = $("#pic_style_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["iconwidth"] = $("#pic_path_"+p+"_"+rowIndex+"_"+mec_id).attr("iconwidth");
		item["iconheight"] = $("#pic_path_"+p+"_"+rowIndex+"_"+mec_id).attr("iconheight");
		item["source"] = $("#source_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["uiid"] = $("#ui_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["custom"] = $("#custom_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["jscode"] = $("#jscode_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["uiname"] = $("#uiname_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["isremind"] = $("#isremind_"+p+"_"+rowIndex+"_"+mec_id).is(':checked') ? "1" : "0";
		item["remindtype"] = $("#remindtype_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["reminddatasource"] = $("#reminddatasource_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["remindsql"] = $("#remindsql_"+p+"_"+rowIndex+"_"+mec_id).val();
		item["remindjavafilename"] = $("#remindjavafilename_"+p+"_"+rowIndex+"_"+mec_id).val();
		
		items.push(item);
	});
	return items;
}

function MADTB_getUISelectOptionHtml(){
	var htm = "";
	for(var i = 0; i < common_mec_nav_items.length; i++){
		var uiid = common_mec_nav_items[i]["uiid"];
		var uiname = common_mec_nav_items[i]["uiname"];
		htm += "<option value=\""+uiid+"\">"+uiname+"</option>";
	}
	return htm;
}

function MADTB_BindEvent(mec_id){
	//根据顶部区域区分当前操作的是左侧按钮还是右侧按钮
	$("#MADTB_"+mec_id+" > .MADTB_Title > span").click(function(){
		if(!$(this).hasClass("chosed")){
			$("#MADTB_"+mec_id+" > .MADTB_Title > span").removeClass("chosed");
			$(this).addClass("chosed");
			var typeV = $(this).attr("typeV");
			$("#MADTB_"+mec_id+" > .MADTB_BaseInfo > div").hide();
			$("#MADTB_"+mec_id+" > .MADTB_BaseInfo > div.MADTB_BaseInfo_" + typeV).show();
		}
	});
	
	//JS输入框绑定获取/失去 焦点时的事件
	var $MADTB_Textarea = $("#MADTB_"+mec_id+" .MADTB_Textarea");
	$MADTB_Textarea.focus(function(){
		$(this).addClass("MADTB_Textarea_Focus");
	});
	$MADTB_Textarea.blur(function(){
		$(this).removeClass("MADTB_Textarea_Focus");
	});
}

function MADTB_ChangeLAT(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='leftActionType_"+mec_id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		$("#MADTB_"+mec_id+" .leftActionContent").hide();
		$("#leftActionContent_" + mec_id + "_" + objV).show();
	},100);
}

function MADTB_ChangeRAT(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='rightActionType_"+mec_id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		$("#MADTB_"+mec_id+" .rightActionContent").hide();
		$("#rightActionContent_" + mec_id + "_" + objV).show();
	},100);
}

function MADTB_Sortable(mec_id, p){
	$("#MADTB_Table_"+p+"_"+mec_id + " > tbody").sortable({
		revert: false,
		axis: "y",
		items: "tr",
		handle: ".bemove"
	});
}

function MADTB_PicSet(rowIndex, mec_id, p){
	var pic_typeV = MADTB_IsNvl($("#pic_type_"+p+"_"+rowIndex+"_"+mec_id).val(),"0");
	var pic_styleV = MADTB_IsNvl($("#pic_style_"+p+"_"+rowIndex+"_"+mec_id).val(),"1");
	var pic_pathV = $("#pic_path_"+p+"_"+rowIndex+"_"+mec_id).val();
	var iconwidthV = $("#pic_path_"+p+"_"+rowIndex+"_"+mec_id).attr("iconwidth");
	var iconheightV = $("#pic_path_"+p+"_"+rowIndex+"_"+mec_id).attr("iconheight");
	pic_pathV = encodeURIComponent(pic_pathV);
	var url = "/mobilemode/picset.jsp?pic_type="+pic_typeV+"&pic_style="+pic_styleV+"&pic_path="+pic_pathV+"&iconwidth="+iconwidthV+"&iconheight="+iconheightV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = "添加图片";
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		var iconwidth = result["iconwidth"];
		var iconheight = result["iconheight"];
		var picStyle = result["pic_style"];
		if (picStyle == "1") {
			iconwidth = "";
			iconheight = "";
		} 
		$("#pic_type_"+p+"_"+rowIndex+"_"+mec_id).val(result["pic_type"]);
		$("#pic_style_"+p+"_"+rowIndex+"_"+mec_id).val(picStyle);
		$("#pic_path_"+p+"_"+rowIndex+"_"+mec_id).val(picPath);
		$("#pic_path_"+p+"_"+rowIndex+"_"+mec_id).attr("iconwidth",iconwidth);
		$("#pic_path_"+p+"_"+rowIndex+"_"+mec_id).attr("iconheight",iconheight);
		
		MADTB_SetPicPath(rowIndex, mec_id, picPath, p);
	};
};

function MADTB_SetPicPath(rowIndex, mec_id, picPath, p){
	var $picImg = $("#pic_img_"+p+"_"+rowIndex+"_"+mec_id);
	if(picPath && picPath != ""){
		$picImg[0].src = picPath;
	}else{
		$picImg[0].src = "/mobilemode/images/mec/add-img-btn_wev8.png";
	}
}

function MADTB_IsNvl(str, dev){
	if (str == "") return dev;
	else return str;
}