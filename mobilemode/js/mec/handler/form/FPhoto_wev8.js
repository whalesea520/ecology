if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FPhoto = function(type, id, mecJson){
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
MEC_NS.FPhoto.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FPhoto.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	fieldlabel = Mec_FiexdUndefinedVal(fieldlabel);
	var html = "";
	html += "<div class=\"Design_Photo_Container\">";
	html += "<div class=\"Design_Photo_Fieldlabel\">" + fieldlabel + "</div>";
	html += "<div class=\"Design_Photo_Fielddom\">"+SystemEnv.getHtmlNoteName(4577)+"</div>";  //拍照字段
	html += "</div>";
	
	return html;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FPhoto.prototype.getAttrDlgHtml = function(){
	
var styleL = "_style" + _userLanguage;

	
var tip = "";
	if(_userLanguage=="8"){
		tip = "Quality: the smaller the value, the lower the quality, the smaller the size of the compressed image, but the picture is not clear. The setting values ranged from 0.1 to 1 </div><div> scaling: compression will be to picture the original wide high will be multiplied by a scaling ratio, the smaller the value of, image compression wide Takahashi is small, and the volume will be smaller and smaller. The value is set between 0.1 and 1.";
	}else if(_userLanguage=="9"){
		tip = "質量：值越小，質量越低，圖片壓縮後體積越小，但圖片也會越不清晰。該值設置介于0.1 至 1之間</div><div>縮放：壓縮時會以圖片的原始寬高會乘以縮放比例，值越小，壓縮後圖片的寬高越小，體積也會越小。該值設置介于0.1 至 1之間";
	}else{
		tip = "质量：值越小，质量越低，图片压缩后体积越小，但图片也会越不清晰。该值设置介于0.1 至 1之间</div><div>缩放：压缩时会以图片的原始宽高会乘以缩放比例，值越小，压缩后图片的宽高越小，体积也会越小。该值设置介于0.1 至 1之间";
	}
	var theId = this.id;
	
	var htm = "<div id=\"MADFPhoto_"+theId+"\" class=\"MADFPhoto_Container\">"
							+"<div class=\"MADFPhoto_Title\">"+SystemEnv.getHtmlNoteName(4578)+"</div>"  //拍照
							+"<div class=\"MADFPhoto_BaseInfo\">"
								+"<span class=\"MADFPhoto_BaseInfo_Label MADFPhoto_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
							    +"<select class=\"MADFPhoto_Select\" id=\"formid_"+theId+"\" onchange=\"MADFPhoto_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
							+"</div>"
							+"<div class=\"MADFPhoto_BaseInfo\">"
								+"<span class=\"MADFPhoto_BaseInfo_Label MADFPhoto_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
								+"<select class=\"MADFPhoto_Select\" id=\"fieldname_"+theId+"\"></select>"
								+ "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
									+ "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFPhoto_fieldSearch\" type=\"text\"/>"
									+ "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFPhoto_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
								+ "</span>"
							+"</div>"
							+"<div class=\"MADFPhoto_BaseInfo\">"
								+"<span class=\"MADFPhoto_BaseInfo_Label MADFPhoto_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
								+"<input class=\"MADFPhoto_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\"   data-multi=false/>"
							+"</div>"
							+"<div class=\"MADFPhoto_BaseInfo\">"
								+"<span class=\"MADFPhoto_BaseInfo_Label MADFPhoto_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4633)+"</span>"  //图片绘制：
								+"<input type=\"checkbox\" id=\"isDrawing_"+theId+"\"/>"
							+"</div>"
							+"<div class=\"MADFPhoto_BaseInfo\">"
								+"<span class=\"MADFPhoto_BaseInfo_Label MADFPhoto_BaseInfo_Label2"+styleL+"\">"+SystemEnv.getHtmlNoteName(4579)+"</span>"  //是否压缩：
								+"<input type=\"checkbox\" id=\"isCompress_"+theId+"\" onclick=\"MADFPhoto_ChangeComp(this, '"+theId+"');\"/>"
							+"</div>"
							+"<div class=\"MADFPhoto_BaseInfo\" id=\"compressWrap_"+theId+"\" style=\"display:none;\">"
								+"<span class=\"MADFPhoto_BaseInfo_Label MADFPhoto_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4580)+"</span>"  //质量-缩放：
								+"<input type=\"text\" id=\"quality_"+theId+"\" style=\"width:53px;border: 1px solid #ccc;height:22px;padding-left:3px;font-size:12px;\" placeholder=\"0.1 ~ 1\"/>"
								+"<span style=\"margin: 0px 5px;font-size:18px;\">-</span>"
								+"<input type=\"text\" id=\"zoom_"+theId+"\" style=\"width:53px;border: 1px solid #ccc;height:22px;padding-left:3px;font-size:12px;\" placeholder=\"0.1 ~ 1\"/>"
								+"<div style=\"padding: 5px;line-height: 18px;border: 1px dotted #ccc;margin-top:10px;margin-right:10px;border-radius:3px;\"><div>"+tip+"</div></div>"  //质量：值越小，质量越低，图片压缩后体积越小，但图片也会越不清晰。该值设置介于0.1 至 1之间</div><div>缩放：压缩时会以图片的原始宽高会乘以缩放比例，值越小，压缩后图片的宽高越小，体积也会越小。该值设置介于0.1 至 1之间
							+"</div>"
							+"<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFPhoto_FieldSearchResult MADFPhoto_FieldSearchResult"+styleL+"\"><ul></ul></div>"
							+"<div class=\"MADFPhoto_BaseInfo\">"
								+"<span class=\"MADFPhoto_BaseInfo_Label MADFPhoto_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4628)+"</span>"  //拍照类型：
								+"<select class=\"MADFPhoto_Select\" id=\"photoType_"+theId+"\">"
									+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4629)+"</option>"  //默认
									+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4630)+"</option>"  //只拍照
									+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4631)+"</option>"  //只选择照片
								+"</select>"
								+"<span class=\"MADFPhoto_BaseInfo_Tip\">"+SystemEnv.getHtmlNoteName(4632)+"</span>"  //(仅在emobile中生效)
							+"</div>"
							+"<div class=\"MADFPhoto_BaseInfo\">"
								+"<span class=\"MADFPhoto_BaseInfo_Label MADFPhoto_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>"  //显示类型：
								+"<select class=\"MADFPhoto_Select\" id=\"showType_"+theId+"\">"
									+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>"  //可编辑
									+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>"  //只读
									+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>"  //必填
								+"</select>"
							+"</div>"
							+"<div class=\"MADFPhoto_Bottom\"><div class=\"MADFPhoto_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
					 +"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FPhoto.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var formid = this.mecJson["formid"];// Form mec_id
	var fieldname = this.mecJson["fieldname"];// 对应字段
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var readonly = Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");
	var required = Mec_FiexdUndefinedVal(this.mecJson["required"], "0");// 是否必填
	
	var photoType = Mec_FiexdUndefinedVal(this.mecJson["photoType"], "1");// 拍照类型
	$("#photoType_"+theId).val(photoType);
	
	if(required == "1"){
		$("#showType_"+theId).val("3");
	}else if(readonly == "1"){
		$("#showType_"+theId).val("2");
	}else{
		$("#showType_"+theId).val("1");
	}
	
	$("#formid_"+theId).val(formid);
	MADFPhoto_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	
	var isDrawing = Mec_FiexdUndefinedVal(this.mecJson["isDrawing"]);
	if(isDrawing == "1"){
		$("#isDrawing_"+theId).attr("checked","checked");
	}
	
	var isCompress = Mec_FiexdUndefinedVal(this.mecJson["isCompress"], "1");
	if(isCompress == "1"){
		$("#isCompress_"+theId).attr("checked","checked");
		$("#compressWrap_"+theId).show();
	}
	
	$("#quality_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["quality"], "0.5"));
	$("#zoom_"+theId).val(Mec_FiexdUndefinedVal(this.mecJson["zoom"], "0.5"));
	
	MADFPhoto_InitFieldSearch(theId);
	$("#MADFPhoto_"+theId).jNice();
	MLanguage({
		container: $("#MADFPhoto_"+theId + " .MADFPhoto_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.FPhoto.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFPhoto_"+theId);
	if($attrContainer.length > 0){
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] =  MLanguage.getValue($("#fieldlabel_"+theId))||fieldlabel;
		this.mecJson["isDrawing"] = $("#isDrawing_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["isCompress"] = $("#isCompress_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["quality"] = $("#quality_"+theId).val();
		this.mecJson["zoom"] = $("#zoom_"+theId).val();
		this.mecJson["photoType"] = $("#photoType_"+theId).val();
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

function MADFPhoto_ChangeComp(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(cbObj.checked){
			$("#compressWrap_"+mec_id).show();
		}else{
			$("#compressWrap_"+mec_id).hide();
		}
	},100);
}

function MADFPhoto_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFPhoto_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFPhoto_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFPhoto_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFPhoto_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFPhoto_InitFieldSearch(mec_id)
}
