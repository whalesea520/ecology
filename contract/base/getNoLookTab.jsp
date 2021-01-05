<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.*"%>
<%@page import="java.net.*"%>
<jsp:useBean id="sto" class="weaver.contractn.entity.DynamicEntity" scope="page" />
<jsp:useBean id="dynamic" class="weaver.contractn.serviceImpl.DynamicServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    User usr = HrmUserVarify.getUser(request, response);
    int author = usr.getUID();
    String consId = request.getParameter("consId");
    
    sto.setUsrId(author);
    sto.setDataid(consId);
    out.print(dynamic.queryNoLookTabByConsId(sto));
    
%>



