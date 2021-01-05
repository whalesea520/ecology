
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.conn.RecordSet" %>


<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) return;
String userid = request.getParameter("userid");
String sql ="";
RecordSet rs  = new RecordSet();

if(rs.getDBType().equalsIgnoreCase("oracle")){
	sql = " select count(*) as num from WorkPlan where status = 0 AND deleted <> 1  AND createrType = '1' AND ','||resourceID||',' LIKE '%,"+userid+",%' AND ( enddate IS NOT NULL AND  enddate ||' '|| endtime >= '"+TimeUtil.getCurrentTimeString()+"')";
}else{
	sql = " select count(*) as num from WorkPlan where status = 0 AND deleted <> 1  AND createrType = '1' AND ','+resourceID+',' LIKE '%,"+userid+",%' AND (enddate <> '' AND enddate IS NOT NULL AND  enddate +' '+ endtime >= '"+TimeUtil.getCurrentTimeString()+"')";
}
rs.execute(sql);
rs.next();
out.clearBuffer();
out.print(rs.getInt("num"));


%>

