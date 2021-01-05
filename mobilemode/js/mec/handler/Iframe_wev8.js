if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Iframe = function(type, id, mecJson){
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
MEC_NS.Iframe.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Iframe.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	var iframe_path = this.mecJson["iframe_path"];
	var width = $("#content_editor").width();
	if(parseFloat(this.mecJson["width"]) > 0){
		width = this.mecJson["width"];
	}
	var height = $("#content_editor").height();
	if(parseFloat(this.mecJson["height"]) > 0){
		height = this.mecJson["height"];
	}
	
	htmTemplate = htmTemplate.replace(/\${theId}/g, theId)
								.replace(/\${width}/g, width)
								.replace(/\${height}/g, height)
								.replace("${iframe_path}", iframe_path);
	return htmTemplate;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Iframe.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Iframe.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADIframe_"+theId+"\">";
	htm += "<div class=\"MADIframe_Title\">"+SystemEnv.getHtmlNoteName(4495)+"</div>";  //Iframe信息
	htm += "<div class=\"MADIframe_Content\">"
			+ "<div class=\"MADIframe_BaseInfo_Entry\">"	
				+ "<span class=\"MADIframe_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4255)+"</span>"  //来源：
				+ "<div class=\"MADIframe_BaseInfo_Entry_Content\" style=\"display: inline-block;width: 234px;padding-right: 16px;\">"
					+ "<input id=\"iframe_path_"+theId+"\" type=\"text\" class=\"MADIframe_Text\" style=\"padding-right: 16px;\"/>"
				+ "</div>"
			+ "</div>"
			
			+ "<div class=\"MADIframe_BaseInfo_Entry\">"	
				+"<span class=\"MADIframe_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4191)+"</span>"  //宽度：
				+"<input class=\"MADIframe_Text\" id=\"width_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4491)+"\"/>"  //如：344，此处缺省则为页面宽度
			+ "</div>"
			
			+ "<div class=\"MADIframe_BaseInfo_Entry\">"	
				+"<span class=\"MADIframe_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4128)+"</span>"  //高度：
				+"<input class=\"MADIframe_Text\" id=\"height_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4496)+"\"/>"  //如：617，此处缺省则为页面高度
			+ "</div>"
	htm += "</div>";		
	htm += "<div class=\"MADIframe_Bottom\"><div class=\"MADIframe_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Iframe.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var iframe_path = this.mecJson["iframe_path"];
	$("#iframe_path_"+theId).val(iframe_path);
	
	$("#width_"+theId).val(this.mecJson["width"]);
	$("#height_"+theId).val(this.mecJson["height"]);
};

/*获取JSON*/
MEC_NS.Iframe.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADIframe_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["iframe_path"] = $("#iframe_path_"+theId).val();
		this.mecJson["width"] = $("#width_"+theId).val();
		this.mecJson["height"] = $("#height_"+theId).val();
	}
	
	return this.mecJson;
};

MEC_NS.Iframe.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["iframe_path"] = "";
	defMecJson["width"] = "";
	defMecJson["height"] = "";
	
	return defMecJson;
};
