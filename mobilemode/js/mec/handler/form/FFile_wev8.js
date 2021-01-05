if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FFile = function(type, id, mecJson){
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
MEC_NS.FFile.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FFile.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	fieldlabel = Mec_FiexdUndefinedVal(fieldlabel);
	var html = "";
	html += "<div class=\"Design_File_Container\">";
	html += "<div class=\"Design_File_Fieldlabel\">" + fieldlabel + "</div>";
	html += "<div class=\"Design_File_Fielddom\">"+SystemEnv.getHtmlNoteName(4581)+"</div>";  //附件字段
	html += "</div>";
	
	return html;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FFile.prototype.getAttrDlgHtml = function(){
	
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	
	var htm = "<div id=\"MADFFile_"+theId+"\" class=\"MADFFile_Container\">"
							+"<div class=\"MADFFile_Title\">"+SystemEnv.getHtmlNoteName(3776)+"</div>"  //附件
							+"<div class=\"MADFFile_BaseInfo\">"
								+"<span class=\"MADFFile_BaseInfo_Label MADFFile_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
							    +"<select class=\"MADFFile_Select\" id=\"formid_"+theId+"\" onchange=\"MADFFile_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
							+"</div>"
							+"<div class=\"MADFFile_BaseInfo\">"
								+"<span class=\"MADFFile_BaseInfo_Label MADFFile_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
								+"<select class=\"MADFFile_Select\" id=\"fieldname_"+theId+"\"></select>"
								+ "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
									+ "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFFile_fieldSearch\" type=\"text\"/>"
									+ "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFFile_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
								+ "</span>"
							+"</div>"
							+"<div class=\"MADFFile_BaseInfo\">"
								+"<span class=\"MADFFile_BaseInfo_Label MADFFile_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
								+"<input class=\"MADFFile_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\" data-multi=false />"
							+"</div>"
							+"<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFFile_FieldSearchResult MADFFile_FieldSearchResult"+styleL+"\"><ul></ul></div>"
							+"<div class=\"MADFFile_BaseInfo\">"
								+"<span class=\"MADFFile_BaseInfo_Label MADFFile_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>"  //显示类型：
								+"<select class=\"MADFFile_Select\" id=\"showType_"+theId+"\">"
									+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>"  //可编辑
									+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>"  //只读
									+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>"  //必填
								+"</select>"
							+"</div>"
							+"<div class=\"MADFFile_Bottom\"><div class=\"MADFFile_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"
					 +"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FFile.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var formid = this.mecJson["formid"];// Form mec_id
	var fieldname = this.mecJson["fieldname"];// 对应字段
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
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
	MADFFile_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	
	MADFFile_InitFieldSearch(theId);
	$("#MADFFile_"+theId).jNice();
	MLanguage({
		container: $("#MADFFile_"+theId + " .MADFFile_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.FFile.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFFile_"+theId);
	if($attrContainer.length > 0){
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] = MLanguage.getValue($("#fieldlabel_"+theId))||fieldlabel;
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

function MADFFile_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFFile_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFFile_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFFile_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFFile_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFFile_InitFieldSearch(mec_id)
}