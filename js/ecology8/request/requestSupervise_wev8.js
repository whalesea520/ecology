	/**
	 *	created by bpf in Oct,2013
	**/
	window.typeid=null;
	window.workflowid=null;
	window.nodeids=null;
	
	/**
	 *	wuiform.init针对本页的功能来说无任何作用，纯粹用于解决兼容init.jsp中的JS/css冲突的问题
	**/
	wuiform.init=function(){
		wuiform.textarea();
		wuiform.wuiBrowser();
		wuiform.select();
	}
	
	flowPageManager.loadFunctions.leftNumMenu = function(){
	   
		$(".ulDiv").leftNumMenu(demoLeftMenus,{
			numberTypes:{
				flowNew:{hoverColor:"#EDCEAF",color:"#FFA302",title:"新的流程"},
				flowResponse:{hoverColor:"#C0D8B8",color:"#486C3E",title:"超时的流程"},
				flowOut:{hoverColor:"#DAC0E3",color:"#C325FF",title:"有反馈的流程"},
				flowAll:{hoverColor:"#A6A6A6",color:"black",title:"全部流程"}
			},
			showZero:false,
			menuStyles:["menu_lv1",""],
			clickFunction:function(attr,level,numberType){
				leftMenuClickFnBySupervise(attr,level,numberType);
			}
		});
		var sumCount=0;
		$(".e8_level_2").each(function(){
			var conuntI=$(this).find(".e8_block:last").html();
			if(conuntI=="" || conuntI==undefined){
				conuntI="0";
			}
			sumCount+=parseInt(conuntI);
		});
		//$(".leftType").append("("+sumCount+")");

		 // $(".flowFrame").attr("src","/workflow/search/WFSupervise.jsp");
	}
	
	function leftMenuClickFnBySupervise(attr,level,numberType) {
	     
		if (level == 1) {

		    if(numberType==='flowNew')
			{
		 	$(".flowFrame").attr("src","/workflow/search/WFSupervise.jsp?method=request&level=1&objid=" + attr.objid);

			}else if(numberType==='flowAll' || numberType===null)
			{
			$(".flowFrame").attr("src","/workflow/search/WFSupervise.jsp?method=type&objid=" + attr.objid);
			}
		} else {
		     if(numberType==='flowNew')
			{
		 	$(".flowFrame").attr("src","/workflow/search/WFSupervise.jsp?method=request&level=2&objid=" + attr.objid);

			}else if(numberType==='flowAll' || numberType===null)
			{
			$(".flowFrame").attr("src","/workflow/search/WFSupervise.jsp?method=workflow&objid=" + attr.objid);
			}
			
		}
	}
	

	
