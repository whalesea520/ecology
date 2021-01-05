if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FScores = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = this.getDefaultMecJson();
	}
	this.mecJson = mecJson;
};

/*获取id。 必需的方法*/
MEC_NS.FScores.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FScores.prototype.getDesignHtml = function(){
	var theId = this.id;
	var fieldlabel=Mec_FiexdUndefinedVal(this.mecJson["fieldlabel"]);
	var readonly =  Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");// 只读
	var contentType = (readonly == "1") ? "view" : "edit";
	var htmTemplate = getPluginContentTemplateById(this.type, contentType);
	
	var size =  Mec_FiexdUndefinedVal(this.mecJson["size"], 5);
	var forStart;
	while((forStart = htmTemplate.indexOf("$mec_forstart$")) != -1){
		var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
		var forTemplate = "";
		var forContentTemplate = "";
		if(forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
			forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
			
			var forHtml = "";
			for(var i = 0; i < size; i++){
				var activeClass = "";
				forHtml += forContentTemplate.replace("${activeClass}", activeClass);
			}
			htmTemplate = htmTemplate.replace(forTemplate, forHtml);
		}else{
			break;
		}
	}
	htmTemplate = htmTemplate.replace("${fieldlabel}", fieldlabel).replace(/\${value}/g, "").replace(/\${theId}/g, theId)
					.replace("${label}", "").replace("${scoreClass}", "");
	
	var icon =  Mec_FiexdUndefinedVal(this.mecJson["icon"]);
	var icon2 =  Mec_FiexdUndefinedVal(this.mecJson["icon2"]);
	var cssStyle = "<style type=\"text/css\">" +
						"#div"+theId+" .score-rating > b:before{background-image: url("+icon2+");}" +
						"#div"+theId+" .score-rating > b:after{background-image: url("+icon+");}" +
				   "</style>";
	htmTemplate = cssStyle + htmTemplate;
	return htmTemplate;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FScores.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	
	var htm = "<div id=\"MADFScores_"+theId+"\" style=\"padding-bottom: 10px;\">";
	htm+="<div class=\"MADFScores_Title\">"+SystemEnv.getHtmlNoteName(4650)+"</div>"  //多行文本
    + "<div class=\"MADFScores_BaseInfo\">"
	    + "<div>"
		    + "<span class=\"MADFScores_BaseInfo_Label MADFScores_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
		    + "<select class=\"MADFScores_Select\" id=\"formid_"+theId+"\" onchange=\"MADFScores_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
	    + "</div>"
	    + "<div>"
		    + "<span class=\"MADFScores_BaseInfo_Label MADFScores_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
		    + "<select class=\"MADFScores_Select\" id=\"fieldname_"+theId+"\"></select>"
		    + "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
		    + "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFScores_fieldSearch\" type=\"text\"/>"
		    + "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFScores_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
		    + "</span>"
	    + "</div>"
	    + "<div>"
		    + "<span class=\"MADFScores_BaseInfo_Label MADFScores_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
		    + "<input class=\"MADFScores_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\" data-multi=false/>"
	    + "</div>"
	    + "<div>"
		    + "<span class=\"MADFScores_BaseInfo_Label MADFScores_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4814)+"：</span>"  //评分个数：
		    + "<input class=\"MADFScores_Text\" id=\"size_"+theId+"\" type=\"text\" />"
	    + "</div>"
	    + "<div style=\"display: table;border-collapse: collapse;width: 100%;\">"
		    + "<span style=\"display: table-cell;vertical-align: middle;\" class=\"MADFScores_BaseInfo_Label MADFScores_BaseInfo_Label"+styleL+" MADFScores_IconLabel"+styleL+"\">"+SystemEnv.getHtmlNoteName(4815)+"：</span>"  //评分图标：
		    + "<div style=\"display: table-cell;padding-left: 6px;\">"
			    + "<div class=\"previewDiv\" id=\"previewDiv_"+theId+"\" onclick=\"MADFScores_PicSet('','"+theId+"');\">"
			    	+ "<div class=\"picDelete\" onclick=\"MADFScores_SetPicPath('','"+theId+"','');\"></div>"
			    	+ "<img class=\"previewImg\"/>"
			    	+ "<input type=\"hidden\" />"
			    + "</div>"
			    + "<div style=\"width: 10px;height: 34px;float: left;margin-right:7px;margin-bottom: 0px;\">"
		    		+ "<div style=\"height:1px;background: rgb(180,180,180);margin-top: 16px;\"></div>"
		    	+ "</div>"
		    	+ "<div class=\"previewDiv\" id=\"previewDiv2_"+theId+"\" onclick=\"MADFScores_PicSet('2','"+theId+"');\">"
			    	+ "<div class=\"picDelete\" onclick=\"MADFScores_SetPicPath('2','"+theId+"','');\"></div>"
			    	+ "<img class=\"previewImg\"/>"
			    	+ "<input type=\"hidden\" />"
			    + "</div>"
			    + "<div style=\"float: left;margin-bottom: 0px;margin-top: 14px;margin-left: 10px;display:none;\"><a href=\"javascript:void(0);\" onclick=\"MADFScores_addOtherIcon('"+theId+"');\" style=\"color: #333;\">快速填充笑脸图标</a></div>"
		    + "</div>"
	    + "</div>"
	    + "<div>"
		    + "<span class=\"MADFScores_BaseInfo_Label MADFScores_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4816)+"：</span>"  //评分名称：
		    + "<input class=\"MADFScores_Text\" id=\"text_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4817)+"\" data-multi=false/>"
	    + "</div>"
		+ "<div>"
			+ "<span class=\"MADFScores_BaseInfo_Label MADFScores_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>"  //显示类型：
			+ "<select class=\"MADFScores_Select\" id=\"showType_"+theId+"\">"
				+ "<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>"  //可编辑
				+ "<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>"  //只读
				+ "<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>"  //必填
			+ "</select>"
		+ "</div>"
	    + "<div>"
		    + "<span class=\"MADFScores_BaseInfo_Label MADFScores_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4535)+"</span>"  //默认值：
		    + "<span class=\"fscores_btn_edit\" onclick=\"MADFScores_editOneInParamOnPage('"+theId+"')\"></span>"
		    + "<span class=\"fscores_param_paramValue\" id=\"paramValue_"+theId+"\"></span>"
	    + "</div>"
    + "</div>"
    + "<div class=\"MADFScores_Bottom\">"
    	+ "<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFScores_FieldSearchResult MADFScores_FieldSearchResult"+styleL+"\"><ul></ul></div>"
    	+ "<div class=\"MADFScores_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>"  //确定
    + "</div>";
    htm+="</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FScores.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var formid = this.mecJson["formid"];
	var fieldname = this.mecJson["fieldname"];
	var fieldlabel = this.mecJson["fieldlabel"];
	
	$("#size_"+theId).val(this.mecJson["size"]);
	MADFScores_SetPicPath("", theId, this.mecJson["icon"]);
	MADFScores_SetPicPath("2", theId, this.mecJson["icon2"]);
	$("#text_"+theId).val(this.mecJson["text"]);
	
	var readonly = Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");
	var required = Mec_FiexdUndefinedVal(this.mecJson["required"], "0");// 是否必填
	var defaultvalue = this.mecJson["defaultvalue"];
	$("#formid_"+theId).val(formid);
	MADFScores_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
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
		var $container = $("#MADFScores_" + theId);
		$(".fscores_param_paramValue", $container).text(inParams[i]["paramValue"]);
		break;
	}
	MADFScores_InitFieldSearch(theId);
	$("#MADFScores_"+theId).jNice();
	MLanguage({
		container: $("#MADFScores_"+theId + " .MADFScores_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.FScores.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer=$("#MADFScores_"+theId);
	if($attrContainer.length>0){
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		var defaultvalue=Mec_FiexdUndefinedVal($("#defaultvalue_"+theId).val());
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] =  MLanguage.getValue($("#fieldlabel_"+theId))|| fieldlabel;
		
		this.mecJson["size"] = $("#size_"+theId).val();
		this.mecJson["icon"] = $("#previewDiv_"+theId + " input").val();
		this.mecJson["icon2"] = $("#previewDiv2_"+theId + " input").val();
		this.mecJson["text"] =  MLanguage.getValue($("#text_"+theId))|| $("#text_"+theId).val();
		
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
		var paramValue = $(".fscores_param_paramValue", $attrContainer).text();
		for(var i = 0; i < inParams.length; i++){
			inParams[i]["paramValue"] = paramValue;
			break;
		}
	}
	return this.mecJson;
};

MEC_NS.FScores.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["size"] = 5;
	defMecJson["icon"] = "/mobilemode/images/favor_fill.png";
	defMecJson["icon2"] = "/mobilemode/images/favor.png";
	defMecJson["text"] = "非常差,差,一般,好,非常好";
	
	var inParams = [
						{
							paramValue : ""
						}
					];
	defMecJson["inParams"] = inParams;
	
	return defMecJson;
};

function MADFScores_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFScores_editOneInParamOnPage(mec_id){
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
		
		var $container = $("#MADFScores_" + mec_id);
		$(".fscores_param_paramValue", $container).text(result["paramValue"]);
	};

}

function MADFScores_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFScores_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFScores_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFScores_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFScores_InitFieldSearch(mec_id);
}

function MADFScores_PicSet(prefix, mec_id){
	var pic_path = $("#previewDiv"+prefix+"_"+mec_id + " input").val();
	var url = "/mobilemode/picset.jsp?pic_path="+pic_path;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4117);  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		MADFScores_SetPicPath(prefix, mec_id, picPath);
	};
}

function MADFScores_SetPicPath(prefix, mec_id, picPath){
	var $previewDiv = $("#previewDiv"+prefix+"_"+mec_id);
	$("input", $previewDiv).val(picPath);
	$(".previewImg", $previewDiv).attr("src", picPath);
	if(picPath == ""){
		$previewDiv.removeClass("hasValue");
	}else{
		$previewDiv.addClass("hasValue");
	}
	
	var e = event || window.event;
	if (e){
		if(e.stopPropagation){
			e.stopPropagation();  
		}else{
			e.cancelBubble=true;
		}
    }
}

function MADFScores_addOtherIcon(mec_id){
	MADFScores_SetPicPath("", mec_id, "/mobilemode/images/emoji_fill.png");
	MADFScores_SetPicPath("2", mec_id, "/mobilemode/images/emoji.png");
}