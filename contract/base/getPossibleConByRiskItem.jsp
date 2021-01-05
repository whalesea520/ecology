<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.*"%>
<%@page import="java.net.*"%>
<jsp:useBean id="contract" class="weaver.contractn.serviceImpl.ContractServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    User usr = HrmUserVarify.getUser(request, response);
    int author = usr.getUID();
    String action = request.getParameter("action");
    String riskItem = request.getParameter("riskItem");
    
    
    if("possible".equals(action)){
    	out.print(contract.queryPossibleConByRistItem(riskItem));
    }else if("actual".equals(action)){
    	out.print(contract.queryContractListByRiskItem(riskItem));
    }
    
%>



