if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.NavPanel = function(typeTmp, idTmp, mecJsonTmp){
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
MEC_NS.NavPanel.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.NavPanel.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var row = Mec_FiexdUndefinedVal(this.mecJson["row"], "2");
	if(row == "" || isNaN(row)){
		row = 2;
	}else{
		row = parseInt(row);
	}
	
	var col = Mec_FiexdUndefinedVal(this.mecJson["col"], "4");
	if(col == "" || isNaN(col)){
		col = 4;
	}else{
		col = parseInt(col);
	}
	
	var iconClass = "";
	var radius = Mec_FiexdUndefinedVal(this.mecJson["radius"]);
	if(radius == "1"){
		iconClass += " radius-icon";
	}
	
	
	var nav_items = this.getNavItems();
	
	var screenNum = row * col;
	var screenItems = new Array();
	var pageArr;
	var rowArr;
	for(var i = 0; i < nav_items.length; i++){
		if(i % screenNum == 0){
			pageArr = new Array();
			screenItems.push(pageArr);
		}
		
		if(i % col == 0){
			rowArr = new Array();
			pageArr.push(rowArr);
		}
		rowArr.push(nav_items[i]);
	}
	
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	htmTemplate = htmTemplate.replace(/\${theId}/g, theId);
	
	var forStart;
	while((forStart = htmTemplate.indexOf("$mec_forstart$")) != -1){
		var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
		var forTemplate = "";
		var forContentTemplate = "";
		if(forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
			forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
			var forHtml = "";
			
			for(var k = 0; k < screenItems.length; k++){
				
				var rows_items = screenItems[k];
				
				var row_forStart;
				if((row_forStart = htmTemplate.indexOf("$mec_row_forstart$")) != -1){
					var row_forEnd = htmTemplate.indexOf("$mec_row_forend$", row_forStart);
					if(row_forEnd != -1){
						var row_forTemplate = htmTemplate.substring(row_forStart, row_forEnd + "$mec_row_forend$".length);
						var row_forContentTemplate = htmTemplate.substring(row_forStart + "$mec_row_forstart$".length, row_forEnd);
						var row_forHtml = "";
						
						var col_forStart;
						if((col_forStart = row_forTemplate.indexOf("$mec_col_forstart$")) != -1){
							var col_forEnd = row_forTemplate.indexOf("$mec_col_forend$", col_forStart);
							if(col_forEnd != -1){
								var col_forTemplate = row_forTemplate.substring(col_forStart, col_forEnd + "$mec_col_forend$".length);
								var col_forContentTemplate = row_forTemplate.substring(col_forStart + "$mec_col_forstart$".length, col_forEnd);
								
								for(var r = 0; r < rows_items.length; r++){
									
									var row_item = rows_items[r];
									var col_forHtml = "";
									
									for(var c = 0; c < row_item.length; c++){
										
										var uiid = row_item[c]["uiid"];
										var uiname = row_item[c]["uiname"];
										var iconpath = row_item[c]["iconpath"];
										
										var action = "";
										
										var isremind = row_item[c]["isremind"];
										var reminddisplay = (isremind == "1") ? "inline-block" : "none";
										var remindnum = "N";
										var remindclass = "MEC_NumberRemind1";
										
										col_forHtml += col_forContentTemplate.replace("${iconpath}", iconpath)
															.replace("${uiname}", uiname)
															.replace("${action}", action)
															.replace("${reminddisplay}", reminddisplay)
															.replace("${remindnum}", remindnum)
															.replace("${remindclass}", remindclass)
															.replace("${iconClass}", iconClass);
									}
									row_forHtml += row_forContentTemplate.replace(col_forTemplate, col_forHtml);
								}
							}
						}
							
						forHtml += forContentTemplate.replace(row_forTemplate, row_forHtml);
					}
					break;
				}else{
					if(screenItems.length == 1){
						forHtml = "";
					}else{
						var pointClass = (k == 0) ? "currPoint" : "";
						forHtml += forContentTemplate.replace("${pointClass}", pointClass);
					}
				}
			}
			
			htmTemplate = htmTemplate.replace(forTemplate, forHtml);
		}else{
			break;
		}
	}
	return htmTemplate;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.NavPanel.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	var $container = $("#NMEC_"+theId);
	$container.css("visibility", "visible");
	
	var sildeCount = $container.find(".navPanel-point b").length;
	if(sildeCount <= 1){
		$(".navPanel-point", $container).hide();
	}
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.NavPanel.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var nav_items = this.getNavItems();
	var htm = "<div id=\"MADNavPanel_"+theId+"\">";
	htm += "<div class=\"MADNP_Title\">"+SystemEnv.getHtmlNoteName(4650)+"</div>" 
		 + "<div class=\"MADNP_BaseInfo\">"
			+ "<div>"
				+ "<span style=\"width: 70px;text-align: left;display: inline-block;\">"+SystemEnv.getHtmlNoteName(4247)+"</span>" //每页显示：
				+ "<span style=\"position: relative;display: inline-block;\"><input type=\"text\" id=\"row_"+theId+"\" class=\"MADNP_Text\" style=\"width: 225px;\"></input><div style=\"position: absolute;top: 6px;right: 6px;\">"+SystemEnv.getHtmlNoteName(3886)+"</div></span>"//行  
			+ "</div>"
			+ "<div>"
				+ "<span style=\"width: 70px;text-align: left;display: inline-block;\">"+SystemEnv.getHtmlNoteName(4937)+"</span>" //每行显示：
				+ "<span style=\"position: relative;display: inline-block;\"><input type=\"text\" id=\"col_"+theId+"\" class=\"MADNP_Text\" style=\"width: 225px;\"></input><div style=\"position: absolute;top: 6px;right: 6px;\">"+SystemEnv.getHtmlNoteName(3887)+"</div></span>" //列 
			+ "</div>"
			+ "<div>"
				+ "<span style=\"width: 70px;text-align: left;display: inline-block;\">"+SystemEnv.getHtmlNoteName(4938)+"</span>" //图标圆角：
				+ "<input type=\"checkbox\" id=\"radius_"+theId+"\" value=\"1\"/>"+SystemEnv.getHtmlNoteName(4939)+"" //显示图标时使用圆角化处理 
			+ "</div>"
		
		 + "</div>";
	
	htm += "<table id=\"MADNP_Table_"+theId+"\" class=\"MADNP_Table\">"
				+ "<thead>"
					+ "<tr>"
						+ "<td></td>"
						+ "<td>"+SystemEnv.getHtmlNoteName(4111)+"</td>"  //图标
						+ "<td>"+SystemEnv.getHtmlNoteName(3539)+"</td>"  //显示名称
						+ "<td>"+SystemEnv.getHtmlNoteName(4112)+"</td>"  //来源
						+ "<td>"+SystemEnv.getHtmlNoteName(3621)+"</td>"  //提示
					+ "</tr>"
				+ "</thead>"
				+ "<tbody>";
				
	for(var i = 0; i < nav_items.length; i++){
		htm += MADNP_CreateRow(i, theId);
	}
	
	htm += "</tbody></table>";
	htm += "<div class=\"MADNP_Bottom\">"
			  + "<div class=\"MADNP_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4114)+"</div>"  //确&nbsp;定
			  + "<span class=\"MADNP_AddItem\" onclick=\"MADNP_AddRow('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</span>"  //添加
		 + "</div>";
	htm += "</div>";	 
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.NavPanel.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var row = Mec_FiexdUndefinedVal(this.mecJson["row"], "2");
	$("#row_"+theId).val(row);
	
	var col = Mec_FiexdUndefinedVal(this.mecJson["col"], "4");
	$("#col_"+theId).val(col);
	
	var radius = Mec_FiexdUndefinedVal(this.mecJson["radius"]);
	if(radius == "1"){
		$("#radius_"+theId).attr("checked","checked");
	}
	
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
		
		$("#pic_path_"+i+"_"+theId).val(iconpath);
		$("#pic_type_"+i+"_"+theId).val(icontype);
		
		MADNP_SetPicPath(i, theId, iconpath);
		
		$("#source_"+i+"_"+theId).val(source);
		$("#ui_"+i+"_"+theId).val(uiid);
		if(source==1){
			$("#uiview_"+i+"_"+theId).val(getCommonNavNameByUid(uiid));
		}else if(source==2){
			$("#uiview_"+i+"_"+theId).val(custom);
		}else if(source==3){
			$("#uiview_"+i+"_"+theId).val("脚本");
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
		
		nav_uiviewBind(i,theId);
	}
	
	MADNP_TriggerTable(theId);
	
	$("#MADNavPanel_"+theId).jNice();
	
	$("#MADNP_Table_"+theId + " > tbody").sortable({
		revert: false,
		axis: "y",
		items: "tr",
		handle: ".bemove"
	});
	
	MLanguage({
		container: $("#MADNP_Table_"+theId + " > tbody")
    });
};
/*获取JSON*/
MEC_NS.NavPanel.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
		
	var $attrTable = $("#MADNP_Table_"+theId);
	if($attrTable.length > 0){
		
		this.mecJson["row"] = $("#row_"+theId).val();
		this.mecJson["col"] = $("#col_"+theId).val();
		this.mecJson["radius"] = $("#radius_"+theId).is(':checked') ? "1" : "0";
		
		var nav_items = [];
		$("#MADNP_Table_"+theId + " > tbody > tr").each(function(i){
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
			
			nav_items.push(n_item);
		});
		this.mecJson["nav_items"] = nav_items;
	}
	return this.mecJson;
};

MEC_NS.NavPanel.prototype.getNavItems = function(){
	var nav_items = this.mecJson["nav_items"];
	if(!nav_items){
		//通过转换生成新的数组对象，避免直接操作公共array的元素属性而影响其他插件的引用。
		var tmpStr = JSON.stringify(common_mec_nav_items);
		var tmpArr = $.parseJSON(tmpStr);
		
		tmpArr = tmpArr.slice(0, 8);
		
		for(var i = 0; i < tmpArr.length; i++){
			var pf = (i + 1);
			if(pf < 10){
				pf = "0" + pf;
			}
			tmpArr[i]["iconpath"] = "/mobilemode/piclibrary/icon2/c"+pf+"_wev8.png";
			tmpArr[i]["icontype"] = "1";	//网址获取
			tmpArr[i]["iconstyle"] = "0";	//自定义大小
		}
		
		nav_items = tmpArr;
	}
	return nav_items;
};

function MADNP_TriggerTable(mec_id){
	$("#MADNP_Table_"+mec_id + " > tbody > tr").each(function(i){
		var rowIndex = $(this).attr("rowIndex");
		MADNP_TriggerTableRow(rowIndex, mec_id);
	});
}

function MADNP_TriggerTableRow(rowIndex, mec_id){
	MADNP_SourceChange(rowIndex, mec_id);
	MADNP_IsremindChange(rowIndex, mec_id);
}

function MADNP_SourceChange(rowIndex, mec_id){
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

function MADNP_IsremindChange(rowIndex, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var $numremindEditFlag = $("#numremindEditFlag_"+rowIndex+"_"+mec_id);
		$("#isremind_"+rowIndex+"_"+mec_id).is(':checked') ? $numremindEditFlag.show() : $numremindEditFlag.hide();
	},100);
}

function MADNP_NumremindEdit(rowIndex, mec_id){
	var remindtypeV = $("#remindtype_"+rowIndex+"_"+mec_id).val();
	
	var remindsqlV = $("#remindsql_"+rowIndex+"_"+mec_id).val();
	remindsqlV = $m_encrypt(remindsqlV);
	
	var reminddatasourceV = $("#reminddatasource_"+rowIndex+"_"+mec_id).val();
	var remindjavafilenameV = $("#remindjavafilename_"+rowIndex+"_"+mec_id).val();
	
	var url = "/mobilemode/numremind.jsp?remindtype="+remindtypeV+"&reminddatasource="+reminddatasourceV+"&remindsql="+remindsqlV+"&remindjavafilename="+remindjavafilenameV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.normalDialog = false;
	dlg.Width = 500;//定义长度
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

function MADNP_DelRow(rowIndex, mec_id){
	$("#MADNP_Table_"+mec_id + " > tbody > tr[rowIndex='"+rowIndex+"']").remove();
}

function MADNP_AddRow(mec_id){
	var maxRowIndex = 0;
	$("#MADNP_Table_"+mec_id + " > tbody > tr").each(function(i){
		var rowIndex = parseInt($(this).attr("rowIndex"));
		if(rowIndex > maxRowIndex){
			maxRowIndex = rowIndex;
		}
	});
	var currRowIndex = maxRowIndex + 1;
	
	var htm = MADNP_CreateRow(currRowIndex, mec_id);
	
	var $newRow = $(htm);
	
	$("#MADNP_Table_"+mec_id + " > tbody").append($newRow);
	
	$newRow.jNice();
	
	MADNP_TriggerTableRow(currRowIndex, mec_id);
	
	MADNP_SetPicPath(currRowIndex, mec_id, "");
	
	nav_uiviewBind(currRowIndex,mec_id);
			
	MLanguage({
		container: $newRow
    });
}
			        						        			
function MADNP_CreateRow(currRowIndex, mec_id){
	var htm = 
		"<tr rowIndex=\""+currRowIndex+"\">"
			+ "<td class=\"bemove\" width=\"7%\"></td>"
			+ "<td width=\"10%\">" 
			+ "<div class=\"MADNP_Toolbar_Item_Img\" onclick=\"MADNP_PicSet("+currRowIndex+",'"+mec_id+"');\">"
				+ "<img id=\"pic_img_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"pic_type_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"pic_path_"+currRowIndex+"_"+mec_id+"\"/>"
			+ "</div> "
			+ "</td>"
			+ "<td width=\"28%\"><input id=\"uiname_"+currRowIndex+"_"+mec_id+"\" type=\"text\" class=\"textStyle\" data-multi=false />" 
			+ "</td>"
			+ "<td width=\"43%\">"
				+ "<div class=\"sbHolder\" style=\"display: inline-block; width: 136px;border: 1px solid #dfdfdf\"><a href=\"javascript:void(0);\" onclick=\"javascript:selectnav(this,"+currRowIndex+",'"+mec_id+"');\" class=\"sbToggle sbToggle-btc\"></a>"
				+ "<input id=\"uiview_"+currRowIndex+"_"+mec_id+"\" style=\"border: 0px none rgb(255, 255, 255); width: 116px !important; height: 18px; font-size: 12px; text-indent: 0px;padding-left: 2px;\" autocomplete=\"off\" onclick=\"javascript:nav_stopEventClink(this,"+currRowIndex+",'"+mec_id+"');\">"
				+ "<input id=\"ui_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\" />"
				+ "<input id=\"source_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\" />"
				+ "<input id=\"custom_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\"/>"
				+ "<input id=\"jscode_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\"/>"
			+ "</div>"
			+ "</td>"
			+ "<td width=\"10%\" style=\"position: relative;\"><input type=\"checkbox\" id=\"isremind_"+currRowIndex+"_"+mec_id+"\" value=\"1\" onclick=\"MADNP_IsremindChange("+currRowIndex+",'"+mec_id+"');\"/>"
				+ "<input type=\"hidden\" id=\"remindtype_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"remindsql_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"reminddatasource_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"remindjavafilename_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<div id=\"numremindEditFlag_"+currRowIndex+"_"+mec_id+"\" class=\"numremindEditFlag\" onclick=\"MADNP_NumremindEdit("+currRowIndex+",'"+mec_id+"');\"></div>"
				+ "<div class=\"delFlag\" onclick=\"MADNP_DelRow("+currRowIndex+",'"+mec_id+"');\"></div>"
			+ "</td>"
		+ "</tr>";
	return htm;
}

function MADNP_getUISelectOptionHtml(){
	var htm = "";
	for(var i = 0; i < common_mec_nav_items.length; i++){
		var uiid = common_mec_nav_items[i]["uiid"];
		var uiname = common_mec_nav_items[i]["uiname"];
		htm += "<option value=\""+uiid+"\">"+uiname+"</option>";
	}
	return htm;
}
function MADNP_PicSet(rowIndex, mec_id){
	var pic_typeV = MADNP_IsNvl($("#pic_type_"+rowIndex+"_"+mec_id).val(),"0");
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
		
		MADNP_SetPicPath(rowIndex, mec_id, picPath);
	};
};

function MADNP_SetPicPath(rowIndex, mec_id, picPath){
	var $picImg = $("#pic_img_"+rowIndex+"_"+mec_id);
	if(picPath && picPath != ""){
		$picImg[0].src = picPath;
	}else{
		$picImg[0].src = "/mobilemode/images/mec/add-img-btn_wev8.png";
	}
}

function MADNP_IsNvl(str, dev){
	if (str == "") return dev;
	else return str;
}