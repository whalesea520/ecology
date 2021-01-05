$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe"
	});
	attachUrl();
});

function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}

function attachUrl(){
	var requestParameters=$(".requestParameterForm").serialize();
	$("a[target='tabcontentframe']").each(function(){
		var	url = "/workflow/search/WFSearchTemp.jsp?"+requestParameters;
		if($(this).attr("timecondition"))
			url += "&timecondition="+$(this).attr("timecondition");
		if($(this).attr("viewcondition")){
			url += "&viewcondition="+$(this).attr("viewcondition");
		}
		$(this).attr("href",url);
		
		
		
	}).bind("click",function(){
		var params = requestParameters;
		if($(this).attr("timecondition"))
			params += "&timecondition="+$(this).attr("timecondition");
		if($(this).attr("viewcondition"))
			params += "&viewcondition="+$(this).attr("viewcondition");
		parent.refreshLeftMenu(params);
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
}