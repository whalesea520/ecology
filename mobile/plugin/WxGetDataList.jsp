<%@ page language="java" contentType="application/json" pageEncoding="GBK"%>
<%@ page import="weaver.wxinterface.WxInterfaceInit"%>
<%	
	out.clearBuffer();
	if(!WxInterfaceInit.isIsutf8()){
		request.setCharacterEncoding("GBK");
	}else{
		request.setCharacterEncoding("UTF-8");
	}
	response.setContentType("application/json;charset=GBK");
	
	request.getRequestDispatcher("/mobile/plugin/ComponentList.jsp?"+request.getQueryString()).forward(request, response);
	return;
%>