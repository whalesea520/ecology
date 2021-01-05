
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,java.util.*,weaver.hrm.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>

<title>xmltable-dongping </title>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<body>
<%
	User user = HrmUserVarify.checkUser(request,response);
	if(user == null){
		out.println("please login.");
		return;
	}
	if(user.getUID()==1){
	//if(true){
		out.println(xssUtil.enableFirewall()+"<br/>");
		String url = xssUtil.null2String(request.getParameter("url"));
		if(!"".equals(url)){
			String param = request.getParameter("param");
			out.println(url+"====="+param+"===="+xssUtil.getRules(url,param));
		}else{
			String key = xssUtil.null2String(request.getParameter("key"));
			out.println(key+"=========="+xssUtil.getRule().get(key)); 
		}

	}else{
		out.println("no right.");
	}
%>
</body>
</html>
