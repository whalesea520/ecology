if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Navigation = function(typeTmp, idTmp, mecJsonTmp){
	this.type = typeTmp;
	if(!idTmp){
		idTmp = new UUID().toString();
	}
	this.id = idTmp;
	if(!mecJsonTmp){
		mecJsonTmp = {};
	}
	this.mecJson = mecJsonTmp;
}

/*获取id。 必需的方法*/
MEC_NS.Navigation.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Navigation.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var nav_items = this.getNavItems();
	var htm = "";
	if(nav_items.length == 0){
		htm = "<div class=\"noNavigation\">"+SystemEnv.getHtmlNoteName(4110)+"navigation</div>"; //未添加
	}else{
		var htmTemplate = getPluginContentTemplateById(this.type);
		var forTemplate = "";
		var forContentTemplate = "";
		var forStart = htmTemplate.indexOf("$mec_forstart$");
		var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
		if(forStart != -1 && forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
			forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
		}
		var forHtml = "";
		//var htm = "<table class=\"homepage_content\"><tbody>";
		for(var i = 0; i < nav_items.length; i++){
			var iconpath = nav_items[i]["iconpath"];
			var uiid = nav_items[i]["uiid"];
			var uiname = nav_items[i]["uiname"];
			var isgroup = nav_items[i]["isgroup"];
			var className = (isgroup == "1") ? "group" : "";
			className += (iconpath == "") ? " no-img" : "";
			var action = "";
			var isremind = nav_items[i]["isremind"];
			var reminddisplay = isremind == "1" ? "inline-block" : "none";
			var remindnum = "N";
			var remindclass = "MEC_NumberRemind1";
			forHtml += forContentTemplate.replace("${iconpath}", iconpath)
								.replace("${uiname}", uiname)
								.replace("${className}", className)
								.replace("${action}", action)
								.replace("${reminddisplay}", reminddisplay)
								.replace("${remindnum}", remindnum)
								.replace("${remindclass}", remindclass);
			/*
			htm += "<tr class=\"menu"+extClass+"\">"
		           + "<td width=\"50\">"
		                + "<img src=\""+iconpath+"\"/>"
		           + "</td>"
		           + "<td>"
		                + uiname
		           + "</td>"
		           + "<td width=\"55\">"
		                + "<img src=\"/mobilemode/images/homepage/homepage_right_wev8.png\"/>"
		           + "</td>"
		        + "</tr>";
		    */
		}
		//htm += "</tbody></table>";
		htm = htmTemplate.replace(forTemplate, forHtml);
	}
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Navigation.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var nav_items = this.getNavItems();
	
	var htm = "<table id=\"MADN_Table_"+theId+"\" class=\"MADN_Table\">"
				+ "<thead>"
					+ "<tr>"
						+ "<td></td>"
						+ "<td>"+SystemEnv.getHtmlNoteName(4111)+"</td>"   //图标
						+ "<td>"+SystemEnv.getHtmlNoteName(3539)+"</td>"   //显示名称
						+ "<td>"+SystemEnv.getHtmlNoteName(4112)+"</td>"   //来源
						+ "<td>"+SystemEnv.getHtmlNoteName(3621)+"</td>"   //提示
						+ "<td>"+SystemEnv.getHtmlNoteName(4113)+"</td>"   //分组
					+ "</tr>"
				+ "</thead>"
				+ "<tbody>";
				
	for(var i = 0; i < nav_items.length; i++){
		var iconpath = nav_items[i]["iconpath"];
		var uiid = nav_items[i]["uiid"];
		var uiname = nav_items[i]["uiname"];
		htm += MADN_CreateRow(i, theId);
	}
	
	htm += "</tbody></table>";
	htm += "<div class=\"MADN_Bottom\">"
			  + "<div class=\"MADN_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4114)+"</div>"   //确&nbsp;定
			  + "<span class=\"MADN_AddItem\" onclick=\"MADN_AddRow('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</span>"  //添加
		 + "</div>";
		 
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Navigation.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var nav_items = this.getNavItems();
	
	for(var i = 0; i < nav_items.length; i++){
		var iconpath = nav_items[i]["iconpath"];
		var icontype = nav_items[i]["icontype"];
		var uiid = nav_items[i]["uiid"];
		var uiname = nav_items[i]["uiname"];
		var source = nav_items[i]["source"];
		var custom = nav_items[i]["custom"];
		var jscode = nav_items[i]["jscode"];
		var isremind = nav_items[i]["isremind"];
		
		var remindtype = nav_items[i]["remindtype"];
		var remindsql = nav_items[i]["remindsql"];
		var reminddatasource = nav_items[i]["reminddatasource"];
		var remindjavafilename = nav_items[i]["remindjavafilename"];
		var isgroup = nav_items[i]["isgroup"];
		
		$("#pic_path_"+i+"_"+theId).val(iconpath);
		$("#pic_type_"+i+"_"+theId).val(icontype);
		
		MADN_SetPicPath(i, theId, iconpath);
		
		$("#source_"+i+"_"+theId).val(source);
		$("#ui_"+i+"_"+theId).val(uiid);
		if(source==1){
			$("#uiview_"+i+"_"+theId).val(getCommonNavNameByUid(uiid));
		}else if(source==2){
			$("#uiview_"+i+"_"+theId).val(custom);
		}else if(source==3){
			$("#uiview_"+i+"_"+theId).val(SystemEnv.getHtmlNoteName(4634));  //脚本
		}
		
		$("#custom_"+i+"_"+theId).val(custom);
		$("#jscode_"+i+"_"+theId).val(jscode);
		$("#uiname_"+i+"_"+theId).val(uiname);
		if(isremind == "1"){
			$("#isremind_"+i+"_"+theId).attr("checked","checked");
		}
		
		$("#remindtype_"+i+"_"+theId).val(remindtype);
		$("#remindsql_"+i+"_"+theId).val(remindsql);
		$("#reminddatasource_"+i+"_"+theId).val(reminddatasource);
		$("#remindjavafilename_"+i+"_"+theId).val(remindjavafilename);
		
		if(isgroup == "1"){
			$("#isgroup_"+i+"_"+theId).attr("checked","checked");
		}
		nav_uiviewBind(i,theId);
	}
	
	MADN_TriggerTable(theId);
	
	$("#MADN_Table_"+theId).jNice();
	
	$("#MADN_Table_"+theId + " > tbody").sortable({
		revert: false,
		axis: "y",
		items: "tr",
		handle: ".bemove"
	});
	
	MLanguage({
		container: $("#MADN_Table_"+theId + " > tbody")
    });
};
/*获取JSON*/
MEC_NS.Navigation.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
		
	var $attrTable = $("#MADN_Table_"+theId);
	if($attrTable.length > 0){
		var nav_items = [];
		$("#MADN_Table_"+theId + " > tbody > tr").each(function(i){
			var rowIndex = $(this).attr("rowIndex");
			var n_item = {};
			n_item["iconpath"] = $("#pic_path_"+rowIndex+"_"+theId).val();
			n_item["icontype"] = $("#pic_type_"+rowIndex+"_"+theId).val();
			n_item["source"] = $("#source_"+rowIndex+"_"+theId).val();
			n_item["uiid"] = $("#ui_"+rowIndex+"_"+theId).val();
			n_item["custom"] = $("#custom_"+rowIndex+"_"+theId).val();
			n_item["jscode"] = $("#jscode_"+rowIndex+"_"+theId).val();
			n_item["uiname"] = MLanguage.getValue($("#uiname_"+rowIndex+"_"+theId)) || $("#uiname_"+rowIndex+"_"+theId).val();
			n_item["isremind"] = $("#isremind_"+rowIndex+"_"+theId).is(':checked') ? "1" : "0";
			n_item["remindtype"] = $("#remindtype_"+rowIndex+"_"+theId).val();
			n_item["remindsql"] = $("#remindsql_"+rowIndex+"_"+theId).val();
			n_item["reminddatasource"] = $("#reminddatasource_"+rowIndex+"_"+theId).val();
			n_item["remindjavafilename"] = $("#remindjavafilename_"+rowIndex+"_"+theId).val();
			n_item["isgroup"] = $("#isgroup_"+rowIndex+"_"+theId).is(':checked') ? "1" : "0";
			
			nav_items.push(n_item);
		});
		this.mecJson["nav_items"] = nav_items;
	}
	return this.mecJson;
};

MEC_NS.Navigation.prototype.getNavItems = function(){
	var nav_items = this.mecJson["nav_items"];
	if(!nav_items){
		nav_items = getCommonNavItems(3);
	}
	return nav_items;
};

function MADN_TriggerTable(mec_id){
	$("#MADN_Table_"+mec_id + " > tbody > tr").each(function(i){
		var rowIndex = $(this).attr("rowIndex");
		MADN_TriggerTableRow(rowIndex, mec_id);
	});
}

function MADN_TriggerTableRow(rowIndex, mec_id){
	MADN_SourceChange(rowIndex, mec_id);
	MADN_IsremindChange(rowIndex, mec_id);
}

function MADN_SourceChange(rowIndex, mec_id){
	var sourceV = $("#source_"+rowIndex+"_"+mec_id).val();
	var $ui = $("#ui_"+rowIndex+"_"+mec_id);
	var $custom = $("#custom_"+rowIndex+"_"+mec_id);
	var $jscode = $("#jscode_"+rowIndex+"_"+mec_id);
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

function MADN_IsremindChange(rowIndex, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var $numremindEditFlag = $("#numremindEditFlag_"+rowIndex+"_"+mec_id);
		$("#isremind_"+rowIndex+"_"+mec_id).is(':checked') ? $numremindEditFlag.show() : $numremindEditFlag.hide();
	},100);
}

function MADN_NumremindEdit(rowIndex, mec_id){
	var remindtypeV = $("#remindtype_"+rowIndex+"_"+mec_id).val();
	
	var remindsqlV = $("#remindsql_"+rowIndex+"_"+mec_id).val();
	remindsqlV = $m_encrypt(remindsqlV);// 系统安全编码
	
	var reminddatasourceV = $("#reminddatasource_"+rowIndex+"_"+mec_id).val();
	var remindjavafilenameV = $("#remindjavafilename_"+rowIndex+"_"+mec_id).val();
	
	var url = "/mobilemode/numremind.jsp?remindtype="+remindtypeV+"&remindsql="+remindsqlV+"&reminddatasource="+reminddatasourceV+"&remindjavafilename="+remindjavafilenameV;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 500;//定义长度
	dlg.normalDialog = false;
	dlg.Height = 255;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4116);  //数字提醒
	dlg.show();
	dlg.hookFn = function(result){
		$("#remindtype_"+rowIndex+"_"+mec_id).val(result["remindtype"]);
		$("#remindsql_"+rowIndex+"_"+mec_id).val(result["remindsql"]);
		$("#reminddatasource_"+rowIndex+"_"+mec_id).val(result["reminddatasource"]);
		$("#remindjavafilename_"+rowIndex+"_"+mec_id).val(result["remindjavafilename"]);
	};
};

function MADN_DelRow(rowIndex, mec_id){
	$("#MADN_Table_"+mec_id + " > tbody > tr[rowIndex='"+rowIndex+"']").remove();
}

function MADN_AddRow(mec_id){
	var maxRowIndex = 0;
	$("#MADN_Table_"+mec_id + " > tbody > tr").each(function(i){
		var rowIndex = parseInt($(this).attr("rowIndex"));
		if(rowIndex > maxRowIndex){
			maxRowIndex = rowIndex;
		}
	});
	var currRowIndex = maxRowIndex + 1;
	
	var htm = MADN_CreateRow(currRowIndex, mec_id);
	
	var $newRow = $(htm);
	
	$("#MADN_Table_"+mec_id + " > tbody").append($newRow);
	
	$newRow.jNice();
	
	MADN_TriggerTableRow(currRowIndex, mec_id);
	
	MADN_SetPicPath(currRowIndex, mec_id, "");
	
	nav_uiviewBind(currRowIndex,mec_id);
	
	MLanguage({
		container: $newRow
    });
}
			        						        			
function MADN_CreateRow(currRowIndex, mec_id){
	var htm = 
		"<tr rowIndex=\""+currRowIndex+"\">"
			+ "<td class=\"bemove\" width=\"7%\"></td>"
			+ "<td width=\"10%\" style=\"position: relative;\"> " 
			+ "<div class=\"MADN_Navigation_Item_Img\" onclick=\"MADN_PicSet("+currRowIndex+",'"+mec_id+"');\">"
				+ "<img id=\"pic_img_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"pic_type_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"pic_path_"+currRowIndex+"_"+mec_id+"\"/>"
			+ "</div> "
			+ "<div class=\"delFlag\" id=\"iconDelFlag_"+currRowIndex+"_"+mec_id+"\" onclick=\"MADN_DelPicPath("+currRowIndex+",'"+mec_id+"');\" style=\"top:6px;right:6px;\"></div>"
			+ "</td>"
			+ "<td width=\"24%\"><input id=\"uiname_"+currRowIndex+"_"+mec_id+"\" type=\"text\" class=\"textStyle\" data-multi=false /></td>"
			+ "<td width=\"41%\">"
				+ "<div class=\"sbHolder\" style=\"display: inline-block; width: 130px;border: 1px solid #dfdfdf\"><a href=\"javascript:void(0);\" onclick=\"javascript:selectnav(this,"+currRowIndex+",'"+mec_id+"');\" class=\"sbToggle sbToggle-btc\"></a>"
					+ "<input id=\"uiview_"+currRowIndex+"_"+mec_id+"\" style=\"border: 0px none rgb(255, 255, 255); width: 110px !important; height: 18px; font-size: 12px; text-indent: 0px;padding-left: 2px;\" autocomplete=\"off\" onclick=\"javascript:nav_stopEventClink(this,"+currRowIndex+",'"+mec_id+"');\">"
					+ "<input id=\"ui_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\" />"
					+ "<input id=\"source_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\" />"
					+ "<input id=\"custom_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\"/>"
					+ "<input id=\"jscode_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\"/>"
				+ "</div>"
			+ "</td>"
			+ "<td width=\"9%\" style=\"position: relative;padding-left: 4px\"><input type=\"checkbox\" id=\"isremind_"+currRowIndex+"_"+mec_id+"\" value=\"1\" onclick=\"MADN_IsremindChange("+currRowIndex+",'"+mec_id+"');\"/>"
				+ "<input type=\"hidden\" id=\"remindtype_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"remindsql_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"reminddatasource_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"remindjavafilename_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<div id=\"numremindEditFlag_"+currRowIndex+"_"+mec_id+"\" class=\"numremindEditFlag\" onclick=\"MADN_NumremindEdit("+currRowIndex+",'"+mec_id+"');\"></div>"
			+ "</td>"
			+ "<td width=\"9%\" style=\"position: relative;padding-left: 2px\"><input type=\"checkbox\" id=\"isgroup_"+currRowIndex+"_"+mec_id+"\" value=\"1\"/>"
				+ "<div class=\"delFlag\" onclick=\"MADN_DelRow("+currRowIndex+",'"+mec_id+"');\"></div>"
			+ "</td>"
		+ "</tr>";
	return htm;
}

function MADN_getUISelectOptionHtml(){
	var htm = "";
	for(var i = 0; i < common_mec_nav_items.length; i++){
		var uiid = common_mec_nav_items[i]["uiid"];
		var uiname = common_mec_nav_items[i]["uiname"];
		htm += "<option value=\""+uiid+"\">"+uiname+"</option>";
	}
	return htm;
}

function MADN_PicSet(rowIndex, mec_id){
	var pic_typeV = MADN_IsNvl($("#pic_type_"+rowIndex+"_"+mec_id).val(),"0");
	var pic_pathV = $("#pic_path_"+rowIndex+"_"+mec_id).val();
	pic_pathV = encodeURIComponent(pic_pathV);
	var url = "/mobilemode/picset.jsp?pic_type="+pic_typeV+"&pic_path="+pic_pathV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4117);  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		$("#pic_type_"+rowIndex+"_"+mec_id).val(result["pic_type"]);
		$("#pic_path_"+rowIndex+"_"+mec_id).val(picPath);
		
		MADN_SetPicPath(rowIndex, mec_id, picPath);
	};
};

function MADN_SetPicPath(rowIndex, mec_id, picPath){
	var $picImg = $("#pic_img_"+rowIndex+"_"+mec_id);
	if(picPath && picPath != ""){
		$picImg[0].src = picPath;
		$("#iconDelFlag_"+rowIndex+"_"+mec_id).removeClass("MADN_Hide");
	}else{
		$("#iconDelFlag_"+rowIndex+"_"+mec_id).addClass("MADN_Hide");
		$picImg[0].src = "/mobilemode/images/mec/add-img-btn_wev8.png";
	}
}

function MADN_DelPicPath(rowIndex, mec_id){
	$("#pic_type_"+rowIndex+"_"+mec_id).val("");
	$("#pic_path_"+rowIndex+"_"+mec_id).val("");
	
	MADN_SetPicPath(rowIndex, mec_id, "");
}

function MADN_IsNvl(str, dev){
	if (str == "") return dev;
	else return str;
}