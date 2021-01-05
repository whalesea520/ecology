if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.FInputText = function(type, id, mecJson){
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
MEC_NS.FInputText.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.FInputText.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var fieldremind = this.mecJson["fieldremind"];// 提示信息
	var readonly =  Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");// 只读
	var contentType = (readonly == "1") ? "view" : "edit";
	var contentTemplate = getPluginContentTemplateById(this.type, contentType);
	htm = contentTemplate.replace("${fieldlabel}", Mec_FiexdUndefinedVal(fieldlabel)).replace("${fieldremind}", Mec_FiexdUndefinedVal(fieldremind)).replace(/\${value}/g, "").replace(/\${valueHtml}/g, "");
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.FInputText.prototype.getAttrDlgHtml = function(){
	
	var styleL = "_style" + _userLanguage;
	var theId = this.id;
	
	var htm = "<div id=\"MADFI_"+theId+"\" class=\"MADFI_Container\">"
							+"<div class=\"MADFI_Title\">"+SystemEnv.getHtmlNoteName(4511)+"</div>"  //单行文本
							+"<div class=\"MADFI_BaseInfo\">"
								+"<div>"
									+"<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4607)+"</span>"  //所属表单：
								    +"<select class=\"MADFI_Select\" id=\"formid_"+theId+"\" onchange=\"MADFI_FormChange('"+theId+"')\">"+Mec_GetFormOptionHtml()+"</select>"
								+"</div>"
								+"<div>"
									+"<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4513)+"</span>"  //对应字段：
								    +"<select class=\"MADFI_Select\" id=\"fieldname_"+theId+"\"></select>"
								    + "<span style=\"margin-left: 10px; position: relative;display: inline-block;\">"
										+ "<INPUT id=\"fieldSearch_"+theId+"\" class=\"MADFI_fieldSearch\" type=\"text\"/>"
										+ "<div id=\"fieldSearchTip_"+theId+"\" class=\"MADFI_fieldSearchTip\">"+SystemEnv.getHtmlNoteName(4590)+"</div>"  //在来源中检索...
									+ "</span>"
								+"</div>"
								+"<div>"
									+"<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4514)+"</span>"  //显示名称：
								    +"<input class=\"MADFI_Text\" id=\"fieldlabel_"+theId+"\" type=\"text\" data-multi=false/>"
								+"</div>"
								+"<div>"
									+"<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4515)+"</span>"  //提示信息：
								    +"<input class=\"MADFI_Text\" id=\"fieldremind_"+theId+"\" type=\"text\" data-multi=false />"
								+"</div>"
								+"<div>"
									+"<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4516)+"</span>"  //字段类型：
									+"<select class=\"MADFI_Select\" id=\"htmlType_"+theId+"\" onchange=\"MADFI_HtmlTypeChange('"+theId+"');\">"
										+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4517)+"</option>"  //文本
										+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(3715)+"</option>"  //日期
										+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(3706)+"</option>"  //时间
										+"<option value=\"4\">"+SystemEnv.getHtmlNoteName(4518)+"</option>"  //日期时间
										+"<option value=\"5\">"+SystemEnv.getHtmlNoteName(4519)+"</option>"  //密码
										+"<option value=\"8\">"+SystemEnv.getHtmlNoteName(4614)+"</option>"  //整数
										+"<option value=\"9\">"+SystemEnv.getHtmlNoteName(4615)+"</option>"  //浮点数
										+"<option value=\"7\">"+SystemEnv.getHtmlNoteName(4521)+"</option>"  //电话号码
									+"</select>"
									+ "<div class=\"MADFI_NumType_float\" style=\"display:none;margin-bottom:0px;\">"
										+ "<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\" style=\"\">"+SystemEnv.getHtmlNoteName(4616)+"</span>"  //小数位数：
										+ "<select class=\"MADFI_Select\" id=\"htmlFloatPrecision_"+theId+"\" style=\"width:53px;\">"
											+ "<option value=\"1\">1</option>"
											+ "<option value=\"2\">2</option>"
											+ "<option value=\"3\">3</option>"
											+ "<option value=\"4\">4</option>"
										+ "</select>"
									+ "</div>"
								+"</div>"
								+ "<div class=\"MADFI_NumContent\">"
									
								+ "</div>"
								+ "<div class=\"MADFI_NumContent\" style=\"display:none;\">"
									+ "<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4522)+"</span>"  //数字范围：
									+ "<input class=\"MADFI_Text\" style=\"width:75px;\" type=\"text\" id=\"minNumber_"+theId+"\" onchange=\"MADFI_NumberChange('"+theId+"');\" placeholder=\""+SystemEnv.getHtmlNoteName(4610)+"\"/>"  //最小值
									+ "<span>~</span>"
									+ "<input class=\"MADFI_Text\" style=\"width:75px;\" type=\"text\" id=\"maxNumber_"+theId+"\" onchange=\"MADFI_NumberChange('"+theId+"');\" placeholder=\""+SystemEnv.getHtmlNoteName(4611)+"\"/>"  //最大值
								+ "</div>"
								+ "<div class=\"MADFI_NumContent\" style=\"display:none;\">"
									+ "<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4617)+"</span>"  //辅助输入：
									+ "<input type=\"checkbox\" name=\"assistInput_"+theId+"\" value=\"1\" onclick=\"MADFI_ChangeRAT(this, '"+theId+"');\">"
									+ "<div class=\"MADFI_NumType_addstep\" style=\"display:none;margin-bottom:0px;\">"
										+ "<span class=\"MADFI_BaseInfo_Label\" style=\"width:40px;\">"+SystemEnv.getHtmlNoteName(4525)+"</span>"  //增幅：
										+ "<input class=\"MADFI_Text\" style=\"width:65px;\" type=\"text\" onchange=\"MADFI_NumberChange('"+theId+"');\" id=\"stepNumval_"+theId+"\" placeholder=\""+SystemEnv.getHtmlNoteName(4526)+"\"/>"  //增幅大小
									+ "</div>"
								+ "</div>"
								
								+ "<div class=\"MADFI_DateContent\" style=\"display:none;\">"
									+ "<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4527)+"</span>"  //年份偏移：
									+ "<input class=\"MADFI_Text\" style=\"width:100px;\" type=\"text\" id=\"yearPrevOffset_"+theId+"\" placeholder=\""+SystemEnv.getHtmlNoteName(4608)+"\"/>"  //向前偏移，100
									+ "<span>&nbsp;~&nbsp;</span>"
									+ "<input class=\"MADFI_Text\" style=\"width:90px;\" type=\"text\" id=\"yearNextOffset_"+theId+"\" placeholder=\""+SystemEnv.getHtmlNoteName(4609)+"\"/>&nbsp;&nbsp;"  //向后偏移，1
									+ "<a href=\"javascript:MADFI_ShowTip('yearOffset');\">"+SystemEnv.getHtmlNoteName(4530)+"</a>"  //设置说明
								+ "</div>"
								+"<div style=\"position: relative;\">"
									+"<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\" style=\"vertical-align: top;\">"+SystemEnv.getHtmlNoteName(4944)+"</span>"  //动态取值：
									+"<textarea class=\"area-control\" id=\"valueExpression_"+theId+"\" style=\"padding: 5px 20px 5px 5px;border: 1px solid #dfdfdf;height: 80px;width: 262px;box-sizing: border-box;\" placeholder=\""+SystemEnv.getHtmlNoteName(4945)+"\"></textarea><span class=\"finput_btn_edit fbtn_edit fbtn_edit"+styleL+"\" onclick=\"MADFI_SetVE('"+theId+"')\" style=\"position: absolute;\"></span>"//取值为其它字段之间的运算结果时可使用此功能
								+"</div>"
								+"<div>"
									+"<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4531)+"</span>"  //显示类型：
									+"<select class=\"MADFI_Select\" id=\"showType_"+theId+"\">"
										+"<option value=\"1\">"+SystemEnv.getHtmlNoteName(4532)+"</option>"  //可编辑
										+"<option value=\"2\">"+SystemEnv.getHtmlNoteName(4533)+"</option>"  //只读
										+"<option value=\"3\">"+SystemEnv.getHtmlNoteName(4534)+"</option>"  //必填
									+"</select>"
								+"</div>"
								+"<div>"
									+ "<span class=\"MADFI_BaseInfo_Label MADFI_BaseInfo_Label1"+styleL+"\">"+SystemEnv.getHtmlNoteName(4535)+"</span>"  //默认值：
									+ "<span class=\"finput_btn_edit\" onclick=\"MADFI_editOneInParamOnPage('"+theId+"')\"></span>"
									+ "<span class=\"finput_param_paramValue\" id=\"paramValue_"+theId+"\"></span>"
								+"</div>"
							+"</div>"
							+"<div id=\"fieldSearchResult_"+theId+"\" class=\"MADFI_FieldSearchResult MADFI_FieldSearchResult"+styleL+"\"><ul></ul></div>"
							+"<div class=\"MADFI_Bottom\"><div class=\"MADFI_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
					 +"</div>";
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.FInputText.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var formid = this.mecJson["formid"];// Form mec_id
	var fieldname = this.mecJson["fieldname"];// 对应字段
	var fieldlabel = this.mecJson["fieldlabel"];// 显示名称
	var fieldremind = this.mecJson["fieldremind"];// 提示信息
	var required = Mec_FiexdUndefinedVal(this.mecJson["required"], "0");// 是否必填
	var defaultvalue = this.mecJson["defaultvalue"];// 默认值
	var htmlType = this.mecJson["htmlType"];// 默认值
	htmlType = htmlType == "6" ? "9" : htmlType;//将历史数据类型为数字的改为浮点数
	var readonly = Mec_FiexdUndefinedVal(this.mecJson["readonly"], "0");
	var minNumber = Mec_FiexdUndefinedVal(this.mecJson["minNumber"]);
	var maxNumber = Mec_FiexdUndefinedVal(this.mecJson["maxNumber"]);
	var stepNumval = Mec_FiexdUndefinedVal(this.mecJson["stepNumval"], 1);
	
	var yearPrevOffset = Mec_FiexdUndefinedVal(this.mecJson["yearPrevOffset"]);
	var yearNextOffset = Mec_FiexdUndefinedVal(this.mecJson["yearNextOffset"]);
	
	$("#formid_"+theId).val(formid);
	MADFI_FormChange(theId,fieldname);
	$("#fieldlabel_"+theId).val(fieldlabel);
	$("#fieldremind_"+theId).val(fieldremind);
	$("#defaultvalue_"+theId).val(defaultvalue);
	$("#htmlType_"+theId).val(htmlType);
	$("#minNumber_" + theId).val(minNumber);
	$("#maxNumber_" + theId).val(maxNumber);
	$("#stepNumval_" + theId).val(stepNumval);
	
	$("#yearPrevOffset_" + theId).val(yearPrevOffset);
	$("#yearNextOffset_" + theId).val(yearNextOffset);
	
	$("#valueExpression_" + theId).val(Mec_FiexdUndefinedVal(this.mecJson["valueExpression"]));
	
	if(required == "1"){
		$("#showType_"+theId).val("3");
	}else if(readonly == "1"){
		$("#showType_"+theId).val("2");
	}else{
		$("#showType_"+theId).val("1");
	}
	
	var inParams = this.mecJson["inParams"];
	for(var i = 0; inParams && i < inParams.length; i++){
		var $container = $("#MADFI_" + theId);
		$(".finput_param_paramValue", $container).text(inParams[i]["paramValue"]);
		break;
	}
	
	var precision = Mec_FiexdUndefinedVal(this.mecJson["precision"], 2);
	$("#htmlFloatPrecision_"+theId).val(precision);
	var assistInput = Mec_FiexdUndefinedVal(this.mecJson["assistInput"], 1);
	
	var $assistInput = $("input[type='checkbox'][name='assistInput_" + theId + "']");
	var $attrContainer = $("#MADFI_"+theId);
	if(assistInput == 1){
		$assistInput.attr("checked", "checked");
		$(".MADFI_NumType_addstep", $attrContainer).css("display","inline-block");
	}
	
	MADFI_InitFieldSearch(theId);
	MADFI_HtmlTypeChange(theId);
	$("#MADFI_"+theId).jNice();
	MLanguage({
		container: $("#MADFI_"+theId + " .MADFI_BaseInfo")
    });
};

/*获取JSON*/
MEC_NS.FInputText.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADFI_"+theId);
	if($attrContainer.length > 0){
		var formid=Mec_FiexdUndefinedVal($("#formid_"+theId).val());
		var fieldname=Mec_FiexdUndefinedVal($("#fieldname_"+theId).val());
		var fieldlabel=Mec_FiexdUndefinedVal($("#fieldlabel_"+theId).val());
		var fieldremind=Mec_FiexdUndefinedVal($("#fieldremind_"+theId).val());
		var defaultvalue=Mec_FiexdUndefinedVal($("#defaultvalue_"+theId).val());
		var htmlType=Mec_FiexdUndefinedVal($("#htmlType_"+theId).val());
		this.mecJson["formid"] = formid;
		this.mecJson["fieldname"] = fieldname;
		this.mecJson["fieldlabel"] =  MLanguage.getValue($("#fieldlabel_"+theId))||fieldlabel;
		this.mecJson["fieldremind"] = MLanguage.getValue($("#fieldremind_"+theId))||fieldremind;
		this.mecJson["defaultvalue"] = defaultvalue;
		this.mecJson["htmlType"] = htmlType;
		this.mecJson["valueExpression"] = $("#valueExpression_"+theId).val();
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
		var paramValue = $(".finput_param_paramValue", $attrContainer).text();
		for(var i = 0; i < inParams.length; i++){
			inParams[i]["paramValue"] = paramValue;
			break;
		}
		this.mecJson["minNumber"] = $("#minNumber_" + theId).val();
		this.mecJson["maxNumber"] = $("#maxNumber_" + theId).val();
		this.mecJson["stepNumval"] = $("#stepNumval_" + theId).val();
		
		this.mecJson["precision"] = $("#htmlFloatPrecision_"+theId).val();
		var $assistInput = $("input[type='checkbox'][name='assistInput_" + theId + "']:checked");
		if($assistInput.length > 0){
			this.mecJson["assistInput"] = "1";
		}else{
			this.mecJson["assistInput"] = "0";
		}
		this.mecJson["yearPrevOffset"] = $("#yearPrevOffset_" + theId).val();
		this.mecJson["yearNextOffset"] = $("#yearNextOffset_" + theId).val();
		
	}
	return this.mecJson;
};

MEC_NS.FInputText.prototype.getDefaultMecJson = function(){
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
	defMecJson["stepNumval"] = "1";
	return defMecJson;
};

function MADFI_FormChange(mec_id,selectedField){
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	Mec_GetFieldOptionHtml(formid, "fieldname_"+mec_id, selectedField);
}

function MADFI_HtmlTypeChange(mec_id){
	$htmlType = $("#htmlType_" + mec_id);
	var $attrContainer = $("#MADFI_"+mec_id);
	var htmlTypeVal = $htmlType.val();
	if(htmlTypeVal == "6" || htmlTypeVal == "8"){
		$(".MADFI_DateContent", $attrContainer).hide();
		$(".MADFI_NumContent", $attrContainer).show();
		$(".MADFI_NumType_float", $attrContainer).hide();
	}else if(htmlTypeVal == "9"){
		$(".MADFI_DateContent", $attrContainer).hide();
		$(".MADFI_NumContent", $attrContainer).show();
		if(_userLanguage=="8"){
			$(".MADFI_NumType_float", $attrContainer).css("display", "block");
		}else{
			$(".MADFI_NumType_float", $attrContainer).css("display", "inline-block");
		}
	}else if($htmlType.val() == "2" || $htmlType.val() == "4"){
		$(".MADFI_NumContent", $attrContainer).hide();
		$(".MADFI_DateContent", $attrContainer).show();
		$(".MADFI_NumType_float", $attrContainer).hide();
	}else{
		$(".MADFI_NumContent", $attrContainer).hide();
		$(".MADFI_DateContent", $attrContainer).hide();
		$(".MADFI_NumType_float", $attrContainer).hide();
	}
}

function MADFI_NumberChange(mec_id){
	var htmlType=$("#htmlType_"+mec_id).val();
	var $stepNumber = $("#stepNumval_" + mec_id);
	var $minNumber = $("#minNumber_" + mec_id);
	var $maxNumber = $("#maxNumber_" + mec_id);
	var stepNum = Number($stepNumber.val().trim());
	var minNumber = Number($minNumber.val().trim());
	var maxNumber = Number($maxNumber.val().trim());
	
	if(isNaN(minNumber)){
		alert(SystemEnv.getHtmlNoteName(4618));  //请输入数字
		$minNumber.val("");
		return;
	}
	if(isNaN(maxNumber)){
		alert(SystemEnv.getHtmlNoteName(4618));  //请输入数字
		$maxNumber.val("");
		return;
	}
	
	if($maxNumber.val() && maxNumber <= minNumber){
		alert(SystemEnv.getHtmlNoteName(4619));  //最大值要大于最小值
		$maxNumber.val("");
		return;
	}
	
	if(htmlType == "8" && parseInt(minNumber) != minNumber){
		alert(SystemEnv.getHtmlNoteName(4620));  //请使用整数作为最小值
		$minNumber.val(minNumber.toFixed(0));
		return;
	}
	if(htmlType == "8" && parseInt(maxNumber) != maxNumber){
		alert(SystemEnv.getHtmlNoteName(4621));  //请使用整数作为最大值
		$maxNumber.val(maxNumber.toFixed(0));
		return;
	}
	
	if(stepNum <= 0 || isNaN(stepNum)){
		alert(SystemEnv.getHtmlNoteName(4622));  //请输入大于0的数字
		$stepNumber.val("1");
		return;
	}
}

function MADFI_editOneInParamOnPage(mec_id){
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
		
		var $container = $("#MADFI_" + mec_id);
		$(".finput_param_paramValue", $container).text(result["paramValue"]);
	};

}

function MADFI_InitFieldSearch(mec_id){
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
						resultHtml += "<li><a href=\"javascript:MADFI_SetFieldSelected('"+mec_id+"','"+vv+"');\">"+vt+"</a></li>";
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
	
	$("#MADFI_" + mec_id).bind("click", function(){
		hideSearchResult();
	});
}

function MADFI_SetFieldSelected(mec_id, v){
	var $field = $("#fieldname_" + mec_id);
	$field.val(v);
	
	preSearchText = "";
	var $searchText = $("#fieldSearch_" + mec_id);
	$searchText.val("");
	$searchText.trigger("blur");
	MADFI_InitFieldSearch(mec_id)
}

function MADFI_ShowTip(type){
	var tip = "";
	if(_userLanguage=="8"){
		tip = "Since the date of choice is a range of the year, the default is the current year to move forward for 100 years as the minimum year, backward shift 1 years as the biggest year, assuming that the current is 2016, the optional year for 1916-2017 years. \n so you can set the offset to complete the control of the year interval, if you want to display the current year, you can set a forward offset to 0, backward offset 0.";
	}else if(_userLanguage=="9"){
		tip = "因爲日期選擇時年份是有一個區間的，默認爲當前年向前偏移100年作爲最小年份，向後偏移1年作爲最大年份，假設當前是2016年，可選年份爲1916-2017年。\n所以可以對偏移進行設置來完成對年份區間的控制，假如隻想顯示當前年，可以設置向前偏移爲0，向後偏移爲0。";
	}else{
		tip = "因为日期选择时年份是有一个区间的，默认为当前年向前偏移100年作为最小年份，向后偏移1年作为最大年份，假设当前是2016年，可选年份为1916-2017年。\n所以可以对偏移进行设置来完成对年份区间的控制，假如只想显示当前年，可以设置向前偏移为0，向后偏移为0。";
	}
	if(type == "yearOffset"){
		alert(tip);  //因为日期选择时年份是有一个区间的，默认为当前年向前偏移100年作为最小年份，向后偏移1年作为最大年份，假设当前是2016年，可选年份为1916-2017年。\n所以可以对偏移进行设置来完成对年份区间的控制，假如只想显示当前年，可以设置向前偏移为0，向后偏移为0。
	}
}

function MADFI_ChangeRAT(cbObj, mec_id){
	setTimeout(function(){
		var $attrContainer = $("#MADFI_"+mec_id);
		if(!cbObj.checked){
			$(".MADFI_NumType_addstep", $attrContainer).hide();
		}else{
			$(".MADFI_NumType_addstep", $attrContainer).css("display","inline-block");
		}
	}, 100);
}

function MADFI_SetVE(mec_id){
	var v = $("#valueExpression_" + mec_id).val();
	var url = "/mobilemode/setup/veSet.jsp?v="+encodeURIComponent(v);
	
	var formidObj = $("#formid_"+mec_id);
	var formid = formidObj.val();
	var mecHandler = MECHandlerPool.getHandler(formid);
	if(!mecHandler){
		return;
	}
	var datasource = mecHandler.mecJson["datasource"];
	var tablename = mecHandler.mecJson["tablename"];
	var formtype = mecHandler.mecJson["formtype"];
	formtype = (formtype == undefined ? "1" : formtype);
	var workflowid = mecHandler.mecJson["workflowid"];
	url += "&dsName="+datasource+"&tbName="+tablename+"&formType="+formtype+"&workflowId="+workflowid;
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 376;//定义长度
	dlg.Height = 608;
	dlg.URL = url;
	dlg.normalDialog = false;
	dlg.Title = SystemEnv.getHtmlNoteName(4002);  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var content = result["content"];
		
		$("#valueExpression_" + mec_id).val(content);
	};
}
