<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<html>
<head>
<title>Text Area Properties</title>
<meta content="noindex, nofollow" name="robots">
</head>
<body>
<%
User user = HrmUserVarify.getUser (request , response);
%>
<div style="text-align:center;line-height:500px;">
	<img src="/workflow/exceldesign/image/shortBtn/loading_wev8.gif"></img>
	<div><%=SystemEnv.getHtmlLabelName(82253,user.getLanguage()) %></div>
</div>
</body>
</html>