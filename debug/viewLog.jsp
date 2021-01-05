<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<%@ include file="init.jsp" %>
<%
if (!isInitDebug()) {
    return;
}

%>
<%
    String logContent = null;

    Class debugAgent = Class.forName("com.weaver.onlinedebug.DebugAgent");
    logContent = (String) debugAgent.getDeclaredMethod("getLogFileContent", (Class[])null).invoke(null,new Object[]{});
%>
<html>
 <head>
  <title> New Document </title>
  <meta name="Generator" content="EditPlus">
  <meta name="Author" content="">
  <meta name="Keywords" content="">
  <meta name="Description" content="">
  <meta http-equiv=Content-Type content="text/html; charset=utf8">
  <link type='text/css' rel='stylesheet'  href='css/main_wev8.css'/>
  <script type="text/javascript" src="javascripts/jquery-1.4.2.min_wev8.js"></script>
  <script type="text/javascript">
  </script>
 </head>
 <body style="overflow:auto;" class="output">
 <textarea id='logbox' style='height:5000px;width:98%;overflow:hidden' class="output">
 <%=logContent%>
 </textarea>
<script type="text/javascript">
var logbox = document.getElementById('logbox');
logbox.style.height=(logbox.scrollHeight)+'px';
//alert(logbox.scrollHeight);
</script>
 </body>
</html>
