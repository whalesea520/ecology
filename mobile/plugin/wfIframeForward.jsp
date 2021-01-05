<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%
	String forwardUrl = Util.null2String(request.getParameter("forwardUrl"));
	RequestDispatcher rd = request.getRequestDispatcher(forwardUrl);
	rd.forward(request, response);
%>