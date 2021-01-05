<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<jsp:useBean id="work" class="weaver.contractn.util.WorkFlowConfig" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
		String mode = request.getParameter("comefrom");
		//String mode = "mode";
		User usr = HrmUserVarify.getUser(request, response);
        out.print(work.queryConTypeInfoOfTree(usr,mode));
%>

