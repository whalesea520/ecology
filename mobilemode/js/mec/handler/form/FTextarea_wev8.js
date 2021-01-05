if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FTextarea = function(type, id, mecJson){
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
MEC_NS.FTextarea.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FTextarea.prototype.getDesignHtml = function(){
	var theId = this.id;
	var fieldlabel=Mec_FiexdUndefinedVal(this.mecJson["fieldlabel"]);
	var fieldremind=Mec_FiexdUndefinedVal(this.mecJson["fieldremind"]);
	var readonly =  Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");// 只读
	var contentType = (readonly == "1") ? "view" : "edit";
	var height = Mec_FiexdUndefinedVal(this.mecJson["height"], "80");
	var htmTemplate = getPluginContentTemplateById(this.type, contentType);
	htmTemplate = htmTemplate.replace("${fieldlabel}", fieldlabel).replace("${fieldremind}", fieldremind).replace("${value}", "").replace(/\${value}/g, "").replace("${heightStyle}", height+"px");
	return htmTemplate;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FTextarea.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	
	var htm = "<div id=\"MADFT_"+theId+"\" style=\"padding-bottom: 10px;\">";
	htm+="<div class=\"MADFT_Title\">"+SystemEnv.getHtmlNoteName(4538)+"</div>";  //多行文本
    htm+="<div class=\"MADFT_BaseInfo\">";
    htm+="<div>";
    htm+="<span class=\"MADFT_BaseInfo_Label MADFT_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>";  //所属表单：
    htm+="<select class=\"MADFT_Select\" id=\"formid_"+theId+"\" onchange=\"MADFT_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>";
    htm+="</div>";
    htm+="<div>";
    htm+="<span class=\"MADFT_BaseInfo_Label MADFT_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>";  //对应字段：
    htm+="<select class=\"MADFT_Select\" id=\"fieldname_"+theId+"\"></select>";
    htm+="<span style=\"margin-left: 10px; position: relative;display: inline-block;\">";
    htm+="<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFT_fieldSearch\" type=\"text\"/>";
    htm+="<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFT_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>";  //在来源中检索...
    htm+="</span>";
    htm+="</div>";
    htm+="<div>";
    htm+="<span class=\"MADFT_BaseInfo_Label MADFT_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>";  //显示名称：
    htm+="<input class=\"MADFT_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\"  data-multi=false/>";
    htm+="</div>";
    htm+="<div>";
    htm+="<span class=\"MADFT_BaseInfo_Label MADFT_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4515)+"</span>";  //提示信息：
    htm+="<input class=\"MADFT_Text\" id=\"fieldremind_"+theId+"\" type=\"text\"  data-multi=false/>";
    htm+="</div>";
    htm+="<div>";
    htm+="<span class=\"MADFT_BaseInfo_Label MADFT_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4128)+"</span>";  //高度：
    htm+="<input class=\"MADFT_Text\" id=\"height_"+theId+"\" type=\"text\" />";
    htm+="</div>";
	htm+="<div>";
	htm+="<span class=\"MADFT_BaseInfo_Label MADFT_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>";  //显示类型：
	htm+="<select class=\"MADFT_Select\" id=\"showType_"+theId+"\">";
	htm+="<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>";  //可编辑
	htm+="<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>";  //只读
	htm+="<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>";  //必填
	htm+="</select>";
	htm+="</div>";
    htm+="<div>";
    htm+="<span class=\"MADFT_BaseInfo_Label MADFT_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4535)+"</span>";  //默认值：
    htm+="<span class=\"ftextarea_btn_edit\" onclick=\"MADFT_editOneInParamOnPage('"+theId+"')\"></span>";
    htm+="<span class=\"ftextarea_param_paramValue\" id=\"paramValue_"+theId+"\"></span>";
    htm+"</div>";
    htm+="</div>";
    htm+="<div class=\"MADFT_Bottom\">";
    htm+="<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFT_FieldSearchResult MADFT_FieldSearchResult"+styleL+"\"><ul></ul></div>";
    htm+="<div class=\"MADFT_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>";  //确定
    htm+="</div>";
    htm+="</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FTextarea.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var formid = this.mecJson["formid"];
	var fieldname = this.mecJson["fieldname"];
	var fieldlabel = this.mecJson["fieldlabel"];
	var fieldremind = this.mecJson["fieldremind"];
	var readonly = Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");
	var required = Mec_FiexdUndefinedVal(this.mecJson["required"], "0");// 是否必填
	var defaultvalue = this.mecJson["defaultvalue"];
	$("#formid_"+theId).val(formid);
	MADFT_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	$("#fieldremind_"+theId).val(fieldremind);
	if(required == "1"){
		$("#showType_"+theId).val("3");
	}else if(readonly == "1"){
		$("#showType_"+theId).val("2");
	}else{
		$("#showType_"+theId).val("1");
	}
	$("#defaultvalue_"+theId).val(defaultvalue);
	
	var inParams = this.mecJson["inParams"];
	for(var i = 0; inParams && i < inParams.length; i++){
		var $container = $("#MADFT_" + theId);
		$(".ftextarea_param_paramValue", $container).text(inParams[i]["paramValue"]);
		break;
	}
	MADFT_InitFieldSearch(theId);
	var height = Mec_FiexdUndefinedVal(this.mecJson["height"], "80");
	$("#height_"+theId).val(height);
	$("#MADFT_"+theId).jNice();
	MLanguage({
		container: $("#MADFT_"+theId + " .MADFT_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.FTextarea.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer=$("#MADFT_"+theId);
	if($attrContainer.length>0){
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		var fieldremind=Mec_FiexdUndefinedVal($("#fieldremind_"+theId).val());
		var defaultvalue=Mec_FiexdUndefinedVal($("#defaultvalue_"+theId).val());
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] = MLanguage.getValue($("#fieldlabel_"+theId))||fieldlabel;
		this.mecJson["fieldremind"] =  MLanguage.getValue($("#fieldremind_"+theId))||fieldremind;
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
		this.mecJson["height"] = Mec_FiexdUndefinedVal($("#height_"+theId).val());
	}
	return this.mecJson;
};

MEC_NS.FTextarea.prototype.getDefaultMecJson = function(){
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
	defMecJson["fieldremind"] = SystemEnv.getHtmlNoteName(4170);  //请输入...
	
	return defMecJson;
};

function MADFT_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFT_editOneInParamOnPage(mec_id){
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
		
		var $container = $("#MADFT_" + mec_id);
		$(".ftextarea_param_paramValue", $container).text(result["paramValue"]);
	};

}

function MADFT_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFT_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFT_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFT_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFT_InitFieldSearch(mec_id)
}