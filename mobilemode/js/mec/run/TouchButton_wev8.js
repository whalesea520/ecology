Mobile_NS.initTouchButton = function(param){
	var $touchBtn = $("<div id=\"touchBtn\"></div>");
	$(document.body).append($touchBtn);
	
	var group_touch_datas = [];
	var touch_datas = param["touch_datas"];
	for(var i = 0; i < touch_datas.length; i++){
		var tData = touch_datas[i];
		
		var touchPageId;
		var pid = tData["pid"];
		if(!pid || pid == ""){
			touchPageId = "mainTouchPage";
		}else{
			touchPageId = pid;
		}
		
		var _gData = null;
		for(var j = 0; j < group_touch_datas.length; j++){
			var gData = group_touch_datas[j];
			if(gData["touchPageId"] == touchPageId){
				_gData = gData;
				break;
			}
		}
		
		if(!_gData){
			_gData = {};
			_gData["touchPageId"] = touchPageId;
			
			var touchPagePid;
			if(!pid || pid == ""){
				touchPagePid = "";
			}else{
				for(var i2 = 0; i2 < touch_datas.length; i2++){
					if(touch_datas[i2]["id"] == pid){
						touchPagePid = touch_datas[i2]["pid"];
						if(!touchPagePid || touchPagePid == ""){
							touchPagePid = "mainTouchPage";
						}
						break;
					}
				}
			}
			
			_gData["touchPagePid"] = touchPagePid;
			_gData["touchDatas"] = [];
			
			group_touch_datas.push(_gData);
		}
		
		var childNum = 0;
		for(var i3 = 0; i3 < touch_datas.length; i3++){
			if(touch_datas[i3]["pid"] == tData["id"]){
				childNum++;
			}
		}
		tData["childNum"] = childNum;
		
		_gData["touchDatas"].push(tData);
	}
	
	var touchPageHtm = "";
	var touchPageHtmTemplate = 
		"<table id=\"${touchPageId}\" class=\"touchPage\" touch_parent_page_id=\"${touchPagePid}\">"
			+ "<tr>"
				+ "<td colspan=\"3\" align=\"center\" valign=\"bottom\">"
					+ "${touchEntry0}"
				+ "</td>"
			+ "</tr>"
			
			+ "<tr>"
				+ "<td align=\"center\" style=\"padding-left: 8px;\">"
					+ "${touchEntry1}"
				+ "</td>"
				+ "<td align=\"center\" style=\"height:100%;\">"
					+ "${touchBackEntry}"
				+ "</td>"
				+ "<td align=\"center\" style=\"padding-right: 8px;\">"
					+ "${touchEntry2}"
				+ "</td>"
			+ "</tr>"
			
			+ "<tr>"
				+ "<td colspan=\"3\" align=\"center\" valign=\"top\">"
					+ "${touchEntry3}"
				+ "</td>"
			+ "</tr>"
			
		+ "</table>";
	
	for(var i = 0; i < group_touch_datas.length; i++){
		var gData = group_touch_datas[i];
		var touchPageId = gData["touchPageId"];
		var touchPagePid = gData["touchPagePid"];
		var touchDatas = gData["touchDatas"];
		var touchBackEntry;
		if(!touchPagePid || touchPagePid == ""){
			touchBackEntry = "";
		}else{
			touchBackEntry = "<div class=\"touchBackEntry\"></div>";
		}
		var _tHtml = touchPageHtmTemplate.replace("${touchPageId}", touchPageId)
											.replace("${touchPagePid}", touchPagePid)
												.replace("${touchBackEntry}", touchBackEntry);
		
		for(var j = 0; j < touchDatas.length; j++){
			var tData = touchDatas[j];
			var childNum = tData["childNum"];
			var touch_url = "";
			if(childNum == 0){
				var source_type = tData["source_type"];
				var source_value = tData["source_value"];
				if(source_type == "1"){
					if(source_value && source_value.indexOf("homepage_") != -1){
						source_value = source_value.substring(9);
					}
					touch_url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + source_value;
				}else if(source_type == "2" || source_type == "3"){
					if(source_value && source_value.indexOf("homepage_") != -1){
						source_value = source_value.substring(9);
						touch_url = "/mobilemode/appHomepageView.jsp?appHomepageId=" + source_value;
					}else{
						touch_url = "/mobilemode/formbaseview.jsp?uiid=" + source_value;
					}
				}else if(source_type == "4"){
					touch_url = source_value;
				}else if(source_type == "5"){
					touch_url = "mobilemode:callJSCode:" + source_value;
				}
			}
			var touch_child_page_id = childNum > 0 ? tData["id"] : "";
			var touchEntryHtm = "<div class=\"touchEntry\" touch_url=\""+touch_url+"\" touch_child_page_id=\""+touch_child_page_id+"\">";
			touchEntryHtm += "<div class=\"icon\"><img src=\""+tData["picpath"]+"\"/></div>";
			touchEntryHtm += "<div class=\"text\">"+tData["showname"]+"</div>";
			
			var isremind = tData["isremind"];
			if(isremind == "1"){
				var remindtype = tData["remindtype"];
				if(remindtype == "1"){	//sql (java文件暂时不考虑)
					var remindsql = tData["remindsql"] || "" ;
					var reminddatasource = tData["reminddatasource"] || "";
					touchEntryHtm += "<span remindsql=\""+remindsql+"\" reminddatasource=\""+reminddatasource+"\" class=\"MEC_NumberRemind\"></span>";
				}
			}
			
			touchEntryHtm += "</div>";
			_tHtml = _tHtml.replace("${touchEntry"+j+"}", touchEntryHtm);
		}
		
		var reg=new RegExp("\\$\\{touchEntry\\d\\}","gmi"); 

		_tHtml = _tHtml.replace(reg, ""); //替换掉多余的占位符
		
		touchPageHtm += _tHtml;
		//alert(touchPageId + " : " + touchPagePid + " : " + touchDatas.length);
		
	}
	
	var $touchContainer = $("<div id=\"touchContainer\"></div>");
	$touchContainer.html(
			"<table id=\"touchBlockWrap\">"
				+ "<tr>"
					+ "<td class=\"_c\" align=\"center\">"
						+ "<table class=\"touchBlock\" >"
							+ "<tr>"
								+ "<td align=\"center\" style=\"height:100%;\">"
									+ "<div id=\"touchMask\"></div>"
									+ "<div id=\"touchPageWrap\">"
									+ touchPageHtm
									+ "</div>"
								+ "</td>"
							+ "</tr>"
						+ "</table>"
					+ "</td>"
				+ "</tr>"
			+ "</table>"
	);
	$(document.body).append($touchContainer);
	
	var $touchLocker = $("<div id=\"touchLocker\"></div>");
	$(document.body).append($touchLocker);

	Mobile_NS.changeTouchButtonPos();
	
	var timer = null; 
	$("#touchBtn").pep({
		useCSSTranslation: false,
		constrainTo: 'window',
		shouldEase: false,
		//shouldPreventDefault: false,
		/*
		initiate: function(ev, obj){
			if(ev.type == "touchstart"){
				return true;	
			}else{
				return false;
			}
		},*/
		start: function(ev, obj){
			obj.$el[0].style.opacity = "";
			obj.$el.addClass("custom-active");
			if(timer != null){
				clearTimeout(timer);
				timer = null;
			}
		},
		drag: function(ev, obj){
		},
		stop: function(ev, obj){
			var bodyWidth = $(document.body).width();
			var eWidth = obj.$el.outerWidth();
			var lWidth = (bodyWidth - eWidth) / 2;
			
			var moveT = obj.$el.position().top;
			var moveL;
			var l = obj.$el.position().left;
			if(l >= lWidth){
				moveL = (bodyWidth - eWidth);
			}else{
				moveL = 0;
			}
			
			this.moveTo(moveL, moveT, true);
			
			if(_top && typeof(_top.setTouchButtonPos) == "function"){
				_top.setTouchButtonPos(moveL, moveT);
			}
			
			timer = setTimeout(function(){
				obj.$el.animate({opacity: '0.3'}, 800, function(){
					this.style.opacity = "";
					obj.$el.removeClass("custom-active");
					timer = null;
				});
			}, 2000);
		},
		click: function(ev, obj){
			Mobile_NS.showTouchBlock(ev);
		}
	});
	
	var bodyClientHeight;
	if(_top && typeof(_top.getBodyClientHeight) == "function"){
		bodyClientHeight = _top.getBodyClientHeight();
	}else{
		bodyClientHeight = document.body.clientHeight;
	}
	
	var $touchBlockWrap = $("#touchBlockWrap");
	$touchBlockWrap.css("left", "0px");
	$touchBlockWrap.css("top", ((bodyClientHeight - $touchBlockWrap.outerHeight(true))/2) + "px");
	
	$("#touchContainer").on("click", Mobile_NS.hideTouchBlock);
	
	$("#touchContainer .touchBlock").on("click", function(ev){
		var $touchPage = $(".touchPage:visible", $(this));
		if($touchPage.length > 0){
			var id = $touchPage.attr("id");
			if(id != "mainTouchPage"){
				var parentPageId = $touchPage.attr("touch_parent_page_id");
				Mobile_NS.changeTouchPageDisplay(parentPageId);
			}else{
				Mobile_NS.hideTouchBlock(ev);
			}
		}else{
			Mobile_NS.hideTouchBlock(ev);
		}
		ev.stopPropagation();
	});
	
	$("#touchContainer .touchPage .touchEntry").on("click", function(ev){
		Mobile_NS.showTouchLocker();
		var url = $(this).attr("touch_url");
		if(url && url != ""){
			Mobile_NS.hideTouchBlock(ev);
			setTimeout(function(){openUrlFindBeforeCreate(url);}, 160);
		}else{
			var childPageId = $(this).attr("touch_child_page_id");
			Mobile_NS.changeTouchPageDisplay(childPageId);
		}
		ev.stopPropagation();
	});
	
	$("#touchContainer .touchPage .touchBackEntry").on("click", function(ev){
		var parentPageId = $(this).closest(".touchPage").attr("touch_parent_page_id");
		Mobile_NS.changeTouchPageDisplay(parentPageId);
		ev.stopPropagation();
	});
};

Mobile_NS.changeTouchPageDisplay = function(beShowPageId){
	Mobile_NS.showTouchLocker();
	var $currPage = $("#touchContainer .touchPage:visible");
	var currPageId = $currPage.attr("id");
	$currPage.fadeOut(200, function(){
		var $beShowPage = $("#"+beShowPageId);
		$beShowPage.css("opacity", "0");
		$beShowPage.show();
		$beShowPage.animate({opacity: "1"}, 200, function(){
			Mobile_NS.hideTouchLocker();
		});
	});
};

Mobile_NS.showTouchLocker = function(){
	$("#touchLocker").show();
};

Mobile_NS.hideTouchLocker = function(){
	setTimeout(function(){$("#touchLocker").hide();}, 300);
};

Mobile_NS.showTouchBlock = function(ev){
	Mobile_NS.showTouchLocker();
	
	var $touchBtn = $("#touchBtn");
	$touchBtn.addClass("custom-active");
	
	var $touchContainer = $("#touchContainer");
	$touchContainer.show();
	
	$("#touchMask", $touchContainer).animate({height: "100%",opacity: "0.8"}, 150, function(){
		$("#mainTouchPage").show();
		$touchBtn.removeClass("custom-active");
		$touchBtn.hide();
		
		Mobile_NS.hideTouchLocker();
	});
	
	$(".touchPage .touchEntry .MEC_NumberRemind", $touchContainer).hide().each(function(){
		var $numRemind = $(this);
		var remindsql = $numRemind.attr("remindsql");
		var reminddatasource = $numRemind.attr("reminddatasource");
		Mobile_NS.SQL(remindsql, reminddatasource, function(result){
			if(result.length == 0){
				return;
			}
			var sqlResult = "";
			var lineData = result[0];
			for (var key in lineData){
				sqlResult = lineData[key];
				break;
			}
			$numRemind.removeClass("MEC_NumberRemind1 MEC_NumberRemind2 MEC_NumberRemind3 MEC_NumberRemind4");
			$numRemind.addClass("MEC_NumberRemind" + sqlResult.length);
			$numRemind.html(sqlResult);
			if(sqlResult != "" && sqlResult != "0"){
				$numRemind.show();
			}
		});
	});
	ev.stopPropagation();
};

Mobile_NS.hideTouchBlock = function(ev){
	Mobile_NS.showTouchLocker();
	
	var $touchContainer = $("#touchContainer");
	
	$("#touchContainer .touchPage").hide();
	
	$("#touchMask", $touchContainer).animate({height: "0%",opacity: "0.3"}, 150, function(){
		$touchContainer.hide();
		$("#touchBtn").show();
		//setTimeout(releasePage, 500);
		Mobile_NS.hideTouchLocker();
	});
	ev.stopPropagation();
};

Mobile_NS.changeTouchButtonPos = function(){
	var touchButtonPos = null;
	if(_top && typeof(_top.getTouchButtonPos) == "function"){
		touchButtonPos = _top.getTouchButtonPos();
		if(touchButtonPos){
			$("#touchBtn").css({
				"top" : touchButtonPos["y"]+"px",
				"left" : touchButtonPos["x"]+"px"
			});
		}
	}
};