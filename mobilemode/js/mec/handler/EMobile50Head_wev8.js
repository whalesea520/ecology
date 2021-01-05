if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.EMobile50Head = function(type, id, mecJson){
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
MEC_NS.EMobile50Head.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.EMobile50Head.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	htm = "<div class=\"eMobile50HeadContainer\">"
			+ "<div class=\"leftTD\">"+SystemEnv.getHtmlNoteName(4344)+"</div>"  //左侧
			+ "<div class=\"centerTD\">"+SystemEnv.getHtmlNoteName(3534)+"</div>"  //标题
			+ "<div class=\"rightTD\">"+SystemEnv.getHtmlNoteName(4345)+"</div>"  //右侧
		+ "</div>";
	
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.EMobile50Head.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADEMobile50Head_"+theId+"\">"
			+ "<div class=\"MADEMobile50Head_Title\">"
				+ "<span class=\"leftBtnFlag chosed\" typeV=\"Left\">"+SystemEnv.getHtmlNoteName(4338)+"</span><span class=\"middleBtnFlag\" typeV=\"Middle\">"+SystemEnv.getHtmlNoteName(3534)+"</span><span class=\"rightBrnFlag\" typeV=\"Right\">"+SystemEnv.getHtmlNoteName(4339)+"</span>"  //左侧按钮  标题  右侧按钮
			+ "</div>";
	htm +=  "<div class=\"MADEMobile50Head_BaseInfo\">"
	
				+ "<div class=\"MADEMobile50Head_BaseInfo_Left\"\">"
						+ "<div class=\"MADEMobile50Head_BaseInfo_Entry\">"
							+ "<span class=\"MADEMobile50Head_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4346)+"</span>"  //是否启用操作：
							+ "<span class=\"MADEMobile50Head_BaseInfo_Entry_Content\">"
								+ "<span class=\"cbboxEntry\"\">"
									+ "<input type=\"checkbox\" name=\"leftActionType_"+theId+"\" onclick=\"MADEMobile50Head_ChangeRATLeft(this, '"+theId+"');\" value=\"1\"\"/>"
								+ "</span>"
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"leftActionContent actionContent\" id=\"leftActionContent_"+theId+"\" style=\"display: none;\">"
							+ "<div class=\"MADEMobile50Head_BaseInfo_Entry\">"
								+ "<div class=\"MADEMobile50Head_BaseInfo_Entry_Label\" style=\"display:inline-block;\">"+SystemEnv.getHtmlNoteName(4347)+"</div>"  //选择替换图片：
								+ "<div class=\"MADEMobile50Head_BaseInfo_Entry_Content\" style=\"display:inline-block;height:25px;\">"
									+ "<div>"
										+ "<div class=\"previewDiv\">"
											+ "<img id=\"previewImg_left_"+theId+"\" class=\"previewImg\" style=\"display: none;\">"
										+ "</div>"
										+ "<div class=\"addPicDiv\" onclick=\"addPic('left_"+theId+"')\">"+SystemEnv.getHtmlNoteName(4348)+"</div>"  //选择图片
										+ "<input type=\"hidden\" id=\"picpath_left_"+theId+"\"/>"
									+ "</div>"
								+ "</div>"
							+ "</div>"
						
							+ "<div class=\"MADEMobile50Head_BaseInfo_Entry\" style=\"margin-top:14px;\">"
								+ "<div class=\"MADEMobile50Head_BaseInfo_Entry_Label\" style=\"display:inline-block;\">"+SystemEnv.getHtmlNoteName(4349)+"</div>"  //单击事件：
								+ "<div class=\"MADEMobile50Head_BaseInfo_Entry_Content\">"
									+ "<div class=\"btn_click_desc\" onclick=\"MADEMobile50Head_addLeftClickEvent('"+theId+"')\">"
										+ "<input  id=\"leftAction_JS_"+theId+"\" type=\"hidden\" value=\"\">"+SystemEnv.getHtmlNoteName(4178)  //单击事件
									+ "</div>"
								+ "</div>"
							+ "</div>"
						+ "</div>"
				+ "</div>"
				
				+ "<div class=\"MADEMobile50Head_BaseInfo_Middle\" style=\"display: none;\">"
						+ "<div class=\"MADEMobile50Head_BaseInfo_Entry\">"
							+ "<span class=\"MADEMobile50Head_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4350)+"</span>"  //页面名称：
							+ "<span class=\"MADEMobile50Head_BaseInfo_Entry_Content\"><input type=\"text\" style=\"margin-left: 25px;\" class=\"MADEMobile50Head_Text\" id=\"middlePageName_"+theId+"\" data-multi=false/></span>"
						+ "</div>"
				
						+ "<div class=\"MADEMobile50Head_BaseInfo_Entry\">"
							+ "<span class=\"MADEMobile50Head_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4346)+"</span>"  //是否启用操作：
							+ "<span class=\"MADEMobile50Head_BaseInfo_Entry_Content\">"
								+ "<span class=\"cbboxEntry\"\">"
									+ "<input type=\"checkbox\" name=\"middleActionType_"+theId+"\" onclick=\"MADEMobile50Head_ChangeRATMiddle(this, '"+theId+"');\" value=\"1\"\"/>"
								+ "</span>"
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"middleActionContent actionContent\" id=\"middleActionContent_"+theId+"\" style=\"display: none;\">"
							+ "<div class=\"menu_list_title\">"
								+ "<div class=\"menu_list_add\" onclick=\"MADEMobile50Head_AddMenu('"+theId+"','');\">"+SystemEnv.getHtmlNoteName(4351)+"</div>"  //添加菜单
							+ "</div>"
							+ "<div class=\"menu_list_content\">"
								+ "<div class=\"menu_list_empty_tip\">"+SystemEnv.getHtmlNoteName(4352)+"</div>"  //单击右上角的添加按钮以添加菜单
								+ "<ul></ul>"
							+ "</div>"
						+ "</div>"
						
				+ "</div>"
				
				+ "<div class=\"MADEMobile50Head_BaseInfo_Right\" style=\"display: none;\">"
						+ "<div class=\"MADEMobile50Head_BaseInfo_Entry\">"
							+ "<span class=\"MADEMobile50Head_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4346)+"</span>"  //是否启用操作：
							+ "<span class=\"MADEMobile50Head_BaseInfo_Entry_Content\">"
								+ "<span class=\"cbboxEntry\"\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" onclick=\"MADEMobile50Head_ChangeRATRight(this, '"+theId+"');\" value=\"1\"\"/>"
								+ "</span>"
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"\" style=\"display: none;\">"
							+ "<div class=\"MADEMobile50Head_BaseInfo_Entry\">"
								+ "<div class=\"MADEMobile50Head_BaseInfo_Entry_Label\" style=\"display:inline-block;\">"+SystemEnv.getHtmlNoteName(4347)+"</div>"  //选择替换图片：
								+ "<div class=\"MADEMobile50Head_BaseInfo_Entry_Content\" style=\"display:inline-block;height:25px;\">"
									+ "<div>"
										+ "<div class=\"previewDiv\">"
											+ "<img id=\"previewImg_right_"+theId+"\" class=\"previewImg\" style=\"display: none;\">"
										+ "</div>"
										+ "<div class=\"addPicDiv\" onclick=\"addPic('right_"+theId+"')\">"+SystemEnv.getHtmlNoteName(4348)+"</div>"  //选择图片
										+ "<input type=\"hidden\" id=\"picpath_right_"+theId+"\"/>"
									+ "</div>"
								+ "</div>"
							+ "</div>"
							
							+ "<div class=\"MADEMobile50Head_BaseInfo_Entry\" style=\"margin-top:14px;\">"
								+ "<div class=\"MADEMobile50Head_BaseInfo_Entry_Label\" style=\"display:inline-block;\">"+SystemEnv.getHtmlNoteName(4349)+"</div>"  //单击事件：
								+ "<div class=\"MADEMobile50Head_BaseInfo_Entry_Content\" style=\"padding-left: 23px;\">"
									+ "<span class=\"cbboxEntry\" style=\"width: 80px;\">"
										+ "<input type=\"checkbox\" name=\"rightClickActionType_"+theId+"\" value=\"1\" onclick=\"MADEMobile50Head_ChangeRATRightClick(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4353)+"</span>"  //输入脚本
									+ "</span>"
									+ "<span class=\"cbboxEntry\" style=\"width: 80px;\">"
										+ "<input type=\"checkbox\" name=\"rightClickActionType_"+theId+"\" value=\"2\" onclick=\"MADEMobile50Head_ChangeRATRightClick(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4351)+"</span>"  //添加菜单
									+ "</span>"
								+ "</div>"
							+ "</div>"
							
							+ "<div class=\"MADEMobile50Head_BaseInfo_Entry rightClickContent\"  id=\"rightClickContent_"+theId+"_1\">"
								+ "<div class=\"MADEMobile50Head_BaseInfo_Entry_Content\" style=\"padding-left: 68px;\">"
									+ "<div class=\"btn_click_desc\" onclick=\"MADEMobile50Head_addRightClickEvent('"+theId+"')\">"
										+ "<input  id=\"rightAction_JS_"+theId+"\" type=\"hidden\" value=\"\">"+SystemEnv.getHtmlNoteName(4178)  //单击事件
									+ "</div>"
								+ "</div>"
							+ "</div>"
							
							+ "<div class=\"rightClickContent\" id=\"rightClickContent_"+theId+"_2\"  style=\"display: none;\">"
								+ "<div class=\"menu_list_title\">"
									+ "<div class=\"menu_list_add\" onclick=\"MADEMobile50Head_AddMenu('"+theId+"','2');\">"+SystemEnv.getHtmlNoteName(4351)+"</div>"  //添加菜单
								+ "</div>"
								+ "<div class=\"menu_list_content2\">"
									+ "<div class=\"menu_list_empty_tip2\">"+SystemEnv.getHtmlNoteName(4352)+"</div>"  //单击右上角的添加按钮以添加菜单
									+ "<ul id=\"rightUL\"></ul>"
								+ "</div>"
							+ "</div>"
						+ "</div>"
				+ "</div>"
		
		   + "</div>";
	htm += "<div class=\"MADEMobile50Head_Bottom\"><div class=\"MADEMobile50Head_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.EMobile50Head.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var leftAction_JS = this.mecJson["leftAction_JS"];
	$("#leftAction_JS_"+theId).val(leftAction_JS);
	
	var leftActionType = this.mecJson["leftActionType"];
	if(leftActionType == "1"){
		$("input[type='checkbox'][name='leftActionType_"+theId+"']").attr("checked","checked");
		$("#leftActionContent_"+theId).show();
	}
	
	var leftPicpath = this.mecJson["leftPicpath"];
	if(leftPicpath!="" && leftPicpath!="undefined"){
		$("#previewImg_left_"+theId).attr("src", leftPicpath).show();
		$("#picpath_left_"+theId).val(leftPicpath);
	}
	
	var middlePageName = this.mecJson["middlePageName"];
	$("#middlePageName_"+theId).val(middlePageName);
	
	var $attrContainer = $("#MADEMobile50Head_"+theId);

	var menu_datas = this.mecJson["menu_datas"];
	if(!menu_datas){
		menu_datas = [];
	}
	if(menu_datas.length == 0){
		$(".menu_list_empty_tip", $attrContainer).show();
	}
	for(var i = 0; menu_datas && i < menu_datas.length; i++){
		MADEMobile50Head_AddMenuToPage(theId, menu_datas[i], "");
	}
	
	var middleActionType = this.mecJson["middleActionType"];
	if(middleActionType == "1"){
		$("input[type='checkbox'][name='middleActionType_"+theId+"']").attr("checked","checked");
		$("#middleActionContent_"+theId).show();
	}
	
	var rightClickActionTypeV = Mec_FiexdUndefinedVal(this.mecJson["rightClickActionType"], 1);
	var $rightClickActionType = $("input[type='checkbox'][name='rightClickActionType_"+theId+"'][value='"+rightClickActionTypeV+"']");
	if($rightClickActionType.length > 0){
		$rightClickActionType.attr("checked", "checked");
		$rightClickActionType.triggerHandler("click");
	}
	
	var menu_datas2 = this.mecJson["menu_datas2"];
	if(!menu_datas2){
		menu_datas2 = [];
	}
	if(menu_datas2.length == 0){
		$(".menu_list_empty_tip2", $attrContainer).show();
	}
	for(var i = 0; menu_datas2 && i < menu_datas2.length; i++){
		MADEMobile50Head_AddMenuToPage(theId, menu_datas2[i], 2);
	}
	
	var rightAction_JS = this.mecJson["rightAction_JS"];
	$("#rightAction_JS_"+theId).val(rightAction_JS);
	
	var rightActionType = this.mecJson["rightActionType"];
	if(rightActionType == "1"){
		$("input[type='checkbox'][name='rightActionType_"+theId+"']").attr("checked","checked");
		$("#rightActionContent_"+theId).show();
	}
	
	var rightPicpath = this.mecJson["rightPicpath"];
	if(rightPicpath!="" && rightPicpath!="undefined"){
		$("#previewImg_right_"+theId).attr("src", rightPicpath).show();
		$("#picpath_right_"+theId).val(rightPicpath);
	}
	
	MADEMobile50Head_BindEvent(theId);
	
	$("#MADEMobile50Head_"+theId).jNice();
	
	MLanguage({
		container: $("#MADEMobile50Head_"+theId)
    });
};

/*获取JSON*/
MEC_NS.EMobile50Head.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADEMobile50Head_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["leftActionType"] = $("input[type='checkbox'][name='leftActionType_"+theId+"']").is(':checked') ? "1" : "0";
		this.mecJson["leftAction_JS"] = $("#leftAction_JS_"+theId).val();
		this.mecJson["leftPicpath"] = $("#picpath_left_"+theId).val();
		this.mecJson["middleActionType"] = $("input[type='checkbox'][name='middleActionType_"+theId+"']").is(':checked') ? "1" : "0";

		this.mecJson["middlePageName"] = MLanguage.getValue($("#middlePageName_"+theId)) || $("#middlePageName_"+theId).val();
		var menu_datas = this.mecJson["menu_datas"];
		if(!menu_datas){
			menu_datas = [];
		}
		var $MenuLi = $(".menu_list_content > ul > li", $attrContainer);
		$MenuLi.each(function(){
			var liId = $(this).attr("id");
			if(liId && liId != ""){
				var menuId = liId.substring("li_".length);
				var menuText = $("input[name='menuText']", $(this)).val();
				var menuTextML = MLanguage.getValue($("input[name='menuText']", $(this)));
				var menuScript = $("#menuScript_"+menuId, $(this)).val();
				for(var i = 0; i < menu_datas.length; i++){
					if(menu_datas[i]["id"] == menuId){
						menu_datas[i]["menuText"] = menuTextML || menuText;
						menu_datas[i]["menuScript"] = menuScript;
						break;
					}
				}
			}
		});
		
		this.mecJson["rightActionType"] = $("input[type='checkbox'][name='rightActionType_"+theId+"']").is(':checked') ? "1" : "0";
		
		var rightClickActionType = $("input[type='checkbox'][name='rightClickActionType_"+theId+"']:checked").val();
		this.mecJson["rightClickActionType"] = rightClickActionType;
		
		var menu_datas2 = this.mecJson["menu_datas2"];
		if(!menu_datas2){
			menu_datas2 = [];
		}
		var $MenuLi2 = $(".menu_list_content2 > ul > li", $attrContainer);
		$MenuLi2.each(function(){
			var liId = $(this).attr("id");
			if(liId && liId != ""){
				var menuId = liId.substring("li_".length);
				var menuText = $("input[name='menuText']", $(this)).val();
				var menuTextML = MLanguage.getValue($("input[name='menuText']", $(this)));
				var menuScript = $("#menuScript_"+menuId, $(this)).val();
				for(var i = 0; i < menu_datas2.length; i++){
					if(menu_datas2[i]["id"] == menuId){
						menu_datas2[i]["menuText"] = menuTextML || menuText;
						menu_datas2[i]["menuScript"] = menuScript;
						break;
					}
				}
			}
		});
		
		this.mecJson["rightAction_JS"] = $("#rightAction_JS_"+theId).val();
		this.mecJson["rightPicpath"] = $("#picpath_right_"+theId).val();
	}
	return this.mecJson;
};

MEC_NS.EMobile50Head.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["leftActionType"] = "0";
	defMecJson["leftAction_JS"] = "";
	defMecJson["leftPicpath"] = "";
	defMecJson["middlePageName"] = "";
	defMecJson["middleActionType"] = "0";
	defMecJson["menu_datas"] = [];
	defMecJson["rightActionType"] = "0";
	defMecJson["rightClickActionType"] = 1;
	defMecJson["menu_datas2"] = [];
	defMecJson["rightAction_JS"] = "";
	defMecJson["rightPicpath"] = "";
	
	return defMecJson;
};

function MADEMobile50Head_BindEvent(mec_id){
	//根据顶部区域区分当前操作的是左侧按钮、标题、右侧按钮
	$("#MADEMobile50Head_"+mec_id+" > .MADEMobile50Head_Title > span").click(function(){
		if(!$(this).hasClass("chosed")){
			$("#MADEMobile50Head_"+mec_id+" > .MADEMobile50Head_Title > span").removeClass("chosed");
			$(this).addClass("chosed");
			var typeV = $(this).attr("typeV");
			$("#MADEMobile50Head_"+mec_id+" > .MADEMobile50Head_BaseInfo > div").hide();
			$("#MADEMobile50Head_"+mec_id+" > .MADEMobile50Head_BaseInfo > div.MADEMobile50Head_BaseInfo_" + typeV).show();
		}
	});
}

function addPic(obj){
	var pic_pathV = $("#picpath_" + obj).val();
	var url = "/mobilemode/picset.jsp?pic_path="+pic_pathV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4117);  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		$("#picpath_" + obj).val(picPath);
		$("#previewImg_" + obj).show().attr("src", picPath);
	};
}

function MADEMobile50Head_ChangeRATLeft(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(!cbObj.checked){
			$("#leftActionContent_" + mec_id).hide();
		}else{
			$("#leftActionContent_" + mec_id).show();
		}
	},100);
}

function MADEMobile50Head_ChangeRATMiddle(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(!cbObj.checked){
			$("#middleActionContent_" + mec_id).hide();
		}else{
			$("#middleActionContent_" + mec_id).show();
		}
	},100);
}

function MADEMobile50Head_ChangeRATRight(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(!cbObj.checked){
			$("#rightActionContent_" + mec_id).hide();
		}else{
			$("#rightActionContent_" + mec_id).show();
		}
	},100);
}

function MADEMobile50Head_AddMenu(mec_id, flag){
	var result = {};
	result["id"] = new UUID().toString();
	result["menuText"] = "";
	result["menuScript"] = "";
	
	MADEMobile50Head_AddMenuToPage(mec_id, result, flag);
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var menu_datas = mecHandler.mecJson["menu_datas"+flag];
	if(!menu_datas){
		menu_datas = [];
		mecHandler.mecJson["menu_datas"+flag] = menu_datas;
	}
	menu_datas.push(result);
}

function MADEMobile50Head_AddMenuToPage(mec_id, result, flag){
	
	var $attrContainer = $("#MADEMobile50Head_"+mec_id);
	
	$(".menu_list_empty_tip"+flag, $attrContainer).hide();
	
	var $ul = $(".menu_list_content"+flag+" > ul", $attrContainer);
	var $li = $("<li id=\"li_"+result["id"]+"\"></li>");
	var htm = "<table>";
	    htm += "<tbody>";
	    	htm += "<tr>";
	    	
			    htm += "<td width=\"100px\" align=\"middle\">";
			    	htm += "<input name=\"menuText\" type=\"text\" class=\"MADEMobile50Head_Text\" style=\"height:22px;line-height:10px;\" value=\""+result["menuText"]+"\" data-multi=false placeholder=\""+SystemEnv.getHtmlNoteName(4354)+"\"/>";  //菜单名称
			    htm += "</td>";
			    
			    htm += "<td width=\"230px\">";
					htm += "<div class=\"menu_click_desc\">";
						htm += "<input id=\"menuScript_"+result["id"]+"\" type=\"hidden\" value=\"\"/>";
						htm += SystemEnv.getHtmlNoteName(4355);  //跳转链接
					htm += "</div>";
				htm += "</td>";
				
				htm += "<td align=\"right\">";
					htm += "<span class=\"inparam_menu_del\" onclick=\"MADEMobile50Head_deleteOneMenuOnPage('"+mec_id+"','"+result["id"]+"','"+flag+"')\"></span>";
				htm += "</td>";
				
			htm += "</tr>";
		htm += "</tbody>";
	htm += "</table>";
	$li.html(htm);
	$ul.append($li);
	
	$("#menuScript_"+result["id"], $li)[0].value = result["menuScript"];
	
	$(".menu_click_desc", $li).click(function(){
		var $this = $(this);
		var $menuScript = $("#menuScript_"+result["id"], $this);
		SL_AddScriptToField($menuScript);
	});

	MLanguage({
		container: $li
    });
}

function MADEMobile50Head_deleteOneMenuOnPage(mec_id, id, flag){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var menu_datas = mecHandler.mecJson["menu_datas"+flag];
	if(!menu_datas){
		menu_datas = [];
	}
	var index = -1;
	for(var i = 0; i < menu_datas.length; i++){
		var data = menu_datas[i];
		if(data["id"] == id){
			index = i;
			break;
		}
	}
	if(index != -1){
		menu_datas.splice(index, 1);
	}
	
	$("#li_" + id).remove();
	
	if(menu_datas.length == 0){
		var $attrContainer = $("#MADEMobile50Head_"+mec_id);
		$(".menu_list_empty_tip"+flag, $attrContainer).show();
	}
}

function MADEMobile50Head_addLeftClickEvent(mec_id){
	var $btnScript = $("#leftAction_JS_"+mec_id);
	SL_AddScriptToField($btnScript);
}
function MADEMobile50Head_addRightClickEvent(mec_id){
	var $btnScript = $("#rightAction_JS_"+mec_id);
	SL_AddScriptToField($btnScript);
}

function MADEMobile50Head_ChangeRATRightClick(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='rightClickActionType_"+mec_id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		$("#MADEMobile50Head_"+mec_id+" .rightClickContent").hide();
		$("#rightClickContent_" + mec_id + "_" + objV).show();
	},100);
}