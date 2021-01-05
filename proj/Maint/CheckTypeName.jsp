<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%><%
String flag = "0";
String typeName = request.getParameter("typeName");
String type=request.getParameter("type");
String sql = "";
if(!"add".equals(type)){
	String projecttypeid = request.getParameter("projecttypeid");
	sql = "select * from Prj_ProjectType where fullname = '"+typeName+"' and id != '"+projecttypeid+"'";
}else{
	sql = "select * from Prj_ProjectType where fullname = '"+typeName+"'";
}
RecordSet.executeSql(sql);
if(RecordSet.getCounts()>0) {
	flag = "1";
}
out.println(flag);
%>