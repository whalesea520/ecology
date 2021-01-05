<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Record" class="weaver.conn.RecordSet" scope="page" />


<%

String sql="select id from DocSecCategory";
RecordSet.executeSql(sql);
while(RecordSet.next())
	{
int id=0;
id=RecordSet.getInt("id");
out.print("id:"+id+" ");
Record.executeProc("DocUserCategory_InsertByCategory",id+"");
out.print(Record.executeProc("DocUserCategory_InsertByCategory",id+"")+";");

}

//response.sendRedirect("DocUpgrade.jsp?");
  		//return ;   
	
%>