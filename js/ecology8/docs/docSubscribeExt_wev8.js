jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle();
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		jQuery("#hoverBtnSpan").hoverBtn();
	
	jQuery("#history").bind("click",function(){
		window.location.href="docSubscribeHistory.jsp";
	});
	
	jQuery("#approve").bind("click",function(){
		window.location.href="docSubscribeApprove.jsp";
	});
	
	jQuery("#back").bind("click",function(){
		window.location.href="docSubscribeBack.jsp";
	});
	
	
});


/**
*日期更改
*/
function changeDate(obj,id,val){
	if(val==null)val='6';
	if(obj.value==val){
		jQuery("#"+id).show();
	}else{
		jQuery("#"+id).hide();
		jQuery("#"+id).siblings("input[type='hidden']").val("");
	}
}