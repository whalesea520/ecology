Mobile_NS.Iframe = {};

Mobile_NS.Iframe.onload = function(p){
	
	var theId = p["id"];
	
	var width = $(window).width();
	if(parseFloat(p["width"]) > 0){
		width = p["width"];
	}
	$("#iframe"+theId).attr("width", width);
	
	var height = $(window).height();
	if(parseFloat(p["height"]) > 0){
		height = p["height"];
	}
	$("#iframe"+theId).attr("height", height);
}