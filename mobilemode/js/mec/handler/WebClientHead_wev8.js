if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.WebClientHead = function(type, id, mecJson){
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
MEC_NS.WebClientHead.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.WebClientHead.prototype.getDesignHtml = function(){
	var htmTemplate = getPluginContentTemplateById(this.type);
	var leftBtnName = this.mecJson["leftBtnName"];
	var middleBtnName = this.mecJson["middleBtnName"];
	if(middleBtnName==""){
		middleBtnName = appName;
	}
	var rightBtnName = this.mecJson["rightBtnName"];
	var htm = htmTemplate.replace("${leftBtnName}", leftBtnName)
						.replace("${middleBtnName}", middleBtnName)
						.replace("${rightBtnName}", rightBtnName);
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.WebClientHead.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADWebClientHead_"+theId+"\">"
				+ "<div class=\"MADWebClientHead_Title\">"
					+ "<span class=\"leftBtnFlag chosed\" typeV=\"Left\">"+SystemEnv.getHtmlNoteName(4338)+"</span><span class=\"middleBtnFlag\" typeV=\"Middle\">"+SystemEnv.getHtmlNoteName(3534)+"</span><span class=\"rightBrnFlag\" typeV=\"Right\">"+SystemEnv.getHtmlNoteName(4339)+"</span>"  //左侧按钮  标题  右侧按钮
				+ "</div>";
	htm +=  "<div class=\"MADWebClientHead_BaseInfo\">"
					+ "<div class=\"MADWebClientHead_BaseInfo_Left\"\">"
							+ "<div class=\"MADWebClientHead_BaseInfo_Entry\">"
								+ "<span class=\"MADWebClientHead_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4318)+"</span>"  //按钮名称：
								+ "<span class=\"MADWebClientHead_BaseInfo_Entry_Content\"><input type=\"text\" class=\"MADWebClientHead_Text\" id=\"leftBtnName_"+theId+"\"/></span>"
							+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADWebClientHead_BaseInfo_Middle\" style=\"display: none;\">"
							+ "<div class=\"MADWebClientHead_BaseInfo_Entry\">"
								+ "<span class=\"MADWebClientHead_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4340)+"</span>"  //标题名称：
								+ "<span class=\"MADWebClientHead_BaseInfo_Entry_Content\"><input type=\"text\" class=\"MADWebClientHead_Text\" id=\"middleBtnName_"+theId+"\"/></span>"
							+ "</div>"
					+ "</div>"
			
					+ "<div class=\"MADWebClientHead_BaseInfo_Right\" style=\"display: none;\">"
							+ "<div class=\"MADWebClientHead_BaseInfo_Entry\">"
								+ "<span class=\"MADWebClientHead_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4318)+"</span>"  //按钮名称：
								+ "<span class=\"MADWebClientHead_BaseInfo_Entry_Content\"><input type=\"text\" class=\"MADWebClientHead_Text\" id=\"rightBtnName_"+theId+"\"/></span>"
							+ "</div>"
							
							+ "<div class=\"MADWebClientHead_BaseInfo_Entry\">"
								+ "<span class=\"MADWebClientHead_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4278)+"</span>"  //执行操作：
								+ "<span class=\"MADWebClientHead_BaseInfo_Entry_Content\">"
									+ "<span class=\"cbboxEntry\" style=\"width: 83px;\">"
										+ "<input type=\"checkbox\" name=\"rightActionType_"+theId+"\" onclick=\"MADWebClientHead_ChangeRAT(this, '"+theId+"');\"/><span class=\"cbboxLabel\">"+SystemEnv.getHtmlNoteName(4341)+"</span>"  //手动输入JS
									+ "</span>"
								+ "</span>"
							+ "</div>"
							
							+ "<div class=\"rightActionContent actionContent\" id=\"rightActionContent_"+theId+"\" style=\"display: none;\">"
								+ "<textarea id=\"rightAction_JS_"+theId+"\" class=\"MADWebClientHead_Textarea\" placeholder=\""+SystemEnv.getHtmlNoteName(4342)+"\"></textarea>"  //请在此处输入JS, 此JS会在按钮点击时执行...
							+ "</div>"
					+ "</div>"
	
	   + "</div>";
	htm += "<div class=\"MADWebClientHead_Bottom\"><div class=\"MADWebClientHead_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.WebClientHead.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var leftBtnName = this.mecJson["leftBtnName"];
	$("#leftBtnName_"+theId).val(leftBtnName);
	
	var middleBtnName = this.mecJson["middleBtnName"];
	$("#middleBtnName_"+theId).val(middleBtnName);
	
	var rightBtnName = this.mecJson["rightBtnName"];
	$("#rightBtnName_"+theId).val(rightBtnName);
	
	var rightAction_JS = this.mecJson["rightAction_JS"];
	$("#rightAction_JS_"+theId).val(rightAction_JS);
	
	var rightActionType = this.mecJson["rightActionType"];
	if(rightActionType == "1"){
		$("input[type='checkbox'][name='rightActionType_"+theId+"']").attr("checked","checked");
		$("#rightActionContent_"+theId).show();
	}
	
	MADWebClientHead_BindEvent(theId);
	
	$("#MADWebClientHead_"+theId).jNice();
};

/*获取JSON*/
MEC_NS.WebClientHead.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADWebClientHead_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["leftBtnName"] = $("#leftBtnName_"+theId).val();
		
		this.mecJson["middleBtnName"] = $("#middleBtnName_"+theId).val();
		
		this.mecJson["rightBtnName"] = $("#rightBtnName_"+theId).val();
		this.mecJson["rightActionType"] = $("input[type='checkbox'][name='rightActionType_"+theId+"']").is(':checked') ? "1" : "0";
		this.mecJson["rightAction_JS"] = $("#rightAction_JS_"+theId).val();
	}
	
	return this.mecJson;
};

MEC_NS.WebClientHead.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["leftBtnName"] = SystemEnv.getHtmlNoteName(4343);  //返回
	
	defMecJson["middleBtnName"] = "";
	
	defMecJson["rightBtnName"] = SystemEnv.getHtmlNoteName(3888);  //更多
	defMecJson["rightActionType"] = "1";
	defMecJson["rightAction_JS"] = "";
	
	return defMecJson;
};

function MADWebClientHead_BindEvent(mec_id){
	//根据顶部区域区分当前操作的是左侧按钮还是右侧按钮
	$("#MADWebClientHead_"+mec_id+" > .MADWebClientHead_Title > span").click(function(){
		if(!$(this).hasClass("chosed")){
			$("#MADWebClientHead_"+mec_id+" > .MADWebClientHead_Title > span").removeClass("chosed");
			$(this).addClass("chosed");
			var typeV = $(this).attr("typeV");
			$("#MADWebClientHead_"+mec_id+" > .MADWebClientHead_BaseInfo > div").hide();
			$("#MADWebClientHead_"+mec_id+" > .MADWebClientHead_BaseInfo > div.MADWebClientHead_BaseInfo_" + typeV).show();
		}
	});
	
	//JS输入框绑定获取/失去 焦点时的事件
	var $MADWebClientHead_Textarea = $("#MADWebClientHead_"+mec_id+" .MADWebClientHead_Textarea");
	$MADWebClientHead_Textarea.focus(function(){
		$(this).addClass("MADWebClientHead_Textarea_Focus");
	});
	$MADWebClientHead_Textarea.blur(function(){
		$(this).removeClass("MADWebClientHead_Textarea_Focus");
	});
}

function MADWebClientHead_ChangeRAT(cbObj, mec_id){
	setTimeout(function(){	//checkbox用了插件，不延时checkbox的checked状态获取不准确
		if(!cbObj.checked){
			$("#rightActionContent_" + mec_id).hide();
		}else{
			$("#rightActionContent_" + mec_id).show();
		}
	},100);
}