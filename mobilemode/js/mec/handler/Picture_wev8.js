if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Picture = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = this.getDefaultMecJson();
	}
	this.mecJson = mecJson;
};

/*获取id。 必需的方法*/
MEC_NS.Picture.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Picture.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	var pic_path = this.mecJson["pic_path"];
	if($.trim(pic_path) == ""){
		pic_path = this.getEmptyPicPath();
	}
	var width = $("#Picture"+theId).width();
	if(parseFloat(this.mecJson["width"]) > 0){
		width = this.mecJson["width"];
	}
	var height = 150;
	if(parseFloat(this.mecJson["height"]) > 0){
		height = this.mecJson["height"];
	}
	var pictureSize = this.mecJson["picturesize"];
	if("2" == pictureSize){
		width = "";
		height = "";
	}
	htmTemplate = htmTemplate.replace("${theId}", theId).replace("${width}", width).replace("${height}", height)
				 .replace("${action}", "").replace("${pic_path}", pic_path);
	
	return htmTemplate;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Picture.prototype.afterDesignHtmlBuild = function(){
	var theId = this.id;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Picture.prototype.getAttrDlgHtml = function(){

	var theId = this.id;
	
	var htm = "<div id=\"MADPture_"+theId+"\">";
	htm += "<div class=\"MADPture_Title\">"+SystemEnv.getHtmlNoteName(4473)+"</div>";  //图片信息
	htm += "<div class=\"MADPture_Content\">"
			+ "<div class=\"MADPture_BaseInfo_Entry\">"	
				+ "<div class=\"MADPture_Item\" style=\"float:left;\">"
					+ "<div class=\"MADPture_Item_Img\" onclick=\"MADPicture_PicSet('"+theId+"');\">"
						+ "<img id=\"pic_img_"+theId+"\" style=\"display: none;\"/>"
						+ "<input type=\"hidden\" id=\"pic_type_"+theId+"\"/>"
						+ "<input type=\"hidden\" id=\"pic_path_"+theId+"\"/>"
						+ "<div id=\"pic_addbtn_"+theId+"\" class=\"MADPture_Item_Addbtn\"></div>"
					+ "</div>"
				+ "</div>"
				+ "<div class=\"MADPture_BaseInfo_Entry\">"
					+ "<span class=\"MADPture_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4474)+"</span>"  //尺寸：
					+ "<span class=\"MADCdar_BaseInfo_Entry_Content\">"
						+ "<select id=\"picturesize_"+theId+"\" class=\"MADS_Select\" style=\"width: 75px;\" onchange=\"MADPicture_SizeChange('"+theId+"');\">"
							+ "<option value=\"1\">"+SystemEnv.getHtmlNoteName(4475)+"</option>"  //指定大小
							+ "<option value=\"2\">"+SystemEnv.getHtmlNoteName(4476)+"</option>"  //原图大小
						+ "</select>"
					+ "</span>"
				+ "</div>"
				+ "<div id=\"pictureSizeAttr_"+theId+"\">"
					+ "<div class=\"MADPture_BaseInfo_Entry\" style=\"float:left;\">"	
						+ "<span class=\"MADPture_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4191)+"</span>"  //宽度：
						+ "<input class=\"MADPture_Text\" id=\"width_"+theId+"\" type=\"text\" placeholder=\""+SystemEnv.getHtmlNoteName(4477)+"\"/>"  //如：450，此处缺省则为页面宽度
					+ "</div>"
				
					+ "<div class=\"MADPture_BaseInfo_Entry\">"	
						+ "<span class=\"MADPture_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4128)+"</span>"  //高度：
						+ "<input class=\"MADPture_Text\" id=\"height_"+theId+"\" type=\"text\"/>"
					+ "</div>"
				+ "</div>"
				+ "<div class=\"MADPture_BaseInfo_Entry\">"	
					+ "<span class=\"MADPture_BaseInfo_Entry_Label\">"+SystemEnv.getHtmlNoteName(4478)+"</span>"  //链接：
						+ "<div class=\"sbHolder\" style=\"display: inline-block; width: 170px;height: 24px !important;border: 1px solid #dfdfdf\"><a href=\"javascript:void(0);\" onclick=\"javascript:selectnav(this,'0','"+theId+"');\" class=\"sbToggle sbToggle-btc\" style=\"right: 3px;top: 3px;\"></a>"
						+ "<input id=\"uiview_0_"+theId+"\" style=\"border: 0px none rgb(255, 255, 255); width: 166px !important; height: 18px; font-size: 12px; text-indent: 7px;padding-left: 4px;padding-top: 3px;padding-bottom: 3px\" autocomplete=\"off\" onclick=\"javascript:nav_stopEventClink(this,'0','"+theId+"');\">"
						+ "<input id=\"ui_0_"+theId+"\" type=\"hidden\" />"
						+ "<input id=\"source_0_"+theId+"\" type=\"hidden\" />"
						+ "<input id=\"custom_0_"+theId+"\" type=\"hidden\"/>"
						+ "<input id=\"jscode_0_"+theId+"\" type=\"hidden\"/>"
						+ "</div>"
					+ "</span>"
				+ "</div>"
			+ "</div>";
	htm += "</div>";		
	htm += "<div class=\"MADPture_Bottom\"><div class=\"MADPture_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Picture.prototype.afterAttrDlgBuild = function(){

	var theId = this.id;
	
	var pic_type = this.mecJson["pic_type"];
	var pic_path = this.mecJson["pic_path"];
	$("#pic_type_"+theId).val(pic_type);
	$("#pic_path_"+theId).val(pic_path);
	MADPicture_SetPicPath(theId, pic_path);
	var picturesize = Mec_FiexdUndefinedVal(this.mecJson["picturesize"]);
	$("#picturesize_"+theId).val(picturesize);
	MADPicture_SizeChange(theId);
	$("#width_"+theId).val(this.mecJson["width"]);
	$("#height_"+theId).val(this.mecJson["height"]);
	
	var source = this.mecJson["source"];
	var uiid = this.mecJson["uiid"];
	var custom = this.mecJson["custom"];
	$("#source_0_"+theId).val(source);
	if(source==1){
		$("#uiview_0_"+theId).val(getCommonNavNameByUid(uiid));
	}else if(source==2){
		$("#uiview_0_"+theId).val(custom);
	}else if(source==3){
		$("#uiview_0_"+theId).val("脚本");
	}
	$("#ui_0_"+theId).val(uiid);
	$("#custom_0_"+theId).val(custom);
	$("#jscode_0_"+theId).val(this.mecJson["jscode"]);
	 
	MADPicture_SourceChange(theId);
	nav_uiviewBind(0,theId);
};

/*获取JSON*/
MEC_NS.Picture.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADPture_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["pic_type"] = $("#pic_type_"+theId).val();	//0本地图片  1网址获取
		this.mecJson["pic_path"] = $("#pic_path_"+theId).val();
		this.mecJson["picturesize"] = $("#picturesize_"+theId).val();
		this.mecJson["width"] = $("#width_"+theId).val();
		this.mecJson["height"] = $("#height_"+theId).val();
		this.mecJson["source"] = $("#source_0_"+theId).val();	//1系统组件  2自定义
		this.mecJson["uiid"] = $("#ui_0_"+theId).val();
		this.mecJson["custom"] = $("#custom_0_"+theId).val();
		this.mecJson["jscode"] = $("#jscode_0_"+theId).val();
	}
	
	return this.mecJson;
};

MEC_NS.Picture.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["pic_type"] = "0";	//0本地图片  1网址获取
	defMecJson["pic_path"] = "";
	defMecJson["picturesize"] = "1";
	defMecJson["width"] = "450";
	defMecJson["height"] = "150";
	
	defMecJson["source"] = "1";	//1系统组件  2自定义
	defMecJson["uiid"] = "";
	defMecJson["custom"] = "";
	defMecJson["jscode"] = "";
	
	return defMecJson;
};

MEC_NS.Picture.prototype.getEmptyPicPath = function(){
	return "/mobilemode/images/mec/pic-icon_wev8.png";
};

function MADPicture_PicSet(theId){
	var pic_typeV = $("#pic_type_"+theId).val();
	var pic_pathV = $("#pic_path_"+theId).val();
	pic_pathV = encodeURIComponent(pic_pathV);
	
	var url = "/mobilemode/picset.jsp?pic_type="+pic_typeV+"&pic_path="+pic_pathV;
	
	var dlg = top.createTopDialog();//获取Dialog对象
	dlg.Model = true;
	dlg.Width = 331;//定义长度
	dlg.Height = 431;
	dlg.URL = url;
	dlg.Title = SystemEnv.getHtmlNoteName(4117);  //添加图片
	dlg.show();
	dlg.hookFn = function(result){
		var picPath = result["pic_path"];
		$("#pic_type_"+theId).val(result["pic_type"]);
		$("#pic_path_"+theId).val(picPath);
		
		MADPicture_SetPicPath(theId, picPath);
	};
}

function MADPicture_SetPicPath(theId, picPath){
	var $picAddbtn = $("#pic_addbtn_"+theId);
	var $picImg = $("#pic_img_"+theId);
	if(picPath && picPath != ""){
		$picAddbtn.hide();
		$picImg.show();
		$picImg[0].src = picPath;
	}else{
		$picImg.hide();
		$picAddbtn.show();
	}
}

function MADPicture_SizeChange(mec_id){
	var pictureSizeV = $("#picturesize_"+mec_id).val();
	if(pictureSizeV == "1"){
		$("#pictureSizeAttr_"+mec_id).show();
	}else{
		$("#pictureSizeAttr_"+mec_id).hide();
	}
}

function MADPicture_SourceChange(mec_id){
	var sourceV = $("#source_0_"+mec_id).val();
	var $ui = $("#ui_0_"+mec_id);
	var $custom = $("#custom_0_"+mec_id);
	var $jscode = $("#jscode_0_"+mec_id);
	if(sourceV == "1"){
		$custom.hide();
		$jscode.hide();
		$ui.show();
	}else if(sourceV == "2"){
		$ui.hide();
		$jscode.hide();
		$custom.show();
	}else if(sourceV == "3"){
		$custom.hide();
		$ui.hide();
		$jscode.show();
	}
}

function MADPicture_getUISelectOptionHtml(){
	var htm = "<option value=\"\"></option>";
	for(var i = 0; i < common_mec_nav_items.length; i++){
		var uiid = common_mec_nav_items[i]["uiid"];
		var uiname = common_mec_nav_items[i]["uiname"];
		htm += "<option value=\""+uiid+"\">"+uiname+"</option>";
	}
	return htm;
}