<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.mobile.plugin.ecology.service.WorkflowSignuture" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
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
String module = Util.null2String(request.getParameter("module"));
if(Util.getIntValue(workflowId)<=0 || requestId<=0 || userId == 0 || pagesize == 0){
  return;
}
//督办监控对应
//String strJson = WorkflowSignuture.getJsonWorkflowSignuture(workflowId, String.valueOf(requestId), userId, pagesize, endId, fromRequestId);
String strJson;
if(module.equals("-1005") || module.equals("-1004")){
    fromRequestId = -99999;
}
strJson = WorkflowSignuture.getJsonWorkflowSignuture(workflowId, String.valueOf(requestId), userId, pagesize, endId, fromRequestId);
if(!"".equals(strJson)){
	JSONObject jo = JSONObject.fromObject(strJson);
	out.println(jo);
}
%>