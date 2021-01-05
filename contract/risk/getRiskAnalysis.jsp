<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="riskVo" class="weaver.contractn.entity.RiskVo" scope="page" />
<jsp:useBean id="riskEntity" class="weaver.contractn.entity.RiskEntity" scope="page" />
<jsp:useBean id="riskService" class="weaver.contractn.serviceImpl.RiskServiceImpl" scope="page" />
<%@page import="weaver.general.Util"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	String treeId = Util.null2s(request.getParameter("treeId"),"");
	String treeType = Util.null2s(request.getParameter("treeType"),"");
	String startdate = Util.null2s(request.getParameter("plan_date"),"");
	String risktype = Util.null2s(request.getParameter("risk_type"),"");
	riskEntity.setStart_date(startdate);
	riskEntity.setRisk_type(risktype);
	riskVo.setTreeId(treeId);
	riskVo.setTreeType(treeType);
	riskVo.setUser(user);
	riskVo.setRisk(riskEntity);
	out.print(Util.null2String(riskService.queryRiskAnalysis(riskVo)));
%>

