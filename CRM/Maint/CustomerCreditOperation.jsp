
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<%
String method = Util.null2String(request.getParameter("method"));
String CreditAmount = Util.fromScreen(request.getParameter("CreditAmount"),user.getLanguage());
String CreditTime = Util.fromScreen(request.getParameter("CreditTime"),user.getLanguage());
String Currencyid = Util.fromScreen(request.getParameter("currencytype"),user.getLanguage());
boolean canedit = HrmUserVarify.checkUserRight("CRM_CustomerCreditAdd:Add",user);
if (!canedit) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
 if (method.equals("edit"))
{	RecordSet.executeSql("delete from CRM_CustomerCredit");
	char flag=2;
	RecordSet.executeProc("CRM_CustomerCredit_Insert",CreditAmount+flag+CreditTime+flag+Currencyid);
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/Maint/CustomerCreditInner.jsp");
%>