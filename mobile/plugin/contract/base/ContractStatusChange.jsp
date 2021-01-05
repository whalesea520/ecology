<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="conEntity" class="weaver.contractn.entity.ContractEntity" scope="page" />
<jsp:useBean id="dynaEntity" class="weaver.contractn.entity.DynamicEntity" scope="page" />
<jsp:useBean id="dynamic" class="weaver.contractn.serviceImpl.DynamicServiceImpl" scope="page" />
<jsp:useBean id="contract" class="weaver.contractn.serviceImpl.ContractServiceImpl" scope="page" />
<jsp:useBean id="selectItem" class="weaver.contractn.serviceImpl.SelectItemServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@page import="com.weaver.formmodel.mobile.manager.MobileUserInit"%>
<%  
    User usr = MobileUserInit.getUser(request, response);
    String usrName = usr.getLastname();
    String consId = request.getParameter("dataid");
    String status = request.getParameter("status");
    String type = request.getParameter("type");
    String operate_type = request.getParameter("operate_type");
    String content = request.getParameter("content");
    conEntity.setStatus(status);
    conEntity.setId(consId);
    
    dynaEntity.setModule("cons_info");
    dynaEntity.setDataid(consId);
    dynaEntity.setType(type);
    dynaEntity.setOperateType(operate_type);
    dynaEntity.setContent(usrName+" 更改了"+content);
    String message = contract.update(conEntity);
    dynamic.sava(dynaEntity);
    out.print(message);   

%>



