<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="cust" class="weaver.contractn.serviceImpl.CustomerServiceImpl" scope="page" />
<jsp:useBean id="custVo" class="weaver.contractn.entity.CustomerVo" scope="page" />
<jsp:useBean id="custEntity" class="weaver.contractn.entity.CustomerEntity" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
    String name = Util.null2String(request.getParameter("name"));
	String treeId = Util.null2String(request.getParameter("treeId"));
	String treeType = Util.null2String(request.getParameter("treeType"));
	custVo.setTreeId(treeId);
	custVo.setTreeType(treeType);
	
	custEntity.setName(name);
	custVo.setCustomer(custEntity);
	
	out.print(cust.queryCusomerInfoList(custVo));
%>

