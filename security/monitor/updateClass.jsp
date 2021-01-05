
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,weaver.hrm.*,weaver.security.classLoader.*,java.lang.reflect.Field,java.lang.reflect.Method,weaver.filter.XssUtil" %>
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
	
if(user==null){
	out.println("无权限，请用sysadmin登录后访问！");
	return;
}
XssUtil xssUtil = new XssUtil();
int UID = xssUtil.getIntValue(""+xssUtil.getRule().get("userID"),1);
if (user.getUID()!=UID){
	out.println("无权限，请用sysadmin登录后访问！");
	return;
}

ClassLoaderManager.newClassLoader(xssUtil.getRootPath());
new weaver.filter.msg.CheckSecurityUpdateInfo();
xssUtil = new XssUtil();
xssUtil.initRules(true);
%>
OK.
</body>
</html>
