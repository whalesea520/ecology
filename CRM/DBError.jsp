
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String type = request.getParameter("type");
%>
<HTML>
<HEAD>
<TITLE><%=SystemEnv.getHtmlLabelName(15119,user.getLanguage())%></TITLE>
</HEAD>
<BODY>
<p>Database <%=type%> Error!</p>
</BODY>
</HTML> 
