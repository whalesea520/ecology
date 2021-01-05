jQuery(document).ready(function($){
	
	var iscreate = $("#iscreate").val();
	if(iscreate == "0"){	//查看界面，查看不需要拦截表单进行数据唯一性校验
		return;
	}
	
	var formId = $("#formid").val();
	var dataId = $("#billid").val();
	
	var promptFieldArr = [];
	
	$.ajax({
		url: "/formmode/setup/formSettingsAction.jsp?action=getPromptField&formId="+formId,
		cache: false,
		success: function(responseText, textStatus){
			promptFieldArr = eval("(" + responseText + ")");
		}
	});
	
	$.aop.around( 
		{
			target: document.frmmain, 
			method: 'submit'
		},
		function(invocation) {
			
			$(".promptValidateFail").removeClass("promptValidateFail");
			var changedFiledInfo = [];
			for(var i = 0; i < promptFieldArr.length; i++){
				var promptField = promptFieldArr[i];
				promptField["checkStatus"] = "true";
				var fieldInfo = promptField["fieldInfo"];
				var fieldElement = getFieldElement(fieldInfo); //获取相应的字段元素
				if(!fieldElement){	//字段在页面中不存在,或者这种字段类型暂时不做唯一性验证
					continue;
				}
				var isChanged = fieldIsChanged(fieldElement);	//判断该元素值是否有被改变过
				if(isChanged){
					var v = getFieldValue(fieldInfo);
					promptField["val"] = v;
					if(v){	//此处值判断一来是判断防止程序出现未期值，更重要的目的是过滤掉如果改变为空值的情况将不参与唯一性验证
						changedFiledInfo.push({"fieldid":fieldInfo["id"], "fieldname":fieldInfo["fieldname"], "changedValue":v});
					}					
				}
			}
			
			if(changedFiledInfo.length > 0){	//有需要唯一性验证的改变数据的字段
				
				rightMenu.style.visibility = "hidden";//验证之前隐藏掉右键菜单
				
				createLoadingTip();
				
				var jsonstr = JSON.stringify(changedFiledInfo);
				var paramData = {"data":encodeURI(jsonstr), "formId":formId, "dataId":dataId};
				$.ajax({
				    url: '/formmode/setup/formSettingsAction.jsp?action=validatePromptFieldData',
				    data: paramData, 
				    dataType: 'json',
				    type: 'POST',
				    success: function (res) {
				    	
				    	dropLoadingTip();
				    	
				    	for(var i = 0; res && i < res.length; i++){
				    		var r_fieldid = res[i]["fieldid"];
				    		var r_dcount = res[i]["dcount"];
				    		if(r_dcount > 0){
				    			//此处统一更改集合中的状态，提示啥的再后面统一做，代码剥离
				    			for(var j = 0; j < promptFieldArr.length; j++){
									var promptField = promptFieldArr[j];
									var fieldInfo = promptField["fieldInfo"];
									var p_fieldid = fieldInfo["id"];
									if(r_fieldid == p_fieldid){
										promptField["checkStatus"] = "false";
										break;
									}
								}
				    		}
				    	}
				    	
				    	//验证加提醒
				    	var isSuccess = true;
				    	var fieldTipHtml = "";
				    	for(var i = 0; i < promptFieldArr.length; i++){
				    		var promptField = promptFieldArr[i];
				    		if(promptField["checkStatus"] == "false"){
				    			isSuccess = false;
				    			
				    			var fieldInfo = promptField["fieldInfo"];
								var fieldElement = getFieldElement(fieldInfo); //获取相应的字段元素
								var $p_td = $(fieldElement).closest("td");
								$p_td.addClass("promptValidateFail");
								
								fieldTipHtml += "【"+fieldInfo["labelName"]+"：\""+promptField["val"]+"\"】,";
				    		}
				    	}
	
				    	if(isSuccess){
				    		invocation.proceed();	//正常提交
				    	}else{	//有字段数据违反了唯一性验证
				    		displayAllmenu();	//右键菜单改为可用
				    		frmmain.subnew.value="0";
				    		var msg = "";
							msg += "<span style='margin-right: 6px;'>"+SystemEnv.getHtmlNoteName(3551,readCookie("languageidweaver"));
							msg += fieldTipHtml.substring(0,fieldTipHtml.length-1);
							msg += SystemEnv.getHtmlNoteName(3552,readCookie("languageidweaver"))+"</span>";
							Dialog.alert(msg,function(){
								if(typeof(setTabButtonUsage)=='function'){
									setTabButtonUsage(false);
								}
							}, 372, 85, false);
				    	}
				    },
				    error: function(){
				    	alert("error");
				    }
				});
			}else{
				invocation.proceed();	//正常提交
			}
		} 
	);
	
	//获取相应的字段元素
	function getFieldElement(fieldInfo){
		var fieldid = fieldInfo["id"];
		var fieldhtmltype = fieldInfo["fieldhtmltype"];
		if(fieldhtmltype == "1"){	//单行文本框
			return document.getElementById("field" + fieldid);
		}else if(fieldhtmltype == "2"){	//多行文本框
			return null;	//暂觉得多行文本框做唯一性校验也没意思，如需要，可修改此处代码
		}else if(fieldhtmltype == "3"){	//浏览按钮
			return document.getElementById("field" + fieldid);
		}else if(fieldhtmltype == "4"){	//Check框
			return null;	//Check框做唯一性验证没有意义，因为只有两个值
		}else if(fieldhtmltype == "5"){	//选择框
			return document.getElementById("field" + fieldid);
		}else if(fieldhtmltype == "6"){	//附件上传
			return null;
		}else if(fieldhtmltype == "7"){	//特殊字段
			return null;
		}
	}
	
	//获取相应的字段元素的值 (可扩展为按照类型增加额外代码进行处理)
	function getFieldValue(fieldInfo){
		var fieldElement = getFieldElement(fieldInfo);
		if(!fieldElement){
			return null;
		}
		return fieldElement.value;
	}
	
	function fieldIsChanged(fieldElement){
		var isChanged = false;
	    var type = fieldElement.type;
	    if (type == "text" || type == "hidden" || type == "textarea" || type == "button")
	    {
	        //if (fieldElement.value != fieldElement.defaultValue)
	        //{
	            isChanged = true;
	        //}
	    }
	    else if (type == "radio" || type == "checkbox")
	    {
	        if (fieldElement.checked != fieldElement.defaultChecked)
	        {
	            isChanged = true;
	        }
	    }
	    else if (type == "select-one")
	    {
	    	var c = false;
	    	var def = 0;
	        for (var j = 0; j < fieldElement.options.length; j++)
	        {
	        	var opt = fieldElement.options[j];
	        	c = c || (opt.selected != opt.defaultSelected);
	        	if (opt.defaultSelected) def = j;
	        }
	        if (c && !fieldElement.multiple) c = (def != fieldElement.selectedIndex);
			if (c){
				isChanged = true;
			}
	    }
	    else
	    {
	        //do otherthing
	    }
		return isChanged;
	}
	
	function createLoadingTip(){
		var $docBody = $(document.body);
		var w = document.body.scrollLeft + document.body.clientWidth/2 - 50;
		var h = document.body.scrollTop + document.body.clientHeight/2 - 50;
		var $loadingTip = $("<div id=\"PromptLoadingTip\" style=\"position: absolute;top: "+h+"px;left: "+w+"px;z-index: 10000;border: 1px solid #e9e9e9; background-color: #fff;padding: 6px 10px 3px 30px; vertical-align:middle; background-image: url('/images/messageimages/loading_wev8.gif');background-repeat: no-repeat;background-position: 10px center;\">数据唯一性验证中，请等待...</div>");
		$docBody.append($loadingTip);
	}
	
	function dropLoadingTip(){
		$("#PromptLoadingTip").remove();
	}
});