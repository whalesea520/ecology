jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        staticOnLoad:true,
        objName:"<%=navName%>"
    });
});
	
	//运行flowPageManager.loadFunctions中的全部函数
	var flowPageManager={onload:function(){
		var loadFunctions=this.loadFunctions;
		for(var xFn in loadFunctions){
			var value=loadFunctions[xFn];
			loadFunctions[xFn]();
		}
	},loadFunctions:{}
	};
		
	/**
	 *页面自适应高度
	**/
	flowPageManager.loadFunctions.autoHeight = function(){
		jQuery(".flowsTable").height(jQuery(window).height()-2);
		
	//	var tdHeight2=jQuery(".ulDiv").parent().parent().parent().height()-2;
	//	jQuery("#overFlowDiv").css("height",(tdHeight2-jQuery(".flowMenuAll").height()-1)+"px");
	//	window.setTimeout(function(){
	//		jQuery(".ulDiv").css("height",jQuery(".ulDiv").find(".e8menu_ul:eq(0)").height()+10+"px");
	//		try{
//				jQuery('#overFlowDiv').perfectScrollbar("update");
//			}catch(e){}
//		},200);
		
//		window.setTimeout(function(){
//			var screenWidth = top.screen.width;
//			if(screenWidth<1280 || window.hideAnyway){
//				hideTree();
//			}
//		},200);

//		var tdHeight=0;
	//	tdHeight = jQuery("#leftmenuTD",top.document).height();
//		if(!tdHeight){
//			tdHeight = jQuery("#leftBlockTd",top.document).height()-2;
//		}
//		jQuery(".flowFrame").css("height",tdHeight+"px");

	}