
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.mobile.plugin.ecology.service.WorkflowSignuture" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="net.sf.json.*"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String workflowId = Util.null2String(request.getParameter("workflowId"));
int requestId = Util.getIntValue(request.getParameter("requestId"));
int userId = Util.getIntValue(request.getParameter("userid"), 0);
int pagesize = Util.getIntValue(request.getParameter("pagesize"), 0);
int endId = Util.getIntValue(request.getParameter("pageindex"), 0);
int fromRequestId = Util.getIntValue(request.getParameter("fromRequestId"), 0);
int imageWidth = Util.getIntValue(request.getParameter("imageWidth"),0);
int imageHeight = Util.getIntValue(request.getParameter("imageHeight"),0);
//对应督办和监控
int module = Util.getIntValue(request.getParameter("module"),0);

if(Util.getIntValue(workflowId)<=0 || requestId<=0 || userId == 0 || pagesize == 0){
  return;
}
if(fromRequestId <= 0 && (module == -1004 || module == -1005)){
    fromRequestId = -99999;
}
if(fromRequestId==requestId){
	fromRequestId = 0;
}
String strworkflowid="";
RecordSet  rs=new RecordSet();
rs.executeQuery(" select workflowid from workflow_currentoperator where requestid=? and userid=? ",requestId,userId);
if(rs.next()){
	 strworkflowid = Util.null2String(rs.getString("workflowid"));
}

if(!(workflowId.equals(strworkflowid))){
	return;
}
String strJson = WorkflowSignuture.getJsonWorkflowSignuture(workflowId, String.valueOf(requestId), userId, pagesize, endId, fromRequestId, true,imageWidth,imageHeight);
if(!"".equals(strJson)){
	JSONObject jo = JSONObject.fromObject(strJson);
	out.println(jo);
	/*response.setContentType("application/json; charset=UTF-8");
	java.io.PrintWriter writer = response.getWriter();
	writer.write(strJson);
	writer.flush();
	writer.close();*/
}
%>