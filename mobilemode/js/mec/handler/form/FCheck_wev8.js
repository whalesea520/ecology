if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FCheck = function(type, id, mecJson){
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
MEC_NS.FCheck.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FCheck.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var contentTemplate = getPluginContentTemplateById(this.type);
	htm = contentTemplate.replace("${fieldlabel}", Mec_FiexdUndefinedVal(fieldlabel)).replace("${value}", "");
	
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FCheck.prototype.getAttrDlgHtml = function(){
	
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	
	var htm = "<div id=\"MADFCheck_"+theId+"\" class=\"MADFCheck_Container\">"
							+"<div class=\"MADFCheck_Title\">"+SystemEnv.getHtmlNoteName(4555)+"</div>"  //Check框
							+"<div class=\"MADFCheck_BaseInfo\">"
								+"<div>"
									+"<span class=\"MADFCheck_BaseInfo_Label MADFCheck_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
								    +"<select class=\"MADFCheck_Select\" id=\"formid_"+theId+"\" onchange=\"MADFCheck_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
								+"</div>"
								+"<div>"
									+"<span class=\"MADFCheck_BaseInfo_Label MADFCheck_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
								    +"<select class=\"MADFCheck_Select\" id=\"fieldname_"+theId+"\"></select>"
								    + "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
										+ "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFCheck_fieldSearch\" type=\"text\"/>"
										+ "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFCheck_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
									+ "</span>"
								+"</div>"
								+"<div>"
									+"<span class=\"MADFCheck_BaseInfo_Label MADFCheck_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
								    +"<input class=\"MADFCheck_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\"  data-multi=false/>"
								+"</div>"
								+"<div>"
									+"<span class=\"MADFCheck_BaseInfo_Label MADFCheck_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>"  //显示类型：
									+"<select class=\"MADFCheck_Select\" id=\"showType_"+theId+"\">"
										+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>"  //可编辑
										+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>"  //只读
									+"</select>"
								+"</div>"
								+"<div>"
									+ "<span class=\"MADFCheck_BaseInfo_Label MADFCheck_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4535)+"</span>"  //默认值：
									+ "<span class=\"fcheck_btn_edit\" onclick=\"MADFCheck_editOneInParamOnPage('"+theId+"')\"></span>"
									+ "<span class=\"fcheck_param_paramValue\" id=\"paramValue_"+theId+"\"></span>"
								+"</div>"
							+"</div>"
							+"<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFCheck_FieldSearchResult MADFCheck_FieldSearchResult"+styleL+"\"><ul></ul></div>"
							+"<div class=\"MADFCheck_Bottom\"><div class=\"MADFCheck_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
					 +"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FCheck.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var formid = this.mecJson["formid"];// Form mec_id
	var fieldname = this.mecJson["fieldname"];// 对应字段
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var defaultvalue = this.mecJson["defaultvalue"];// 默认值
	
	$("#formid_"+theId).val(formid);
	MADFCheck_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	$("#defaultvalue_"+theId).val(defaultvalue);
	var readonly = Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");
	if(readonly == "1"){
		$("#showType_"+theId).val("2");
	}else{
		$("#showType_"+theId).val("1");
	}
	
	var inParams = this.mecJson["inParams"];
	for(var i = 0; inParams && i < inParams.length; i++){
		var $container = $("#MADFCheck_" + theId);
		$(".fcheck_param_paramValue", $container).text(inParams[i]["paramValue"]);
		break;
	}
	MADFCheck_InitFieldSearch(theId);
	
	$("#MADFCheck_"+theId).jNice();
	MLanguage({
		container: $("#MADFCheck_"+theId + " .MADFCheck_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.FCheck.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFCheck_"+theId);
	if($attrContainer.length > 0){
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
			this.mecJson["readonly"] = "0";
		}else if(showType == "2"){
			this.mecJson["readonly"] = "1";
		}
		
		var inParams = this.mecJson["inParams"];
		var paramValue = $(".fcheck_param_paramValue", $attrContainer).text();
		for(var i = 0; i < inParams.length; i++){
			inParams[i]["paramValue"] = paramValue;
			break;
		}
		
	}
	return this.mecJson;
};

MEC_NS.FCheck.prototype.getDefaultMecJson = function(){
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

function MADFCheck_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}


function MADFCheck_editOneInParamOnPage(mec_id){
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
		
		var $container = $("#MADFCheck_" + mec_id);
		$(".fcheck_param_paramValue", $container).text(result["paramValue"]);
	};

}

function MADFCheck_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFCheck_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFCheck_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFCheck_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFCheck_InitFieldSearch(mec_id)
}
