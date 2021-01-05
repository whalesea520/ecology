
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");
%>
<%
String type = request.getParameter("type");
%>
<HTML>
<HEAD>
<TITLE><%=SystemEnv.getHtmlLabelName(15119,user.getLanguage())%></TITLE>
<META content="text/html; charset=UTF-8" http-equiv=Content-Type>
<META content="Microsoft FrontPage 4.0" name=GENERATOR>
</HEAD>
<BODY>
<p>Database <%=type%> Error!</p>
</BODY>
</HTML> 
