<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String method = Util.null2String(request.getParameter("method1"));
String CustomerID = Util.fromScreen(request.getParameter("ForCustomerID"),user.getLanguage());
String ContractId = Util.fromScreen(request.getParameter("ForContractId"),user.getLanguage());
String ExchangeInfo = Util.fromScreen(request.getParameter("ExchangeInfo"),user.getLanguage());
 
String para = "";
char flag=Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;

 if (method.equals("add"))
{	
	para = ContractId;
	para += flag+"";
	para += flag+ExchangeInfo;
	para += flag+""+user.getUID();
	para += flag+currentdate ;
	para += flag+currenttime ;
	
	
	RecordSet.executeProc("CRM_ContractExch_Insert",para);
}
else
{
	response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}
response.sendRedirect("/CRM/data/ContractView.jsp?CustomerID="+CustomerID+"&id="+ContractId);
%>