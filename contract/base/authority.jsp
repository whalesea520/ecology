<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="org.json.*"%>
<jsp:useBean id="mode" class="weaver.formmode.view.ModeShareManager" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    User usr = HrmUserVarify.getUser(request, response);
    mode.getShareDetailTableByUser("formmode",usr);
    
    

%>



