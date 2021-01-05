if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Slide = function(type, id, mecJson){
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
MEC_NS.Slide.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Slide.prototype.getDesignHtml = function(){
	var theId = this.id;
	
	var htmTemplate = getPluginContentTemplateById(this.type);
	
	var height = this.mecJson["height"];
	//height = 159;	//设计时高度固定为159
	htmTemplate = htmTemplate.replace("${theId}", theId)
							.replace("${height}", height);
	
	var pic_items;
	var slideBtnType = this.mecJson["slideBtnType"];
	if(slideBtnType == "R"){// 从url获取
		pic_items = this.getDefaultMecJson()["pic_items"];
	}else{
		pic_items = this.mecJson["pic_items"];
	}
	
	var forStart;
	while((forStart = htmTemplate.indexOf("$mec_forstart$")) != -1){
		var forEnd = htmTemplate.indexOf("$mec_forend$", forStart);
		var forTemplate = "";
		var forContentTemplate = "";
		if(forEnd != -1){
			forTemplate = htmTemplate.substring(forStart, forEnd + "$mec_forend$".length);
			forContentTemplate = htmTemplate.substring(forStart + "$mec_forstart$".length, forEnd);
			
			var forHtml = "";
			for(var i = 0; i < pic_items.length; i++){
				var pic_path = pic_items[i]["pic_path"];
				var pic_desc = pic_items[i]["pic_desc"];
				
				if($.trim(pic_path) == ""){
					pic_path = this.getEmptyPicPath();
					if($.trim(pic_desc) == ""){
						pic_desc = SystemEnv.getHtmlNoteName(4118); //默认幻灯片图片
					}
				}
				var pointClass = (i == 0) ? "currPoint" : "";
				var action = "";
				pic_path = "src=\"" + pic_path + "\"";
				forHtml += forContentTemplate.replace("${action}", action)
									.replace("${pic_path}", pic_path)
									.replace("${pic_desc}", pic_desc)
									.replace("${pointClass}", pointClass);
			}
			htmTemplate = htmTemplate.replace(forTemplate, forHtml);
		}else{
			break;
		}
	}
	
	
	var htm = htmTemplate;
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Slide.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADS_Silde_"+theId+"\">"
				+ "<div class=\"MADS_Title\">"
					+ "<span class=\"leftBtnSpan\" id=\"leftBtn_"+theId+"\">"+SystemEnv.getHtmlNoteName(4119)+"</span>"  //手动设置
					+ "<span class=\"rightBtnSpan\" id=\"rightBtn_"+theId+"\">"+SystemEnv.getHtmlNoteName(4120)+"</span>"  //从URL获取
				+ "</div>"
				+ "<div class=\"MADS_Silde_Container\" id=\"leftContainer_"+theId+"\">";
	
	var pic_items = this.mecJson["pic_items"];
	for(var i = 0; i < pic_items.length; i++){
		htm += MADS_CreateRow(i, theId);
	}
	
	htm += 
		" </div>"
		
		+ "<div class=\"MADS_Silde_URLContainer\" id=\"rightContainer_"+theId+"\">"
			+"<div class=\"MADS_Silde_URLBorder\">"
				+ "<div class=\"MADS_BaseUrlInfo\">"
					+ SystemEnv.getHtmlNoteName(4123) + "<input type=\"text\" id=\"slideUrl_"+theId+"\" class=\"MADS_Text\" style=\"width: 80%;\"/>"  //来源URL：
				+ "</div>"
				+ "<div class=\"MADS_BaseUrlInfo\">"
					+ "<div><span style=\"font-weight:bolder;\">"+SystemEnv.getHtmlNoteName(4121)+"</span>"+SystemEnv.getHtmlNoteName(4122)+"</div>"  //注：     返回数据类型为json数组
					+ "<div class=\"MADS_InfoText\"><span >"+SystemEnv.getHtmlNoteName(4124)+" &nbsp;&nbsp;--&nbsp;&nbsp; </span>action</div>"  //图片链接对应的key
					+ "<div class=\"MADS_InfoText\"><span >"+SystemEnv.getHtmlNoteName(4124)+" &nbsp;&nbsp;--&nbsp;&nbsp; </span>pic_path</div>"  //图片链接对应的key 
					+ "<div class=\"MADS_InfoText\"><span >"+SystemEnv.getHtmlNoteName(4124)+" &nbsp;&nbsp;--&nbsp;&nbsp; </span>pic_desc</div>"+  //图片链接对应的key
					 		"<span style=\"font-weight:bolder;\">"+SystemEnv.getHtmlNoteName(4125)+"</span>" +  //示例：
							"<div class=\"MADS_InfoText\">[{\"action\":\"/mobilemode/demo.jsp\",</div>" +
							"<div class=\"MADS_InfoText\">\"pic_path\":\"/mobilemode/demo.png\",</div>" +
							"<div class=\"MADS_InfoText\">\"pic_desc\":\""+SystemEnv.getHtmlNoteName(4126)+"1\"}]</div>"  //图例
				+"</div>"
			+ "</div>"
		+"</div>"				
		+ "<div id=\"MADS_Silde_Add\">"
			+ "<span class=\"MADS_Silde_Addbtn\" onclick=\"MADS_AddRow('"+theId+"');\">"+SystemEnv.getHtmlNoteName(4117)+"</span>" //添加图片
		+ "</div>"
		
		+ "<div class=\"MADS_Title\">"+SystemEnv.getHtmlNoteName(4127)+"</div>"  //基础信息设置
		+ "<div class=\"MADS_BaseInfo\">"
			+ SystemEnv.getHtmlNoteName(4128) + "<input type=\"text\" id=\"height_"+theId+"\" class=\"MADS_Text\" style=\"width: 123px;\"/>"  //高度：
		+ "</div>"
		+ "<div class=\"MADS_BaseInfo\">"
		+ SystemEnv.getHtmlNoteName(4129) + "<input type=\"checkbox\" id=\"lazyLoad_"+theId+"\" style=\"vertical-align:middle;\"/>"  //延迟加载：
		+ "</div>"
		+ "<div class=\"MADS_Title\">"+SystemEnv.getHtmlNoteName(4133)+"</div>"  //轮播设置
		+ "<div class=\"MADS_BaseInfo\">"
			+ "<select id=\"auto_"+theId+"\" class=\"MADS_Select\" style=\"width: 68px;\">"
				+ "<option value=\"0\">"+SystemEnv.getHtmlNoteName(4134)+"</option>"  //不轮播
				+ "<option value=\"3\">3"+SystemEnv.getHtmlNoteName(4135)+"</option>"  //秒
				+ "<option value=\"5\">5"+SystemEnv.getHtmlNoteName(4135)+"</option>"  //秒
				+ "<option value=\"7\">7"+SystemEnv.getHtmlNoteName(4135)+"</option>"  //秒
				+ "<option value=\"9\">9"+SystemEnv.getHtmlNoteName(4135)+"</option>"  //秒
			+ "</select>"
			+ "<span class=\"desc\">"+SystemEnv.getHtmlNoteName(4136)+"</span>"  //后自动播放下一张图片
		+ "</div>"
		
		+ "<div class=\"MADS_Bottom\"><div class=\"MADS_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>"  //确定
	+ "</div>"
	+ "<div class=\"NoLessSide MAD_Warn\">"+SystemEnv.getHtmlNoteName(4137)+"</div>";  //幻灯片图片数不得少于1张
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Slide.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;

	var height = this.mecJson["height"];	//高度
	var auto = this.mecJson["auto"];	//轮播秒数
	var slideUrl = this.mecJson["slideUrl"];	// 来源url
	$("#height_"+theId).val(height);
	$("#auto_"+theId).val(auto);
	$("#slideUrl_"+theId).val(slideUrl);
	
	var lazyLoad = Mec_FiexdUndefinedVal(this.mecJson["lazyLoad"] , "0");
	if(lazyLoad == "1"){
		$("#lazyLoad_"+theId).attr("checked","checked");
	}
	
	var slideBtnType = this.mecJson["slideBtnType"];
	if(slideBtnType == "R"){
		$("#rightBtn_"+theId).addClass("checked");
		$("#rightContainer_"+theId).show();
		$("#MADS_Silde_Add").hide();
	}else{
		$("#leftBtn_"+theId).addClass("checked");
		$("#leftContainer_"+theId).show();
	}
	$("#leftBtn_"+theId).click(function(){
		$(this).addClass("checked");
		$("#rightBtn_"+theId).removeClass("checked");
		$("#leftContainer_"+theId).show();   
		$("#MADS_Silde_Add").show();
		$("#rightContainer_"+theId).hide();
	});
	$("#rightBtn_"+theId).click(function(){
		$(this).addClass("checked");
		$("#leftBtn_"+theId).removeClass("checked");
		$("#rightContainer_"+theId).show();    
		$("#leftContainer_"+theId).hide();  
		$("#MADS_Silde_Add").hide();
	});
		
	var pic_items = this.mecJson["pic_items"];
	
	for(var i = 0; i < pic_items.length; i++){
		var p_item = pic_items[i];
		var pic_type = p_item["pic_type"];	//0本地图片  1网址获取
		var pic_path = p_item["pic_path"];
		var pic_desc = p_item["pic_desc"];
		var source = p_item["source"];	//1系统组件  2自定义
		var uiid = p_item["uiid"];
		var custom = p_item["custom"];
		var jscode = p_item["jscode"];
	
		$("#pic_type_"+i+"_"+theId).val(pic_type);
		$("#pic_path_"+i+"_"+theId).val(pic_path);
		$("#pic_desc_"+i+"_"+theId).val(pic_desc);
		$("#source_"+i+"_"+theId).val(source);
		$("#ui_"+i+"_"+theId).val(uiid);
		if(source==1){
			$("#uiview_"+i+"_"+theId).val(getCommonNavNameByUid(uiid));
		}else if(source==2){
			$("#uiview_"+i+"_"+theId).val(custom);
		}else if(source==3){
			$("#uiview_"+i+"_"+theId).val("脚本");
		}
		$("#custom_"+i+"_"+theId).val(custom);
		$("#jscode_"+i+"_"+theId).val(jscode);
		
		MADS_SetPicPath(i, theId, pic_path);
		
		nav_uiviewBind(i,theId);
	}
	
	MADS_TriggerTable(theId);
	
	$("#MADS_Silde_"+theId + " .MADS_Silde_Container").sortable({
		revert: false,
		axis: "y",
		items: ".MADS_Silde_Item",
		cursor: "move"
	});
	
	MLanguage({
		container: $("#MADS_Silde_"+theId + " .MADS_Silde_Container")
    });
};

/*获取JSON*/
MEC_NS.Slide.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADS_Silde_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["height"] = $("#height_"+theId).val();	//高度
		this.mecJson["auto"] = $("#auto_"+theId).val();	//轮播秒数
		this.mecJson["slideUrl"] = $("#slideUrl_"+theId).val();	// 来源URL
		this.mecJson["lazyLoad"] = $("#lazyLoad_"+theId).is(':checked') ? "1" : "0";// 延迟加载
		
		if($("#leftBtn_"+theId).hasClass("checked")){
			this.mecJson["slideBtnType"] = "L";
		}else{
			this.mecJson["slideBtnType"] = "R";
		}
		
		var pic_items = [];
		$("#MADS_Silde_"+theId + " .MADS_Silde_Container .MADS_Silde_Item").each(function(i){
			var rowIndex = $(this).attr("rowIndex");
			var p_item = {};
			p_item["pic_type"] = $("#pic_type_"+rowIndex+"_"+theId).val();	//0本地图片  1网址获取
			p_item["pic_path"] = $("#pic_path_"+rowIndex+"_"+theId).val();
			var pdesc = $("#pic_desc_"+rowIndex+"_"+theId).val();
			var pclone = MLanguage.getValue($("#pic_desc_"+rowIndex+"_"+theId));
			p_item["pic_desc"] = pclone == undefined ? pdesc : pclone;
			p_item["source"] = $("#source_"+rowIndex+"_"+theId).val();	//1系统组件  2自定义
			p_item["uiid"] = $("#ui_"+rowIndex+"_"+theId).val();
			p_item["custom"] = $("#custom_"+rowIndex+"_"+theId).val();
			p_item["jscode"] = $("#jscode_"+rowIndex+"_"+theId).val();
			pic_items.push(p_item);
		});
		this.mecJson["pic_items"] = pic_items;
	}
	
	return this.mecJson;
};

MEC_NS.Slide.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["height"] = 200;	//高度
	defMecJson["auto"] = 0;	//轮播秒数
	defMecJson["slideBtnType"] = "L";	
	
	var pic_items = [];
	
	var p_item = {};
	p_item["pic_type"] = "0";	//0本地图片  1网址获取
	p_item["pic_path"] = "";
	p_item["pic_desc"] = "";
	p_item["source"] = "1";	//1系统组件  2自定义
	p_item["uiid"] = "";
	p_item["custom"] = "";
	p_item["jscode"] = "";
	pic_items.push(p_item);
	
	defMecJson["pic_items"] = pic_items;
	
	return defMecJson;
};

MEC_NS.Slide.prototype.getEmptyPicPath = function(){
	return "/mobilemode/images/mec/pic-icon_wev8.png";
};


function MADS_PicSet(rowIndex, mec_id){
	var pic_typeV = $("#pic_type_"+rowIndex+"_"+mec_id).val();
	var pic_pathV = $("#pic_path_"+rowIndex+"_"+mec_id).val();
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
		$("#pic_type_"+rowIndex+"_"+mec_id).val(result["pic_type"]);
		$("#pic_path_"+rowIndex+"_"+mec_id).val(picPath);
		
		MADS_SetPicPath(rowIndex, mec_id, picPath);
	};
};

function MADS_SetPicPath(rowIndex, mec_id, picPath){
	var $picAddbtn = $("#pic_addbtn_"+rowIndex+"_"+mec_id);
	var $picImg = $("#pic_img_"+rowIndex+"_"+mec_id);
	if(picPath && picPath != ""){
		$picAddbtn.hide();
		$picImg.show();
		$picImg[0].src = picPath;
	}else{
		$picImg.hide();
		$picAddbtn.show();
	}
}

function MADS_TriggerTable(mec_id){
	$("#MADS_Silde_"+mec_id + " .MADS_Silde_Container .MADS_Silde_Item").each(function(i){
		var rowIndex = $(this).attr("rowIndex");
		MADS_TriggerTableRow(rowIndex, mec_id);
	});
}

function MADS_TriggerTableRow(rowIndex, mec_id){
	MADS_SourceChange(rowIndex, mec_id);
}

function MADS_SourceChange(rowIndex, mec_id){
	var sourceV = $("#source_"+rowIndex+"_"+mec_id).val();
	var $ui = $("#ui_"+rowIndex+"_"+mec_id);
	var $custom = $("#custom_"+rowIndex+"_"+mec_id);
	var $jscode = $("#jscode_"+rowIndex+"_"+mec_id);
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

function MADS_DelRow(rowIndex, mec_id){
	var $MADS_Silde_Container = $("#MADS_Silde_"+mec_id + " .MADS_Silde_Container");
	if($(".MADS_Silde_Item", $MADS_Silde_Container).length <= 1){
		$("#MAD_"+mec_id+" .NoLessSide").fadeIn(1000, function(){
			$(this).fadeOut(2000);
		});
		return;
	}
	$(".MADS_Silde_Item[rowIndex='"+rowIndex+"']",$MADS_Silde_Container).remove();
}

function MADS_AddRow(mec_id){
	var maxRowIndex = 0;
	$("#MADS_Silde_"+mec_id + " .MADS_Silde_Container .MADS_Silde_Item").each(function(i){
		var rowIndex = parseInt($(this).attr("rowIndex"));
		if(rowIndex > maxRowIndex){
			maxRowIndex = rowIndex;
		}
	});
	
	var currRowIndex = maxRowIndex + 1;
	
	var htm = MADS_CreateRow(currRowIndex, mec_id);
	
	var $newRow = $(htm);
	
	$("#MADS_Silde_"+mec_id + " .MADS_Silde_Container").append($newRow);
	
	MADS_TriggerTableRow(currRowIndex, mec_id);
	
	nav_uiviewBind(currRowIndex,mec_id);
	
	MLanguage({
		container: $newRow
    });
}

function MADS_CreateRow(currRowIndex, mec_id){
	var htm = 
		"<div class=\"MADS_Silde_Item\" rowIndex=\""+currRowIndex+"\">"
			+ "<div class=\"MADS_Silde_Item_Img\" onclick=\"MADS_PicSet("+currRowIndex+",'"+mec_id+"');\">"
				+ "<img id=\"pic_img_"+currRowIndex+"_"+mec_id+"\" style=\"display: none;\"/>"
				+ "<input type=\"hidden\" id=\"pic_type_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<input type=\"hidden\" id=\"pic_path_"+currRowIndex+"_"+mec_id+"\"/>"
				+ "<div id=\"pic_addbtn_"+currRowIndex+"_"+mec_id+"\" class=\"MADS_Silde_Item_Addbtn\"></div>"
			+ "</div>"
			
			+ "<div class=\"MADS_Silde_Item_Detail\">"
				+ "<div class=\"MADS_Silde_Item_Detail1\">"
					+ "<input type=\"text\" id=\"pic_desc_"+currRowIndex+"_"+mec_id+"\" class=\"MADS_Text\" placeholder=\""+SystemEnv.getHtmlNoteName(4582)+"\" class=\"textStyle\" data-multi=false/>"  //请输入图片标题 / 描述
				+ "</div>"

				+ "<div class=\"MADS_Silde_Item_Detail2\">"
						+ "<div class=\"sbHolder\" style=\"display: inline-block; width: 204px;height: 24px !important;border: 1px solid #dfdfdf\"><a href=\"javascript:void(0);\" onclick=\"javascript:selectnav(this,"+currRowIndex+",'"+mec_id+"');\" class=\"sbToggle sbToggle-btc\" style=\"right: 3px;top: 3px;\"></a>"
						+ "<input id=\"uiview_"+currRowIndex+"_"+mec_id+"\" style=\"border: 0px none rgb(255, 255, 255); width: 181px !important; height: 18px; font-size: 12px; text-indent: 7px;padding-left: 4px;padding-top: 3px;padding-bottom: 3px\" autocomplete=\"off\" onclick=\"javascript:nav_stopEventClink(this,"+currRowIndex+",'"+mec_id+"');\">"
						+ "<input id=\"ui_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\" />"
						+ "<input id=\"source_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\" />"
						+ "<input id=\"custom_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\"/>"
						+ "<input id=\"jscode_"+currRowIndex+"_"+mec_id+"\" type=\"hidden\"/>"
						+ "</div>"
				+ "</div>"
			+ "</div>"
			
			+ "<div class=\"del_btn\" onclick=\"MADS_DelRow("+currRowIndex+",'"+mec_id+"');\"></div>"
		+ "</div>";
	return htm;
}

function MADS_getUISelectOptionHtml(){
	var htm = "<option value=\"\"></option>";
	for(var i = 0; i < common_mec_nav_items.length; i++){
		var uiid = common_mec_nav_items[i]["uiid"];
		var uiname = common_mec_nav_items[i]["uiname"];
		htm += "<option value=\""+uiid+"\">"+uiname+"</option>";
	}
	return htm;
}
