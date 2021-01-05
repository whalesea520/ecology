<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.net.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.join.news.*" %>
<jsp:useBean id="_rs_comm" class="weaver.conn.RecordSet" scope="page" />

 <%
	request.setCharacterEncoding("utf-8");    
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%

String title="";
int extendloginid=0;
String sqlLoginTemplate = "SELECT loginTemplateTitle FROM SystemLoginTemplate WHERE isCurrent='1'";	
_rs_comm.executeSql(sqlLoginTemplate);
if(_rs_comm.next()){
	title = _rs_comm.getString("loginTemplateTitle");
	extendloginid = _rs_comm.getInt("extendloginid");
}



NewsUtil NewsUtil=new NewsUtil(request.getHeader("Host"));
%>