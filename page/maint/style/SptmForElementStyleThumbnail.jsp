
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
  <head>
    <LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
  </head>  
  <%
  	String styleid = Util.null2String(request.getParameter("id"));
  	out.print(su.getContainerForStyle(styleid));
%>