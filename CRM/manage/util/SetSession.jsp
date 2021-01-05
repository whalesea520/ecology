
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
		String userid = Util.null2String(request.getParameter("userid"));
        request.getSession().setAttribute("CRM_MAIN_USERID",userid);
		return;
%>