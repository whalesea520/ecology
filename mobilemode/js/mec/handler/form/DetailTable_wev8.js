if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.DetailTable = function(type, id, mecJson){
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
MEC_NS.DetailTable.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.DetailTable.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var tablename = this.mecJson["tablename"] || "";
	var htm = "";
	
	var fielddatas = this.mecJson["field_datas"] || [];
	if(tablename == ""){
		htm  = "<div class=\"Design_Form_Container\" style=\"height: 30px; \"><div class=\"Design_Form_Tip\">"+SystemEnv.getHtmlNoteName(4744)+"</div></div>"//明细表
	}else{
		var dataAdd = this.mecJson["datactrl_add"] || "";
		var dataDelete = this.mecJson["datactrl_delete"] || "";
		var htm  = "<div class=\"Design_DetailTable_FormPanel\">";
			htm +=		"<div class=\"Design_DetailTable_DataCtrlBtns\">";
			if(dataDelete == 1){
				htm += 		"<button type=\"button\" class=\"detailtable_btn\">"+SystemEnv.getHtmlNoteName(4756)+"</button>";//删除
			}
			if(dataAdd == 1){
				htm += 		"<button type=\"button\" class=\"detailtable_btn\">"+SystemEnv.getHtmlNoteName(4755)+"</button>";//添加
			}
			htm	+= 		"</div>";
			htm += 		"<div class=\"Design_DetailTable_Datadetails\">";
			htm += 			"<table class=\"DetailTable_Title\">";
			htm += 				"<thead>";
			htm += 					"<tr class=\"dt_title_tr\">";
								htm += "<td>"+SystemEnv.getHtmlNoteName(4757)+"</td>";//序号
								var fieldsize = fielddatas.length;
								for(var i = 0;i < fieldsize; i++){
									var fielddata = fielddatas[i];
									var fieldLabel = fielddata["fieldlabel"] || "";
									var fieldName = fielddata["fieldname"] || "";
									var fieldType = fielddata["fieldtype"] || "";
									var fieldWidth = fielddata["fieldwidth"] || "100";
									var style = "width:"+fieldWidth+"px;";
									//是否隐藏域
									if(fieldType == "8"){
										style = "display:none;";
									}
									htm += "<td style="+style+">"+fieldLabel+"</td>";
								}
			htm += 					"</tr>";
			htm += 				"</thead>";
			htm += 			"</table>";
			htm += 		"</div>";
			htm += "</div>";
	}
	
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.DetailTable.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "<div id=\"MADFDTABLE_"+theId+"\"  style=\"min-height: 240px;\">";
	htm += "<div class=\"MADF_Title\">"+SystemEnv.getHtmlNoteName(4729)+"</div>"   //表单信息
	 	+ "<div class=\"MADF_loading\">"
	 		+ "<span>"+SystemEnv.getHtmlNoteName(4317)+"</span>"  //数据加载中，请等待...
	 	+ "</div>";
	htm += "<div class=\"MADF_BaseInfo\">"
				+"<div>"
					+"<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4728)+"：</span>"  //所属主表：
				    +"<select class=\"MADF_Select\" id=\"formid_"+theId+"\" onchange=\"MADFDTABLE_MainTableChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
				+"</div>"
		
				+ "<div  id=\"sourceSearchWarp_"+theId+"\">"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4730)+"：</span>"  //子表表名：
					+ "<div id=\"tablenameContainer_"+theId+"\" style=\"display:inline-block;margin-bottom:0px;\">"
						+ "<select class=\"MADF_Select\" id=\"tablename_"+theId+"\" onchange=\"MADFDTABLE_TableChangeBefore('"+theId+"');\">"
						+ "</select>"
					+ "</div>"
					+ "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
						+ "<INPUT id=\"sourceSearch_"+theId+"\" class=\"MADF_SourceSearch\" type=\"text\"/>"
						+ "<div id=\"sourceSearchTip_"+theId+"\" class=\"MADF_SourceSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
					+ "</span>"
					+ "</span>"
				+ "</div>"
				
				+ "<div>"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4731)+"：</span>"  //关联字段：
					+ "<select class=\"MADF_Select\" id=\"relatekey_"+theId+"\">"
					+ "</select>"
				+ "</div>"
				
				+ "<div>"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4732)+"：</span>"  //子表主键：
					+ "<select class=\"MADF_Select\" id=\"dtablekey_"+theId+"\">"
					+ "</select>"
				+ "</div>"

				+ "<div>"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4733)+"：</span>"  //数据控制：
					+ "<span class=\"MADButton_style_content\">"
						+ "<span class=\"MADButton_style_title1 MADButton_style_title1"+styleL+"\">"
							+ "<input type=\"checkbox\" id=\"datactrl_add_"+theId+"\" value=\"0\"><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4734)+"</span>"  //允许新增
						+ "</span>"
						+ "<span class=\"MADButton_style_title1 MADButton_style_title1"+styleL+"\">"
							+ "<input type=\"checkbox\" id=\"datactrl_update_"+theId+"\" value=\"0\"><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4735)+"</span>"  //允许修改
						+ "</span>"
						+ "<span class=\"MADButton_style_title1 MADButton_style_title1"+styleL+"\">"
							+ "<input type=\"checkbox\" id=\"datactrl_delete_"+theId+"\" value=\"0\"><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4736)+"</span>"  //允许删除
						+ "</span>"
					+ "</span>"
				+ "</div>"
				+ "<div>"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4737)+"：</span>"  //内容高度：
					+ "<input type=\"text\" id=\"contentheight_"+theId+"\" style=\"width:80px;\" class=\"MADF_Text\" value=\"\"/>"
					+ "<span>（"+SystemEnv.getHtmlNoteName(4738)+"）</span>"
				+ "</div>"
			+ "</div>";
	htm += "<div class=\"MADF_BaseInfo MADF_Fields_Container\">"
			+ "<table class=\"Fields_Table\">"
				+ "<thead>"
					+ "<tr>"
						+ "<td width=\"4%\"></td>"      //字段
						+ "<td style=\"text-align:left\">"+SystemEnv.getHtmlNoteName(4739)+"</td>"      //字段
						+ "<td>"+SystemEnv.getHtmlNoteName(4740)+"</td>"  //显示名称
						+ "<td width=\"18%\">"+SystemEnv.getHtmlNoteName(4741)+"</td>"  //显示类型
						+ "<td width=\"25%\">"+SystemEnv.getHtmlNoteName(4742)+"</td>"  //字段类型
						+ "<td width=\"12%\">"+SystemEnv.getHtmlNoteName(4743)+"</td>"   //默认值
					+ "</tr>"
				+ "</head>"
				+ "<tbody>"
				+"</tbody>"
			+ "</table>"
			+ "<div class=\"detail_table_empty_tip\">"+SystemEnv.getHtmlNoteName(4747)+"</div>"//单击右下角添加按钮添加明细字段
		+  "</div>";
	
	htm += "<div id=\"sourceSearchResult_"+theId+"\" class=\"MADF_SourceSearchResult MADF_SourceSearchResult"+styleL+"\"><ul></ul></div>";
	htm += "<div class=\"MADF_Bottom\" style=\"position:relative;padding-left:0px;\">"
			+ "<div class=\"MADFDTABLE_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>" //确定
			+ "<div class=\"MADFDTABLE_AddBtn\" onclick=\"MADFDTABLE_AddFieldItem('"+theId+"')\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"//添加
		+  "</div>";  
	
	htm += "<div id=\"errorMsgContainer\" style=\"border: 1px solid red;margin: 3px 0px;padding: 3px;display: none;\">";
	htm += "	<div id=\"errorMsgTitle\" style=\"color: red;font-weight: bold;\"></div>";
	htm += "	<div style=\"color: red;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"errorMsgContent\"></span></div>";
	htm += "</div>";
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.DetailTable.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var tablename = this.mecJson["tablename"];
	$("#formid_"+theId).val(this.mecJson["maintable"]);
	$("#tablename_"+theId).val(tablename);
	$("#relatekey_"+theId).val(this.mecJson["relatekey"]);
	$("#dtablekey_"+theId).val(this.mecJson["dtablekey"]);
	$("#contentheight_"+theId).val(this.mecJson["contentheight"]);
	
	if(this.mecJson["datactrl_add"] == "1"){
		$("#datactrl_add_"+theId).attr("checked","checked");
	}
	if(this.mecJson["datactrl_update"] == "1"){
		$("#datactrl_update_"+theId).attr("checked","checked");
	}
	if(this.mecJson["datactrl_delete"] == "1"){
		$("#datactrl_delete_"+theId).attr("checked","checked");
	}
	
	MADFDTABLE_MainTableChange(theId, tablename);
	MADFDTABLE_InitSourceSearch(theId);
	var $attrContainer = $("#MADFDTABLE_"+theId);
	this.loadTableFields(tablename);//加载表单字段
	var field_datas = this.mecJson["field_datas"];
	if(!field_datas){
		field_datas = [];
	}
	var fieldSize = field_datas.length;
	if(fieldSize == 0){
		$(".detail_table_empty_tip", $attrContainer).show();
	}
	for(var i = 0; i < fieldSize; i++){
		MADFDTABLE_AddFieldItemToPage(theId, field_datas[i]);
	}
	
	$("#MADFDTABLE_" + theId).jNice();
	$("#MADFDTABLE_" + theId + " .Fields_Table > tbody").sortable({
		revert: false,
		axis: "y",
		items: "tr",
		handle: ".bemove"
	});
	MADFDTABLE_BuildFieldPropPanel();//初始化字段类型设置面板
};

/*获取JSON*/
MEC_NS.DetailTable.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFDTABLE_"+theId);
	if($attrContainer.length > 0){
		var maintable = Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var tablename = Mec_FiexdUndefinedVal($("#tablename_"+theId).val());
		var relatekey = Mec_FiexdUndefinedVal($("#relatekey_"+theId).val());
		var dtablekey = Mec_FiexdUndefinedVal($("#dtablekey_"+theId).val());
		var contentheight = Mec_FiexdUndefinedVal($("#contentheight_"+theId).val());
		var datactrl_add = $("#datactrl_add_"+theId).is(':checked') ? "1" : "0";
		var datactrl_update = $("#datactrl_update_"+theId).is(':checked') ? "1" : "0";
		var datactrl_delete = $("#datactrl_delete_"+theId).is(':checked') ? "1" : "0";
		
		this.mecJson["maintable"] = maintable;
		this.mecJson["tablename"] = tablename;
		this.mecJson["relatekey"] = relatekey;
		this.mecJson["dtablekey"] = dtablekey;
		this.mecJson["datactrl_add"] = datactrl_add;
		this.mecJson["datactrl_update"] = datactrl_update;
		this.mecJson["datactrl_delete"] = datactrl_delete;
		this.mecJson["contentheight"] = contentheight;
		
		var field_datas = [];
		$(".Fields_Table tbody > tr", $attrContainer).each(function(){
			var $this = $(this);
			var showType = $("[name=showType]", $this).val();
			var fieldPropsVal = $.parseJSON(decodeURIComponent($("[name=fieldTypeProps]", $this).val()) || "{}");
			var defaultValue = decodeURIComponent($("[name=defaultvalue]", $this).val());
			fieldPropsVal.entryId = $this.attr("id").replace("entry_","");
			fieldPropsVal.fieldname = $("[name=fieldname]", $this).val();
			fieldPropsVal.fieldlabel = MLanguage.getValue( $("[name=fieldlabel]", $this))||$("[name=fieldlabel]", $this).val();
			fieldPropsVal.showType = showType;
			fieldPropsVal.fieldTypeText = $("[name=fieldTypeText]", $this).attr("labelid");
			fieldPropsVal.defaultvalue = defaultValue;
			fieldPropsVal.fieldmectype = $("[name=fieldmectype]", $this).val();
			if(!fieldPropsVal["inParams"]){
				var inParams = [
								{
									paramValue : ""
								}
							];
				fieldPropsVal["inParams"] = inParams;
			}
			fieldPropsVal["inParams"][0]["paramValue"] = defaultValue;
			if(showType == "1"){
				fieldPropsVal["required"] = "0";
				fieldPropsVal["readonly"] = "0";
			}else if(showType == "2"){
				fieldPropsVal["required"] = "0";
				fieldPropsVal["readonly"] = "1";
			}else{
				fieldPropsVal["required"] = "1";
				fieldPropsVal["readonly"] = "0";
			}
			field_datas.push(fieldPropsVal);
		});
		this.mecJson["field_datas"] = field_datas;
	}
	
	return this.mecJson;
};

MEC_NS.DetailTable.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["designtitle"] = "明细表";  //明细表
	defMecJson["maintable"] = "";//所属主表
	defMecJson["tablename"] = "";//子表表名
	defMecJson["relatekey"] = "mainid";//关联字段
	defMecJson["dtablekey"] = "id";//子表主键
	defMecJson["datactrl_add"] = "1";//数据控制-允许新增
	defMecJson["datactrl_update"] = "1";//数据控制-允许修改
	defMecJson["datactrl_delete"] = "1";//数据控制-允许删除
	
	defMecJson["field_datas"] = [];
	
	return defMecJson;
};

MEC_NS.DetailTable.prototype.loadTableFields = function(defTable){
	var that = this;
	var theId = this.id;
	var fieldData = [];
	
	var datasource = this.mecJson["datasource"];
	var tablename = this.mecJson["tablename"];
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getFieldsByTable&dsName="+datasource+"&tbName="+tablename+"&formType=1");
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + timestamp;
	$.ajax({
	 	type: "GET",
	 	contentType: "application/json",
	 	url: encodeURI(url),
	 	data: "{}",
	 	cache:false,
	 	async: false,
	 	success: function(responseText, textStatus) 
	 	{
	 		var result = $.parseJSON(responseText);
	 		var status = result.status;
			if(status == "1"){
				fieldData = result.data;
				that.fieldData = fieldData;
				if(fieldData.length > 0 && !defTable){//自动添加所有字段
					var $attrContainer = $("#MADFDTABLE_"+theId);
					var $table = $(".Fields_Table tbody", $attrContainer);
					$table.empty();
					for(var i = 0; i < fieldData.length; i++){
						var column_name = (fieldData[i]["column_name"] || "").toLowerCase();
						var column_label = fieldData[i]["column_label"] || column_name;
						if(column_name == "id" || column_name == "mainid" 
							|| column_name == "formmodeid" || column_name == "modedatacreater" 
							|| column_name == "modedatacreatertype" || column_name == "modedatacreatedate" 
							|| column_name == "modedatacreatetime"){
							continue;
						}
						var fieldid = fieldData[i]["column_fieldid"] || "";
						var fieldhtmltype = fieldData[i]["column_fieldhtmltype"] || "";
						var fielddbtype = fieldData[i]["column_fielddbtype"] || "";
						var type = fieldData[i]["column_fieldtype"] || "";
						var browsername = fieldData[i]["column_browsername"] || "";
						var fieldtype = fieldhtmltype;
						var fieldTypeText = "";
						var htmlType = "";
						var mecFieldData = {"entryId": new UUID().toString(),"fieldname":column_name, "fieldlabel":column_label};
						
						if(fieldhtmltype == "1"){
							fieldTypeText = "4511";//单行文本
							var precision = "2";
							if(type == "1"){
								htmlType = "1";//文本
							}else if(type == "2"){
								htmlType = "8";//整数
							}else if(type == "3" || type == "5"){
								htmlType = "9";//浮点数
								var regex = /(decimal|number)\(\d+\,(\d+)\)/i;
								var matches = regex.exec(fielddbtype);
								if(matches && matches[2]){
									precision = matches[2];
								}
							}else{
								htmlType = "9";
							}
							mecFieldData["htmlType"] = htmlType;
							mecFieldData["precision"] = precision;
							mecFieldData["assistInput"] = "1";
							mecFieldData["stepNumval"] = "1";
							mecFieldData["fieldmectype"] = "FInputText";
							mecFieldData["fieldremind"] = SystemEnv.getHtmlNoteName(4170);
						}else if(fieldhtmltype == "2"){
							fieldTypeText = "4538";//多行文本
							mecFieldData["fieldmectype"] = "FTextarea";
							mecFieldData["fieldremind"] = SystemEnv.getHtmlNoteName(4170);
						}else if(fieldhtmltype == "3"){
							if(type == "2" || type == "19"){
								fieldtype = "1";
								fieldTypeText = "4511";//单行文本
								if(type == "2"){
									htmlType = "2";//日期
								}else{
									htmlType = "3";//时间
								}
								mecFieldData["htmlType"] = htmlType;
								mecFieldData["fieldmectype"] = "FInputText";
							}else{
								fieldTypeText = "4556";//浏览按钮
								mecFieldData["browsertype"] = type;
								if(type == "161" || type == "162" || type == "256" || type == "257"){
									mecFieldData["browsername"] = fielddbtype;
									if(type == "256" || type == "257"){
										mecFieldData["_browsername"] = browsername;
									}
								}
								mecFieldData["fieldmectype"] = "FBrowser";
							}
						}else if(fieldhtmltype == "4"){
							fieldTypeText = "4555";//check框
							mecFieldData["fieldmectype"] = "FCheck";
						}else if(fieldhtmltype == "5"){
							fieldTypeText = "4541";//选择项
							var sql = "select selectname as name, selectvalue as value from workflow_SelectItem where fieldid = '"+fieldid+"' and isbill=1 and cancel=0 order by listorder";
							mecFieldData["rightAction_SQL"] = sql;
							mecFieldData["rightActionType"] = "2";
							mecFieldData["fieldmectype"] = "FSelect";
						}else if(fieldhtmltype == "6"){
							if(type == "1"){
								fieldTypeText = "3776";//附件
								fieldtype = "6";
								mecFieldData["fieldmectype"] = "FFile";
							}else{
								fieldTypeText = "4578";//拍照
								fieldtype = "7";
								mecFieldData["fieldmectype"] = "FPhoto";
								mecFieldData["isCompress"] = "1";
								mecFieldData["quality"] = "0.5";
								mecFieldData["zoom"] = "0.5";
								mecFieldData["photoType"] = "1";
							}
							mecFieldData["fieldwidth"] = "200";
						}else{
							mecFieldData["htmlType"] = "1";//文本
							mecFieldData["fieldmectype"] = "FInputText";
							mecFieldData["fieldremind"] = SystemEnv.getHtmlNoteName(4170);
							fieldTypeText = "4511";//单行文本
							fieldtype = "1";
						}
						mecFieldData["fieldTypeText"] = fieldTypeText;
						mecFieldData["fieldtype"] = fieldtype;
						if(!mecFieldData["fieldwidth"]){
							mecFieldData["fieldwidth"] = "100";
						}
						MADFDTABLE_AddFieldItemToPage(theId, mecFieldData);
					}
				}
			}
	 	},
	    error: function(){
	    	that.fieldData = fieldData;
	    }
	});
	
};

function MADFDTABLE_MainTableChange(mec_id,tablename){
	MADFDTABLE_ResetErrorMsg();
	var maintableid = $("#formid_"+mec_id).val();//主表插件id
	var mainFormMecHandler = MECHandlerPool.getHandler(maintableid);
	if(mainFormMecHandler == null) return;
	var $vtableName = $("#tablename_" + mec_id);
	var $vtableName_loading = $(".MADF_loading", $("#MADFDTABLE_"+mec_id));
	var vdatasourceV = mainFormMecHandler.mecJson["datasource"];
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	mecHandler.mecJson["datasource"] = vdatasourceV;//明细表数据源和主表保持一致

	$vtableName.attr("disabled", true);
	$vtableName_loading.show();
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getDataSourceTables&datasource="+vdatasourceV);
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		var status = result.status;
		if(status == "1"){
			var data = result.data;
			MADFDTABLE_addTablenameOption(mec_id,data,tablename);
			MADFDTABLE_TableChange(mec_id, mecHandler.mecJson["relatekey"], mecHandler.mecJson["dtablekey"], tablename);
		}else{
			var errorMsg = result.errorMsg;
			MADFDTABLE_SetErrorMsg(SystemEnv.getHtmlNoteName(4333), errorMsg);  //获取表(视图)时发生如下错误：
			
			var $vkeyname = $("#dtablekey_" + mec_id);
			var $vrelatekey = $("#relatekey_" + mec_id);
			$vtableName.empty();
			$vkeyname.empty();
			$vrelatekey.empty();
			$vtableName.removeAttr("disabled");
			$vtableName_loading.hide();
		}
	});
}

function MADFDTABLE_addTablenameOption(mec_id,data,tablename){
	var $vtableName=$("#tablename_"+mec_id);
	var optionHtml = "";
	for(var i = 0; i < data.length; i++){
		var table_name = data[i]["table_name"];
		var table_type = data[i]["table_type"];
		if(table_type == "VIEW" || !table_name)continue;
		var selected = "";
		if (tablename && table_name.toUpperCase() == tablename.toUpperCase()) selected = "selected";
		var showText = table_name + (table_type == "TABLE" ? " ["+SystemEnv.getHtmlNoteName(4509)+"]" : "");  //表
		var virtualformtype = table_type == "TABLE" ? 0 : "";
		optionHtml += "<option value=\""+table_name+"\" virtualformtype=\""+virtualformtype+"\" "+selected+">"+showText+"</option>";
	}
	if($vtableName.children().length > 0){
		$vtableName.remove();//解决table数据量大的时候浏览器卡死问题 @author xxb
		$vtableName = $("<select class=\"MADF_Select\" id=\"tablename_"+mec_id+"\" onchange=\"MADF_TableChangeBefore('"+mec_id+"');\"></select>");
		$vtableName.appendTo("#tablenameContainer_" + mec_id);
	}
	$vtableName.append(optionHtml);
	var $attrContainer = $("#MADFDTABLE_"+mec_id);
	var $vtableName_loading = $(".MADF_loading", $attrContainer);
	$vtableName.removeAttr("disabled");
	$vtableName_loading.hide();
}

function MADFDTABLE_TableChange(mec_id,selectedRelateKey, selectedKey, tablename){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	mecHandler.mecJson["tablename"] = $("#tablename_" + mec_id).val();
	Mec_GetFieldOptionHtml(mec_id, "relatekey_"+mec_id, selectedRelateKey, false);
	Mec_GetFieldOptionHtml(mec_id, "dtablekey_"+mec_id, selectedKey, true);
	mecHandler.loadTableFields(tablename);
}

function MADFDTABLE_InitSourceSearch(mec_id){
	var $searchText = $("#sourceSearch_" + mec_id);
	var $searchTextTip = $("#sourceSearchTip_" + mec_id);
	
	$searchTextTip.click(function(e){
		$searchText[0].focus();
		e.stopPropagation(); 
	});
	
	$searchText.focus(function(){
		$searchTextTip.hide();
	});
	
	$searchText.blur(function(){
		if(this.value == ""){
			$searchTextTip.show();
		}
	});
	
	$searchText.click(function(e){
		e.stopPropagation(); 
	});
	
	var $srarchResult = $("#sourceSearchResult_" + mec_id);
	function hideSearchResult(){
		$srarchResult.hide();	
	}
	
	function showSearchResult(){
		$srarchResult.show();	
	}
	
	function clearSearchResult(){
		$srarchResult.children("ul").find("*").remove();	
	}
	
	var preSearchText = "";
	
	$searchText.keyup(function(event){
		if(this.value == ""){
			preSearchText = "";
			hideSearchResult();
			clearSearchResult();
		}else{
			if(this.value != preSearchText){
				var warpDiv = $("#sourceSearchWarp_"+ mec_id);
				var top = warpDiv.get(0).offsetTop+warpDiv.get(0).clientHeight;
				$("#sourceSearchResult_"+mec_id).css("top",top+"px");
				preSearchText = this.value;
				var searchValue = this.value;
				
				var resultHtml = "";
				
				var $vtableName = $("#tablename_"  + mec_id);
				$vtableName.find("option").each(function(){
					var vt = $(this).text();
					var vv = $(this).attr("value");
					if(vt.toLowerCase().indexOf(searchValue.toLowerCase()) != -1){
						resultHtml += "<li><a href=\"javascript:MADFDTABLE_SetSourceSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
					}
				});
				
				if(resultHtml == ""){
					resultHtml = "<li><font class='tip'>"+SystemEnv.getHtmlNoteName(4270)+"</font></li>";  //无匹配的结果
				}
				
				$srarchResult.children("ul").html(resultHtml);
				showSearchResult();
			}
		}
	});
	
	$("#MADFDTABLE_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFDTABLE_SetSourceSelected(mec_id, v){
	var $source = $("#tablename_" + mec_id);
	$source.val(v);
	MADFDTABLE_TableChangeBefore(mec_id);
	
	preSearchText = "";
	var $searchText = $("#sourceSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFDTABLE_InitSourceSearch(mec_id);
}

function MADFDTABLE_TableChangeBefore(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var keyname = $("#dtablekey_" + mec_id).val();
	var relatekey = $("#relatekey_" + mec_id).val();
	if(keyname != null && keyname != ""){//缓存当改变主键而又未保存时的值
		mecHandler.mecJson["dtablekey"] = keyname;
	}
	if(relatekey != null && relatekey != ""){
		if(relatekey != "mainid"){
			relatekey = "mainid";
		}
		mecHandler.mecJson["relatekey"] = relatekey;
	}
	MADFDTABLE_TableChange(mec_id,mecHandler.mecJson["relatekey"],mecHandler.mecJson["dtablekey"]);
}

function MADFDTABLE_AddFieldItem(mec_id){
	var mecFieldData = {};
	mecFieldData["htmlType"] = "1";//文本
	mecFieldData["fieldmectype"] = "FInputText";
	mecFieldData["fieldremind"] = SystemEnv.getHtmlNoteName(4170);
	mecFieldData["fieldTypeText"] = "4511";//单行文本
	mecFieldData["fieldtype"] = "1";
	MADFDTABLE_AddFieldItemToPage(mec_id, mecFieldData);
}

function MADFDTABLE_AddFieldItemToPage(mec_id, data){
	var styleL = "_style" + _userLanguage;
	var $attrContainer = $("#MADFDTABLE_"+mec_id);
	var $table = $(".Fields_Table tbody", $attrContainer);
	$(".detail_table_empty_tip", $attrContainer).hide();
	
	var entryId = (data && data.entryId) || new UUID().toString();
	var fieldname = (data && data.fieldname) || "";
	var fieldlabel = (data && data.fieldlabel) || "";
	var showType = (data && data.showType) || "";
	var fieldTypeText = (data && data.fieldTypeText) || "";
	var _fieldTypeText = SystemEnv.getHtmlNoteName(fieldTypeText - 0) || "";
	var fieldmectype = (data && data.fieldmectype) || "";
	var fieldtype = (data && data.fieldtype) || "1";//字段类型
	var fieldTypeProps = data || {};
	var defaultvalue = encodeURIComponent((data && data.defaultvalue) || "");
	var hasValueClass = "";
	if(defaultvalue) hasValueClass = "MADFDTABLE_hasValue";
	
	var fieldTypePropsStr = encodeURIComponent(JSON.stringify(fieldTypeProps));
	var $tr = $("<tr id=\"entry_"+entryId+"\"></tr>");
	var selectHtml = " selected = \"selected\" ";
	var entryHtml = "<td class=\"bemove\"></td>";
	entryHtml += "<td><select class=\"MADF_Select\" name=\"fieldname\"></select></td>";//字段
	entryHtml += "<td><input name=\"fieldlabel\" type=\"text\" value=\""+fieldlabel+"\"  data-multi=false/></td>";//显示名称
	entryHtml += "<td><select class=\"MADF_Select\" name=\"showType\">";
			if(fieldtype != "8"){
			entryHtml += "<option value=\"1\""+(showType == "1" ? selectHtml : "")+">"+SystemEnv.getHtmlNoteName(4532)+"</option>";  //可编辑
			}
			entryHtml += "<option value=\"2\""+(showType == "2" ? selectHtml : "")+">"+SystemEnv.getHtmlNoteName(4533)+"</option>";  //只读
			if(fieldtype != "4" && fieldtype != "8"){
			entryHtml += "<option value=\"3\""+(showType == "3" ? selectHtml : "")+">"+SystemEnv.getHtmlNoteName(4534)+"</option>"; //必填
			}
		entryHtml += "</select></td>";//显示类型
	entryHtml += "<td>"
					+ "<div class=\"MADF_FieldtypeHolder MADF_FieldtypeHolder"+styleL+"\" onclick=\"javascript:MADFDTABLE_initFieldPropPanel(this, '"+entryId+"');\">"
						+"<a href=\"javascript:void(0);\" class=\"sbToggle sbToggle-btc\"></a>"
						+ "<input id=\"fieldtype_"+entryId+"\" labelid=\""+fieldTypeText+"\" name=\"fieldTypeText\" value=\""+_fieldTypeText+"\" style=\"color:#000;background-color:#fff;border: 0px none rgb(255, 255, 255); height: 18px; font-size: 12px; text-indent: 0px;padding-left: 2px;\" disabled>"
						+ "<input type=\"hidden\" name=\"fieldTypeProps\" value=\""+fieldTypePropsStr+"\"/>"
					+ "</div>"
				+"</td>";//字段类型
	entryHtml += "<td><span class=\"MADFDTABLE_btn_edit "+hasValueClass+"\" onclick=\"MADFDTABLE_editFieldDefaultParamOnPage(this, '"+mec_id+"', '"+entryId+"')\"></span><span class=\"confTip\">"
					+ "</span><span class=\"MADFDTABLE_btn_del\" onclick=\"MADFDTABLE_DeleteFieldItemOnPage('"+mec_id+"','"+entryId+"')\"></span>"
					+ "<input type=\"hidden\" name=\"defaultvalue\" value=\""+defaultvalue+"\"/>"
					+ "<input type=\"hidden\" name=\"fieldmectype\" value=\""+fieldmectype+"\"/>"
				+"</td>";//默认值
	$tr.html(entryHtml);
	$table.append($tr);
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var fieldData = mecHandler.fieldData;
	
	if(fieldData.length > 0){
		var $columnName = $("select[name='fieldname']", $tr);
		var optionHtml = "";
		
		for(var i = 0; i < fieldData.length; i++){
			var column_name = fieldData[i]["column_name"];
			var column_label = MLanguage.parse(fieldData[i]["column_label"]);
			optionHtml+= "<option value=\""+column_name+"\"";
			if(fieldname && column_name && column_name.toLowerCase()==fieldname.toLowerCase()){
				optionHtml+= " selected = \"selected\" ";
			}
			if(column_label && column_label!=""){
				column_name = column_name + " ["+column_label+"]";
			}
			optionHtml+= ">"+column_name+"</option>";
		}
		$columnName.append(optionHtml);
	}
	
	
	MLanguage({
		container: $tr
    });
	
}

function MADFDTABLE_DeleteFieldItemOnPage(mec_id, entryid){
	var $attrContainer = $("#MADFDTABLE_"+mec_id);
	$("tr#entry_"+entryid).remove();
	if($(".Fields_Table tbody > tr", $attrContainer).length == 0){
		$(".detail_table_empty_tip", $attrContainer).show();
	}
}

function MADFDTABLE_editFieldDefaultParamOnPage(obj, mec_id, entryId){
	var $attrContainer = $("#MADFDTABLE_"+mec_id);
	var $entry = $("#entry_"+entryId, $attrContainer);
	var paramValue = decodeURIComponent($("[name=defaultvalue]", $entry).val());
	paramValue = $m_encrypt(paramValue);// 系统安全编码
	
	var url = "/mobilemode/defaultparaminfo.jsp?paramValue="+paramValue;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 358;//定义长度
	dlg.Height = 250;
	dlg.normalDialog = false;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4002);  //编辑
	dlg.show();
	dlg.hookFn = function(result){
		var resultVal = result["paramValue"];
		$("[name=defaultvalue]", $entry).val(encodeURIComponent(resultVal));
		if(resultVal){
			$(obj).addClass("MADFDTABLE_hasValue");
		}else{
			$(obj).removeClass("MADFDTABLE_hasValue");
		}
	};

}

function MADFDTABLE_SetErrorMsg(title, content){
	$("#errorMsgTitle").html(title);
	$("#errorMsgContent").html(content);
	$("#errorMsgContainer").show();
}

function MADFDTABLE_ResetErrorMsg(){
	$("#errorMsgTitle").html("");
	$("#errorMsgContent").html("");
	$("#errorMsgContainer").hide();
}

/**
 * 构建字段类型设置面板
 */
function MADFDTABLE_BuildFieldPropPanel(){
	var styleL = "_style" + _userLanguage;
	var propPanelHtm = "<div id=\"detailTableFieldpropsPanel\" class=\"detailTableFieldpropsPanel detailTableFieldpropsPanel"+styleL+"\">";//开始div
		propPanelHtm += "<div class=\"panelContent\">";//面板内容
		propPanelHtm +=		"<div class=\"MADF_BaseInfo\" style=\"margin-bottom:10px;\">"  //字段类型div开始
								+ "<div>"
									+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4745)+"：</span>"
									+ "<select id=\"MADFDETABLE_FieldTypeSelect\" class=\"MADF_Select\" onchange=\"MADFDETABLE_FieldTypeChange();\">"
										+ "<option value=\"1\" labelid=\"4511\">"+SystemEnv.getHtmlNoteName(4511)+"</option>"//单行文本
										+ "<option value=\"2\" labelid=\"4538\">"+SystemEnv.getHtmlNoteName(4538)+"</option>"//多行文本
										+ "<option value=\"3\" labelid=\"4556\">"+SystemEnv.getHtmlNoteName(4556)+"</option>"//浏览按钮
										+ "<option value=\"4\" labelid=\"4555\">"+SystemEnv.getHtmlNoteName(4555)+"</option>"//check框
										+ "<option value=\"5\" labelid=\"4541\">"+SystemEnv.getHtmlNoteName(4541)+"</option>"//选择项
										+ "<option value=\"6\" labelid=\"3776\">"+SystemEnv.getHtmlNoteName(3776)+"</option>"//附件
										+ "<option value=\"7\" labelid=\"4578\">"+SystemEnv.getHtmlNoteName(4578)+"</option>"//拍照
										+ "<option value=\"8\" labelid=\"4537\">"+SystemEnv.getHtmlNoteName(4537)+"</option>"//隐藏域
									+ "</select>"
								+ "</div>"
								+"<div>"
									+"<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4408)+"：</span>"  //列宽：
								    +"<input class=\"MADF_Text\" id=\"MADFDTABLE_FieldWidth\" style=\"width:80px;\" name=\"MADFDTABLE_FieldWidth\" type=\"text\"/>"
								    +"<span>("+SystemEnv.getHtmlNoteName(4746)+")</span>"
								+"</div>"
							+ "</div>";//字段类型div结束
		
		propPanelHtm += "<div class=\"FInputTextPanel MADF_BaseInfo PanelItem\">"//单行文本类型div开始
							+"<div>"
								+"<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4515)+"</span>"  //提示信息：
							    +"<input class=\"MADF_Text\" id=\"MADFDTABLE_FIRemind\" name=\"MADFDTABLE_FIRemind\" type=\"text\" data-multi=false/>"
							+"</div>"
							+ "<div>"
								+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4185)+"</span>"  //类型：
								+ "<select class=\"MADF_Select\" id=\"MADFDTABLE_FIHtmlType\" name=\"MADFDTABLE_FinputTextHtmlType\" onchange=\"MADFDETABLE_FInputTextHtmlTypeChange();\">"
									+ "<option value=\"1\">"+SystemEnv.getHtmlNoteName(4517)+"</option>"  //文本
									+ "<option value=\"2\">"+SystemEnv.getHtmlNoteName(3715)+"</option>"  //日期
									+ "<option value=\"3\">"+SystemEnv.getHtmlNoteName(3706)+"</option>"  //时间
									+ "<option value=\"4\">"+SystemEnv.getHtmlNoteName(4518)+"</option>"  //日期时间
									+ "<option value=\"5\">"+SystemEnv.getHtmlNoteName(4519)+"</option>"  //密码
									+ "<option value=\"8\">"+SystemEnv.getHtmlNoteName(4614)+"</option>"  //整数
									+ "<option value=\"9\">"+SystemEnv.getHtmlNoteName(4615)+"</option>"  //浮点数
									+ "<option value=\"7\">"+SystemEnv.getHtmlNoteName(4521)+"</option>"  //电话号码
								+ "</select>"
								+ "<div class=\"MADFI_NumType_float\" style=\"display:none;margin-bottom:0px;\">"
									+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\" style=\"\">"+SystemEnv.getHtmlNoteName(4616)+"</span>"  //小数位数：
									+ "<select class=\"MADF_Select\" id=\"MADFDTABLE_FIHtmlFloatPrecision\" style=\"width:53px;\">"
										+ "<option value=\"1\">1</option>"
										+ "<option value=\"2\">2</option>"
										+ "<option value=\"3\">3</option>"
										+ "<option value=\"4\">4</option>"
									+ "</select>"
								+ "</div>"
							+"</div>"
							+ "<div class=\"MADFI_NumContent\">"
								
							+ "</div>"
							+ "<div class=\"MADFI_NumContent\" style=\"display:none;\">"
								+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4522)+"</span>"  //数字范围：
								+ "<input class=\"MADF_Text\" style=\"width:75px;\" type=\"text\" id=\"MADFDTABLE_FIMinNumber\" placeholder=\""+SystemEnv.getHtmlNoteName(4610)+"\"/>"  //最小值
								+ "<span>~</span>"
								+ "<input class=\"MADF_Text\" style=\"width:75px;\" type=\"text\" id=\"MADFDTABLE_FIMaxNumber\" placeholder=\""+SystemEnv.getHtmlNoteName(4611)+"\"/>"  //最大值
							+ "</div>"
							+ "<div class=\"MADFI_NumContent\" style=\"display:none;\">"
								+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4617)+"</span>"  //辅助输入：
								+ "<input type=\"checkbox\" name=\"MADFDTABLE_FIAssistInput\" value=\"1\" onclick=\"MADFDTABLE_FInputTextChangeRAT(this);\">"
								+ "<div class=\"MADFDTABLE_FINumType_addstep\" style=\"display:none;margin-bottom:0px;\">"
									+ "<span class=\"MADF_BaseInfo_Label\" style=\"width:40px;\">"+SystemEnv.getHtmlNoteName(4525)+"</span>"  //增幅：
									+ "<input class=\"MADF_Text\" style=\"width:105px;\" type=\"text\" id=\"MADFDTABLE_FIStepNumval\" placeholder=\""+SystemEnv.getHtmlNoteName(4526)+"\"/>"  //增幅大小
								+ "</div>"
							+ "</div>"
							
							+ "<div class=\"MADFI_DateContent\" style=\"display:none;\">"
								+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4527)+"</span>"  //年份偏移：
								+ "<input class=\"MADF_Text\" style=\"width:100px;\" type=\"text\" id=\"MADFDTABLE_FIYearPrevOffset\" placeholder=\""+SystemEnv.getHtmlNoteName(4608)+"\"/>"  //向前偏移，100
								+ "<span>&nbsp;~&nbsp;</span>"
								+ "<input class=\"MADF_Text\" style=\"width:90px;\" type=\"text\" id=\"MADFDTABLE_FIYearNextOffset\" placeholder=\""+SystemEnv.getHtmlNoteName(4609)+"\"/>&nbsp;&nbsp;"  //向后偏移，1
							+ "</div>"
						+ "</div>";//单行文本类型div结束
	
		propPanelHtm += "<div class=\"FTextareaPanel MADF_BaseInfo PanelItem\">"//多行文本类型div开始
							+ "<div>"
								+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4515)+"</span>"  //提示信息：
							    + "<input class=\"MADF_Text\" id=\"MADFDTABLE_FTextAreaRemind\" name=\"MADFDTABLE_FTextAreaRemind\" type=\"text\" data-multi=false/>"
							+ "</div>"
						+ "</div>";//多行文本类型div结束
		
		propPanelHtm += "<div class=\"FSelectPanel MADF_BaseInfo PanelItem\">"//选择项类型div开始
							+ "<div class=\"MADFS_BaseInfo_Entry\">"
								+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4542)+"</span>"  //选择来源：
								+ "<span class=\"MADFS_BaseInfo_Entry_Content\">"
									+ "<span class=\"cbboxEntry\" style=\"width: 100px;\">"
										+ "<input type=\"checkbox\" name=\"MADFDTABLE_FSRightActionType\" value=\"1\" onclick=\"MADFDTABLE_FSelectChangeRAT(this);\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4543)+"</span>"  //手动添加
									+ "</span>"
									+ "<span class=\"cbboxEntry\" style=\"width: 130px;\">"
										+ "<input type=\"checkbox\" name=\"MADFDTABLE_FSRightActionType\" value=\"2\" onclick=\"MADFDTABLE_FSelectChangeRAT(this);\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4280)+"</span>"  //手动输入SQL
									+ "</span>"
								+ "</span>"
							+ "</div>"
							
							+ "<div class=\"rightActionContent actionContent\" id=\"MADFDTABLE_FSRightActionContent_1\" style=\"display: none;position: relative;padding-top: 20px;\">"
								+ "<div class=\"select_root_add\" onclick=\"MADFDTABLE_AddSelectEntry();\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
								+ "<table class=\"MADFS_Table\" id=\"MADFDTABLE_FSelectTable\" style=\"width:100%;\">"
									+ "<colgroup>"
										+ "<col width=\"20px\"/>"
										+ "<col width=\"40px\"/>"
										+ "<col width=\"140px\"/>"
										+ "<col width=\"30px\"/>"
										+ "<col width=\"80px\"/>"
										+ "<col width=\"*\"/>"
									+ "</colgroup>"
									+ "<tbody>"
										
									+ "</tbody>"
								+ "</table>"
								
								+ "<div class=\"select_empty_tip\">"+SystemEnv.getHtmlNoteName(4159)+"</div>"  //单击右上角的添加按钮以添加内容
					
																	
							+ "</div>"
							
							+ "<div class=\"rightActionContent actionContent\" id=\"MADFDTABLE_FSRightActionContent_2\" style=\"display: none;\">"
							
								+"<div class=\"MADFS_DataSource\">"
									//+"<div style=\"position: relative;padding-left: 66px;\">"
										+"<span class=\"MADFS_DataSource_Label MADFS_DataSource_Label"+styleL+"\" style=\"\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"   //数据源：
										+"<select class=\"MADF_Select\" id=\"MADFDTABLE_FSDatasource\">"
											+"  <option value=\"\">(local)</option>"
										+"</select>"
									//+"</div>"
								+"</div>"
								
								+ "<textarea id=\"MADFDTABLE_FSRightAction_SQL\" class=\"MADF_Textarea\" placeholder=\""+SystemEnv.getHtmlNoteName(4283)+"\"></textarea>"  //请在此处输入SQL...
								+"<div style=\"padding-top: 3px;\"><a href=\"javascript:void(0);\" onclick=\"MADFDTABLE_OpenSQLHelp();\">"+SystemEnv.getHtmlNoteName(4202)+"</a></div>"  //如何书写SQL？
							+ "</div>"
						+ "</div>";//选择项类型div结束
		
		propPanelHtm += "<div class=\"FBrowserPanel MADF_BaseInfo PanelItem\">"//浏览框类型div开始
							+ "<div>"
								+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4185)+"</span>"  //类型：
								+ "<select id=\"MADFDETABLE_FBrowserTypeSelect\" class=\"MADF_Select\" onchange=\"MADFDETABLE_OnFBrowserTypeChange();\">"
								+ "</select>"
							+ "</div>"
							+ "<div id=\"MADFDTABLE_BrowserNameDiv\" class=\"browsernameDiv browsernameDiv"+styleL+"\">"
						    	+ "<input id=\"MADFDTABLE_BrowserId\" type=\"hidden\"/>"
						    	+ "<input id=\"MADFDTABLE_BrowserName\" class=\"MADFBro_Text2\" type=\"text\" readonly=\"readonly\" style=\"\"/>"
						    	+ "<button type=\"button\" onclick=\"MADFDTABLE_openBrowserChoose()\" class=\"MADFBro_BrowserBtn MADFBro_BrowserBtn"+styleL+"\"></button>"
						    + "</div>"
						+ "</div>";//浏览框类型div结束
		var tip = "";
		if(_userLanguage=="8"){
			tip = "Quality: the smaller the value, the lower the quality, the smaller the size of the compressed image, but the picture is not clear. The setting values ranged from 0.1 to 1 </div><div> scaling: compression will be to picture the original wide high will be multiplied by a scaling ratio, the smaller the value of, image compression wide Takahashi is small, and the volume will be smaller and smaller. The value is set between 0.1 and 1.";
		}else if(_userLanguage=="9"){
			tip = "質量：值越小，質量越低，圖片壓縮後體積越小，但圖片也會越不清晰。該值設置介于0.1 至 1之間</div><div>縮放：壓縮時會以圖片的原始寬高會乘以縮放比例，值越小，壓縮後圖片的寬高越小，體積也會越小。該值設置介于0.1 至 1之間";
		}else{
			tip = "质量：值越小，质量越低，图片压缩后体积越小，但图片也会越不清晰。该值设置介于0.1 至 1之间</div><div>缩放：压缩时会以图片的原始宽高会乘以缩放比例，值越小，压缩后图片的宽高越小，体积也会越小。该值设置介于0.1 至 1之间";
		}
		propPanelHtm += "<div class=\"FPhotoPanel MADF_BaseInfo PanelItem\">"//照片上传类型div开始
							+"<div>"
								+"<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4633)+"</span>"  //图片绘制：
								+"<input type=\"checkbox\" id=\"MADFDTABLE_FPIsDrawing\"/>"
							+"</div>"
							+"<div>"
								+"<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4579)+"</span>"  //是否压缩：
								+"<input type=\"checkbox\" id=\"MADFDTABLE_FPIsCompress\" onclick=\"MADFDTABLE_FPhotoChangeComp(this);\"/>"
							+"</div>"
							+"<div id=\"MADFDTABLE_FPCompressWrap\" style=\"display:none;\">"
								+"<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4580)+"</span>"  //质量-缩放：
								+"<input type=\"text\" id=\"MADFDTABLE_FPQuality\" style=\"width:53px;border: 1px solid #ccc;height:22px;padding-left:3px;font-size:12px;\" placeholder=\"0.1 ~ 1\"/>"
								+"<span style=\"margin: 0px 5px;font-size:18px;\">-</span>"
								+"<input type=\"text\" id=\"MADFDTABLE_FPZoom\" style=\"width:53px;border: 1px solid #ccc;height:22px;padding-left:3px;font-size:12px;\" placeholder=\"0.1 ~ 1\"/>"
								+"<div style=\"padding: 5px;line-height: 18px;border: 1px dotted #ccc;margin-top:10px;margin-right:10px;border-radius:3px;\"><div>"+tip+"</div></div>"  //质量：值越小，质量越低，图片压缩后体积越小，但图片也会越不清晰。该值设置介于0.1 至 1之间</div><div>缩放：压缩时会以图片的原始宽高会乘以缩放比例，值越小，压缩后图片的宽高越小，体积也会越小。该值设置介于0.1 至 1之间
							+"</div>"
							+"<div>"
								+"<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4628)+"</span>"  //拍照类型：
								+"<select class=\"MADFPhoto_Select\" id=\"MADFDTABLE_FPPhotoType\">"
									+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4629)+"</option>"  //默认
									+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4630)+"</option>"  //只拍照
									+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4631)+"</option>"  //只选择照片
								+"</select>"
								+"<span class=\"MADFPhoto_BaseInfo_Tip\">"+SystemEnv.getHtmlNoteName(4632)+"</span>"  //(仅在emobile中生效)
							+"</div>"
						+ "</div>";//照片上传类型div结束
		propPanelHtm += "</div>";
		propPanelHtm += "<div class=\"panelFooter\">"
							+ "<div class=\"MADFDTABLE_SaveBtn MADFDTABLE_PanelOkBtn\" onclick=\"MADFDTABLE_SaveProps();\">"+SystemEnv.getHtmlNoteName(3451)+"</div>" //确定
							+ "<div class=\"MADFDTABLE_CancelBtn\" onclick=\"MADFDTABLE_closeFieldPropPanel();\">"+SystemEnv.getHtmlNoteName(3516)+"</div>" //取消
						+  "</div>";  
		
		propPanelHtm +=	"</div>";//开始div结束
	if($("#detailTableFieldpropsPanel").length == 0){
		$("#content .content_left").append(propPanelHtm);
		$("#detailTableFieldpropsPanel").jNice();
		$("#MADFDTABLE_FSelectTable > tbody").sortable({
			revert: false,
			axis: "y",
			items: "tr",
			handle: ".bemove"
		});
		$("#detailTableFieldpropsPanel").bind("click",function(event){
	       	var e=event || window.event;
		    if (e && e.stopPropagation){
		        e.stopPropagation();    
		    }
	    });
		MADFDTABLE_FSSetDataSourceHTML();//选择框数据源初始化
		MADFDTABLE_fillBrowserType();//浏览框类型初始化
		/*MLanguage({
			container:$("#detailTableFieldpropsPanel .PanelItem") //设置属性多语言
	    });*/
	}
}

/**
 * 初始化属性面板
 * 
 * @param obj
 * @param entryid
 */
function MADFDTABLE_initFieldPropPanel(obj, entryid){
	var offset = $("#fieldtype_"+entryid).offset();
	var window_height = $(window).height();
	
	var oTop=document.body.scrollTop == 0 ?document.documentElement.scrollTop:document.body.scrollTop;
	var v_top = offset.top - oTop;
	var $sbt = $("#fieldtype_"+entryid).parent();
	var sb_hegiht = $sbt.height();
	var top = v_top + sb_hegiht + 4;
	var wHeight = $(window).height();
	var oo = wHeight - top;
	var hh = $("#detailTableFieldpropsPanel").outerHeight(true);
	if(oo < hh){
		top = v_top - hh - 4;
	}
	var left = 150;
	var ol = $(window).width()-offset.left;
	if(ol<300){
		left = left+300-ol+10;
	}
	var $container = $("#detailTableFieldpropsPanel");
	$container.css({"top":top+"px", "left":(offset.left-left)+"px"});
	$container.attr("currEntryId", entryid);
	
	if(!$("a", $(obj)).hasClass("sbToggle-btc-reverse")){
		var $entry = $("#entry_"+entryid);
		var $fieldTypeProps = $("[name='fieldTypeProps']", $entry);
		var initVal = decodeURIComponent($fieldTypeProps.val()) || "{}";
		if(initVal){
			var iniValObj = $.parseJSON(initVal);
			//字段类型
			var fieldtype = iniValObj.fieldtype || "1";
			var fieldwidth = iniValObj.fieldwidth || "";
			$("#MADFDETABLE_FieldTypeSelect").val(fieldtype);
			$("#MADFDTABLE_FieldWidth").val(fieldwidth);//列宽
			MADFDETABLE_FieldTypeChange();
			if(fieldtype == "1"){//初始化单行文本
				MADFDETABLE_FInputTextUIInit(iniValObj);
			    $("#detailTableFieldpropsPanel .FInputTextPanel").find('[data-multi]').attr('data-multi',false);
				$("#detailTableFieldpropsPanel .FInputTextPanel").find('.multi__clone').remove();
			    MLanguage({
					container:$("#detailTableFieldpropsPanel .FInputTextPanel") //设置属性多语言
			    });
			}else if(fieldtype == "2"){//初始化多行文本
				var fieldremindDefault = SystemEnv.getHtmlNoteName(4170);  //请输入...
				var fieldremind = iniValObj["fieldremind"] || "";
				if(typeof(iniValObj["fieldremind"]) == "undefined"){
					fieldremind = fieldremindDefault;
				}
				$("#MADFDTABLE_FTextAreaRemind").val(fieldremind);
				$("#detailTableFieldpropsPanel .FTextareaPanel").find('[data-multi]').attr('data-multi',false);
				$("#detailTableFieldpropsPanel .FTextareaPanel").find('.multi__clone').remove();
			    MLanguage({
					container:$("#detailTableFieldpropsPanel .FTextareaPanel") //设置属性多语言
			    });
			}else if(fieldtype == "3"){//初始化浏览框
				MADFDTABLE_FBrowserUIInit(iniValObj);
			}else if(fieldtype == "5"){//初始化选择框
				MADFDETABLE_FSelectUIInit(iniValObj);
			}else if(fieldtype == "7"){//初始化拍照
				MADFDTABLE_FPhotoUIInit(iniValObj);
			}
		}
		$(".MADF_FieldtypeHolder a").removeClass("sbToggle-btc-reverse");
		$("a", $(obj)).addClass("sbToggle-btc-reverse");
		$("#detailTableFieldpropsPanel").slideDown(50);
	}else{
		$("a", $(obj)).removeClass("sbToggle-btc-reverse");
		$("#detailTableFieldpropsPanel").slideUp(50);
	}
	
	var e=event || window.event;
    if (e && e.stopPropagation){
        e.stopPropagation();    
    }else{
        e.cancelBubble=true;
    }
}

/**
 * 关闭属性面板
 */
function MADFDTABLE_closeFieldPropPanel(){
	var $container = $("#detailTableFieldpropsPanel");
	var currEntryId = $container.attr("currEntryId");
	$("#entry_"+currEntryId).find("a").removeClass("sbToggle-btc-reverse");
	$("#detailTableFieldpropsPanel").slideUp(50);
	var fieldremind = SystemEnv.getHtmlNoteName(4170);  //请输入...
	//清空组件值
	MADFDETABLE_FInputTextUIInit();//单行文本
	$("#MADFDTABLE_FTextAreaRemind", $container).val(fieldremind);//多行文本
	MADFDETABLE_FSelectUIInit();//选择框
	MADFDTABLE_FBrowserUIInit();//浏览框
	MADFDTABLE_FPhotoUIInit();//拍照
}

/**
 * 字段类型change
 */
function MADFDETABLE_FieldTypeChange(){
	var $container = $("#detailTableFieldpropsPanel");
	$(".PanelItem", $container).hide();
	var fieldValue = $("#MADFDETABLE_FieldTypeSelect").val();
	if(fieldValue == "1"){
		$(".FInputTextPanel", $container).show();
	}else if(fieldValue == "2"){
		$(".FTextareaPanel", $container).show();
	}else if(fieldValue == "3"){
		$(".FBrowserPanel", $container).show();
	}else if(fieldValue == "5"){
		$(".FSelectPanel", $container).show();
	}else if(fieldValue == "7"){
		$(".FPhotoPanel", $container).show();
	}
}

/**
 * 初始化单行文本类型UI值
 * @param data
 */
function MADFDETABLE_FInputTextUIInit(data){
	var fieldremindDefault = SystemEnv.getHtmlNoteName(4170);  //请输入...
	var $container = $("#detailTableFieldpropsPanel");
	var fieldremind = (data && data["fieldremind"]) || "";
	if(data && typeof(data["fieldremind"]) == "undefined"){
		fieldremind = fieldremindDefault;
	}
	var htmlType 	= (data && data["htmlType"]) || "1";
	var precision 	= (data && data["precision"]) || "2";
	var minNumber 	= (data && data["minNumber"]) || "";
	var maxNumber 	= (data && data["maxNumber"]) || "";
	var assistInput = (data && data["assistInput"]) || "";
	var stepNumval 	= (data && data["stepNumval"]) || "";
	var yearPrevOffset = (data && data["yearPrevOffset"]) || "";
	var yearNextOffset = (data && data["yearNextOffset"]) || "";
	
	$("#MADFDTABLE_FIRemind", $container).val(fieldremind);//单行文本提示信息
	$("#MADFDTABLE_FIHtmlType").val(htmlType);//类型
	
	MADFDETABLE_FInputTextHtmlTypeChange();
	
	$("#MADFDTABLE_FIHtmlFloatPrecision").val(precision);//小数位数
	$("#MADFDTABLE_FIMinNumber").val(minNumber);//数字范围，最小值
	$("#MADFDTABLE_FIMaxNumber").val(maxNumber);//数字范围，最大值
	$("#MADFDTABLE_FIStepNumval").val(stepNumval);//辅助输入，步值
	
	if(assistInput == "1"){
		$("input[name='MADFDTABLE_FIAssistInput']").attr("checked","checked").next(".jNiceCheckbox").addClass("jNiceChecked");
		$(".MADFDTABLE_FINumType_addstep", $container).css("display","inline-block");
	}else{
		$("input[name='MADFDTABLE_FIAssistInput']").removeAttr("checked","checked").next(".jNiceCheckbox").removeClass("jNiceChecked");
		$(".MADFDTABLE_FINumType_addstep", $container).hide();
	}
	
	$("#MADFDTABLE_FIYearPrevOffset").val(yearPrevOffset);
	$("#MADFDTABLE_FIYearNextOffset").val(yearNextOffset);
}
/**
 * 单行文本类型change
 */
function MADFDETABLE_FInputTextHtmlTypeChange(){
	var $container = $("#detailTableFieldpropsPanel");
	$htmlType = $("[name='MADFDTABLE_FinputTextHtmlType']", $container);
	
	var htmlTypeVal = $htmlType.val();
	if(htmlTypeVal == "6" || htmlTypeVal == "8"){
		$(".MADFI_DateContent", $container).hide();
		$(".MADFI_NumContent", $container).show();
		$(".MADFI_NumType_float", $container).hide();
	}else if(htmlTypeVal == "9"){
		$(".MADFI_DateContent", $container).hide();
		$(".MADFI_NumContent", $container).show();
		if(_userLanguage=="8"){
			$(".MADFI_NumType_float", $container).css("display", "block");
		}else{
			$(".MADFI_NumType_float", $container).css("display", "inline-block");
		}
	}else if($htmlType.val() == "2" || $htmlType.val() == "4"){
		$(".MADFI_NumContent", $container).hide();
		$(".MADFI_DateContent", $container).show();
		$(".MADFI_NumType_float", $container).hide();
	}else{
		$(".MADFI_NumContent", $container).hide();
		$(".MADFI_DateContent", $container).hide();
		$(".MADFI_NumType_float", $container).hide();
	}
}

function MADFDTABLE_FInputTextChangeRAT(cbObj, mec_id){
	setTimeout(function(){
		var $container = $("#detailTableFieldpropsPanel");
		if(!cbObj.checked){
			$(".MADFDTABLE_FINumType_addstep", $container).hide();
		}else{
			$(".MADFDTABLE_FINumType_addstep", $container).css("display","inline-block");
		}
	}, 100);
}

/**
 * 初始化选择框UI
 * @param data
 */
function MADFDETABLE_FSelectUIInit(data){
	var rightActionTypeV = (data && data["rightActionType"]) || "1";
	var $rightActionType = $("input[type='checkbox'][name='MADFDTABLE_FSRightActionType'][value='"+rightActionTypeV+"']");
	
	if($rightActionType.length > 0){
		$rightActionType.attr("checked", "checked").next(".jNiceCheckbox").addClass("jNiceChecked");
		$rightActionType.triggerHandler("click");
	}
	
	var $container = $("#detailTableFieldpropsPanel");
	
	var select_datas = (data && data["select_datas"]) || [];
	if(select_datas.length == 0){
		$(".select_empty_tip", $container).show();
	}
	$(".MADFS_Table tbody", $container).empty();
	for(var i = 0; i < select_datas.length; i++){
		var data = select_datas[i];
		MADFDETABLE_FSAddSelectEntryToPage(data);
	}
	
	var datasource = (data && data["datasource"]) || "";
	var sql = (data && data["rightAction_SQL"]) || "";
	//设置数据源
	$("#MADFDTABLE_FSDatasource").val(datasource);

	var $sql = $("#MADFDTABLE_FSRightAction_SQL");
	$sql.val(sql);
	
	$sql.focus(function(){
		$(this).addClass("MADFS_Textarea_Focus");
	});
	$sql.blur(function(){
		$(this).removeClass("MADFS_Textarea_Focus");
	});
}

function MADFDTABLE_FSSetDataSourceHTML(val){
	var $DataSource = $("#MADFDTABLE_FSDatasource");
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
			$DataSource.append(dataSourceSelectHtml);
		}
	});
}

function MADFDTABLE_OpenSQLHelp(){
	var url = "/mobilemode/fselectSQLHelp.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 540;//定义长度
	dlg.Height = 455;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4204);  //SQL帮助
	dlg.show();
}

function MADFDTABLE_AddSelectEntry(){
	var result = {};
	
	var $attrContainer = $("#detailTableFieldpropsPanel");
	
	var id = new UUID().toString();
	result["id"] = id;
	result["name"] = "";
	result["value"] = "";
		
	MADFDETABLE_FSAddSelectEntryToPage(result);
}

function MADFDETABLE_FSAddSelectEntryToPage(data){
	$(".select_empty_tip", $attrContainer).hide();
	var $attrContainer = $("#detailTableFieldpropsPanel");
	
	var id = data["id"];
	var name = data["name"];
	var value = data["value"];
	
	var SelectEntry = "<tr id=\"SelectEntry_"+id+"\" class=\"SelectEntry\" >"
						+ "<td class=\"bemove\">"
						+ "</td>"
						+ "<td style=\"text-align:right\">"
							+ SystemEnv.getHtmlNoteName(4544)  //显示：
						+ "</td>"
						+ "<td>"
							+ "<input type=\"text\" id=\"selectname_"+id+"\" value=\""+name+"\" class=\"MADFS_Text_NAME MADF_Text\" style=\"width: 140px;\" data-multi=\"false\">"
						+ "</td>"
						+ "<td style=\"text-align:right\">"
							+ SystemEnv.getHtmlNoteName(4545)  //值：
						+ "</td>"
						+ "<td>"
						+ "<input type=\"text\" id=\"selectvalue_"+id+"\" value=\""+value+"\" class=\"MADFS_Text_VALUE MADF_Text\" style=\"width: 80px;\">"
						+ "</td>"
						+ "<td align=\"right\">"
							+ "<input type=\"hidden\" value=\""+id+"\" class=\"MADFS_Text_ID\">"
							+ "<span class=\"select_btn_del\" onclick=\"MADFDETABLE_DeleteSelectEntry('"+id+"');\"></span>"
						+ "</td>"
					+ "</tr>";
	
	var $ParentSelectEntry;
	$ParentSelectEntry = $(".MADFS_Table tbody", $attrContainer);
	
	
	$ParentSelectEntry.append(SelectEntry);
	MLanguage({
		container: $ParentSelectEntry.find("tr")
    });
}
function MADFDETABLE_DeleteSelectEntry(entryid){
	var $attrContainer = $("#detailTableFieldpropsPanel");
	$("#SelectEntry_" + entryid, $attrContainer).remove();
	
	var $tableBody = $(".MADFS_Table tbody",$attrContainer);
	if($tableBody.children().length == 0){
		$(".select_empty_tip", $attrContainer).show();
	}
}
/**
 * 选择框类型点击操作
 * @param cbObj
 */
function MADFDTABLE_FSelectChangeRAT(cbObj){
	var $container = $("#detailTableFieldpropsPanel");
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='MADFDTABLE_FSRightActionType']", $container).each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
		
		$(".rightActionContent", $container).hide();
		$("#MADFDTABLE_FSRightActionContent_" + objV, $container).show();
	},100);
}

function MADFDTABLE_FBrowserUIInit(data){
	var browsertype = (data && data.browsertype) || "";
	var browsername = (data && data.browsername) || "";
	var _browsername = (data && data._browsername) || "";
	if(!_browsername){
		_browsername = browsername;
	}
	$("#MADFDETABLE_FBrowserTypeSelect").val(browsertype);
	MADFDETABLE_OnFBrowserTypeChange();
	$("#MADFDTABLE_BrowserId").val(browsername);
	$("#MADFDTABLE_BrowserName").val(_browsername);
}

function MADFDTABLE_fillBrowserType(){
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getBrowserType");
	$.ajax({
	 	type: "GET",
	 	contentType: "application/json",
	 	url: encodeURI(url),
	 	data: "{}",
	 	success: function(responseText, textStatus) 
	 	{
	 		var result = $.parseJSON(responseText);
	 		var status = result.status;
			if(status == "1"){
				var data = result.data;
				var optionHtml = "<option></option>";
				for(var i = 0; i < data.length; i++){
					var match = data[i]["match"];
					var value = data[i]["value"];
					var text = data[i]["text"];
					optionHtml+= "<option match=\""+match+"\" value=\""+value+"\">"+text+"</option>";
				}
				var $fieldObj = $("#MADFDETABLE_FBrowserTypeSelect");
				$fieldObj.empty().append(optionHtml);
				MADFDETABLE_OnFBrowserTypeChange();
			}
	 	},
	    error: function(){
	    }
	});
}

function MADFDETABLE_OnFBrowserTypeChange(){
	var browsertype = $("#MADFDETABLE_FBrowserTypeSelect").val();
	if(browsertype == "161" || browsertype == "162" || browsertype == "256" || browsertype == "257"){
		$("#MADFDTABLE_BrowserNameDiv").show();
	}else{
		$("#MADFDTABLE_BrowserNameDiv").hide();
		$("#MADFDTABLE_BrowserId").val("");
		$("#MADFDTABLE_BrowserName").val("");
	}
}

function MADFDTABLE_openBrowserChoose(){
	var browsertype = $("#MADFDETABLE_FBrowserTypeSelect").val();
	var url = "";
	if(browsertype == "161" || browsertype == "162"){
		url = "/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp";
	}else if(browsertype == "256" || browsertype == "257"){
		url = "/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp";
	}
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 550;//定义长度
	dlg.Height = 650;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3418);  //请选择
	dlg.show();
	dlg.callback = function(result){
		var v = result.id;
		if(v == "browser."){
			v = "";
		}
		$("#MADFDTABLE_BrowserId").val(v);
		
		var n = result.name;
		if(n){
			var reStripTags = /<\/?.*?>/g;
			n = n.replace(reStripTags, ''); //只有文字的结果
		}else{
			n = v;
		}
		$("#MADFDTABLE_BrowserName").val(n);
	};
}

function MADFDTABLE_FPhotoUIInit(data){
	var isDrawing = (data && data.isDrawing) || "";
	var isCompress = (data && data.isCompress) || "1";
	var quality = (data && data.quality) || "0.5";
	var zoom = (data && data.zoom) || "0.5";
	var photoType = (data && data.photoType) || "1";// 拍照类型
	
	$("#MADFDTABLE_FPPhotoType").val(photoType);
	
	if(isDrawing == "1"){
		$("#MADFDTABLE_FPIsDrawing").attr("checked","checked").next(".jNiceCheckbox").addClass("jNiceChecked");
	}else{
		$("#MADFDTABLE_FPIsDrawing").removeAttr("checked","checked").next(".jNiceCheckbox").removeClass("jNiceChecked");
	}
	if(isCompress == "1"){
		$("#MADFDTABLE_FPIsCompress").attr("checked","checked").next(".jNiceCheckbox").addClass("jNiceChecked");
	}else{
		$("#MADFDTABLE_FPIsCompress").removeAttr("checked","checked").next(".jNiceCheckbox").removeClass("jNiceChecked");
	}
	$("#MADFDTABLE_FPIsCompress").triggerHandler("click");
	
	$("#MADFDTABLE_FPQuality").val(quality);
	$("#MADFDTABLE_FPZoom").val(zoom);
}

function MADFDTABLE_FPhotoChangeComp(cbObj){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(cbObj.checked){
			$("#MADFDTABLE_FPCompressWrap").show();
		}else{
			$("#MADFDTABLE_FPCompressWrap").hide();
		}
	},100);
}

/**
 * 保存字段类型属性
 */
function MADFDTABLE_SaveProps(){
	var $container = $("#detailTableFieldpropsPanel");
	var currEntryId = $container.attr("currEntryId");
	var $entry = $("#entry_"+currEntryId);
	var $fieldTypeProps = $("[name='fieldTypeProps']", $entry);
	
	var fieldtype = $("#MADFDETABLE_FieldTypeSelect").val();
	var fieldTypeText = $("#MADFDETABLE_FieldTypeSelect option[value='"+fieldtype+"']").text();
	var fieldlabelid = $("#MADFDETABLE_FieldTypeSelect option[value='"+fieldtype+"']").attr("labelid");
	$("#fieldtype_"+currEntryId).val(fieldTypeText).attr("labelid", fieldlabelid);
	var fieldwidth = $("#MADFDTABLE_FieldWidth").val();//列宽
	
	var oldVal = $fieldTypeProps.val();
	var valObj = $.parseJSON(decodeURIComponent(oldVal));
	
	valObj["fieldtype"] = fieldtype;
	valObj["fieldwidth"] = fieldwidth;
	var fieldmectype = "";
	if(fieldtype == "1"){
		fieldmectype = "FInputText";
		valObj["fieldremind"] =   MLanguage.getValue($("#MADFDTABLE_FIRemind", $container)) || Mec_FiexdUndefinedVal($("#MADFDTABLE_FIRemind", $container).val());//单行文本提示信息
		valObj["htmlType"] = Mec_FiexdUndefinedVal($("#MADFDTABLE_FIHtmlType").val());//类型
		valObj["precision"] = Mec_FiexdUndefinedVal($("#MADFDTABLE_FIHtmlFloatPrecision").val());//小数位数
		valObj["minNumber"] = $("#MADFDTABLE_FIMinNumber").val();//数字范围，最小值
		valObj["maxNumber"] = $("#MADFDTABLE_FIMaxNumber").val();//数字范围，最大值
		valObj["stepNumval"] = $("#MADFDTABLE_FIStepNumval").val();////辅助输入，步值
		var $assistInput = $("input[type='checkbox'][name='MADFDTABLE_FIAssistInput']:checked");
		if($assistInput.length > 0){
			valObj["assistInput"] = "1";
		}else{
			valObj["assistInput"] = "0";
		}
		valObj["yearPrevOffset"] = $("#MADFDTABLE_FIYearPrevOffset").val();
		valObj["yearNextOffset"] = $("#MADFDTABLE_FIYearNextOffset").val();
	}else if(fieldtype == "2"){//多行文本
		fieldmectype = "FTextarea";
		valObj["fieldremind"] = MLanguage.getValue($("#MADFDTABLE_FTextAreaRemind", $container)) ||  Mec_FiexdUndefinedVal($("#MADFDTABLE_FTextAreaRemind", $container).val());//多行文本提示信息
	}else if(fieldtype == "3"){//浏览框
		fieldmectype = "FBrowser";
		var browsertype = Mec_FiexdUndefinedVal($("#MADFDETABLE_FBrowserTypeSelect").val());
		valObj["browsertype"] = browsertype;
		
		var browsername = Mec_FiexdUndefinedVal($("#MADFDTABLE_BrowserId").val());
		valObj["browsername"] = browsername;
		
		var _browsername = Mec_FiexdUndefinedVal($("#MADFDTABLE_BrowserName").val());
		valObj["_browsername"] = _browsername;
	}else if(fieldtype == "4"){//check框
		fieldmectype = "FCheck";
	}else if(fieldtype == "5"){//选择框
		fieldmectype = "FSelect";
		var rightActionType = $("input[type='checkbox'][name='MADFDTABLE_FSRightActionType']:checked").val();
		valObj["rightActionType"] = rightActionType;
		var datasource;
		var rightAction_SQL;
		
		if(rightActionType==1) {
			var $rightActionContent = $("#MADFDTABLE_FSRightActionContent_1");
			var $SelectEntry = $(".SelectEntry", $rightActionContent);
			
			var select_datas = [];
			$SelectEntry.each(function(){
				var rowfields = {};
				var id = $(".MADFS_Text_ID", $(this)).val();
				var name = $(".MADFS_Text_NAME", $(this)).val();
				var value = $(".MADFS_Text_VALUE", $(this)).val();
				rowfields.id = id;
				rowfields.name = MLanguage.getValue($(".MADFS_Text_NAME", $(this))) ||  name;
				rowfields.value = value;
				select_datas.push(rowfields);
			});
			valObj["select_datas"] = select_datas;
			
		}else if(rightActionType==2) {
			datasource = $("#MADFDTABLE_FSDatasource").val();
			rightAction_SQL = $("#MADFDTABLE_FSRightAction_SQL").val();
			valObj["datasource"] = datasource;
			valObj["rightAction_SQL"] = rightAction_SQL;
		}
	}else if(fieldtype == "6"){//附件
		fieldmectype = "FFile";
	}else if(fieldtype == "7"){//拍照
		fieldmectype = "FPhoto";
		valObj["isDrawing"] = $("#MADFDTABLE_FPIsDrawing").is(':checked') ? "1" : "0";
		valObj["isCompress"] = $("#MADFDTABLE_FPIsCompress").is(':checked') ? "1" : "0";
		valObj["quality"] = $("#MADFDTABLE_FPQuality").val();
		valObj["zoom"] = $("#MADFDTABLE_FPZoom").val();
		valObj["photoType"] = $("#MADFDTABLE_FPPhotoType").val();
	}else if(fieldtype == "8"){//隐藏域
		fieldmectype = "FHidden";
	}
	var $showtype = $("select[name='showType']", $entry);
	//check框和隐藏域无必填
	if(fieldtype == "4" || fieldtype == "8"){
		$("option[value='3']", $showtype).remove();
		if(fieldtype == "8"){
			$("option[value='1']", $showtype).remove();
		}else{
			if($("option[value='1']", $showtype).length == 0){
				$("<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>").prependTo($showtype);
			}
		}
	}else{
		var $requireopt = $("option[value='3']", $showtype);
		var $editopt = $("option[value='1']", $showtype);
		if($requireopt.length == 0){
			$("<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>").appendTo($showtype);
		}
		if($editopt.length == 0){
			$("<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>").prependTo($showtype);
		}
	}
	$("input[name='fieldmectype']", $entry).val(fieldmectype);
	$fieldTypeProps.val(encodeURIComponent(JSON.stringify(valObj)));
	MADFDTABLE_closeFieldPropPanel();
}