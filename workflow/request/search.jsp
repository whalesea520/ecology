
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
String q = request.getParameter("q");
if(q.equals("")) return;
//RecordSet.executeSql("select * from HrmResource where lastname like '%"+q+"%' or workcode like '%"+q+"%'");
RecordSet.executeSql("select * from HrmResource where lastname like '%"+q+"%'");
while(RecordSet.next()){
	String id = RecordSet.getString("id");
	String lastname = RecordSet.getString("lastname");
	String departmentid = RecordSet.getString("departmentid");
	String departmentname = DepartmentComInfo.getDepartmentname(departmentid);
	String workcode = RecordSet.getString("workcode");
	//out.println(workcode+"  "+lastname+"|"+id);
	out.println(lastname+"/"+departmentname+"|"+id);
}
%>