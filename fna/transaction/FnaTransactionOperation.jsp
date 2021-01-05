<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
if(true){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}else{
	HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit", null);
}
%>