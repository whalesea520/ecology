
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%
	if(!HrmUserVarify.checkUserRight("intergration:SAPsetting",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
%>