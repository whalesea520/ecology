<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="weaver.contractn.util.ContractUtil" %>
<jsp:useBean  id="contractIncom"
	class="weaver.contractn.serviceImpl.IncomServiceImpl" scope="page" />
<jsp:useBean  id="incomVo"
    class="weaver.contractn.entity.IncomVo" scope="page" />
<jsp:useBean  id="incomEntity"
    class="weaver.contractn.entity.IncomEntity" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>    
<%
		User usr = MobileUserInit.getUser(request, response);
		String pageIndex = ContractUtil.null2one(request.getParameter("pageIndex"));
		String pageSize = ContractUtil.null2twenty(request.getParameter("pageSize"));
        incomEntity.setPay_count(Util.null2String(request.getParameter("pay_count")));
        incomEntity.setPay_date(request.getParameter("pay_date"));
        //incomEntity.setPay_date("'2017-2-2','2017-5-25'");
        incomVo.setTreeType(request.getParameter("treeType"));
        incomVo.setTreeId(request.getParameter("treeId"));
        incomEntity.setType(request.getParameter("type"));
        incomVo.setIncom(incomEntity);
        incomVo.setConsName(request.getParameter("cons_name"));
        incomVo.setUser(usr);
        incomVo.setPageIndex(Integer.parseInt(pageIndex));
        incomVo.setPageSize(Integer.parseInt(pageSize));
        JSONObject incomList = contractIncom.queryIncomList(incomVo);
        JSONObject  resultObj = new JSONObject();
        resultObj.put("datas",incomList.getJSONArray("datas"));
        JSONObject totalList = contractIncom.querySumIncom(incomVo);
        resultObj.put("total",totalList);
		out.print(Util.null2String(resultObj));

%>



