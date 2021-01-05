
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));

String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
int bywhat = Util.getIntValue(request.getParameter("bywhat"),4);
String currentdate =  Util.null2String(request.getParameter("currentdate"));
String movedate = Util.null2String(request.getParameter("movedate"));

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String cancelDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String cancelTime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16);
if(operation.equals("cancel")){
	if(!id.equals("")){
		String sql = "update CarUseApprove set cancelDate='"+cancelDate+"',cancelTime='"+cancelTime+"',cancel='1' where id="+id;
		//System.out.println("sql:"+sql);
		RecordSet.executeSql(sql);
	}
	response.sendRedirect("/car/CarUseInfo.jsp?bywhat="+bywhat+"&currentdate="+currentdate);
}
%>