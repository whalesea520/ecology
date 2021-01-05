<%@ page import="com.weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
	request.getSession(true).removeAttribute("weaver_user@bean");
	response.sendRedirect("/jsp/login.jsp" );
%>