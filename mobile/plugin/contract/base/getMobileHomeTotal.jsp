<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import="weaver.hrm.User"%>   
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="weaver.contractn.util.Constant"%>
<jsp:useBean id="PayPlanVo" class="weaver.contractn.entity.PayPlanVo" scope="page" />
<jsp:useBean id="PayPlanEntity" class="weaver.contractn.entity.PayPlanEntity" scope="page" />
<jsp:useBean id="contractVo" class="weaver.contractn.entity.ContractVo" scope="page" />
<jsp:useBean id="contractEntity" class="weaver.contractn.entity.ContractEntity" scope="page" />
<jsp:useBean id="incomVo" class="weaver.contractn.entity.IncomVo" scope="page" />
<jsp:useBean id="incomEntity" class="weaver.contractn.entity.IncomEntity" scope="page" />
<jsp:useBean id="contract" class="weaver.contractn.serviceImpl.ContractServiceImpl" scope="page" />
<jsp:useBean id="incom" class="weaver.contractn.serviceImpl.IncomServiceImpl" scope="page" />
<jsp:useBean id="pay" class="weaver.contractn.serviceImpl.PayPlanServiceImpl" scope="page" />
<jsp:useBean id="remaind" class="weaver.contractn.serviceImpl.RemaindServiceImpl" scope="page" />
<jsp:useBean id="risk" class="weaver.contractn.serviceImpl.RiskServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	User usr = MobileUserInit.getUser(request, response);
	JSONObject resultObj = new JSONObject();
	int pageIndex = 1;
	int pageSize = 1;
	/**今日签约**/
	String todayDate = contractEntity.getCreate_date();
	contractEntity.setSign_date("'"+todayDate+"','"+todayDate+"'");
	contractVo.setContract(contractEntity);
	contractVo.setUser(usr);
	float conNum = contract.queryTotalCountBySignDate(contractVo);
	resultObj.put("todaySign",conNum);
	/**今日收款**/
	incomEntity.setPay_date("'"+todayDate+"','"+todayDate+"'");
	incomVo.setIncom(incomEntity);
	incomVo.setUser(usr);
	float incomNum = incom.querySumIncom(incomVo).getFloat("incomTotalCount");
	resultObj.put("todayIncom",incomNum);
	/**今日应收**/
	PayPlanEntity.setPlan_date("'"+todayDate+"','"+todayDate+"'");
	PayPlanEntity.setType(Constant.INCOM_PAYTYPE_INFO_SELECTITEMVALUE);
	PayPlanVo.setPayPlan(PayPlanEntity);
	PayPlanVo.setUser(usr);
	float planIncomNum = pay.queryTotalCountByPlanPayDate(PayPlanVo);
	resultObj.put("todayPlanIncom",planIncomNum);
	/**今日应付**/
	PayPlanEntity.setType(Constant.PAY_PAYTYPE_INFO_SELECTITEMVALUE);
	float planPayNum = pay.queryTotalCountByPlanPayDate(PayPlanVo);
	resultObj.put("todayPlanPay",planPayNum);
	/**合同提醒**/
	PayPlanEntity.setType("");
	PayPlanVo.setResource("remaind");
	PayPlanVo.setPageIndex(pageIndex);
	PayPlanVo.setPageSize(pageSize);
	int payPlanRemaindNum = pay.queryPayPlanListInfo(PayPlanVo).getIntValue("totalSize");
	resultObj.put("payRemaind",payPlanRemaindNum);
	/**风险提醒**/
	JSONArray riskArr = risk.queryUnsolveRiskRemaind(usr);
	resultObj.put("riskRemaind",riskArr.size());
	out.print(Util.null2String(resultObj));
	
%>



