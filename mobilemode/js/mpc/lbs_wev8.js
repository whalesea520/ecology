function _p_getLBS(fieldid){
	if(top && typeof(top.registLBSBackWindow) == "function"){
		window.lbs_fieldid = fieldid;
		top.registLBSBackWindow(window);
	}
	var url = "/mobilemode/lbs.jsp";
	openDetail(url);
}

function _LBSLoaded(result, fieldid){
	
	var $field = $("#field" + fieldid);
	$field[0].value = result;
	
	var resultArr = result.split(";;");
	var gpsstr = resultArr[0];
	var addstr = resultArr[1];
	
	var $lbsContainer = $("#lbsContainer_"+ fieldid);
	$lbsContainer.find(".lbsEntery").remove();
	
	var $lbsEntery = $("<div class=\"lbsEntery\"></div>");
	
	var lbsContentHtm = "<div class=\"lbsContent\" onclick=\"openMap('"+gpsstr+"');\" >"+ addstr + "</div>";
	
	$lbsEntery.html(lbsContentHtm);
	
	var $lbsDelete = $("<div class=\"lbsDelete\" onclick=\"lbsDelete('"+fieldid+"');\"></div>");
	
	$lbsEntery.append($lbsDelete);
	$lbsContainer.append($lbsEntery);
}

function openMap(gpsstr){
	var url = "/mobilemode/showmap.jsp?gpsstr=" + gpsstr;
	openDetail(url);
	if(event && event.stopPropagation){
		event.stopPropagation();
	}
}

function lbsDelete(fieldid){
	var $lbsContainer = $("#lbsContainer_"+ fieldid);
	$lbsContainer.find(".lbsEntery").remove();
	var $field = $("#field" + fieldid);
	$field[0].value = "";
}