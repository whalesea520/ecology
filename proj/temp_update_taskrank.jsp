
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<%

String sqlstr = " SELECT * FROM Prj_TaskProcess ";
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	sqlstr = " select count(*) as counts from Prj_TaskProcess where isdelete<>'1' and parentid="+RecordSet.getString("id");
	RecordSet2.executeSql(sqlstr);
	RecordSet2.next();
	sqlstr = " update Prj_TaskProcess set childnum='"+RecordSet2.getString("counts")+"' where id="+RecordSet.getString("id");
	RecordSet3.executeSql(sqlstr);
}

sqlstr = " SELECT * FROM Prj_TaskInfo ";
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	sqlstr = " select count(*) as counts from Prj_TaskInfo where isdelete<>'1' and parentid="+RecordSet.getString("id");
	RecordSet2.executeSql(sqlstr);
	RecordSet2.next();
	sqlstr = " update Prj_TaskInfo set childnum='"+RecordSet2.getString("counts")+"' where id="+RecordSet.getString("id");
	RecordSet3.executeSql(sqlstr);
}



%>
<p>ok！</p>