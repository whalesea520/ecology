
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles_wev8.css">
	-->
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  </head>
  <%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(26798,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
  <body>
<table width="100%" height="28" cellspacing="0" cellpadding="0">
	<tr>
		<td height="28" align="top" valign="top">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		</td>
	</tr>
</table>
  </body>
</html>
