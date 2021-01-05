
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="java.net.URLDecoder"%>

<%

User user = HrmUserVarify.getUser(request, response) ;
if (user == null ) return ;

if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String targetwfid = Util.null2String(request.getParameter("targetwfid"));
String versionDesc = URLDecoder.decode(Util.null2String(request.getParameter("versionDesc")), "UTF-8");

//System.out.println("targetwfid=" + targetwfid);
//System.out.println("versionDesc=" + versionDesc);

WorkflowVersion wfversion = new WorkflowVersion(targetwfid);
int newwfid = wfversion.saveAsVersion(user, versionDesc, request.getRemoteAddr());
response.setCharacterEncoding("utf-8");
response.getWriter().write(newwfid + "");	
%>