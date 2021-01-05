<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
StringBuffer result = new StringBuffer();

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null){
		result.append("{\"flag\":false,\"errorInfo\":\"error！\"}");
	}else{
		request.getRequestDispatcher("/fna/wfPage/getClearSubjectInfo.jsp").forward(request, response);
	}
%>