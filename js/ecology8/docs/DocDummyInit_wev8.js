jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		jQuery("#hoverBtnSpan").hoverBtn();
	
});
	

	
