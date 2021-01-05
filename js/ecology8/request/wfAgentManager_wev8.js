$(function() {
	$('.e8_box').Tabs({
		staticOnLoad : true,
		iframe : "tabcontentframe"
	});

 jQuery(".e8_box  a").bind("click",function(){
			//	_contentDocument = getIframeDoc();
				$("#tabcontentframe").attr("src","/workflow/request/wfAgentDetail.jsp?agentInfo="+$(this).attr("name"));
				
		//		console.dir($(_contentDocument).find("#createdateselect"));
				
	//			$(_contentDocument).find("#createdateselect").val($(this).attr("name"));
			
//			    $(_contentDocument).find("#frmmain").submit();


				//jQuery("#createdateselect",_contentDocument).val("1");
                //jQuery("#frmmain",_contentDocument).submit();
			});


//	attachUrl();
});

function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}

function getIframeDoc(){
    	return jQuery(".e8_box").Tabs({
		    		method:"getContentDocument"
		    	});
}

function attachUrl(){
	var requestParameters=$(".requestParameterForm").serialize();
	$("[name='tabcontentframe']").attr("src","/workflow/search/WFSuperviseList.jsp?"+requestParameters);
	
}