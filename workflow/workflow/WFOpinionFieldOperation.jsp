<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="WFOpinionManager" class="weaver.workflow.workflow.WFOpinionManager" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

<%
//added by pony on 2006-04-24 for TD4215
	WFOpinionManager.processFields(request);
	//System.out.println("OK.....");
	int workflowid = Util.getIntValue(request.getParameter("workflowid"),0) ;
	String path = "WFOpinionField.jsp?ajax=1&wfid="+workflowid;
	response.sendRedirect(path);
	return;
//added end.
%>