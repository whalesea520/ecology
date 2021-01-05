
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.mobile.plugin.ecology.service.WorkflowSignuture" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.mobile.webservices.workflow.soa.RequestPreProcessing"%>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
weaver.file.FileUpload fu = new weaver.file.FileUpload(request);

String requestids = Util.null2String(fu.getParameter("requestids"));

String strJson = RequestPreProcessing.getRequestStatus(user, requestids);
if(!"".equals(strJson)){
	response.setContentType("application/json; charset=UTF-8");
	java.io.PrintWriter writer = response.getWriter();
	writer.write(strJson);
	writer.flush();
	writer.close();
}
%>