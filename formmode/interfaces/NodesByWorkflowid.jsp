
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String workflowid = request.getParameter("workflowid");
	PrintWriter writer = response.getWriter();
	JSONArray array = new JSONArray();
	rs.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= "+workflowid+"  order by a.nodeorder,a.nodeType,a.nodeId  ");
	while(rs.next()) {
		int temptriggerNodeId = rs.getInt("triggerNodeId");
		String triggerNodeName = Util.null2String(rs.getString("triggerNodeName"));
		JSONObject object2 = new JSONObject();
		object2.put("name",triggerNodeName);
		object2.put("value",temptriggerNodeId);
		array.add(object2);
	}
	writer.print(array.toString());
	return;
%>