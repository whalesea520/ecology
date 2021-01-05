<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.*"%>
<jsp:useBean id="mode" class="weaver.contractn.serviceImpl.ModeServiceImpl" scope="page" />
<%
	//String modeName = "电子合同_合同信息";
	String modeName = request.getParameter("modeName");
	JSONObject obj = mode.queryImportExpandInfo(modeName);
	String url = "/formmode/interfaces/ModeDataBatchImport.jsp?ajax=1&modeid="+obj.getString("modeid")+"&pageexpandid="+obj.getString("expandid");
	obj.put("url",url);
	out.print(obj.toString());
%>
