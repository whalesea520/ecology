<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="WFOpinionNodeManager" class="weaver.workflow.workflow.WFOpinionNodeManager" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
//added by pony on 2006-04-24 for TD4215
	WFOpinionNodeManager.updateNodeFields(request);
	//System.out.println("OK.....");
	int workflowid = Util.getIntValue(request.getParameter("workflowid"),0) ;
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0) ;
	String path = "AddOpinionField.jsp?ajax=1&wfid="+workflowid+"&nodeid="+nodeid;
	response.sendRedirect(path);
	return;
//added end.
%>