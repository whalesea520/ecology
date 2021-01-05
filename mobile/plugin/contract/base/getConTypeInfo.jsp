<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="work" class="weaver.contractn.util.WorkFlowConfig" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
		User usr = HrmUserVarify.getUser(request, response);
		int usrId = usr.getUID();
        out.print(work.queryConTypeInfoOfTree(usrId));
%>

