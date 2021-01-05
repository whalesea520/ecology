<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%
	String uniqueKey = Util.null2String(request.getParameter("uniqueKey"));
	String pdfstream_result = Util.null2String(session.getAttribute("pdfstream_"+uniqueKey));
	if("success".equals(pdfstream_result)){
		session.removeAttribute("pdfstream_"+uniqueKey);
		response.getWriter().write("1");
	}else{
		response.getWriter().write("0");
	}
%>