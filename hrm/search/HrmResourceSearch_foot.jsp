<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%> 

<%
User user = HrmUserVarify.getUser (request , response) ;
%>


<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language=javascript src="HrmResourceSearchResult1_wev8.js"></script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<script language="javascript">
function onShowResourceConditionBrowserBack(e,dialogId,name){
	if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
		var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
		var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
		var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
		var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
		var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
		var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
		var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
		var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);
	
		var sHtml = "";
		var fileIdValue = "";
		shareTypeValues = shareTypeValues.substr(1);
		shareTypeTexts = shareTypeTexts.substr(1);
		relatedShareIdses = relatedShareIdses.substr(1);
		relatedShareNameses = relatedShareNameses.substr(1);
		rolelevelValues = rolelevelValues.substr(1);
		rolelevelTexts = rolelevelTexts.substr(1);
		secLevelValues = secLevelValues.substr(1);
		secLevelTexts = secLevelTexts.substr(1);
	
		var shareTypeValueArray = shareTypeValues.split("~");
		var shareTypeTextArray = shareTypeTexts.split("~");
		var relatedShareIdseArray = relatedShareIdses.split("~");
		var relatedShareNameseArray = relatedShareNameses.split("~");
		var rolelevelValueArray = rolelevelValues.split("~");
		var rolelevelTextArray = rolelevelTexts.split("~");
		var secLevelValueArray = secLevelValues.split("~");
		var secLevelTextArray = secLevelTexts.split("~");
		for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {
	
			var shareTypeValue = shareTypeValueArray[_i];
			var shareTypeText = shareTypeTextArray[_i];
			var relatedShareIds = relatedShareIdseArray[_i];
			var relatedShareNames = relatedShareNameseArray[_i];
			var rolelevelValue = rolelevelValueArray[_i];
			var rolelevelText = rolelevelTextArray[_i];
			var secLevelValue = secLevelValueArray[_i];
			var secLevelText = secLevelTextArray[_i];
	
			fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
					+ relatedShareIds + "_" + rolelevelValue + "_"
					+ secLevelValue;

			if (shareTypeValue == "1") {
				sHtml = sHtml + "," + shareTypeText + "("
						+ relatedShareNames + ")";
			} else if (shareTypeValue == "2") {
				sHtml = sHtml
						+ ","
						+ shareTypeText
						+ "("
						+ relatedShareNames
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
			} else if (shareTypeValue == "3") {
				sHtml = sHtml
						+ ","
						+ shareTypeText
						+ "("
						+ relatedShareNames
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
			} else if (shareTypeValue == "4") {
				sHtml = sHtml
						+ ","
						+ shareTypeText
						+ "("
						+ relatedShareNames
						+ ")"
						+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
						+ rolelevelText
						+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
			} else {
				sHtml = sHtml
						+ ","
						+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
						+ secLevelValue
						+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
			}
		}
				
		sHtml = sHtml.substr(1);
		fileIdValue = fileIdValue.substr(1);

		jQuery("#"+name).val(fileIdValue);
		jQuery("#"+name+"span").html(sHtml);
	}else{
		if (ismand == 0) {
			jQuery("#"+name+"span").html("");
		} else {
			jQuery("#"+name+"span").html("<img src='/images/BacoError.gif' align=absmiddle>");
		}
		jQuery("#"+name).val("");
	}
}

function resetCondition(selector){
	if(!selector)selector="#advancedSearchDiv";
	//清空文本框
	jQuery(selector).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(selector).find(".e8_os").find("span.e8_showNameClass").remove();
	jQuery(selector).find(".e8_os").find("input[type='hidden']").val("");
	//清空下拉框
	try{
		jQuery(selector).find("select").each(function(){
			var $target = jQuery(this);
			var _defaultValue = $target.attr("_defaultValue");
			if(!_defaultValue){
				var option = $target.find("option:first");
				_defaultValue = option.attr("value");
			}
			if($target.attr('id') == 'status')
				_defaultValue = 8;
			$target.val(_defaultValue);
			var checkText=$target.find("option:selected").text();
			var sb = $target.attr('sb');
			jQuery('#sbSelector_'+sb).text(checkText);
			jQuery('#sbSelector_'+sb).attr("title",checkText); 
		});
	}catch(e){
		
	}
	//清空日期
	jQuery(selector).find(".calendar").siblings("span").html("");
	jQuery(selector).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find(".Calendar").siblings("span").html("");
	jQuery(selector).find(".Calendar").siblings("input[type='hidden']").val("");
	
	jQuery(selector).find("input[type='checkbox']").each(function(){
		try{
			changeCheckboxStatus(this,false);
		}catch(e){
			this.checked = false;
		}
	});
}
</script>
</HTML>