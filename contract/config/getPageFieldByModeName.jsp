<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="mode" class="weaver.contractn.serviceImpl.ModeServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	String modeName = request.getParameter("modeName");
	//String modeName = "电子合同_合同收款";
	out.print(Util.null2String(mode.queryPageFiledIdsByModeName(modeName)));

%>
