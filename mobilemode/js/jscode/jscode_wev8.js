$(function() {
	initMobileJSCode();
});

function initMobileJSCode(){
	var $JSCode_Container = $("#JSCode_Container");
	if($JSCode_Container.length == 0){
		return;
	}
	
	var htm = $JSCode_Container.html();
	var currMec_id = "";
	var beginIndex = 0;
	var theStart;
	while((theStart = htm.indexOf("#jscode{", beginIndex)) != -1){
		var theEnd = htm.indexOf("}#",theStart);
		if(theEnd != -1){
			var jscodeInitHtm = htm.substring(theStart, theEnd + "}#".length);
			var jscodeInitContentHtm = htm.substring(theStart + "#jscode{".length, theEnd);
			
			var javacodeInitJson = $.parseJSON("{"+jscodeInitContentHtm+"}");
			
			var codeid = javacodeInitJson["id"];
			
			var codeConfig = getCodeConfigByCodeid(codeid);
			
			var codeHtml;
			if(codeConfig == null){
				codeHtml = "";
			}else{
				codeHtml = getCodeHtmlByConfig(codeConfig);
			}
			
			htm = htm.replace(jscodeInitHtm, codeHtml);
			
			$JSCode_Container.html(htm);
			
		}else{
			break;
		}
	}
	
	if(currMec_id != ""){
		triggerMECDesign(currMec_id);
	}
}

function getCodeHtmlByConfig(codeConfig){
	var codeid = codeConfig["id"];
	return "<div codeid=\""+codeid+"\" jscode=\"true\" class=\"jscode_entry\">"+codeConfig["text"]+"<span class=\"jscode_del\" onclick=\"deleteMobileJSCode('"+codeid+"')\"></span></div>";
}

function writeMobileJSCode(codeid){
	var codeConfig = getCodeConfigByCodeid(codeid);
	var type = codeConfig["type"];
	if(type == "1"){	//功能性函数
		var dlg = top.createTopDialog();//获取Dialog对象
		dlg.Model = true;
		dlg.Width = 600;//定义长度
		dlg.Height = 600;
		dlg.URL = "/mobilemode/jscodedesc.jsp?codeid="+codeid;
		dlg.Title = "脚本说明";
		dlg.show();
		return;
	}
	
	var $JSCode_Container = $("#JSCode_Container");
	if($JSCode_Container.length == 0){
		$JSCode_Container = $("<div id=\"JSCode_Container\"></div>");
		$("#homepageContainer").append($JSCode_Container);
	}
	
	var $jscode_entry = $(".jscode_entry[codeid='"+codeid+"']", $JSCode_Container);
	if($jscode_entry.length == 0){
		var codeHtml = getCodeHtmlByConfig(codeConfig);
		$jscode_entry = $(codeHtml);
		$JSCode_Container.append($jscode_entry);
		triggerEditorScroll();
		$JSCode_Container[0].scrollIntoView();
		
		//添加page中的jscode_items
		jscode_items.push(codeConfig);
		//添加选项中的脚本项
		$("#draggable_center select[isJSCodeSel='true']").each(function(){
			$(this).append("<option value='"+codeid+"'>"+codeConfig["text"]+"</option>");  
		});
	}else{
		top.Dialog.alert("该脚本已存在当前布局中，请勿重复添加");
	}
	
}

function deleteMobileJSCode(codeid){
	var $jscode_entry = $("#JSCode_Container .jscode_entry[codeid='"+codeid+"']");
	$jscode_entry.remove();
	
	if($("#JSCode_Container").children().length == 0){
		triggerEditorScroll();
	}
	
	//删除page中的jscode_items
	var removeIndex = -1;
	for(var i = 0; i < jscode_items.length; i++){
		if(jscode_items[i]["id"] == codeid){
			removeIndex = i;
			break;
		}
	}
	if(removeIndex != -1){
		jscode_items.splice(removeIndex, 1);
	}
	
	//删除选项中的脚本项
	$("#draggable_center select[isJSCodeSel='true']").each(function(){
		$("option[value='"+codeid+"']", $(this)).remove();   
	});
}

function getCodeConfigByCodeid(codeid){
	for(var i = 0; i < JSCodeConfigArr.length; i++){
		var codeConfig = JSCodeConfigArr[i];
		if(codeConfig["id"] == codeid){
			return codeConfig;
		}
	}
	return null;
}

function getJSCodeOptionHtml(){
	var htm = "<option value=\"\"></option>";
	for(var i = 0; i < jscode_items.length; i++){
		var id = jscode_items[i]["id"];
		var text = jscode_items[i]["text"];
		htm += "<option value=\""+id+"\">"+text+"</option>";
	}
	return htm;
}
