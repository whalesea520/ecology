$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe"
	});
	attachUrl();
});

//隐藏导航栏
function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}

function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var type=$(this).attr("type");
		var labelid=$(this).attr("labelid");
		var layout=$(this).attr("layout");
		$(this).attr("href","/cowork/CoworkListNew.jsp?type="+type+"&labelid="+labelid+"&layout="+layout);
		
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
}