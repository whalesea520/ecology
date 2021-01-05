
Mobile_NS.NavHeader = {};

Mobile_NS.NavHeader.onload = function(p){
	var theId = p["id"];
	var $NMECHeader = $("#NMEC_" + theId);
	$NMECHeader.on("click", function(){
		var script = $(this).attr("script");
		if(script && script != ""){
			try{
				script = decodeURIComponent(script);
				eval(script);
			}catch(e){
				console.log(e);
			}
		}
	});
	
	Mobile_NS.NavHeader.bindBtnEvent(theId);
	
	var isFixedTop = p["isFixedTop"];
	if(isFixedTop == "1"){
		$("#scroll_header").append($("#abbr_" + theId));
		var h = 0;
		$("#scroll_header").children().each(function(){
			h += $(this).height();
		});
		$("#scroll_wrapper").css("top", h + "px");
	}
};

Mobile_NS.NavHeader.bindBtnEvent = function(mec_id){
	var $NMECHeader = $("#NMEC_" + mec_id);
	var $btns = $(".btnWrap > .btn", $NMECHeader);
	if($btns.length > 0){
		Mobile_NS.onTap($btns, function(event){
			event.stopPropagation();
			var script = $(this).attr("script");
			if(script && script != ""){
				script = decodeURIComponent(script);
				eval(script);
			}
		});
	}
	var $imgbtns = $(".btnWrap > .imgBtn", $NMECHeader);
	if($imgbtns.length > 0){
		Mobile_NS.onTap($imgbtns, function(event){
			event.stopPropagation();
			var script = $(this).attr("script");
			if(script && script != ""){
				script = decodeURIComponent(script);
				eval(script);
			}
		});
	}
};
