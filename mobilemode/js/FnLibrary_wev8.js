var FnLibraryConfig = {
	mode : 0	//0 设计   1运行
};

if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.SQL = function(sqlstr, datasource, callbackFn){
	sqlstr = encodeURIComponent(sqlstr);
	if(!datasource){
		datasource = "";
	}
	var asyncFlag = false;
	if(typeof(callbackFn) == "function"){
		asyncFlag = true;
	}
	var result = "";
	$.ajax({
	 	type: "POST",
	 	contentType: "application/json",
	 	url: "/weaver/com.weaver.formmodel.mobile.jscode.servlet.JSCodeAction?action=runSQL&sql="+sqlstr+"&datasource="+datasource,
	 	data: "{}",
	 	async: asyncFlag,
	 	success: function(responseText, textStatus) 
	 	{
	 		var data = $.parseJSON(responseText);
	 		var status = data["status"];
	 		if(status != "-1"){	//server端没有出现未知异常
	 			result = data["result"];
	 		}
	 		if(typeof(callbackFn) == "function"){
	 			callbackFn.call(this, result);
	 		}
	 	},
	    error: function(){
	    	//alert("error");
	    }
	});
	return result;
};

Mobile_NS.toMapPage = function(appHomepageId, addressKey, addressValue){
	openDetail("/mobilemode/appHomepageView.jsp?appHomepageId="+appHomepageId+"&"+addressKey+"="+encodeURI(addressValue));
};

Mobile_NS.progressBar = function(id, config){
	var $obj = $("#" + id);
	if($obj.length == 0){
		return;
	}
	var v = $obj.html();
	v = $.trim(v);
	
	if(v == ""){
		v = 0;
	}else if(isNaN(v)){
		return;
	}
	
	var $csProgressBar = $("<div class=\"csProgressBar\"></div>");
	$csProgressBar.html("<div style=\"width:"+v+"%;\"><span>"+v+"%</span></div>");
	
	var color = "";
	
	var defaultConfig = {"0-40":"#da532c", "41-70":"#e3a21a", "71-100":"#99b433"};
	if(config){
		defaultConfig = config;
	}
	
	for(var key in defaultConfig){
		var keyArr = key.split("-");
		if(keyArr.length == 2 && !isNaN(keyArr[0]) && !isNaN(keyArr[1])){
			if(v >= keyArr[0] && v <= keyArr[1]){
				color = defaultConfig[key];
				break;
			}
		}
	}
	if(color != ""){
		$csProgressBar.children("div").css("background-color", color);	
	}
	
	$obj.html("");
	$obj.append($csProgressBar);
};

Mobile_NS.createTopfloorPage = function(pageIdOrUrl, param){
	top.createTopfloorPage(pageIdOrUrl, param);
};

Mobile_NS.closeTopfloorPage = function(callbackFn){
	top.closeTopfloorPage(callbackFn);
};

Mobile_NS.backTopfloorPage = function(){
	top.backTopfloorPage();
};

Mobile_NS.refresh = function(){
	if(top && typeof(top.refreshCurrPage) == "function"){
		top.refreshCurrPage();
	}else{
		location.reload();
	}
};

Mobile_NS.backToHomepage = function(){
	if(top && typeof(top.backToHomepage) == "function"){
		top.backToHomepage();
	}
};
