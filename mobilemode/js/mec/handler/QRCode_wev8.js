if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.QRCode = function(type, id, mecJson){
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
MEC_NS.QRCode.prototype.getID = function(){
	return this.id;
};

MEC_NS.QRCode.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.QRCode.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	var htm = htmTemplate.replace("${theId}", theId);
	return htm;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.QRCode.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
	
	var p = this.mecJson;
	p["id"] = theId;
	
	Mobile_NS.initQRCode(p);
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.QRCode.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADQR_"+theId+"\">"
	htm += "<div class=\"MADQR__Title\">"+SystemEnv.getHtmlNoteName(4312)+"</div>";  //二维码信息
	htm += "<div class=\"MADQR_Content\">"
		   	+ "<div style=\"margin-top: 10px;\">"
		   		+ "<textarea id=\"content_"+theId+"\" class=\"MADQR_TextArea\" placeholder=\""+SystemEnv.getHtmlNoteName(4314)+"\"></textarea>"  //在此处键入二维码的内容，此内容可以是任意字符串
		   	+ "</div>"
		   	+ "<div>"
		   		+ "<span style=\"margin-left: 2px;\">"+SystemEnv.getHtmlNoteName(4954)+"</span>" //显示宽高：
		   		+ "<span>"
			   		+ "<input type=\"text\" id=\"width_"+theId+"\" class=\"MADQR_Text\"/>"
			   		+ "<span style=\"margin:0px 3px;\">-</span>"
			   		+ "<input type=\"text\" id=\"height_"+theId+"\" class=\"MADQR_Text\"/>"
		   		+ "</span>"
		   	+ "</div>"
			+ "<div class=\"row\">"
		   		+ "<span>"+SystemEnv.getHtmlNoteName(4955)+"</span>"  //logo图片：
		   		+ "<span style=\"position: relative;display: inline-block;\">"
			   		+ "<input type=\"text\" id=\"logo_"+theId+"\" class=\"MADQR_Text\" style=\"width: 280px;padding-right:54px;box-sizing: border-box;\"/>"
			   		+ "<div onclick=\"MADQRCode_PicSet('"+theId+"');\" style=\"background-color: #0066b1;color: #fff;height: 22px;line-height: 22px;position: absolute;right: 2px;top: 2px;padding: 0px 10px;cursor: pointer;border-radius: 3px;\">上传</div>"
		   		+ "</span>"
		   	+ "</div>"
		   	+ "<div>"
		   		+ "<span>"+SystemEnv.getHtmlNoteName(4956)+"</span>"  //显示宽高：
		   		+ "<span>"
			   		+ "<input type=\"text\" id=\"logoWidth_"+theId+"\" class=\"MADQR_Text\"/>"
			   		+ "<span style=\"margin:0px 3px;\">-</span>"
			   		+ "<input type=\"text\" id=\"logoHeight_"+theId+"\" class=\"MADQR_Text\"/>"
		   		+ "</span>"
		   	+ "</div>"
		 + "</div>";
	htm += "<div class=\"MADQR_Bottom\"><div class=\"MADQR_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.QRCode.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	
	var width = this.mecJson["width"];
	var height = this.mecJson["height"];
	var content = this.mecJson["content"];
	var logo = this.mecJson["logo"];
	var logoWidth = this.mecJson["logoWidth"];
	var logoHeight = this.mecJson["logoHeight"];
	
	$("#width_"+theId).val(width);
	$("#height_"+theId).val(height);
	$("#content_"+theId)[0].value = content;
	$("#logo_"+theId).val(logo);
	$("#logoWidth_"+theId).val(logoWidth);
	$("#logoHeight_"+theId).val(logoHeight);
};

/*获取JSON*/
MEC_NS.QRCode.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MAD_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["width"] = $("#width_"+theId).val();
		this.mecJson["height"] = $("#height_"+theId).val();
		this.mecJson["content"] = $("#content_"+theId).val();
		this.mecJson["logo"] = $("#logo_"+theId).val();
		this.mecJson["logoWidth"] = $("#logoWidth_"+theId).val();
		this.mecJson["logoHeight"] = $("#logoHeight_"+theId).val();
	}
	return this.mecJson;
};

MEC_NS.QRCode.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["content"] = "";
	defMecJson["width"] = "256";
	defMecJson["height"] = "256";
	defMecJson["logoWidth"] = "32";
	defMecJson["logoHeight"] = "32";
	
	return defMecJson;
};

function MADQRCode_PicSet(mec_id){
	var pic_pathV = $("#logo_"+mec_id).val();
	pic_pathV = encodeURIComponent(pic_pathV);
	var url = "/mobilemode/picset.jsp?&pic_path="+pic_pathV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 425;//定义长度
	dlg.Height = 371;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4117);  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		$("#logo_"+mec_id).val(picPath);
	};
};