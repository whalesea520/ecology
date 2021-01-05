
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,weaver.hrm.*,weaver.security.classLoader.*,java.lang.reflect.Field,java.lang.reflect.Method" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title></title>

<LINK href="Weaver.css" type=text/css rel=STYLESHEET>
</head>
<body>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int UID = xssUtil.getIntValue(""+xssUtil.getRule().get("userID"),1);
if (user.getUID()!=UID)
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
ReflectMethodCall rmc = new ReflectMethodCall();
rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"setConfigFirewall", new Class[]{boolean.class}, true);

%>
OK.
</body>
</html>
