Mobile_NS.TabBar = {};

Mobile_NS.TabBar.onload = function(p){
	
	var id = p["id"];
	var tBar = this;
	
	var $container = $("#NMEC_" + id);
	
	$("#scroll_footer").append($("#abbr_"+id)).show();
	$("#scroll_wrapper").css("bottom", $("#scroll_footer").height() + "px");
	
	$(".tab-item", $container).click(function(e){
		var that = this;
		if(!$(that).hasClass("active")){
			$(that).siblings(".tab-item.active").removeClass("active");
			$(that).addClass("active");
			
			if($(that).index() == 0){
				$("#scroll_wrapper .homepageFrame").addClass("hide");
				$("#scroll_scroller").show();
			}else{
				var itemId = $(that).attr("id");
				var data = tBar.getDataById(p, itemId);
				var source_type = data["source_type"];
				var source_value = data["source_value"];
				
				var url = "";
				var isScript = false;
				if(source_type == "1"){
					if(source_value && source_value.indexOf("homepage_") != -1){
						source_value = source_value.substring(9);
					}
					url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + source_value;
				}else if(source_type == "2" || source_type == "3"){
					if(source_value && source_value.indexOf("homepage_") != -1){
						source_value = source_value.substring(9);
						url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + source_value;
					}else{
						url = "/mobilemode/formbaseview.jsp?uiid=" + source_value;
					}
				}else if(source_type == "4"){
					url = source_value;
				}else if(source_type == "5"){
					isScript = true;
				}
				
				if(!isScript){
					$("#scroll_scroller").hide();
					$("#scroll_wrapper .homepageFrame").addClass("hide");
					var $frame = $("#frame_" + itemId);
					if($frame.length == 0){
						$frame = $("<iframe id=\"frame_"+itemId+"\" class=\"homepageFrame blankFrame\" frameborder=\"0\" scrolling=\"auto\"></iframe>");
						$("#scroll_wrapper").append($frame);
						
						var noLogin = $p("noLogin");
						if(noLogin == "1"){
							url += (url.indexOf("?") == -1 ? "?" : "&") + "noLogin=" + noLogin;
						}
						var historyLength = window.history.length;
						$frame[0].src = url;
						$frame[0].onload = function(){
							fixIFrameIOSHistoryBug(historyLength);
							$(this).removeClass("blankFrame");
							
							var _id = this.getAttribute("pageid");
							if(!_id || _id == ""){	//没有id
								var pageIdentifier = null;
								try{ // 捕获可能存在的js跨域访问出现的异常
									pageIdentifier = this.contentWindow.pageIdentifier;
								}catch(e){
									
								}
								if(pageIdentifier){
									var p_type = pageIdentifier["type"];
									var p_id = pageIdentifier["id"];
									if(p_type == 1){
										_id = "appHomepageFrame_" + p_id;
									}
									this.setAttribute("pageid", _id);
								}
							}
						};
					}else{
						$frame.removeClass("hide");
					}
				}else{
					if($.trim(source_value) != ""){
						eval(source_value);
					}
				}
			}
		}
	});
};

Mobile_NS.TabBar.getDataById = function(p, itemId){
	var datas = p["datas"];
	for(var i = 0; i < datas.length; i++){
		var dataid = datas[i]["id"];
		if(dataid == itemId){
			return datas[i]; 
		}
	}
	return null;
};

Mobile_NS.getCurrentWindow = function(){
	var $item = $(".tabBarContainer .tab-item.active");
	if($item.index() == 0){
		return window;
	}else{
		var itemId = $item.attr("id");
		var $frame = $("#frame_" + itemId);
		if($frame.length > 0){
			return $frame[0].contentWindow.Mobile_NS.getCurrentWindow();
		}else{
			return window;
		}
	}
	
};