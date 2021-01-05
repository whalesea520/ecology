<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String method = request.getParameter("method");

String time = Util.fromScreen(request.getParameter("time"),user.getLanguage());
String spannum = Util.fromScreen(request.getParameter("spannum"),user.getLanguage());

if (method.equals("add"))
{
	char flag=2;
	RecordSet.executeProc("CRM_SellTimespan_insert",time+flag+spannum);

}
else if (method.equals("edit"))
{
	char flag=2;
	RecordSet.executeProc("CRM_SellTimespan_update",time+flag+spannum);

}



out.println("<script>parent.getParentWindow(window).closeWin();</script>");
%>