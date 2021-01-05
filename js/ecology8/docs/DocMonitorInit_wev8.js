	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:doSubmit});
			jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
			jQuery("#tabDiv").remove();
			jQuery("#hoverBtnSpan").hoverBtn();
		
		jQuery("#toggleLeft").bind("click",function(){
			jQuery(".flowMenusTd",parent.document).toggle();
			jQuery(".leftTypeSearch",parent.document).toggle();
		});
});
	

	
