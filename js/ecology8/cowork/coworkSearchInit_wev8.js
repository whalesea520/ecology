	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
			jQuery(".topMenuTitle td:eq(0)").html(jQuery("#tabDiv").html());
			jQuery("#tabDiv").remove();
			jQuery("#hoverBtnSpan").hoverBtn();
		
		jQuery("#toggleLeft").bind("click",function(){
			jQuery(".flowMenusTd",parent.document).toggle();
			jQuery(".leftTypeSearch",parent.document).toggle();
		});
		
		jQuery("#hoverBtnSpan .item").bind("click",function(){
			//resetCondtion();
			//parent.refreshLeftMenu("0",jQuery("#_doccreater").val(),jQuery("#urlType").val(),jQuery("#frmmain").attr("action"));
			//jQuery("#frmmain").submit();
			var type=$(this).attr("type");
			var labelid=$(this).attr("labelid");
			
			$("#type").val(type);
			$("#labelid").val(labelid);
			$("#frmmain").submit();
		});
		
		
	jQuery("#history").bind("click",function(){
		window.location.href="DocCommonContent.jsp?ishow=false&urlType=7";
	});
	
	jQuery("#approve").bind("click",function(){
		window.location.href="DocCommonContent.jsp?ishow=false&urlType=8";
	});
	
	jQuery("#back").bind("click",function(){
		window.location.href="DocCommonContent.jsp?ishow=false&urlType=9";
	});
	
	jQuery("#docNumber").bind("click",function(){
		window.location.href="docNumber.jsp";
	});
	
	jQuery("#secretLevel").bind("click",function(){
		window.location.href="docSecretLevel.jsp";
	});
	
	jQuery("#docKind").bind("click",function(){
		window.location.href="docKind.jsp";
	});
	
	jQuery("#intancyLevel").bind("click",function(){
		window.location.href="docInstancyLevel.jsp";
	});
	
	jQuery("#baseInfoTab").bind("click",function(){
		jQuery("#contentInfo").hide();
		jQuery("#showInfo").hide();
		jQuery("div.selectedTitle").removeClass("selectedTitle");
		jQuery(this).addClass("selectedTitle");
		jQuery("#baseInfo").show();
	});
	
	jQuery("#contentTab").bind("click",function(){
		jQuery("div.selectedTitle").removeClass("selectedTitle");
		jQuery(this).addClass("selectedTitle");
		jQuery("#baseInfo").hide();
		jQuery("#contentInfo").show();
		jQuery("#showInfo").hide();
	});
	
	jQuery("#showTab").bind("click",function(){
		jQuery("div.selectedTitle").removeClass("selectedTitle");
		jQuery(this).addClass("selectedTitle");
		jQuery("#baseInfo").hide();
		jQuery("#contentInfo").hide();
		jQuery("#showInfo").show();
	});
	
	jQuery("#showModle").bind("click",function(){
		window.location.href="/docs/mould/DocMould.jsp";
	});
	
	jQuery("#editModle").bind("click",function(){
		window.location.href="/docs/mouldfile/DocMould.jsp";
	});
	
});
	

	
