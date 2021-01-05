<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@ page import="weaver.hrm.User"%>  
<%@page import="weaver.contractn.util.ContractUtil" %>
<%@page import="com.alibaba.fastjson.JSONArray" %>
<jsp:useBean id="remaind" class="weaver.contractn.serviceImpl.RemaindServiceImpl" scope="page" />
<jsp:useBean id="PayPlanVo" class="weaver.contractn.entity.PayPlanVo" scope="page" />
<jsp:useBean id="PayPlanEntity" class="weaver.contractn.entity.PayPlanEntity" scope="page" />
<jsp:useBean id="pay" class="weaver.contractn.serviceImpl.PayPlanServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
		User usr = MobileUserInit.getUser(request, response);
		PayPlanVo.setUser(usr);
  		String pageIndex = ContractUtil.null2one(request.getParameter("pageIndex"));
		String pageSize = ContractUtil.null2twenty(request.getParameter("pageSize"));
  		PayPlanEntity.setType("");
  		PayPlanVo.setResource("remaind");
  		PayPlanVo.setPageIndex(Integer.parseInt(pageIndex));
  		PayPlanVo.setPageSize(Integer.parseInt(pageSize));
  		JSONArray arr = pay.queryPayPlanListInfo(PayPlanVo).getJSONArray("datas");
        out.print(arr.toString());

%>



