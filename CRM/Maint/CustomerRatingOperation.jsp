
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CustomerRatingComInfo" class="weaver.crm.Maint.CustomerRatingComInfo" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String workflow11 = Util.null2String(request.getParameter("workflow11"));
String workflow12 = Util.null2String(request.getParameter("workflow12"));
String workflow21 = Util.null2String(request.getParameter("workflow21"));
String workflow22 = Util.null2String(request.getParameter("workflow22"));
String workflow31 = Util.null2String(request.getParameter("workflow31"));
String workflow32 = Util.null2String(request.getParameter("workflow32"));
String canupgrade = Util.null2String(request.getParameter("canupgrade"));

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_CustomerRating_Insert",name+flag+desc+flag+workflow11+flag+workflow12+flag+workflow21+flag+workflow22+flag+workflow31+flag+workflow32+flag+canupgrade);

	CustomerRatingComInfo.removeCustomerRatingCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_CustomerRating_Update",id+flag+name+flag+desc+flag+workflow11+flag+workflow12+flag+workflow21+flag+workflow22+flag+workflow31+flag+workflow32+flag+canupgrade);

	CustomerRatingComInfo.removeCustomerRatingCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("CRM_CustomerRating_Delete",id);

	CustomerRatingComInfo.removeCustomerRatingCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/ListCustomerRating.jsp");
%>