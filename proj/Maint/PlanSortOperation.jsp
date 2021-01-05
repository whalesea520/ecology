<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />
<%
String method = request.getParameter("method");
String id = request.getParameter("id");
String type = request.getParameter("type");
String desc = request.getParameter("desc");

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("Prj_PlanSort_Insert",type+flag+desc);

	PlanSortComInfo.removePlanSortCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("Prj_PlanSort_Update",id+flag+type+flag+desc);

	PlanSortComInfo.removePlanSortCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("Prj_PlanSort_Delete",id);

	PlanSortComInfo.removePlanSortCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/proj/Maint/ListPlanSort.jsp");
%>