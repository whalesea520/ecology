
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowServiceImpl" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="net.sf.json.*"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

WorkflowServiceImpl  workflowServiceImpl=new WorkflowServiceImpl();
String workflowId = Util.null2String(request.getParameter("workflowId"));
int requestId = Util.getIntValue(request.getParameter("requestId"));
int userId = user.getUID();
int pagesize = Util.getIntValue(request.getParameter("pagesize"), 0);
int endId = Util.getIntValue(request.getParameter("pageindex"), 0);
int fromRequestId = Util.getIntValue(request.getParameter("fromRequestId"), 0);
if(Util.getIntValue(workflowId)<=0 || requestId<=0){
  return;
}
String strJson = workflowServiceImpl.getWorkflowResource(workflowId, String.valueOf(requestId), userId, pagesize, endId);
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