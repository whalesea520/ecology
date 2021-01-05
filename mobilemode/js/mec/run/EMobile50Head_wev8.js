Mobile_NS.resetTitle = function(){
	document.onclick = function() {
		if(top && !top._mobile_title_flag && typeof(top.resetTitle) == "function"){
			$("#menuList").hide();
			top.resetTitle();
		}
	}; 
};

Mobile_NS.addMenuList = function(menu_datas){
	var $attrContainer = $("#scroll_header");
	var $MenuList = $("#menuList",$attrContainer);
	if(!$MenuList.length){
		$MenuList = $("<div id=\"menuList\"  class=\"menuList\"></div>");
		$attrContainer.append($MenuList);
	}
	
	var $tableUl = $(".table-view", $MenuList);
	if(!$tableUl.length){
		$tableUl = $("<ul class=\"table-view\"></ul>");
		$MenuList.append($tableUl);
	}
	for(var i = 0; i < menu_datas.length; i++){
		if($("#menu_"+menu_datas[i]["id"]).length==0){
			var htm = "<li id=\"menu_"+menu_datas[i]["id"]+"\" class=\"menuSpan\" script=\""+encodeURIComponent(menu_datas[i]["menuScript"])+"\">"+menu_datas[i]["menuText"]+"</li>";
			$tableUl.append(htm);
			
			Mobile_NS.onTap($("#menu_"+menu_datas[i]["id"]), function(){
				$("#menuList > li").removeClass("selected");
				$(this).addClass("selected");
				var script = $(this).attr("script");
				if(script && script != ""){
					script = decodeURIComponent(script);
					eval(script);
				}
			});
		}
	}
	
};