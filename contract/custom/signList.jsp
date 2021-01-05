<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.*"%>
<jsp:useBean id="fileService" class="weaver.contractn.serviceImpl.FileServiceImpl" scope="page" />
<jsp:useBean id="fileHandle" class="weaver.contractn.util.FileHandle" scope="page" />
<jsp:useBean id="contract" class="weaver.contractn.serviceImpl.ContractServiceImpl" scope="page" />
<jsp:useBean id="conEntity" class="weaver.contractn.entity.ContractEntity" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
    String username = user.getUsername() ;
    String action = request.getParameter("action");
    String status = request.getParameter("status");
    conEntity.setStatus(status);
    conEntity.setContactor(username);
    if("query".equals(action)){
        out.print(contract.queryContractSignByCustomer(conEntity).toString());
    }else if("add".equals(action)){
        JSONArray array = fileHandle.uploadFile(request).getJSONArray("fileItem");
        fileService.save(array,"seal",null);
    }
	
%>

