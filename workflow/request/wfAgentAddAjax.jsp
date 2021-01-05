
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
<%
	int usertype = Util.getIntValue(request.getParameter("usertype"));
	int typeid = Util.getIntValue(request.getParameter("typeid"), -1);
	//System.out.println("usertype="+usertype+"  typeid="+typeid);
	ArrayList workflowids = new ArrayList();
	String sql = "";
	if (usertype == 0) {
		sql = "select * from workflow_base where isvalid=1 and workflowtype=" + typeid + " order by workflowname ";
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			workflowids.add(RecordSet.getString("id"));
		}
	} else if (usertype == 1) {
		//客户用户只能代理“外部访问者支持”类型的流程
		sql = "select id from workflow_base where isvalid=1 and workflowtype=29 order by workflowname";
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			workflowids.add(RecordSet.getString("id"));
		}
	}
%>
<table class="viewform">
<%
 	for (int j = 0; j < workflowids.size(); j++) {
 		String workflowid1 = (String) workflowids.get(j);
 		String workflowname1 = WorkflowComInfo.getWorkflowname(workflowid1);
 		String curtypeid = WorkflowComInfo.getWorkflowtype(workflowid1);
%>
	<tr class="field">
		<td width="20%"></td>
		<td><input type="checkbox" name="w<%=typeid%>" value="W<%=workflowid1%>" onclick="checkSub('<%=typeid%>')" checked><%=workflowname1%></td>
<%
 	}
%>
</table>