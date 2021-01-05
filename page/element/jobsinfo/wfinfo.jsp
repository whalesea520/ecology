<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.mobile.webservices.workflow.*" %>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String userid = request.getParameter("userid");
WorkflowServiceImpl wsi = new WorkflowServiceImpl();

int count=wsi.getToDoWorkflowRequestCount(Util.getIntValue(userid),true,new String[]{});
out.clearBuffer();
out.print(count);
%>
