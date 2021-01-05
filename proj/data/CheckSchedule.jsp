<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%><%
String flag = "0";
String manager = request.getParameter("manager");
String departmentId=ResourceComInfo.getDepartmentID(manager); 
String subCompanyId=DepartmentComInfo.getSubcompanyid1(departmentId);
int subCompanyId1= Util.getIntValue(subCompanyId,0);
String sql = "select * from HrmSchedule where scheduleType='4' and relatedId="+subCompanyId1;
RecordSet.executeSql(sql);
if(RecordSet.getCounts()>0) {
	flag = "1";
}
//System.out.println(sql);
out.println(flag);
%>