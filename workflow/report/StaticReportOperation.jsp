<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!--jsp:useBean id="StaticReportComInfo" class="weaver.workflow.report.StaticReportComInfo" scope="page" / !-->
<%
String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;

if(operation.equals("reportadd")){
  	String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
	String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
	String pagename = Util.fromScreen(request.getParameter("pagename"),user.getLanguage());
	String module = Util.fromScreen(request.getParameter("module"),user.getLanguage()); 

	String para = name + separator + description + separator + pagename + separator + module ; 
	RecordSet.executeProc("Workflow_StaticReport_Insert",para);
 }
 if(operation.equals("reportedit")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
	String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
	String pagename = Util.fromScreen(request.getParameter("pagename"),user.getLanguage());
	String module = Util.fromScreen(request.getParameter("module"),user.getLanguage());  

	String para = ""+id + separator + name + separator + description + separator + pagename + separator + module ;
	RecordSet.executeProc("Workflow_StaticReport_Update",para);
 }
 if(operation.equals("reportdelete")){
  	int id = Util.getIntValue(request.getParameter("id"));
	String para = ""+id;	
    RecordSet.executeProc("Workflow_StaticReport_Delete",para);    
 }
 //StaticReportComInfo.removeStaticReportCache() ;
 response.sendRedirect("StaticReportManage.jsp");
%>