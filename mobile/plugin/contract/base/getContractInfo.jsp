<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<jsp:useBean id="conService" class="weaver.contractn.serviceImpl.ContractServiceImpl" scope="page" />
<jsp:useBean id="dynamic" class="weaver.contractn.serviceImpl.DynamicServiceImpl" scope="page" />
<jsp:useBean id="risk" class="weaver.contractn.serviceImpl.RiskServiceImpl" scope="page" />
<jsp:useBean id="incom" class="weaver.contractn.serviceImpl.IncomServiceImpl" scope="page" />

<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	User usr = MobileUserInit.getUser(request, response);
    int consId = Integer.parseInt(Util.null2o(request.getParameter("consId")));
    JSONObject resultobj = conService.queryAllInfoById(consId);
    JSONArray dynamicArr = dynamic.queryDynamicIncludeComments(consId+"").getJSONArray("datas");
    JSONArray riskArr = risk.queryRiskListByConId(consId).getJSONArray("datas");
    JSONArray incomArr = incom.queryIncomInfoByConsId(consId+"");
    String related_c = Util.null2String(resultobj.getString("related_c"));
    resultobj.put("dynamicNum",dynamicArr.size());
    resultobj.put("riskNum",riskArr.size());
    resultobj.put("incomNum",incomArr.size());
    resultobj.put("relatedNum","".equals(related_c)?0:related_c.split(",").length);
	out.print(Util.null2String(resultobj));
	
%>



