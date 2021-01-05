<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.mobile.webservices.workflow.WorkflowServiceImpl"%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if (user == null) return;
	
	String requestid = Util.null2String(request.getParameter("requestid"));
	WorkflowServiceImpl wf = new WorkflowServiceImpl();
    out.println(wf.getRightMenu(requestid, user));
%>
