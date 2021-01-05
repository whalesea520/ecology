<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>   
<%@page import="weaver.general.Util"%>
<%@page import="weaver.contractn.util.ContractUtil" %>
<jsp:useBean id="rs" id="payPlan"
	class="weaver.contractn.serviceImpl.PayPlanServiceImpl" scope="page" />
<jsp:useBean id="rs" id="payVo"
    class="weaver.contractn.entity.PayPlanVo" scope="page" />
<jsp:useBean id="rs" id="payEntity"
    class="weaver.contractn.entity.PayPlanEntity" scope="page" />
 <%@ include file="/page/maint/common/initNoCache.jsp"%>   
<%
		String pageIndex = ContractUtil.null2one(request.getParameter("pageIndex"));
		String pageSize = ContractUtil.null2twenty(request.getParameter("pageSize"));
        payEntity.setType(request.getParameter("type"));
        payEntity.setPlan_count(Util.null2String(request.getParameter("plan_count")));
        payEntity.setPlan_date(request.getParameter("plan_date"));
        payEntity.setCondition(request.getParameter("condition"));
        payVo.setConsName(request.getParameter("cons_name"));
        payVo.setConsCount(request.getParameter("cons_count"));
        payVo.setConsCode(request.getParameter("cons_code"));
        payVo.setTreeType(request.getParameter("treeType"));
        payVo.setTreeId(request.getParameter("treeId"));
        payVo.setPayPlan(payEntity);
        payVo.setUsrId(user.getUID());
        payVo.setUser(user);
        payVo.setResource(Util.null2String(request.getParameter("resource")));
        payVo.setPageIndex(Integer.parseInt(pageIndex));
        payVo.setPageSize(Integer.parseInt(pageSize));
		out.print(Util.null2String(payPlan.queryPayPlanListInfo(payVo)));      

%>

                

   
                                                         