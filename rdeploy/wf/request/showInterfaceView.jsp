<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	wfLayoutToHtml.setRequest(request);
	wfLayoutToHtml.setUser(user);
	wfLayoutToHtml.setIscreate(1);
	Hashtable ret_hs = wfLayoutToHtml.analyzeLayout();
%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="/workflow/exceldesign/css/excelHtml_wev8.css" />
<%=ret_hs.get("wfcss") %>
</head>
<body style="overflow:hidden;">
<%
	String wfformhtml = Util.null2String((String)ret_hs.get("wfformhtml"));
	out.println(wfformhtml);
	StringBuffer jsStr = wfLayoutToHtml.getJsStr();
%>
</body>
</html>
<script language="javascript">
<%//out.println(jsStr.toString());%>

jQuery(document).ready(function(){
	try{
		createTags();
	}catch(e){}
	doDisableAll_s();
	removeInput();
});

function doDisableAll_s(){
	jQuery("*").removeAttr("onchange");
	jQuery("*").removeAttr("onclick");
	jQuery("*").removeAttr("onBlur");
	jQuery("*").removeAttr("onKeyPress");
	jQuery("*").removeAttr("onpropertychange");
	jQuery("*").removeAttr("onfocus");
}

function removeInput(){
	$(":input[type=text]").each(
		function(){
			jQuery(this).remove();
			//jQuery(this).attr("disabled", "disabled");
		}
	);
	$("textarea").each(
		function(){
			jQuery(this).remove();
			//jQuery(this).attr("disabled", "disabled");
		}
	);
}

function wfbrowvaluechange(){}
function checkLengthbrow(){}
</script>