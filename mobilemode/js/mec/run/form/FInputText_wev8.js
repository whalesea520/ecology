Mobile_NS.FInputText = {};
Mobile_NS.FInputText.onload = function(p){
	var theId = p["id"];
	var htmlType = p["htmlType"] || "";	//1.文本，2.日期，3.时间，4.日期时间，5.密码，6.数字，7.电话号码
	
	var readonly = p["readonly"] || "0";
	
	if(htmlType != "" && htmlType != "1" && readonly != "1"){
		
		var currYear = (new Date()).getFullYear();	
		var yearPrevOffset = p["yearPrevOffset"] || "100";
		var yearNextOffset = p["yearNextOffset"] || "1";
		yearPrevOffset = parseInt(yearPrevOffset);
		yearNextOffset = parseInt(yearNextOffset);
		
		var _userlang = p["_userlang"] || 7;
		
		var opt={};
		opt.date = {preset : 'date', dateFormat : "yy-mm-dd"};
		opt.datetime = {preset : 'datetime', dateFormat : "yy-mm-dd", width : 40};
		opt.time = {preset : 'time'};
		opt.defa = {
			theme: 'android-ics light', //皮肤样式
	        display: 'modal', //显示方式 
	        mode: 'scroller', //日期选择模式
			lang:_userlang == 8 ? 'en' : 'zh',
	        startYear:currYear - yearPrevOffset, //开始年份
	        endYear:currYear + yearNextOffset //结束年份
		};
		
		var $field = $("#" + theId);
		var $inputContainer = $("#div" + theId);
		
		if(htmlType == "2"){
			var optCurr = $.extend(opt['date'], opt['defa']);
			$field.mobiscroll(optCurr).date(optCurr);
		}else if(htmlType == "3"){
			var optCurr = $.extend(opt['time'], opt['defa']);
			$field.mobiscroll(optCurr).time(optCurr);
		}else if(htmlType == "4"){
			var optCurr = $.extend(opt['datetime'], opt['defa']);
			$field.mobiscroll(optCurr).datetime(optCurr);
		}else if(htmlType == "6" || htmlType == "8" || htmlType == "9"){
			var assistInput = p["assistInput"] || 1;
			
			if(assistInput == 1){
				$inputContainer.append("<div class=\"Design_FInputText_Number_AddMinus\">"
						+ "<span class=\"Design_FInputText_Number_Minus\"></span>"
						+ "<span class=\"Design_FInputText_Number_Add\"></span>"
				+ "</div>");
			}
			
			Mobile_NS.FInputText.changeNumberValue(p);
		}
		
		if(htmlType == "2" || htmlType == "3" || htmlType == "4"){// 清空按钮
			$field.change(function(){
				var $clearBtn = $("#fieldSub"+theId);
				$clearBtn.show();
				$clearBtn.click(function(e){
					e.stopPropagation();
					var fieldval = $("#"+theId).val();
					if(fieldval && fieldval != ""){
						$("#"+theId).val("").trigger("change");
						$clearBtn.hide();
						$clearBtn.unbind();
					}
				});
				$field.triggerHandler("input");
			});
		}
		
	}
	
	var valueExpression = p["valueExpression"];
	if(typeof(valueExpression) != "undefined" && valueExpression != null && valueExpression != ""){
		var FV = function(val){
			var htmlType = p["htmlType"] || "";
			var precision = p["precision"] || "2";
			
			if(htmlType == "9" || htmlType == "6"){//将老的数字类型当做浮点数处理
				val = Number(val).toFixed(precision);
			}else if(htmlType == "8"){
				val = Number(val).toFixed(0);
			}
			
			return val;
		}
		
		var nameArr = (valueExpression.match(/{(\w+)}|{(\w+\.\w+)}/g) || []).map(function(pro){
			return pro.replace(/{|}/g, "")
		});
		
		var runVP = function(){
			
			var isRunabled = true;
			var paramArr = {};
			$.each(nameArr, function(i, name){
				if(!/(\w+)\.(\w+)/.test(name)){
					var v = $f(name).val();
					if(v != "" && !isNaN(v)){
						v = Number(v);
					}
					paramArr[name] = v;
				}
			});
			
			with(paramArr){
				var v = eval(valueExpression.replace(/{|}/g, ""));
				$f(p["fieldname"]).val(FV(v));
				//console.log(v);
			}
			
		};
		
		$.each(nameArr, function(i, name){
			var nameMatches = name.match(/(\w+)\.(\w+)/);
			if(nameMatches){//明细表字段
				var detailtable = nameMatches[1];
				var detailfield = nameMatches[2];
				var detailtableMecid = $("input[type='hidden'][value='"+detailtable+"']").attr("name") 
					|| $("input[type='hidden'][value='"+detailtable.toLowerCase()+"']").attr("name")
					|| $("input[type='hidden'][value='"+detailtable.toUpperCase()+"']").attr("name");
				if(detailtableMecid){
					detailtableMecid = detailtableMecid.replace("detailtablename_", "");
					$("#detailtable"+detailtableMecid).bind("detailtableDomChanged", runVP);
				}
			}else{
				$f(name).$Obj.bind("input", runVP);
			}
		});
		//默认值触发运算
		var formid = p["formid"];
		var $form = $("#"+formid);
		if(!$("input[name='billid']", $form).val()){
			runVP();
		}
	}
	
};

Mobile_NS.FInputText.changeNumberValue = function(p){
	var that = this;
	var mec_id = p["id"];
	var formid = p["formid"];
	var htmlType = p["htmlType"] || "";
	var multiLJson = p['multiLJson'];
	var $form = $("#"+formid);
	var $field = $("#" + mec_id);
	var minNumber = NaN;
	!p["minNumber"] || (minNumber = Number(p["minNumber"]));
	var maxNumber = NaN;
	!p["maxNumber"] || (maxNumber = Number(p["maxNumber"]));
	var stepNumval = Number(p["stepNumval"]);
	if(isNaN(stepNumval)){
		stepNumval = 1;
	}else{
		stepNumval = Math.abs(stepNumval);
	}
	
	var $inputContainer = $("#div" + mec_id);
	$(".Design_FInputText_Number_Minus", $inputContainer).bind("click", function(){
		var fieldVal = Number($field.val());
		if(!$field.val() || isNaN(fieldVal)){
			if(isNaN(maxNumber)){
				fieldVal = 0;
			}else{
				fieldVal = maxNumber;
			}
		}
		fieldVal = fieldVal - stepNumval;
		if(!isNaN(minNumber)){
			if(fieldVal < minNumber){
				Mobile_NS.Form.showMsg($("#" + formid), multiLJson['383814']+"("+minNumber+")!", "Form_Msg_Err");//超出最小值范围
				$field.val(minNumber);
				return;
			}
		}
		$field.val(fieldVal);
		that.formatValue($field, p);
		
		Mobile_NS.FInputText.toTriggerByClick(mec_id);
	});
	$(".Design_FInputText_Number_Add", $inputContainer).bind("click", function(){
		var fieldVal = Number($field.val());
		if(!$field.val() || isNaN(fieldVal)){
			if(isNaN(minNumber)){
				fieldVal = 0;
			}else{
				fieldVal = minNumber;
			}
		}
		fieldVal = fieldVal + stepNumval;
		if(!isNaN(maxNumber)){
			if(fieldVal > maxNumber){
				Mobile_NS.Form.showMsg($("#" + formid), multiLJson['383815']+"("+maxNumber+")!", "Form_Msg_Err");//超出最大值范围
				$field.val(maxNumber);
				return;
			}
		}
		$field.val(fieldVal);
		that.formatValue($field, p);
		
		Mobile_NS.FInputText.toTriggerByClick(mec_id);
	});
	var eventStr = "change blur";
	if(navigator.userAgent.indexOf("MSIE") == -1){
		eventStr += " input";
	}
	$field.bind(eventStr, function(){
		if($field.val() == "-") return;
		var fieldVal = Number($field.val());
		if($field.val() != "" && !isNaN(fieldVal)){
			if(!isNaN(minNumber) && fieldVal < minNumber){
				$field.val(minNumber);
				Mobile_NS.Form.showMsg($("#" + formid), multiLJson['383814']+"("+minNumber+")!", "Form_Msg_Info");//超出最小值范围
			}else if(!isNaN(maxNumber) && fieldVal > maxNumber){
				$field.val(maxNumber);
				Mobile_NS.Form.showMsg($("#" + formid), multiLJson['383815']+"("+maxNumber+")!", "Form_Msg_Info");//超出最大值范围
			}
		}else{
			$field.val("");
		}
	});
	
	$field.bind("blur", function(){
		var oldV = $field.val();
		that.formatValue($field, p, minNumber, maxNumber);
		var newV = $field.val();
		if(oldV != newV){
			Mobile_NS.FInputText.toTriggerByClick(mec_id);
		}
	});
	
	var billid = $("#billid", $form).val();
	if(!billid){
		var defVal = Number($field.val());
		if($field.val() != "" && !isNaN(defVal)){
			if((!isNaN(minNumber) && defVal < minNumber) || (!isNaN(maxNumber) && defVal > maxNumber)){
				Mobile_NS.Form.showMsg($("#" + formid), $field.attr("fieldlabel") + multiLJson['19206']+"("+defVal+")"+multiLJson['383816']+"!", "Form_Msg_Err");//默认值 ()超出范围
				$field.val("").attr("placeholder", multiLJson['383817']);//默认值超出范围
			}
			that.formatValue($field, p, minNumber, maxNumber);//初始化页面时执行，默认值可能不合法
		}
	}
	
}

Mobile_NS.FInputText.toTriggerByClick = function(mec_id){
	var $field = $("#" + mec_id);
	$field.trigger("input");
	$field.trigger("change");
}

Mobile_NS.FInputText.formatValue = function(obj, p, min, max){
	var htmlType = p["htmlType"] || "";
	var precision = p["precision"] || "2";
	
	var val = obj.val();
	if(isNaN(Number(val)) || val == ""){
		//只输入负号和为空串时的处理
		if(!isNaN(min) && min > 0){
			val = min;
		}else if(!isNaN(max) && max < 0){
			val = max;
		}else{
			val = 0;
		}
	}
	if(htmlType == "9" || htmlType == "6"){//将老的数字类型当做浮点数处理
		val = Number(val).toFixed(precision);
	}else if(htmlType == "8"){
		val = Number(val).toFixed(0);
	}
	obj.val(val + "");
}
