<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="rs" id="contractRisk"
	class="weaver.contractn.serviceImpl.RiskServiceImpl" scope="page" />
<%
        int conId = Integer.parseInt("".equals(request.getParameter("basicId")) ? "0":request.getParameter("basicId"));
        
		out.print(contractRisk.queryRiskListByConId(conId));

%>



