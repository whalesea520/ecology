if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Button = function(type, id, mecJson){
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
MEC_NS.Button.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Button.prototype.getDesignHtml = function(){
	var theId = this.id;
	var button_datas = this.mecJson["button_datas"];
	var rightActionTypeV = this.mecJson["rightActionType"];
	var htm = "";
	if(button_datas.length == 0){
		htm = "<div class=\"noButton\">"+SystemEnv.getHtmlNoteName(4479)+"</div>";  //未添加button
	}else{
		var htmTemplate = getPluginContentTemplateById(this.type);
		htmTemplate = htmTemplate.replace("${theId}", theId);
		var forTemplate = "";
		var forContentTemplate = "";
		var forStart = htmTemplate.indexOf("$mec_forstart$");
		var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
		if(forStart != -1 && forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
		}
		if(rightActionTypeV == 1){
			var forFixedStart = htmTemplate.indexOf("$mec_fixed_forstart$");
			var forFixedEnd = htmTemplate.indexOf("$mec_fixed_forend$");
			if(forFixedStart != -1 && forFixedEnd != -1){
				forContentTemplate = htmTemplate.substring(forFixedStart + "$mec_fixed_forstart$".length, forFixedEnd);
			}
		}else{
			var forRelativeStart = htmTemplate.indexOf("$mec_relative_forstart$");
			var forRelativeEnd = htmTemplate.indexOf("$mec_relative_forend$");
			if(forRelativeStart != -1 && forRelativeEnd != -1){
				forContentTemplate = htmTemplate.substring(forRelativeStart + "$mec_relative_forstart$".length, forRelativeEnd);
			}
		}
		var forHtml = "";
		for(var i = 0; i < button_datas.length; i++){
			var data = button_datas[i];
			var id = data["id"];
			var buttonName = data["buttonName"];
			var className = data["className"];
			var style = data["style"];
			var script = data["script"];
			var isremind = data["isremind"] == "1" ? "block" : "none";
			var iconPath = data["icon_path"] == undefined ? "" : data["icon_path"];
			var iconPosition = data["icon_position"] == undefined ? "1" : data["icon_position"];
			
			var buttonHtml = forContentTemplate.replace("${id}", id)
				.replace("${title}", buttonName)
				.replace("${class}", className)
				.replace("${style}", style)
				.replace("${script}", encodeURIComponent(script))
				.replace("${display}", isremind)
				.replace("${remindNum}", "N");
			if(iconPath != ""){
				if(iconPosition == "2"){
					buttonName = "<span>"+buttonName+"</span><span class=\"image\"><img src=\""+iconPath+"\"/></span>";
				}else{
					buttonName = "<span class=\"image\"><img src=\""+iconPath+"\"/></span><span>"+buttonName+"</span>";
				}
			}else{
				buttonName = "<span>"+buttonName+"</span>"
			}
			buttonHtml = buttonHtml.replace("${buttonName}", buttonName);
			forHtml += buttonHtml;
		}
		htm = htmTemplate.replace(forTemplate, forHtml);
	}
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Button.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	var htm = "<div id=\"MADButton_" + theId + "\">"
				+ "<div class=\"MADButton_title\">"
					+ SystemEnv.getHtmlNoteName(4480)  //插件设置
					+ "<div class=\"button_title_add\" onclick=\"MADButton_AddOne('"+theId+"')\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
				+ "</div>"
				+ "<div class=\"MADButton_style\">"
					+ "<span class=\"MADButton_style_label\">"+SystemEnv.getHtmlNoteName(4481)+"</span>"  //按钮布局：
					+ "<span class=\"MADButton_style_content\">"
						+ "<span class=\"cbboxEntry\" style=\"width:60px;\">"
							+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"1\" onclick=\"MADButton_ChangeRAT(this, '"+theId+"');\"><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4482)+"</span>"  //固定
						+ "</span>"
						+ "<span class=\"cbboxEntry\" style=\"width:100px;\">"
							+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"2\" onclick=\"MADButton_ChangeRAT(this, '"+theId+"');\"><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4483)+"</span>"  //自适应
						+ "</span>"
					+ "</span>"
				+ "</div>"
				+ "<div class=\"MADButton_Content\">"
					+ "<div class=\"button_ul_root_header\"><span style=\"width:7%;\"></span><span style=\"width:24%;\">"+SystemEnv.getHtmlNoteName(4177)+"</span><span style=\"width:10%;\">"+SystemEnv.getHtmlNoteName(4111)+"</span><span style=\"width:30%;\">"+SystemEnv.getHtmlNoteName(4484)+"</span><span style=\"width:15%;\">"+SystemEnv.getHtmlNoteName(3621)+"</span><span style=\"width:14%;\">"+SystemEnv.getHtmlNoteName(4485)+"</span></div>"  //按钮名称  图标  图标位置  提示  操作
					+ "<ul class=\"button_ul_root\">"
					+ "</ul>"
					+ "<div class=\"button_empty_tip\">"+SystemEnv.getHtmlNoteName(4159)+"</div>"  //单击右上角的添加按钮以添加内容
				+ "</div>"
				+ "<div class=\"MADButton_Bottom\"><div class=\"MADButton_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>"
			+ "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Button.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var $attrContainer = $("#MADButton_" + theId);
	var button_datas = this.mecJson["button_datas"];
	if(button_datas.length == 0){
		$(".button_empty_tip", $attrContainer).show();
	}
	for(var i = 0; i < button_datas.length; i++){
		MADBUTTON_AddButtonEntryToPage(theId, button_datas[i]);
	}
	
	var rightActionTypeV = this.mecJson["rightActionType"];
	var $rightActionType = $("input[type='checkbox'][name='rightActionType_" + theId + "'][value='" + rightActionTypeV + "']");
	if($rightActionType.length > 0){
		$rightActionType.attr("checked", "checked");
		$rightActionType.triggerHandler("click");
	}
	
	$("#MADButton_" + theId).jNice();//调用表单插件
	$("#MADButton_" + theId + " .MADButton_Content > ul").sortable({
		revert: false,
		axis: "y",
		items: "li",
		handle: ".bemove"
	});
};

/*获取JSON*/
MEC_NS.Button.prototype.getMecJson = function(){
	var theId = this.id;
	var $attrContainer = $("#MADButton_" + theId);
	this.mecJson["id"] = theId;
	this.mecJson["mectype"]= this.type;
	//获取按钮布局设置值
	var $rightAction = $("input[type='checkbox'][name='rightActionType_"+theId+"']:checked");
	if($rightAction.length > 0){
		var rightActionType = $rightAction.val();
		this.mecJson["rightActionType"] = rightActionType;
	}
	if($attrContainer.length > 0){
		var button_datas = this.mecJson["button_datas"];
		for(var i = 0; i < button_datas.length; i++){
			var button_data = button_datas[i];
			button_data["isremind"] = $("#remindcBox_"+button_data["id"]).is(':checked') ? "1" : "0";
			button_data["icon_type"] = $("#icon_type_"+button_data["id"]).val();
			button_data["icon_style"] = $("#icon_style_"+button_data["id"]).val();
			button_data["icon_path"] = $("#icon_path_"+button_data["id"]).val();
			var $iconPosition = $("input[type='checkbox'][name='iconPosition_"+button_data["id"]+"']:checked");
			if($iconPosition.length > 0){
				button_data["icon_position"] = $iconPosition.val();
			}else{
				button_data["icon_position"] = "1";
			}
		}
		
		var datasTemp = [];
		$(".MADButton_Content > ul > li", $attrContainer).each(function(i){
			var liId = $(this).attr("id").substring(12);//buttonEntry_CE。。。。。AB
			for(var i = 0; i < button_datas.length; i++){
				var button_data = button_datas[i];
				if(liId == button_data["id"]){
					datasTemp.push(button_data);
				}
			}
		});
		this.mecJson["button_datas"] = datasTemp;
		
	}
	return this.mecJson;
};

MEC_NS.Button.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	var defMecJson = {};
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	defMecJson["rightActionType"] = 1;
	var button_datas = [];
	defMecJson["button_datas"] = button_datas;
	return defMecJson;
};

function MADButton_AddOne(mec_id){
	var url = "/mobilemode/buttonEntry.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 490;//定义长度
	dlg.Height = 395;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3518);  //添加
	dlg.show();
	dlg.hookFn = function(result){
		result["id"] = new UUID().toString();
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		var button_datas = mecHandler.mecJson["button_datas"];
		button_datas.push(result);
		MADBUTTON_AddButtonEntryToPage(mec_id, result);
	};
}

function MADBUTTON_AddButtonEntryToPage(mec_id, result){
	var $attrContainer = $("#MADButton_" + mec_id);
	$(".button_empty_tip", $attrContainer).hide();
	var id = result["id"];
	var buttonName = result["buttonName"];
	var buttonNameLabel = MLanguage.parse(buttonName)||buttonName;
	var className = result["className"];
	var script = result["script"];
	var style = result["style"];
	
	var isremind = result["isremind"] == undefined ? "0" : result["isremind"];
	var remindtype = result["remindtype"] == undefined ? "" : result["remindtype"];
	var remindsql = result["remindsql"] == undefined ? "" : result["remindsql"];
	var reminddatasource = result["reminddatasource"] == undefined ? "" : result["reminddatasource"];
	var remindjavafilename = result["remindjavafilename"] == undefined ? "" : result["remindjavafilename"];
	
	var icon_type = result["icon_type"] == undefined ? "" : result["icon_type"];
	var icon_style = result["icon_style"] == undefined ? "" : result["icon_style"];
	var icon_path = result["icon_path"] == undefined ? "" : result["icon_path"];
	var icon_position = result["icon_position"] == undefined ? "1" : result["icon_position"];
	
	var $buttonEntry = $("<li id=\"buttonEntry_" + id + "\"></li>");
	$buttonEntry.html(
		  "<div class=\"button_table_wrap\">"
			+ "<table>"
				+ "<tr>"
					+ "<td class=\"bemove\" width=\"7%\"></td>"
					+ "<td width=\"24%\">"
						+ "<div class=\"button_dis_buttonName\" title=\""+buttonNameLabel+"\" data-value=\""+ buttonName +"\" >" + buttonNameLabel + "</div>"
					+ "</td>"
					+ "<td width=\"10%\" style=\"position:relative;\">"
						+ "<div class=\"button_dis_icon\" title=\""+SystemEnv.getHtmlNoteName(4486)+"\" onclick=\"MADBUTTON_IconSet('"+id+"', '"+mec_id+"')\">"  //点击修改图片
							+ "<img id=\"buttonIcon_"+id+"\" class=\"button_icon_img\" style=\"width:16px;height:16px;cursor:pointer;\" src=\"/mobilemode/images/mec/add-img-btn_wev8.png\">"
							+ "<input type=\"hidden\" id=\"icon_type_"+id+"\" value=\""+icon_type+"\"/>"
							+ "<input type=\"hidden\" id=\"icon_style_"+id+"\" value=\""+icon_style+"\"/>"
							+ "<input type=\"hidden\" id=\"icon_path_"+id+"\" value=\""+icon_path+"\"/>"
						+ "</div>"
						+ "<div class=\"delFlag\" title=\""+SystemEnv.getHtmlNoteName(4487)+"\"></div>"  //删除图标
					+ "</td>"
					+ "<td width=\"30%\">"
						+ "<div class=\"button_dis_iconposition\">"
							+ "<input type=\"checkbox\" name=\"iconPosition_"+id+"\" value=\"1\" onclick=\"MADBUTTON_IsIconPositionChange(this, '"+id+"')\"/>"
							+ "<span style=\"padding-right:5px;color:#999;font-size:12px;\">"+SystemEnv.getHtmlNoteName(4488)+"</span>"  //左
							+ "<input type=\"checkbox\" name=\"iconPosition_"+id+"\" value=\"2\" onclick=\"MADBUTTON_IsIconPositionChange(this, '"+id+"')\"/>"
							+ "<span style=\"color:#999;font-size:12px;\">"+SystemEnv.getHtmlNoteName(4489)+"</span>"  //右
						+ "</div>"
					+ "</td>"
					+ "<td width=\"15%\">"
						+ "<input type=\"checkbox\" id=\"remindcBox_"+id+"\" value=\"1\" onclick=\"MADBUTTON_IsremindChange('"+id+"');\">"
						+ "<span id=\"numremindEditFlag_"+id+"\" class=\"numremindEditFlag\" onclick=\"MADBUTTON_NumremindEdit('"+id+"', '"+mec_id+"');\"></span>"
						+ "<input type=\"hidden\" id=\"remindtype_"+id+"\" value=\""+remindtype+"\"/>"
						+ "<input type=\"hidden\" id=\"remindsql_"+id+"\" value=\""+remindsql+"\"/>"
						+ "<input type=\"hidden\" id=\"reminddatasource_"+id+"\" value=\""+reminddatasource+"\"/>"
						+ "<input type=\"hidden\" id=\"remindjavafilename_"+id+"\" value=\""+remindjavafilename+"\"/>"
					+ "</td>"
					+ "<td width=\"14%\">"
						+ "<span class=\"button_btn_del\" title=\""+SystemEnv.getHtmlNoteName(3519)+"\" onclick=\"MADButton_DeleteButtonEntry('" + mec_id + "', '" + id + "')\"></span>"  //删除
						+ "<span class=\"button_btn_edit\" title=\""+SystemEnv.getHtmlNoteName(4002)+"\" onclick=\"MADButton_EditOne('" + mec_id + "', '" + id + "')\"></span>"  //编辑
					+ "</td>"
				+ "</tr>"
			+ "</table>"
		+ "</div>"
	);
	$(".button_ul_root", $attrContainer).append($buttonEntry);
	if(isremind == "1"){
		$("#remindcBox_"+id).attr("checked", "checked");
		$("#remindcBox_"+id).triggerHandler("click");
	}
	MADBUTTON_ChangeIconPosition(id, icon_position);
	MADBUTTON_SetIconPath(id, icon_path);
	$buttonEntry.hover(function(){
		if($("#icon_path_"+id).val() != ""){
			$(".delFlag", $(this)).bind("click", function(){
				$("#icon_type_"+id).val("");
				$("#icon_style_"+id).val("");
				$("#icon_path_"+id).val("");
				MADBUTTON_SetIconPath(id, "");
				MADBUTTON_ChangeIconPosition(id, "1");
			}).show();
		}
	}, function(){
		$(".delFlag", $(this)).unbind("click").hide();
	});
	$buttonEntry.jNice();
}

function MADBUTTON_ChangeIconPosition(rowId, value){
	var $icon_position = $("input[type='checkbox'][name='iconPosition_" + rowId + "'][value='"+value+"']");
	if($icon_position.length > 0){
		$icon_position.attr("checked", "checked");
		$icon_position.triggerHandler("click");
	}
}

function MADBUTTON_IconSet(rowId, mec_id){
	
	var pic_typeV = $("#icon_type_"+rowId).val() == "" ? "0" : $("#icon_type_"+rowId).val();
	var pic_styleV = $("#icon_style_"+rowId).val() == "" ? "1" : $("#icon_style_"+rowId).val();
	var pic_pathV = $("#icon_path_"+rowId).val();
	pic_pathV = encodeURIComponent(pic_pathV);
	
	var url = "/mobilemode/picset.jsp?pic_type="+pic_typeV+"&pic_style="+pic_styleV+"&pic_path="+pic_pathV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4117);  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		
		$("#icon_type_"+rowId).val(result["pic_type"]);
		$("#icon_style_"+rowId).val(result["pic_style"]);
		$("#icon_path_"+rowId).val(picPath);
		
		MADBUTTON_SetIconPath(rowId, picPath);
	};
};
function MADBUTTON_SetIconPath(rowId, picPath){
	var $IconImg = $("#buttonIcon_"+rowId);
	if(picPath && picPath != ""){
		$IconImg[0].src = picPath;
	}else{
		$IconImg[0].src = "/mobilemode/images/mec/add-img-btn_wev8.png";
	}
}

function MADBUTTON_IsremindChange(rowId){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var $numremindEditFlag = $("#numremindEditFlag_"+rowId);
		$("#remindcBox_"+rowId).is(':checked') ? $numremindEditFlag.css("display", "inline-block") : $numremindEditFlag.css("display", "none");
	},100);
}

function MADBUTTON_NumremindEdit(rowId, mecId){
	var mecHandler = MECHandlerPool.getHandler(mecId);
	if(mecHandler == null) return;
	var button_datas = mecHandler.mecJson["button_datas"];
	var button_data = null;
	for(var i = 0; i < button_datas.length; i++){
		var data = button_datas[i];
		if(data["id"] == rowId){
			button_data = data;
			break;
		}
	}
	if(button_data == null) return;
	var remindtypeV = $("#remindtype_"+rowId).val();
	
	var remindsqlV = $("#remindsql_"+rowId).val();
	remindsqlV = $m_encrypt(remindsqlV);
	
	var reminddatasourceV = $("#reminddatasource_"+rowId).val();
	var remindjavafilenameV = $("#remindjavafilename_"+rowId).val();
	
	var url = "/mobilemode/numremind.jsp?remindtype="+remindtypeV+"&reminddatasource="+reminddatasourceV+"&remindsql="+remindsqlV+"&remindjavafilename="+remindjavafilenameV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 500;//定义长度
	dlg.Height = 255;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4116)  //数字提醒;
	dlg.show();
	dlg.hookFn = function(result){
		button_data["isremind"] = $("#remindcBox_"+rowId).is(':checked') ? "1" : "0";
		button_data["remindtype"] = result["remindtype"];
		button_data["remindsql"] = result["remindsql"];
		button_data["reminddatasource"] = result["reminddatasource"];
		button_data["remindjavafilename"] = result["remindjavafilename"];
	};
};

function MADButton_EditOne(mec_id, buttonId){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	if(mecHandler == null) return;
	var button_datas = mecHandler.mecJson["button_datas"];
	var button_data = null;
	for(var i = 0; i < button_datas.length; i++){
		var data = button_datas[i];
		if(data["id"] == buttonId){
			button_data = data;
			break;
		}
	}
	//获取自定义样式，预览使用
	var mecStyle = $("#content_editor style").html().trim();
	var buttonEntry = JSON.stringify(button_data);
	buttonEntry = $m_encrypt(buttonEntry);
	var url = "/mobilemode/buttonEntry.jsp?buttonEntry=" + buttonEntry + "&mecStyle=" + mecStyle;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 490;//定义长度
	dlg.Height = 440;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4002);  //编辑
	dlg.show();
	dlg.hookFn = function(result){
		var buttonName = result["buttonName"];
		var className = result["className"];
		var script = result["script"];
		var style = result["style"];
		button_data["buttonName"] = buttonName;
		button_data["className"]  = className;
		button_data["script"]     = script;
		button_data["style"]      = style;
		button_data["borderColor"]= result["borderColor"];
		button_data["fontColor"]  = result["fontColor"];
		button_data["bgColor"]    = result["bgColor"];
		//获取属性框该按钮的DOM
		var $li = $("#buttonEntry_" + buttonId);
		$(".button_dis_buttonName", $li).html(MLanguage.parse(buttonName)||buttonName);
		$(".button_dis_className", $li).html(className);
		$(".button_dis_script", $li).html(script);
		$(".button_dis_style", $li).html(style);
	};
}

function MADButton_DeleteButtonData(mec_id, id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var button_datas = mecHandler.mecJson["button_datas"];
	var index = -1;
	for(var i = 0; i < button_datas.length; i++){
		var data = button_datas[i];
		if(data["id"] == id){
			index = i;
			break;
		}
	}
	if(index != -1){
		button_datas.splice(index, 1);
	}
}

function MADButton_DeleteButtonEntry(mec_id, id){
	var msg = SystemEnv.getHtmlNoteName(4244);  //确定删除?
	if(!confirm(msg)){
		return;
	}
	MADButton_DeleteButtonData(mec_id, id);
	var $attrContainer = $("#MADButton_" + mec_id);
	$("#buttonEntry_" + id, $attrContainer).remove();
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var button_datas = mecHandler.mecJson["button_datas"];
	if(button_datas.length == 0){
		$(".button_empty_tip", $attrContainer).show();
	}
}

function MADButton_ChangeRAT(cbObj, mec_id){
	setTimeout(function(){
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
		}else{
			$("input[type='checkbox'][name='rightActionType_" + mec_id + "']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
	}, 100);
}

function MADBUTTON_IsIconPositionChange(cbObj, rowId){
	setTimeout(function(){
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
		}else{
			$("input[type='checkbox'][name='iconPosition_" + rowId + "']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
	}, 100);
}