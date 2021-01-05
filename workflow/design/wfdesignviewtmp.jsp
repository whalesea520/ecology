<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%
	String qureyString = request.getQueryString();
	//response.sendRedirect("wfdesign.jsp?"+request.getQueryString());
%>
<html>
<title><%=SystemEnv.getHtmlLabelName(22316,user.getLanguage())%></title>
<body onbeforeunload="javascript:return false">
	<iframe id="designFRM" src="wfdesign.jsp?<%=qureyString%>" style="width:100%;height:100%"></iframe>
<body>
</html>
<script>
var isModify = false;
function getModify() {
	isModify = document.frames['designFRM'].checkModified();
}
function window.onbeforeunload() {
	var url = document.getElementById('designFRM').src;
	if(url.indexOf('type=edit')!=-1) {
		window.dialogArguments.parent.setDesignTime();
	}
	getModify();
	if(isModify) {
		window.dialogArguments.parent.setDesignTime();
		event.returnValue = "<%=SystemEnv.getHtmlLabelName(18407,user.getLanguage())%>";
	}
}
</script>