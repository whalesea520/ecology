/*顶部按钮划出页面相关代码*/
function createSildePage(items, p){
	var sildePageId = (p == "L") ? "leftSlidePage" : ((p == "R")? "rightSlidePage" : "");
	if(sildePageId == ""){
		return;
	}
	var $sildePage = $("#" + sildePageId);
	if($sildePage.length > 0){
		return;
	}
	
	$sildePage = $("<div id=\""+sildePageId+"\" class=\"slidePage\"></div>");
	for(var i = 0; i < items.length; i++){
		var iconpath = items[i]["iconpath"];
		var iconstyle = items[i]["iconstyle"];
		var uiname = items[i]["uiname"];
		var remindnum = items[i]["remindnum"];
		var action = items[i]["action"];
		
		var iHtm = "<div class=\"sildePageEntry\" onclick=\""+action+"\">";
		if(iconpath && $.trim(iconpath) != ""){
			iHtm += "<img src=\""+iconpath+"\" style=\""+iconstyle+"\"/>";
		}
		iHtm += uiname;
		if(remindnum && $.trim(remindnum) != ""){
			iHtm += "（"+remindnum+"）";
		}
		iHtm += "</div>";
		$sildePage.append(iHtm);
	}
	
	var swipeevent = (p == "L") ? "swipeleft" : ((p == "R")? "swiperight" : "");
	$sildePage.on(swipeevent,function(){
		doPageSilde(p);
	});
	
	$(document.body).prepend($sildePage);
	
	$sildePage.css("height", document.body.scrollHeight + "px");
}

function doPageSilde(p){
	if(p == "L"){
		sildeLeftPage();
	}else if(p == "R"){
		sildeRightPage();
	}	
}

var leftDisplayFlag = false;
function sildeLeftPage(){
	var w = 70;
	
	function doShow(n){
		n = n - 10;
		
		var l = n;
		var r = w - l;
		
		$("#leftSlidePage").animate({ left: "-"+l+"%"}, 5, function(){
			$("#homepageContainer").animate({right: "-"+r+"%"}, 0, function(){
				if(n != 0){
					doShow(n);
				}
			});
			
	 	});
	}
	
	function doHide(n){
		n = n - 10;
		
		var r = n;
		var l = w - r;
		
		
		$("#homepageContainer").animate({right: "-"+r+"%"}, 20, function(){
			$("#leftSlidePage").animate({ left: "-"+l+"%"}, 0, function(){
				if(n != 0){
					doHide(n);
				}else{
					$("#leftSlidePage").hide();
				}
			});
			
	 	});
	}
	
	if(!leftDisplayFlag){
		$("#leftSlidePage").show();
		doShow(w);
	}else{
		doHide(w);
	}
	
	leftDisplayFlag = !leftDisplayFlag;
}

var rightDisplayFlag = false;
function sildeRightPage(){
	var w = 70;
	
	function doShow(n){
		n = n - 10;
		
		var r = n;
		var l = w - r;
		
		$("#rightSlidePage").animate({ right: "-"+r+"%"}, 5, function(){
			$("#homepageContainer").animate({left: "-"+l+"%"}, 0, function(){
				if(n != 0){
					doShow(n);
				}
			});
			
	 	});
	}
	
	function doHide(n){
		n = n - 10;
		
		var l = n;
		var r = w - l;
		
		
		$("#homepageContainer").animate({left: "-"+l+"%"}, 20, function(){
			$("#rightSlidePage").animate({ right: "-"+r+"%"}, 0, function(){
				if(n != 0){
					doHide(n);
				}else{
					$("#rightSlidePage").hide();
				}
			});
			
	 	});
	}
	
	if(!rightDisplayFlag){
		$("#rightSlidePage").show();
		doShow(w);
	}else{
		doHide(w);
	}
	
	rightDisplayFlag = !rightDisplayFlag;
}
