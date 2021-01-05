<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProcessingTypeComInfo" class="weaver.proj.Maint.ProcessingTypeComInfo" scope="page" />
<%
String method = request.getParameter("method");
String id = request.getParameter("id");
String type = request.getParameter("type");
String desc = request.getParameter("desc");

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("Prj_ProcessingType_Insert",type+flag+desc);

	ProcessingTypeComInfo.removeProcessingTypeCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("Prj_ProcessingType_Update",id+flag+type+flag+desc);

	ProcessingTypeComInfo.removeProcessingTypeCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("Prj_ProcessingType_Delete",id);

	ProcessingTypeComInfo.removeProcessingTypeCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/proj/Maint/ListProcessingType.jsp");
%>