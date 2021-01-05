Mobile_NS.formFieldRepeatVerify = function(formid, successFn, failFn){
	var $form = $("#"+formid);
	eval("var repeatVerifyFieldInfo = window.repeatVerifyFieldInfo_" + formid + ";");
	var fieldInfoArr = [];
	for(var i = 0; repeatVerifyFieldInfo && i < repeatVerifyFieldInfo.length; i++){
		var verifyField = repeatVerifyFieldInfo[i];
		verifyField["checkStatus"] = "true";
		var fieldInfo = verifyField["fieldInfo"];
		var fieldname = fieldInfo["fieldname"];
		var v = $f(fieldname).val();
		verifyField["val"] = v;
		if(v){	//此处值判断一来是判断防止程序出现未期值，更重要的目的是过滤掉如果改变为空值的情况将不参与唯一性验证
			fieldInfoArr.push({"fieldid":fieldInfo["id"], "fieldname":fieldInfo["fieldname"], "fieldhtmltype":fieldInfo["fieldhtmltype"], "type":fieldInfo["type"], "changedValue":v});
		}					
	}
	
	if(fieldInfoArr.length > 0){
		var jsonstr = JSON.stringify(fieldInfoArr);
		var dataId = $("input[type='hidden'][name='billid']", $form).val();
		var tablename = $("input[type='hidden'][name='tablename']", $form).val();
		var paramData = {"data":encodeURI(jsonstr), "tablename":tablename, "dataId":dataId};
		Mobile_NS.ajax("/mobilemode/formComponentAction.jsp?action=verifyFieldDataRepeat", paramData, function(responseText){
			var result = $.parseJSON(responseText);
			var isSuccess = true;
			var tipHtml = "";
			for(var i = 0; result && i < result.length; i++){
	    		var fieldname = result[i]["fieldname"];
	    		var dcount = result[i]["dcount"];
	    		if(dcount > 0){
	    			isSuccess = false;
	    			var wevF = $f(fieldname);
	    			tipHtml += "【"+wevF.$Obj.attr("fieldlabel")+"：\""+wevF.val()+"\"】,";
	    		}
	    	}
			if(isSuccess){
				successFn.call(window);
			}else{
				tipHtml = tipHtml.substring(0, tipHtml.length-1);
				tipHtml = "您录入的" + tipHtml + "已存在，违反了唯一性验证，请重新录入";
				Mobile_NS.formMsg($form, tipHtml, "Form_Msg_Err");
				failFn.call(window);
			}
		});
	}else{
		successFn.call(window);
	}
};