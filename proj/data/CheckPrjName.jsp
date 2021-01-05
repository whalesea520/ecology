<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%><%
String flag = "0";
String prjName = request.getParameter("prjName");
String prjtypeid = request.getParameter("prjtypeid");
String type=request.getParameter("type");
String sql = "";
if(!"add".equals(type)){
	String projectid = request.getParameter("projectid");
	sql = "select * from Prj_ProjectInfo where name = '"+prjName+"' and prjtype='"+prjtypeid+"' and id != '"+projectid+"'";
}else{
	sql = "select * from Prj_ProjectInfo where name = '"+prjName+"' and prjtype='"+prjtypeid+"'";
}
RecordSet.executeSql(sql);
if(RecordSet.getCounts()>0) {
	flag = "1";
}
out.println(flag);
%>