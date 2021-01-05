if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.Form = {};
Mobile_NS.Form.onload = function(formid){// 初始化
	var $form = $("#"+formid);
	Mobile_NS.Form.formatValue();
	//初始化页面时有默认值触发字段联动
	var billid = $("#billid", $form).val();
	if(!billid){
		$("[onchange^='Mobile_NS.readyToTrigger'],[oninput^='Mobile_NS.readyToTrigger']").each(function(){
			var that = $(this);
			if(that.val()){
				if(that.attr("onchange")){
					$(this).trigger("change");
				}
				if(that.attr("oninput")){
					$(this).trigger("input");
				}
			}
		});
	}
};

/*向前兼容，并将此方法暴露在函数库说明中供页面调用*/
Mobile_NS.formSubmit = function(formid, callbackFn, successMsg){
	Mobile_NS.Form.submit(formid, callbackFn, successMsg);
};

Mobile_NS.Form.submit = function(formid, callbackFn, successMsg){// 提交
	var $form = $("#"+formid);

	if($form.hasClass("submitting")) return;// 正在提交
	
	var errorMsg = Mobile_NS.Form.checkRequired($form);
	if(errorMsg != ""){
		Mobile_NS.Form.showMsg($form, errorMsg, "Form_Msg_Err");
	}else{
		var validateScript = $.trim($("input[name='validateScript']", $form).val());
		if(validateScript != ""){
			var vFnCode = "var validateFn = function(){"+decodeURIComponent(validateScript)+"};";
			eval(vFnCode);
			var vResult = validateFn();
			if(vResult == false){	//阻止表单提交
				return;
			}
		}
		
		$form.addClass("submitting");
		var $fButtons = $(".fButtons[formid='"+formid+"']");
		$fButtons.addClass("disabled");
		Mobile_NS.formFieldRepeatVerify(formid, function(){
			Mobile_NS.Form.send(formid, callbackFn, successMsg);
		}, function(){
			$fButtons.removeClass("disabled");
			$form.removeClass("submitting");
		});
	}
};
Mobile_NS.Form.getFormData = function($form){
	var formData = new FormData();
	
	$form.find("input, select, textarea").each(function(){
		var $this = $(this);
		var name = $this.attr("name");
		if(name){
			if(this.tagName.toLowerCase() == "input" && $this.attr("type").toLowerCase() == "file"){
				var file = this.files[0];
				file && formData.append(name, file);
			}else{
				formData.append(name, $(this).val());
			}
		}
	});
	
	return formData;
};
Mobile_NS.Form.send = function(formid, callbackFn, successMsg){
	if(Object.prototype.toString.call(callbackFn) == "[object String]"){
		successMsg = callbackFn;
	}
	var $form = $("#"+formid);
	var actionUrl = $form.attr("action");
	var formData = Mobile_NS.Form.getFormData($form); 
	$.ajax({
		url: actionUrl,
		type: 'POST',
		data: formData,
		processData: false,	//必须false才会避开jQuery对 formdata 的默认处理,XMLHttpRequest会对 formdata 进行正确的处理
		contentType: false,	//必须false才会自动加上正确的Content-Type
		success : function(responseText, textStatus) {
			if(responseText == ""){
				console.error("表单提交后服务端返回值为空");
				return;
			}
			var result = $.parseJSON(responseText);
			if(typeof(Mobile_NS.formResponse) == "function"){	//兼容老的代码会重写formResponse的情况
				Mobile_NS.formResponse(result);
				return;
			}
			var status = result["status"];
			if(status == "1"){
				var msg = successMsg || _formMLJson['83551'];//保存成功!
				Mobile_NS.Form.showMsg($form, msg, "Form_Msg_Info");
				
				var billid = result["id"];
				if(billid && billid != ""){
					$("input[type='hidden'][name='billid']", $form).val(billid);
					$("#actiontype").val(1);
				}
				
				//明细表主键赋值
				var detailidsArray = result["detailidsList"] || [];
				for(var i in detailidsArray){
					var dataItem = detailidsArray[i];
					var detailtablename = dataItem["tablename"] || "";
					var mainkey = dataItem["mainkey"] || "id";
					var detailids = dataItem["detailids"] || [];
					for(var j in detailids){
						var detailid = detailids[j] || "";
						var detailidSplitArr = detailid.split("_SPLIT_");
						if(detailidSplitArr.length > 1){
							var indexid = detailidSplitArr[0];
							var detailkeyvalue = detailidSplitArr[1];
							if(detailkeyvalue){
								$("input[name='"+detailtablename+"_"+mainkey+"_rowindex_"+indexid+"']").val(detailkeyvalue);
							}
						}
					}
				}
				
				if(typeof(callbackFn) == "function"){
					try{callbackFn(billid);}catch(e){console.error(e);}
				}
			}else if(status == "0"){
				var errMsg = _formMLJson['383769'];//表单保存出现异常：
				var formtype = $("input[name=formtype]", $form).val();
				if(formtype == "2"){
					errMsg = _formMLJson['383770'];//流程创建异常：
				}
				errMsg += decodeURIComponent(result["errMsg"]);
				Mobile_NS.Form.showMsg($form, errMsg, "Form_Msg_Err");
			}
			var $fButtons = $(".fButtons[formid='"+formid+"']");
			$fButtons.removeClass("disabled");
			$form.removeClass("submitting");
		},
		error: function(responseText) {
			Mobile_NS.Alert(_formMLJson['383771'] + JSON.stringify(responseText), false, [_formMLJson['383773'], function(){//数据提交失败：  知道了
				$(this).parents("#dialog").hide();
			}]);
		}
	});
};

Mobile_NS.Form.formatValue = function(){
	$("textarea[name^='fieldname_']").each(function(){
		var that = $(this);
		var content = that.val();
		if(content){
			brRegex = /<br>/g;
			replaceBrValue = "\n";
			spaceRegex = /&_nbsp;/g;
			replaceSpaceValue = " ";
			content = content.replace(brRegex, replaceBrValue).replace(spaceRegex, replaceSpaceValue);
			that.val(content);
		}
	});
};

Mobile_NS.Form.deleteData = function(formid){// 提交删除
	Mobile_NS.Confirm(_formMLJson['383775'], _formMLJson['82017'], [_formMLJson['383776'],function(){}],[_formMLJson['131200'], function(){//删除后将不能恢复,请确认! 确认删除? 点错了 删除
		
		var $form = $("#"+formid);
		if($form.hasClass("submiting")) return;// 正在提交
		
		$form.addClass("submitting");
		var $fButtons = $(".fButtons[formid='"+formid+"']");
		$fButtons.addClass("disabled");
		
		var billid = $("#billid", $form).val();
		var modelid = $("#modelid", $form).val();
		var url = "/mobilemode/formComponentAction.jsp?action=deletedata";
		if(billid != "" && modelid != ""){
			Mobile_NS.ajax(url, {billid:billid, modelid:modelid}, function(data){
				var status = data["status"];
				if(status == "2"){
					Mobile_NS.Alert(_formMLJson['20461']);//删除成功
					Mobile_NS.refreshPrevPageList();
					Mobile_NS.backPage();
				}else if(status == "-1"){
					var errMsg = data["errMsg"];
					Mobile_NS.Form.showMsg($form, errMsg, "Form_Msg_Err");
				}
			}, "json");
		}else{
			Mobile_NS.Form.showMsg($form, _formMLJson['383777'], "Form_Msg_Err");//参数不合法
		}
	}]
	);
};

Mobile_NS.Form.edit = function(formid){
	var $form = $("#"+formid);
	var billid = $("#billid", $form).val();
	var modelid = $("#modelid", $form).val();
	if(billid == "" || modelid == ""){
		Mobile_NS.Form.showMsg($form, _formMLJson['383777'], "Form_Msg_Err");//参数不合法
	}else{
		$u_r_replace("/mobilemode/layout.jsp?appid="+appid+"&billid="+billid+"&modelid="+modelid+"&uitype=2");
	}
};

Mobile_NS.Form.reset = function(formid){// 重置
	var $form = $("#"+formid);
	$form[0].reset(); 
	Mobile_NS.Form.nativeReset($form);
};
Mobile_NS.formMsg = function($form, msg, bgClass){
	Mobile_NS.Form.showMsg($form, msg, bgClass);
};
Mobile_NS.Form.showMsg = function($form, msg, bgClass){
	if(_top && typeof(_top.Dialog) == "function"){
		if(bgClass == "Form_Msg_Info"){
			Mobile_NS.Alert(msg);
		}else if(bgClass == "Form_Msg_Err"){
			Mobile_NS.Alert(msg, false, [_formMLJson['383773'], function(){//知道了
				$(this).parents("#dialog").hide();
			}]);
		}
	}else{
		Mobile_NS.Form.showMsg2($form, msg, bgClass);
	}
};

// jQuery 淡入淡出效果
Mobile_NS.Form.showMsg2 = function($form, msg, bgClass){
	var $slideDiv = $(".Form_Msg", $form);
	$slideDiv.removeClass("Form_Msg_Err Form_Msg_Info");
	$slideDiv.addClass(bgClass);
	$slideDiv.html(msg);
	
	$slideDiv.addClass("fadeIn");
	
	var outTime = 2000;
	if(bgClass == "Form_Msg_Err"){
		outTime = 6000;
	}
	setTimeout(function(){
		$slideDiv.removeClass("fadeIn");
		
		setTimeout(function(){
			$slideDiv.removeClass(bgClass);
			$slideDiv.html("");
		}, 600);
	}, outTime);
};

// 提交前验证表单必填项
Mobile_NS.Form.checkRequired = function($form){
	var requiredFields = [];
	
	var $fields = $("[require='required']", $form);
	for ( var i = 0; i < $fields.length; i++) { 
		if($fields[i].value == ""){
			//lbs必填
			var isLbs = $($fields[i]).attr("isLbs");
			if(isLbs == "isLbs"){
				return _formMLJson['383778'];//请定位所在位置
			}
			
			var fieldlabel = $($fields[i]).attr("fieldlabel");
			requiredFields.push(fieldlabel);
		}
	}
	
	var errorMsg = "";
	if(requiredFields.length > 0){
		errorMsg = _formMLJson['383779']+"(" + requiredFields.join() + ")";//必要信息不完整
	}
	return errorMsg;
};

// 表单原生控件重置
Mobile_NS.Form.nativeReset = function($form){
	if($(".Design_FSound_Container", $form).length > 0){// 语音
		$form.find("[id^='soundContent']").val("");
		$form.find("[id^='soundRecord']").show();
		$form.find("[id^='soundDelete']").hide();
	}
	if($(".Design_LBS_Container", $form).length > 0){// LBS
		$form.find("[id^='lbsField']").val("");
		$form.find("[id^='lbsLocation']").show();
		$form.find("[id^='lbsDelete']").hide();
	}
	if($(".Design_FPhoto_Container", $form).length > 0){// 拍照
		var $photoField = $form.find("[id^='photoField']");
		$photoField.each(function(){
			var $this = $(this);
			var mecid = $this.attr("mecid");
			$entry = $("#photoBorder"+mecid);
			$entryWrap = $("#photoEntryWrap"+mecid);
			$entryWrap.children().remove();
			$entryWrap.append($entry);
			var $defaultValueShowHtmlWrap = $("#photoEntryDefaultShowHtmlWrap"+mecid);
			var defaultValue = $defaultValueShowHtmlWrap.attr("data-value") || "";
			$this.val(defaultValue);
			if($defaultValueShowHtmlWrap.children().length > 0){
				$("img.lazy", $defaultValueShowHtmlWrap).each(function(){
					var $img = $(this);
					var src = $img.attr("src");
					var originalSrc = $img.attr("data-original");
					if(originalSrc && src != originalSrc){
						$img.attr("src", originalSrc);
					}
				});
				$entryWrap.prepend($("div.Design_FPhoto_EntryBorder", $defaultValueShowHtmlWrap).clone());
			}
		});
	}
	if($(".Design_FFile_Container", $form).length > 0){// 附件
		var $fileField = $form.find("[id^='fileField']");
		$fileField.each(function(){
			var $this = $(this);
			var mecid = $this.attr("mecid");
			$entry = $("#fileBorder"+mecid);
			$entryWrap = $("#FileEntryWrap"+mecid);
			$entryWrap.children().remove();
			$entryWrap.append($entry);
			var originalVal = $(this).val();
			if(originalVal){
				var $defaultValueShowHtmlWrap = $("#FileEntryDefaultShowHtmlWrap"+mecid);
				if($defaultValueShowHtmlWrap.children().length > 0){
					$entryWrap.prepend($("div.Design_FFile_EntryBorder", $defaultValueShowHtmlWrap).clone());
				}
			}
		});
	}
	if($(".Design_FHandwriting_Container", $form).length > 0){// 批注
		var $HandwritingField = $form.find("[id^='HandwritingField']");
		$HandwritingField.each(function(){
			var $this = $(this);
			var mecid = $this.attr("mecid");
			$this.val("");
			$entryWrap = $("#HandwritingWrap" + mecid);
			$entryWrap.addClass("empty");
		});
	}
	if($(".Design_FCheckbox_Field", $form).length > 0){//Checkbox
		$(".Design_FCheckbox_Field", $form).each(function(){
			var id = $(this).attr("id").replace("div", "");
			Mobile_NS.FCheckbox.reset(id);
		});
	}
	if($(".Design_FCheck_Field", $form).length > 0){//Check框
		$(".Design_FCheck_Field", $form).each(function(){
			var id = $(this).attr("id").replace("div", "");
			var originalVal = $("#"+id).val();
			var $FCheckContainer = $(".FCheckContainer", $(this));
			if($FCheckContainer.hasClass("active")){
				$FCheckContainer.removeClass("active");
			}
			if(originalVal=="1"){
				$FCheckContainer.addClass("active");
			}
		});
	}
	if($(".Design_FBrowser_Field", $form).length > 0){//Browser框
		$(".Design_FBrowser_Field", $form).each(function(){
			var id = $(this).attr("id").replace("div", "");
			var originalVal = $("#"+id).val();
			if(originalVal == ""){
				$(this).find(".browser-name-wrap").removeClass("hasValue");
			}else{
				$(this).find(".browser-name-wrap").addClass("hasValue");
			}
			var $browserName = $(this).find(".browser-name")
			$browserName.html($browserName.attr("showname"));
		});
	}
	if($(".field-view-span", $form).length > 0){
		$(".field-view-span", $form).each(function(){
			$(this).html($(this).attr("showname"));
		});
	}
	//多行文本重置
	$(".Design_FTextarea_Field", $form).each(function(){
		var $this = $(this);
		var $textarea = $("textarea", $this);
		$(".field-view-span", $this).html($textarea.html());
	});
	
};
Mobile_NS.Form.Trigger = {};

Mobile_NS.readyToTrigger = function(p, obj){
	Mobile_NS.Form.Trigger.readyToTrigger(p, obj);
};

Mobile_NS.Form.Trigger.getValueByKey = function(jsonObj, key){
	var value = "";
	for(var k in jsonObj){
		if(k.toLowerCase() == key.toLowerCase()){
			value = jsonObj[k];
		}
	}
	return value;
};

Mobile_NS.Form.Trigger.readyToTrigger = function(p, obj){
	var that = this;
	var triggers = $.parseJSON(decodeURIComponent(p));
	var $fieldEle = $(obj);
	for(var i in triggers){
		var trigger = triggers[i];
		var modeid = that.getValueByKey(trigger, "modeid");
		var dataInputs = that.getValueByKey(triggers[i], "dataInputs");
		if(dataInputs){
			for(var j in dataInputs){
				var dataInput = dataInputs[j];
				var datasourceName = that.getValueByKey(dataInput, "datasourceName");
				var whereClause = that.getValueByKey(dataInput, "whereClause");
				var dataInputTables = that.getValueByKey(dataInput, "dataInputTables");
				that.setEachTriggerDetail($fieldEle, dataInputTables, whereClause, datasourceName, modeid);
			}
		}
	}
};
//解析一个触发设置，对应表单建模里面的触发设置
Mobile_NS.Form.Trigger.setEachTriggerDetail = function(field, dataInputTables, whereClause, datasourcename, modeid){
	var that = this;
	if(dataInputTables){
		//赋值字段
		var triggerJsonArr = [];
		//取值字段
		var triggerConditionjsonArr = [];
		var fromTable = "";
		var triggerCondition = "";
		//是否触发字段联动，加此条件用来限制当触发字段为树形多节点，并且设置了多触发条件时生效，即只执行当前节点的触发设置，非当前节点则不执行
		var isTrigger = true;
		for(var i in dataInputTables){
			var dataInputTable = dataInputTables[i];
			var tableName = that.getValueByKey(dataInputTable, "tableName");
			var alias = that.getValueByKey(dataInputTable, "alias");
			var formId = that.getValueByKey(dataInputTable, "formId");
			var dataInputTableFields = that.getValueByKey(dataInputTable, "dataInputTableFields");
			if(fromTable != ""){
				fromTable += ",";
			}
			
			fromTable += (tableName + " " + alias);
			if(dataInputTableFields){
				for(var j in dataInputTableFields){
					var tableFieldJson = dataInputTableFields[j];
					if(that.getValueByKey(tableFieldJson, "type") == "1"){//取值字段设置
						var otherTrigjson = {};
						var tempName = that.getValueByKey(tableFieldJson, "dbFieldName");
						otherTrigjson.alias = alias;
						otherTrigjson.name = tempName;
						var tempFieldid = that.getValueByKey(tableFieldJson, "pageFieldName");
						otherTrigjson.fieldid = tempFieldid;
						otherTrigjson.value = "";
						var tempField = $("*[fieldid='"+tempFieldid.substring(5)+"']");
						otherTrigjson.expression = "=";
						if(tempField.length > 0){
							var fieldHtmlType = tempField.attr("fieldhtmltype");
							//多行文本多人力资源用like查询
							var expression = ((fieldHtmlType == "2" || (fieldHtmlType == "3" && tempField.attr("browserid") == "17")) ? " like " : "=");
							
							var fieldValue = tempField.val();
							var treenodeid = that.getValueByKey(tableFieldJson, "treenodeid");
							if(treenodeid && fieldValue){
								var fieldValuePrefix = treenodeid + "_";
								if(fieldValue.slice(0, fieldValuePrefix.length) != fieldValuePrefix){
									isTrigger = false;
									break;
								}
								fieldValue = fieldValue.replace(fieldValuePrefix, "");
							}
							otherTrigjson.value = fieldValue
							otherTrigjson.expression = expression;
						}
						triggerConditionjsonArr.push(otherTrigjson);
					}else{//赋值字段
						var triggerJson = {};
						triggerJson["searchFieldName"] = that.getValueByKey(tableFieldJson,"dbFieldName");
						triggerJson["beTriggerName"] = that.getValueByKey(tableFieldJson,"pageFieldName");
						triggerJson["formId"] = formId;
						triggerJson["alias"] = alias;
						triggerJsonArr.push(triggerJson);
					}
				}
				if(!isTrigger) break;
			}
		}
		if(isTrigger){
			that.setTriggerDetail(field, fromTable, whereClause, triggerJsonArr, datasourcename, modeid, triggerConditionjsonArr);
		}
	}
};

//给被联动的字段赋值
Mobile_NS.Form.Trigger.setTriggerDetail = function(field, fromTable, whereClause, triggerJsonArr, datasourcename, modeid, triggerConditionjsonArr){
	var that = this;
	var searchFieldName = "";
	var beTriggerName = "";
	var formId = "";
	var btvArray = new Array();
	var fieldValue = field.val();
	var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=getFieldTriggerValue&triggerJsonArr="+encodeURIComponent(JSON.stringify(triggerJsonArr))+"&fromTable="+fromTable+"&whereClause="+encodeURIComponent(whereClause)+"&triggerConditionjsonArr="+encodeURIComponent(JSON.stringify(triggerConditionjsonArr)));
	Mobile_NS.ajax(url, {datasourcename:datasourcename}, function(result){
		for(var i in triggerJsonArr){
			var data = triggerJsonArr[i];
			searchFieldName = data["searchFieldName"];
			beTriggerName = data["beTriggerName"].substring(5);
			formId = data["formId"];
			
			var beTriggerValues = "";
			
			if(fieldValue == "" || fieldValue == null){
				var beTriggerValue = "";
				beTriggerValues += ("," + beTriggerValue);
				btvArray[0] = beTriggerValue;
				that.setTriggerdetailByhtmltype(formId, searchFieldName, datasourcename, btvArray, beTriggerValues, beTriggerName, false, modeid);
			}else{
				if($.parseJSON(result)["status"] == "1"){
					var values = $.parseJSON(result)["data"];
					if(values.length){
						var beTriggerValue = that.getValueByKey(values[0],searchFieldName);
						beTriggerValues += (","+beTriggerValue);
						btvArray[0] = beTriggerValues;
					}
					that.setTriggerdetailByhtmltype(formId, searchFieldName, datasourcename, btvArray, beTriggerValues, beTriggerName, true, modeid);
				}else{
					var beTriggerValue = "";
					beTriggerValues += ("," + beTriggerValue);
					btvArray[0] = beTriggerValue;
					that.setTriggerdetailByhtmltype(formId, searchFieldName, datasourcename, btvArray, beTriggerValues, beTriggerName, false, modeid);
				}
			}
		}
	});
};

//按照字段类型给字段赋值
Mobile_NS.Form.Trigger.setTriggerdetailByhtmltype = function(formid, searchfieldname, datasourcename, btvArray, beTriggerValues, beTriggerName, istrigger, modeid){
	var beTriggerdetail = "";
	if(beTriggerValues) beTriggerValues = beTriggerValues.substring(1);
	var $element = $("[fieldid='" + beTriggerName + "']");
	if(!$element) return;
	var mecId = $element.attr("id");
	var htmltype = $element.attr("fieldhtmltype");
	if(htmltype == "3"){//browser
		if(istrigger){
			//查询联动赋值字段的browser值
			var browserid = $element.attr("browserid");
			var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=parseBrowserValue&browserId="+browserid+"&convertValue="+encodeURIComponent(btvArray.toString())+"&fieldId="+beTriggerName);
			Mobile_NS.ajax(url, {}, function(data){
				if($.parseJSON(data)["status"] == "1"){
					beTriggerdetail = $.parseJSON(data)["data"];
					//给联动的字段赋值
					$("#"+mecId).val(beTriggerValues);
					$("#"+mecId+"_span").html(beTriggerdetail);
					if(beTriggerdetail){
						$element.siblings(".browser-name-wrap").addClass("hasValue");
					}else{
						$element.siblings(".browser-name-wrap").removeClass("hasValue");
					}
					$element.attr("onchange") && $element.trigger("change");
				}
			});
		}else{
			$("#"+mecId).val(beTriggerValues);
			$("#"+mecId+"_span").html("");
			$element.siblings(".browser-name-wrap").removeClass("hasValue");
			$element.attr("onchange") && $element.trigger("change");
		}
		
	}else if(htmltype == "4"){//check框
		var $checkContainer = $element.siblings(".FCheckContainer");
		if(beTriggerValues == "1"){
			$checkContainer.addClass("active");
			$("#"+mecId).val(beTriggerValues);
		}else{
			$checkContainer.removeClass("active");
			$("#"+mecId).val("");
		}
	}else if(htmltype == "5"){// 选择项
		var value = beTriggerValues;
		var $_span = $("#"+mecId+"_span");
		if(!!$_span[0]){
			var jsonObj = decodeURIComponent($_span.attr("jsonstr"));
			jsonObj = $.parseJSON(jsonObj);
			$_span.html(jsonObj[value]);
		}
		$("#"+mecId).val(value);
	}else{
		brRegex = /<br>/g;
		replaceBrValue = "\n";
		spaceRegex = /&nbsp;/g;
		replaceSpaceValue = " ";
		beTriggerValues = beTriggerValues.replace(brRegex, replaceBrValue).replace(spaceRegex, replaceSpaceValue);
		//给联动的字段赋值
		$("#"+mecId).val(beTriggerValues);
		$("#"+mecId+"_span").html(beTriggerValues);
	}
	if(htmltype != "3"){
		$element.attr("oninput") && $element.trigger("input");
		$element.attr("onchange") && $element.trigger("change");
	}
}
Mobile_NS.Form.PageExpand = {};
Mobile_NS.Form.PageExpand.doInterfacesAction = function(interfaceurl, openurl){
	var that = this;
	var url = jionActionUrl("com.weaver.formmodel.data.servlet.BusinessDataAction", "action=doInterfacesAction");
	$.ajax({
		url : url,
		type : "get",
		processData : false,
		data : interfaceurl,
		dataType : "text",
		async : true,//改为异步
		success: function do4Success(msg){}
	});
	that.jsORopenUrl(openurl);
}

Mobile_NS.Form.PageExpand.jsORopenUrl = function(url){
	url = decodeURIComponent(url);
	if(url.substring(0,11) == "javascript:"){
		eval(url.substring(11));
	}else{
		openDetail(url);
	}
}

Mobile_NS.getFormField = $f = function(name){
	return new Wev_MField(name);
};


function Wev_MField(name){
	this.name = name;
	
	var prefix = "fieldname_";
	var fieldName = prefix + name.toLowerCase();
	var $formFields = $("[name^='"+prefix+"']");
	var $field = null;
	$.each($formFields, function(i){
		var $this = $(this);
		if($this.attr("name").toLowerCase() == fieldName){
			$field = $this;
			return false;
		}
	});
	
	if($field == null){
		this.$Obj = $();
		console.error("未找到名称为 " + name + " 的字段。");
	}else{
		this.$Obj = $field;
	}
}

Wev_MField.prototype.val = function(v){
	var that = this;
	if(typeof(v) == "undefined"){	//取值
		return that.$Obj.val();
	}else{
		var $abbr = that.$Obj.closest("abbr");
		var type = $abbr.attr("m_type");
		if(type == "FInputText"){
			that.$Obj.val(v);
			$(".field-view-span", $abbr).html(v);
			that.$Obj.trigger("input");
			that.$Obj.trigger("change");
		}else if(type == "FSelect"){
			that.$Obj.val(v);
			that.$Obj.trigger("change");
			that.$Obj.trigger("input");
		}else if(type == "FBrowser"){
			var browserId = that.$Obj.attr("browserid");
			var browserName = that.$Obj.attr("browsername");
			var url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=parseBrowserValue&browserId="+browserId+"&convertValue="+encodeURIComponent(v)+"&browserName="+browserName);
			Mobile_NS.ajax(url, {}, function(data){
				if($.parseJSON(data)["status"] == "1"){
					var text = $.parseJSON(data)["data"];
					that.$Obj.val(v);
					$(".browser-name", $abbr).html(text);
					if(text){
						$(".browser-name-wrap", $abbr).addClass("hasValue");
					}else{
						$(".browser-name-wrap", $abbr).removeClass("hasValue");
					}
					that.$Obj.trigger("change");
					that.$Obj.trigger("input");
				}
			});
		}else if(type == "FCheckbox"){
			that.$Obj.val(v);
			$("ul li.checked", $abbr).removeClass("checked");
			var cbType = $(".FCheckboxContainer", $abbr).attr("cb-type");
			if(cbType == "0"){
				$("ul li[data-value='"+v+"']", $abbr).addClass("checked");
			}else{
				var vArr = v.split(",");
				$.each(vArr, function(i, tmpV){
					$("ul li[data-value='"+tmpV+"']", $abbr).addClass("checked");
				});
			}
			that.$Obj.trigger("input");
		}else if(type == "FCheck"){
			if(v != "1" && v != ""){
				console.error("check框只有2种值：选中状态为1，非选中状态为空。");
				return;
			}
			that.$Obj.val(v);
			$(".FCheckContainer", $abbr).toggleClass("active", v == "1");
			that.$Obj.trigger("change");
		}else if(type == "FTextarea"){
			that.$Obj.val(v);
			$(".field-view-span", $abbr).html(v);
			that.$Obj.trigger("change");
			that.$Obj.trigger("input");
		}else{
			that.$Obj.val(v);
		}
		return that;
	}
};

Wev_MField.prototype.text = function(){
	var that = this;
	var $abbr = that.$Obj.closest("abbr");
	var type = $abbr.attr("m_type");
	if(type == "FSelect"){
		var index = that.$Obj[0].selectedIndex; 
		return that.$Obj.find("option").eq(index).text();
	}else if(type == "FCheckbox"){
		var t = "";
		$("ul li.checked", $abbr).each(function(){
			t = t + $(this).text() + ",";
		});
		if(t != ""){
			t = t.substring(0, t.length - 1);
		}
		return t;
	}else if(type == "FBrowser"){
		return $(".browser-name", $abbr).text();
	}else if(type == "FLbs"){
		return $(".Design_LBS_Delete_Text", $abbr).text();
	}else{
		return that.$Obj.text();
	}
};

Mobile_NS.calculateColSum = function(fieldname){
	var result = 0;
	if(fieldname){
		var expMatches = fieldname.match(/(\w+)\.(\w+)/);
		if(expMatches){
			var detailtable = expMatches[1];
			var detailfield = expMatches[2];
			var detailtableMecid = $("input[type='hidden'][value='"+detailtable+"']").attr("name") 
				|| $("input[type='hidden'][value='"+detailtable.toLowerCase()+"']").attr("name")
				|| $("input[type='hidden'][value='"+detailtable.toUpperCase()+"']").attr("name");
			if(detailtableMecid){
				detailtableMecid = detailtableMecid.replace("detailtablename_", "");
				var $detailtable = $("#detailtable"+detailtableMecid);
				$("input[type='hidden']", $detailtable).each(function(){
					var $hidden = $(this);
					var name = $hidden.attr("name");
					if(name && name.toLowerCase().indexOf((detailtable + "_" + detailfield + "_rowindex_").toLowerCase()) != -1){
						var v = $hidden.val();
						if(v != "" && !isNaN(v)){
							result += Number(v);
						}
					}
				});
			}
		}
	}
	return result;
}