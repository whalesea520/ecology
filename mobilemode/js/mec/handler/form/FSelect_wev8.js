if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FSelect = function(type, id, mecJson){
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
MEC_NS.FSelect.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FSelect.prototype.getDesignHtml = function(){
	var theId = this.id;
	var optionvalues;
	var rightActionTypeV = this.mecJson["rightActionType"];
	
	var select_datas = this.mecJson["select_datas"];
	
	var datasource = this.mecJson["datasource"];
	var rightAction_SQL = this.mecJson["rightAction_SQL"];
	var defaultvalue = this.mecJson["defaultvalue"];
	
	var readonly =  Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");// 只读
	var contentType = (readonly == "1") ? "view" : "edit";
	var htmTemplate = getPluginContentTemplateById(this.type, contentType);
	
	if(rightActionTypeV==1){
		
		optionvalues = select_datas;
		
		if(optionvalues.length==0) {
			var htm = "<div class=\"Design_FSelect_Tip\">"+SystemEnv.getHtmlNoteName(4539)+"</div>";  //信息设置不完整，未添加option
			return htm;
		}else {
			
			
			var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
			htmTemplate = htmTemplate.replace("${fieldlabel}", Mec_FiexdUndefinedVal(fieldlabel));
			
			if(readonly == "1"){
				var selectname = "";
				var selectvalue = "";
				for(var i = 0; i < optionvalues.length; i++){
					var data = optionvalues[i];
					var name = data["name"];
					var value = data["value"];
					if(defaultvalue != "" && defaultvalue == value){
						selectvalue = value;
						selectname = name;
						break;
					}
				}
				htmTemplate = htmTemplate.replace(/\${name}/g, selectname).replace("${value}", selectvalue);
			}else{
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
					forHtml += forContentTemplate.replace("${value}", value)
										.replace("${name}", name).replace("${defSelected}", value == defaultvalue ? "selected=\"selected\"" : "");
				}
				htmTemplate = htmTemplate.replace(forTemplate, forHtml);
			}
			
			return htmTemplate;
			
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
			MADFS_DataGet(theId, datasource, rightAction_SQL, function(status,datas){
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
				
				var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
				htmTemplate = htmTemplate.replace("${fieldlabel}", Mec_FiexdUndefinedVal(fieldlabel));
				
				if(readonly == "1"){
					var selectname = "";
					var selectvalue = "";
					for(var i = 0; i < optionvalues.length; i++){
						var data = optionvalues[i];
						var name = data["name"];
						var value = data["value"];
						if(defaultvalue != "" && defaultvalue == value){
							selectvalue = value;
							selectname = name;
							break;
						}
					}
					htmTemplate = htmTemplate.replace(/\${name}/g, selectname).replace("${value}", selectvalue);
				}else{
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
						forHtml += forContentTemplate.replace("${value}", value)
											.replace("${name}", name).replace("${defSelected}", value == defaultvalue ? "selected=\"selected\"" : "");
					
					}
					htmTemplate = htmTemplate.replace(forTemplate, forHtml);
				}
			
				return htmTemplate;
			}
		}
		
	}
	
	
	
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FSelect.prototype.getAttrDlgHtml = function(){
	
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	
	var htm = "<div id=\"MADFS_"+theId+"\">"
				+ "<div class=\"MADFS_Title\">"+SystemEnv.getHtmlNoteName(4541)+"</div>"  //选择项
				+ "<div class=\"MADFS_BaseInfo\">"
				
				
				
				
						+ "<div>"
						    + "<span class=\"MADFS_BaseInfo_Label MADFS_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
						    + "<select class=\"MADFS_Select\" id=\"formid_"+theId+"\" onchange=\"MADFS_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
					    + "</div>"
					    + "<div>"
						    + "<span class=\"MADFS_BaseInfo_Label MADFS_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
						    + "<select class=\"MADFS_Select\" id=\"fieldname_"+theId+"\"></select>"
						    + "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
								+ "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFS_fieldSearch\" type=\"text\"/>"
								+ "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFS_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
							+ "</span>"
					    + "</div>"
					    + "<div>"
						    + "<span class=\"MADFS_BaseInfo_Label MADFS_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
						    +"<input class=\"MADFS_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\" data-multi=false/>"
					    + "</div>"
					    
					    + "<div class=\"MADFS_BaseInfo_Entry\">"
							+ "<span class=\"MADFS_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4542)+"</span>"  //选择来源：
							+ "<span class=\"MADFS_BaseInfo_Entry_Content\">"
								+ "<span class=\"cbboxEntry\" style=\"width: 100px;\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"1\" onclick=\"MADFS_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4543)+"</span>"  //手动添加
								+ "</span>"
								+ "<span class=\"cbboxEntry\" style=\"width: 130px;\">"
									+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" value=\"2\" onclick=\"MADFS_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4280)+"</span>"  //手动输入SQL
								+ "</span>"
							+ "</span>"
						+ "</div>"
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"_1\" style=\"display: none;position: relative;padding-top: 20px;\">"

						
								+ "<div class=\"select_root_add\" onclick=\"MADFS_AddSelectEntry('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
								
								
								+ "<table class=\"MADFS_Table\" id=\"MADFS_Table_"+theId+"\" style=\"width:100%;\">"
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
						
						+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"_2\" style=\"display: none;\">"
						
							+"<div class=\"MADFS_DataSource\">"
								+"<div style=\"position: relative;padding-left: 75px;\">"
									+"<span class=\"MADFS_DataSource_Label MADFS_DataSource_Label"+styleL+"\" style=\"position: absolute;top: 3px;left: 0px;\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"   //数据源：
									+"<select class=\"MADFS_Select\" id=\"datasource_"+theId+"\">"
										+"  <option value=\"\">(local)</option>"
									+"</select>"
								+"</div>"
							+"</div>"
							
							+ "<textarea id=\"rightAction_SQL_"+theId+"\" class=\"MADFS_Textarea\" placeholder=\""+SystemEnv.getHtmlNoteName(4283)+"\"></textarea>"  //请在此处输入SQL...
							+"<div style=\"padding-top: 3px;\"><a href=\"javascript:void(0);\" onclick=\"MADFS_OpenSQLHelp();\">"+SystemEnv.getHtmlNoteName(4202)+"</a></div>"  //如何书写SQL？
						+ "</div>"
						+"<div>"
							+"<span class=\"MADFS_BaseInfo_Label MADFS_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>"  //显示类型：
							+"<select class=\"MADFS_Select\" id=\"showType_"+theId+"\">"
								+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>"  //可编辑
								+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>"  //只读
								+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>"  //必填
							+"</select>"
						+"</div>"
						+"<div>"
							+ "<span class=\"MADFS_BaseInfo_Label MADFS_BaseInfo_Label1"+styleL+"\" style=\"position:relative;\">"+SystemEnv.getHtmlNoteName(4535)+"</span>"  //默认值：
							+ "<span class=\"fselect_btn_edit\" onclick=\"MADFS_editOneInParamOnPage('"+theId+"')\"></span>"
							+ "<span class=\"fselect_param_paramValue\" id=\"paramValue_"+theId+"\"></span>"
						+"</div>"
						
				+ "</div>"
				+"<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFS_FieldSearchResult MADFS_FieldSearchResult"+styleL+"\"><ul></ul></div>"
				+ "<div class=\"MADFS_Bottom\"><div class=\"MADFS_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FSelect.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var formid = this.mecJson["formid"];// Form mec_id
	var fieldname = this.mecJson["fieldname"];// 对应字段
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var required = Mec_FiexdUndefinedVal(this.mecJson["required"], "0");// 是否必填
	var defaultvalue = this.mecJson["defaultvalue"];// 默认值
	$("#formid_"+theId).val(formid);
	MADFS_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	$("#defaultvalue_"+theId).val(defaultvalue);
	var readonly = Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");
	
	if(required == "1"){
		$("#showType_"+theId).val("3");
	}else if(readonly == "1"){
		$("#showType_"+theId).val("2");
	}else{
		$("#showType_"+theId).val("1");
	}
	
	var rightActionTypeV = this.mecJson["rightActionType"];
	var $rightActionType = $("input[type='checkbox'][name='rightActionType_"+theId+"'][value='"+rightActionTypeV+"']");
	if($rightActionType.length > 0){
		$rightActionType.attr("checked", "checked");
		$rightActionType.triggerHandler("click");
	}
	
	var $attrContainer = $("#MADFS_"+theId);
	var select_datas = this.mecJson["select_datas"];
	if(select_datas && select_datas.length == 0){
		$(".select_empty_tip", $attrContainer).show();
	}
	for(var i = 0; select_datas && i < select_datas.length; i++){
		var data = select_datas[i];
		MADFS_AddSelectEntryToPage(theId, data);
	}
	
	
	//动态获取数据源的值，并给数据源添加HTML
	$("#datasource_" + theId).val(this.mecJson["datasource"]);
	MADFS_setDataSourceHTML(theId,this.mecJson["datasource"]);

	var $sql = $("#rightAction_SQL_"+theId);
	$sql[0].value = this.mecJson["rightAction_SQL"];
	
	$sql.focus(function(){
		$(this).addClass("MADFS_Textarea_Focus");
	});
	$sql.blur(function(){
		$(this).removeClass("MADFS_Textarea_Focus");
	});
	
	var inParams = this.mecJson["inParams"];
	for(var i = 0; inParams && i < inParams.length; i++){
		var $container = $("#MADFS_" + theId);
		$(".fselect_param_paramValue", $container).text(inParams[i]["paramValue"]);
		break;
	}
	
	
	$("#MADFS_"+theId).jNice();
	
	$("#MADFS_Table_"+theId + " > tbody").sortable({
		revert: false,
		axis: "y",
		items: "tr",
		handle: ".bemove"
	});
	MADFS_InitFieldSearch(theId);
	MLanguage({
		container: $("#MADFS_"+theId + " .MADFS_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.FSelect.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFS_"+theId);
	if($attrContainer.length > 0){
		
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		var defaultvalue=Mec_FiexdUndefinedVal($("#paramValue_"+theId).html());
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

		var rightActionType = $("input[type='checkbox'][name='rightActionType_"+theId+"']:checked").val();
		this.mecJson["rightActionType"] = rightActionType;
		
		
		var datasource;
		var rightAction_SQL;
		
		if(rightActionType==1) {
			
			var $rightActionContent = $("#rightActionContent_" + theId + "_1");
			var $SelectEntry = $(".SelectEntry", $rightActionContent);
			
			var select_datas = [];
			$SelectEntry.each(function(){
				var rowfields = {};
				var id = $(".MADFS_Text_ID", $(this)).val();
				var name =  MLanguage.getValue( $(".MADFS_Text_NAME", $(this)))|| $(".MADFS_Text_NAME", $(this)).val();
				var value = $(".MADFS_Text_VALUE", $(this)).val();
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
		var paramValue = $(".fselect_param_paramValue", $attrContainer).text();
		for(var i = 0; i < inParams.length; i++){
			inParams[i]["paramValue"] = paramValue;
			break;
		}
		
	}
	return this.mecJson;
};

MEC_NS.FSelect.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["rightActionType"] = 1;
	
	defMecJson["select_datas"] = [];
	
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

function MADFS_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFS_ChangeRAT(cbObj, mec_id){
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
		
		$("#MADFS_"+mec_id+" .rightActionContent").hide();
		$("#rightActionContent_" + mec_id + "_" + objV).show();
	},100);
}

function MADFS_editOneInParamOnPage(mec_id){
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
		
		var $container = $("#MADFS_" + mec_id);
		$(".fselect_param_paramValue", $container).text(result["paramValue"]);
	};

}

function MADFS_OpenSQLHelp(){
	var url = "/mobilemode/fselectSQLHelp.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 540;//定义长度
	dlg.Height = 455;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4204);  //SQL帮助
	dlg.show();
}

function MADFS_setDataSourceHTML(mec_id,val){
	var $MADFS_DataSource = $("#datasource_" + mec_id);
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
			$MADFS_DataSource.append(dataSourceSelectHtml);
		}
	});
}

function MADFS_DataGet(theId, datasource, sql, fn){
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "&sql="+encodeURIComponent(sql));
	$.ajax({
		type:"POST",
		async:false,
		url:url,
		data:{action:"getDataBySQLWithFSelect",datasource:datasource},
		success : function (responseText){
			var jObj = $.parseJSON(responseText);
			var status = jObj["status"];
			var datas = jObj["datas"];
			fn.call(this, status, datas);
		}
	});
	
}

function MADFS_AddSelectEntry(mec_id){
	var result = {};
	
	var $attrContainer = $("#MADFS_"+mec_id);
	
	var id = new UUID().toString();
	result["id"] = id;
	result["name"] = "";
	result["value"] = "";
		
	$(".select_empty_tip", $attrContainer).hide();
		
	MADFS_AddSelectEntryToPage(mec_id, result);

}

function MADFS_AddSelectEntryToPage(mec_id, result){
	var $attrContainer = $("#MADFS_"+mec_id);
	
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
							+ "<input type=\"text\" id=\"selectname_"+id+"\" value=\""+name+"\"  data-multi=false  class=\"MADFS_Text_NAME\" style=\"width: 140px;\">"
						+ "</td>"
						+ "<td style=\"text-align:right\">"
							+ SystemEnv.getHtmlNoteName(4545)  //值：
						+ "</td>"
						+ "<td>"
						+ "<input type=\"text\" id=\"selectvalue_"+id+"\" value=\""+value+"\" class=\"MADFS_Text_VALUE\" style=\"width: 80px;\">"
						+ "</td>"
						+ "<td align=\"right\">"
							+ "<input type=\"hidden\" value=\""+id+"\" class=\"MADFS_Text_ID\">"
							+ "<span class=\"select_btn_del\" onclick=\"MADFS_DeleteSelectEntry('"+mec_id+"', '"+id+"');\"></span>"
						+ "</td>"
					+ "</tr>";
	
	var $ParentSelectEntry;
	$ParentSelectEntry = $(".MADFS_Table tbody", $attrContainer);
	
	
	$ParentSelectEntry.append(SelectEntry);
	MLanguage({
		container: $ParentSelectEntry.find("#SelectEntry_"+id)
    });
}

function MADFS_DeleteSelectData(mec_id, id){
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

function MADFS_DeleteSelectEntry(mec_id, id){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	MADFS_DeleteSelectData(mec_id, id);
	
	var $attrContainer = $("#MADFS_"+mec_id);
	$("#SelectEntry_" + id, $attrContainer).remove();
	
	var $tableBody = $(".MADFS_Table tbody",$attrContainer);
	if($tableBody.children().length == 0){
		$(".select_empty_tip", $attrContainer).show();
	}
}

function MADFS_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFS_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFS_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFS_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFS_InitFieldSearch(mec_id)
}