if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FButton = function(type, id, mecJson){
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
MEC_NS.FButton.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FButton.prototype.getDesignHtml = function(){
	var theId = this.id;
	var fbutton_datas = this.mecJson["fbutton_datas"];
	var formid = this.mecJson["formid"];
	var htm = "";
	if(fbutton_datas.length==0){
		htm = "<div class=\"noFButton\">"+SystemEnv.getHtmlNoteName(4479)+"</div>";  //未添加button
	}else{
		var htmTemplate = getPluginContentTemplateById(this.type);
		htmTemplate = htmTemplate.replace("${theId}",theId);
		var forTemplate = "";
		var forContentTemplate = "";
		var forStart = htmTemplate.indexOf("$mec_forstart$");
		var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
		if(forStart != -1 && forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
			forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
		}
		var forHtml = "";
		for(var i = 0; i < fbutton_datas.length; i++){
			var data = fbutton_datas[i];
			var id = data["id"];
			var buttonname = data["buttonname"];
			var action= data["action"];
			var buttontype = "";
			if(action =="1" || action =="4" || action == "5"){
				buttontype = "fSubmitButton";
			}else if(action == "2" || action == "6"){
				buttontype = "fResetButton";
			}else if(action == "3"){
				buttontype = "fManualButton";
			}
			var buttonHtml = forContentTemplate.replace("${buttontype}",buttontype).replace("${id}", id).replace("${formid}", formid).replace("${action}", action)
							.replace("${title}", buttonname).replace("${buttonname}", buttonname);
			forHtml += buttonHtml;
		}
		htm = htmTemplate.replace(forTemplate, forHtml);
	}
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FButton.prototype.getAttrDlgHtml = function(){
		
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	
	var htm = "<div id=\"MADFBUTTON_"+theId+"\">"
				+ "<div class=\"MADFBUTTON_Title\">"
					+ SystemEnv.getHtmlNoteName(4559)  //表单按钮
					+ "<div class=\"fbutton_root_add\" onclick=\"MADFBUTTON_AddOne('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3518)+"</div>"  //添加
				+ "</div>"
				+"<div class=\"MADFBUTTON_FORM\">"
				    +"<span class=\"MADFBUTTON_BaseInfo_Label MADFBUTTON_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
				    +"<select class=\"MADFBUTTON_Select\" id=\"formid_"+theId+"\">"+Mec_GetFormOptionHtml()+"</select>"
			    +"</div>"
			    +"<div class=\"MADFBUTTON_FORM\">"
				    +"<span class=\"MADFBUTTON_BaseInfo_Label MADFBUTTON_BaseInfo_Label"+styleL+"\">页面扩展：</span>"  //页面扩展：
				    +"<input type=\"checkbox\" id=\"isShowPageExtend_"+theId+"\" value=\"1\"/><span class=\"cbboxLabel\">显示表单建模的页面扩展按钮</span>"
			    +"</div>"
				+ "<div class=\"MADFBUTTON_Content\">"
					+ "<ul class=\"fbutton_ul_root\">"
					+ "</ul>"
					+ "<div class=\"fbutton_empty_tip\">"+SystemEnv.getHtmlNoteName(4159)+"</div>"  //单击右上角的添加按钮以添加内容
				+ "</div>"
				+ "<div class=\"MADFBUTTON_Bottom\"><div class=\"MADFBUTTON_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
			+ "</div>"
			+ "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>"  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FButton.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var $attrContainer = $("#MADFBUTTON_"+theId);
	
	var formid = this.mecJson["formid"];
	$("#formid_"+theId).val(formid);
	
	var isShowPageExtend;
	if(this.mecJson.hasOwnProperty("isShowPageExtend")){	
		isShowPageExtend = this.mecJson["isShowPageExtend"];
	}else{ //兼容老的数据，默认选中
		isShowPageExtend = "1";
	}
	if(isShowPageExtend == "1"){
		$("#isShowPageExtend_"+theId).attr("checked", "checked");
	}
	
	var fbutton_datas = this.mecJson["fbutton_datas"];
	
	if(fbutton_datas.length == 0){
		$(".fbutton_empty_tip", $attrContainer).show();
	}
	
	for(var i = 0; i < fbutton_datas.length; i++){
		var data = fbutton_datas[i];
		MADFBUTTON_AddFButtonEntryToPage(theId, data);
	}
	
	$(".MADFBUTTON_Content > ul").sortable({
		revert: false,
		axis: "y",
		items: "li",
		handle: ".bemove"
	});
	
	$attrContainer.jNice();
};

/*获取JSON*/
MEC_NS.FButton.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFBUTTON_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["formid"] = Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		this.mecJson["isShowPageExtend"] = $("#isShowPageExtend_"+theId).is(":checked") ? "1" : "0";
		
		var fbutton_datas =[];
		$("li", $attrContainer).each(function(){
			var $this = $(this);
			var fbutton_data = {};
			var fbuttonid = $this.attr("id").substring("fbuttonEntry_".length);
			fbutton_data["id"] = fbuttonid;
			fbutton_data["buttonname"] = $(".fbutton_dis_buttonname", $this).attr('data-value');
			fbutton_data["buttonreminder"] = $(".fbutton_dis_buttonreminder", $this).val();
			fbutton_data["action"] = $this.attr("action");
			fbutton_data["_action"] = $(".fbutton_dis_action", $this).html();
			
			if($this.attr("action") == "3"){
				fbutton_data["actionvalue"] = $("#fbutton_dis_callbackfunction_" + fbuttonid).val();
				fbutton_data["callbackfunction"] = "";
			}else{
				fbutton_data["actionvalue"] = "";
				fbutton_data["callbackfunction"] = $("#fbutton_dis_callbackfunction_" + fbuttonid).val();
			}
			
			fbutton_datas.push(fbutton_data);
		});
		
		this.mecJson["fbutton_datas"] = fbutton_datas;
	}
	return this.mecJson;
};

MEC_NS.FButton.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["formid"] = "";
	defMecJson["isShowPageExtend"] = "1";
	
	var fbutton_datas =[];
	fbutton_datas.push({
		"id" : new UUID().toString(),
		"buttonname" : SystemEnv.getHtmlNoteName(4336),  //提交
		"action" : "1",
		"_action" : SystemEnv.getHtmlNoteName(4336),  //提交
		"actionvalue" : "",
		"callbackfunction" : ""
	});
	fbutton_datas.push({
		"id" : new UUID().toString(),
		"buttonname" : SystemEnv.getHtmlNoteName(4049),  //重置
		"action" : "2",
		"_action" : SystemEnv.getHtmlNoteName(4049),  //重置
		"actionvalue" : "",
		"callbackfunction" : ""
	});
	defMecJson["fbutton_datas"] = fbutton_datas;
	
	return defMecJson;
};

function MADFBUTTON_AddOne(mec_id){
	var url = "/mobilemode/fbuttonEntry.jsp";
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 400;//定义长度
	dlg.Height = 272;
	dlg.normalDialog = false;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(3518);  //添加
	dlg.show();
	dlg.hookFn = function(result){
		result["id"] = new UUID().toString();
		var mecHandler = MECHandlerPool.getHandler(mec_id);
		var fbutton_datas = mecHandler.mecJson["fbutton_datas"];
		fbutton_datas.push(result);
		MADFBUTTON_AddFButtonEntryToPage(mec_id, result);
	};
}

function MADFBUTTON_AddFButtonEntryToPage(mec_id, result){
	var $attrContainer = $("#MADFBUTTON_"+mec_id);
	$(".fbutton_empty_tip", $attrContainer).hide();
	
	var id = result["id"];
	
	var buttonname = result["buttonname"];
	var buttonreminder = result["buttonreminder"] || "";
	var action = result["action"];
	var _action = result["_action"];
	var actionvalue = result["actionvalue"];
	var callbackfunction = result["callbackfunction"];
	
	if(action == "1"){
		actionvalue = "Mobile_NS.formSubmit(this)";
	}else if(action == "2"){
		actionvalue = "Mobile_NS.formReset(this)";
	}else if(action == "3"){
		callbackfunction = actionvalue;
		actionvalue = "Mobile_NS.formManual(this)";
	}else if(action == "4"){
		actionvalue = "Mobile_NS.formSubmit(this)";
	}
	
	var $fbuttonEntry = $("<li id=\"fbuttonEntry_"+id+"\" action=\""+action+"\"></li>");
	
	$fbuttonEntry.html("<div class=\"fbutton_table_wrap\">"
					+ "<table>"
						+ "<tr>"
							+ "<td class=\"bemove\" width=\"35\"></td>"
							+ "<td width=\"65\">"
								+ "<div class=\"fbutton_dis_buttonname\" data-value=\"" + buttonname + "\" >"+ (MLanguage.parse(buttonname) || buttonname)+"</div>"
								+ "<input type=\"hidden\" class=\"fbutton_dis_buttonreminder\" value=\""+buttonreminder+"\"/>"
							+ "</td>"
							+ "<td width=\"55\">"
								+ "<div class=\"fbutton_dis_action\">"+_action+"</div>"
							+ "</td>"
							+ "<td width=\"95\">"
								+ "<div class=\"fbutton_dis_actionvalue\" title=\""+actionvalue+"\">"+actionvalue+"</div>"
							+ "</td>"
							+ "<td width=\"95\">"
								+ "<div class=\"fbutton_dis_callbackfunction\" title=\""+callbackfunction+"\">"+callbackfunction+"</div>"
								+ "<input type=\"hidden\" id=\"fbutton_dis_callbackfunction_" + id + "\"/>"
							+ "</td>"
							+ "<td width=\"30\" align=\"right\">"
								+ "<span class=\"fbutton_btn_del\" onclick=\"MADFBUTTON_DeleteFButtonEntry('"+mec_id+"', '"+id+"');\"></span>"
								+ "<span class=\"fbutton_btn_edit\" onclick=\"MADFBUTTON_EditOne('"+mec_id+"', '"+id+"');\"></span>"
							+ "</td>"
						+ "</tr>"
					+ "</table>"
					+"</div>");
	
	var $ParentfbuttonEntry;
	$ParentfbuttonEntry = $(".fbutton_ul_root", $attrContainer);
	
	$ParentfbuttonEntry.append($fbuttonEntry);
	
	$("#fbutton_dis_callbackfunction_" + id)[0].value = callbackfunction;
}

function MADFBUTTON_EditOne(mec_id,fbuttonid){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var fbutton_datas = mecHandler.mecJson["fbutton_datas"];
	var fbutton_data = null;
	for(var i = 0; i < fbutton_datas.length; i++){
		var data = fbutton_datas[i];
		if(data["id"] == fbuttonid){
			fbutton_data = data;
			break;
		}
	}
	var fbuttonEntry = JSON.stringify(fbutton_data);
	fbuttonEntry = $m_encrypt(fbuttonEntry);
	
	var url = "/mobilemode/fbuttonEntry.jsp?fbuttonEntry="+fbuttonEntry;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 400;//定义长度
	dlg.Height = 272;
	dlg.normalDialog = false;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4002);  //编辑
	dlg.show();
	dlg.hookFn = function(result){
		var buttonname = result["buttonname"];
		var buttonreminder = result["buttonreminder"];
		var action = result["action"];
		var _action = result["_action"];
		var actionvalue = result["actionvalue"];
		var callbackfunction = result["callbackfunction"];
		fbutton_data["buttonname"] = buttonname;
		fbutton_data["buttonreminder"] = buttonreminder;
		fbutton_data["action"] = action;
		fbutton_data["_action"] = _action;
		fbutton_data["actionvalue"] = actionvalue;
		fbutton_data["callbackfunction"] = callbackfunction;
		
		var $li = $("#fbuttonEntry_" + fbuttonid);
		$(".fbutton_dis_buttonname", $li).html( MLanguage.parse(buttonname) || buttonname).attr('data-value',buttonname);
		$(".fbutton_dis_buttonreminder", $li).val(buttonreminder);
		$(".fbutton_dis_action", $li).html(_action);
		$li.attr("action", action);
		if(action == "1"){
			$(".fbutton_dis_callbackfunction", $li).html(callbackfunction);
			$("#fbutton_dis_callbackfunction_" + fbuttonid)[0].value = callbackfunction;
		}else if(action == "3"){
			$(".fbutton_dis_callbackfunction", $li).html(actionvalue);
			$("#fbutton_dis_callbackfunction_" + fbuttonid)[0].value = actionvalue;
		}else if(action == "4"){
			$(".fbutton_dis_callbackfunction", $li).html(callbackfunction);
			$("#fbutton_dis_callbackfunction_" + fbuttonid)[0].value = callbackfunction;
		}
	};
}

function MADFBUTTON_DeleteFButtonData(mec_id, id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var fbutton_datas = mecHandler.mecJson["fbutton_datas"];
	var index = -1;
	for(var i = 0; i < fbutton_datas.length; i++){
		var data = fbutton_datas[i];
		if(data["id"] == id){
			index = i;
			break;
		}
	}
	if(index != -1){
		fbutton_datas.splice(index, 1);
	}
}

function MADFBUTTON_DeleteFButtonEntry(mec_id, id){
	var msg = SystemEnv.getHtmlNoteName(4175);  //确定删除吗？
	if(!confirm(msg)){
		return;
	}
	
	MADFBUTTON_DeleteFButtonData(mec_id, id);
	
	var $attrContainer = $("#MADFBUTTON_"+mec_id);
	$("#fbuttonEntry_" + id, $attrContainer).remove();
	
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	var fbutton_datas = mecHandler.mecJson["fbutton_datas"];
	if(fbutton_datas.length == 0){
		$(".fbutton_empty_tip", $attrContainer).show();
	}
}