function showE8TypeOption(closed){
	if(closed){
		jQuery("#e8TypeOption").hide();
	}else{
		jQuery("#e8TypeOption").toggle();
	}
	if(jQuery("#e8TypeOption").css("display")=="none"){
		jQuery("span.leftType").removeClass("leftTypeSel");
		var src = jQuery("#currentImg").attr("src");
		if(src){
			src = src.replace(/_sel_wev8/,"_wev8");
			jQuery("#currentImg").attr("src",src);
		}
		jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_wev8.png");
	}else{
		jQuery("span.leftType").addClass("leftTypeSel");
		jQuery("#e8TypeOption").width(jQuery("span.leftType").width()+10);
		var src = jQuery("#currentImg").attr("src");
		if(src){
			src = src.replace(/_wev8\.png/,"_sel_wev8.png");
			jQuery("#currentImg").attr("src",src);
		}
		jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_sel_wev8.png");
	}
	return;
}

jQuery(document).ready(function(){
	var clearHandle = null;
	jQuery("#e8typeDiv").hover(function(){
		
	},function(){
		if(jQuery("#e8TypeOption").length>0){
			if(clearHandle)clearTimeout(clearHandle);
			clearHandle = window.setTimeout(function(){
				showE8TypeOption(true);
			},500);
		}
	});
	
	jQuery("#e8TypeOption").hover(function(){
		if(clearHandle)clearTimeout(clearHandle);
	},function(){
		showE8TypeOption(true);
	});
});