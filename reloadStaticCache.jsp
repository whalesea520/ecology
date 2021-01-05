<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="wStaticFilter" class="weaver.filter.WStaticFilter" />
<%
	wStaticFilter.reload();
	out.println("ok...");
%>