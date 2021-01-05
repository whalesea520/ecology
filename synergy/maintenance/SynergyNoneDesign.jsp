
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
</head>
<%
	String spagetype = Util.null2String(request.getParameter("pagetype"));
	String stype = Util.null2String(request.getParameter("stype"));
	String waringstr = "";
	if(spagetype.equals("menu"))
		waringstr = SystemEnv.getHtmlLabelName(19060, user.getLanguage());
	else 
	{
		waringstr = SystemEnv.getHtmlLabelName(19060, user.getLanguage());
		if(stype.equals("doc"))
			waringstr = SystemEnv.getHtmlLabelName(84326, user.getLanguage());
	}
%>
<body>
<table class = "Shadow" style="background:white;">
<tr><td><div style="display:inline-flex;padding-left:50px;position:absolute;top:40px;">
   <img src="/synergy/js/waring_wev8.png"> <%=waringstr %>
</div></td>
</tr>
<tr><td></td></tr>
<tr><td></td></tr>
</table>

</body>
</html>