<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response); 
%>
<html>
<head>
<style>
.notSupportNotice{
	height:100%; text-align:center; 
	line-height:22em; font-size:20px; 
	color:red; background:#efefef;
}
</style>
</head>
<body style="overflow:hidden;">
<div style="width:100%; height:100%;">
	<div class='notSupportNotice'><%=SystemEnv.getHtmlLabelName(128065, user.getLanguage())%></div>
</div>
</body>
</html>