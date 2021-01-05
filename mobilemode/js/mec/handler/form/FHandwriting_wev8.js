if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FHandwriting = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = {};
	}
	this.mecJson = mecJson;
}

/*获取id。 必需的方法*/
MEC_NS.FHandwriting.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FHandwriting.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var readonly = this.mecJson["readonly"];
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var prompt = (readonly == 1 ? "只读" : (this.mecJson["prompt"] || ""));
	var height = this.mecJson["height"] || 150;
	fieldlabel = Mec_FiexdUndefinedVal(fieldlabel);
	var html = "";
	html += "<div class=\"Design_Handwriting_Container\">";
		html += "<div class=\"Design_Handwriting_Fieldlabel\">" + fieldlabel + "</div>";
		html += "<div class=\"Design_Handwriting_Fielddom\" style=\"height:"+height+"px;\"><div style=\"line-height:"+height+"px;\">"+prompt+"</div></div>";
	html += "</div>";
	
	return html;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FHandwriting.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "<div id=\"MADFHandwriting_"+theId+"\" class=\"MADFHandwriting_Container\">"
							+"<div class=\"MADFHandwriting_Title\">"+SystemEnv.getHtmlNoteName(4623)+"</div>"  //手写批注
							+"<div class=\"MADFHandwriting_BaseInfo\">"
								+"<span class=\"MADFHandwriting_BaseInfo_Label MADFHandwriting_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
							    +"<select class=\"MADFHandwriting_Select\" id=\"formid_"+theId+"\" onchange=\"MADFHandwriting_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
							+"</div>"
							+"<div class=\"MADFHandwriting_BaseInfo\">"
								+"<span class=\"MADFHandwriting_BaseInfo_Label MADFHandwriting_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
								+"<select class=\"MADFHandwriting_Select\" id=\"fieldname_"+theId+"\"></select>"
								+ "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
									+ "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFHandwriting_fieldSearch\" type=\"text\"/>"
									+ "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFHandwriting_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
								+ "</span>"
							+"</div>"
							+"<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFHandwriting_FieldSearchResult MADFHandwriting_FieldSearchResult"+styleL+"\"><ul></ul></div>"
							+"<div class=\"MADFHandwriting_BaseInfo\">"
								+"<span class=\"MADFHandwriting_BaseInfo_Label MADFHandwriting_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
								+"<input class=\"MADFHandwriting_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\" data-multi=false />"
							+"</div>"
							+"<div class=\"MADFHandwriting_BaseInfo\">"
								+"<span class=\"MADFHandwriting_BaseInfo_Label MADFHandwriting_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4128)+"</span>"  //高度：
								+"<input class=\"MADFHandwriting_Text\" id=\"height_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4586)+"\"/>"  //如：175，此处缺省为插件高度
							+"</div>"
							+"<div class=\"MADFHandwriting_BaseInfo\">"
								+"<span class=\"MADFHandwriting_BaseInfo_Label MADFHandwriting_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4515)+"</span>"  //提示信息：
								+"<input class=\"MADFHandwriting_Text\" id=\"prompt_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4624)+"\" data-multi=false/>"  //输入手写前提示信息
							+"</div>"
							+"<div class=\"MADFHandwriting_BaseInfo\">"
							+"<span class=\"MADFHandwriting_BaseInfo_Label MADFHandwriting_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>"  //显示类型：
							+"<select class=\"MADFHandwriting_Select\" id=\"showType_"+theId+"\">"
								+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>"  //可编辑
								+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>"  //只读
								+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>"  //必填
							+"</select>"
						+"</div>"
							+"<div class=\"MADFHandwriting_Bottom\"><div class=\"MADFHandwriting_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
					 +"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FHandwriting.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var formid = this.mecJson["formid"];// Form mec_id
	var fieldname = this.mecJson["fieldname"];// 对应字段
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var height = this.mecJson["height"] || 150;
	var prompt = this.mecJson["prompt"] || SystemEnv.getHtmlNoteName(4625);  //点击输入
	var readonly = Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");
	var required = Mec_FiexdUndefinedVal(this.mecJson["required"], "0");// 是否必填
	

	if(required == "1"){
		$("#showType_"+theId).val("3");
	}else if(readonly == "1"){
		$("#showType_"+theId).val("2");
	}else{
		$("#showType_"+theId).val("1");
	}
	
	$("#formid_"+theId).val(formid);
	MADFHandwriting_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	$("#height_"+theId).val(height);
	$("#prompt_"+theId).val(prompt);
	
	MADFHandwriting_InitFieldSearch(theId);
	$("#MADFHandwriting_"+theId).jNice();
	MLanguage({
		container: $("#MADFHandwriting_"+theId + " .MADFHandwriting_BaseInfo")
    });
	
};

/*获取JSON*/
MEC_NS.FHandwriting.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFHandwriting_"+theId);
	if($attrContainer.length > 0){
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		var height = $("#height_"+theId).val() || 200;
		var prompt = $("#prompt_"+theId).val() || SystemEnv.getHtmlNoteName(4625);  //点击输入
		
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] =  MLanguage.getValue($("#fieldlabel_"+theId))||fieldlabel;
		this.mecJson["height"] = height;
		this.mecJson["prompt"] = MLanguage.getValue($("#prompt_"+theId))||prompt;
		
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
	}
	return this.mecJson;
};

function MADFHandwriting_ChangeComp(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(cbObj.checked){
			$("#compressWrap_"+mec_id).show();
		}else{
			$("#compressWrap_"+mec_id).hide();
		}
	},100);
}

function MADFHandwriting_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFHandwriting_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFHandwriting_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFHandwriting_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFHandwriting_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFHandwriting_InitFieldSearch(mec_id)
}
