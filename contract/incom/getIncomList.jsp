<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.contractn.util.ContractUtil" %>
<jsp:useBean  id="contractIncom"
	class="weaver.contractn.serviceImpl.IncomServiceImpl" scope="page" />
<jsp:useBean  id="incomVo"
    class="weaver.contractn.entity.IncomVo" scope="page" />
<jsp:useBean  id="incomEntity"
    class="weaver.contractn.entity.IncomEntity" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>    
<%		
		String action = request.getParameter("action");
		String pageIndex = ContractUtil.null2one(request.getParameter("pageIndex"));
		String pageSize = ContractUtil.null2twenty(request.getParameter("pageSize"));
		incomEntity.setPay_count(Util.null2String(request.getParameter("pay_count")));
        incomEntity.setPay_date(request.getParameter("pay_date"));
        incomEntity.setPlan_count(request.getParameter("plan_count"));
        incomEntity.setPlan_date(request.getParameter("plan_date"));
        incomVo.setTreeType(request.getParameter("treeType"));
        incomVo.setTreeId(request.getParameter("treeId"));
        incomEntity.setType(request.getParameter("type"));
        incomEntity.setCompany(request.getParameter("company"));
        incomVo.setIncom(incomEntity);
        incomVo.setConsName(Util.null2String(request.getParameter("cons_name")));
        incomVo.setConsCode(Util.null2String(request.getParameter("cons_code")));
        incomVo.setConsCount(Util.null2String(request.getParameter("cons_count")));
        incomVo.setUser(user);
        incomVo.setPageIndex(Integer.parseInt(pageIndex));
        incomVo.setPageSize(Integer.parseInt(pageSize));
        if("chart".equals(action)){
			out.print(Util.null2String(contractIncom.queryTotalIncom(incomVo)));
		}else{
			out.print(Util.null2String(contractIncom.queryIncomList(incomVo)));
		};

%>



