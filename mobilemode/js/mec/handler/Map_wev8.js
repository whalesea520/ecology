if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Map = function(type, id, mecJson){
	this.type = type;
	if(!id){
		id = new UUID().toString();
	}
	this.id = id;
	if(!mecJson){
		mecJson = this.getDefaultMecJson();
	}
	this.mecJson = mecJson;
	this.b_map = null;
}

/*获取id。 必需的方法*/
MEC_NS.Map.prototype.getID = function(){
	return this.id;
};

MEC_NS.Map.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Map.prototype.getDesignHtml = function(){
	var theId = this.id;
	var height = this.mecJson["height"];
	var htm = "<div id=\"mapContainer_"+theId+"\" style=\"height:"+height+"px;\"></div>";
	return htm;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Map.prototype.afterDesignHtmlBuild = function(){
	this.buildMap();
};

MEC_NS.Map.prototype.getBMapObj = function(){
	if(!this.b_map){
		var theId = this.id;
		this.b_map = new BMap.Map("mapContainer_" + theId);
	}
	return this.b_map;
};

MEC_NS.Map.prototype.buildMap = function(){
	var theId = this.id;
	var b_map = new BMap.Map("mapContainer_" + theId);
	b_map.clearOverlays();    //清除地图上所有覆盖物
	var zoomLevel = Mec_FiexdUndefinedVal(this.mecJson["zoomLevel"], 18);
    var local = new BMap.LocalSearch(b_map, { //智能搜索
      onSearchComplete: function(){
        	var pp = local.getResults().getPoi(0).point;    //获取第一个智能搜索的结果
        	b_map.centerAndZoom(pp, zoomLevel);
        	b_map.addOverlay(new BMap.Marker(pp));    //添加标注
    	}
    });
    local.search(this.mecJson["address"]);
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Map.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;

	var tip = ""
	if(_userLanguage=="8"){
		tip = "Note: if you fill in the name of the parameter, the page will get the value from the set parameter name when loading the map. If the parameter name is empty or the value obtained from the parameter name is empty, the contents of the above \"address\" column are used as the display address of the map.";
	}else if(_userLanguage=="9"){
		tip = "注：如填寫了參數名稱，則頁面在加載地圖時将從設置的參數名稱中獲取值作爲地圖的顯示地址。如果參數名稱爲空或者從參數名稱中獲取到的值爲空，則将使用上面\"地址\"欄中填寫的内容作爲地圖的顯示地址。";
	}else{
		tip = "注：如填写了参数名称，则页面在加载地图时将从设置的参数名称中获取值作为地图的显示地址。如果参数名称为空或者从参数名称中获取到的值为空，则将使用上面\"地址\"栏中填写的内容作为地图的显示地址。";
	}
	var theId = this.id;
	var htm = "<div id=\"MADM_"+theId+"\" style=\"padding-bottom: 10px;\">"
					+ "<div class=\"MADM_Title\">"+SystemEnv.getHtmlNoteName(4210)+"</div>"  //地图信息
					+ "<div class=\"MADM_BaseInfo\">"
						+ "<div>"
							+ "<span class=\"MADM_BaseInfo_Label MADM_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4211)+"</span>"  //参数名称：
							+ "<input class=\"MADM_Text\" id=\"paramName_"+theId+"\" type=\"text\" value=\""+Mec_FiexdUndefinedVal(this.mecJson["paramName"])+"\"/>"
						+ "</div>"
						+ "<div>"
							+ "<span class=\"MADM_BaseInfo_Label MADM_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4212)+"</span>"  //地址：
							+ "<input class=\"MADM_Text\" id=\"address_"+theId+"\" type=\"text\" placeholder=\""+this.mecJson["address"]+"\"/>"
						+ "</div>"
						+ "<div>"
							+ "<span class=\"MADM_BaseInfo_Label MADM_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4213)+"</span>"  //地图高度：
							+ "<input class=\"MADM_Text\" id=\"height_"+theId+"\" type=\"text\"  value=\""+this.mecJson["height"]+"\"/>"
						+ "</div>"
						+ "<div>"
							+ "<span class=\"MADM_BaseInfo_Label MADM_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4214)+"</span>"  //比例尺：
							+ "<select style=\"width:280px;text-indent:7px;\" id=\"zoomLevel_"+theId+"\">"
								+ "<option value=\"18\">50m</option>"
								+ "<option value=\"17\">100m</option>"
								+ "<option value=\"16\">200m</option>"
								+ "<option value=\"15\">500m</option>"
								+ "<option value=\"14\">1km</option>"
								+ "<option value=\"13\">2km</option>"
								+ "<option value=\"12\">5km</option>"
								+ "<option value=\"11\">10km</option>"
								+ "<option value=\"10\">20km</option>"
								+ "<option value=\"9\">25km</option>"
								+ "<option value=\"8\">50km</option>"
								+ "<option value=\"7\">100km</option>"
								+ "<option value=\"6\">200km</option>"
								+ "<option value=\"5\">500km</option>"
								+ "<option value=\"4\">1000km</option>"
								+ "<option value=\"3\">2000km</option>"
							+ "</select>"
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADM_Bottom\">"
    					+ "<div class=\"MADM_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>"  //确定
    				+ "</div>"
    				+ "<div class=\"MADM_Tip\">"+tip+"</div>"  //注：如填写了参数名称，则页面在加载地图时将从设置的参数名称中获取值作为地图的显示地址。如果参数名称为空或者从参数名称中获取到的值为空，则将使用上面\"地址\"栏中填写的内容作为地图的显示地址。
			+ "</div>";
			
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Map.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var ac = new BMap.Autocomplete({    //建立一个自动完成的对象
	    "input" : "address_" + theId
	    ,"location" : this.getBMapObj()
	});
	
	/*使用placeholder规避不能赋值的情况*/
	var address = this.mecJson["address"];
	setTimeout(function(){
		$("#address_" + theId).val(address);
	},100);
	
	var zoomLevel = Mec_FiexdUndefinedVal(this.mecJson["zoomLevel"], 18);
	$("#zoomLevel_" + theId).val(zoomLevel);
};

/*获取JSON*/
MEC_NS.Map.prototype.getMecJson = function(){
	var theId = this.id;
	
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADM_"+theId);
	if($attrContainer.length > 0){
		var height = $("#height_" + theId).val();
		if($.trim(height) == ""){
			height = "200";
		}
		this.mecJson["height"] = height;
		
		var $address = $("#address_" + theId);
		var address = $address.val();
		if($.trim(address) == ""){
			address = $address.attr("placeholder");
		}
		this.mecJson["address"] = address;
		
		this.mecJson["paramName"] = $("#paramName_" + theId).val();
		
		this.mecJson["zoomLevel"] = $("#zoomLevel_" + theId).val();
	}
	
	return this.mecJson;
};

MEC_NS.Map.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["height"] = "200";
	defMecJson["address"] = "上海市浦东新区泛微网络科技有限公司";
	defMecJson["paramName"] = "";
	
	return defMecJson;
};
/*
function MADM_RefreshMap(mec_id){
	var mecHandler = MECHandlerPool.getHandler(mec_id);
	mecHandler.getMecJson();	//获取Json，可以刷新插件内部的JSON数据
	
	$("#mapContainer_" + mec_id).css("height", mecHandler.mecJson["height"] + "px");
	
	mecHandler.buildMap();
	
	var $MAD_Alert = $("#MAD_"+mec_id+" .MAD_Alert");
	$MAD_Alert.css("top", $("#draggable_center").scrollTop() + "px");
	$MAD_Alert.fadeIn(1000, function(){
		$(this).fadeOut(2000);
	});
}*/