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
		var url = "/system/systemmonitor/workflow/WorkflowMonitorList.jsp?"+requestParameters;
		if($(this).attr("timecondition"))
			url += "&timecondition="+$(this).attr("timecondition");
		$(this).attr("href",url);
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
}