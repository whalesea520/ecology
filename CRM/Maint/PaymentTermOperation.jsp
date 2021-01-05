
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="PaymentTermComInfo" class="weaver.crm.Maint.PaymentTermComInfo" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String id = Util.null2String(request.getParameter("id"));
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_PaymentTerm_Insert",name+flag+desc);

	PaymentTermComInfo.removePaymentTermCache();
}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_PaymentTerm_Update",id+flag+name+flag+desc);

	PaymentTermComInfo.removePaymentTermCache();
}
else if (method.equals("delete"))
{
	RecordSet.executeProc("CRM_PaymentTerm_Delete",id);

	PaymentTermComInfo.removePaymentTermCache();
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/ListPaymentTerm.jsp");
%>