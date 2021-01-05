<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="mode" class="weaver.contractn.serviceImpl.ModeServiceImpl" scope="page" />
<%
	//String modeName = "电子合同_合同收款";
	String modeName = request.getParameter("modeName");
	out.print(mode.queryExpandInfo(modeName) == null ? "":mode.queryExpandInfo(modeName).toString());
%>
