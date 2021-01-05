
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	request.getRequestDispatcher("WorkPlanShareAdd.jsp?types=1").forward(request, response);
%>
