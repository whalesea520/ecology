if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FCheckbox = function(type, id, mecJson){
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
MEC_NS.FCheckbox.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FCheckbox.prototype.getDesignHtml = function(){
	var theId = this.id;
	var optionvalues;
	var rightActionTypeV = this.mecJson["rightActionType"];
	var layoutTypeV = this.mecJson["layoutType"];
	layoutTypeV = "FCheckBoxLayout" + (layoutTypeV == undefined ? "vertical" : layoutTypeV);
	var select_datas = this.mecJson["select_datas"];
	
	var datasource = this.mecJson["datasource"];
	var rightAction_SQL = this.mecJson["rightAction_SQL"];
	
	if(rightActionTypeV==1){
		
		optionvalues = select_datas;
		
		if(optionvalues.length==0) {
			var htm = "<div class=\"Design_FSelect_Tip\">"+SystemEnv.getHtmlNoteName(4546)+"</div>";  //信息设置不完整，请添加选项
			return htm;
		}else {
			var htmTemplate = getPluginContentTemplateById(this.type);
			var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
			htmTemplate = htmTemplate.replace("${fieldlabel}", Mec_FiexdUndefinedVal(fieldlabel))
									 .replace("${layoutClass}", layoutTypeV);
			var forTemplate = "";
			var forContentTemplate = "";
			var forStart = htmTemplate.indexOf("$mec_forstart$");
			var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
			if(forStart != -1 && forEnd != -1){
				forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
				forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
			}
			var forHtml = "";
			
			for(var i = 0; i < optionvalues.length; i++){
				var data = optionvalues[i];
				var name = data["name"];
				var value = data["value"];
				forHtml += forContentTemplate.replace("${cb_value}", value)
									.replace("${cb_name}", name);
			
			}
			var htm = htmTemplate.replace(forTemplate, forHtml);
			//htm = htm.replace("<!--", "").replace("-->", "");
			return htm;
			
		}
		
		
	}else if(rightActionTypeV==2){
		
		var theThis = this;
		if($.trim(rightAction_SQL) == ""){
			var htm = "<div class=\"Design_FSelect_Tip\">"+SystemEnv.getHtmlNoteName(4274)+"</div>";  //信息设置不完整，未配置数据来源SQL
			return htm;
		}else{
			
			rightAction_SQL = $m_encrypt(rightAction_SQL);// 系统安全编码
			if(rightAction_SQL == ""){// 系统安全关键字验证不通过
				var tipHtm = "<div class=\"Design_FSelect_Tip\">"+SystemEnv.getHtmlNoteName(4207)+"</div>";  //数据来源SQL未通过系统安全测试，请检查关键字
				return tipHtm;
			}
			
			var flag;
			MADFC_DataGet(theId, datasource, rightAction_SQL, function(status,datas){
				if(status == "0"){
					flag = 0;
				}else if(status == "-1"){
					flag = -1;
				}else if(status == "1"){
					flag = 1;
					optionvalues = datas;
				}
			});
			
			if(flag==0){
				var htm = "<div class=\"Design_FSelect_Tip\">"+SystemEnv.getHtmlNoteName(4208)+"</div>";  //查询数据来源SQL时出现错误，请检查SQL是否拼写正确
				return htm;
			}else if(flag==-1) {
				var htm = "<div class=\"Design_FSelect_Tip\">"+SystemEnv.getHtmlNoteName(4540)+"</div>";  //出现异常
				return htm;
			}else if(flag==1) {
				
				var htmTemplate = getPluginContentTemplateById(this.type);
				var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
				htmTemplate = htmTemplate.replace("${fieldlabel}", Mec_FiexdUndefinedVal(fieldlabel))
										.replace("${layoutClass}", layoutTypeV);
				var forTemplate = "";
				var forContentTemplate = "";
				var forStart = htmTemplate.indexOf("$mec_forstart$");
				var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
				if(forStart != -1 && forEnd != -1){
					forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
					forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
				}
				var forHtml = "";
				
				for(var i = 0; i < optionvalues.length; i++){
					var data = optionvalues[i];
					var name = data["name"];
					var value = data["value"];
					forHtml += forContentTemplate.replace("${cb_value}", value)
										.replace("${cb_name}", name);
				
				}
				var htm = htmTemplate.replace(forTemplate, forHtml);
				//htm = htm.replace("<!--", "").replace("-->", "");
				return htm;
				
			}
		}
		
	}
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FCheckbox.prototype.getAttrDlgHtml = function(){
	
	var styleL = "_style" + _userLanguage;

	var tip = "";
	if(_userLanguage=="8"){
		tip = "According to the page passes the name cbType the parameters of the rule: <br/>cbType=0 for radio; <br/>cbType=1 for checkbox; <br/> the rest still for radio.";
	}else if(_userLanguage=="9"){
		tip = "根據頁面傳遞名稱爲cbType的參數進行裁定：<br/>cbType=0時爲單選；<br/>cbType=1時爲多選；<br/>其餘情況仍爲單選；";
	}else{
		tip = "根据页面传递名称为cbType的参数进行裁定：<br/>cbType=0时为单选；<br/>cbType=1时为多选；<br/>其余情况仍为单选；";
	}

	var theId = this.id;
	
	var htm = "<div id=\"MADFC_"+theId+"\">"
				+ "<div class=\"MADFC_Title\">"+SystemEnv.getHtmlNoteName(4547)+"</div>"  //生成select
				+ "<div class=\"MADFC_BaseInfo\">"
				
				
				
				
						+ "<div>"
						    + "<span class=\"MADFC_BaseInfo_Label MADFC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
						    + "<select class=\"MADFC_Select\" id=\"formid_"+theId+"\" onchange=\"MADFC_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
					    + "</div>"
					    + "<div>"
						    + "<span class=\"MADFC_BaseInfo_Label MADFC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
						    + "<select class=\"MADFC_Select\" id=\"fieldname_"+theId+"\"></select>"
						    + "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
								+ "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFC_fieldSearch\" type=\"text\"/>"
								+ "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFC_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
							+ "</span>"
					    + "</div>"
					    + "<div>"
						    + "<span class=\"MADFC_BaseInfo_Label MADFC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
						    +"<input class=\"MADFC_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\"  data-multi=false/>"
					    + "</div>"
					    
						+ "<div>"
							+ "<span class=\"MADFC_BaseInfo_Label MADFC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4548)+"</span>"  //选择类型：
							+ "<span>"
							+ "<select class=\"MADFC_Select\" id=\"cbType_"+theId+"\" onchange=\"MADFC_CbTypeChange('"+theId+"');\">"
								+"<option value=\"0\">"+SystemEnv.getHtmlNoteName(4549)+"</option>"  //单选
								+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4550)+"</option>"  //多选
								+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4551)+"</option>"  //变量裁定
							+ "</select>"
							+ "</span>"
						+ "</div>"
					    
						+ "<div id=\"cbTypeTip_"+theId+"\" class=\"cbTypeTip_desc cbTypeTip_desc"+styleL+"\">"+tip+"</div>"  //根据页面传递名称为cbType的参数进行裁定：<br/>cbType=0时为单选；<br/>cbType=1时为多选；<br/>其余情况仍为单选；
						
					    + "<div class=\"MADFC_BaseInfo_Entry\">"
							+ "<span class=\"MADFC_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4542)+"</span>"  //选择来源：
							+ "<span class=\"MADFC_BaseInfo_Entry_Content\">"
								+ "<span class=\"cbboxEntry\" style=\"width: 100px;\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"1\" onclick=\"MADFC_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4543)+"</span>"  //手动添加
								+ "</span>"
								+ "<span class=\"cbboxEntry\" style=\"width: 130px;\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"2\" onclick=\"MADFC_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4280)+"</span>"  //手动输入SQL
								+ "</span>"
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"_1\" style=\"display: none;position: relative;padding-top: 20px;\">"

						
								+ "<div class=\"checkbox_root_add\" onclick=\"MADFC_AddSelectEntry('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
								
								
								+ "<table class=\"MADFC_Table\" id=\"MADFC_Table_"+theId+"\" style=\"width:100%;\">"
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
								
								+ "<div class=\"checkbox_empty_tip\">"+SystemEnv.getHtmlNoteName(4159)+"</div>"  //单击右上角的添加按钮以添加内容
			
																
						+ "</div>"
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"_2\" style=\"display: none;\">"
						
							+"<div class=\"MADFC_DataSource\">"
								+"<div style=\"position: relative;padding-left: 75px;\">"
									+"<span class=\"MADFC_DataSource_Label MADFC_DataSource_Label"+styleL+"\" style=\"position: absolute;top: 3px;left: 0px;\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"   //数据源：
									+"<select class=\"MADFC_Select\" id=\"datasource_"+theId+"\">"
										+"  <option value=\"\">(local)</option>"
									+"</select>"
								+"</div>"
							+"</div>"
							
							+ "<textarea id=\"rightAction_SQL_"+theId+"\" class=\"MADFC_Textarea\" placeholder=\""+SystemEnv.getHtmlNoteName(4283)+"\"></textarea>"  //请在此处输入SQL...
							+"<div style=\"padding-top: 3px;\"><a href=\"javascript:void(0);\" onclick=\"MADFC_OpenSQLHelp();\">"+SystemEnv.getHtmlNoteName(4202)+"</a></div>"  //如何书写SQL？
						+ "</div>"
						+ "<div>"
							+ "<span class=\"MADFC_BaseInfo_Label MADFC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4552)+"</span>"  //插件样式：
							+ "<span class=\"cbboxEntry cbboxEntry_style cbboxEntry"+styleL+"\">"
								+ "<input type=\"checkbox\" name=\"layout_"+theId+"\" value=\"vertical\" onclick=\"MADFC_ChangeLayout(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4553)+"</span>"  //纵向排列
							+ "</span>"
							+ "<span class=\"cbboxEntry cbboxEntry_style cbboxEntry"+styleL+"\">"
								+ "<input type=\"checkbox\" name=\"layout_"+theId+"\" value=\"horizontal\" onclick=\"MADFC_ChangeLayout(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4554)+"</span>"  //横向排列
							+ "</span>"
						+ "</div>"
						+"<div>"
							+"<span class=\"MADFC_BaseInfo_Label MADFC_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>"  //显示类型：
							+"<select class=\"MADFC_Select\" id=\"showType_"+theId+"\">"
								+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>"  //可编辑
								+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>"  //只读
								+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>"  //必填
							+"</select>"
						+"</div>"
						+"<div>"
							+ "<span class=\"MADFC_BaseInfo_Label MADFC_BaseInfo_Label1"+styleL+"\" style=\"position:relative;\">"+SystemEnv.getHtmlNoteName(4535)+"</span>"  //默认值：
							+ "<span class=\"fcheckbox_btn_edit\" onclick=\"MADFC_editOneInParamOnPage('"+theId+"')\"></span>"
							+ "<span class=\"fcheckbox_param_paramValue\" id=\"paramValue_"+theId+"\"></span>"
						+"</div>"
						
				+ "</div>"
				+"<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFC_FieldSearchResult MADFC_FieldSearchResult"+styleL+"\"><ul></ul></div>"
				+ "<div class=\"MADFC_Bottom\"><div class=\"MADFC_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FCheckbox.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var formid = this.mecJson["formid"];// Form mec_id
	var fieldname = this.mecJson["fieldname"];// 对应字段
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var readonly = Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");//是否只读
	var required = Mec_FiexdUndefinedVal(this.mecJson["required"], "0");// 是否必填
	var defaultvalue = this.mecJson["defaultvalue"];// 默认值
	$("#formid_"+theId).val(formid);
	MADFC_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	if(required == "1"){
		$("#showType_"+theId).val("3");
	}else if(readonly == "1"){
		$("#showType_"+theId).val("2");
	}else{
		$("#showType_"+theId).val("1");
	}
	$("#defaultvalue_"+theId).val(defaultvalue);
	
	var cbType = Mec_FiexdUndefinedVal(this.mecJson["cbType"], "0");
	$("#cbType_"+theId).val(cbType);
	MADFC_CbTypeChange(theId);
	
	var rightActionTypeV = this.mecJson["rightActionType"];
	var $rightActionType = $("input[type='checkbox'][name='rightActionType_"+theId+"'][value='"+rightActionTypeV+"']");
	if($rightActionType.length > 0){
		$rightActionType.attr("checked", "checked");
		$rightActionType.triggerHandler("click");
	}
	
	var layoutTypeV = this.mecJson["layoutType"];
	layoutTypeV = (layoutTypeV == undefined ? "vertical" : layoutTypeV);
	var $layoutType = $("input[type='checkbox'][name='layout_"+theId+"'][value='"+layoutTypeV+"']");
	if($layoutType.length > 0){
		$layoutType.attr("checked", "checked");
		$layoutType.triggerHandler("click");
	}
	
	var $attrContainer = $("#MADFC_"+theId);
	var select_datas = this.mecJson["select_datas"];
	if(select_datas && select_datas.length == 0){
		$(".checkbox_empty_tip", $attrContainer).show();
	}
	for(var i = 0; select_datas && i < select_datas.length; i++){
		var data = select_datas[i];
		MADFC_AddCheckboxEntryToPage(theId, data);
	}
	
	
	//动态获取数据源的值，并给数据源添加HTML
	$("#datasource_" + theId).val(this.mecJson["datasource"]);
	MADFC_setDataSourceHTML(theId,this.mecJson["datasource"]);

	var $sql = $("#rightAction_SQL_"+theId);
	$sql[0].value = this.mecJson["rightAction_SQL"];
	
	$sql.focus(function(){
		$(this).addClass("MADFC_Textarea_Focus");
	});
	$sql.blur(function(){
		$(this).removeClass("MADFC_Textarea_Focus");
	});
	
	var inParams = this.mecJson["inParams"];
	for(var i = 0; inParams && i < inParams.length; i++){
		var $container = $("#MADFC_" + theId);
		$(".fcheckbox_param_paramValue", $container).text(inParams[i]["paramValue"]);
		break;
	}
	
	
	$("#MADFC_"+theId).jNice();
	
	$("#MADFC_Table_"+theId + " > tbody").sortable({
		revert: false,
		axis: "y",
		items: "tr",
		handle: ".bemove"
	});
	MADFC_InitFieldSearch(theId);
	MLanguage({
		container: $("#MADFC_"+theId + " .MADFC_BaseInfo")
    });
	MLanguage({
		container: $("#MADFC_"+theId + " .SelectEntry")
    });
	
	
};

/*获取JSON*/
MEC_NS.FCheckbox.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFC_"+theId);
	if($attrContainer.length > 0){
		
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		var defaultvalue=Mec_FiexdUndefinedVal($("#defaultvalue_"+theId).val());
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] = MLanguage.getValue($("#fieldlabel_"+theId))||fieldlabel;
		this.mecJson["defaultvalue"] = defaultvalue;
		var showType = $("#showType_"+theId).val();
		if(showType == "1"){
			this.mecJson["required"] = "0";
			this.mecJson["readonly"] = "0";
		}else if(showType == "2"){
			this.mecJson["required"] = "0";
			this.mecJson["readonly"] = "1";
		}else{
			this.mecJson["required"] = "1";
			this.mecJson["readonly"] = "0";
		}

		this.mecJson["cbType"] = $("#cbType_"+theId).val();
		var rightActionType = $("input[type='checkbox'][name='rightActionType_"+theId+"']:checked").val();
		this.mecJson["rightActionType"] = rightActionType;
		
		var layoutType = $("input[type='checkbox'][name='layout_"+theId+"']:checked").val();
		this.mecJson["layoutType"] = layoutType;
		
		var datasource;
		var rightAction_SQL;
		
		if(rightActionType==1) {
			
			var $rightActionContent = $("#rightActionContent_" + theId + "_1");
			var $SelectEntry = $(".SelectEntry", $rightActionContent);
			
			var select_datas = [];
			$SelectEntry.each(function(){
				var rowfields = {};
				var id = $(".MADFC_Text_ID", $(this)).val();
				var name = MLanguage.getValue( $(".MADFC_Text_NAME", $(this)))|| $(".MADFC_Text_NAME", $(this)).val();
				var value = $(".MADFC_Text_VALUE", $(this)).val();
				rowfields.id = id;
				rowfields.name = name;
				rowfields.value = value;
				select_datas.push(rowfields);
			});
			this.mecJson["select_datas"] = select_datas;
			
		}else if(rightActionType==2) {
			datasource = $("#datasource_" + theId).val();
			rightAction_SQL = $("#rightAction_SQL_"+theId).val();
			this.mecJson["datasource"] = datasource;
			this.mecJson["rightAction_SQL"] = rightAction_SQL;
		}
		
		var inParams = this.mecJson["inParams"];
		var paramValue = $(".fcheckbox_param_paramValue", $attrContainer).text();
		for(var i = 0; i < inParams.length; i++){
			inParams[i]["paramValue"] = paramValue;
			break;
		}
		
	}
	return this.mecJson;
};

MEC_NS.FCheckbox.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["rightActionType"] = 1;
	defMecJson["layoutType"] = "vertical";
	
	defMecJson["select_datas"] = [];
	
	defMecJson["cbType"] = "1";
	
	defMecJson["datasource"] = "";
	defMecJson["rightAction_SQL"] = "";
	
	var inParams = [
						{
							paramValue : ""
						}
					];
	defMecJson["inParams"] = inParams;
	
	return defMecJson;
};

function MADFC_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFC_ChangeRAT(cbObj, mec_id){
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
		
		$("#MADFC_"+mec_id+" .rightActionContent").hide();
		$("#rightActionContent_" + mec_id + "_" + objV).show();
	},100);
}

function MADFC_ChangeLayout(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		var objV = cbObj.value;
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
			return;
		}else{
			$("input[type='checkbox'][name='layout_"+mec_id+"']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
	},100);
}

function MADFC_editOneInParamOnPage(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var inParams = mecHandler.mecJson["inParams"];
	var paramobj = null;
	for(var i = 0; i < inParams.length; i++){
		paramobj = inParams[i];
		break;
	}
	
	var paramValue = paramobj["paramValue"];
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
		paramobj["paramValue"] = result["paramValue"];
		
		var $container = $("#MADFC_" + mec_id);
		$(".fcheckbox_param_paramValue", $container).text(result["paramValue"]);
	};

}

function MADFC_OpenSQLHelp(){
	var url = "/mobilemode/fselectSQLHelp.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 540;//定义长度
	dlg.Height = 455;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4204);  //SQL帮助
	dlg.show();
}

function MADFC_setDataSourceHTML(mec_id,val){
	var $MADFC_DataSource = $("#datasource_" + mec_id);
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
			$MADFC_DataSource.append(dataSourceSelectHtml);
		}
	});
}

function MADFC_DataGet(theId, datasource, sql, fn){
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "&sql="+encodeURIComponent(sql));
	$.ajax({
		type:"POST",
		async:false,
		url:url,
		data:{action:"getDataBySQLWithFCheckbox",datasource:datasource},
		success : function (responseText){
			var jObj = $.parseJSON(responseText);
			var status = jObj["status"];
			var datas = jObj["datas"];
			fn.call(this, status, datas);
		}
	});
	
}

function MADFC_AddSelectEntry(mec_id){
	var result = {};
	
	var $attrContainer = $("#MADFC_"+mec_id);
	
	var id = new UUID().toString();
	result["id"] = id;
	result["name"] = "";
	result["value"] = "";
		
	$(".checkbox_empty_tip", $attrContainer).hide();
		
	MADFC_AddCheckboxEntryToPage(mec_id, result);

}

function MADFC_AddCheckboxEntryToPage(mec_id, result){
	var $attrContainer = $("#MADFC_"+mec_id);
	
	var id = result["id"];
	var name = result["name"];
	var value = result["value"];
	
	var SelectEntry = "<tr id=\"SelectEntry_"+id+"\" class=\"SelectEntry\" >"
						+ "<td class=\"bemove\">"
						+ "</td>"
						+ "<td style=\"text-align:right\">"
							+ SystemEnv.getHtmlNoteName(4544)  //显示：
						+ "</td>"
						+ "<td>"
							+ "<input type=\"text\" id=\"selectname_"+id+"\" value=\""+name+"\"  data-multi=false  class=\"MADFC_Text_NAME\" style=\"width: 140px;\">"
						+ "</td>"
						+ "<td style=\"text-align:right\">"
							+ SystemEnv.getHtmlNoteName(4545)  //值：
						+ "</td>"
						+ "<td>"
						+ "<input type=\"text\" id=\"selectvalue_"+id+"\" value=\""+value+"\" class=\"MADFC_Text_VALUE\" style=\"width: 80px;\">"
						+ "</td>"
						+ "<td align=\"right\">"
							+ "<input type=\"hidden\" value=\""+id+"\" class=\"MADFC_Text_ID\">"
							+ "<span class=\"checkbox_btn_del\" onclick=\"MADFC_DeleteCheckboxEntry('"+mec_id+"', '"+id+"');\"></span>"
						+ "</td>"
					+ "</tr>";
	
	var $ParentSelectEntry;
	$ParentSelectEntry = $(".MADFC_Table tbody", $attrContainer);
	
	
	$ParentSelectEntry.append(SelectEntry);
	MLanguage({
		container: $ParentSelectEntry.find("#SelectEntry_"+id)
    });
}

function MADFC_DeleteCheckboxData(mec_id, id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var select_datas = mecHandler.mecJson["select_datas"];
	var index = -1;
	for(var i = 0; i < select_datas.length; i++){
		var data = select_datas[i];
		if(data["id"] == id){
			index = i;
			break;
		}
	}
	if(index != -1){
		select_datas.splice(index, 1);
	}
}

function MADFC_DeleteCheckboxEntry(mec_id, id){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	MADFC_DeleteCheckboxData(mec_id, id);
	
	var $attrContainer = $("#MADFC_"+mec_id);
	$("#SelectEntry_" + id, $attrContainer).remove();
	
	var $tableBody = $(".MADFC_Table tbody",$attrContainer);
	if($tableBody.children().length == 0){
		$(".checkbox_empty_tip", $attrContainer).show();
	}
}

function MADFC_InitFieldSearch(mec_id){
	var $searchText = $("#fieldSearch_" + mec_id);
	var $searchTextTip = $("#fieldSearchTip_" + mec_id);
	
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
	
	var $srarchResult = $("#fieldSearchResult_" + mec_id);
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
				preSearchText = this.value;
				var searchValue = this.value;
				//clearSearchResult();
				
				var resultHtml = "";
				
				var $vfieldName = $("#fieldname_"  + mec_id);
				$vfieldName.find("option").each(function(){
					var vt = $(this).text();
					var vv = $(this).attr("value");
					if(vt.toLowerCase().indexOf(searchValue.toLowerCase()) != -1){
						resultHtml += "<li><a href=\"javascript:MADFC_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFC_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFC_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFC_InitFieldSearch(mec_id)
}

function MADFC_CbTypeChange(mec_id){
	var cbType = $("#cbType_" + mec_id).val();
	if(cbType == "2"){
		$("#cbTypeTip_" + mec_id).show();
	}else{
		$("#cbTypeTip_" + mec_id).hide();
	}
}