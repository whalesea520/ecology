
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<%
String sqlstr = "";
sqlstr = " update CptCapitalAssortment set capitalcount='0' ";
RecordSet2.executeSql(sqlstr);

sqlstr = " select * from CptCapital where isdata = '1' ";
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	sqlstr = " update CptCapitalAssortment set capitalcount=capitalcount+1 where id="+RecordSet.getString("capitalgroupid");
	RecordSet2.executeSql(sqlstr);
	out.print(sqlstr);
}

%>
<p>ok！</p>