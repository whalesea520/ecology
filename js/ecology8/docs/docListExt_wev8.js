jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:null,params:{container:'a'}});
		jQuery(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		jQuery("#tabDiv").remove();
		jQuery("#hoverBtnSpan").hoverBtn();
	jQuery("#docAll").bind("click",function(){
		window.location.href="DocList.jsp?isuserdefault=0";
	});
	
	jQuery("#userdefault").bind("click",function(){
		window.location.href="DocList.jsp?isuserdefault=1";
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