<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.formmode.exttools.impexp.common.CodeUtils"%>
<%@page import="com.weaver.formmodel.mobile.appio.imports.services.DataVerifyService"%>
<%@page import="weaver.formmode.exttools.impexp.common.Base64"%>
<%@page import="java.nio.charset.Charset"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String str = "测试";
String str1 = "测试";
%>
<%!
String encoding = "UTF-8";
private String getBase64(String str){
	byte[] b = str.getBytes();
	String s = new String(Base64.encode(b));
	return s;
}
private String getFromBase64(String str) {
	byte[] b = str.getBytes();
	String s = new String(Base64.decode(b));
	return s;
}
private String getBase64a(String str){
	try{
		byte[] b = str.getBytes(encoding);
		str = new String(Base64.encode(b),encoding);
	}catch(Exception e){
		
	}
	return str;
}
private String getFromBase64a(String str) {
	try{
		byte[] b = str.getBytes(encoding);
		str = new String(Base64.decode(b),encoding);
	}catch(Exception e){
		
	}
	return str;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'base64.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

  </head>
  
  <body>
    This is my JSP page. <br>
    <%str = getBase64(str); %>
    <%=str %>
    <br>
    <%str = getFromBase64(str); %>
    <%=str %>
    <br>
    <%str1 = getBase64a(str1); %>
    <%=str1 %>
    <br>
    <%str1 = getFromBase64a(str1); %>
    <%=str1 %>
  </body>
</html>
