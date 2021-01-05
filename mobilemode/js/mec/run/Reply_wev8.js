var reply_mecid;
var reply_callbackFn;

Mobile_NS.replyInit = function(mecid){// 初始化
	reply_mecid = mecid;
	
	$("#replyBtn"+mecid).click(function(e){
		var $form = $("#replyForm"+mecid);
		var isSubmit = $form.attr("isSubmit");
		if(isSubmit == "0"){// 未提交
			$form.attr("isSubmit", "1");
			var url = $form.attr("action");
			var isAuto = $form.attr("isAuto");
			if(isAuto == "0"){
				url = jionActionUrl("com.weaver.formmodel.mobile.mec.servlet.MECAction", "action=saveReplyData");
			}
			var data = $form.serialize();
			Mobile_NS.ajax(url,data,function(res) {
		    	if(res.status==1){
		    		var callbackFn = reply_callbackFn;
		    		if(callbackFn && typeof(callbackFn) == "function"){
		    			callbackFn.call(this);
		    		}
		    		$form[0].reset();
		    	}else{
		    		if(res.errMsg){
		    			alert(res.errMsg);
		    		}else{
		    			alert("保存异常");
		    		}
		    	}
		    	$form.attr("isSubmit", "0");
		    },"json");
		}
		e.stopPropagation();
	});
	
	var $divContainer = $("#replyDivContainer"+mecid);
	$("#scroll_footer").append($divContainer);
	
	var isDefault = $divContainer.attr("isDefault");
	if(isDefault == "1"){// 默认显示
		$("#scroll_footer").show();
		$("#scroll_wrapper").css("bottom", $("#scroll_footer").height() + "px");
		refreshIScroll();
	}
}

Mobile_NS.replyPageHide = function(){// 插件隐藏
	$("#scroll_footer").hide();
	$("#scroll_wrapper").css("bottom", "0px");
	refreshIScroll();
}

Mobile_NS.replyPageShow = function(callbackFn, jsonObj){// 插件显示
	reply_callbackFn = callbackFn;
	if(jsonObj) Mobile_NS.replyDataSet(jsonObj);
	
	$("#scroll_footer").show();
	$("#scroll_wrapper").css("bottom", $("#scroll_footer").height() + "px");
	refreshIScroll();
	
}

Mobile_NS.replyDataSet = function(jsonObj){// 设置隐藏域数值
	var $form = $("#replyForm"+reply_mecid);
	for(var key in jsonObj){
		var value = jsonObj[key];
		$input = $("input[paramkey="+key+"]", $form);
		if($input.length > 0){
			$input[0].value = value;
		}
	}
}
