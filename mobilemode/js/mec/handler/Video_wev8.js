if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Video = function(type, id, mecJson){
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
MEC_NS.Video.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Video.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	var video_path = this.mecJson["video_path"];
	var width = $("#videoContainer"+theId).width();
	if(parseFloat(this.mecJson["width"]) > 0){
		width = this.mecJson["width"];
	}
	
	htmTemplate = htmTemplate.replace(/\${theId}/g, theId)
								.replace("${width}", width)
								.replace("${video_path}", video_path);
	return htmTemplate;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Video.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	var autoplay = this.mecJson["autoplay"];
	if(autoplay == "1"){
		$("#video"+theId).attr("autoplay", "autoplay");
	}
	
	var loop = this.mecJson["loop"];
	if(loop == "1"){
		$("#video"+theId).attr("loop", "loop");
	}
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Video.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADVideo_"+theId+"\">";
	htm += "<div class=\"MADVideo_Title\">"+SystemEnv.getHtmlNoteName(4490)+"</div>";  //视频信息
	htm += "<div class=\"MADVideo_Content\">"
			+ "<div class=\"MADVideo_BaseInfo_Entry\">"	
				+ "<span class=\"MADVideo_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4255)+"</span>"  //来源：
				+ "<div class=\"MADVideo_BaseInfo_Entry_Content\" style=\"display: inline-block;width: 234px;padding-right: 16px;\">"
					+ "<input id=\"video_path_"+theId+"\" type=\"text\" class=\"MADVideo_Text\" style=\"padding-right: 16px;\"/>"
					+ "<div class=\"fileUploadDiv\" onclick=\"fileUploadSet('"+theId+"');\">"
						+ "<div class=\"addTransverse\"></div>"
						+ "<div class=\"addVertical\"></div>"
					+ "</div>"
				+ "</div>"
			+ "</div>"
			
			+ "<div class=\"MADVideo_BaseInfo_Entry\">"	
				+"<span class=\"MADVideo_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4191)+"</span>"  //宽度：
				+"<input class=\"MADVideo_Text\" id=\"width_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4606)+"\"/>"  //如：344，此处缺省则为页面宽度
			+ "</div>"
			
			+"<div class=\"MADVideo_BaseInfo_Entry\">"
				+"<span class=\"MADVideo_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4492)+"</span>"  //自动播放：
				+"<input type=\"checkbox\" id=\"autoplay_"+theId+"\"/>"
			+"</div>"
			
			+"<div class=\"MADVideo_BaseInfo_Entry\">"
				+"<span class=\"MADVideo_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4493)+"</span>"  //循环播放：
				+"<input type=\"checkbox\" id=\"loop_"+theId+"\"/>"
			+"</div>";
	htm += "</div>";		
	htm += "<div class=\"MADVideo_Bottom\"><div class=\"MADVideo_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Video.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var video_path = this.mecJson["video_path"];
	$("#video_path_"+theId).val(video_path);
	
	$("#width_"+theId).val(this.mecJson["width"]);
	
	var autoplay = this.mecJson["autoplay"];
	if(autoplay == "1"){
		$("#autoplay_"+theId).attr("checked","checked");
	}
	
	var loop = this.mecJson["loop"];
	if(loop == "1"){
		$("#loop_"+theId).attr("checked","checked");
	}
	
	$("#MADVideo_"+theId).jNice();
};

/*获取JSON*/
MEC_NS.Video.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADVideo_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["video_path"] = $("#video_path_"+theId).val();
		this.mecJson["width"] = $("#width_"+theId).val();
		this.mecJson["autoplay"] = $("#autoplay_"+theId).is(':checked') ? "1" : "0";
		this.mecJson["loop"] = $("#loop_"+theId).is(':checked') ? "1" : "0";
	}
	
	return this.mecJson;
};

MEC_NS.Video.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["video_path"] = "";
	defMecJson["width"] = "";
	defMecJson["autoplay"] = "0";
	defMecJson["loop"] = "0";
	
	return defMecJson;
};

function fileUploadSet(theId){
	var url = "/mobilemode/fileUpload.jsp";
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 350;//定义长度
	dlg.Height = 145;
	dlg.normalDialog = false;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4494);  //文件上传
	dlg.show();
	dlg.hookFn = function(result){
		var filePath = result["file_path"];
		$("#video_path_"+theId).val(filePath);
	};
}
