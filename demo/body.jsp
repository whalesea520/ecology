<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%
String param = request.getRequestURI();

String querystring = request.getQueryString();
out.println("getRequestURI = "+param+" getQueryString=  "+querystring);
%>
