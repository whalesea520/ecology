<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.service.CustomPageService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ReportComInfo" class="weaver.workflow.report.ReportComInfo" scope="page" />
<jsp:useBean id="FormInfoService" class="weaver.formmode.service.FormInfoService" scope="page" />
<%
out.clear();
User user = HrmUserVarify.getUser (request , response) ;
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String modeid = Util.null2String(request.getParameter("modeid"));
String formid = Util.null2String(request.getParameter("formid"));
String action = Util.null2String(request.getParameter("action"));
String operation = Util.null2String(request.getParameter("operation"));
CustomPageService customPageService = new CustomPageService();
if("saveorupdate".equals(operation)) {
	FormInfoService.saveOrUpdateImportTemplate(request,user);
	response.getWriter().println("<script type=\"text/javascript\">parent.onCloseAndRefresh();</script>");
}else if("clear".equals(operation)) {
	FormInfoService.saveOrUpdateImportTemplate(request,user);
	response.getWriter().println("<script type=\"text/javascript\">parent.onCloseAndRefresh();</script>");
}
%>