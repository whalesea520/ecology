<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="hrmTree" class="weaver.contractn.serviceImpl.TreeOperateServiceImpl" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	//查询人员树
	User usr = HrmUserVarify.getUser(request, response);
    int usrId = usr.getUID();
	out.print(hrmTree.queryHrmTreeInfo(usrId));
	
%>

