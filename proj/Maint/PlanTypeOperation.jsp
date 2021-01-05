<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PlanTypeComInfo" class="weaver.proj.Maint.PlanTypeComInfo" scope="page" />
<%
String method = request.getParameter("method");
String id = request.getParameter("id");
String type = request.getParameter("type");
String desc = request.getParameter("desc");

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("Prj_PlanType_Insert",type+flag+desc);

	PlanTypeComInfo.removePlanTypeCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("Prj_PlanType_Update",id+flag+type+flag+desc);

	PlanTypeComInfo.removePlanTypeCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("Prj_PlanType_Delete",id);

	PlanTypeComInfo.removePlanTypeCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/proj/Maint/ListPlanType.jsp");
%>