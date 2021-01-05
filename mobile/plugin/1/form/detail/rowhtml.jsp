
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.mobile.webservices.workflow.WorkflowServiceUtil" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.workflow.request.RequestPreAddinoperateManager" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Hashtable" %>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>
<% 
//User user = HrmUserVarify.getUser (request , response) ;

String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String groupId = request.getParameter("groupId");
String derecorderindex =  request.getParameter("derecorderindex");
String newRowNum = request.getParameter("newRowNum");
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
	RequestPreAddinoperateManager requestPreAddM = new RequestPreAddinoperateManager();
	requestPreAddM.setCreater(user.getUID());
	requestPreAddM.setOptor(user.getUID());
	requestPreAddM.setWorkflowid(Util.getIntValue(workflowid));
	requestPreAddM.setNodeid(Util.getIntValue(nodeId));
	Hashtable getPreAddRule_hs = requestPreAddM.getPreAddRule();
	String html = WorkflowServiceUtil.getAddJsString(workflowid,nodeId,user,derecorderindexInt,groupIdInt,rowIndexInt,isEditsBoolean,isdisplayBoolean,tableOrderIdInt,newRowNum,getPreAddRule_hs);
	out.println(html);
}

%>

