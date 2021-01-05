function setKeyword(source,target,formId){
	jQuery("#"+target).val(jQuery("#"+source).val());
}
/**
*清空搜索条件
*/
function resetCondtion() {
	//清空文本框
	jQuery("#advancedSearchDiv").find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery("#advancedSearchDiv").find(".Browser").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	//清空下拉框
	jQuery("#advancedSearchDiv").find("select").val("0");
	//jQuery("#advancedSearchDiv").find("select").trigger("change");
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
}
jQuery(document).ready(function () {
	if (typeof onBtnSearchClick != "undefined" && onBtnSearchClick instanceof Function) {
		jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	}
	jQuery(".topMenuTitle td:eq(0)").html(jQuery("#tabDiv").html());
	jQuery("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
	jQuery("#toggleLeft").bind("click", function () {
		jQuery(".flowMenusTd", parent.document).toggle();
		jQuery(".leftTypeSearch", parent.document).toggle();
	});
	jQuery("#baseInfoTab").bind("click", function () {
		jQuery("#contentInfo").hide();
		jQuery("#showInfo").hide();
		jQuery("div.selectedTitle").removeClass("selectedTitle");
		jQuery(this).addClass("selectedTitle");
		jQuery("#baseInfo").show();
	});
	jQuery("#contentTab").bind("click", function () {
		jQuery("div.selectedTitle").removeClass("selectedTitle");
		jQuery(this).addClass("selectedTitle");
		jQuery("#baseInfo").hide();
		jQuery("#contentInfo").show();
		jQuery("#showInfo").hide();
	});
	jQuery("#showTab").bind("click", function () {
		jQuery("div.selectedTitle").removeClass("selectedTitle");
		jQuery(this).addClass("selectedTitle");
		jQuery("#baseInfo").hide();
		jQuery("#contentInfo").hide();
		jQuery("#showInfo").show();
	});
	jQuery("#showDeptField").bind("click", function () {
		window.location.href = "/hrm/company/addDeptFieldlabel.jsp?ajax=1";
	});
	jQuery("#editDeptField").bind("click", function () {
		window.location.href = "/hrm/company/editDeptFieldBatch.jsp?ajax=1";
	});
	jQuery("#HrmValidate").bind("click", function () {
		window.location.href = "/hrm/tools/HrmValidate.jsp";
	});
	jQuery("#HrmValidatePrivate").bind("click", function () {
		window.location.href = "/hrm/tools/HrmValidatePrivate.jsp";
	});
});
function changeDate(obj, id, val) {
	if (val == null) {
		val = "6";
	}
	if (obj.value == val) {
		jQuery("#" + id).show();
	} else {
		jQuery("#" + id).hide();
		jQuery("#" + id).siblings("input[type='hidden']").val("");
	}
}

function hrmCheckinput(obj){
	if(obj.value==""){
		jQuery(obj).siblings("span").html("<IMG src=/images/BacoError_wev8.gif align=absMiddle>");
	}else{
		jQuery(obj).siblings("span").html("");
	}
}
