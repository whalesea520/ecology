
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo"
	class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="WorkTypeComInfo"
	class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocChangeManager" class="weaver.docs.change.DocChangeManager" scope="page" />
<%
	int usertype = Util.getIntValue(request.getParameter("usertype"));
	int typeid = Util.getIntValue(request.getParameter("typeid"), -1);
	//System.out.println("usertype="+usertype+"  typeid="+typeid);
	ArrayList workflowids = new ArrayList();
	String sql = "";
	sql = "select t1.id from workflow_base t1, workflow_createdoc t2";
	sql += " where t2.status='1' AND t2.flowDocField>0 and t1.id=t2.workflowid and t1.isvalid=1 and t1.workflowtype=" + typeid;
	//4.x版本的安全性检查
	if (DocChangeManager.cversion.equals("4")) {
		sql += " and t1.id in(select t1.id from workflow_base t1,workflow_fieldLable fieldLable,workflow_formField formField, workflow_formdict formDict"; 
		sql += " where fieldLable.formid = formField.formid ";
		sql += " and fieldLable.fieldid = formField.fieldid "; 
		sql += " and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "; 
		sql += " and formField.formid = t1.formid and fieldLable.langurageid = "+user.getLanguage(); 
		sql += " and formDict.fieldHtmlType = '3' and formDict.type = 9 ";
		sql += " group by t1.id) ";
	}
	sql += " and t1.id not in(select workflowid from DocChangeWorkflow) ";
	sql += " order by t1.workflowname ";
	RecordSet.executeSql(sql);
	while (RecordSet.next()) {
		workflowids.add(RecordSet.getString("id"));
	}
%>
<table class="viewform" width='100%'>
<%
 	for (int j = 0; j < workflowids.size(); j++) {
 		String workflowid1 = (String) workflowids.get(j);
 		String workflowname1 = WorkflowComInfo.getWorkflowname(workflowid1);
 		String curtypeid = WorkflowComInfo.getWorkflowtype(workflowid1);
%>
	<tr class="field">
		<td width="5%"></td>
		<td width="95%"><input type="checkbox" name="w<%=typeid%>" value="W<%=workflowid1%>" onclick="checkSub('<%=typeid%>')"><%=workflowname1%></td>
	</tr>
<%
 	}
%>
</table>