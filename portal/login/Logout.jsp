<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String loginfile = Util.getCookie(request , "loginfileweaver") ;
request.getSession(true).removeValue("moniter") ;
request.getSession(true).invalidate() ;
response.sendRedirect("/portal/Refresh.jsp?loginfile="+ loginfile) ;
%>