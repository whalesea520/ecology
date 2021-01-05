<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />

<%
User user = HrmUserVarify.getUser(request, response);
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>

    <%
        int fieldId = Util.getIntValue(request.getParameter("fieldId"),-1);
		int docMouldID=Util.getIntValue(request.getParameter("docMouldID"),-1);
		int workflowId = Util.getIntValue(request.getParameter("wfid"),-1);
		String option =Util.null2String(request.getParameter("option"));
		
		User user = HrmUserVarify.getUser (request , response) ;
		String isIE = (String)session.getAttribute("browser_isie");
		if (isIE == null || "".equals(isIE)) {
			isIE = "true";
			session.setAttribute("browser_isie", "true");
		}
        String formID = WorkflowComInfo.getFormId(""+workflowId);
        String isbill = WorkflowComInfo.getIsBill(""+workflowId);
		if(option.equals("viewMould")){
		RecordSet.executeSql("update workflow_docshow set isDefault='0' WHERE flowId = " + workflowId + " AND selectItemId = -1 "); 
		RecordSet.executeSql("update workflow_docshow set isDefault='1' WHERE flowId = " + workflowId + " AND selectItemId = -1 and docMouldID=" + docMouldID); 
		
		}else{
		RecordSet.executeSql("update WorkFlow_DocShowEdit set isDefault='0' WHERE flowId = " + workflowId + " AND selectItemId = -1 "); 
		RecordSet.executeSql("update WorkFlow_DocShowEdit set isDefault='1' WHERE flowId = " + workflowId + " AND selectItemId = -1 and docMouldID=" + docMouldID); 
		
		
		}
		
		
	%>
	
	
