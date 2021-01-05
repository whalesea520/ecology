if(typeof(MEC_NS) == 'undefined'){
	MEC_NS = {};
}

MEC_NS.Weather = function(type, id, mecJson){
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
MEC_NS.Weather.prototype.getID = function(){
	return this.id;
};

MEC_NS.Weather.prototype.runWhenPageOnLoad = function(){
	this.afterDesignHtmlBuild();
};

/*获取设计的html， 页面上怎么显示控件完全依赖于此方法。 必需的方法*/
MEC_NS.Weather.prototype.getDesignHtml = function(){
	var theId = this.id;
	var height = this.mecJson["height"];
	var city = this.mecJson["city"];
	if($.trim(city) == ""){
		city = $("#city_" + theId).attr("placeholder");
	}
	var htm = "<div class=\"weatherContainer\" id=\"weatherContainer_"+theId+"\" >";
	htm += "<div class=\"top\"> <img  id=\"big_"+theId+"\" src=\"\" alt=\"\"> <p id=\"deg_"+theId+"\" class=\"text deg\"></p><input class=\"text\" type=\"text\" id=\"weathercity_"+theId+"\"  value=\""+city+"\"></div>";
    htm +=" <div class=\"bot\"><ul>";
    for(var i=0;i<4;i++){
    	htm += "<li><h1 id=\"forecast"+i+"_"+theId+"\"></h1><img  id=\"forecastimg"+i+"_"+theId+"\" src=\"/mobilemode/images/weathericon/Sun.png\"></img><p id=\"forecastdeg"+i+"_"+theId+"\"></p></li>";
    }
    htm +="</ul> </div> </div>"; 
	return htm;
};

/*页面上显示控件完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Weather.prototype.afterDesignHtmlBuild = function(){
	this.buildWeather();
};


MEC_NS.Weather.prototype.buildWeather = function(){
	var theId = this.id;
	Mobile_NS.initWeather(theId,"",this.mecJson);
};

/*获取构建属性编辑窗体的html，添加和单击控件后会调用此方法，由此方法去构建属性编辑窗体。 必需的方法*/
MEC_NS.Weather.prototype.getAttrDlgHtml = function(){
	var styleL = "_style" + _userLanguage;
	var tip = "";
	if(_userLanguage=="8"){
		tip = "Note: if you fill in the name of the parameter, the page will be used to obtain the value as the display city of the weather, when the page is loaded. If the parameter name is empty or the value obtained from the parameter name is empty, the contents of the above \"city\" column will be used as a display city.";
	}else if(_userLanguage=="9"){
		tip = "注：如填寫了參數名稱，則頁面在加載時将從設置的參數名稱中獲取值作爲天氣的顯示城市。如果參數名稱爲空或者從參數名稱中獲取到的值爲空，則将使用上面\"城市\"欄中填寫的内容作爲顯示城市。";
	}else{
		tip = "注：如填写了参数名称，则页面在加载时将从设置的参数名称中获取值作为天气的显示城市。如果参数名称为空或者从参数名称中获取到的值为空，则将使用上面\"城市\"栏中填写的内容作为显示城市。";
	}

	
	var theId = this.id;
	var htm = "<div id=\"MADWEA_"+theId+"\" style=\"padding-bottom: 10px;\">"
					+ "<div class=\"MADWEA_Title\">"+SystemEnv.getHtmlNoteName(4446)+"</div>"  //天气信息
					+ "<div class=\"MADWEA_BaseInfo\">"
						+ "<div>"
							+ "<span class=\"MADWEA_BaseInfo_Label MADWEA_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4211)+"</span>"  //参数名称：
							+ "<input class=\"MADWEA_Text\" id=\"paramName_"+theId+"\"  type=\"text\" value=\""+Mec_FiexdUndefinedVal(this.mecJson["paramName"])+"\"/>"
						+ "</div>"
						+ "<div style=\"display:none;\">"
							+ "<span class=\"MADWEA_BaseInfo_Label MADWEA_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4447)+"</span>"  //当前城市：
							+ "<input type=\"checkbox\" id=\"useCurrentCity_"+theId+"\"/>"
						+ "</div>"
						+ "<div>"
							+ "<span class=\"MADWEA_BaseInfo_Label MADWEA_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4448)+"</span>"  //城市：
							+ "<input class=\"MADWEA_Text\" id=\"city_"+theId+"\" type=\"text\" placeholder=\""+this.mecJson["city"]+"\"/>"
						+ "</div>"
						+ "<div style='display:none' >"
							+ "<span class=\"MADWEA_BaseInfo_Label MADWEA_BaseInfo_Label"+styleL+"\">"+SystemEnv.getHtmlNoteName(4128)+"</span>"  //高度：
							+ "<input class=\"MADWEA_Text\" id=\"height_"+theId+"\"  type=\"text\" placeholder=\""+this.mecJson["height"]+"\" />"
						+ "</div>"
					+ "</div>"
					
					+ "<div class=\"MADWEA_Bottom\">"
    					+ "<div class=\"MADWEA_SaveBtn\" onclick=\"refreshMecDesign('"+theId+"');\">"+SystemEnv.getHtmlNoteName(3451)+"</div>"  //确定
    				+ "</div>"
    				+ "<div class=\"MADWEA_Tip\">"+tip+"</div>"  //注：如填写了参数名称，则页面在加载时将从设置的参数名称中获取值作为天气的显示城市。如果参数名称为空或者从参数名称中获取到的值为空，则将使用上面\"城市\"栏中填写的内容作为显示城市。
			+ "</div>";
			
	htm += "<div class=\"MAD_Alert\">"+SystemEnv.getHtmlNoteName(4115)+"</div>";  //已生成到布局
	return htm;
};

/*构建属性编辑窗体完成后调用此方法，主要用于一些必须要使用js对页面进行后置操作时，无需要此方法可至空。 不必需的方法，有此方法系统自动调用*/
MEC_NS.Weather.prototype.afterAttrDlgBuild = function(){
	var theId = this.id;
	var paramName = this.mecJson["paramName"];
	var city = this.mecJson["city"];
	if($.trim(city) == ""){
		city = $("#city_" + theId).attr("placeholder");
	}
	var height = this.mecJson["height"];
	if($.trim(height) == ""){
		height = $("#height_" + theId).attr("placeholder");
	}
	var useCurrentCity = Mec_FiexdUndefinedVal(this.mecJson["useCurrentCity"] , "0");
	$("#city_" + theId).val(city);
	$("#height_" + theId).val(height);
	$("#paramName_" + theId).val(paramName);
	if(useCurrentCity == "1"){
		$("#useCurrentCity_"+theId).attr("checked","checked");
	}
	
	$("#MADWEA_"+theId).jNice();
};

/*获取JSON*/
MEC_NS.Weather.prototype.getMecJson = function(){
	var theId = this.id;
	this.mecJson["id"] = theId;
	this.mecJson["mectype"] = this.type;
	
	var $attrContainer = $("#MADWEA_"+theId);
	if($attrContainer.length > 0){
		var height = $("#height_" + theId).val();
		if($.trim(height) == ""){
			height = "190";
		}
		this.mecJson["height"] = height;
		
		var $city = $("#city_" + theId);
		var city = $city.val();
		if($.trim(city) == ""){
			city = $city.attr("placeholder");
		}
		this.mecJson["city"] = city;
		
		this.mecJson["paramName"] = $("#paramName_" + theId).val();
		this.mecJson["useCurrentCity"] = $("#useCurrentCity_"+theId).is(':checked') ? "1" : "0";
	}
	
	return this.mecJson;
};

MEC_NS.Weather.prototype.getDefaultMecJson = function(){
	var theId = this.id;
	var defMecJson = {};
	
	defMecJson["id"] = theId;
	defMecJson["mectype"] = this.type;
	
	defMecJson["height"] = "190";
	defMecJson["city"] = "上海";
	defMecJson["paramName"] = "";
	defMecJson["useCurrentCity"] = "0";
	
	return defMecJson;
};
