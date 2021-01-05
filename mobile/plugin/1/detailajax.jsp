
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.mobile.webservices.workflow.WorkflowServiceUtil" %>
<%@ page import="weaver.hrm.*" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<% 
User user = HrmUserVarify.getUser (request , response) ;
String groupId = request.getParameter("groupId");
String derecorderindex =  request.getParameter("derecorderindex");
//System.out.println("derecorderindex:"+derecorderindex);
String workflowid =  request.getParameter("workflowid");
String nodeId =  request.getParameter("nodeId");
String rowIndex = request.getParameter("rowIndex");
String isEdits = request.getParameter("isEdits");
String tableOrderId = request.getParameter("tableOrderId");
if(!"".equals(groupId)&&groupId != null){
	int groupIdInt = Integer.parseInt(groupId);
	if("".equals(derecorderindex) || null== derecorderindex){
		derecorderindex = "0";
	}
	if("".equals(rowIndex)|| null == rowIndex){
		rowIndex = "0";
	}
    if("".equals(tableOrderId)||null == tableOrderId){
		 tableOrderId = "0";
	}
	int rowIndexInt = Integer.parseInt(rowIndex);
	int derecorderindexInt = Integer.parseInt(derecorderindex);
	boolean isEditsBoolean = Boolean.parseBoolean(isEdits);
	boolean isdisplayBoolean = false;
	int  tableOrderIdInt  = Integer.parseInt(tableOrderId);
	String html = WorkflowServiceUtil.getAddJsString(workflowid,nodeId,user,derecorderindexInt,groupIdInt,rowIndexInt,isEditsBoolean,isdisplayBoolean,tableOrderIdInt);
	out.println(html);
}

%>

