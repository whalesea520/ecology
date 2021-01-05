Mobile_NS.Video = {};

Mobile_NS.Video.onload = function(p){
	
	var theId = p["id"];
	
	var width = $("#videoContainer"+theId).width();
	if(parseFloat(p["width"]) > 0){
		width = p["width"];
	}
	$("#video"+theId).attr("width", width);
	
	var autoplay = p["autoplay"];
	if(autoplay == "1"){
		$("#video"+theId).attr("autoplay", "autoplay");
	}
	
	var loop = p["loop"];
	if(loop == "1"){
		$("#video"+theId).attr("loop", "loop");
	}
}