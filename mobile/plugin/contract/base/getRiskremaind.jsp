<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.contractn.util.Constant" %>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<jsp:useBean id="rs" id="contractRisk"
	class="weaver.contractn.serviceImpl.RiskServiceImpl" scope="page" />
<jsp:useBean id="sto" class="weaver.contractn.entity.DynamicEntity" scope="page" />
<jsp:useBean id="dynamic" class="weaver.contractn.serviceImpl.DynamicServiceImpl" scope="page" />

<%@ include file="/page/maint/common/initNoCache.jsp"%>     
<%
		User usr = MobileUserInit.getUser(request, response);
		out.print(Util.null2String(contractRisk.queryUnsolveRiskRemaind(usr)));

%>



