if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FSound = function(type, id, mecJson){
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
MEC_NS.FSound.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FSound.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	fieldlabel = Mec_FiexdUndefinedVal(fieldlabel);
	var html = "";
	html += "<div class=\"Design_FSound_Container\">";
	html += "<div class=\"Design_FSound_Fieldlabel\">" + fieldlabel + "</div>";
	html += "<div class=\"Design_FSound_Fielddom\">"+SystemEnv.getHtmlNoteName(4560)+"</div>";  //语音字段
	html += "</div>";
	
	return html;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FSound.prototype.getAttrDlgHtml = function(){
	
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	
	var htm = "<div id=\"MADFSound_"+theId+"\" class=\"MADFSound_Container\">"
							+"<div class=\"MADFSound_Title\">"+SystemEnv.getHtmlNoteName(4561)+"</div>" //语音
							+"<div class=\"MADFSound_BaseInfo\">"
								+"<span class=\"MADFSound_BaseInfo_Label MADFSound_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>" //所属表单：
							    +"<select class=\"MADFSound_Select\" id=\"formid_"+theId+"\" onchange=\"MADFSound_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
							+"</div>"
							+"<div class=\"MADFSound_BaseInfo\">"
								+"<span class=\"MADFSound_BaseInfo_Label MADFSound_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
								+"<select class=\"MADFSound_Select\" id=\"fieldname_"+theId+"\"></select>"
								+ "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
									+ "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFSound_fieldSearch\" type=\"text\"/>"
									+ "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFSound_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
								+ "</span>"
							+"</div>"
							+"<div class=\"MADFSound_BaseInfo\" style=\"display:none;\">"
								+"<span class=\"MADFSound_BaseInfo_Label MADFSound_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
								+"<input class=\"MADFSound_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\" />"
							+"</div>"
							+"<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFSound_FieldSearchResult MADFSound_FieldSearchResult"+styleL+"\"><ul></ul></div>"
							+"<div class=\"MADFSound_Bottom\"><div class=\"MADFSound_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
					 +"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FSound.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var formid = this.mecJson["formid"];// Form mec_id
	var fieldname = this.mecJson["fieldname"];// 对应字段
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	$("#formid_"+theId).val(formid);
	MADFSound_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	
	MADFSound_InitFieldSearch(theId);
	$("#MADFSound_"+theId).jNice();
};

/*获取JSON*/
MEC_NS.FSound.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFSound_"+theId);
	if($attrContainer.length > 0){
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] = fieldlabel;
	}
	return this.mecJson;
};

function MADFSound_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFSound_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFSound_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFSound_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFSound_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFSound_InitFieldSearch(mec_id)
}