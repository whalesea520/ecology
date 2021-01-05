if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FLbs = function(type, id, mecJson){
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
MEC_NS.FLbs.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FLbs.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	fieldlabel = Mec_FiexdUndefinedVal(fieldlabel);
	var html = "";
	html += "<div class=\"Design_FLbs_Container\">";
	html += "<div class=\"Design_FLbs_Fieldlabel\">" + fieldlabel + "</div>";
	html += "<div class=\"Design_FLbs_Fielddom\">"+SystemEnv.getHtmlNoteName(4562)+"</div>";  //LBS字段
	html += "</div>";
	
	return html;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FLbs.prototype.getAttrDlgHtml = function(){
	
	var styleL = "_style" + _userLanguage;

	var theId = this.id;
	
	var htm = "<div id=\"MADFLbs_"+theId+"\" class=\"MADFLbs_Container\">"
							+"<div class=\"MADFLbs_Title\">LBS</div>"
							+"<div class=\"MADFLbs_BaseInfo\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
							    +"<select class=\"MADFLbs_Select\" id=\"formid_"+theId+"\" onchange=\"MADFLbs_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
							+"</div>"
							+"<div class=\"MADFLbs_BaseInfo\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
								+"<select class=\"MADFLbs_Select\" id=\"fieldname_"+theId+"\"></select>"
								+ "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
									+ "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFLbs_fieldSearch\" type=\"text\"/>"
									+ "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFLbs_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
								+ "</span>"
							+"</div>"
							+"<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFLbs_FieldSearchResult MADFLbs_FieldSearchResult"+styleL+"\"><ul></ul></div>"
							+"<div class=\"MADFLbs_BaseInfo\" style=\"display:none;\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
								+"<input class=\"MADFLbs_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\" />"
							+"</div>"
							
							+"<div class=\"MADFLbs_BaseInfo\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4563)+"</span>"  //数据保存：
								+"<select class=\"MADFLbs_Select\" id=\"savetype_"+theId+"\" onchange=\"MADFLbs_SavetypeChange('"+theId+"')\" style=\"width: 262px;\">"
									+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4564)+"</option>"  //只保存经纬度
									+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4565)+"</option>"  //只保存地址中文名称
									+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4566)+"</option>"  //既保存经纬度，同时保存地址中文名称
								+"</select>"
							+"</div>"
							+"<div class=\"MADFLbs_BaseInfo\" id=\"MADFLbs_Address_"+theId+"\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4567)+"</span>"  //中文名字段：
								+"<select class=\"MADFLbs_Select\" id=\"addressFieldname_"+theId+"\"></select>"
								+ "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
									+ "<INPUT id=\"addressFieldSearch_"+theId+"\" class=\"MADFLbs_fieldSearch\" type=\"text\"/>"
									+ "<div id=\"addressFieldSearchTip_"+theId+"\" class=\"MADFLbs_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
								+ "</span>"
							+"</div>"
							+"<div id=\"addressFieldSearchResult_"+theId+"\" class=\"MADFLbs_AddressFieldSearchResult MADFLbs_AddressFieldSearchResult"+styleL+"\"><ul></ul></div>"
							
							+"<div class=\"MADFLbs_BaseInfo\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4568)+"</span>"  //定位类型：
								+"<select class=\"MADFLbs_Select\" id=\"postype_"+theId+"\" style=\"width: 262px;\">"
									+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4569)+"</option>"  //只显示当前位置，不显示周围热点
									+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4570)+"</option>"  //显示当前位置和周围热点
									+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4571)+"</option>"  //显示当前位置和周围热点，并允许改变位置
								+"</select>"
							+"</div>"
							+"<div class=\"MADFLbs_BaseInfo\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4318)+"</span>"  //按钮名称：
								+"<input class=\"MADFLbs_Text\" id=\"btntext_"+theId+"\" type=\"text\"  data-multi=false/>"
							+"</div>"
							+"<div class=\"MADFLbs_BaseInfo\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4572)+"</span>"  //搜索半径：
								+"<input class=\"MADFLbs_Text\" id=\"poiradius_"+theId+"\" type=\"text\" style=\"width: 85px;\"/>"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4573)+"</span>"  //热点个数：
								+"<input class=\"MADFLbs_Text\" id=\"numpois_"+theId+"\" type=\"text\" style=\"width: 85px;\"/>"
							+"</div>"
							+"<div class=\"MADFLbs_BaseInfo\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4319)+"</span>"  //回调脚本：
								/*+"<textarea class=\"MADFLbs_Text\" id=\"backscript_"+theId+"\" style=\"height: 80px;padding: 2px 4px;\"></textarea>"*/
								+"<div class=\"MADFLbs_BaseInfo_Script\" id=\"scriptdiv_"+theId+"\">"
									+"<input id=\"backscript_"+theId+"\" type=\"hidden\" value=\"\"/>"+SystemEnv.getHtmlNoteName(4574)  //单击
								+"</div>"
							+"</div>"
							+"<div class=\"MADFLbs_BaseInfo\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>"  //显示类型：
								+"<select class=\"MADFLbs_Select\" id=\"showType_"+theId+"\">"
									+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>"  //可编辑
									+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>"  //只读
									+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>"  //必填
								+"</select>"
							+"</div>"
							+"<div class=\"MADFLbs_BaseInfo\">"
								+"<span class=\"MADFLbs_BaseInfo_Label MADFLbs_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4575)+"</span>"  //当前位置：
								+"<input type=\"checkbox\" id=\"isShowCurrLocation_"+theId+"\" onclick=\"MADFLbs_ShowContent(this, '"+theId+"');\"/>"
							+"</div>"
							+"<div class=\"MADFLbs_BaseInfo\" id=\"contentWrap_"+theId+"\" style=\"display:none;\">"
								+"<div style=\"padding: 5px;line-height: 18px;border: 1px dotted #ccc;margin: 10px 15px 10px 10px;border-radius:3px;\"><div>"+SystemEnv.getHtmlNoteName(4576)+"</div></div>"  //如勾选该选项，则默认显示当前位置
							+"</div>"
							+"<div class=\"MADFLbs_Bottom\"><div class=\"MADFLbs_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
					 +"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FLbs.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var formid = this.mecJson["formid"];// Form mec_id
	var fieldname = this.mecJson["fieldname"];// 对应字段
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var savetype = Mec_FiexdUndefinedVal(this.mecJson["savetype"], "1");// 数据保存
	var addressFieldname = this.mecJson["addressFieldname"];// 地址中文名称字段
	var postype = this.mecJson["postype"];// 定位类型
	var btntext = this.mecJson["btntext"];// 按钮名称
	var poiradius = this.mecJson["poiradius"];// poi半径
	var numpois = this.mecJson["numpois"];// poi数量
	var backscript = this.mecJson["backscript"];// 回调脚本
	if(backscript && backscript != ""){
		backscript = decodeURIComponent(backscript);
	}
	var required = Mec_FiexdUndefinedVal(this.mecJson["required"], "0");// 是否必填
	var readonly = Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");// 是否只读
	if(required == "1"){
		$("#showType_"+theId).val("3");
	}else if(readonly == "1"){
		$("#showType_"+theId).val("2");
	}else{
		$("#showType_"+theId).val("1");
	}
	
	$("#formid_"+theId).val(formid);
	MADFLbs_FormChange(theId,fieldname,addressFieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	$("#savetype_"+theId).val(savetype);
	$("#postype_"+theId).val(postype);
	$("#btntext_"+theId).val(btntext);
	$("#poiradius_"+theId).val(poiradius);
	$("#numpois_"+theId).val(numpois);
	$("#backscript_"+theId).val(backscript);
	
	var isShowCurrLocation = Mec_FiexdUndefinedVal(this.mecJson["isShowCurrLocation"]);
	if(isShowCurrLocation == "1"){
		$("#isShowCurrLocation_"+theId).attr("checked","checked");
		$("#contentWrap_"+theId).show();
	}
	
	MADFLbs_SavetypeChange(theId);
	
	$("#scriptdiv_"+theId).click(function(){
		SL_AddScriptToField($("#backscript_"+theId));
	});
	
	MADFLbs_InitFieldSearch(theId);
	MADFLbs_InitAddressFieldSearch(theId);
	$("#MADFLbs_"+theId).jNice();
	MLanguage({
		container: $("#MADFLbs_"+theId + " .MADFLbs_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.FLbs.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFLbs_"+theId);
	if($attrContainer.length > 0){
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		var savetype=Mec_FiexdUndefinedVal($("#savetype_"+theId).val());
		var addressFieldname=Mec_FiexdUndefinedVal($("#addressFieldname_"+theId).val());
		var postype=Mec_FiexdUndefinedVal($("#postype_"+theId).val());
		var btntext=Mec_FiexdUndefinedVal($("#btntext_"+theId).val());
		var poiradius=Mec_FiexdUndefinedVal($("#poiradius_"+theId).val());
		var numpois=Mec_FiexdUndefinedVal($("#numpois_"+theId).val());
		var backscript=Mec_FiexdUndefinedVal($("#backscript_"+theId).val());
		backscript = encodeURIComponent(backscript);
		var showType = $("#showType_"+theId).val();
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] = fieldlabel;
		this.mecJson["savetype"] = savetype;
		this.mecJson["addressFieldname"] = addressFieldname;
		this.mecJson["postype"] = postype;
		this.mecJson["btntext"] =  MLanguage.getValue($("#btntext_"+theId))|| btntext;
		this.mecJson["poiradius"] = poiradius;
		this.mecJson["numpois"] = numpois;
		this.mecJson["backscript"] = backscript;
		this.mecJson["isShowCurrLocation"] = $("#isShowCurrLocation_"+theId).is(':checked') ? "1" : "0";
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

MEC_NS.FLbs.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	defMecJson["id"] = theId;
	defMecJson["savetype"] = "1";
	defMecJson["postype"] = "1";
	defMecJson["btntext"] = SystemEnv.getHtmlNoteName(3451);  //确定
	defMecJson["poiradius"] = "500";
	defMecJson["numpois"] = "12";
	
	return defMecJson;
};

function MADFLbs_FormChange(mec_id,selectedField,selectedAddressField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
	Mec_GetFieldOptionHtml(formid, "addressFieldname_"+mec_id, selectedAddressField);
}

function MADFLbs_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFLbs_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFLbs_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFLbs_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFLbs_InitFieldSearch(mec_id)
}

function MADFLbs_InitAddressFieldSearch(mec_id){
	var $addressSearchText = $("#addressFieldSearch_" + mec_id);
	var $addressSearchTextTip = $("#addressFieldSearchTip_" + mec_id);
	
	$addressSearchTextTip.click(function(e){
		$addressSearchText[0].focus();
		e.stopPropagation(); 
	});
	
	$addressSearchText.focus(function(){
		$addressSearchTextTip.hide();
	});
	
	$addressSearchText.blur(function(){
		if(this.value == ""){
			$addressSearchTextTip.show();
		}
	});
	
	$addressSearchText.click(function(e){
		e.stopPropagation(); 
	});
	
	var $addressSrarchResult = $("#addressFieldSearchResult_" + mec_id);
	function hideAddressSearchResult(){
		$addressSrarchResult.hide();	
	}
	
	function showAddressSearchResult(){
		$addressSrarchResult.show();	
	}
	
	function clearAddressSearchResult(){
		$addressSrarchResult.children("ul").find("*").remove();	
	}
	
	var preAddressSearchText = "";
	
	$addressSearchText.keyup(function(event){
		if(this.value == ""){
			preAddressSearchText = "";
			hideAddressSearchResult();
			clearAddressSearchResult();
		}else{
			if(this.value != preAddressSearchText){
				preAddressSearchText = this.value;
				var addressSearchValue = this.value;
				//clearSearchResult();
				
				var resultHtml = "";
				
				var $vfieldName = $("#addressFieldname_"  + mec_id);
				$vfieldName.find("option").each(function(){
					var vt = $(this).text();
					var vv = $(this).attr("value");
					if(vt.toLowerCase().indexOf(addressSearchValue.toLowerCase()) != -1){
						resultHtml += "<li><a href=\"javascript:MADFLbs_SetAddressFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
					}
				});
				
				if(resultHtml == ""){
					resultHtml = "<li><font class='tip'>"+SystemEnv.getHtmlNoteName(4270)+"</font></li>";  //无匹配的结果
				}
				
				$addressSrarchResult.children("ul").html(resultHtml);
				showAddressSearchResult();
			}
		}
	});
	
	$("#MADFLbs_" + mec_id).bind("click", function(){
		hideAddressSearchResult();
	});
}

function MADFLbs_SetAddressFieldSelected(mec_id, v){
	var $addressField = $("#addressFieldname_" + mec_id);
	$addressField.val(v);
	
	preAddressSearchText = "";
	var $addressSearchText = $("#addressFieldSearch_" + mec_id);
	$addressSearchText.val("");
	$addressSearchText.trigger("blur");
	MADFLbs_InitAddressFieldSearch(mec_id)
}

function MADFLbs_SavetypeChange(mec_id){
	var $Entry = $("#MADFLbs_" + mec_id);
	
	var savetype = $("#savetype_" + mec_id, $Entry).val();
	if(savetype == "1" || savetype == "2"){
		$("#MADFLbs_Address_"+mec_id, $Entry).hide();
	}else if(savetype == "3"){
		$("#MADFLbs_Address_"+mec_id, $Entry).show();
	}
}

function MADFLbs_ShowContent(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(cbObj.checked){
			$("#contentWrap_"+mec_id).show();
		}else{
			$("#contentWrap_"+mec_id).hide();
		}
	},100);
}