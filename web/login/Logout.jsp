<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/web/inc/WebServer.jsp" %>
<%
String loginfile = Util.getCookie(request , "loginfileweaver") ;
request.getSession(true).removeValue("moniter") ;
request.getSession(true).removeValue("WeaverMailSet") ;
request.getSession(true).invalidate() ;

response.sendRedirect(webServerLogOut) ;
%>