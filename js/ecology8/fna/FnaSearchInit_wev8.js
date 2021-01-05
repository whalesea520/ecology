	jQuery(document).ready(function(){
		jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
		jQuery("#hoverBtnSpan").hoverBtn();

/*
			jQuery(".topMenuTitle td:eq(0)").html(jQuery("#tabDiv").html());
			jQuery("#tabDiv").remove();
			jQuery("#hoverBtnSpan").hoverBtn();
		
		jQuery("#toggleLeft").bind("click",function(){
			jQuery(".flowMenusTd",parent.document).toggle();
			jQuery(".leftTypeSearch",parent.document).toggle();
		});
		
		jQuery("#docAll").bind("click",function(){
			resetCondtion();
			parent.refreshLeftMenu("0",jQuery("#_doccreater").val(),jQuery("#urlType").val(),jQuery("#frmmain").attr("action"));
			jQuery("#frmmain").submit();
		});
		
		jQuery("#docToday").bind("click",function(){
			jQuery("#doccreatedateselect").val("1");
			parent.refreshLeftMenu("1",jQuery("#_doccreater").val(),jQuery("#urlType").val(),jQuery("#frmmain").attr("action"));
			jQuery("#frmmain").submit();
		});
		
		jQuery("#docWeek").bind("click",function(){
			jQuery("#doccreatedateselect").val("2");
			parent.refreshLeftMenu("2",jQuery("#_doccreater").val(),jQuery("#urlType").val(),jQuery("#frmmain").attr("action"));
			jQuery("#frmmain").submit();
		});
		
		jQuery("#docMonth").bind("click",function(){
			jQuery("#doccreatedateselect").val("3");
			parent.refreshLeftMenu("3",jQuery("#_doccreater").val(),jQuery("#urlType").val(),jQuery("#frmmain").attr("action"));
			jQuery("#frmmain").submit();
		});
		
		jQuery("#docQuarterly").bind("click",function(){
			jQuery("#doccreatedateselect").val("4");
			parent.refreshLeftMenu("4",jQuery("#_doccreater").val(),jQuery("#urlType").val(),jQuery("#frmmain").attr("action"));
			jQuery("#frmmain").submit();
		});
		
		jQuery("#docYear").bind("click",function(){
			jQuery("#doccreatedateselect").val("5");
			parent.refreshLeftMenu("5",jQuery("#_doccreater").val(),jQuery("#urlType").val(),jQuery("#frmmain").attr("action"));
			jQuery("#frmmain").submit();
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
	
	jQuery("#showDeptField").bind("click", function() {
		window.location.href = "/hrm/company/addDeptFieldlabel.jsp?ajax=1";
	});

	jQuery("#editDeptField").bind("click", function() {
		window.location.href = "/hrm/company/editDeptFieldBatch.jsp?ajax=1";
	});

	jQuery("#HrmValidate").bind("click", function() {
		window.location.href = "/hrm/tools/HrmValidate.jsp";
	});

	jQuery("#HrmValidatePrivate").bind("click", function() {
		window.location.href = "/hrm/tools/HrmValidatePrivate.jsp";
	});
*/
});
