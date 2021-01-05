if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Html = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = {};
	}
	this.mecJson = mecJson;
}

/*获取id。 必需的方法*/
MEC_NS.Html.prototype.getID = function(){
	return this.id;
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Html.prototype.getDesignHtml = function(){
	var theId = this.id;
	var htm = this.getHtm();
	if(htm == ""){
		htm = "<div class=\"Design_Html_Empty\">"+SystemEnv.getHtmlNoteName(4181)+"</div>";  //您尚未输入任何Html文本
	}else{
		var regExp = new RegExp("<script[^>]*>[\\d\\D]*?</script>", "gi");
        htm = htm.replace(regExp, "");
	}
	htm = "<div class=\"Design_Html_Container\">"+htm+"</div>"
	return htm;
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Html.prototype.getAttrDlgHtml = function(){
	var theId = this.id;
	
	var htm = "<div id=\"MADH_"+theId+"\">"
	htm += "<div class=\"MADH_Title\">HTML</div>";
	htm += "<div class=\"MADH_Content\"><textarea id=\"htm_"+theId+"\" class=\"MADH_Htm\"></textarea></div>";
	htm += "<div class=\"MADH_Bottom\"><div class=\"MADH_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div></div>";  //确定
	htm += "</div>";
	
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Html.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var $attrContainer = $("#MADH_" + theId);
	
	var $htm = $("#htm_"+theId);
	
	$htm[0].value = this.getHtm();
	
	$htm.focus(function(){
		$(this).addClass("MADH_Htm_Focus");
	});
	$htm.blur(function(){
		$(this).removeClass("MADH_Htm_Focus");
	});
	
	var htmHeight = parseInt($("#draggable_center").css("max-height")) - 100;
	$(".MADH_Htm", $attrContainer).css("height", htmHeight);
};

/*获取JSON*/
MEC_NS.Html.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADH_"+theId);
	if($attrContainer.length > 0){
		this.mecJson["htm"] = $("#htm_"+theId).val();
	}
	return this.mecJson;
};

MEC_NS.Html.prototype.getHtm = function(){
	return Mec_FiexdUndefinedVal(this.mecJson["htm"]);
};