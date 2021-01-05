
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetR" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%


String para = "";
char flag = 2;
String sqlstr = "select id from CRM_CustomerInfo where deleted<>1 and id not in (select customerid from CRM_ContacterLog_Remind)";
RecordSet.executeSql(sqlstr);
while(RecordSet.next())
{
	para = RecordSet.getString("id");
	para += flag + "1";
	para += flag + "30";	
	para += flag + "0";	
	RecordSetR.executeProc("CRM_ContacterLog_R_Insert",para);
}
out.print("OK!");
%>
