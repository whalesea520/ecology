jQuery(document).ready(function(){
	jQuery(".btn_common").live("mouseover",function(){
		jQuery(this).addClass("btn_common_hover");
	}).live("mouseout",function(){
		jQuery(this).removeClass("btn_common_hover");
	});
});