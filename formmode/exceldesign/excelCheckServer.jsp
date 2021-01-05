<%@ page import="weaver.hrm.*" %><%@ page import="weaver.general.Util" %><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /><%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%><%
String flag = "0";
try{
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
	if(user == null)  flag = "1";
	if(flag.equals("0")) {
		RecordSet.executeSql("select count(1) from License");
		if(RecordSet.getCounts()==0) {
			flag = "2";
		}
	}
	int userid = Util.getIntValue(request.getParameter("userid"), -1);
	if(userid!=user.getUID()) flag = "3";

}catch(Exception e){}
out.print(flag);
%>