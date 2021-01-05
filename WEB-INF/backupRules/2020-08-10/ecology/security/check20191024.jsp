
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,java.util.*,java.io.*,java.util.regex.*,java.util.concurrent.*,weaver.hrm.*,org.apache.commons.lang.StringUtils,java.text.DateFormat" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	
	if(user==null){
		response.sendRedirect("/login/Login.jsp");
		return;
	}
	if(!"sysadmin".equals(user.getLoginid())){
		out.println("请使用sysadmin登录系统后访问该页面。");
		return;
	}
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>数据库配置泄露补丁升级结果</title>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body>
<div style="margin:0 auto;width:800px;margin-top:50px;">
<h1><b>
	<font style="color:red;">看到本页面表示数据库配置泄露补丁安全补丁包已经升级成功！(20191024)</font>
</b></h1>
</div>
</body>
</html>
