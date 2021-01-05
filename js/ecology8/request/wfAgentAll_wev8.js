$(function() {
	$('.e8_box').Tabs({
		staticOnLoad : true,
		iframe : "tabcontentframe"
	});

    jQuery(".e8_box  a").bind("click",function(){
 	
		_contentDocument = getIframeDoc();
		
		console.dir($(_contentDocument).find("#createdateselect"));
		
		$(_contentDocument).find("#createdateselect").val($(this).attr("name"));
	
	    $(_contentDocument).find("#frmmain").submit();

			});
    flowPageManager.onload(); 
  

});

function getIframeDoc(){
	return jQuery(".e8_box").Tabs({
	    		method:"getContentDocument"
	    	});
}

function refreshTab(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
		}else{ 
			window.parent.oTd1.style.display='';
		}
	}
}


	
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