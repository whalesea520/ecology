if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FBrowser = function(type, id, mecJson){
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
MEC_NS.FBrowser.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FBrowser.prototype.getDesignHtml = function(){
	var theId = this.id;
	var fieldlabel=Mec_FiexdUndefinedVal(this.mecJson["fieldlabel"]);
	var readonly =  Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");// 只读
	var contentType = (readonly == "1") ? "view" : "edit";
	var htmTemplate = getPluginContentTemplateById(this.type, contentType);
	htmTemplate = htmTemplate.replace("${fieldlabel}", fieldlabel).replace("${value}", "").replace(/\${showname}/g, "");
	return htmTemplate;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FBrowser.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "<div id=\"MADFBro_"+theId+"\" style=\"padding-bottom: 10px;\">";
	htm+="<div class=\"MADFBro_Title\">"+SystemEnv.getHtmlNoteName(4556)+"</div>";  //浏览按钮
    htm+="<div class=\"MADFBro_BaseInfo\">";
    htm+="<div>";
    htm+="<span class=\"MADFBro_BaseInfo_Label MADFBro_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>";  //所属表单：
    htm+="<select class=\"MADFBro_Select\" id=\"formid_"+theId+"\" onchange=\"MADFBro_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>";
    htm+="</div>";
    htm+="<div>";
    htm+="<span class=\"MADFBro_BaseInfo_Label MADFBro_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>";  //对应字段：
    htm+="<select class=\"MADFBro_Select\" id=\"fieldname_"+theId+"\"></select>";
    htm+="<span style=\"margin-left: 10px; position: relative;display: inline-block;\">";
    htm+="<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFBro_fieldSearch\" type=\"text\"/>";
    htm+="<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFBro_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4557)+"</div>";  //检索字段...
    htm+="</span>";
    htm+="</div>";
    htm+="<div>";
    htm+="<span class=\"MADFBro_BaseInfo_Label MADFBro_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>";  //显示名称：
    htm+="<input class=\"MADFBro_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\"  data-multi=false/>";
    htm+="</div>";
    htm+="<div>";
    htm+="<span class=\"MADFBro_BaseInfo_Label MADFBro_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4516)+"</span>";  //字段类型：
    htm+="<select notBeauty=\"true\" class=\"MADFBro_Select\" id=\"browsertype_"+theId+"\" name=\"browsertype_"+theId+"\" onchange=\"MADFBro_OnChangeBrowserType('"+theId+"')\">";
    htm+="</select>";
    htm+="<span style=\"margin-left: 10px; position: relative;display: inline-block;\">";
    htm+="<INPUT id=\"browsertypeSearch_"+theId+"\" class=\"MADFBro_fieldSearch\" type=\"text\"/>";
    htm+="<div id=\"browsertypeSearchTip_"+theId+"\" class=\"MADFBro_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4558)+"</div>";  //检索类型...
    htm+="</span>";
    htm+="</div>";
    htm+="<div id=\"browsernameDiv_"+theId+"\" class=\"browsernameDiv browsernameDiv"+styleL+"\">";
    htm+="<input id=\"browsername_"+theId+"\" type=\"hidden\"/>";
    htm+="<input id=\"_browsername_"+theId+"\" class=\"MADFBro_Text2\" type=\"text\" readonly=\"readonly\" style=\"\"/>";
    htm+="<button type=\"button\" onclick=\"MADFBro_openBrowserChoose('"+theId+"')\" class=\"MADFBro_BrowserBtn MADFBro_BrowserBtn"+styleL+"\"></button>";
    htm+="</div>";
    
    htm+="<div>";
	htm+="<span class=\"MADFBro_BaseInfo_Label MADFBro_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>";  //显示类型：
	htm+="<select class=\"MADFBro_Select\" id=\"showType_"+theId+"\">";
	htm+="<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>";  //可编辑
	htm+="<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>";  //只读
	htm+="<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>";  //必填
	htm+="</select>";
	htm+="</div>";
    htm+="<div>";
    htm+="<span class=\"MADFBro_BaseInfo_Label MADFBro_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4535)+"</span>";  //默认值：
    htm+="<span class=\"ftextarea_btn_edit\" onclick=\"MADFBro_editOneInParamOnPage('"+theId+"')\"></span>";
    htm+="<span class=\"ftextarea_param_paramValue\" id=\"paramValue_"+theId+"\"></span>";
    htm+"</div>";
    htm+="</div>";
    htm+="<div class=\"MADFBro_Bottom\">";
    htm+="<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFBro_SearchResult MADFBro_FieldSearchResult MADFBro_FieldSearchResult"+styleL+"\"><ul></ul></div>";
    htm+="<div id=\"browsertypeSearchResult_"+theId+"\" class=\"MADFBro_SearchResult MADFBro_BrowserTypeSearchResult MADFBro_BrowserTypeSearchResult"+styleL+"\"><ul></ul></div>";
    htm+="<div class=\"MADFBro_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>";  //确定
    htm+="</div>";
    htm+="</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FBrowser.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var formid = this.mecJson["formid"];
	var fieldname = this.mecJson["fieldname"];
	var fieldlabel = this.mecJson["fieldlabel"];
	var required = Mec_FiexdUndefinedVal(this.mecJson["required"], "0");// 是否必填
	var defaultvalue = this.mecJson["defaultvalue"];
	$("#formid_"+theId).val(formid);
	MADFBro_FormChange(theId,fieldname);
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
	
	var inParams = this.mecJson["inParams"];
	for(var i = 0; inParams && i < inParams.length; i++){
		var $container = $("#MADFBro_" + theId);
		$(".ftextarea_param_paramValue", $container).text(inParams[i]["paramValue"]);
		break;
	}
	MADFBro_InitFieldSearch(theId);
	
	var browsertypeV = this.mecJson["browsertype"];
	MADFBro_fillBrowserType(theId, browsertypeV);
	MADFBro_InitBrowserTypeSearch(theId);
	
	var browsername = this.mecJson["browsername"];
	$("#browsername_"+theId).val(browsername);
	
	var _browsername = this.mecJson["_browsername"];
	if(!_browsername){
		_browsername = browsername;
	}
	$("#_browsername_"+theId).val(_browsername);
	
	$("#MADFBro_"+theId).jNice();
	MLanguage({
		container: $("#MADFBro_"+theId + " .MADFBro_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.FBrowser.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer=$("#MADFBro_"+theId);
	if($attrContainer.length>0){
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		var defaultvalue=Mec_FiexdUndefinedVal($("#defaultvalue_"+theId).val());
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] =  MLanguage.getValue($("#fieldlabel_"+theId))|| fieldlabel;
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
		
		var inParams = this.mecJson["inParams"];
		var paramValue = $(".ftextarea_param_paramValue", $attrContainer).text();
		for(var i = 0; i < inParams.length; i++){
			inParams[i]["paramValue"] = paramValue;
			break;
		}
		
		var browsertype = Mec_FiexdUndefinedVal($("#browsertype_"+theId).val());
		this.mecJson["browsertype"] = browsertype;
		
		var browsername = Mec_FiexdUndefinedVal($("#browsername_"+theId).val());
		this.mecJson["browsername"] = browsername;
		
		var _browsername = Mec_FiexdUndefinedVal($("#_browsername_"+theId).val());
		this.mecJson["_browsername"] = _browsername;
	}
	return this.mecJson;
};

MEC_NS.FBrowser.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;

	
	var inParams = [
						{
							paramValue : ""
						}
					];
	defMecJson["inParams"] = inParams;
	
	return defMecJson;
};

function MADFBro_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFBro_editOneInParamOnPage(mec_id){
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
		
		var $container = $("#MADFBro_" + mec_id);
		$(".ftextarea_param_paramValue", $container).text(result["paramValue"]);
	};

}

function MADFBro_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFBro_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFBro_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFBro_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
}

function MADFBro_InitBrowserTypeSearch(mec_id){
	var $searchText = $("#browsertypeSearch_" + mec_id);
	var $searchTextTip = $("#browsertypeSearchTip_" + mec_id);
	
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
	
	var $srarchResult = $("#browsertypeSearchResult_" + mec_id);
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
				
				var $vfieldName = $("#browsertype_"  + mec_id);
				$vfieldName.find("option").each(function(){
					var vt = $(this).text();
					var vv = $(this).attr("value");
					var match = $(this).attr("match");
					if(vt.toLowerCase().indexOf(searchValue) != -1 || (match && match.toLowerCase().indexOf(searchValue.toLowerCase()) != -1)){
						resultHtml += "<li><a href=\"javascript:MADFBro_SetBrowserTypeSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFBro_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFBro_SetBrowserTypeSelected(mec_id, v){
	var $field = $("#browsertype_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#browsertypeSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	
	MADFBro_OnChangeBrowserType(mec_id);
}

function MADFBro_fillBrowserType(mec_id, v){
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
				var $fieldObj = $("#browsertype_" + mec_id);
				$fieldObj.empty().append(optionHtml);
				if(v){
					$fieldObj.val(v);
				}
				MADFBro_OnChangeBrowserType(mec_id);
			}
	 	},
	    error: function(){
	    }
	});
}

function MADFBro_OnChangeBrowserType(mec_id){
	var browsertype = $("#browsertype_" + mec_id).val();
	if(browsertype == "161" || browsertype == "162" || browsertype == "256" || browsertype == "257"){
		$("#browsernameDiv_" + mec_id).show();
	}else{
		$("#browsernameDiv_" + mec_id).hide();
		$("#browsername_" + mec_id).val("");
		$("#_browsername_" + mec_id).val("");
	}
}

function MADFBro_openBrowserChoose(mec_id){
	var browsertype = $("#browsertype_" + mec_id).val();
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
		$("#browsername_" + mec_id).val(v);
		
		var n = result.name;
		if(n){
			var reStripTags = /<\/?.*?>/g;
			n = n.replace(reStripTags, ''); //只有文字的结果
		}else{
			n = v;
		}
		$("#_browsername_" + mec_id).val(n);
	};
}
