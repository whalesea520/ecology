if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Form = function(type, id, mecJson){
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
MEC_NS.Form.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Form.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var tablename = this.mecJson["formname"];
	if(tablename==""){
		tablename="&lt;Form&gt;&lt;/Form&gt;";
	}
	var htm  = "<div class=\"Design_Form_Container\" style=\"height: 30px; \"><div class=\"Design_Form_Tip\">"+tablename+"</div></div>"
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Form.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var uitype = -1;
	if(typeof(window._uitype) != "undefined"){
		uitype = window._uitype;
	}
	var disabled = "";
	if(uitype > -1){
		disabled = " form-disabled ";
	}
	
	var tip = "";
	if(_userLanguage=="8"){
		tip = "Variable support Description: \n1. process name {workflowname}\n2. field value {fieldname}\n3. system variables, such as: {currusername}, {currdate}, {currtime}, etc.";
	}else if(_userLanguage=="9"){
		tip = "變量支持說明:\n1.流程名稱{workflowname}\n2.字段值{fieldname}\n3.系統變量,如:{currusername}、{currdate}、{currtime}等";
	}else{
		tip = "变量支持说明:\n1.流程名称{workflowname}\n2.字段值{fieldname}\n3.系统变量,如:{currusername}、{currdate}、{currtime}等";
	}
	var theId = this.id;
	
	var htm = "<div id=\"MADF_"+theId+"\"  style=\"min-height: 240px;\">";
	htm += "<div class=\"MADF_Title\">Form</div>"
	 	+ "<div class=\"MADF_loading\">"
	 		+ "<span>"+SystemEnv.getHtmlNoteName(4317)+"</span>"  //数据加载中，请等待...
	 	+ "</div>";
	htm += "<div class=\"MADF_BaseInfo " + disabled + "\" title=\""+SystemEnv.getHtmlNoteName(4771)+"\">"
				+ "<div>"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4497)+"</span>"  //表单名称：
					+ "<input type=\"text\" id=\"formname_"+theId+"\" class=\"MADF_Text\"/>"
				+ "</div>"
				+ "<div>"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4498)+"</span>"  //提交类型：
					+ "<span class=\"MADButton_style_content\">"
						+ "<span class=\"MADButton_style_title1 MADButton_style_title1"+styleL+"\">"
							+ "<input type=\"checkbox\" name=\"formtype_"+theId+"\" value=\"1\" onclick=\"MADF_ChangeType(this, '"+theId+"');\"><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4499)+"</span>"  //表单建模
						+ "</span>"
						+ "<span class=\"MADButton_style_title1 MADButton_style_title1"+styleL+"\">"
							+ "<input type=\"checkbox\" name=\"formtype_"+theId+"\" value=\"2\" onclick=\"MADF_ChangeType(this, '"+theId+"');\"><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4500)+"</span>"  //创建流程
						+ "</span>"
						+ "<span class=\"MADButton_style_title2 MADButton_style_title2"+styleL+"\">"
							+ "<input type=\"checkbox\" name=\"formtype_"+theId+"\" value=\"3\" onclick=\"MADF_ChangeType(this, '"+theId+"');\"><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4501)  //自定义URL
							+"<a title=\""+SystemEnv.getHtmlNoteName(4502)+"\" id=\"downtempletimg_"+theId+"\" href='/weaver/weaver.formmode.servelt.DownloadFile?filename=/mobilemode/templet/templetAction.jsp'><img  style=\"width:14px;cursor:pointer;padding-left:3px;border:0px;\"  src='/mobilemode/images/download_wev8.png' /></a>"  //下载模版
						+ "</span>"
					+ "</span>"
				+ "</div>"
				+ "<div id=\"formURL_"+theId+"\">"
				+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4326)+"</span>"  //提交URL：
				+ "<input type=\"text\" id=\"formsuburl_"+theId+"\" class=\"MADF_Text\"/>"
				+ "</div>"
				+ "<div>"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4201)+"</span>"  //数据源：
					+ "<select class=\"MADF_Select\" id=\"datasource_"+theId+"\" onchange=\"MADF_DataSourceChange('"+theId+"');\">"
					+"  <option value=\"$ECOLOGY_SYS_LOCAL_POOLNAME\">(local)</option>"
					+ "</select>"
					+ "<input type=\"button\" id=\"reloadbutton_"+theId+"\" class=\"MADF_Reloadbutton\" onclick=\"MADF_RemoveTablesFromComInfo('"+theId+"')\" value=\""+SystemEnv.getHtmlNoteName(4335)+"\"/>"  //清除缓存
				+ "</div>"
				+ "<div  id=\"sourceSearchWarp_"+theId+"\">"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4327)+" </span>"  //表名：
					+ "<div id=\"tablenameContainer_"+theId+"\" style=\"display:inline-block;margin-bottom:0px;\">"
						+ "<select class=\"MADF_Select\" id=\"tablename_"+theId+"\" onchange=\"MADF_TableChangeBefore('"+theId+"');\">"
						+ "</select>"
					+ "</div>"
					+ "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
						+ "<INPUT id=\"sourceSearch_"+theId+"\" class=\"MADF_SourceSearch\" type=\"text\"/>"
						+ "<div id=\"sourceSearchTip_"+theId+"\" class=\"MADF_SourceSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
					+ "</span>"
					+ "</span>"
				+ "</div>"
				+ "<div>"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4503)+" </span>"  //主键：
					+ "<select class=\"MADF_Select\" id=\"keyname_"+theId+"\">"
					+ "</select>"
				+ "</div>"
				+ "<div id=\"relateMode_"+theId+"\" style=\"display:none;\">"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4504)+" </span>"  //关联模块：
					+ "<input style=\"display:none;\" id=\"modelname_"+theId+"\" class=\"MADF_Text2\" type=\"text\" readonly=\"readonly\" style=\"\"/>"
					+ "<input id=\"modelid2_"+theId+"\" type=\"hidden\"/>"
					+ "<button style=\"display:none;\" type=\"button\" onclick=\"MADF_openModelChoose('"+theId+"')\" class=\"MADF_BrowserBtn\"></button>"
					+ "<select class=\"MADF_Select\" id=\"modelid_"+theId+"\">"
					+ "</select>"
				+ "</div>"
				+ "<div id=\"relateWorkFlow_"+theId+"\" style=\"display:none;\">"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4505)+" </span>"  //关联流程：
					+ "<select class=\"MADF_Select\" id=\"workflowid_"+theId+"\">"
					+ "</select>"
				+ "</div>"
				+ "<div id=\"workflowTitleContainer_"+theId+"\" style=\"display:none;position:relative;\">"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4627)+"</span>"  //流程标题：
					+ "<input type=\"text\" id=\"workflowtitle_"+theId+"\" class=\"MADF_Text\"/>"
					+ "<img src=\"/images/remind_wev8.png\" style=\"\" title=\""+tip+"\"/>"  //变量支持说明:\n1.流程名称{workflowname}\n2.字段值{fieldname}\n3.系统变量,如:{currusername}、{currdate}、{currtime}等
				+ "</div>"
				+ "<div>"
					+ "<span class=\"MADF_BaseInfo_Label MADF_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4506)+" </span>"  //验证脚本：
					+ "<span class=\"MADF_ClickBtn\" onclick=\"MADF_writeValidateScript('"+theId+"')\">"
					+ "<input id=\"validateScript_"+theId+"\" type=\"hidden\" value=\"\"/>"
					+ "<label class=\"scriptTip\" id=\"scriptTip_"+theId+"\">"+SystemEnv.getHtmlNoteName(4507)+"</label>"  //点击输入提交前验证脚本
					+ "</span>"
				+ "</div>"
			+ "</div>";
	htm += "<div id=\"sourceSearchResult_"+theId+"\" class=\"MADF_SourceSearchResult MADF_SourceSearchResult"+styleL+"\"><ul></ul></div>";
	htm += "<div class=\"MADF_Bottom\"><div class=\"MADF_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	
	htm += "<div id=\"errorMsgContainer\" style=\"border: 1px solid red;margin: 3px 0px;padding: 3px;display: none;\">"
	htm += "	<div id=\"errorMsgTitle\" style=\"color: red;font-weight: bold;\"></div>"
	htm += "	<div style=\"color: red;\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id=\"errorMsgContent\"></span></div>"
	htm += "</div>"
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Form.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var formname = this.mecJson["formname"];
	var formsuburl = this.mecJson["formsuburl"];
	var datasource = this.mecJson["datasource"];
	var tablename = this.mecJson["tablename"];
	var keyname = this.mecJson["keyname"];
	var modelid = this.mecJson["modelid"];
	var modelname = this.mecJson["modelname"];
	var validateScript = Mec_FiexdUndefinedVal(this.mecJson["validateScript"]);
	MADF_ChangeScriptTip(theId, validateScript);
	if(formsuburl==null||formsuburl==""){
		formsuburl = "/mobilemode/formComponentAction.jsp";
	}
	var formtype = this.mecJson["formtype"];
	if(formtype == undefined) formtype = "1";//兼容老版本
	var $formType = $("input[type='checkbox'][name='formtype_" + theId + "'][value='" + formtype + "']");
	if($formType.length > 0){
		$formType.attr("checked", "checked");
		$formType.triggerHandler("click");
	}
	
	var workflowtitle = this.mecJson["workflowtitle"];
	if(workflowtitle == undefined) workflowtitle = "{workflowname}(表单提交流程)-{currusername}-{currdate}";
	
	$("#formname_"+theId).val(formname);
	$("#formsuburl_"+theId).val(formsuburl);
	$("#datasource_"+theId).val(datasource);
	$("#tablename_"+theId).val(tablename);
	$("#keyname_"+theId).val(keyname);
	$("#modelid_"+theId).val(modelid);
	$("#modelname_"+theId).val(modelname);
	$("#validateScript_"+theId)[0].value = validateScript;
	$("#workflowtitle_"+theId).val(workflowtitle);
	
	MADF_setDataSourceHTML(theId,datasource,tablename);
	MADF_InitSourceSearch(theId);
	$("#MADF_" + theId).jNice();
};

/*获取JSON*/
MEC_NS.Form.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADF_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["formname"] = $("#formname_"+theId).val();
		this.mecJson["formsuburl"] = $("#formsuburl_"+theId).val();
		this.mecJson["datasource"] = $("#datasource_"+theId).val();
		this.mecJson["tablename"] = $("#tablename_"+theId).val();
		var keyname = $("#keyname_"+theId).val();
		this.mecJson["keyname"] = (keyname == null ? "id" : keyname);
		this.mecJson["modelid"] = $("#modelid_"+theId).val();
		this.mecJson["modelname"] = $("#modelid_"+theId).find("option:selected").text();
		this.mecJson["validateScript"] = $("#validateScript_"+theId).val();
		this.mecJson["workflowid"] = $("#workflowid_" + theId).val();
		this.mecJson["workflowtitle"] = $("#workflowtitle_" + theId).val();
	}
	return this.mecJson;
};

MEC_NS.Form.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["formname"] = SystemEnv.getHtmlNoteName(4508);  //表单1
	defMecJson["formtype"] = "1";
	defMecJson["formsuburl"] = "/mobilemode/formComponentAction.jsp";
	defMecJson["datasource"] = "";
	defMecJson["tablename"] = "";
	defMecJson["keyname"] = "id";
	defMecJson["workflowid"] = "";
	defMecJson["workflowtitle"] = "{workflowname}(表单提交流程)-{currusername}-{currdate}";
	
	return defMecJson;
};

function MADF_TableChangeBefore(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var keyname = $("#keyname_" + mec_id).val();
	if(keyname != null && keyname != ""){//缓存当改变主键而又未保存时的值
		mecHandler.mecJson["keyname"] = keyname;
	}
	
	MADF_TableChange(mec_id,mecHandler.mecJson["keyname"], mecHandler.mecJson["workflowid"], mecHandler.mecJson["modelid"]);
}

function MADF_TableChange(mec_id,selectedField, selectedWorkflow, selectedModel){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	mecHandler.mecJson["tablename"] = $("#tablename_" + mec_id).val();
	var formtype = mecHandler.mecJson["formtype"];
	
	var formid = mec_id;
	if(formtype == "2"){
		Mec_GetWorkflowOptionHtml(formid, "workflowid_" + mec_id, selectedWorkflow, false);
	}else{
		Mec_GetFieldOptionHtml(formid, "keyname_"+mec_id, selectedField, true);
		Mec_GetTableModelOptionHtml(formid, "modelid_" + mec_id, selectedModel, true);
	}
}

function MADF_setDataSourceHTML(mec_id,datasource,tablename){
	var $MADF_DataSource = $("#datasource_" + mec_id);
	var url = jionActionUrl("com.weaver.formmodel.mobile.servlet.MobileAppBaseAction", "action=getDataSource");
	FormmodeUtil.doAjaxDataLoad(url, function(datas){
		for(var i = 0; i < datas.length; i++){
			var data = datas[i];
			var pointid = data;
			var selected = "";
			if (pointid=="" || typeof(pointid)=="undefined") continue;
			if (pointid == datasource) selected = "selected";
			var dataSourceSelectHtml = "<option value=\""+pointid+"\" "+selected+">";
			dataSourceSelectHtml += pointid;
			dataSourceSelectHtml += "</option>";
			$MADF_DataSource.append(dataSourceSelectHtml);
		}
		MADF_DataSourceChange(mec_id,tablename);
	});
}

function MADF_DataSourceChange(mec_id,tablename){
	resetErrorMsg();
	var $vdatasource = $("#datasource_" + mec_id);
	var $vtableName = $("#tablename_" + mec_id);
	var $vtableName_loading = $(".MADF_loading");
	var vdatasourceV = $vdatasource.val();
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	mecHandler.mecJson["datasource"] = vdatasourceV;

	$vdatasource.attr("disabled",true);
	$vtableName.attr("disabled",true);
	$vtableName_loading.show();
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getDataSourceTables&datasource="+vdatasourceV);
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		var status = result.status;
		if(status == "1"){
			var data = result.data;
			MADF_addTablenameOption(mec_id,data,tablename);
			MADF_TableChange(mec_id,mecHandler.mecJson["keyname"], mecHandler.mecJson["workflowid"], mecHandler.mecJson["modelid"]);
		}else{
			var errorMsg = result.errorMsg;
			setErrorMsg(SystemEnv.getHtmlNoteName(4333), errorMsg);  //获取表(视图)时发生如下错误：
			
			var $vkeyname = $("#keyname_" + mec_id);
			var $vworkflowid = $("#workflowid_" + mec_id);
			var $vmodelid = $("#modelid_" + mec_id);
			$vtableName.empty();
			$vkeyname.empty();
			$vworkflowid.empty();
			$vmodelid.empty();
			$vdatasource.removeAttr("disabled");
			$vtableName.removeAttr("disabled");
			$vtableName_loading.hide();
		}
	});
}

function MADF_addTablenameOption(mec_id,data,tablename){
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
	
	var $vdatasource = $("#datasource_" + mec_id);
	var $vtableName_loading = $(".MADF_loading");
	$vdatasource.removeAttr("disabled");
	$vtableName.removeAttr("disabled");
	$vtableName_loading.hide();
}

function setErrorMsg(title, content){
	$("#errorMsgTitle").html(title);
	$("#errorMsgContent").html(content);
	$("#errorMsgContainer").show();
}

function resetErrorMsg(){
	$("#errorMsgTitle").html("");
	$("#errorMsgContent").html("");
	$("#errorMsgContainer").hide();
}

function MADF_InitSourceSearch(mec_id){
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
				//clearSearchResult();
				
				var resultHtml = "";
				
				var $vtableName = $("#tablename_"  + mec_id);
				$vtableName.find("option").each(function(){
					var vt = $(this).text();
					var vv = $(this).attr("value");
					if(vt.toLowerCase().indexOf(searchValue.toLowerCase()) != -1){
						resultHtml += "<li><a href=\"javascript:MADF_SetSourceSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADF_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADF_SetSourceSelected(mec_id, v){
	var $source = $("#tablename_" + mec_id);
	$source.val(v);
	MADF_TableChangeBefore(mec_id);
	
	preSearchText = "";
	var $searchText = $("#sourceSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADF_InitSourceSearch(mec_id)
}

function MADF_RemoveTablesFromComInfo(mec_id){
	var $vdatasource = $("#datasource_" + mec_id);
	var $vtableName = $("#tablename_" + mec_id);
	var $vtableName_loading = $(".MADF_loading");
	var vdatasourceV = $vdatasource.val();

	$vdatasource.attr("disabled",true);
	$vtableName.attr("disabled",true);
	$vtableName_loading.show();
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=removeTablesFromComInfo&datasource="+vdatasourceV);
	FormmodeUtil.doAjaxDataLoad(url, function(result){
		var message = result.message;
		var status = result.status;
		if(status == "1"){
			var mecHandler = MECHandlerPool.getHandler(mec_id);
			var tablename;
			if(mecHandler){
				tablename = mecHandler.mecJson["tablename"];
			}
			MADF_DataSourceChange(mec_id, tablename);
		}else{
			$vdatasource.removeAttr("disabled");
			$vtableName.removeAttr("disabled")
			$vtableName_loading.hide();
			alert(message);
		}
	});
}

function MADF_openModelChoose(mec_id){
	var url = "/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 550;//定义长度
	dlg.Height = 650;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3418);  //请选择
	dlg.show();
	dlg.callback = function(result){
		
		var id = result.id;
		var name = result.name;
		$("#modelid_" + mec_id).val(id);
		$("#modelname_" + mec_id).val(name);
		dlg.close();
	};
}

function MADF_openWorkflowChoose(mec_id){
	var url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 550;//定义长度
	dlg.Height = 650;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3418);  //请选择
	dlg.show();
	dlg.callback = function(result){
		var id = result.id;
		var name = result.name;
		$("#workflowid_" + mec_id).val(id);
		$("#workflowname_" + mec_id).val(name);
		dlg.close();
	};
}

function Mec_GetTableModelOptionHtml(formid, modeldomid, defval, hasEmptyOption){
	var mecHandler = MECHandlerPool.getHandler(formid);
	if(!mecHandler){
		return;
	}
	var datasource = mecHandler.mecJson["datasource"];
	var tablename = mecHandler.mecJson["tablename"];
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getModelByTable&dsName="+datasource+"&tbName="+tablename);
	var timestamp = (new Date()).valueOf();	//时间戳，防止缓存
	url += (url.indexOf("?") == -1 ? "?" : "&") + timestamp;
	$.ajax({
	 	type: "GET",
	 	contentType: "application/json",
	 	url: encodeURI(url),
	 	data: "{}",
	 	cache:false,
	 	success: function(responseText, textStatus) 
	 	{
	 		var result = $.parseJSON(responseText);
	 		var status = result.status;
			if(status == "1"){
				var optionHtml = "";
				if(hasEmptyOption){
					optionHtml+= "<option value=\"\"></option>";
				}
				var data = result.data;
				for(var i = 0; i < data.length; i++){
					var modelname = MLanguage.parse(data[i]["modelname"]);
					if(modelname.length > 20) modelname = modelname.substring(0, 20) + "...";
					var modelid = data[i]["modelid"];
					optionHtml+= "<option value=\""+modelid+"\"";
					if(modelid == defval){
						optionHtml+= " selected = \"selected\" ";
					}
					optionHtml+= ">"+modelname+"</option>";
				}
				var $fieldObj = $("#"+modeldomid);
				$fieldObj.empty().append(optionHtml);
			}
	 	},
	    error: function(){
	    }
	});
}

var MADF_ScriptTip = "";
if(_userLanguage=="8"){
	MADF_ScriptTip = "/*\n\t form submitted before the call to this script, if the script returns to false, it will prevent the form submission, no return value or return true, the form will be submitted to the normal. \n\t script methed $f can be used directly, such as $f(\"title\").val();\n*/";
}else if(_userLanguage=="9"){
	MADF_ScriptTip = "/*\n\t表單提交前會調用此腳本，如果腳本中返回false，則會阻止表單提交，無返回值或者返回true，表單将正常提交。\n\t編寫腳本時可以直接使用$f方法获取字段，如$f(\"title\").val();\n*/" ;
}else{
	MADF_ScriptTip = "/*\n\t表单提交前会调用此脚本，如果脚本中返回false，则会阻止表单提交，无返回值或者返回true，表单将正常提交。\n\t编写脚本时可以直接使用$f方法获取字段，如$f(\"title\").val();\n*/";
}

function MADF_writeValidateScript(mec_id){
	var $field = $("#validateScript_" + mec_id);
	var fieldV = $.trim($field.val());
	if(fieldV == ""){
		fieldV = MADF_ScriptTip;
		$field.val(fieldV);
	}
	SL_AddScriptToField($field, function(scriptCode){
		MADF_ChangeScriptTip(mec_id, scriptCode);
	});
}

function MADF_ChangeScriptTip(mec_id, scriptCode){
	var $scriptTip = $("#scriptTip_" + mec_id);
	scriptCode = $.trim(scriptCode);
	if(scriptCode == "" || scriptCode == MADF_ScriptTip){
		$scriptTip.html(SystemEnv.getHtmlNoteName(4507));  //点击输入提交前验证脚本
	}else{
		$scriptTip.html(SystemEnv.getHtmlNoteName(4510));  //已设置
	}
}

function MADF_ChangeType(cbObj, mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	if(mecHandler == null) return;
	setTimeout(function(){
		var objV = cbObj.value;
		var formURL = $("#formURL_"+mec_id);
		var downtempletimg = $("#downtempletimg_"+mec_id);
		var oldUrl = "";
		//记录上次输入的自定义URL的值
		if(typeof(formURL.attr("oldVal"))=="string"&&formURL.attr("oldVal")=="3"){
			oldUrl = $("#formsuburl_" + mec_id).val(); 
			formURL.attr("oldUrl",oldUrl);
		}else{
			if(formURL.attr("oldVal")){
				if(formURL.attr("oldUrl")){
					oldUrl = formURL.attr("oldUrl");
				}
			}else{
				if(mecHandler.mecJson["formsuburl"]&&objV == "3"){
					oldUrl = mecHandler.mecJson["formsuburl"];
				}
			}
		}
		if(objV == "1"){
			formURL.hide();
			downtempletimg.hide();
			$("#relateMode_" + mec_id).show();
			$("#relateWorkFlow_" + mec_id).hide();
			$("#workflowTitleContainer_" + mec_id).hide();
			$("#formsuburl_" + mec_id).val("/mobilemode/formComponentAction.jsp");
			$("#keyname_" + mec_id).parent().show();
			mecHandler.mecJson["formtype"] = "1";
			if(mecHandler.mecJson["keyname"] == ""){//兼容老数据
				mecHandler.mecJson["keyname"] = "id";
			}
			MADF_TableChangeBefore(mec_id);
		}else if(objV == "2"){
			formURL.hide();
			downtempletimg.hide();
			$("#relateMode_" + mec_id).hide();
			$("#relateWorkFlow_" + mec_id).show();
			$("#workflowTitleContainer_" + mec_id).show();
			$("#formsuburl_" + mec_id).val("/mobilemode/formWorkflowAction.jsp");
			$("#keyname_" + mec_id).parent().hide();
			mecHandler.mecJson["formtype"] = "2";
			MADF_TableChangeBefore(mec_id);
		}else if(objV == "3"){
			formURL.show();
			downtempletimg.show();
			$("#relateMode_" + mec_id).hide();
			$("#relateWorkFlow_" + mec_id).hide();
			$("#workflowTitleContainer_" + mec_id).hide();
			$("#formsuburl_" + mec_id).val(oldUrl);
			$("#keyname_" + mec_id).parent().hide();
			mecHandler.mecJson["formtype"] = "3";
		}
		formURL.attr("oldVal",objV);
		if(!cbObj.checked){
			changeCheckboxStatus(cbObj, true);
		}else{
			$("input[type='checkbox'][name='formtype_" + mec_id + "']").each(function(){
				if(this.value != objV){
					changeCheckboxStatus(this, false);
				}
			});
		}
	}, 100);
}




