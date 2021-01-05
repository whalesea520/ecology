<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="mode" class="weaver.contractn.serviceImpl.ModeServiceImpl" scope="page" />
<%
	//String modeName = "电子合同_合同信息查询";
	String modeName = request.getParameter("modeName");
	out.print(mode.queryModeInfoByModeName(modeName) == null ? "":mode.queryModeInfoByModeName(modeName).toString());

%>
